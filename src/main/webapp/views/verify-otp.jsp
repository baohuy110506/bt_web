<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Thực Mã OTP Kích Hoạt Tài Khoản</title>
    <style>
        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
            min-height: calc(100vh - 200px);
        }
        .card-custom {
            background: white;
            padding: 35px 35px;
            border-radius: 14px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        .otp-input {
            letter-spacing: 6px;
            font-size: 1.35rem;
            text-align: center;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="card-custom">
            <div class="text-center mb-4">
                <i class="fa-solid fa-shield-halved fa-3x text-primary mb-2"></i>
                <h3 class="fw-bold mb-1">Xác Thực Mã OTP</h3>
                <p class="text-muted small">
                    Nhập mã xác thực gồm 6 chữ số đã được gửi tới email của tài khoản 
                    <strong class="text-primary">${username}</strong>
                </p>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-check me-2"></i> ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="needs-validation" novalidate id="otpForm">
                <input type="hidden" name="username" value="${username}">

                <div class="mb-4">
                    <label class="form-label fw-semibold small">Mã Xác Thực OTP (6 số) <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-key text-secondary"></i></span>
                        <input type="text" 
                               name="otp" 
                               id="otp" 
                               class="form-control otp-input" 
                               placeholder="123456" 
                               maxlength="6" 
                               pattern="^[0-9]{6}$" 
                               required 
                               autofocus>
                        <div class="invalid-feedback">
                            Vui lòng nhập đúng 6 chữ số mã OTP!
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-circle-check me-1"></i> Kích Hoạt Tài Khoản
                </button>
            </form>

            <div class="text-center mt-3 pt-3 border-top small">
                Chưa nhận được mã? 
                <a href="${pageContext.request.contextPath}/resend-otp?username=${username}" class="text-decoration-none text-primary fw-semibold">
                    <i class="fa fa-redo me-1"></i> Gửi lại mã OTP
                </a>
            </div>

            <div class="text-center mt-2 small">
                <a href="${pageContext.request.contextPath}/login" class="text-secondary text-decoration-none">
                    <i class="fa fa-arrow-left me-1"></i> Quay lại Đăng Nhập
                </a>
            </div>
        </div>
    </div>

    <script>
        (function () {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
