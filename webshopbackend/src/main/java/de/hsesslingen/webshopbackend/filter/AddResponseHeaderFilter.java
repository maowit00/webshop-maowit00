package de.hsesslingen.webshopbackend.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AddResponseHeaderFilter implements Filter {

    @Value("${server.port}")
    String port;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        httpServletResponse.setHeader("server-port", port);
        chain.doFilter(request, response);
    }
}