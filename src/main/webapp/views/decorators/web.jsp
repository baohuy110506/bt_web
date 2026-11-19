<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Hệ Thống Quản Lý Video JPA</sitemesh:write></title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #0284c7;
            --primary-hover: #0369a1;
            --dark-bg: #0f172a;
        }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .app-navbar {
            background: #0f172a !important;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.25rem;
            color: #ffffff !important;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .navbar-brand i {
            color: #38bdf8;
            font-size: 1.4rem;
        }
        .nav-link {
            color: #cbd5e1 !important;
            font-weight: 500;
            padding: 0.5rem 0.9rem !important;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .nav-link:hover {
            color: #ffffff !important;
            background: rgba(255, 255, 255, 0.08);
        }
        .nav-link.active {
            color: #38bdf8 !important;
            font-weight: 600;
        }
        .main-wrapper {
            flex: 1 0 auto;
        }
        .app-footer {
            background: #0f172a;
            color: #94a3b8;
            padding: 30px 0 20px;
            margin-top: 40px;
            border-top: 1px solid #1e293b;
        }
        .app-footer a {
            color: #cbd5e1;
            text-decoration: none;
            transition: color 0.2s;
        }
        .app-footer a:hover {
            color: #38bdf8;
        }
        .user-avatar-sm {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #38bdf8;
        }
    </style>

    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Header Navigation Bar (Bootstrap 5) -->
    <nav class="navbar navbar-expand-lg navbar-dark app-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="fa-solid fa-circle-play"></i>
                <span>Media JPA</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                    aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">
                            <i class="fa fa-home me-1"></i> Trang Chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/video">
                            <i class="fa fa-film me-1 text-warning"></i> Video Của Tôi
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fa fa-folder-tree me-1 text-info"></i> Danh Mục
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/videos">
                            <i class="fa fa-video me-1 text-primary"></i> Quản Trị Video
                        </a>
                    </li>
                </ul>

                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${sessionScope.account == null}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm px-3">
                                <i class="fa fa-sign-in-alt me-1"></i> Đăng Nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm px-3">
                                <i class="fa fa-user-plus me-1"></i> Đăng Ký
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown">
                                <button class="btn btn-outline-light btn-sm dropdown-toggle d-flex align-items-center gap-2"
                                        type="button" id="userMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account.avatar}">
                                            <img src="${sessionScope.account.avatar}" alt="Avatar" class="user-avatar-sm">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-circle-user fs-5 text-info"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <span>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</span>
                                    <c:if test="${sessionScope.account.roleid == 1}">
                                        <span class="badge bg-danger ms-1">Admin</span>
                                    </c:if>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userMenuButton">
                                    <li>
                                        <h6 class="dropdown-header">Tài khoản: ${sessionScope.account.userName}</h6>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                            <i class="fa fa-id-card me-2 text-primary"></i> Thông Tin Cá Nhân
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/video">
                                            <i class="fa fa-video me-2 text-warning"></i> Video Của Tôi
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fa fa-sign-out-alt me-2"></i> Đăng Xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Area Rendered by SiteMesh 3 -->
    <main class="main-wrapper">
        <sitemesh:write property="body"/>
    </main>

    <!-- Footer (Bootstrap 5) -->
    <footer class="app-footer">
        <div class="container">
            <div class="row g-4 mb-3">
                <div class="col-md-5">
                    <h5 class="text-white mb-2">
                        <i class="fa-solid fa-circle-play text-info me-2"></i>Media JPA System
                    </h5>
                    <p class="small text-secondary mb-0">
                        Hệ thống bài tập môn Lập Trình Web - Cấu hình <strong>SiteMesh Decorator 3</strong> kết hợp <strong>Bootstrap 5</strong>, Hibernate 6 ORM, Jakarta EE và SQL Server.
                    </p>
                </div>
                <div class="col-md-3">
                    <h6 class="text-white mb-2">Liên Kết Nhanh</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-1"><a href="${pageContext.request.contextPath}/home"><i class="fa fa-angle-right me-1"></i> Trang Chủ</a></li>
                        <li class="mb-1"><a href="${pageContext.request.contextPath}/video"><i class="fa fa-angle-right me-1"></i> Phân Trang Video</a></li>
                        <li class="mb-1"><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa fa-angle-right me-1"></i> Quản Lý Danh Mục</a></li>
                        <li class="mb-1"><a href="${pageContext.request.contextPath}/admin/videos"><i class="fa fa-angle-right me-1"></i> Quản Trị Video</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h6 class="text-white mb-2">Thông Tin Kỹ Thuật</h6>
                    <p class="small text-secondary mb-1">
                        <i class="fa fa-layer-group text-info me-1"></i> <strong>SiteMesh 3:</strong> Decorator Pattern
                    </p>
                    <p class="small text-secondary mb-1">
                        <i class="fa fa-shield-halved text-success me-1"></i> <strong>Bảo Mật:</strong> BCrypt & OTP Email
                    </p>
                    <p class="small text-secondary mb-0">
                        <i class="fa fa-bootstrap text-primary me-1"></i> <strong>Giao Diện:</strong> Bootstrap 5 Responsive
                    </p>
                </div>
            </div>
            <div class="pt-3 border-top border-secondary text-center small text-secondary">
                &copy; 2026 - Lập Trình Web JPA &bull; Thiết kế bằng SiteMesh 3 Decorator Template.
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
