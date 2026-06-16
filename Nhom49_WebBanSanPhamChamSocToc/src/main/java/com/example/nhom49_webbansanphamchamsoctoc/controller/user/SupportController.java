package com.example.nhom49_webbansanphamchamsoctoc.controller.user;
import com.example.nhom49_webbansanphamchamsoctoc.model.Feedback;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.FeedbackService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupportController", value = "/support")
public class SupportController extends HttpServlet {

    private FeedbackService feedbackService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            request.setAttribute("searchQuery", query.trim());
        }
        User currentUser = SessionUtil.getCurrentUser(request.getSession(false));
        if (currentUser != null) {
            request.setAttribute("currentUser", currentUser);
            try {
                List<Feedback> recentTickets = feedbackService.findByUserId(currentUser.getUserId());
                request.setAttribute("recentTickets", recentTickets);
            } catch (Exception e) {
            }
        }

        request.getRequestDispatcher("/user/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}