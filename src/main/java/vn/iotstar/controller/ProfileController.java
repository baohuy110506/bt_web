package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.ValidationUtil;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
@WebServlet(urlPatterns = {
    "/user/profile", "/profile",
    "/user/profile/verify-otp",
    "/user/profile/resend-otp"
})
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("account");
        User currentUser = userService.get(sessionUser.getUserName());
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        session.setAttribute("account", currentUser);

        String uri = req.getRequestURI();

        // 1. Chức năng xác thực OTP khi cập nhật Email mới
        if (uri.contains("/verify-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            if (pendingEmail == null || pendingEmail.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/user/profile");
                return;
            }
            req.setAttribute("newEmail", pendingEmail);
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        // 2. Gửi lại mã OTP xác nhận email mới
        if (uri.contains("/resend-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            if (pendingEmail != null && !pendingEmail.trim().isEmpty()) {
                String newOtp = EmailUtil.generateOtp();
                session.setAttribute("pendingEmailOtp", newOtp);
                currentUser.setCode(newOtp);
                userService.update(currentUser);

                // Gửi mã OTP đến email mới
                EmailUtil.sendOtpEmail(pendingEmail.trim(), "Mã OTP Xác Nhận Email Mới - Media JPA",
                        newOtp, "cập nhật địa chỉ email mới trong hệ thống");
                System.out.println("[OTP RESEND PROFILE] Mã OTP gửi tới email mới " + pendingEmail + ": " + newOtp);

                req.setAttribute("successMsg", "Đã gửi lại mã OTP đến email mới: " + pendingEmail);
            }
            req.setAttribute("newEmail", pendingEmail);
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        // 3. Mặc định: Hiển thị trang Profile thông tin cá nhân
        req.setAttribute("user", currentUser);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("account");
        User currentUser = userService.get(sessionUser.getUserName());
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();

        // ==============================================================
        // XỬ LÝ XÁC THỰC OTP CẬP NHẬT EMAIL MỚI
        // ==============================================================
        if (uri.contains("/verify-otp")) {
            String otpInput = req.getParameter("otp");
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            String pendingOtp = (String) session.getAttribute("pendingEmailOtp");

            if (pendingEmail == null || pendingOtp == null) {
                resp.sendRedirect(req.getContextPath() + "/user/profile");
                return;
            }

            if (otpInput == null || otpInput.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập mã OTP gồm 6 chữ số!");
                req.setAttribute("newEmail", pendingEmail);
                req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
                return;
            }

            if (!pendingOtp.equals(otpInput.trim())) {
                req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hạn! Vui lòng thử lại.");
                req.setAttribute("newEmail", pendingEmail);
                req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
                return;
            }

            // OTP CHÍNH XÁC -> Tiến hành lưu email mới và thông tin chờ duyệt vào Database
            currentUser.setEmail(pendingEmail);
            String pendingFullname = (String) session.getAttribute("pendingFullname");
            if (pendingFullname != null) {
                currentUser.setFullName(pendingFullname);
            }
            String pendingPhone = (String) session.getAttribute("pendingPhone");
            currentUser.setPhone(pendingPhone);

            String pendingAvatar = (String) session.getAttribute("pendingAvatar");
            if (pendingAvatar != null && !pendingAvatar.trim().isEmpty()) {
                currentUser.setAvatar(pendingAvatar);
            }

            currentUser.setCode(null); // Xóa OTP sau khi xác nhận
            userService.update(currentUser);

            // Cập nhật session và xóa các thuộc tính tạm
            session.setAttribute("account", currentUser);
            session.removeAttribute("pendingEmail");
            session.removeAttribute("pendingEmailOtp");
            session.removeAttribute("pendingFullname");
            session.removeAttribute("pendingPhone");
            session.removeAttribute("pendingAvatar");

            req.setAttribute("user", currentUser);
            req.setAttribute("successMsg", "Xác thực OTP thành công! Đã cập nhật email mới: " + pendingEmail);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        // ==============================================================
        // XỬ LÝ CẬP NHẬT THÔNG TIN PROFILE (FULLNAME, PHONE, EMAIL, AVATAR CLOUDINARY)
        // ==============================================================
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        Map<String, String> errors = new HashMap<>();

        // 1. Kiểm tra Fullname
        if (fullname == null || fullname.trim().isEmpty()) {
            errors.put("fullname", "Vui lòng nhập họ và tên!");
        } else if (fullname.trim().length() < 2) {
            errors.put("fullname", "Họ và tên phải có tối thiểu 2 ký tự!");
        }

        // 2. Kiểm tra Email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Vui lòng nhập địa chỉ email!");
        } else if (!ValidationUtil.isValidEmail(email.trim())) {
            errors.put("email", "Định dạng email không hợp lệ (Ví dụ: name@example.com)!");
        }

        // 3. Kiểm tra Phone nếu có nhập
        if (phone != null && !phone.trim().isEmpty() && !ValidationUtil.isValidPhone(phone.trim())) {
            errors.put("phone", "Số điện thoại không đúng chuẩn VN (10 số, bắt đầu bằng 03, 05, 07, 08, 09)!");
        }

        // 4. Kiểm tra file ảnh Multipart upload
        Part avatarPart = null;
        try {
            avatarPart = req.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submittedName = avatarPart.getSubmittedFileName();
                if (!ValidationUtil.isValidImageExtension(submittedName)) {
                    errors.put("avatarFile", "Chỉ chấp nhận các file ảnh: JPG, JPEG, PNG, WEBP, GIF!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("user", currentUser);
            req.setAttribute("fullname", fullname);
            req.setAttribute("phone", phone);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        // Xử lý upload avatar lên Cloudinary bằng Multipart
        String uploadedAvatarUrl = null;
        if (avatarPart != null && avatarPart.getSize() > 0) {
            uploadedAvatarUrl = CloudinaryUtil.uploadImage(avatarPart);
        }

        String currentEmail = currentUser.getEmail() != null ? currentUser.getEmail().trim() : "";
        String inputEmail = email.trim();

        // TRƯỜNG HỢP 1: NGƯỜI DÙNG THAY ĐỔI EMAIL MỚI -> GỬI OTP ĐẾN EMAIL MỚI ĐỂ XÁC NHẬN
        if (!inputEmail.equalsIgnoreCase(currentEmail)) {
            // Kiểm tra xem email mới đã thuộc về user nào khác chưa
            if (userService.checkExistEmail(inputEmail)) {
                errors.put("email", "Địa chỉ email mới '" + inputEmail + "' đã được sử dụng bởi tài khoản khác!");
                req.setAttribute("errors", errors);
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                return;
            }

            // Sinh mã OTP 6 chữ số
            String otp = EmailUtil.generateOtp();

            // Lưu các thông tin chờ xác nhận vào Session
            session.setAttribute("pendingEmail", inputEmail);
            session.setAttribute("pendingEmailOtp", otp);
            session.setAttribute("pendingFullname", fullname.trim());
            session.setAttribute("pendingPhone", phone != null ? phone.trim() : null);
            if (uploadedAvatarUrl != null) {
                session.setAttribute("pendingAvatar", uploadedAvatarUrl);
            }

            // Lưu mã OTP vào CSDL
            currentUser.setCode(otp);
            userService.update(currentUser);

            // Gửi mã OTP xác nhận đến EMAIL MỚI
            EmailUtil.sendOtpEmail(inputEmail, "Xác Nhận Cập Nhật Email Mới - Media JPA",
                    otp, "thay đổi địa chỉ email tài khoản sang " + inputEmail);
            System.out.println("[OTP NEW EMAIL] Mã OTP gửi tới email mới " + inputEmail + ": " + otp);

            // Chuyển hướng tới trang nhập mã OTP
            resp.sendRedirect(req.getContextPath() + "/user/profile/verify-otp");
            return;
        }

        // TRƯỜNG HỢP 2: EMAIL KHÔNG ĐỔI -> CẬP NHẬT TRỰC TIẾP FULLNAME, PHONE, AVATAR CLOUDINARY
        currentUser.setFullName(fullname.trim());
        currentUser.setPhone(phone != null ? phone.trim() : null);
        if (uploadedAvatarUrl != null) {
            currentUser.setAvatar(uploadedAvatarUrl);
        }

        userService.update(currentUser);
        session.setAttribute("account", currentUser);

        req.setAttribute("user", currentUser);
        req.setAttribute("successMsg", "Cập nhật thông tin cá nhân và ảnh đại diện thành công!");
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }
}
