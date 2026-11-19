<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập Vào Hệ Thống</title>
    <style>
        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
            min-height: calc(100vh - 200px);
        }
        .login-card {
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
        <div class="login-card">
            <div class="text-center mb-4">
                <i class="fa-solid fa-circle-user fa-3x text-primary mb-2"></i>
                <h3 class="fw-bold mb-1">Đăng Nhập</h3>
                <p class="text-muted small">Chào mừng bạn quay lại hệ thống quản lý Media</p>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-check me-2"></i> ${successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <c:if test="${not empty unactivatedUsername}">
                        <div class="mt-2">
                            <a href="${pageContext.request.contextPath}/verify-otp?username=${unactivatedUsername}" class="btn btn-sm btn-outline-danger">
                                <i class="fa fa-key me-1"></i> Nhập mã OTP kích hoạt ngay
                            </a>
                        </div>
                    </c:if>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM ĐĂNG NHẬP VỚI CLIENT & SERVER VALIDATION -->
            <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate id="loginForm">
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Tài khoản hoặc Email <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-user text-secondary"></i></span>
                        <input type="text" 
                               placeholder="Nhập username hoặc email" 
                               name="username" 
                               id="username"
                               class="form-control ${not empty errors['username'] ? 'is-invalid' : ''}" 
                               value="${username != null ? username : (param.username != null ? param.username : unactivatedUsername)}" 
                               required 
                               minlength="3">
                        <div class="invalid-feedback">
                            ${not empty errors['username'] ? errors['username'] : 'Vui lòng nhập tài khoản hoặc email hợp lệ (tối thiểu 3 ký tự)!'}
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-lock text-secondary"></i></span>
                        <input type="password" 
                               placeholder="Nhập mật khẩu" 
                               name="password" 
                               id="password"
                               class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}" 
                               required 
                               minlength="4">
                        <div class="invalid-feedback">
                            ${not empty errors['password'] ? errors['password'] : 'Vui lòng nhập mật khẩu (tối thiểu 4 ký tự)!'}
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="remember" id="rememberMe" value="on">
                        <label class="form-check-label small text-muted" for="rememberMe">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="small text-danger text-decoration-none fw-semibold">
                        Quên mật khẩu?
                    </a>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-sign-in-alt me-1"></i> Đăng Nhập
                </button>
            </form>

            <div class="text-center mt-4 pt-3 border-top small text-muted">
                Chưa có tài khoản? 
                <a href="${pageContext.request.contextPath}/register" class="text-primary text-decoration-none fw-semibold">
                    Đăng ký ngay
                </a>
            </div>

            <div class="mt-3 p-3 bg-light rounded-3 small border border-dashed">
                <span class="fw-bold text-dark"><i class="fa fa-info-circle text-primary me-1"></i>Tài khoản test trong DB:</span><br>
                &bull; Admin: <code>admin</code> / <code>123456</code><br>
                &bull; User: <code>user</code> / <code>123456</code>
            </div>
        </div>
    </div>

    <!-- Script kích hoạt Bootstrap 5 Client-side validation -->
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
