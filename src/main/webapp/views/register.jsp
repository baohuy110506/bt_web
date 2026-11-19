<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Tài Khoản Mới</title>
    <style>
        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
            min-height: calc(100vh - 200px);
        }
        .register-card {
            background: white;
            padding: 35px 35px;
            border-radius: 14px;
            width: 100%;
            max-width: 520px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="register-card">
            <div class="text-center mb-4">
                <i class="fa-solid fa-user-plus fa-3x text-primary mb-2"></i>
                <h3 class="fw-bold mb-1">Tạo Tài Khoản</h3>
                <p class="text-muted small">Đăng ký và xác thực kích hoạt an toàn bằng mã OTP Email</p>
            </div>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM ĐĂNG KÝ VỚI CLIENT & SERVER VALIDATION -->
            <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate id="registerForm">
                
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Tên đăng nhập <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-user text-secondary"></i></span>
                        <input type="text" 
                               name="username" 
                               id="username"
                               class="form-control ${not empty errors['username'] ? 'is-invalid' : ''}" 
                               placeholder="Ví dụ: nguyen_van_a (3-30 ký tự)" 
                               value="${username != null ? username : param.username}" 
                               required 
                               pattern="^[a-zA-Z0-9_]{3,30}$">
                        <div class="invalid-feedback">
                            ${not empty errors['username'] ? errors['username'] : 'Tên đăng nhập từ 3-30 ký tự chữ, số hoặc dấu gạch dưới!'}
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Địa chỉ Email <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-envelope text-secondary"></i></span>
                        <input type="email" 
                               name="email" 
                               id="email"
                               class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}" 
                               placeholder="example@gmail.com" 
                               value="${email != null ? email : param.email}" 
                               required 
                               pattern="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$">
                        <div class="invalid-feedback">
                            ${not empty errors['email'] ? errors['email'] : 'Vui lòng nhập định dạng email hợp lệ!'}
                        </div>
                    </div>
                </div>

                <div class="row g-2 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Họ và tên</label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa fa-id-card text-secondary"></i></span>
                            <input type="text" 
                                   name="fullname" 
                                   id="fullname"
                                   class="form-control ${not empty errors['fullname'] ? 'is-invalid' : ''}" 
                                   placeholder="Nguyễn Văn A" 
                                   value="${fullname != null ? fullname : param.fullname}">
                            <div class="invalid-feedback">
                                ${errors['fullname']}
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Số điện thoại</label>
                        <div class="input-group has-validation">
                            <span class="input-group-text"><i class="fa fa-phone text-secondary"></i></span>
                            <input type="tel" 
                                   name="phone" 
                                   id="phone"
                                   class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" 
                                   placeholder="0912345678" 
                                   value="${phone != null ? phone : param.phone}"
                                   pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$">
                            <div class="invalid-feedback">
                                ${not empty errors['phone'] ? errors['phone'] : 'SĐT VN 10 số (bắt đầu bằng 03, 05, 07, 08, 09)!'}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-lock text-secondary"></i></span>
                        <input type="password" 
                               name="password" 
                               id="password"
                               class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}" 
                               placeholder="Tối thiểu 6 ký tự" 
                               required 
                               minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['password'] ? errors['password'] : 'Mật khẩu phải có ít nhất 6 ký tự!'}
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group has-validation">
                        <span class="input-group-text"><i class="fa fa-check-double text-secondary"></i></span>
                        <input type="password" 
                               name="repassword" 
                               id="repassword"
                               class="form-control ${not empty errors['repassword'] ? 'is-invalid' : ''}" 
                               placeholder="Nhập lại mật khẩu" 
                               required>
                        <div class="invalid-feedback" id="repasswordFeedback">
                            ${not empty errors['repassword'] ? errors['repassword'] : 'Vui lòng xác nhận mật khẩu trùng khớp!'}
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    <i class="fa fa-paper-plane me-1"></i> Đăng Ký & Nhận Mã OTP
                </button>
            </form>

            <div class="mt-3 p-3 bg-light rounded-3 small text-success border border-success-subtle">
                <i class="fa fa-shield-halved me-1"></i>
                <strong>Bảo mật:</strong> Sau khi đăng ký, hệ thống sẽ gửi mã OTP 6 số đến email để kích hoạt. Mật khẩu được mã hóa an toàn bằng thuật toán BCrypt.
            </div>

            <div class="text-center mt-3 pt-3 border-top small text-muted">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/login" class="text-primary text-decoration-none fw-semibold">
                    Đăng nhập tại đây
                </a>
            </div>
        </div>
    </div>

    <!-- Script kích hoạt Bootstrap 5 Client-side validation & Kiểm tra mật khẩu khớp -->
    <script>
        (function () {
            'use strict';
            const form = document.getElementById('registerForm');
            const pass = document.getElementById('password');
            const repass = document.getElementById('repassword');
            const repassFeedback = document.getElementById('repasswordFeedback');

            function validatePasswordMatch() {
                if (repass.value && repass.value !== pass.value) {
                    repass.setCustomValidity('Mật khẩu xác nhận không khớp');
                    repassFeedback.textContent = 'Mật khẩu xác nhận không trùng khớp!';
                } else {
                    repass.setCustomValidity('');
                    repassFeedback.textContent = 'Vui lòng xác nhận mật khẩu trùng khớp!';
                }
            }

            pass.addEventListener('input', validatePasswordMatch);
            repass.addEventListener('input', validatePasswordMatch);

            form.addEventListener('submit', function (event) {
                validatePasswordMatch();
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
