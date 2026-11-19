package vn.iotstar.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.ServletException;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected Filter setup() throws ServletException {
        SiteMeshFilterBuilder builder = new SiteMeshFilterBuilder() {
            @Override
            public Filter create() {
                return new TomcatSafeSiteMeshFilter(getSelector(), getContentProcessor(), getDecoratorSelector(), isIncludeErrorPages());
            }
        };
        applyCustomConfiguration(builder);
        return builder.create();
    }

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.setDecoratorPrefix("")
               .addExcludedPath("/views/decorators/*")
               .addExcludedPath("/decorators/*")
               .addExcludedPath("/image/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/assets/*")
               // Template Bootstrap cho khu vực Quản trị Admin
               .addDecoratorPath("/admin/*", "/WEB-INF/decorators/admin.jsp")
               // Áp dụng template Bootstrap mặc định cho toàn bộ trang web
               .addDecoratorPath("/*", "/WEB-INF/decorators/web.jsp");
    }

    @Override
    protected boolean reloadRequired() {
        return false;
    }

    @Override
    protected boolean getAutoReload() {
        return false;
    }
}
