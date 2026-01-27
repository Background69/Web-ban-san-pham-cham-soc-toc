package com.example.nhom49_webbansanphamchamsoctoc.controller.payment;

import com.example.nhom49_webbansanphamchamsoctoc.services.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CancelPaymentController", urlPatterns = {"/payment/cancel"})
public class CancelPaymentController extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String orderTempId = (String) session.getAttribute("orderTempId");

        if (orderTempId != null) {
            paymentService.cancelTransaction(orderTempId);
            session.removeAttribute("orderTempId");
            session.removeAttribute("orderData");
        }

        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
