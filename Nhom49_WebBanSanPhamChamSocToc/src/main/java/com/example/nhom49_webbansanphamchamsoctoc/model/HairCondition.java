package com.example.nhom49_webbansanphamchamsoctoc.model;

/**
 * Model HairCondition - Bảng hair_conditions trong database
 * Quản lý các tình trạng tóc (Khô xơ, Hư tổn, Gàu, Rụng tóc...)
 */
public class HairCondition {
    private int conditionId;
    private String conditionName;
    private String conditionSlug;

    // Constructors
    public HairCondition() {
    }

    // Getters and Setters
    public int getConditionId() {
        return conditionId;
    }

    public void setConditionId(int conditionId) {
        this.conditionId = conditionId;
    }

    public String getConditionName() {
        return conditionName;
    }

    public void setConditionName(String conditionName) {
        this.conditionName = conditionName;
    }

    public String getConditionSlug() {
        return conditionSlug;
    }

    public void setConditionSlug(String conditionSlug) {
        this.conditionSlug = conditionSlug;
    }

}
