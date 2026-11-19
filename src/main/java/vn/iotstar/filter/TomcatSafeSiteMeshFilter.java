package vn.iotstar.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
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
    protected void bufferAndPostProcess(FilterChain chain, HttpServletRequest request,
                                        HttpServletResponse response, Selector selector)
            throws IOException, ServletException {
        // Tạo dynamic proxy cho response không kế thừa ServletResponseWrapper.
        // Ngăn chặn Apache Tomcat 10/11 tự động unwrap về ResponseFacade gốc để gọi setSuspended(true) khi forward.
        HttpServletResponse proxyResponse = (HttpServletResponse) Proxy.newProxyInstance(
                HttpServletResponse.class.getClassLoader(),
                new Class<?>[]{HttpServletResponse.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        return method.invoke(response, args);
                    }
                }
        );

        super.bufferAndPostProcess(chain, request, proxyResponse, selector);
    }

    @Override
    protected WebAppContext createContext(String contentType, HttpServletRequest request,
                                         HttpServletResponse response, ResponseMetaData metaData) {
        return new TomcatSafeWebAppContext(contentType, request, response,
                getFilterConfig().getServletContext(), getContentProcessor(), metaData, this.includeErrorPages);
    }
}
