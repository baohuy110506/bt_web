<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Video - Admin (JPA)</title>
</head>
<body>
    <div class="row justify-content-center">
        <div class="col-lg-9 col-xl-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="card-title fw-bold text-primary mb-0">
                        <i class="fa fa-pen-to-square me-2"></i>Cập Nhật Video: ${video.videoId}
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

                    <form action="${pageContext.request.contextPath}/admin/video/update" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <input type="hidden" name="videoId" value="${video.videoId}">

                        <div class="row g-3 mb-3">
                            <div class="col-md-5">
                                <label class="form-label fw-semibold small">Mã Video (Cố định)</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa fa-hashtag text-secondary"></i></span>
                                    <input type="text" class="form-control bg-light" value="${video.videoId}" disabled>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <label class="form-label fw-semibold small">Danh Mục Phân Loại <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select ${not empty errors['categoryId'] ? 'is-invalid' : ''}" required>
                                    <option value="">-- Chọn danh mục liên kết --</option>
                                    <c:forEach items="${cateList}" var="c">
                                        <option value="${c.categoryid}" ${(selectedCategoryId != null && selectedCategoryId == c.categoryid) || (video.category != null && video.category.categoryid == c.categoryid) ? 'selected' : ''}>
                                            ${c.categoryname}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    ${not empty errors['categoryId'] ? errors['categoryId'] : 'Vui lòng chọn danh mục liên kết!'}
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Tiêu Đề Video <span class="text-danger">*</span></label>
                            <input type="text" 
                                   name="title" 
                                   id="title"
                                   class="form-control ${not empty errors['title'] ? 'is-invalid' : ''}" 
                                   value="${video.title}" 
                                   required 
                                   minlength="3" 
                                   maxlength="200">
                            <div class="invalid-feedback">
                                ${not empty errors['title'] ? errors['title'] : 'Tiêu đề video phải từ 3 đến 200 ký tự!'}
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small d-block">Ảnh Poster Hiện Tại</label>
                            <c:choose>
                                <c:when test="${not empty video.poster && video.poster.startsWith('http')}">
                                    <img src="${video.poster}" alt="Poster" class="rounded border p-1 mb-2" style="max-height: 120px; max-width: 200px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/image?fname=${video.poster}" alt="Poster" class="rounded border p-1 mb-2" style="max-height: 120px; max-width: 200px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Thay Đổi Ảnh Poster (Upload Multipart)</label>
                            <input type="file" 
                                   name="posterFile" 
                                   class="form-control ${not empty errors['posterFile'] ? 'is-invalid' : ''}" 
                                   accept="image/*">
                            <div class="invalid-feedback">
                                ${errors['posterFile']}
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Hoặc URL Poster Trực Tiếp</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa fa-link text-secondary"></i></span>
                                <input type="text" name="poster" class="form-control" value="${video.poster}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Mô Tả Video</label>
                            <textarea name="description" class="form-control" rows="3">${video.description}</textarea>
                        </div>

                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="active" value="1" id="activeVideoEdit" ${video.active == 1 ? 'checked' : ''}>
                                <label class="form-check-label fw-medium text-success" for="activeVideoEdit">
                                    Kích hoạt hiển thị video (Active)
                                </label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="fa fa-save me-1"></i> Cập Nhật Video
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
