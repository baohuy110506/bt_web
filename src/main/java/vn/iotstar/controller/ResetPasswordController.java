package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/reset-password")
public class ResetPasswordController extends HttpServlet {

    private UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("user");
        if (user == null || user.trim().isEmpty()) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                user = (String) session.getAttribute("resetUser");
            }
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String user = req.getParameter("user");
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (user == null || user.trim().isEmpty()) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                user = (String) session.getAttribute("resetUser");
            }
        }

        java.util.Map<String, String> errors = new java.util.HashMap<>();
        if (otp == null || otp.trim().isEmpty()) {
            errors.put("otp", "Vui lòng nhập mã OTP!");
        } else if (otp.trim().length() != 6) {
            errors.put("otp", "Mã OTP phải có đúng 6 chữ số!");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            errors.put("newPassword", "Vui lòng nhập mật khẩu mới!");
        } else if (newPassword.trim().length() < 6) {
            errors.put("newPassword", "Mật khẩu mới phải có tối thiểu 6 ký tự!");
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Vui lòng xác nhận lại mật khẩu mới!");
        } else if (!newPassword.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không trùng khớp!");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("user", user);
            req.setAttribute("otp", otp);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        boolean success = service.resetPassword(user, otp.trim(), newPassword.trim());
        if (success) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("resetUser");
            }
            req.setAttribute("successMsg", "Đổi mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hạn! Vui lòng thử lại.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        }
    }
}
