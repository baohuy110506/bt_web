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
@WebServlet(urlPatterns = { "/verify-otp", "/resend-otp" })
public class VerifyOtpController extends HttpServlet {

    private UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();
        if (url.contains("/resend-otp")) {
            String username = req.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    username = (String) session.getAttribute("otpUsername");
                }
            }
            if (username != null && !username.trim().isEmpty()) {
                boolean sent = service.sendActivationOtp(username.trim());
                if (sent) {
                    req.setAttribute("msg", "Mã OTP mới đã được gửi đến email của bạn! (Hoặc xem tại Console nếu test cục bộ)");
                } else {
                    req.setAttribute("alert", "Không tìm thấy tài khoản để gửi lại mã OTP!");
                }
            }
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        String username = req.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                username = (String) session.getAttribute("otpUsername");
            }
        }
        req.setAttribute("username", username);
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String otp = req.getParameter("otp");

        if (username == null || username.trim().isEmpty()) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                username = (String) session.getAttribute("otpUsername");
            }
        }

        if (otp == null || otp.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập mã OTP gồm 6 chữ số!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        boolean isVerified = service.verifyOtp(username, otp.trim());
        if (isVerified) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("otpUsername");
                session.removeAttribute("otpEmail");
            }
            req.setAttribute("successMsg", "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hạn! Vui lòng thử lại.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
