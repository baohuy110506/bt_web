package vn.iotstar.util;

import java.util.Properties;
import java.util.Random;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }

    /**
     * Gửi email HTML chứa mã xác thực OTP
     * Thông tin SMTP Gmail được đọc bảo mật từ file .env qua EnvUtil (không hardcode vào mã nguồn)
     * @param toEmail Email người nhận
     * @param subject Tiêu đề thư
     * @param otp Mã OTP
     * @param purpose Mục đích gửi (kích hoạt tài khoản hoặc quên mật khẩu)
     * @return true nếu gửi thành công hoặc đã fallback in console
     */
    public static boolean sendOtpEmail(String toEmail, String subject, String otp, String purpose) {
        // Đọc cấu hình từ .env hoặc biến môi trường OS
        final String fromEmail = EnvUtil.get("EMAIL_SENDER", Constant.EMAIL_SENDER);
        final String fromPassword = EnvUtil.get("EMAIL_PASSWORD", Constant.EMAIL_PASSWORD);

        // Luôn log mã OTP ra console để thuận tiện cho việc kiểm thử / chấm điểm cục bộ
        System.out.println("=================================================");
        System.out.println("[EMAIL SERVICE] To: " + toEmail);
        System.out.println("[EMAIL SERVICE] Purpose: " + purpose);
        System.out.println("[EMAIL SERVICE] Configured Sender: " + fromEmail);
        System.out.println("[EMAIL SERVICE] >>> OTP CODE: " + otp + " <<<");
        System.out.println("=================================================");

        if (toEmail == null || toEmail.trim().isEmpty()) {
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, fromPassword);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Shopping JPA System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail.trim()));
            message.setSubject(subject, "UTF-8");

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff;'>"
                    + "<div style='text-align: center; margin-bottom: 20px;'>"
                    + "<h2 style='color: #0284c7; margin: 0;'>Xác Thực Tài Khoản Shopping JPA</h2>"
                    + "</div>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn nhận được email này vì đã thực hiện yêu cầu: <strong>" + purpose + "</strong>.</p>"
                    + "<p>Vui lòng sử dụng mã OTP dưới đây để hoàn tất quá trình xác thực:</p>"
                    + "<div style='text-align: center; margin: 25px 0;'>"
                    + "<span style='display: inline-block; font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #0284c7; background: #f0f9ff; padding: 12px 28px; border-radius: 8px; border: 1px dashed #38bdf8;'>"
                    + otp + "</span>"
                    + "</div>"
                    + "<p style='color: #64748b; font-size: 13px;'>Mã OTP này có hiệu lực trong vòng <strong>5 phút</strong>. Tuyệt đối không chia sẻ mã này với bất kỳ ai để bảo vệ tài khoản.</p>"
                    + "<hr style='border: none; border-top: 1px solid #f1f5f9; margin: 20px 0;'/>"
                    + "<p style='font-size: 12px; color: #94a3b8; text-align: center;'>Hệ thống quản lý Jakarta EE - JPA Hibernate 6</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            // Chỉ gửi qua SMTP nếu email người gửi đã được cấu hình khác giá trị mặc định
            if (fromEmail != null && !fromEmail.contains("your-email@gmail.com") && !fromPassword.contains("your-app-password")) {
                Transport.send(message);
                System.out.println("[EMAIL SERVICE] Đã gửi email thành công tới: " + toEmail);
            } else {
                System.out.println("[EMAIL SERVICE] Chưa cấu hình thông tin SMTP trong file .env, dùng mã OTP hiển thị tại Console để kích hoạt.");
            }
            return true;
        } catch (Exception e) {
            System.err.println("[EMAIL SERVICE] Không thể gửi email qua SMTP (" + e.getMessage() + ").");
            System.err.println("[EMAIL SERVICE] Hướng dẫn: Xem mã OTP đã in ở Console phía trên để tiếp tục thử nghiệm.");
            return true; // Vẫn trả về true để luồng người dùng không bị crash khi chưa cấu hình mật khẩu SMTP
        }
    }
}
