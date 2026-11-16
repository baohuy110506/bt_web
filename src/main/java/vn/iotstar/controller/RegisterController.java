package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {

    private UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    session = req.getSession(true);
                    session.setAttribute("username", cookie.getValue());
                    resp.sendRedirect(req.getContextPath() + "/home");
                    return;
                }
            }
        }
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        String alertMsg = "";

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            alertMsg = "Vui lòng nhập đầy đủ tài khoản và mật khẩu!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            alertMsg = "Email không hợp lệ! Vui lòng nhập đúng email để nhận mã OTP.";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (repassword != null && !repassword.equals(password)) {
            alertMsg = "Mật khẩu xác nhận không trùng khớp!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (service.checkExistUsername(username.trim())) {
            alertMsg = "Tên đăng nhập đã được sử dụng!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (service.checkExistEmail(email.trim())) {
            alertMsg = "Email này đã được sử dụng!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Tạo mã OTP 6 chữ số ngẫu nhiên
        String otp = EmailUtil.generateOtp();

        // Đăng ký với mật khẩu mã hóa BCrypt và trạng thái chờ kích hoạt OTP (status = 0)
        boolean isSuccess = service.registerWithOtp(username.trim(), password.trim(), email.trim(), fullname, phone, otp);

        if (isSuccess) {
            HttpSession session = req.getSession(true);
            session.setAttribute("otpUsername", username.trim());
            session.setAttribute("otpEmail", email.trim());

            // Chuyển hướng sang trang nhập mã OTP xác thực tài khoản
            resp.sendRedirect(req.getContextPath() + "/verify-otp?username=" + username.trim());
        } else {
            alertMsg = "Lỗi hệ thống khi đăng ký tài khoản! Vui lòng thử lại sau.";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
