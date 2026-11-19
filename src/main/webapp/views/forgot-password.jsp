<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - Nhận Mã OTP</title>
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
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="card-custom">
            <div class="text-center mb-4">
                <i class="fa-solid fa-key fa-3x text-danger mb-2"></i>
                <h3 class="fw-bold mb-1">Quên Mật Khẩu</h3>
                <p class="text-muted small">Nhập tên đăng nhập hoặc email đã đăng ký để nhận mã OTP lấy lại mật khẩu</p>
            </div>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="needs-validation" novalidate id="forgotForm">
                <div class="mb-4">
                    <label class="form-label fw-semibold small">Tên đăng nhập hoặc Email <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-envelope-open text-secondary"></i></span>
                        <input type="text" 
                               name="emailOrUsername" 
                               id="emailOrUsername"
                               class="form-control ${not empty errors['emailOrUsername'] ? 'is-invalid' : ''}" 
                               placeholder="Nhập username hoặc email..." 
                               value="${emailOrUsername != null ? emailOrUsername : param.emailOrUsername}" 
                               required 
                               minlength="3">
                        <div class="invalid-feedback">
                            ${not empty errors['emailOrUsername'] ? errors['emailOrUsername'] : 'Vui lòng nhập tên đăng nhập hoặc email hợp lệ (tối thiểu 3 ký tự)!'}
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-paper-plane me-1"></i> Gửi Mã OTP Xác Nhận
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
