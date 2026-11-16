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
@WebServlet(urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String emailOrUsername = req.getParameter("emailOrUsername");
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập Email hoặc Tên đăng nhập của bạn!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        boolean sent = service.sendForgotPasswordOtp(emailOrUsername.trim());
        if (sent) {
            HttpSession session = req.getSession(true);
            session.setAttribute("resetUser", emailOrUsername.trim());
            resp.sendRedirect(req.getContextPath() + "/reset-password?user=" + emailOrUsername.trim());
        } else {
            req.setAttribute("alert", "Không tìm thấy tài khoản tương ứng với thông tin vừa nhập!");
            req.setAttribute("emailOrUsername", emailOrUsername);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
