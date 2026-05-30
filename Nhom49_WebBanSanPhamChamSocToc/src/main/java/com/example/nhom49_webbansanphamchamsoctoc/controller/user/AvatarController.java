package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.cloudinary.utils.ObjectUtils;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProfileService;
import com.example.nhom49_webbansanphamchamsoctoc.util.CloudinaryConfig;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AvatarController", urlPatterns = {"/profile/avatar"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 2, // 2 MB
        maxRequestSize = 1024 * 1024 * 5 // 5 MB
)
public class AvatarController extends HttpServlet {

    private ProfileService profileService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.profileService = new ProfileService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = SessionUtil.getCurrentUser(request.getSession(false));
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/profile/edit");
            return;
        }

        try {
            Part filePart = request.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                request.getSession().setAttribute("error", "Vui lòng chọn file ảnh");
                response.sendRedirect(request.getContextPath() + "/profile/edit");
                return;
            }

            // Validate file type
            String contentType = filePart.getContentType();
            if (!"image/jpeg".equals(contentType)
                    && !"image/png".equals(contentType)
                    && !"image/webp".equals(contentType)
                    && !"image/gif".equals(contentType)) {
                request.getSession().setAttribute("error", "Vui lòng chọn file ảnh hợp lệ (JPG, PNG, GIF, WebP)");
                response.sendRedirect(request.getContextPath() + "/profile/edit");
                return;
            }

            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            Map<?, ?> result = CloudinaryConfig.getInstance()
                    .uploader()
                    .upload(
                            fileBytes,
                            ObjectUtils.asMap(
                                    "folder", "avatars",
                                    "public_id", "avatar_" + currentUser.getUserId(),
                                    "overwrite", true,
                                    "invalidate", true,
                                    "resource_type", "image"
                            )
                    );

            String avatarUrl = (String) result.get("secure_url");

            if (avatarUrl == null || avatarUrl.isBlank()) {
                request.getSession().setAttribute("error", "Không lấy được URL ảnh từ Cloudinary");
                response.sendRedirect(request.getContextPath() + "/profile/edit");
                return;
            }

            boolean success = profileService.updateAvatar(currentUser.getUserId(), avatarUrl);

            if (success) {
                currentUser.setAvatar(avatarUrl);
                SessionUtil.setCurrentUser(request.getSession(), currentUser);

                request.getSession().setAttribute(
                        "success",
                        "Ảnh đại diện của bạn đã được cập nhật thành công."
                );
            } else {
                String errorMessage = profileService.getLastError();
                request.getSession().setAttribute(
                        "error",
                        errorMessage != null ? errorMessage : "Cập nhật ảnh đại diện thất bại."
                );
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi tải ảnh. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/profile/edit");
    }
}
