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
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig()
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/list", "/admin/category/add", "/admin/category/insert",
        "/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String url = req.getRequestURI();
        if (url.contains("/admin/categories") || url.contains("/admin/category/list")) {
            List<Category> list = cateService.findAll();
            req.setAttribute("listcate", list);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/edit")) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Category category = cateService.findById(id);
                    req.setAttribute("cate", category);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/delete")) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    cateService.delete(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String url = req.getRequestURI();
        if (url.contains("/admin/category/insert")) {
            // lấy dữ liệu từ form
            String categoryname = req.getParameter("categoryname");
            int status = 1;
            try {
                status = Integer.parseInt(req.getParameter("status"));
            } catch (Exception ignored) {
            }
            String images = req.getParameter("images");

            // VALIDATION CHO FORM INSERT DANH MỤC
            java.util.Map<String, String> errors = new java.util.HashMap<>();
            if (categoryname == null || categoryname.trim().isEmpty()) {
                errors.put("categoryname", "Vui lòng nhập tên danh mục!");
            } else if (categoryname.trim().length() < 2) {
                errors.put("categoryname", "Tên danh mục phải có độ dài ít nhất 2 ký tự!");
            } else if (categoryname.trim().length() > 100) {
                errors.put("categoryname", "Tên danh mục không được vượt quá 100 ký tự!");
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    if (!vn.iotstar.util.ValidationUtil.isValidImageExtension(part.getSubmittedFileName())) {
                        errors.put("images1", "Định dạng file không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP, GIF.");
                    } else if (part.getSize() > 10 * 1024 * 1024) {
                        errors.put("images1", "Kích thước ảnh không được vượt quá 10MB!");
                    }
                }
            } catch (Exception ignored) {}

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.setAttribute("categoryname", categoryname);
                req.setAttribute("images", images);
                req.setAttribute("status", status);
                req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                return;
            }

            // đưa dữ liệu vào model
            Category category = new Category();
            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR; // upload vào thư mục bất kỳ
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index > 0 ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + "/" + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages("avatar.png");
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
                category.setImages("avatar.png");
            }

            // đưa model vào phương thức insert
            cateService.insert(category);

            // chuyển trang
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }

        if (url.contains("/admin/category/update")) {
            // lấy dữ liệu từ form
            int categoryid = 0;
            try {
                categoryid = Integer.parseInt(req.getParameter("categoryid"));
            } catch (Exception ignored) {}

            String categoryname = req.getParameter("categoryname");
            int status = 1;
            try {
                status = Integer.parseInt(req.getParameter("status"));
            } catch (Exception ignored) {
            }
            String images = req.getParameter("images");

            // VALIDATION CHO FORM EDIT DANH MỤC
            java.util.Map<String, String> errors = new java.util.HashMap<>();
            if (categoryname == null || categoryname.trim().isEmpty()) {
                errors.put("categoryname", "Vui lòng nhập tên danh mục!");
            } else if (categoryname.trim().length() < 2) {
                errors.put("categoryname", "Tên danh mục phải có độ dài ít nhất 2 ký tự!");
            } else if (categoryname.trim().length() > 100) {
                errors.put("categoryname", "Tên danh mục không được vượt quá 100 ký tự!");
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    if (!vn.iotstar.util.ValidationUtil.isValidImageExtension(part.getSubmittedFileName())) {
                        errors.put("images1", "Định dạng file không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP, GIF.");
                    } else if (part.getSize() > 10 * 1024 * 1024) {
                        errors.put("images1", "Kích thước ảnh không được vượt quá 10MB!");
                    }
                }
            } catch (Exception ignored) {}

            Category category = cateService.findById(categoryid);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                category.setCategoryname(categoryname);
                category.setStatus(status);
                req.setAttribute("cate", category);
                req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                return;
            }

            String fileold = category.getImages();
            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR; // upload vào thư mục bất kỳ
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    // xóa file cũ trên thư mục
                    if (fileold != null && fileold.length() >= 5 && !fileold.substring(0, 5).equals("https")) {
                        deleteFile(uploadPath + "\\" + fileold);
                    }
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index > 0 ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + "/" + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages(fileold);
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
            }

            // đưa model vào phương thức update
            cateService.update(category);

            // chuyển trang
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }
    }

    public static void deleteFile(String filePath) throws IOException {
        try {
            Path path = Paths.get(filePath);
            Files.deleteIfExists(path);
        } catch (Exception ignored) {
        }
    }
}
