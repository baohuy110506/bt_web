package vn.iotstar.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class EnvUtil {
    private static final Map<String, String> envMap = new HashMap<>();
    private static boolean isLoaded = false;

    static {
        loadEnv();
    }

    private static synchronized void loadEnv() {
        if (isLoaded) return;

        // 1. Thử đọc file .env từ thư mục gốc của project hoặc user.dir
        String[] potentialPaths = {
            ".env",
            "D:\\HK1 - 26- 27\\lap trinh web\\bt3\\.env",
            System.getProperty("user.dir") + File.separator + ".env"
        };

        boolean loadedFromFile = false;
        for (String path : potentialPaths) {
            File file = new File(path);
            if (file.exists() && file.isFile()) {
                try (FileInputStream fis = new FileInputStream(file);
                     BufferedReader reader = new BufferedReader(new InputStreamReader(fis, StandardCharsets.UTF_8))) {
                    parseEnv(reader);
                    loadedFromFile = true;
                    System.out.println("[ENV] Đã nạp thành công biến môi trường từ file: " + file.getAbsolutePath());
                    break;
                } catch (Exception e) {
                    System.err.println("[ENV] Lỗi đọc file .env tại " + path + ": " + e.getMessage());
                }
            }
        }

        // 2. Nếu chưa đọc được từ file ổ đĩa, thử đọc từ classpath (src/main/resources/.env)
        if (!loadedFromFile) {
            try (InputStream is = EnvUtil.class.getClassLoader().getResourceAsStream(".env")) {
                if (is != null) {
                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                        parseEnv(reader);
                        System.out.println("[ENV] Đã nạp biến môi trường từ classpath .env");
                    }
                }
            } catch (Exception ignored) {}
        }

        isLoaded = true;
    }

    private static void parseEnv(BufferedReader reader) throws Exception {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            // Bỏ qua dòng trống hoặc dòng chú thích
            if (line.isEmpty() || line.startsWith("#")) {
                continue;
            }
            int equalIndex = line.indexOf('=');
            if (equalIndex > 0) {
                String key = line.substring(0, equalIndex).trim();
                String value = line.substring(equalIndex + 1).trim();

                // Loại bỏ dấu ngoặc kép hoặc ngoặc đơn nếu có
                if ((value.startsWith("\"") && value.endsWith("\"")) ||
                    (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.substring(1, value.length() - 1);
                }
                envMap.put(key, value);
            }
        }
    }

    /**
     * Lấy giá trị biến môi trường theo thứ tự ưu tiên:
     * 1. System.getenv (Biến môi trường hệ điều hành)
     * 2. System.getProperty (JVM property)
     * 3. Giá trị trong file .env
     * 4. defaultValue mặc định nếu không tìm thấy
     */
    public static String get(String key, String defaultValue) {
        // 1. Kiểm tra biến môi trường OS
        String osEnv = System.getenv(key);
        if (osEnv != null && !osEnv.trim().isEmpty()) {
            return osEnv.trim();
        }

        // 2. Kiểm tra System Property
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }

        // 3. Kiểm tra trong Map nạp từ file .env
        String fileVal = envMap.get(key);
        if (fileVal != null && !fileVal.trim().isEmpty()) {
            return fileVal.trim();
        }

        return defaultValue;
    }

    public static String get(String key) {
        return get(key, "");
    }
}
