package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProfileService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "AvatarController", urlPatterns = { "/profile/avatar" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
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
            if (contentType == null || !contentType.startsWith("image/")) {
                request.getSession().setAttribute("error", "Vui lòng chọn file ảnh hợp lệ (JPG, PNG, GIF, WebP)");
                response.sendRedirect(request.getContextPath() + "/profile/edit");
                return;
            }

            // Get file extension
            String fileName = filePart.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = "avatar_" + currentUser.getUserId() + "_" + System.currentTimeMillis() + extension;

            // Save to avatars directory in static folder
            String uploadDir = getServletContext().getRealPath("/static/avatars");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            String filePath = uploadDir + File.separator + newFileName;
            filePart.write(filePath);

            // Update user avatar in database using ProfileService
            String avatarUrl = "avatars/" + newFileName;
            boolean success = profileService.updateAvatar(currentUser.getUserId(), avatarUrl);

            if (success) {
                // Update session user
                currentUser.setAvatar(avatarUrl);
                SessionUtil.setCurrentUser(request.getSession(), currentUser);
                request.getSession().setAttribute("success", "Cập nhật ảnh đại diện thành công");
            } else {
                request.getSession().setAttribute("error", profileService.getLastError());
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi tải ảnh: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/profile/edit");
    }
}
