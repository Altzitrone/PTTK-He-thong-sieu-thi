package model;

public class Staff6 extends Member6 {
    private String workShift;

    public Staff6() {
    }

    public Staff6(int id, String fullName, String phoneNumber, String workShift) {
        super(id, fullName, phoneNumber);
        this.workShift = workShift;
    }

    public String getWorkShift() {
        return workShift;
    }

    public void setWorkShift(String workShift) {
        this.workShift = workShift;
    }
}
