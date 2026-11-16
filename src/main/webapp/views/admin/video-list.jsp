<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Videos - Admin (JPA)</title>
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
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .page-title { font-size: 24px; color: #1e293b; margin-bottom: 5px; font-weight: 700; }
        .page-subtitle { color: #64748b; font-size: 14px; margin-bottom: 25px; }
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .btn-add {
            background: #0284c7;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add:hover { background: #0369a1; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
        th, td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #f8fafc; color: #475569; font-weight: 600; }
        tr:hover { background: #f8fafc; }
        .poster-img { width: 70px; height: 45px; object-fit: cover; border-radius: 4px; background: #e2e8f0; }
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .badge-active { background: #dcfce7; color: #15803d; }
        .badge-inactive { background: #fee2e2; color: #b91c1c; }
        .btn-action {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            margin-right: 5px;
        }
        .btn-edit { background: #e0f2fe; color: #0284c7; }
        .btn-delete { background: #fee2e2; color: #ef4444; }
        .btn-play { background: #fef3c7; color: #d97706; }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2><i class="fa fa-cogs"></i> Hệ Thống Quản Trị JPA - Quản Lý Video</h2>
        <div>
            <a href="${pageContext.request.contextPath}/home" style="color: white; text-decoration: none; font-size: 14px; margin-right: 15px;">
                <i class="fa fa-home"></i> Về Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/logout" style="color: #fee2e2; text-decoration: none; font-size: 14px;">
                <i class="fa fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>

    <div class="admin-layout">
        <div class="sidebar">
            <div class="user-info">
                <div class="user-avatar"><i class="fa fa-user-shield"></i></div>
                <div style="font-weight: 600; color: white;">${sessionScope.account != null ? sessionScope.account.fullName : 'Admin User'}</div>
                <div style="font-size: 12px; color: #38bdf8;">Quản trị viên hệ thống</div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i> Trang Chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/video"><i class="fa fa-play"></i> Video Của Tôi (/video)</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa fa-folder-open"></i> Quản Lý Danh Mục</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/videos"><i class="fa fa-film"></i> CRUD Videos</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="content-card">
                <div class="action-bar">
                    <div>
                        <h1 class="page-title">Quản Lý Videos (CRUD)</h1>
                        <p class="page-subtitle">Thực hiện Thêm, Sửa, Xóa và xem video liên kết với CSDL webst2 (Bảng Videos 1-N với Users)</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/video/add" class="btn-add">
                        <i class="fa fa-plus-circle"></i> Thêm Video Mới
                    </a>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Mã Video</th>
                            <th>Poster</th>
                            <th>Tiêu Đề</th>
                            <th>Danh Mục</th>
                            <th>Người Đăng (User)</th>
                            <th>Lượt Xem</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${videoList}" var="v">
                            <tr>
                                <td><strong>${v.videoId}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                            <img src="${v.poster}" alt="Poster" class="poster-img">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" alt="Poster" class="poster-img">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" style="color: #0284c7; font-weight: 600; text-decoration: none;" title="Xem & Play Video">
                                        ${v.title}
                                    </a>
                                </td>
                                <td>${v.category != null ? v.category.categoryname : 'N/A'}</td>
                                <td>
                                    <span style="font-weight: 500; color: #475569;">
                                        <i class="fa fa-user"></i> ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Admin'}
                                    </span>
                                </td>
                                <td><i class="fa fa-eye"></i> ${v.views}</td>
                                <td>
                                    <span class="badge ${v.active ? 'badge-active' : 'badge-inactive'}">
                                        ${v.active ? 'Hoạt động' : 'Đã ẩn'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn-action btn-play" title="Play Video">
                                        <i class="fa fa-play"></i> Xem
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" class="btn-action btn-edit">
                                        <i class="fa fa-edit"></i> Sửa
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/video/delete?id=${v.videoId}" class="btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');">
                                        <i class="fa fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
