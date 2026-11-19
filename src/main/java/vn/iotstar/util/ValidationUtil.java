package vn.iotstar.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    // Regex kiểm tra định dạng email
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // Regex kiểm tra số điện thoại Việt Nam (10 hoặc 11 số, bắt đầu bằng 0 hoặc +84)
    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^(0|\\+84)[3|5|7|8|9][0-9]{8}$");

    // Regex kiểm tra tên đăng nhập (chữ cái, số, dấu gạch dưới, từ 3-30 ký tự)
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_]{3,30}$");

    // Regex kiểm tra mã Video (chữ cái, số, gạch nối, gạch dưới, từ 2-50 ký tự)
    private static final Pattern VIDEO_ID_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_-]{2,50}$");

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone.trim().replaceAll("\\s+", "")).matches();
    }

    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidVideoId(String videoId) {
        if (videoId == null || videoId.trim().isEmpty()) {
            return false;
        }
        return VIDEO_ID_PATTERN.matcher(videoId.trim()).matches();
    }

    public static boolean isValidImageExtension(String filename) {
        if (filename == null || filename.trim().isEmpty()) {
            return true; // Không bắt buộc nếu không chọn file
        }
        String lower = filename.trim().toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                || lower.endsWith(".png") || lower.endsWith(".webp")
                || lower.endsWith(".gif");
    }
}
