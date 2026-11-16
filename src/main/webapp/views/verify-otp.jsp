<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Thực OTP Kích Hoạt Tài Khoản</title>
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
        .otp-card {
            background: white;
            padding: 35px 40px;
            border-radius: 14px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
            text-align: center;
        }
        .icon-circle {
            width: 70px;
            height: 70px;
            background: #e0f2fe;
            color: #0284c7;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin: 0 auto 18px;
        }
        .otp-card h2 {
            color: #1e293b;
            margin-bottom: 8px;
            font-size: 22px;
            font-weight: 700;
        }
        .desc {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 22px;
            line-height: 1.5;
        }
        .alert-danger {
            background: #fee2e2;
            color: #b91c1c;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #ef4444;
            text-align: left;
        }
        .alert-success {
            background: #dcfce7;
            color: #15803d;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #22c55e;
            text-align: left;
        }
        .otp-input {
            width: 100%;
            padding: 14px;
            font-size: 24px;
            text-align: center;
            letter-spacing: 8px;
            font-weight: 700;
            border: 2px solid #cbd5e1;
            border-radius: 8px;
            outline: none;
            color: #1e293b;
            transition: border-color 0.2s;
            margin-bottom: 20px;
        }
        .otp-input:focus {
            border-color: #0284c7;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
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
        .resend-box {
            margin-top: 22px;
            font-size: 14px;
            color: #64748b;
        }
        .resend-box a {
            color: #0284c7;
            text-decoration: none;
            font-weight: 600;
        }
        .console-tip {
            margin-top: 20px;
            padding: 10px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 8px;
            font-size: 12px;
            color: #475569;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="otp-card">
        <div class="icon-circle">
            <i class="fa fa-envelope-open-text"></i>
        </div>

        <h2>Xác Thực Kích Hoạt Tài Khoản</h2>
        <p class="desc">
            Vui lòng nhập mã OTP gồm 6 chữ số được gửi đến email của bạn để kích hoạt tài khoản
            <c:if test="${not empty username}"><strong>(${username})</strong></c:if>.
        </p>

        <c:if test="${not empty alert}">
            <div class="alert-danger">
                <i class="fa fa-circle-exclamation"></i> ${alert}
            </div>
        </c:if>

        <c:if test="${not empty msg}">
            <div class="alert-success">
                <i class="fa fa-circle-check"></i> ${msg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <input type="hidden" name="username" value="${username}">
            
            <input type="text" name="otp" class="otp-input" maxlength="6" placeholder="000000" pattern="[0-9]{6}" required autofocus>

            <button type="submit" class="btn-submit">
                <i class="fa fa-check-circle"></i> Kích Hoạt Tài Khoản
            </button>
        </form>

        <div class="resend-box">
            Chưa nhận được mã? 
            <a href="${pageContext.request.contextPath}/resend-otp?username=${username}">
                <i class="fa fa-rotate-right"></i> Gửi lại mã OTP
            </a>
        </div>

        <div class="console-tip">
            💡 <strong>Mẹo kiểm thử:</strong> Nếu đang test môi trường local chưa cấu hình Gmail App Password, bạn hãy mở <strong>Console/Terminal</strong> của máy chủ Eclipse/Tomcat để xem mã OTP in tự động!
        </div>

        <div style="margin-top: 15px; font-size: 13px;">
            <a href="${pageContext.request.contextPath}/login" style="color: #64748b; text-decoration: none;">&larr; Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>
