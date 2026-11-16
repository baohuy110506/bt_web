package vn.iotstar.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Mã hóa mật khẩu plain text bằng BCrypt chuẩn an toàn (org.mindrot.jbcrypt).
     * @param plainPassword mật khẩu dạng thô
     * @return chuỗi đã mã hóa BCrypt
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return plainPassword;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Kiểm tra mật khẩu plain text với mật khẩu đã mã hóa.
     * @param plainPassword mật khẩu người dùng nhập
     * @param storedPassword mật khẩu lưu trong cơ sở dữ liệu
     * @return true nếu khớp, ngược lại false
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        // Kiểm tra xem storedPassword có phải là định dạng hash BCrypt ($2a$, $2b$, $2y$) không
        if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
            try {
                return BCrypt.checkpw(plainPassword, storedPassword);
            } catch (Exception e) {
                return plainPassword.equals(storedPassword);
            }
        }
        // Trường hợp mật khẩu cũ trong database chưa hash
        return plainPassword.equals(storedPassword);
    }
}
