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

        java.util.Map<String, String> errors = new java.util.HashMap<>();

        // 1. Kiểm tra username
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Vui lòng nhập tên đăng nhập!");
        } else if (!vn.iotstar.util.ValidationUtil.isValidUsername(username.trim())) {
            errors.put("username", "Tên đăng nhập phải từ 3-30 ký tự, không dấu và không chứa ký tự đặc biệt!");
        } else if (service.checkExistUsername(username.trim())) {
            errors.put("username", "Tên đăng nhập này đã được sử dụng!");
        }

        // 2. Kiểm tra email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Vui lòng nhập địa chỉ email!");
        } else if (!vn.iotstar.util.ValidationUtil.isValidEmail(email.trim())) {
            errors.put("email", "Định dạng email không hợp lệ (Ví dụ: user@example.com)!");
        } else if (service.checkExistEmail(email.trim())) {
            errors.put("email", "Email này đã được đăng ký trong hệ thống!");
        }

        // 3. Kiểm tra họ và tên
        if (fullname != null && !fullname.trim().isEmpty() && fullname.trim().length() < 2) {
            errors.put("fullname", "Họ và tên phải có ít nhất 2 ký tự!");
        }

        // 4. Kiểm tra số điện thoại nếu có nhập
        if (phone != null && !phone.trim().isEmpty() && !vn.iotstar.util.ValidationUtil.isValidPhone(phone.trim())) {
            errors.put("phone", "Số điện thoại không đúng định dạng VN (10 số, bắt đầu bằng 03, 05, 07, 08, 09)!");
        }

        // 5. Kiểm tra mật khẩu
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu!");
        } else if (password.trim().length() < 6) {
            errors.put("password", "Mật khẩu phải có độ dài tối thiểu 6 ký tự!");
        }

        // 6. Kiểm tra xác nhận mật khẩu
        if (repassword == null || repassword.trim().isEmpty()) {
            errors.put("repassword", "Vui lòng xác nhận lại mật khẩu!");
        } else if (!repassword.equals(password)) {
            errors.put("repassword", "Mật khẩu xác nhận không trùng khớp!");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("fullname", fullname);
            req.setAttribute("phone", phone);
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
            req.setAttribute("alert", "Lỗi hệ thống khi đăng ký tài khoản! Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
