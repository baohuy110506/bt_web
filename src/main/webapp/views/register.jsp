<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Tài Khoản Mới</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body {
            background: linear-gradient(135deg, #1e293b 0%, #0284c7 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 25px 20px;
        }
        .register-card {
            background: white;
            padding: 35px 40px;
            border-radius: 14px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }
        .register-card h2 {
            text-align: center;
            color: #1e293b;
            margin-bottom: 8px;
            font-size: 24px;
            font-weight: 700;
        }
        .sub-desc {
            text-align: center;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 22px;
        }
        .alert-danger {
            background: #fee2e2;
            color: #b91c1c;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #ef4444;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
        }
        .input-group {
            display: flex;
            align-items: center;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .input-group:focus-within {
            border-color: #0284c7;
        }
        .input-group-addon {
            padding: 11px 14px;
            background: #f1f5f9;
            color: #64748b;
            font-size: 14px;
        }
        .form-control {
            width: 100%;
            padding: 11px 12px;
            border: none;
            outline: none;
            font-size: 14px;
        }
        .btn-submit {
            width: 100%;
            padding: 13px;
            background: #0284c7;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #0369a1;
        }
        .footer-text {
            text-align: center;
            margin-top: 20px;
            color: #64748b;
            font-size: 14px;
        }
        .footer-text a {
            color: #0284c7;
            text-decoration: none;
            font-weight: 600;
        }
        .otp-notice {
            background: #f0fdf4;
            border: 1px dashed #86efac;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 12px;
            color: #166534;
            margin-top: 15px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="register-card">
        <h2>Tạo Tài Khoản Mới</h2>
        <p class="sub-desc">Đăng ký tài khoản và kích hoạt bằng mã OTP gửi về Email</p>

        <c:if test="${alert != null}">
            <div class="alert-danger">
                <i class="fa fa-circle-exclamation"></i> ${alert}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label>Tên đăng nhập <span style="color:#ef4444;">*</span></label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-user"></i></span>
                    <input type="text" placeholder="Nhập tên đăng nhập" name="username" class="form-control" value="${param.username}" required>
                </div>
            </div>

            <div class="form-group">
                <label>Email nhận mã OTP <span style="color:#ef4444;">*</span></label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                    <input type="email" placeholder="example@email.com" name="email" class="form-control" value="${param.email}" required>
                </div>
            </div>

            <div class="form-group">
                <label>Họ và tên</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-id-card"></i></span>
                    <input type="text" placeholder="Nhập họ và tên đầy đủ" name="fullname" class="form-control" value="${param.fullname}">
                </div>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                    <input type="tel" placeholder="Nhập số điện thoại" name="phone" class="form-control" value="${param.phone}">
                </div>
            </div>

            <div class="form-group">
                <label>Mật khẩu <span style="color:#ef4444;">*</span></label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                    <input type="password" placeholder="Nhập mật khẩu (sẽ được mã hóa BCrypt)" name="password" class="form-control" required>
                </div>
            </div>

            <div class="form-group">
                <label>Xác nhận mật khẩu <span style="color:#ef4444;">*</span></label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-check-double"></i></span>
                    <input type="password" placeholder="Nhập lại mật khẩu" name="repassword" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn-submit"><i class="fa fa-paper-plane"></i> Đăng ký & Nhận mã OTP</button>
        </form>

        <div class="otp-notice">
            <i class="fa fa-shield-halved"></i> <strong>Lưu ý bảo mật:</strong> Sau khi nhấn Đăng ký, hệ thống sẽ gửi mã OTP gồm 6 chữ số đến email để kích hoạt tài khoản của bạn. Mật khẩu sẽ được băm bằng chuẩn BCrypt.
        </div>

        <div class="footer-text">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a> | <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
        </div>
    </div>
</body>
</html>
