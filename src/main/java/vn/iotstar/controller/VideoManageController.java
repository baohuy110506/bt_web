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

            // VALIDATION CHO FORM INSERT VIDEO
            java.util.Map<String, String> errors = new java.util.HashMap<>();
            if (videoId == null || videoId.trim().isEmpty()) {
                errors.put("videoId", "Vui lòng nhập mã Video (Video ID)!");
            } else if (!vn.iotstar.util.ValidationUtil.isValidVideoId(videoId.trim())) {
                errors.put("videoId", "Mã Video phải từ 2-50 ký tự, chỉ chứa chữ cái, số, gạch nối hoặc gạch dưới!");
            } else if (videoService.findById(videoId.trim()) != null) {
                errors.put("videoId", "Mã Video '" + videoId.trim() + "' đã tồn tại trong CSDL! Vui lòng chọn mã khác.");
            }

            if (title == null || title.trim().isEmpty()) {
                errors.put("title", "Vui lòng nhập tiêu đề Video!");
            } else if (title.trim().length() < 3) {
                errors.put("title", "Tiêu đề Video phải có độ dài ít nhất 3 ký tự!");
            } else if (title.trim().length() > 200) {
                errors.put("title", "Tiêu đề Video không được vượt quá 200 ký tự!");
            }

            if (categoryId <= 0) {
                errors.put("categoryId", "Vui lòng chọn danh mục liên kết cho video!");
            }

            try {
                Part part = req.getPart("posterFile");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    if (!vn.iotstar.util.ValidationUtil.isValidImageExtension(part.getSubmittedFileName())) {
                        errors.put("posterFile", "Định dạng file không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP, GIF.");
                    }
                }
            } catch (Exception ignored) {}

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.setAttribute("videoId", videoId);
                req.setAttribute("title", title);
                req.setAttribute("description", description);
                req.setAttribute("poster", posterUrl);
                req.setAttribute("active", active);
                req.setAttribute("selectedCategoryId", categoryId);
                req.setAttribute("cateList", categoryService.findAll());
                req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                return;
            }

            Video video = new Video();
            video.setVideoId(videoId.trim());
            video.setTitle(title.trim());
            video.setDescription(description != null ? description.trim() : "");
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
            return;

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

            // VALIDATION CHO FORM EDIT VIDEO
            java.util.Map<String, String> errors = new java.util.HashMap<>();
            Video video = videoService.findById(videoId);
            if (video == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            if (title == null || title.trim().isEmpty()) {
                errors.put("title", "Vui lòng nhập tiêu đề Video!");
            } else if (title.trim().length() < 3) {
                errors.put("title", "Tiêu đề Video phải có độ dài ít nhất 3 ký tự!");
            } else if (title.trim().length() > 200) {
                errors.put("title", "Tiêu đề Video không được vượt quá 200 ký tự!");
            }

            if (categoryId <= 0) {
                errors.put("categoryId", "Vui lòng chọn danh mục liên kết cho video!");
            }

            try {
                Part part = req.getPart("posterFile");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    if (!vn.iotstar.util.ValidationUtil.isValidImageExtension(part.getSubmittedFileName())) {
                        errors.put("posterFile", "Định dạng file không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP, GIF.");
                    }
                }
            } catch (Exception ignored) {}

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                video.setTitle(title);
                video.setDescription(description);
                video.setActive(active);
                req.setAttribute("video", video);
                req.setAttribute("selectedCategoryId", categoryId);
                req.setAttribute("cateList", categoryService.findAll());
                req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
                return;
            }

            video.setTitle(title.trim());
            video.setDescription(description != null ? description.trim() : "");
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

            resp.sendRedirect(req.getContextPath() + "/admin/videos");
            return;
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
