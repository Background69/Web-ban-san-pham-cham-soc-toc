package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;
import com.example.nhom49_webbansanphamchamsoctoc.model.Feedback;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.FeedbackMessage;
import com.example.nhom49_webbansanphamchamsoctoc.services.FeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet(name = "AdminSupportController", urlPatterns = {"/admin/support"})
public class AdminSupportController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private static final Set<String> VALID_STATUSES = Set.of(
            "RECEIVED", "PROCESSING", "RESOLVED", "CLOSED"
    );

    private static final Set<String> VALID_CATEGORIES = Set.of(
            "SYSTEM_ERROR", "SHIPPING", "PRODUCT_QUALITY", "SHOPPING_GUIDE", "OTHER"
    );

    private FeedbackService feedbackService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            showDetail(request, response);
        } else {
            showList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("reply".equals(action)) {
            handleReply(request, response);
        } else if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/support");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            String category = request.getParameter("category");
            String pageStr = request.getParameter("page");

            if (status != null && !status.isBlank() && !VALID_STATUSES.contains(status)) {
                status = null;
            }
            if (category != null && !category.isBlank() && !VALID_CATEGORIES.contains(category)) {
                category = null;
            }

            int page = 1;
            if (pageStr != null) {
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException ignored) {
                }
            }

            List<Feedback> tickets = feedbackService.findAll(keyword, status, category, page, PAGE_SIZE);
            int totalCount = feedbackService.countAll(keyword, status, category);
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            request.setAttribute("tickets", tickets);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

            // Giữ lại giá trị filter trên form
            request.setAttribute("filterKeyword", keyword);
            request.setAttribute("filterStatus", status);
            request.setAttribute("filterCategory", category);

            request.getRequestDispatcher("/admin/support/list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách ticket. Vui lòng thử lại.");
            request.getRequestDispatcher("/admin/support/list.jsp").forward(request, response);
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/admin/support");
                return;
            }

            int feedbackId;
            try {
                feedbackId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/support");
                return;
            }

            Feedback feedback = feedbackService.findById(feedbackId);
            if (feedback == null) {
                response.sendRedirect(request.getContextPath() + "/admin/support");
                return;
            }

            List<FeedbackImage> images = feedbackService.findImagesByFeedbackId(feedbackId);
            List<FeedbackMessage> messages = feedbackService.findMessagesByFeedbackId(feedbackId);
            request.setAttribute("feedback", feedback);
            request.setAttribute("feedbackImages", images);
            request.setAttribute("feedbackMessages", messages);
            String success = (String) request.getSession().getAttribute("supportSuccess");
            String error = (String) request.getSession().getAttribute("supportError");
            if (success != null) {
                request.setAttribute("successMessage", success);
                request.getSession().removeAttribute("supportSuccess");
            }
            if (error != null) {
                request.setAttribute("errorMessage", error);
                request.getSession().removeAttribute("supportError");
            }
            request.getRequestDispatcher("/admin/support/detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/support");
        }
    }

    private void handleReply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("feedbackId");
        String message = request.getParameter("message");
        String newStatus = request.getParameter("newStatus");

        if (idStr == null || message == null || message.trim().isEmpty()) {
            request.getSession().setAttribute("supportError", "Nội dung phản hồi không được để trống.");
            response.sendRedirect(request.getContextPath() + "/admin/support?action=detail&id=" + idStr);
            return;
        }

        int feedbackId;
        try {
            feedbackId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        if (newStatus != null && !newStatus.isBlank() && !VALID_STATUSES.contains(newStatus)) {
            newStatus = null;
        }

        boolean success = feedbackService.adminReply(feedbackId, message.trim(), newStatus);

        if (success) {
            request.getSession().setAttribute("supportSuccess", "Đã gửi phản hồi thành công.");
        } else {
            request.getSession().setAttribute("supportError", "Có lỗi xảy ra khi gửi phản hồi.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support?action=detail&id=" + feedbackId);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("feedbackId");
        String newStatus = request.getParameter("newStatus");

        if (idStr == null || newStatus == null || !VALID_STATUSES.contains(newStatus)) {
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        int feedbackId;
        try {
            feedbackId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        boolean success = feedbackService.updateStatus(feedbackId, newStatus);

        if (success) {
            request.getSession().setAttribute("supportSuccess", "Đã cập nhật trạng thái ticket.");
        } else {
            request.getSession().setAttribute("supportError", "Không thể cập nhật trạng thái.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/support?action=detail&id=" + feedbackId);
    }
}
