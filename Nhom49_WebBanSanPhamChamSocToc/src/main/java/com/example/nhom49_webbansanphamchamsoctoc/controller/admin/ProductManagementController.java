package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductManagementController", value = "/ProductManagementController")
public class ProductManagementController extends HttpServlet {
    ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        //Nếu chưa đăng nhập chuyển sang trang đăng nhập
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
        String action = request.getParameter("action");
        //Thêm sản phẩm
        if ("create".equals(action)){
            request.getRequestDispatcher("/view/admin/productform.jsp")
                    .forward(request,response);
            return;

        }
        // Sửa sản phẩm
        if ("edit".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(id);
            request.getAttribute("product");
            request.getRequestDispatcher("/view/admin/productform.jsp")
                    .forward(request,response);

        }
        //Xoá Sản phẩm
        if ("detele".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.delete(id);
            response.sendRedirect(request.getContextPath()+"/admin/products");
            return;
        }


        List<Product> products = productDAO.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("view/admin/product.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Chức năng thêm
        if ("create".equals(action)) {
            Product product = productFromRequest(request);
            product.setProductId(Integer.parseInt(request.getParameter("id")));
            productDAO.update(product);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
        private Product productFromRequest(HttpServletRequest request){
            Product product = new Product();
            product.setProductName(request.getParameter("productname"));
            product.setCategory(request.getParameter("category"));
            product.setImages(request.getParameter("image"));
            return product;
        }
}