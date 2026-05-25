package com.example.nhom49_webbansanphamchamsoctoc.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;


public class Ward implements Serializable {

    @SerializedName("Code")
    private String code;

    @SerializedName("Name")
    private String name;

    @SerializedName("FullName")
    private String fullName;

    @SerializedName("FullNameEn")
    private String fullNameEn;

    @SerializedName("CodeName")
    private String codeName;

    @SerializedName("DistrictCode")
    private String districtCode;

    public Ward() {
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFullNameEn() {
        return fullNameEn;
    }

    public void setFullNameEn(String fullNameEn) {
        this.fullNameEn = fullNameEn;
    }

    public String getCodeName() {
        return codeName;
    }

    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }

    public String getDistrictCode() {
        return districtCode;
    }

    public void setDistrictCode(String districtCode) {
        this.districtCode = districtCode;
    }
}
