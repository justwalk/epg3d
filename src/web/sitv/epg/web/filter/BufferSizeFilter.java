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
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;

import chances.epg.log.EpgLogFactory;

/**
 * Class comments.
 *
 * @author sunjie
 */
public class BufferSizeFilter implements Filter{

    private String bufferSize;

    public void destroy() {
        // TODO Auto-generated method stub
        
    }

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        // TODO Auto-generated method stub
        HttpServletRequest httprequest=(HttpServletRequest)request;
        HttpServletResponse httpresponse=(HttpServletResponse)response;
        if("Vision Browser/1.3.3".equals(httprequest.getHeader("User-Agent")))//全景30A
        {         
            httpresponse.setBufferSize(Integer.parseInt(bufferSize));
        }
        chain.doFilter(request, response); //继续执行下一个filter，注意filter执行的先后顺序
        
    }

    public void init(FilterConfig config) throws ServletException {
        // TODO Auto-generated method stub
        bufferSize = config.getInitParameter("bufferSize");
    }

}
