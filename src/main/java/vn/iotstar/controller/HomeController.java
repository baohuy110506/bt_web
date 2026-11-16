package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/home", "/"})
public class HomeController extends HttpServlet {

    private ICategoryService categoryService = new CategoryServiceImpl();
    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // 1. Lấy danh sách danh mục sản phẩm
        List<Category> cateList = categoryService.findAll();
        req.setAttribute("cateList", cateList);
        req.setAttribute("listcate", cateList);

        // 2. Lấy 10 video mới nhất hiển thị lên trang chủ theo yêu cầu đề bài
        List<Video> top10Videos = videoService.findTop10Latest();
        req.setAttribute("top10Videos", top10Videos);

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
