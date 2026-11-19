package vn.iotstar.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class CloudinaryUtil {

    private static Cloudinary cloudinary;

    static {
        initCloudinary();
    }

    private static void initCloudinary() {
        String cloudName = EnvUtil.get("CLOUDINARY_CLOUD_NAME", "");
        String apiKey = EnvUtil.get("CLOUDINARY_API_KEY", "");
        String apiSecret = EnvUtil.get("CLOUDINARY_API_SECRET", "");

        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", cloudName);
        config.put("api_key", apiKey);
        config.put("api_secret", apiSecret);
        config.put("secure", "true");

        cloudinary = new Cloudinary(config);
    }

    /**
     * Upload file ảnh đại diện lên Cloudinary sử dụng Multipart (Jakarta Servlet Part)
     *
     * @param part Part từ request.getPart("avatarFile")
     * @return URL ảnh đã upload trên Cloudinary (hoặc fallback tên file cục bộ nếu chưa cấu hình Cloudinary)
     */
    public static String uploadImage(Part part) {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String cloudName = EnvUtil.get("CLOUDINARY_CLOUD_NAME", "");
        String apiKey = EnvUtil.get("CLOUDINARY_API_KEY", "");
        String apiSecret = EnvUtil.get("CLOUDINARY_API_SECRET", "");

        // 1. Nếu có cấu hình Cloudinary hợp lệ, tiến hành upload lên Cloudinary bằng multipart
        if (!cloudName.isEmpty() && !apiKey.isEmpty() && !apiSecret.isEmpty()) {
            try (InputStream is = part.getInputStream()) {
                byte[] fileBytes = is.readAllBytes();
                Map<?, ?> uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                        "folder", "webst2_avatars",
                        "resource_type", "image"
                ));
                if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                    String secureUrl = (String) uploadResult.get("secure_url");
                    System.out.println("[CLOUDINARY] Upload thành công ảnh lên Cloudinary: " + secureUrl);
                    return secureUrl;
                }
            } catch (Exception e) {
                System.err.println("[CLOUDINARY] Lỗi khi upload lên Cloudinary: " + e.getMessage() + ". Tiến hành fallback lưu cục bộ.");
            }
        }

        // 2. Fallback lưu file cục bộ (Constant.DIR) nếu Cloudinary chưa điền API Key hoặc mất kết nối
        try {
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            int dotIndex = submittedName.lastIndexOf(".");
            String ext = dotIndex > 0 ? submittedName.substring(dotIndex) : ".png";
            String localFileName = "avatar_" + System.currentTimeMillis() + ext;
            part.write(uploadPath + File.separator + localFileName);
            System.out.println("[LOCAL] Đã lưu file ảnh avatar cục bộ: " + localFileName);
            return localFileName;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
}
