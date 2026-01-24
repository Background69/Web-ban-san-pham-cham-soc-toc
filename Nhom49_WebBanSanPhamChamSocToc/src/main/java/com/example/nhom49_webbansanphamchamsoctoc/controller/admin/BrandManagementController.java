package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "BrandManagementController", value = "/BrandManagementController")
public class BrandManagementController extends HttpServlet {
    private BrandDAO brandDAO;
    public void init(){
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);


        //Nếu chưa đăng nhập chuyển sang trang Login
        if (session==null|| session.getAttribute("currentUser")==null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())){
            response.sendError(HttpServletResponse.SC_FORBIDDEN,"Không có quyeefn truy cập");
            return;
        }

        request.setAttribute("brands", brandDAO.findAll());
        request.setAttribute("origins", brandDAO.findAllOrigins());

        request.getRequestDispatcher("/admin/BrandManagement.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String action = request.getParameter("action");
            if ("add".equals(action)){
                addBrand(request);
            } else if ("update".equals(action)){
                updateBrand(request);
            } else  if ("delete".equals(action)){
                deleteBrand(request);
            }
    }
    private void addBrand(HttpServletRequest request){
        Brand brand = new Brand();
        brand.setBrandName(request.getParameter("brandName"));
        brand.setBrandSlug(request.getParameter("brandSlug"));
        brand.setLogoUrl(request.getParameter("logoUrl"));
        brand.setOrigin(request.getParameter("origin"));
        brand.setShortDescription(request.getParameter("shortDescription"));
        brand.setFullDescription(request.getParameter("fullDescription"));
        brandDAO.insert(brand);
    }
    private void updateBrand(HttpServletRequest request){
        Brand brand = new Brand();
        brand.setBrandId(Integer.parseInt(request.getParameter("brandId")));
        brand.setBrandName(request.getParameter("brandName"));
        brand.setBrandSlug(request.getParameter("brandSlug"));
        brand.setLogoUrl(request.getParameter("logoUrl"));
        brand.setOrigin(request.getParameter("origin"));
        brand.setShortDescription(request.getParameter("shortDescription"));
        brand.setFullDescription(request.getParameter("fullDescription"));

        brandDAO.update(brand);
    }
    private void deleteBrand(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("brandId"));
        brandDAO.delete(id);
    }
}