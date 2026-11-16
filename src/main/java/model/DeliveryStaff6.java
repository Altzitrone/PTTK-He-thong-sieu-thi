package model;

public class DeliveryStaff6 extends Staff6 {
    public static final String AVAILABLE = "Đang rảnh";
    public static final String BUSY = "Đang giao";

    private String workStatus;

    public DeliveryStaff6() {
    }

    public DeliveryStaff6(int id, String fullName, String phoneNumber, String workShift, String workStatus) {
        super(id, fullName, phoneNumber, workShift);
        this.workStatus = workStatus;
    }

    public String getWorkStatus() {
        return workStatus;
    }

    public void setWorkStatus(String workStatus) {
        this.workStatus = workStatus;
    }
}
