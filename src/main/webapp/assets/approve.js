const approvalForm = document.getElementById('approve-form');
const approveButton = document.getElementById('approve-button');

function updateApprovalButton() {
    approveButton.disabled = approvalForm.querySelector('input[name="deliveryStaffId"]:checked') === null;
}

approvalForm.addEventListener('change', updateApprovalButton);
window.addEventListener('pageshow', updateApprovalButton);
updateApprovalButton();
