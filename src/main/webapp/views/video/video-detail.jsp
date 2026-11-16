<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${video.title} - Chi Tiết & Phát Video</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; }
        body { background: #0f172a; color: #e2e8f0; min-height: 100vh; }
        .main-container {
            max-width: 1300px;
            margin: 25px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 30px;
        }
        @media (max-width: 900px) {
            .main-container { grid-template-columns: 1fr; }
        }

        /* KHUNG PHÁT VIDEO PLAYER */
        .player-wrapper {
            background: #020617;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            aspect-ratio: 16 / 9;
            width: 100%;
            position: relative;
        }
        .player-wrapper video {
            width: 100%;
            height: 100%;
            object-fit: contain;
            background: black;
        }
        .player-wrapper iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        .poster-preview-fallback {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* CHI TIẾT VIDEO */
        .video-info-box {
            background: #1e293b;
            padding: 22px;
            border-radius: 12px;
            margin-top: 18px;
        }
        .video-title {
            font-size: 22px;
            font-weight: 700;
            color: white;
            line-height: 1.4;
            margin-bottom: 12px;
        }
        .meta-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #334155;
            margin-bottom: 15px;
            font-size: 14px;
            color: #94a3b8;
        }
        .meta-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .meta-pill {
            background: #334155;
            padding: 5px 12px;
            border-radius: 20px;
            color: #cbd5e1;
            font-size: 13px;
        }
        .uploader-box {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .uploader-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #0284c7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
        }
        .uploader-name {
            font-weight: 600;
            color: white;
            font-size: 15px;
        }
        .uploader-role {
            font-size: 12px;
            color: #94a3b8;
        }
        .desc-box {
            background: #0f172a;
            padding: 16px;
            border-radius: 8px;
            font-size: 14px;
            line-height: 1.6;
            color: #cbd5e1;
        }

        /* SIDEBAR VIDEO GỢI Ý */
        .sidebar-title {
            font-size: 18px;
            font-weight: 700;
            color: white;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .sidebar-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .sidebar-item {
            display: flex;
            gap: 12px;
            background: #1e293b;
            padding: 10px;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: background 0.2s;
        }
        .sidebar-item:hover {
            background: #334155;
        }
        .sidebar-thumb {
            width: 120px;
            height: 75px;
            border-radius: 6px;
            overflow: hidden;
            flex-shrink: 0;
            background: #0f172a;
        }
        .sidebar-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .sidebar-item-info {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .sidebar-item-title {
            font-size: 13px;
            font-weight: 600;
            color: #f1f5f9;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .sidebar-item-views {
            font-size: 11px;
            color: #94a3b8;
        }
    </style>
</head>
<body>
    <jsp:include page="/views/common/topbar.jsp" />

    <div class="main-container">
        <!-- CỘT TRÁI: VIDEO PLAYER VÀ CHI TIẾT -->
        <div>
            <!-- KHUNG TRÌNH CHIẾU / PHÁT VIDEO CHÍNH -->
            <div class="player-wrapper">
                <c:choose>
                    <%-- Nếu là link nhúng video YouTube (chứa từ khóa youtube trong mô tả) --%>
                    <c:when test="${not empty video.videoId && not empty video.description && video.description.contains('youtube')}">
                        <iframe src="https://www.youtube.com/embed/${video.videoId}?autoplay=1" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </c:when>
                    <%-- Mặc định phát video HTML5 (hỗ trợ MP4, WebM và hiển thị Poster) --%>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty video.poster && video.poster.startsWith('http')}">
                                <video controls autoplay poster="${video.poster}">
                                    <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                                </video>
                            </c:when>
                            <c:otherwise>
                                <video controls autoplay poster="${pageContext.request.contextPath}/image?fname=${video.poster}">
                                    <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- THÔNG TIN CHI TIẾT VIDEO -->
            <div class="video-info-box">
                <h1 class="video-title">${video.title}</h1>

                <div class="meta-bar">
                    <div class="meta-left">
                        <span class="meta-pill"><i class="fa fa-eye"></i> ${video.views} lượt xem</span>
                        <c:if test="${not empty video.category}">
                            <span class="meta-pill" style="background: #0284c7; color: white;">
                                <i class="fa fa-folder"></i> ${video.category.categoryname}
                            </span>
                        </c:if>
                        <span class="meta-pill" style="background: #10b981; color: white;">
                            <i class="fa fa-check-circle"></i> ${video.active ? 'Hoạt động' : 'Tạm ẩn'}
                        </span>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/video" style="color: #38bdf8; text-decoration: none; font-size: 13px; font-weight: 500;">
                            &larr; Quay lại danh sách video (/video)
                        </a>
                    </div>
                </div>

                <!-- Người đăng tải (mối quan hệ 1-N với Users) -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                    <div class="uploader-box">
                        <div class="uploader-avatar">
                            <i class="fa fa-user"></i>
                        </div>
                        <div>
                            <div class="uploader-name">
                                ${video.user != null ? (video.user.fullName != null ? video.user.fullName : video.user.userName) : 'Quản trị viên'}
                            </div>
                            <div class="uploader-role">
                                <c:choose>
                                    <c:when test="${video.user.roleid == 1}">Quản trị viên hệ thống (Admin)</c:when>
                                    <c:otherwise>Thành viên chia sẻ</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Mô tả video -->
                <div class="desc-box">
                    <h3 style="font-size: 15px; margin-bottom: 8px; color: #f8fafc;"><i class="fa fa-align-left"></i> Mô tả nội dung video:</h3>
                    <p style="white-space: pre-line;">${video.description != null && not empty video.description ? video.description : 'Chưa có thông tin mô tả chi tiết cho video này.'}</p>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: DANH SÁCH VIDEO GỢI Ý -->
        <div>
            <h3 class="sidebar-title"><i class="fa fa-fire" style="color: #f59e0b;"></i> Video Gợi Ý Mới Nhất</h3>
            <div class="sidebar-list">
                <c:forEach items="${relatedVideos}" var="rv">
                    <c:if test="${rv.videoId != video.videoId}">
                        <a href="${pageContext.request.contextPath}/video/detail?id=${rv.videoId}" class="sidebar-item">
                            <div class="sidebar-thumb">
                                <c:choose>
                                    <c:when test="${not empty rv.poster && rv.poster.startsWith('http')}">
                                        <img src="${rv.poster}" alt="${rv.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/image?fname=${rv.poster}" alt="${rv.title}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="sidebar-item-info">
                                <div class="sidebar-item-title">${rv.title}</div>
                                <div class="sidebar-item-views">
                                    <i class="fa fa-eye"></i> ${rv.views} &bull; ${rv.user != null ? rv.user.userName : 'Admin'}
                                </div>
                            </div>
                        </a>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
