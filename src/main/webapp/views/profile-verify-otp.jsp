<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Thực OTP Cập Nhật Email Mới</title>
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
            max-width: 480px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        .otp-input {
            letter-spacing: 6px;
            font-size: 1.4rem;
            text-align: center;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="card-custom text-center">
            <div class="mb-3">
                <i class="fa-solid fa-envelope-circle-check fa-3x text-primary"></i>
            </div>
            
            <h4 class="fw-bold mb-1">Xác Nhận Email Mới</h4>
            <p class="text-muted small mb-3">
                Hệ thống đã gửi một mã OTP gồm 6 chữ số đến địa chỉ email mới:
                <br><strong class="text-primary fs-6">${newEmail}</strong>
            </p>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show text-start" role="alert">
                    <i class="fa fa-circle-check me-2"></i> ${successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show text-start" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/profile/verify-otp" method="post" class="needs-validation text-start" novalidate id="otpForm">
                <div class="mb-4">
                    <label class="form-label fw-semibold small">Nhập mã xác thực OTP (6 chữ số) <span class="text-danger">*</span></label>
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
                    <div class="form-text text-muted small mt-1">
                        Kiểm tra hộp thư đến (Inbox) hoặc Spam của email mới để nhận mã.
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-check-circle me-1"></i> Xác Nhận Cập Nhật Email
                </button>
            </form>

            <div class="mt-4 pt-3 border-top small text-muted">
                Chưa nhận được mã OTP? 
                <a href="${pageContext.request.contextPath}/user/profile/resend-otp" class="text-primary text-decoration-none fw-semibold">
                    <i class="fa fa-redo me-1"></i> Gửi lại mã OTP
                </a>
            </div>

            <div class="mt-2 small">
                <a href="${pageContext.request.contextPath}/user/profile" class="text-secondary text-decoration-none">
                    <i class="fa fa-arrow-left me-1"></i> Hủy bỏ & Quay lại trang Profile
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
