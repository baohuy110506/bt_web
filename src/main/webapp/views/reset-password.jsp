<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt Lại Mật Khẩu Mới</title>
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
            letter-spacing: 4px;
            font-size: 1.25rem;
            text-align: center;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="card-custom">
            <div class="text-center mb-4">
                <i class="fa-solid fa-lock-open fa-3x text-primary mb-2"></i>
                <h3 class="fw-bold mb-1">Đặt Lại Mật Khẩu</h3>
                <p class="text-muted small">Nhập mã OTP vừa nhận qua email và thiết lập mật khẩu mới</p>
            </div>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="post" class="needs-validation" novalidate id="resetForm">
                <input type="hidden" name="user" value="${user}">

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Mã xác thực OTP (6 chữ số) <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-shield-alt text-secondary"></i></span>
                        <input type="text" 
                               name="otp" 
                               id="otp"
                               class="form-control otp-input ${not empty errors['otp'] ? 'is-invalid' : ''}" 
                               placeholder="123456" 
                               value="${otp != null ? otp : param.otp}" 
                               required 
                               maxlength="6" 
                               pattern="^[0-9]{6}$">
                        <div class="invalid-feedback">
                            ${not empty errors['otp'] ? errors['otp'] : 'Vui lòng nhập đúng 6 chữ số mã OTP!'}
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Mật khẩu mới <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-lock text-secondary"></i></span>
                        <input type="password" 
                               name="newPassword" 
                               id="newPassword"
                               class="form-control ${not empty errors['newPassword'] ? 'is-invalid' : ''}" 
                               placeholder="Tối thiểu 6 ký tự" 
                               required 
                               minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['newPassword'] ? errors['newPassword'] : 'Mật khẩu mới phải có tối thiểu 6 ký tự!'}
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-check-double text-secondary"></i></span>
                        <input type="password" 
                               name="confirmPassword" 
                               id="confirmPassword"
                               class="form-control ${not empty errors['confirmPassword'] ? 'is-invalid' : ''}" 
                               placeholder="Nhập lại mật khẩu mới" 
                               required>
                        <div class="invalid-feedback" id="confirmFeedback">
                            ${not empty errors['confirmPassword'] ? errors['confirmPassword'] : 'Vui lòng xác nhận mật khẩu mới trùng khớp!'}
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-check-circle me-1"></i> Lưu Mật Khẩu Mới
                </button>
            </form>

            <div class="text-center mt-4 pt-3 border-top small">
                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-secondary">
                    <i class="fa fa-arrow-left me-1"></i> Quay lại Đăng Nhập
                </a>
            </div>
        </div>
    </div>

    <script>
        (function () {
            'use strict';
            const form = document.getElementById('resetForm');
            const pass = document.getElementById('newPassword');
            const confirm = document.getElementById('confirmPassword');
            const confirmFeedback = document.getElementById('confirmFeedback');

            function validateMatch() {
                if (confirm.value && confirm.value !== pass.value) {
                    confirm.setCustomValidity('Mật khẩu xác nhận không khớp');
                    confirmFeedback.textContent = 'Mật khẩu xác nhận không trùng khớp!';
                } else {
                    confirm.setCustomValidity('');
                    confirmFeedback.textContent = 'Vui lòng xác nhận mật khẩu mới trùng khớp!';
                }
            }

            pass.addEventListener('input', validateMatch);
            confirm.addEventListener('input', validateMatch);

            form.addEventListener('submit', function (event) {
                validateMatch();
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
