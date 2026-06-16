package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ImageDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Image;

import java.util.List;
public class ImageService {
    private final ImageDAO imageDAO;

    public ImageService(ImageDAO imageDAO) {
        this.imageDAO = imageDAO;
    }

    public Image save(Image image) {
        return imageDAO.save(image);
    }

    public Image findByTitle(String title) {
        return imageDAO.findByTitle(title);
    }

    public List<Image> findHomeBanners() {
        return imageDAO.findHomeBanners();
    }

    public Image findById(int id) {
        return imageDAO.findById(id);
    }

    public void delete(int id){
        imageDAO.delete(id);
    }
}
