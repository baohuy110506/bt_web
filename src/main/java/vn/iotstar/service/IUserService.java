package vn.iotstar.service;

import vn.iotstar.entity.User;

public interface IUserService {
    User login(String username, String password);
    User findByUsername(String username);
    User findByEmail(String email);
    User get(String username);
    void insert(User user);
    void update(User user);
    boolean register(String username, String password, String email, String fullname, String phone);
    boolean registerWithOtp(String username, String password, String email, String fullname, String phone, String otp);
    boolean verifyOtp(String usernameOrEmail, String otp);
    boolean sendActivationOtp(String usernameOrEmail);
    boolean sendForgotPasswordOtp(String usernameOrEmail);
    boolean resetPassword(String usernameOrEmail, String otp, String newPassword);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
}
