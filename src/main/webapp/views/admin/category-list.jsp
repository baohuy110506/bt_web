<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục - Admin (JPA)</title>
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
        .content {
            flex: 1;
            padding: 30px;
        }
        .content-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .page-title {
            font-size: 24px;
            color: #1e293b;
            margin-bottom: 5px;
            font-weight: 700;
        }
        .page-subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 25px;
        }
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
            font-weight: 600;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add:hover { background: #0369a1; }
        .search-box {
            display: flex;
            align-items: center;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            overflow: hidden;
            background: white;
        }
        .search-box input {
            padding: 9px 14px;
            border: none;
            outline: none;
            font-size: 14px;
            width: 240px;
        }
        .search-box button {
            background: #f1f5f9;
            border: none;
            padding: 9px 14px;
            cursor: pointer;
            color: #64748b;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table th {
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            text-align: left;
            padding: 12px 16px;
            border-bottom: 2px solid #e2e8f0;
            font-size: 14px;
        }
        table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            vertical-align: middle;
        }
        table tr:hover { background: #f8fafc; }
        .cat-img {
            width: 140px;
            height: 95px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
        }
        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-active { background: #dcfce7; color: #15803d; }
        .badge-locked { background: #fee2e2; color: #b91c1c; }
        .btn-action {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
        }
        .btn-edit { background: #e0f2fe; color: #0369a1; }
        .btn-edit:hover { background: #bae6fd; }
        .btn-delete { background: #fee2e2; color: #b91c1c; margin-left: 6px; }
        .btn-delete:hover { background: #fecaca; }
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
                <li><a href="${pageContext.request.contextPath}/video"><i class="fa fa-play"></i> Video Của Tôi (/video)</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa fa-folder"></i> Quản lý Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/videos"><i class="fa fa-film"></i> CRUD Videos (Admin)</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="content-card">
                <h1 class="page-title">Quản lý danh mục</h1>
                <p class="page-subtitle">Nơi bạn có thể quản lý danh mục của mình (JPA Hibernate ORM)</p>

                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/admin/category/add" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm danh mục mới
                    </a>

                    <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="search-box">
                        <input type="text" name="keyword" placeholder="Tìm kiếm danh mục..." value="${keyword}">
                        <button type="submit"><i class="fa fa-search"></i></button>
                    </form>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th style="width: 60px;">STT</th>
                            <th style="width: 170px;">Hình ảnh</th>
                            <th>Tên danh mục</th>
                            <th style="width: 140px;">Trạng thái</th>
                            <th style="width: 160px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listcate}" var="cate" varStatus="STT">
                            <tr>
                                <td>${STT.index+1}</td>
                                <c:choose>
                                    <c:when test="${not empty cate.images && cate.images.startsWith('https')}">
                                        <c:url value="${cate.images}" var="imgUrl"></c:url>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image?fname=${cate.images}" var="imgUrl"></c:url>
                                    </c:otherwise>
                                </c:choose>
                                <td><img class="cat-img" src="${imgUrl}" alt="${cate.categoryname}" /></td>
                                <td><strong>${cate.categoryname}</strong></td>
                                <td>
                                    <c:if test="${cate.status==1}">
                                        <span class="badge badge-active">Hoạt động</span>
                                    </c:if>
                                    <c:if test="${cate.status!=1}">
                                        <span class="badge badge-locked">Khóa</span>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn-action btn-edit">Sửa</a>
                                    <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" class="btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listcate}">
                            <tr>
                                <td colspan="5" style="text-align: center; color: #94a3b8; padding: 30px;">
                                    Không có danh mục nào trong cơ sở dữ liệu. Nhấn "Thêm danh mục mới" để thêm!
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
