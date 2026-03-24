package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.PendingRegistrationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.PendingRegistration;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.http.HttpSession;
import org.jdbi.v3.core.Jdbi;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

public class AuthenticationService {

    private static final int REGISTRATION_OTP_EXPIRY_MINUTES = 15;
    private static final int MAX_REGISTRATION_OTP_ATTEMPTS = 5;
    private static final String DEFAULT_USER_ROLE = "Kh\u00e1ch h\u00e0ng";

    private final UserDAO userDAO;
    private final PendingRegistrationDAO pendingRegistrationDAO;
    private final Jdbi jdbi;
    private EmailService emailService;
    private String lastError;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
        this.pendingRegistrationDAO = new PendingRegistrationDAO();
        this.jdbi = JDBIConnector.getInstance();
    }

    public String getLastError() {
        return lastError;
    }

    public User login(String emailOrUsername, String password) {
        lastError = null;
        if (ValidationUtil.isEmpty(emailOrUsername)) {
            lastError = "Email hoac ten dang nhap khong duoc de trong";
            return null;
        }
        if (ValidationUtil.isEmpty(password)) {
            lastError = "Mat khau khong duoc de trong";
            return null;
        }

        User user = userDAO.findByEmail(emailOrUsername.trim());
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername.trim());
        }

        if (user == null) {
            lastError = "Tai khoan khong ton tai";
            return null;
        }
        if (!user.isActive()) {
            lastError = "Tai khoan da bi khoa";
            return null;
        }
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            lastError = "Mat khau khong dung";
            return null;
        }

        return user;
    }

    public User register(String email, String username, String phone, String password, String confirmPassword) {
        if (!startPendingRegistration(email, username, phone, password, confirmPassword)) {
            return null;
        }

        User pendingUser = new User();
        pendingUser.setEmail(ValidationUtil.sanitize(email));
        pendingUser.setUsername(ValidationUtil.sanitize(username));
        pendingUser.setPhone(ValidationUtil.sanitize(phone));
        return pendingUser;
    }

    public boolean startPendingRegistration(String email, String username, String phone,
                                            String password, String confirmPassword) {
        lastError = null;
        pendingRegistrationDAO.deleteExpiredUnverified();

        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return false;
        }

        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) {
            lastError = usernameError;
            return false;
        }

        String passwordError = ValidationUtil.validatePassword(password);
        if (passwordError != null) {
            lastError = passwordError;
            return false;
        }

        String phoneError = ValidationUtil.validatePhone(phone);
        if (phoneError != null) {
            lastError = phoneError;
            return false;
        }

        String confirmError = ValidationUtil.validateConfirmPassword(password, confirmPassword);
        if (confirmError != null) {
            lastError = confirmError;
            return false;
        }

        String normalizedEmail = email.trim();
        String normalizedUsername = username.trim();

        if (userDAO.existsByEmail(normalizedEmail)) {
            lastError = "Email da ton tai";
            return false;
        }

        if (userDAO.existsByUsername(normalizedUsername)) {
            lastError = "Ten dang nhap da ton tai";
            return false;
        }

        if (pendingRegistrationDAO.existsByUsernameExcludingEmail(normalizedUsername, normalizedEmail)) {
            lastError = "Ten dang nhap dang cho xac thuc boi email khac";
            return false;
        }

        String otpCode = generateOtpCode();
        Timestamp otpExpiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(REGISTRATION_OTP_EXPIRY_MINUTES));
        String passwordHash = PasswordUtil.hashPassword(password);

        int pendingId = pendingRegistrationDAO.saveOrUpdate(
                normalizedEmail,
                normalizedUsername,
                null,
                ValidationUtil.sanitize(phone),
                passwordHash,
                otpCode,
                otpExpiry
        );

        if (pendingId <= 0) {
            lastError = "Khong the khoi tao dang ky tam";
            return false;
        }

        try {
            boolean sent = getEmailService().sendRegistrationOtpEmail(
                    normalizedEmail,
                    otpCode,
                    REGISTRATION_OTP_EXPIRY_MINUTES
            );
            if (!sent) {
                lastError = "Khong gui duoc OTP. Vui long thu lai";
                return false;
            }
        } catch (Exception e) {
            lastError = "He thong email chua duoc cau hinh";
            return false;
        }

        return true;
    }

    public boolean resendRegistrationOtp(String email) {
        lastError = null;
        pendingRegistrationDAO.deleteExpiredUnverified();

        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return false;
        }

        String normalizedEmail = email.trim();
        PendingRegistration pending = pendingRegistrationDAO.findByEmail(normalizedEmail);
        if (pending == null) {
            lastError = "Khong tim thay dang ky tam. Vui long dang ky lai";
            return false;
        }

        if (pending.isVerified()) {
            lastError = "Dang ky nay da xac thuc";
            return false;
        }

        if (userDAO.existsByEmail(normalizedEmail)) {
            lastError = "Email nay da duoc dang ky";
            return false;
        }

        String otpCode = generateOtpCode();
        Timestamp otpExpiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(REGISTRATION_OTP_EXPIRY_MINUTES));
        boolean updated = pendingRegistrationDAO.updateOtp(normalizedEmail, otpCode, otpExpiry);
        if (!updated) {
            lastError = "Khong the cap nhat OTP";
            return false;
        }

        try {
            boolean sent = getEmailService().sendRegistrationOtpEmail(
                    normalizedEmail,
                    otpCode,
                    REGISTRATION_OTP_EXPIRY_MINUTES
            );
            if (!sent) {
                lastError = "Khong gui duoc OTP. Vui long thu lai";
                return false;
            }
        } catch (Exception e) {
            lastError = "He thong email chua duoc cau hinh";
            return false;
        }

        return true;
    }

    public User verifyPendingRegistration(String email, String otpCode) {
        lastError = null;

        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return null;
        }

        if (!isValidOtpCode(otpCode)) {
            lastError = "Ma OTP phai gom 6 chu so";
            return null;
        }

        PendingRegistration pending = pendingRegistrationDAO.findByEmail(email.trim());
        if (pending == null) {
            lastError = "Thong tin dang ky tam khong ton tai hoac da het han";
            return null;
        }

        if (pending.isVerified()) {
            lastError = "Dang ky nay da duoc xac thuc";
            return null;
        }

        if (pending.getAttempts() >= MAX_REGISTRATION_OTP_ATTEMPTS) {
            lastError = "OTP da vuot qua so lan thu toi da";
            return null;
        }

        if (pending.getOtpExpiry() == null || pending.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
            pendingRegistrationDAO.deleteById(pending.getPendingId());
            lastError = "OTP da het han. Vui long dang ky lai";
            return null;
        }

        if (!otpCode.equals(pending.getOtpCode())) {
            pendingRegistrationDAO.incrementAttempts(pending.getPendingId());
            int currentAttempts = pending.getAttempts() + 1;
            if (currentAttempts >= MAX_REGISTRATION_OTP_ATTEMPTS) {
                lastError = "OTP da vuot qua so lan thu toi da";
            } else {
                lastError = "OTP khong dung";
            }
            return null;
        }

        Integer userId = createUserFromPending(pending);
        if (userId == null || userId <= 0) {
            if (lastError == null) {
                lastError = "Khong the kich hoat tai khoan";
            }
            return null;
        }

        return userDAO.findById(userId);
    }

    private Integer createUserFromPending(PendingRegistration pending) {
        try {
            return jdbi.inTransaction(handle -> {
                int emailExists = handle.createQuery("SELECT COUNT(*) FROM users WHERE email = :email")
                        .bind("email", pending.getEmail())
                        .mapTo(Integer.class)
                        .one();
                if (emailExists > 0) {
                    throw new IllegalStateException("Email da ton tai");
                }

                int usernameExists = handle.createQuery("SELECT COUNT(*) FROM users WHERE username = :username")
                        .bind("username", pending.getUsername())
                        .mapTo(Integer.class)
                        .one();
                if (usernameExists > 0) {
                    throw new IllegalStateException("Ten dang nhap da ton tai");
                }

                Integer newUserId = handle.createUpdate("""
                                INSERT INTO users
                                (email, username, full_name, password, phone, avatar, role, is_active, google_id, auth_provider)
                                VALUES (:email, :username, :fullName, :password, :phone, :avatar, :role, :isActive, :googleId, :authProvider)
                                """)
                        .bind("email", pending.getEmail())
                        .bind("username", pending.getUsername())
                        .bind("fullName", pending.getFullName())
                        .bind("password", pending.getPasswordHash())
                        .bind("phone", pending.getPhone())
                        .bind("avatar", "avatar/avatar.jpg")
                        .bind("role", DEFAULT_USER_ROLE)
                        .bind("isActive", true)
                        .bind("googleId", (String) null)
                        .bind("authProvider", "LOCAL")
                        .executeAndReturnGeneratedKeys("user_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null);

                if (newUserId == null || newUserId <= 0) {
                    throw new IllegalStateException("Khong the tao tai khoan");
                }

                int deleted = handle.createUpdate("DELETE FROM pending_registration WHERE pending_id = :pendingId")
                        .bind("pendingId", pending.getPendingId())
                        .execute();

                if (deleted == 0) {
                    throw new IllegalStateException("Khong the hoan tat xac thuc dang ky");
                }

                return newUserId;
            });
        } catch (Exception e) {
            if (e.getMessage() != null && !e.getMessage().isBlank()) {
                lastError = e.getMessage();
            } else {
                lastError = "Khong the kich hoat tai khoan";
            }
            return null;
        }
    }

    private String generateOtpCode() {
        int value = ThreadLocalRandom.current().nextInt(100000, 1000000);
        return String.valueOf(value);
    }

    private boolean isValidOtpCode(String otp) {
        return otp != null && otp.matches("\\d{6}");
    }

    private EmailService getEmailService() {
        if (emailService == null) {
            emailService = new EmailService();
        }
        return emailService;
    }

    public void setCurrentUser(HttpSession session, User user) {
        SessionUtil.setCurrentUser(session, user);
    }

    public void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute(SessionUtil.USER_KEY);
            session.removeAttribute(SessionUtil.CURRENT_USER_KEY);
            session.removeAttribute(SessionUtil.CART_KEY);
            session.invalidate();
        }
    }

    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }
}
