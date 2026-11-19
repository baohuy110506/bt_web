<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Danh Mục - Admin</title>
</head>
<body>
    <div class="row justify-content-center">
        <div class="col-lg-8 col-xl-7">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="card-title fw-bold text-primary mb-0">
                        <i class="fa fa-pen-to-square me-2"></i>Chỉnh Sửa Danh Mục: #${cate.categoryid}
                    </h5>
                    <a href="<c:url value="/admin/categories"/>" class="btn btn-outline-secondary btn-sm">
                        <i class="fa fa-arrow-left me-1"></i> Danh Sách
                    </a>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa fa-circle-exclamation me-2"></i> ${alert}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <input type="hidden" name="categoryid" value="${cate.categoryid}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Mã danh mục (ID)</label>
                            <input type="text" class="form-control bg-light" value="${cate.categoryid}" disabled>
                        </div>

                        <div class="mb-3">
                            <label for="categoryname" class="form-label fw-semibold small">Tên danh mục <span class="text-danger">*</span></label>
                            <input type="text" 
                                   id="categoryname" 
                                   name="categoryname" 
                                   class="form-control ${not empty errors['categoryname'] ? 'is-invalid' : ''}" 
                                   value="${cate.categoryname}" 
                                   required 
                                   minlength="2" 
                                   maxlength="100">
                            <div class="invalid-feedback">
                                ${not empty errors['categoryname'] ? errors['categoryname'] : 'Vui lòng nhập tên danh mục từ 2 đến 100 ký tự!'}
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small d-block">Hình ảnh hiện tại</label>
                            <c:choose>
                                <c:when test="${not empty cate.images && cate.images.startsWith('http')}">
                                    <img src="${cate.images}" alt="Category Image" class="rounded border p-1 mb-2" style="max-height: 100px; max-width: 160px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/image?fname=${cate.images}" alt="Category Image" class="rounded border p-1 mb-2" style="max-height: 100px; max-width: 160px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="mb-3">
                            <label for="images" class="form-label fw-semibold small">Đổi URL hình ảnh mới</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa fa-link text-secondary"></i></span>
                                <input type="text" id="images" name="images" class="form-control" value="${cate.images}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="images1" class="form-label fw-semibold small">Hoặc tải file ảnh mới từ máy tính (Multipart)</label>
                            <input type="file" 
                                   id="images1" 
                                   name="images1" 
                                   class="form-control ${not empty errors['images1'] ? 'is-invalid' : ''}" 
                                   accept="image/*">
                            <div class="invalid-feedback">
                                ${errors['images1']}
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold small d-block">Trạng thái danh mục</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}>
                                <label class="form-check-label text-success fw-medium" for="ston">
                                    <i class="fa fa-check-circle me-1"></i> Hoạt động
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="stoff" name="status" value="0" ${cate.status == 0 ? 'checked' : ''}>
                                <label class="form-check-label text-danger fw-medium" for="stoff">
                                    <i class="fa fa-ban me-1"></i> Khóa
                                </label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="fa fa-save me-1"></i> Cập Nhật
                            </button>
                            <a href="<c:url value="/admin/categories"/>" class="btn btn-outline-secondary px-3">
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
