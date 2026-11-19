<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Quản Trị Hệ Thống - Admin Panel</sitemesh:write></title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f1f5f9;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .admin-navbar {
            background: #090d16 !important;
            border-bottom: 2px solid #0284c7;
        }
        .admin-sidebar-badge {
            background: #e11d48;
            color: #fff;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 6px;
        }
        .main-wrapper {
            flex: 1 0 auto;
            padding: 24px 0;
        }
        .admin-footer {
            background: #090d16;
            color: #94a3b8;
            padding: 16px 0;
            border-top: 1px solid #1e293b;
        }
    </style>

    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Admin Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark admin-navbar sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-white d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/admin/videos">
                <i class="fa-solid fa-gauge-high text-primary"></i>
                <span>Media Admin</span>
                <span class="admin-sidebar-badge">ADMIN</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="adminNavbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/home">
                            <i class="fa fa-arrow-left me-1"></i> Về Trang Web
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fa fa-folder-tree me-1 text-info"></i> Quản Lý Danh Mục
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/admin/videos">
                            <i class="fa fa-video me-1 text-warning"></i> Quản Lý Video
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-light" href="${pageContext.request.contextPath}/admin/video/add">
                            <i class="fa fa-plus-circle me-1 text-success"></i> Thêm Video Mới
                        </a>
                    </li>
                </ul>

                <div class="d-flex align-items-center gap-3">
                    <span class="text-secondary small">
                        Đăng nhập bởi: <strong class="text-white">${sessionScope.account != null ? sessionScope.account.userName : 'Admin'}</strong>
                    </span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                        <i class="fa fa-sign-out-alt me-1"></i> Đăng Xuất
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Admin Content Area -->
    <main class="main-wrapper">
        <div class="container-fluid px-4">
            <sitemesh:write property="body"/>
        </div>
    </main>

    <!-- Admin Footer -->
    <footer class="admin-footer">
        <div class="container-fluid px-4 text-center small">
            &copy; 2026 Admin Management Portal &bull; Trang Quản Trị Hệ Thống Sitemesh 3 Bootstrap 5.
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
