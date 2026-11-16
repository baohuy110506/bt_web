<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Danh Mục Mới - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body { background: #f1f5f9; color: #1e293b; display: flex; flex-direction: column; min-height: 100vh; }
        .admin-header {
            background: #0284c7;
            color: white;
            padding: 14px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-header h2 { font-size: 20px; font-weight: 700; }
        .admin-layout { display: flex; flex: 1; }
        .sidebar {
            width: 260px;
            background: #0f172a;
            color: #94a3b8;
            padding: 25px 0;
            display: flex;
            flex-direction: column;
        }
        .user-info {
            padding: 0 20px 25px 20px;
            text-align: center;
            border-bottom: 1px solid #1e293b;
        }
        .user-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #0284c7;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            font-size: 30px;
            color: white;
        }
        .sidebar-menu { list-style: none; margin-top: 15px; }
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 25px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.2s;
        }
        .sidebar-menu li.active a, .sidebar-menu li a:hover {
            background: #0284c7;
            color: white;
        }
        .content { flex: 1; padding: 30px; }
        .content-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 650px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .page-title { font-size: 24px; color: #1e293b; margin-bottom: 25px; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; font-weight: 700; }
        .form-group { margin-bottom: 22px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #475569; font-size: 14px; }
        .form-control {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
        }
        .form-control:focus { border-color: #0284c7; }
        .radio-row { display: flex; gap: 20px; align-items: center; margin-top: 6px; }
        .radio-row label { display: inline-flex; align-items: center; gap: 6px; font-weight: normal; margin-bottom: 0; cursor: pointer; }
        .btn-group { display: flex; gap: 12px; margin-top: 25px; }
        .btn {
            padding: 11px 25px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-submit { background: #0284c7; color: white; }
        .btn-submit:hover { background: #0369a1; }
        .btn-cancel { background: #e2e8f0; color: #475569; }
        .btn-cancel:hover { background: #cbd5e1; }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2>Dashboard</h2>
        <div style="display: flex; align-items: center; gap: 20px;">
            <span>Xin chào, <strong>${sessionScope.account != null ? sessionScope.account.fullName : 'Admin'}</strong></span>
            <a href="${pageContext.request.contextPath}/logout" style="background: #ef4444; color: white; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600;">Đăng xuất</a>
        </div>
    </div>

    <div class="admin-layout">
        <div class="sidebar">
            <div class="user-info">
                <div class="user-avatar"><i class="fa fa-user-shield"></i></div>
                <div style="color: white; font-weight: 600;">Bạn là Admin</div>
                <div style="font-size: 12px; color: #94a3b8; margin-top: 4px;">${sessionScope.account != null ? sessionScope.account.email : 'admin@iotstar.vn'}</div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-house"></i> Trang chủ Web</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa fa-folder"></i> Quản lý Danh mục</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/category/add"><i class="fa fa-plus-circle"></i> Thêm danh mục mới</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="content-card">
                <h1 class="page-title"><i class="fa fa-plus-circle"></i> Thêm Danh Mục Mới (JPA)</h1>

                <form action="<c:url value="/admin/category/insert"/>" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="categoryname">Tên danh mục:</label>
                        <input type="text" id="categoryname" name="categoryname" class="form-control" placeholder="Nhập tên danh mục..." required>
                    </div>

                    <div class="form-group">
                        <label for="images">Link hình ảnh (URL):</label>
                        <input type="text" id="images" name="images" class="form-control" placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="form-group">
                        <label for="images1">Hoặc tải ảnh lên từ máy tính:</label>
                        <input type="file" id="images1" name="images1" class="form-control" accept="image/*">
                    </div>

                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <div class="radio-row">
                            <label for="ston">
                                <input type="radio" id="ston" name="status" value="1" checked> Hoạt động
                            </label>
                            <label for="stoff">
                                <input type="radio" id="stoff" name="status" value="0"> Khóa
                            </label>
                        </div>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-submit"><i class="fa fa-check"></i> Insert</button>
                        <a href="<c:url value="/admin/categories"/>" class="btn btn-cancel">Hủy bỏ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
