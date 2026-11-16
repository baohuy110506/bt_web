<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Video - Phân Trang 6 Video / Trang</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body { background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }
        .page-header {
            background: linear-gradient(135deg, #0f172a 0%, #0369a1 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .page-header h1 { font-size: 26px; font-weight: 700; margin-bottom: 8px; }
        .page-header p { font-size: 14px; color: #cbd5e1; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; flex: 1; width: 100%; }

        .banner-info {
            background: #e0f2fe;
            border-left: 4px solid #0284c7;
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: #0369a1;
        }

        /* Lưới 6 video / trang */
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .video-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            border: 1px solid #f1f5f9;
        }
        .video-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.12);
        }
        .video-thumb-wrap {
            position: relative;
            width: 100%;
            height: 190px;
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
            background: rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 40px;
            opacity: 0.8;
            transition: opacity 0.2s, color 0.2s;
        }
        .video-card:hover .play-overlay {
            opacity: 1;
            color: #38bdf8;
        }
        .video-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .category-badge {
            background: #f1f5f9;
            color: #475569;
            font-size: 12px;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 8px;
            align-self: flex-start;
        }

        /* Bấm vào tiêu đề sẽ play video */
        .video-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            text-decoration: none;
            line-height: 1.4;
            margin-bottom: 10px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .video-title:hover {
            color: #0284c7;
            text-decoration: underline;
        }
        .video-desc {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 14px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .video-footer {
            font-size: 13px;
            color: #64748b;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }

        /* PHÂN TRANG (Pagination) */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-bottom: 40px;
        }
        .page-link {
            padding: 9px 16px;
            background: white;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            color: #334155;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .page-link:hover {
            background: #f1f5f9;
            border-color: #94a3b8;
        }
        .page-link.active {
            background: #0284c7;
            color: white;
            border-color: #0284c7;
            font-weight: 700;
        }
        .page-link.disabled {
            color: #94a3b8;
            pointer-events: none;
            background: #f8fafc;
            border-color: #e2e8f0;
        }
    </style>
</head>
<body>
    <jsp:include page="/views/common/topbar.jsp" />

    <div class="page-header">
        <h1><i class="fa fa-film"></i> Tất Cả Videos (URL: /video)</h1>
        <p>Phân trang chuẩn 6 sản phẩm/trang theo yêu cầu đề bài</p>
    </div>

    <div class="container">
        <!-- Thông báo người dùng & số lượng -->
        <div class="banner-info">
            <div>
                <c:choose>
                    <c:when test="${isUserVideos}">
                        <i class="fa fa-user-circle"></i> Đang hiển thị video của người dùng: 
                        <strong>${userOwner.fullName != null ? userOwner.fullName : userOwner.userName}</strong> (Tổng cộng: <strong>${totalVideos}</strong> video)
                    </c:when>
                    <c:otherwise>
                        <i class="fa fa-globe"></i> Đang hiển thị tất cả video hệ thống (Tổng: <strong>${totalVideos}</strong> video). 
                        <a href="${pageContext.request.contextPath}/login" style="color:#0284c7; font-weight:700;">Đăng nhập</a> để quản lý và xem video của chính bạn.
                    </c:otherwise>
                </c:choose>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/video/add" style="background:#0284c7; color:white; padding:7px 14px; border-radius:6px; text-decoration:none; font-weight:600; font-size:13px;">
                    <i class="fa fa-plus"></i> Thêm Video Mới
                </a>
            </div>
        </div>

        <!-- LƯỚI 6 VIDEO TRÊN TRANG HIỆN TẠI -->
        <div class="video-grid">
            <c:forEach items="${videoList}" var="v">
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
                            <span class="category-badge"><i class="fa fa-tag"></i> ${v.category.categoryname}</span>
                        </c:if>

                        <!-- TIÊU ĐỀ VIDEO CÓ LINK CLICK XEM CHI TIẾT VÀ PLAY VIDEO -->
                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-title" title="${v.title}">
                            ${v.title}
                        </a>

                        <p class="video-desc">${v.description != null ? v.description : 'Không có mô tả chi tiết cho video này.'}</p>

                        <div class="video-footer">
                            <span><i class="fa fa-user"></i> ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Admin'}</span>
                            <span><i class="fa fa-eye"></i> ${v.views} lượt xem</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty videoList}">
            <div style="text-align: center; padding: 50px 20px; background: white; border-radius: 12px; margin-bottom: 40px;">
                <i class="fa fa-video-slash" style="font-size: 40px; color: #94a3b8; margin-bottom: 15px;"></i>
                <h3 style="color: #475569;">Chưa có video nào để hiển thị!</h3>
                <p style="color: #64748b; margin-top: 8px;">Hãy bấm <a href="${pageContext.request.contextPath}/admin/video/add">Thêm video mới</a> để tạo video đầu tiên của bạn.</p>
            </div>
        </c:if>

        <!-- THANH ĐIỀU HƯỚNG PHÂN TRANG 6 VIDEO / TRANG -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <!-- Nút Previous -->
                <a href="${pageContext.request.contextPath}/video?page=${currentPage - 1}" class="page-link ${currentPage == 1 ? 'disabled' : ''}">
                    &laquo; Trước
                </a>

                <!-- Các số trang 1, 2, 3... -->
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <a href="${pageContext.request.contextPath}/video?page=${p}" class="page-link ${currentPage == p ? 'active' : ''}">
                        ${p}
                    </a>
                </c:forEach>

                <!-- Nút Next -->
                <a href="${pageContext.request.contextPath}/video?page=${currentPage + 1}" class="page-link ${currentPage == totalPages ? 'disabled' : ''}">
                    Sau &raquo;
                </a>
            </div>
        </c:if>
    </div>
</body>
</html>
