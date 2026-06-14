package com.example.nhom49_webbansanphamchamsoctoc.controller.user;
import com.example.nhom49_webbansanphamchamsoctoc.model.Feedback;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.FeedbackService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

@WebServlet(name = "FeedbackController", urlPatterns = {"/support/feedback"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 5,         // 5 MB per file
        maxRequestSize = 1024 * 1024 * 20      // 20 MB
)
public class FeedbackController extends HttpServlet {

    private static final Set<String> VALID_CATEGORIES = Set.of(
            "SYSTEM_ERROR", "SHIPPING", "PRODUCT_QUALITY", "SHOPPING_GUIDE", "OTHER"
    );

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp"
    );

    private FeedbackService feedbackService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.feedbackService = new FeedbackService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();
        try {
            String category = getPartValue(request, "category");
            String title = getPartValue(request, "title");
            String content = getPartValue(request, "content");
            String customerName = getPartValue(request, "customerName");
            String customerEmail = getPartValue(request, "customerEmail");

            List<String> errors = new ArrayList<>();

            if (category == null || !VALID_CATEGORIES.contains(category)) {
                errors.add("Phân loại không hợp lệ");
            }
            if (title == null || title.trim().length() < 5) {
                errors.add("Tiêu đề phải có ít nhất 5 ký tự");
            }
            if (title != null && title.length() > 255) {
                errors.add("Tiêu đề không được quá 255 ký tự");
            }
            if (content == null || content.trim().length() < 20) {
                errors.add("Nội dung phải có ít nhất 20 ký tự");
            }
            if (customerEmail == null || !customerEmail.matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                errors.add("Email không hợp lệ");
            }

            if (!errors.isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", String.join(", ", errors));
                out.print(json);
                return;
            }

            List<byte[]> imageBytes = new ArrayList<>();
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    if (imageBytes.size() >= 3) break; // max 3 images

                    String partContentType = part.getContentType();
                    if (partContentType == null || !ALLOWED_CONTENT_TYPES.contains(partContentType)) {
                        continue;
                    }
                    if (part.getSize() > 5 * 1024 * 1024) {
                        continue;
                    }

                    imageBytes.add(part.getInputStream().readAllBytes());
                }
            }

            Feedback feedback = new Feedback();
            feedback.setCategory(category);
            feedback.setTitle(title.trim());
            feedback.setContent(content.trim());
            feedback.setCustomerName(customerName != null ? customerName.trim() : null);
            feedback.setCustomerEmail(customerEmail.trim());

            User currentUser = SessionUtil.getCurrentUser(request.getSession(false));
            if (currentUser != null) {
                feedback.setUserId(currentUser.getUserId());
            }

            String ticketCode = feedbackService.createFeedback(feedback, imageBytes);

            if (ticketCode != null) {
                json.addProperty("success", true);
                json.addProperty("ticketCode", ticketCode);
                json.addProperty("message", "Phản hồi của bạn đã được gửi thành công! Mã ticket: " + ticketCode);
            } else {
                json.addProperty("success", false);
                json.addProperty("message", "Có lỗi xảy ra khi gửi phản hồi. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            json.addProperty("success", false);
            json.addProperty("message", "Có lỗi xảy ra. Vui lòng thử lại sau.");
        }

        out.print(json);
    }

    private String getPartValue(HttpServletRequest request, String name) {
        try {
            Part part = request.getPart(name);
            if (part == null || part.getSize() == 0) return null;
            return new String(part.getInputStream().readAllBytes(), "UTF-8");
        } catch (Exception e) {
            return null;
        }
    }
}