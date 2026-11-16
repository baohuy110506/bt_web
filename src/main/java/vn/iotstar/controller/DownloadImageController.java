package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/image")
public class DownloadImageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.isEmpty()) {
            return;
        }

        File file = new File(Constant.DIR + File.separator + fileName);
        if (file.exists() && file.isFile()) {
            if (fileName.toLowerCase().endsWith(".png")) {
                resp.setContentType("image/png");
            } else if (fileName.toLowerCase().endsWith(".gif")) {
                resp.setContentType("image/gif");
            } else {
                resp.setContentType("image/jpeg");
            }
            try (FileInputStream fis = new FileInputStream(file)) {
                fis.transferTo(resp.getOutputStream());
            }
        } else {
            // Serve a placeholder SVG when image file is not on disk
            resp.setContentType("image/svg+xml");
            String svg = "<svg xmlns='http://www.w3.org/2000/svg' width='150' height='100' viewBox='0 0 150 100'>"
                    + "<rect width='150' height='100' fill='#e2e8f0'/>"
                    + "<text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-family='sans-serif' font-size='14' fill='#64748b'>"
                    + (fileName.length() > 15 ? fileName.substring(0, 15) : fileName)
                    + "</text></svg>";
            resp.getOutputStream().write(svg.getBytes());
        }
    }
}
