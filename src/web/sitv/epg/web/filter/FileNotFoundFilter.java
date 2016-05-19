/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;

import sitv.epg.business.EpgLogFactory;

/**
 * 用于处理内容图片不存在时使用默认图片替换.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class FileNotFoundFilter implements Filter {
    private Log logger = EpgLogFactory.getSystemLogger();
    private String forward;

    /* (non-Javadoc)
     * @see javax.servlet.Filter#destroy()
     */
    public void destroy() {
        
    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        HttpServletResponse httpresponse=(HttpServletResponse)response;
        FileNotFoundResponseWrapper wrapper = new FileNotFoundResponseWrapper(httpresponse);
        try{
            chain.doFilter(request, wrapper);
            if(wrapper.getStatusCode() == HttpServletResponse.SC_NOT_FOUND){
                RequestDispatcher dispatcher = request.getRequestDispatcher(forward);
                dispatcher.forward(request, response);
            }
        }catch(Exception ex){
            logger.error(ex);
        }
        
    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
     */
    public void init(FilterConfig config) throws ServletException {
        forward = config.getInitParameter("forward");
    }
}
