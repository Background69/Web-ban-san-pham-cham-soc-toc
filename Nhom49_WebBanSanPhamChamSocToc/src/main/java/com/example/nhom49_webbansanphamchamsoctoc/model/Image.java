package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;

public class Image implements Serializable {
    private int id;
    private String title;
    private String imageUrl;

    public Image() {
    }

    public Image(int id, String title, String imageUrl) {
        this.id = id;
        this.title = title;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String url) {
        this.imageUrl = url;
    }
}
