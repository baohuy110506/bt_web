package vn.iotstar.filter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.sitemesh.content.ContentProcessor;
import org.sitemesh.webapp.WebAppContext;
import org.sitemesh.webapp.contentfilter.ResponseMetaData;

public class TomcatSafeWebAppContext extends WebAppContext {

    public TomcatSafeWebAppContext(String contentType, HttpServletRequest request, HttpServletResponse response,
                                  jakarta.servlet.ServletContext servletContext, ContentProcessor contentProcessor,
                                  ResponseMetaData metaData, boolean includeErrorPages) {
        super(contentType, request, response, servletContext, contentProcessor, metaData, includeErrorPages);
    }

    @Override
    protected void dispatch(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(path);
        if (dispatcher == null) {
            throw new ServletException("Không tìm thấy đường dẫn decorator: " + path);
        }
        // Trên Apache Tomcat 10/11, sau khi Servlet Controller đã forward tới JSP con,
        // response bị đánh dấu committed. Ta dùng include thay vì forward để tương thích hoàn hảo.
        if (response.isCommitted()) {
            dispatcher.include(request, response);
        } else {
            try {
                dispatcher.forward(request, response);
            } catch (IllegalStateException e) {
                dispatcher.include(request, response);
            }
        }
    }
}
