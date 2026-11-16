<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Video Mới - Admin (JPA)</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body { background: #f1f5f9; color: #1e293b; display: flex; flex-direction: column; min-height: 100vh; }
        .admin-header { background: #0284c7; color: white; padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; }
        .admin-header h2 { font-size: 20px; font-weight: 700; }
        .admin-layout { display: flex; flex: 1; }
        .sidebar { width: 260px; background: #0f172a; color: #94a3b8; padding: 25px 0; display: flex; flex-direction: column; }
        .sidebar-menu { list-style: none; margin-top: 15px; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 12px; padding: 12px 25px; color: #cbd5e1; text-decoration: none; font-size: 14px; font-weight: 500; }
        .sidebar-menu li.active a { background: #0284c7; color: white; }
        .content { flex: 1; padding: 30px; }
        .content-card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); max-width: 800px; }
        .page-title { font-size: 22px; color: #1e293b; margin-bottom: 25px; font-weight: 700; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; color: #334155; }
        .form-control { width: 100%; padding: 11px 14px; border: 1.5px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; }
        .form-control:focus { border-color: #0284c7; }
        textarea.form-control { resize: vertical; min-height: 100px; }
        .btn-submit { background: #0284c7; color: white; border: none; padding: 12px 24px; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; }
        .btn-submit:hover { background: #0369a1; }
        .btn-cancel { background: #f1f5f9; color: #475569; padding: 12px 20px; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; margin-left: 10px; }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2><i class="fa fa-film"></i> Quản Lý Video - Thêm Mới</h2>
        <a href="${pageContext.request.contextPath}/admin/videos" style="color: white; text-decoration: none; font-size: 14px;">
            &larr; Trở về danh sách
        </a>
    </div>

    <div class="admin-layout">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i> Trang Chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/video"><i class="fa fa-play"></i> Video Của Tôi (/video)</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa fa-folder-open"></i> Quản Lý Danh Mục</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/videos"><i class="fa fa-film"></i> CRUD Videos</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="content-card">
                <h1 class="page-title"><i class="fa fa-plus-circle" style="color: #0284c7;"></i> Thêm Video Mới</h1>

                <!-- FORM MULTIPART THEO CHUẨN JAKARTA SERVLET -->
                <form action="${pageContext.request.contextPath}/admin/video/insert" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Mã Video (Video ID) <span style="color:#ef4444;">*</span></label>
                        <input type="text" name="videoId" class="form-control" placeholder="Ví dụ: v13 hoặc mã YouTube" required>
                    </div>

                    <div class="form-group">
                        <label>Tiêu Đề Video <span style="color:#ef4444;">*</span></label>
                        <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề video" required>
                    </div>

                    <div class="form-group">
                        <label>Danh Mục Phân Loại</label>
                        <select name="categoryId" class="form-control">
                            <option value="0">-- Chọn danh mục liên kết --</option>
                            <c:forEach items="${cateList}" var="c">
                                <option value="${c.categoryid}">${c.categoryname}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Ảnh Poster (Upload file bằng Multipart)</label>
                        <input type="file" name="posterFile" class="form-control" accept="image/*">
                        <small style="color: #64748b; display: block; margin-top: 5px;">Hỗ trợ định dạng JPG, PNG, WEBP (Lưu vào thư mục cấu hình Multipart).</small>
                    </div>

                    <div class="form-group">
                        <label>Hoặc Nhập URL Poster Trực Tiếp</label>
                        <input type="text" name="poster" class="form-control" placeholder="https://images.unsplash.com/...">
                    </div>

                    <div class="form-group">
                        <label>Mô Tả Video</label>
                        <textarea name="description" class="form-control" placeholder="Nhập nội dung mô tả chi tiết của video..."></textarea>
                    </div>

                    <div class="form-group">
                        <label style="cursor: pointer; display: flex; align-items: center; gap: 8px;">
                            <input type="checkbox" name="active" value="1" checked> 
                            <span>Kích hoạt hiển thị video ngay lập tức (Active)</span>
                        </label>
                    </div>

                    <div style="margin-top: 30px;">
                        <button type="submit" class="btn-submit"><i class="fa fa-save"></i> Lưu Video</button>
                        <a href="${pageContext.request.contextPath}/admin/videos" class="btn-cancel">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
