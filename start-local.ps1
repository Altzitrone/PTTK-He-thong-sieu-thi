param(
    [switch]$CreateWorkbenchAccount,
    [switch]$GrantWorkbenchOrderAccess,
    [switch]$UpdateItemDescriptions,
    [switch]$UpdateDemoOrderCustomers,
    [switch]$UpdateDeliveryWorkflow
)

$ErrorActionPreference = 'Stop'
$demo = Join-Path $PSScriptRoot 'target/local-demo'
$mysql = Join-Path $demo 'mysql-8.4.13-winx64'
$tomcat = Join-Path $demo 'apache-tomcat-9.0.123'
$data = Join-Path $demo 'data'
$war = Join-Path $PSScriptRoot 'target/PTTKWeb.war'
$server = Join-Path $mysql 'bin/mysqld.exe'
$bootstrap = Join-Path $tomcat 'bin/bootstrap.jar'
$java = (Get-Command java.exe).Source

foreach ($path in @((Join-Path $data 'mysql'), $server, $bootstrap, $war)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing local demo file: $path" }
}

$listeners = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners()
foreach ($port in @(8080, 13306)) {
    if ($port -in $listeners.Port) { throw "Port $port is already in use. If PTTKWeb is running, open http://127.0.0.1:8080/PTTKWeb/login." }
}

# The previous demo password lived only in the Tomcat process.
$password = [guid]::NewGuid().ToString('N')
$initFile = Join-Path $demo "mysql-start-$([guid]::NewGuid().ToString('N')).sql"
$db = $null
$web = $null
$dbLog = Join-Path $demo 'mysql.err'
try {
    $initStatements = @("ALTER USER 'supermarket_demo'@'127.0.0.1' IDENTIFIED BY '$password';")
    if ($CreateWorkbenchAccount) {
        $workbenchPassword = [guid]::NewGuid().ToString('N').Substring(0, 20) + 'Aa1!'
        $initStatements += "CREATE USER 'workbench_pttk'@'127.0.0.1' IDENTIFIED BY '$workbenchPassword';"
        $initStatements += "GRANT SELECT, INSERT ON supermarket6.tblItem6 TO 'workbench_pttk'@'127.0.0.1';"
    }
    if ($GrantWorkbenchOrderAccess) {
        $initStatements += "GRANT SELECT, INSERT ON supermarket6.tblOnlineOrder6 TO 'workbench_pttk'@'127.0.0.1';"
        $initStatements += "GRANT SELECT, INSERT ON supermarket6.tblOrderDetail6 TO 'workbench_pttk'@'127.0.0.1';"
        $initStatements += "GRANT SELECT ON supermarket6.tblCustomer6 TO 'workbench_pttk'@'127.0.0.1';"
        $initStatements += "GRANT UPDATE (stockQuantity) ON supermarket6.tblItem6 TO 'workbench_pttk'@'127.0.0.1';"
    }
    if ($UpdateDeliveryWorkflow) {
        $initStatements += Get-Content (Join-Path $PSScriptRoot 'database/upgrade-order-delivery.sql') -Encoding UTF8
    }
    [IO.File]::WriteAllLines($initFile, [string[]]$initStatements, [Text.UTF8Encoding]::new($false))
    $db = Start-Process -FilePath $server -ArgumentList @('--no-defaults', "--basedir=`"$mysql`"",
        "--datadir=`"$data`"", "--init-file=`"$initFile`"", '--bind-address=127.0.0.1', '--port=13306',
        '--mysqlx=OFF', '--console') -WindowStyle Hidden -PassThru -RedirectStandardOutput "$demo/mysql.out" -RedirectStandardError $dbLog
    $ready = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if ($db.HasExited) { break }
        if (Select-String -LiteralPath $dbLog -SimpleMatch 'ready for connections' -Quiet) {
            $ready = $true
            break
        }
        Start-Sleep -Seconds 1
    }
    if (-not $ready) { throw "MySQL failed to start. See $dbLog." }

    $env:SUPERMARKET_DB_URL = 'jdbc:mysql://127.0.0.1:13306/supermarket6'
    $env:SUPERMARKET_DB_USER = 'supermarket_demo'
    $env:SUPERMARKET_DB_PASSWORD = $password
    $demoUpdates = @()
    if ($UpdateItemDescriptions) { $demoUpdates += 'database/update-item-descriptions.sql' }
    if ($UpdateDemoOrderCustomers) { $demoUpdates += 'database/update-demo-order-customers.sql' }
    foreach ($demoUpdate in $demoUpdates) {
        $client = Join-Path $mysql 'bin/mysql.exe'
        $previousClientPassword = $env:MYSQL_PWD
        try {
            $env:MYSQL_PWD = $password
            $OutputEncoding = [Text.UTF8Encoding]::new($false)
            Get-Content (Join-Path $PSScriptRoot $demoUpdate) -Raw -Encoding UTF8 |
                & $client --no-defaults --protocol=TCP -h 127.0.0.1 -P 13306 -u supermarket_demo --default-character-set=utf8mb4 --batch
            if ($LASTEXITCODE -ne 0) { throw "Could not apply $demoUpdate." }
        } finally {
            $env:MYSQL_PWD = $previousClientPassword
        }
    }
    Copy-Item -LiteralPath $war -Destination (Join-Path $tomcat 'webapps/PTTKWeb.war') -Force
    $web = Start-Process -FilePath $java -ArgumentList @("-Dcatalina.home=`"$tomcat`"",
        "-Dcatalina.base=`"$tomcat`"", '-cp', "`"$bootstrap;$tomcat/bin/tomcat-juli.jar`"",
        'org.apache.catalina.startup.Bootstrap', 'start') -WindowStyle Hidden -PassThru -RedirectStandardOutput "$demo/tomcat.out" -RedirectStandardError "$demo/tomcat.err"
    $url = 'http://127.0.0.1:8080/PTTKWeb/login'
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if ($web.HasExited) { break }
        $status = curl.exe --noproxy '*' --silent --max-time 2 --output NUL --write-out '%{http_code}' $url
        if ($LASTEXITCODE -eq 0 -and $status -eq '200') {
            Write-Output "PTTKWeb is running at $url"
            if ($CreateWorkbenchAccount) {
                $client = Join-Path $mysql 'bin/mysql.exe'
                $previousClientPassword = $env:MYSQL_PWD
                try {
                    $env:MYSQL_PWD = $workbenchPassword
                    & $client --no-defaults --protocol=TCP -h 127.0.0.1 -P 13306 -u workbench_pttk -D supermarket6 -N -e 'SELECT COUNT(*) FROM tblItem6' | Out-Null
                    if ($LASTEXITCODE -ne 0) { throw 'Could not verify the Workbench account.' }
                } finally {
                    $env:MYSQL_PWD = $previousClientPassword
                }
                Write-Output "Workbench password: $workbenchPassword"
            }
            return
        }
        Start-Sleep -Seconds 1
    }
    throw "Tomcat failed to serve the login page. See $demo/tomcat.err."
} catch {
    if ($web -and -not $web.HasExited) { Stop-Process -Id $web.Id }
    if ($db -and -not $db.HasExited) { Stop-Process -Id $db.Id }
    throw
} finally {
    if (Test-Path -LiteralPath $initFile) { Remove-Item -LiteralPath $initFile }
    Remove-Item Env:SUPERMARKET_DB_PASSWORD -ErrorAction SilentlyContinue
}
