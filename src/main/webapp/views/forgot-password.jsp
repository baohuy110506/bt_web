<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - Nhận Mã OTP</title>
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
        .card {
            background: white;
            padding: 35px 40px;
            border-radius: 14px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }
        .icon-circle {
            width: 65px;
            height: 65px;
            background: #fee2e2;
            color: #ef4444;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 15px;
        }
        .card h2 {
            text-align: center;
            color: #1e293b;
            margin-bottom: 8px;
            font-size: 22px;
            font-weight: 700;
        }
        .desc {
            text-align: center;
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
        }
        .input-group {
            display: flex;
            align-items: center;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            overflow: hidden;
            transition: border-color 0.2s;
            margin-bottom: 20px;
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
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
        }
        .footer-links a {
            color: #0284c7;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-circle">
            <i class="fa fa-key"></i>
        </div>

        <h2>Quên Mật Khẩu?</h2>
        <p class="desc">Nhập Email hoặc Tên đăng nhập của tài khoản. Chúng tôi sẽ gửi mã OTP gồm 6 chữ số để bạn thiết lập lại mật khẩu.</p>

        <c:if test="${not empty alert}">
            <div class="alert-danger">
                <i class="fa fa-circle-exclamation"></i> ${alert}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="input-group">
                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                <input type="text" name="emailOrUsername" class="form-control" placeholder="Email hoặc Tên đăng nhập" value="${emailOrUsername}" required autofocus>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa fa-paper-plane"></i> Gửi Mã OTP Xác Nhận
            </button>
        </form>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/login">&larr; Quay lại Đăng nhập</a>
        </div>
    </div>
</body>
</html>
