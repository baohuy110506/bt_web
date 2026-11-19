<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Video Mới - Admin (JPA)</title>
</head>
<body>
    <div class="row justify-content-center">
        <div class="col-lg-9 col-xl-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="card-title fw-bold text-primary mb-0">
                        <i class="fa fa-circle-plus me-2"></i>Thêm Video Mới (JPA)
                    </h5>
                    <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-secondary btn-sm">
                        <i class="fa fa-arrow-left me-1"></i> Trở Về Danh Sách
                    </a>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- FORM MULTIPART THEO CHUẨN JAKARTA SERVLET & VALIDATION -->
                    <form action="${pageContext.request.contextPath}/admin/video/insert" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-5">
                                <label class="form-label fw-semibold small">Mã Video (Video ID) <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text"><i class="fa fa-hashtag text-secondary"></i></span>
                                    <input type="text" 
                                           name="videoId" 
                                           id="videoId"
                                           class="form-control ${not empty errors['videoId'] ? 'is-invalid' : ''}" 
                                           placeholder="Ví dụ: v10, video_demo" 
                                           value="${videoId != null ? videoId : param.videoId}" 
                                           required 
                                           pattern="^[a-zA-Z0-9_-]{2,50}$">
                                    <div class="invalid-feedback">
                                        ${not empty errors['videoId'] ? errors['videoId'] : 'Mã video từ 2-50 ký tự (chữ cái, số, gạch nối)!'}
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <label class="form-label fw-semibold small">Danh Mục Phân Loại <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select ${not empty errors['categoryId'] ? 'is-invalid' : ''}" required>
                                    <option value="">-- Chọn danh mục liên kết --</option>
                                    <c:forEach items="${cateList}" var="c">
                                        <option value="${c.categoryid}" ${(selectedCategoryId != null && selectedCategoryId == c.categoryid) || param.categoryId == c.categoryid ? 'selected' : ''}>
                                            ${c.categoryname}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    ${not empty errors['categoryId'] ? errors['categoryId'] : 'Vui lòng chọn danh mục liên kết cho video!'}
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" 
                                   name="title" 
                                   id="title"
                                   class="form-control ${not empty errors['title'] ? 'is-invalid' : ''}" 
                                   placeholder="Nhập tiêu đề video (3-200 ký tự)..." 
                                   value="${title != null ? title : param.title}" 
                                   required 
                                   minlength="3" 
                                   maxlength="200">
                            <div class="invalid-feedback">
                                ${not empty errors['title'] ? errors['title'] : 'Tiêu đề video phải từ 3 đến 200 ký tự!'}
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Ảnh Poster (Upload file bằng Multipart)</label>
                            <input type="file" 
                                   name="posterFile" 
                                   class="form-control ${not empty errors['posterFile'] ? 'is-invalid' : ''}" 
                                   accept="image/*">
                            <div class="invalid-feedback">
                                ${errors['posterFile']}
                            </div>
                            <div class="form-text text-muted">Hỗ trợ JPG, PNG, WEBP (Tối đa 50MB lưu theo chuẩn Multipart).</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Hoặc Nhập URL Poster Trực Tiếp</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa fa-link text-secondary"></i></span>
                                <input type="text" 
                                       name="poster" 
                                       class="form-control" 
                                       placeholder="https://images.unsplash.com/..." 
                                       value="${poster != null ? poster : param.poster}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Mô Tả Video</label>
                            <textarea name="description" 
                                      class="form-control" 
                                      rows="3" 
                                      placeholder="Nhập thông tin mô tả chi tiết của video...">${description != null ? description : param.description}</textarea>
                        </div>

                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="active" value="1" id="activeVideo" ${active == null || active == 1 ? 'checked' : ''}>
                                <label class="form-check-label fw-medium text-success" for="activeVideo">
                                    Kích hoạt hiển thị video ngay (Active)
                                </label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="fa fa-check me-1"></i> Lưu Video
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-secondary px-3">
                                Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
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
