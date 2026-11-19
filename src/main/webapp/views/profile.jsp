<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Cá Nhân - Thông Tin Người Dùng</title>
    <style>
        .profile-header {
            background: linear-gradient(135deg, #0f172a 0%, #0284c7 100%);
            color: white;
            padding: 35px 0;
            margin-bottom: 30px;
        }
        .profile-avatar-lg {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        .avatar-preview-box {
            position: relative;
            display: inline-block;
        }
        .cloudinary-badge {
            background: linear-gradient(135deg, #2563eb, #38bdf8);
            color: white;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
    </style>
</head>
<body>

    <!-- Header Banner Profile -->
    <div class="profile-header">
        <div class="container">
            <div class="d-flex align-items-center gap-3">
                <i class="fa-solid fa-id-badge fa-2x text-info"></i>
                <div>
                    <h3 class="fw-bold mb-1">Hồ Sơ Người Dùng</h3>
                    <p class="mb-0 text-light opacity-75 small">Quản lý thông tin cá nhân, cập nhật email xác nhận OTP và ảnh đại diện Cloudinary</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa fa-circle-check me-2"></i> ${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty alert}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- CỘT TRÁI: THẺ TỔNG QUAN USER & AVATAR -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm text-center p-4">
                    <div class="avatar-preview-box mx-auto mb-3">
                        <c:choose>
                            <c:when test="${not empty user.avatar && user.avatar.startsWith('http')}">
                                <img src="${user.avatar}" alt="Avatar" id="avatarPreview" class="profile-avatar-lg">
                            </c:when>
                            <c:when test="${not empty user.avatar}">
                                <img src="${pageContext.request.contextPath}/image?fname=${user.avatar}" alt="Avatar" id="avatarPreview" class="profile-avatar-lg">
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&auto=format&fit=crop" alt="Avatar" id="avatarPreview" class="profile-avatar-lg">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h5 class="fw-bold mb-1">${user.fullName != null ? user.fullName : user.userName}</h5>
                    <p class="text-muted small mb-2">@${user.userName}</p>

                    <div>
                        <c:choose>
                            <c:when test="${user.roleid == 1}">
                                <span class="badge bg-danger px-3 py-1">Quản Trị Viên (Admin)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary px-3 py-1">Thành Viên (User)</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr class="my-3">

                    <div class="text-start small">
                        <div class="mb-2 d-flex justify-content-between">
                            <span class="text-muted"><i class="fa fa-envelope me-1"></i> Email:</span>
                            <span class="fw-semibold text-dark">${user.email}</span>
                        </div>
                        <div class="mb-2 d-flex justify-content-between">
                            <span class="text-muted"><i class="fa fa-phone me-1"></i> Số điện thoại:</span>
                            <span class="fw-semibold text-dark">${user.phone != null ? user.phone : 'Chưa cập nhật'}</span>
                        </div>
                        <div class="mb-2 d-flex justify-content-between">
                            <span class="text-muted"><i class="fa fa-calendar-check me-1"></i> Ngày tham gia:</span>
                            <span class="fw-semibold text-dark">${user.createdDate != null ? user.createdDate : '2026-11-16'}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                            <span class="text-muted"><i class="fa fa-cloud me-1"></i> Lưu trữ ảnh:</span>
                            <span class="cloudinary-badge"><i class="fa-solid fa-cloud-arrow-up"></i> Cloudinary</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: FORM CHỈNH SỬA THÔNG TIN -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3 text-primary border-bottom pb-2">
                        <i class="fa fa-user-pen me-2"></i>Chỉnh Sửa Hồ Sơ Cá Nhân
                    </h5>

                    <!-- FORM MULTIPART CẬP NHẬT PROFILE & UPLOAD CLOUDINARY -->
                    <form action="${pageContext.request.contextPath}/user/profile" method="post" enctype="multipart/form-data" class="needs-validation" novalidate id="profileForm">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Tên đăng nhập (Username)</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa fa-user text-secondary"></i></span>
                                    <input type="text" class="form-control bg-light" value="${user.userName}" disabled>
                                </div>
                                <div class="form-text text-muted">Tên đăng nhập được cố định trong hệ thống.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Họ và tên <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="fa fa-id-card text-secondary"></i></span>
                                    <input type="text" 
                                           name="fullname" 
                                           id="fullname"
                                           class="form-control ${not empty errors['fullname'] ? 'is-invalid' : ''}" 
                                           value="${fullname != null ? fullname : user.fullName}" 
                                           placeholder="Nhập họ và tên đầy đủ" 
                                           required 
                                           minlength="2">
                                    <div class="invalid-feedback">
                                        ${not empty errors['fullname'] ? errors['fullname'] : 'Vui lòng nhập họ và tên (tối thiểu 2 ký tự)!'}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Số điện thoại</label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="fa fa-phone text-secondary"></i></span>
                                    <input type="tel" 
                                           name="phone" 
                                           id="phone"
                                           class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" 
                                           value="${phone != null ? phone : user.phone}" 
                                           placeholder="0912345678" 
                                           pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$">
                                    <div class="invalid-feedback">
                                        ${not empty errors['phone'] ? errors['phone'] : 'SĐT VN 10 số (bắt đầu bằng 03, 05, 07, 08, 09)!'}
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Địa chỉ Email <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="fa fa-envelope text-secondary"></i></span>
                                    <input type="email" 
                                           name="email" 
                                           id="email"
                                           class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}" 
                                           value="${email != null ? email : user.email}" 
                                           placeholder="example@gmail.com" 
                                           required 
                                           pattern="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$">
                                    <div class="invalid-feedback">
                                        ${not empty errors['email'] ? errors['email'] : 'Vui lòng nhập định dạng email hợp lệ!'}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- CẢNH BÁO XÁC THỰC OTP KHI ĐỔI EMAIL MỚI -->
                        <div class="p-3 bg-info-subtle border border-info-subtle rounded-3 mb-3 small text-dark">
                            <i class="fa fa-info-circle text-info me-1"></i>
                            <strong>Xác nhận OTP khi đổi Email:</strong> Nếu bạn thay đổi sang địa chỉ email mới, hệ thống sẽ tự động gửi mã <strong>OTP gồm 6 số đến email mới</strong> để bạn xác nhận trước khi cập nhật thành công vào CSDL.
                        </div>

                        <!-- UPLOAD ẢNH ĐẠI DIỆN CLOUDINARY BẰNG MULTIPART -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold small">Ảnh đại diện Avatar (Upload lên Cloudinary bằng Multipart)</label>
                            <div class="input-group has-validation">
                                <span class="input-group-text"><i class="fa fa-cloud-arrow-up text-primary"></i></span>
                                <input type="file" 
                                       name="avatarFile" 
                                       id="avatarFile"
                                       class="form-control ${not empty errors['avatarFile'] ? 'is-invalid' : ''}" 
                                       accept="image/*">
                                <div class="invalid-feedback">
                                    ${errors['avatarFile']}
                                </div>
                            </div>
                            <div class="form-text text-muted small">
                                Chọn file ảnh (JPG, PNG, WEBP, GIF) để tải trực tiếp lên dịch vụ <strong>Cloudinary</strong> qua giao thức Multipart.
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="fa fa-save me-1"></i> Lưu Cập Nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-3">
                                Trở về trang chủ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Script xem trước ảnh đại diện khi chọn file và kiểm tra form Bootstrap 5 -->
    <script>
        (function () {
            'use strict';
            const form = document.getElementById('profileForm');
            const fileInput = document.getElementById('avatarFile');
            const avatarPreview = document.getElementById('avatarPreview');

            // Xem trước ảnh khi user chọn file
            if (fileInput && avatarPreview) {
                fileInput.addEventListener('change', function (e) {
                    const file = e.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function (evt) {
                            avatarPreview.src = evt.target.result;
                        };
                        reader.readAsDataURL(file);
                    }
                });
            }

            form.addEventListener('submit', function (event) {
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
