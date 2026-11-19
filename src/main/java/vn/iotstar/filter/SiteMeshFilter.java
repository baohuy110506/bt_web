package vn.iotstar.filter;

import jakarta.servlet.annotation.WebFilter;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

@WebFilter(filterName = "sitemesh", urlPatterns = "/*")
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Áp dụng template Bootstrap mặc định cho toàn bộ trang web
        builder.addDecoratorPath("/*", "/views/decorators/web.jsp")
               // Template Bootstrap dành cho khu vực Quản trị Admin
               .addDecoratorPath("/admin/*", "/views/decorators/admin.jsp")
               // Bỏ qua các đường dẫn tĩnh hoặc tài nguyên
               .addExcludedPath("/image/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/assets/*");
    }
}
