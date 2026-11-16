package vn.iotstar.service.impl;

import java.sql.Date;

import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.UserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements IUserService, UserService {

    private UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        User user = findByUsername(username);
        if (user == null) {
            user = findByEmail(username);
        }
        if (user != null && password != null) {
            if (PasswordUtil.checkPassword(password, user.getPassWord())) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone) {
        String otp = EmailUtil.generateOtp();
        return registerWithOtp(username, password, email, fullname, phone, otp);
    }

    @Override
    public boolean registerWithOtp(String username, String password, String email, String fullname, String phone, String otp) {
        if (userDao.checkExistUsername(username) || userDao.checkExistEmail(email)) {
            return false;
        }
        long millis = System.currentTimeMillis();
        Date date = new Date(millis);
        User user = new User();
        user.setEmail(email != null ? email.trim() : null);
        user.setUserName(username != null ? username.trim() : null);
        user.setFullName(fullname != null ? fullname.trim() : username);
        // Mã hóa mật khẩu BCrypt trước khi lưu vào DB
        user.setPassWord(PasswordUtil.hashPassword(password.trim()));
        user.setAvatar("avatar.png");
        user.setRoleid(3);
        user.setPhone(phone);
        user.setCreatedDate(date);
        user.setStatus(0); // Chưa kích hoạt
        user.setCode(otp); // Lưu mã OTP kích hoạt

        userDao.insert(user);

        // Gửi email chứa OTP cho người dùng
        EmailUtil.sendOtpEmail(email, "Mã kích hoạt tài khoản Shopping JPA", otp, "Kích hoạt tài khoản mới");
        return true;
    }

    @Override
    public boolean verifyOtp(String usernameOrEmail, String otp) {
        if (usernameOrEmail == null || otp == null) {
            return false;
        }
        User user = findByUsername(usernameOrEmail);
        if (user == null) {
            user = findByEmail(usernameOrEmail);
        }
        if (user != null && user.getCode() != null && user.getCode().trim().equals(otp.trim())) {
            user.setStatus(1); // Kích hoạt thành công
            user.setCode(null); // Xóa mã OTP sau khi dùng
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean sendActivationOtp(String usernameOrEmail) {
        User user = findByUsername(usernameOrEmail);
        if (user == null) {
            user = findByEmail(usernameOrEmail);
        }
        if (user != null && user.getEmail() != null) {
            String newOtp = EmailUtil.generateOtp();
            user.setCode(newOtp);
            userDao.update(user);
            return EmailUtil.sendOtpEmail(user.getEmail(), "Mã kích hoạt tài khoản Shopping JPA", newOtp, "Gửi lại mã kích hoạt tài khoản");
        }
        return false;
    }

    @Override
    public boolean sendForgotPasswordOtp(String usernameOrEmail) {
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            return false;
        }
        User user = findByUsername(usernameOrEmail.trim());
        if (user == null) {
            user = findByEmail(usernameOrEmail.trim());
        }
        if (user != null && user.getEmail() != null && !user.getEmail().isEmpty()) {
            String otp = EmailUtil.generateOtp();
            user.setCode(otp);
            userDao.update(user);
            return EmailUtil.sendOtpEmail(user.getEmail(), "Mã OTP khôi phục mật khẩu Shopping JPA", otp, "Khôi phục mật khẩu tài khoản");
        }
        return false;
    }

    @Override
    public boolean resetPassword(String usernameOrEmail, String otp, String newPassword) {
        if (usernameOrEmail == null || otp == null || newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }
        User user = findByUsername(usernameOrEmail.trim());
        if (user == null) {
            user = findByEmail(usernameOrEmail.trim());
        }
        if (user != null && user.getCode() != null && user.getCode().trim().equals(otp.trim())) {
            // Mã hóa mật khẩu mới
            user.setPassWord(PasswordUtil.hashPassword(newPassword.trim()));
            user.setCode(null);
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }
}
