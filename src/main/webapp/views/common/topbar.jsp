<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header style="background: #0f172a; color: white; padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 12px rgba(0,0,0,0.25); font-family: 'Roboto', 'Segoe UI', Arial, sans-serif; position: sticky; top: 0; z-index: 1000;">
    <div style="display: flex; align-items: center; gap: 28px;">
        <a href="${pageContext.request.contextPath}/home" style="color: white; text-decoration: none; font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 8px;">
            <i class="fa fa-play-circle" style="color: #38bdf8;"></i> Media JPA
        </a>
        <nav style="display: flex; gap: 18px; align-items: center;">
            <a href="${pageContext.request.contextPath}/home" style="color: #cbd5e1; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s;">
                <i class="fa fa-home"></i> Trang Chủ
            </a>
            <a href="${pageContext.request.contextPath}/video" style="color: #f59e0b; text-decoration: none; font-size: 14px; font-weight: 600; transition: color 0.2s;">
                <i class="fa fa-video"></i> Video Của Tôi (/video)
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" style="color: #38bdf8; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s;">
                <i class="fa fa-folder-open"></i> Quản Lý Danh Mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/videos" style="color: #a855f7; text-decoration: none; font-size: 14px; font-weight: 600; transition: color 0.2s;">
                <i class="fa fa-film"></i> CRUD Videos (Admin)
            </a>
        </nav>
    </div>

    <div>
        <c:choose>
            <c:when test="${sessionScope.account == null}">
                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${pageContext.request.contextPath}/login" style="color: #e2e8f0; text-decoration: none; padding: 7px 16px; border: 1px solid #475569; border-radius: 6px; font-size: 14px; font-weight: 500;">
                        <i class="fa fa-sign-in-alt"></i> Đăng Nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/register" style="background: #0284c7; color: white; text-decoration: none; padding: 7px 16px; border-radius: 6px; font-size: 14px; font-weight: 600;">
                        <i class="fa fa-user-plus"></i> Đăng Ký
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: flex; gap: 14px; align-items: center;">
                    <span style="color: #e2e8f0; font-size: 14px;">
                        Xin chào, <strong style="color: #38bdf8;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</strong>
                        <c:if test="${sessionScope.account.roleid == 1}">
                            <span style="background: #e11d48; color: white; padding: 2px 8px; border-radius: 10px; font-size: 11px; margin-left: 4px; font-weight: 600;">Admin</span>
                        </c:if>
                    </span>
                    <a href="${pageContext.request.contextPath}/logout" style="background: #ef4444; color: white; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 500;">
                        <i class="fa fa-sign-out-alt"></i> Đăng Xuất
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>
