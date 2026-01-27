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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Controller xử lý upload avatar cho user
 */
@WebServlet(name = "AvatarUploadController", urlPatterns = { "/profile/avatar" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 2, // 2MB
        maxRequestSize = 1024 * 1024 * 5 // 5MB
)
public class AvatarUploadController extends HttpServlet {

    private ProfileService profileService;
    private static final String UPLOAD_DIR = "static/images/avatars";

    @Override
    public void init() throws ServletException {
        profileService = new ProfileService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = SessionUtil.getCurrentUser(session);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Part filePart = request.getPart("avatar");

            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Vui lòng chọn file ảnh");
                forwardToEdit(request, response, currentUser);
                return;
            }

            // Validate file type
            String contentType = filePart.getContentType();
            if (!isValidImageType(contentType)) {
                request.setAttribute("error", "Chỉ chấp nhận file ảnh JPG, PNG, GIF, WebP");
                forwardToEdit(request, response, currentUser);
                return;
            }

            // Validate file size (max 2MB)
            if (filePart.getSize() > 2 * 1024 * 1024) {
                request.setAttribute("error", "File ảnh không được vượt quá 2MB");
                forwardToEdit(request, response, currentUser);
                return;
            }

            // Get real path for upload directory
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

            // Create directory if not exists
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generate unique filename
            String originalFileName = getFileName(filePart);
            String extension = getFileExtension(originalFileName);
            String newFileName = "avatar_" + currentUser.getUserId() + "_"
                    + UUID.randomUUID().toString().substring(0, 8) + extension;

            // Save file
            Path filePath = Paths.get(uploadPath, newFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Build avatar URL
            String avatarUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + newFileName;

            // Update database
            boolean success = profileService.updateAvatar(currentUser.getUserId(), avatarUrl);

            if (success) {
                // Update session user
                currentUser.setAvatar(avatarUrl);
                SessionUtil.setCurrentUser(session, currentUser);
                request.setAttribute("success", "Cập nhật avatar thành công!");
            } else {
                // Delete uploaded file if db update fails
                Files.deleteIfExists(filePath);
                request.setAttribute("error", profileService.getLastError());
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi upload avatar: " + e.getMessage());
        }

        forwardToEdit(request, response, currentUser);
    }

    private boolean isValidImageType(String contentType) {
        return contentType != null && (contentType.equals("image/jpeg") ||
                contentType.equals("image/png") ||
                contentType.equals("image/gif") ||
                contentType.equals("image/webp"));
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 2, cd.length() - 1);
            }
        }
        return "avatar.jpg";
    }

    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            return fileName.substring(lastDot).toLowerCase();
        }
        return ".jpg";
    }

    private void forwardToEdit(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        request.setAttribute("user", user);
        request.getRequestDispatcher("/user/profile-edit.jsp").forward(request, response);
    }
}
