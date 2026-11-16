package vn.iotstar.util;

import java.io.File;

public class Constant {
    public static final String SESSION_USERNAME = "username";
    public static final String SESSION_ACCOUNT = "account";
    public static final String COOKIE_REMEMBER = "username";
    public static final String DIR = "D:\\upload";

    // Cấu hình gửi mail OTP được nạp tự động và bảo mật từ file .env hoặc biến môi trường OS
    // Không còn hardcode trong mã nguồn, an toàn tuyệt đối khi push lên GitHub!
    public static final String EMAIL_SENDER = EnvUtil.get("EMAIL_SENDER", "your-email@gmail.com");
    public static final String EMAIL_PASSWORD = EnvUtil.get("EMAIL_PASSWORD", "your-app-password");

    public static class Path {
        public static final String ADMIN_CATEGORY_LIST = "/views/admin/category-list.jsp";
        public static final String ADMIN_CATEGORY_ADD = "/views/admin/category-add.jsp";
        public static final String ADMIN_CATEGORY_EDIT = "/views/admin/category-edit.jsp";

        public static final String ADMIN_VIDEO_LIST = "/views/admin/video-list.jsp";
        public static final String ADMIN_VIDEO_ADD = "/views/admin/video-add.jsp";
        public static final String ADMIN_VIDEO_EDIT = "/views/admin/video-edit.jsp";

        public static final String USER_VIDEO_LIST = "/views/video/video-list.jsp";
        public static final String VIDEO_DETAIL = "/views/video/video-detail.jsp";
        public static final String VERIFY_OTP = "/views/verify-otp.jsp";
        public static final String FORGOT_PASSWORD = "/views/forgot-password.jsp";
        public static final String RESET_PASSWORD = "/views/reset-password.jsp";
    }

    static {
        File uploadDir = new File(DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }
}
