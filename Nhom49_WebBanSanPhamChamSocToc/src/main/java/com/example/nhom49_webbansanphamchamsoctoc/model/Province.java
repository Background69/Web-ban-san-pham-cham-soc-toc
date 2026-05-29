package com.example.nhom49_webbansanphamchamsoctoc.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

public class Province implements Serializable {

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

    @SerializedName("Districts")
    private List<District> districts;

    public Province() {
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

    public List<District> getDistricts() {
        return districts;
    }

    public void setDistricts(List<District> districts) {
        this.districts = districts;
    }
}
