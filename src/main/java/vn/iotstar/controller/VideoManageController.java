package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
@WebServlet(urlPatterns = {
    "/admin/videos", "/admin/video/list",
    "/admin/video/add", "/admin/video/insert",
    "/admin/video/edit", "/admin/video/update",
    "/admin/video/delete"
})
public class VideoManageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService videoService = new VideoServiceImpl();
    private ICategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String uri = req.getRequestURI();

        if (uri.contains("/admin/videos") || uri.contains("/admin/video/list")) {
            // Danh sách tất cả video
            List<Video> list = videoService.findAll();
            req.setAttribute("videoList", list);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/add")) {
            // Trang form thêm video mới
            List<Category> cateList = categoryService.findAll();
            req.setAttribute("cateList", cateList);
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/edit")) {
            // Trang form chỉnh sửa video
            String videoId = req.getParameter("id");
            if (videoId != null && !videoId.trim().isEmpty()) {
                Video video = videoService.findById(videoId.trim());
                req.setAttribute("video", video);
            }
            List<Category> cateList = categoryService.findAll();
            req.setAttribute("cateList", cateList);
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/delete")) {
            // Xóa video theo VideoId
            String videoId = req.getParameter("id");
            if (videoId != null && !videoId.trim().isEmpty()) {
                try {
                    videoService.delete(videoId.trim());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String uri = req.getRequestURI();

        if (uri.contains("/admin/video/insert")) {
            // Thêm video mới
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("poster");
            int active = "1".equals(req.getParameter("active")) ? 1 : 0;
            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(req.getParameter("categoryId"));
            } catch (Exception ignored) {}

            Video video = new Video();
            video.setVideoId(videoId != null ? videoId.trim() : "v" + System.currentTimeMillis());
            video.setTitle(title);
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);

            if (categoryId > 0) {
                Category cate = categoryService.findById(categoryId);
                video.setCategory(cate);
            }

            // Gán User sở hữu video (mối quan hệ 1-N với User)
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("account") != null) {
                User currentUser = (User) session.getAttribute("account");
                video.setUser(currentUser);
            }

            // Xử lý upload poster bằng Multipart
            String posterFileName = handleFileUpload(req, "posterFile");
            if (!posterFileName.isEmpty()) {
                video.setPoster(posterFileName);
            } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                video.setPoster(posterUrl.trim());
            } else {
                video.setPoster("default-video.jpg");
            }

            try {
                videoService.insert(video);
            } catch (Exception e) {
                e.printStackTrace();
            }

            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (uri.contains("/admin/video/update")) {
            // Cập nhật thông tin video
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("poster");
            int active = "1".equals(req.getParameter("active")) ? 1 : 0;
            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(req.getParameter("categoryId"));
            } catch (Exception ignored) {}

            Video video = videoService.findById(videoId);
            if (video != null) {
                video.setTitle(title);
                video.setDescription(description);
                video.setActive(active);

                if (categoryId > 0) {
                    Category cate = categoryService.findById(categoryId);
                    video.setCategory(cate);
                }

                // Xử lý upload poster mới nếu có
                String newPoster = handleFileUpload(req, "posterFile");
                if (!newPoster.isEmpty()) {
                    video.setPoster(newPoster);
                } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                    video.setPoster(posterUrl.trim());
                }

                try {
                    videoService.update(video);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    /**
     * Phương thức tiện ích xử lý upload file qua Multipart (Jakarta Servlet 6.0)
     */
    private String handleFileUpload(HttpServletRequest req, String partName) {
        try {
            Part part = req.getPart(partName);
            if (part != null && part.getSize() > 0) {
                String originalFilename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                int dotIndex = originalFilename.lastIndexOf(".");
                String ext = dotIndex > 0 ? originalFilename.substring(dotIndex) : "";
                String newFileName = System.currentTimeMillis() + ext;

                String uploadPath = Constant.DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                part.write(uploadPath + File.separator + newFileName);
                return newFileName;
            }
        } catch (Exception e) {
            System.err.println("[UPLOAD ERROR] " + e.getMessage());
        }
        return "";
    }
}
