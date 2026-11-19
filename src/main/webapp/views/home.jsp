<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Video & Category Shopping JPA</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body { background: #f8fafc; color: #1e293b; min-height: 100vh; }
        .hero {
            background: linear-gradient(135deg, #0f172a 0%, #0284c7 100%);
            color: white;
            padding: 45px 30px;
            text-align: center;
        }
        .hero h1 { font-size: 30px; margin-bottom: 10px; font-weight: 700; }
        .hero p { font-size: 15px; color: #cbd5e1; max-width: 700px; margin: 0 auto; line-height: 1.6; }
        .hero-actions { margin-top: 20px; display: flex; justify-content: center; gap: 15px; }
        .hero-btn {
            padding: 9px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .hero-btn-primary { background: #38bdf8; color: #0f172a; }
        .hero-btn-secondary { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.3); }

        .container { max-width: 1200px; margin: 35px auto; padding: 0 20px; }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
        }
        .section-header h2 {
            font-size: 22px;
            font-weight: 700;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-header a {
            color: #0284c7;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        /* Grid Video */
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 45px;
        }
        .video-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }
        .video-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.12);
        }
        .video-thumb-wrap {
            position: relative;
            width: 100%;
            height: 140px;
            background: #0f172a;
            overflow: hidden;
        }
        .video-thumb-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .video-card:hover .video-thumb-wrap img {
            transform: scale(1.05);
        }
        .play-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 34px;
            opacity: 0.85;
            transition: opacity 0.2s;
        }
        .video-card:hover .play-overlay {
            opacity: 1;
            color: #38bdf8;
        }
        .video-body {
            padding: 14px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .video-title {
            font-size: 15px;
            font-weight: 600;
            color: #1e293b;
            text-decoration: none;
            line-height: 1.4;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .video-title:hover {
            color: #0284c7;
            text-decoration: underline;
        }
        .video-meta {
            font-size: 12px;
            color: #64748b;
            display: flex;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 10px;
            border-top: 1px solid #f1f5f9;
        }
        .category-badge {
            background: #e0f2fe;
            color: #0369a1;
            font-size: 11px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 4px;
            display: inline-block;
            margin-bottom: 6px;
        }

        /* Danh mục */
        .cate-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        .cate-card {
            background: white;
            border-radius: 10px;
            padding: 16px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            text-decoration: none;
            color: #1e293b;
            transition: transform 0.2s;
        }
        .cate-card:hover {
            transform: translateY(-3px);
            color: #0284c7;
        }
        .cate-card img {
            width: 100%;
            height: 110px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="hero">
        <h1>Nền Tảng Đa Phương Tiện & Danh Mục JPA</h1>
        <p>Hệ thống hỗ trợ Đăng ký xác thực OTP Email, Mã hóa mật khẩu BCrypt, Quên mật khẩu OTP, Quản lý Video (1-N với User) và Phân trang 6 Video/Trang.</p>
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/video" class="hero-btn hero-btn-primary">
                <i class="fa fa-play"></i> Xem Video Phân Trang (/video)
            </a>
            <a href="${pageContext.request.contextPath}/admin/videos" class="hero-btn hero-btn-secondary">
                <i class="fa fa-plus-circle"></i> Quản Lý CRUD Videos
            </a>
        </div>
    </div>

    <div class="container">
        <!-- 1. MỤC 10 VIDEO MỚI NHẤT TRÊN TRANG CHỦ THEO YÊU CẦU ĐỀ BÀI -->
        <div class="section-header">
            <h2><i class="fa fa-fire" style="color: #ef4444;"></i> 10 Video Mới Nhất</h2>
            <a href="${pageContext.request.contextPath}/video">Xem tất cả video có phân trang &rarr;</a>
        </div>

        <div class="video-grid">
            <c:forEach items="${top10Videos}" var="v">
                <div class="video-card">
                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-thumb-wrap">
                        <c:choose>
                            <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                <img src="${v.poster}" alt="${v.title}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" alt="${v.title}">
                            </c:otherwise>
                        </c:choose>
                        <div class="play-overlay">
                            <i class="fa fa-play-circle"></i>
                        </div>
                    </a>

                    <div class="video-body">
                        <c:if test="${not empty v.category}">
                            <div><span class="category-badge">${v.category.categoryname}</span></div>
                        </c:if>

                        <!-- BẤM VÀO TIÊU ĐỀ SẼ XEM CHI TIẾT VÀ PLAY VIDEO -->
                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-title" title="${v.title}">
                            ${v.title}
                        </a>

                        <div class="video-meta">
                            <span><i class="fa fa-user"></i> ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Admin'}</span>
                            <span><i class="fa fa-eye"></i> ${v.views} lượt xem</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty top10Videos}">
                <p style="color: #64748b; font-size: 14px;">Chưa có video nào trong hệ thống. Hãy thêm mới trong mục <a href="${pageContext.request.contextPath}/admin/videos">Quản lý video</a>!</p>
            </c:if>
        </div>

        <!-- 2. MỤC DANH MỤC SẢN PHẨM -->
        <div class="section-header">
            <h2><i class="fa fa-folder-open" style="color: #0284c7;"></i> Danh Mục Sản Phẩm</h2>
            <a href="${pageContext.request.contextPath}/admin/categories">Quản lý danh mục &rarr;</a>
        </div>

        <div class="cate-grid">
            <c:forEach items="${cateList}" var="c">
                <a href="${pageContext.request.contextPath}/admin/categories" class="cate-card">
                    <c:choose>
                        <c:when test="${not empty c.images && c.images.startsWith('http')}">
                            <img src="${c.images}" alt="${c.categoryname}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/image?fname=${c.images}" alt="${c.categoryname}">
                        </c:otherwise>
                    </c:choose>
                    <strong>${c.categoryname}</strong>
                </a>
            </c:forEach>
        </div>
    </div>
</body>
</html>
