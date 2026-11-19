package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {

    private UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Kiểm tra cookie tự động đăng nhập (Remember me)
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (Constant.COOKIE_REMEMBER.equals(cookie.getName())) {
                    User user = service.get(cookie.getValue());
                    if (user != null && user.getStatus() == 1) {
                        session = req.getSession(true);
                        session.setAttribute("account", user);
                        session.setAttribute("username", user.getUserName());
                        resp.sendRedirect(req.getContextPath() + "/waiting");
                        return;
                    }
                }
            }
        }

        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");
        boolean isRememberMe = "on".equals(remember);

        // Validation kiểm tra tính hợp lệ dữ liệu
        java.util.Map<String, String> errors = new java.util.HashMap<>();
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Vui lòng nhập tên đăng nhập hoặc email!");
        }
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu!");
        } else if (password.trim().length() < 4) {
            errors.put("password", "Mật khẩu phải có độ dài ít nhất 4 ký tự!");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // Đăng nhập hỗ trợ mật khẩu đã mã hóa (hash password BCrypt) và cả plain text cho dữ liệu cũ
        User user = service.login(username.trim(), password.trim());
        if (user != null) {
            // Kiểm tra trạng thái kích hoạt tài khoản bằng OTP email
            if (user.getStatus() == 0) {
                String alertMsg = "Tài khoản của bạn chưa được kích hoạt qua mã OTP email! Vui lòng kiểm tra email hoặc kích hoạt tài khoản.";
                req.setAttribute("alert", alertMsg);
                req.setAttribute("unactivatedUsername", user.getUserName());
                req.setAttribute("unactivatedEmail", user.getEmail());
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("account", user);
            session.setAttribute("username", user.getUserName());

            if (isRememberMe) {
                saveRememberMe(req, resp, username.trim());
            }

            resp.sendRedirect(req.getContextPath() + "/waiting");
        } else {
            req.setAttribute("alert", "Tài khoản hoặc mật khẩu không chính xác!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }

    private void saveRememberMe(HttpServletRequest req, HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, username);
        cookie.setMaxAge(30 * 60);
        cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        response.addCookie(cookie);
    }
}
