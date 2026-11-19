package vn.iotstar.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.sitemesh.DecoratorSelector;
import org.sitemesh.content.ContentProcessor;
import org.sitemesh.webapp.SiteMeshFilter;
import org.sitemesh.webapp.WebAppContext;
import org.sitemesh.webapp.contentfilter.ResponseMetaData;
import org.sitemesh.webapp.contentfilter.Selector;

public class TomcatSafeSiteMeshFilter extends SiteMeshFilter {

    private final boolean includeErrorPages;

    public TomcatSafeSiteMeshFilter(Selector selector, ContentProcessor contentProcessor,
                                    DecoratorSelector<WebAppContext> decoratorSelector, boolean includeErrorPages) {
        super(selector, contentProcessor, decoratorSelector, includeErrorPages);
        this.includeErrorPages = includeErrorPages;
    }

    @Override
    protected WebAppContext createContext(String contentType, HttpServletRequest request,
                                         HttpServletResponse response, ResponseMetaData metaData) {
        return new TomcatSafeWebAppContext(contentType, request, response,
                getFilterConfig().getServletContext(), getContentProcessor(), metaData, this.includeErrorPages);
    }
}
