<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập Vào Hệ Thống</title>
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
            padding: 20px;
        }
        .login-card {
            background: white;
            padding: 35px 40px;
            border-radius: 14px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }
        .login-card h2 {
            text-align: center;
            color: #1e293b;
            margin-bottom: 22px;
            font-size: 24px;
            font-weight: 700;
        }
        .alert-danger {
            background: #fee2e2;
            color: #b91c1c;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #ef4444;
            line-height: 1.5;
        }
        .alert-success {
            background: #dcfce7;
            color: #15803d;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #22c55e;
            line-height: 1.5;
        }
        .form-group {
            margin-bottom: 18px;
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
            padding: 12px 14px;
            background: #f1f5f9;
            color: #64748b;
            font-size: 15px;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: none;
            outline: none;
            font-size: 15px;
        }
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            font-size: 14px;
            color: #475569;
        }
        .btn-submit {
            width: 100%;
            padding: 13px;
            background: #0284c7;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-submit:hover {
            background: #0369a1;
        }
        .footer-links {
            display: flex;
            justify-content: space-between;
            margin-top: 22px;
            font-size: 14px;
            color: #64748b;
        }
        .footer-links a {
            color: #0284c7;
            text-decoration: none;
            font-weight: 600;
        }
        .demo-accounts {
            margin-top: 20px;
            padding: 12px;
            background: #f8fafc;
            border-radius: 8px;
            font-size: 12px;
            color: #64748b;
            border: 1px dashed #cbd5e1;
            line-height: 1.7;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Đăng Nhập Vào Hệ Thống</h2>

        <c:if test="${not empty successMsg}">
            <div class="alert-success">
                <i class="fa fa-circle-check"></i> ${successMsg}
            </div>
        </c:if>

        <c:if test="${not empty alert}">
            <div class="alert-danger">
                <i class="fa fa-circle-exclamation"></i> ${alert}
                <c:if test="${not empty unactivatedUsername}">
                    <div style="margin-top: 8px;">
                        <a href="${pageContext.request.contextPath}/verify-otp?username=${unactivatedUsername}" style="color: #0284c7; font-weight: 700;">
                            👉 Bấm vào đây để nhập mã OTP kích hoạt tài khoản
                        </a>
                    </div>
                </c:if>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-user"></i></span>
                    <input type="text" placeholder="Tài khoản hoặc Email" name="username" class="form-control" value="${param.username != null ? param.username : unactivatedUsername}" required>
                </div>
            </div>

            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                    <input type="password" placeholder="Mật khẩu" name="password" class="form-control" required>
                </div>
            </div>

            <div class="options-row">
                <label style="cursor: pointer; display: flex; align-items: center; gap: 6px;">
                    <input type="checkbox" name="remember" value="on"> Nhớ tôi (Cookie)
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password" style="color: #ef4444; text-decoration: none; font-weight: 500;">
                    <i class="fa fa-key"></i> Quên mật khẩu?
                </a>
            </div>

            <button type="submit" class="btn-submit">Đăng nhập</button>
        </form>

        <div class="footer-links">
            <span>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></span>
            <a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i> Trang chủ</a>
        </div>

        <div class="demo-accounts">
            <strong>Tài khoản có sẵn trong DB webst2:</strong><br>
            • Admin: <code>admin</code> / <code>123456</code><br>
            • Manager: <code>manager</code> / <code>123456</code><br>
            • User: <code>user</code> / <code>123456</code><br>
            <em>Mật khẩu được mã hóa an toàn bằng thuật toán BCrypt.</em>
        </div>
    </div>
</body>
</html>
