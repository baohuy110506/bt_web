package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/video", "/video/detail" })
public class VideoController extends HttpServlet {

    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String uri = req.getRequestURI();

        // 1. Chức năng xem chi tiết và play video: /video/detail?id=...
        if (uri.contains("/video/detail")) {
            String videoId = req.getParameter("id");
            if (videoId != null && !videoId.trim().isEmpty()) {
                // Tự động tăng lượt xem
                videoService.incrementViews(videoId.trim());
                Video video = videoService.findById(videoId.trim());
                req.setAttribute("video", video);

                // Lấy danh sách video gợi ý
                List<Video> relatedVideos = videoService.findTop10Latest();
                req.setAttribute("relatedVideos", relatedVideos);
            }
            req.getRequestDispatcher("/views/video/video-detail.jsp").forward(req, resp);
            return;
        }

        // 2. Chức năng hiển thị tất cả video của user với phân trang 6 video/trang tại URL /video
        HttpSession session = req.getSession(false);
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("account");
        }

        int page = 1;
        int pageSize = 6; // Yêu cầu đề bài: phân trang 6sp/trang
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Video> videoList;
        int totalVideos;

        if (currentUser != null) {
            // User đã đăng nhập: lấy tất cả video của chính user đó
            totalVideos = videoService.countByUserId(currentUser.getId());
            videoList = videoService.findByUserId(currentUser.getId(), page, pageSize);
            req.setAttribute("isUserVideos", true);
            req.setAttribute("userOwner", currentUser);
        } else {
            // Khách chưa đăng nhập: hiển thị video hệ thống có phân trang 6 video/trang kèm thông báo đăng nhập
            totalVideos = videoService.count();
            videoList = videoService.findAll(page, pageSize);
            req.setAttribute("isUserVideos", false);
        }

        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages == 0) totalPages = 1;

        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("pageSize", pageSize);

        req.getRequestDispatcher("/views/video/video-list.jsp").forward(req, resp);
    }
}
