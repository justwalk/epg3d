/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.config;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.util.WebUtils;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.nav.url.EpgResourceLocator;
import chances.epg.taglib.EpgBaseTagSupport;

/**
 * Epg系统配置参数装载器.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class EpgStartupServlet extends HttpServlet {
    private static Log logger = EpgLogFactory.getSystemLogger();
    private static final String CONFIG_PATH_NAME = "epgConfigLocation";
    private String configPath;
    
    /**
     * 
     */
    private static final long serialVersionUID = 4985933568408758906L;

    /*
     * (non-Javadoc)
     * 
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        this.loadEpgConfig(req.getSession().getServletContext());
        Properties props = EpgConfigUtils.getInstance().getProperties();
        StringBuffer html = new StringBuffer();
        html.append("Update epg config sucess.Parameters:").append("<br>");
        for (Object key : props.keySet()) {
            html.append(key).append("=").append(props.get(key)).append("<br>");
        }
        
        resp.getWriter().write(html.toString());
        resp.getWriter().flush();
    }

    /*
     * (non-Javadoc)
     * 
     * @see javax.servlet.GenericServlet#init(javax.servlet.ServletConfig)
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        configPath = config.getServletContext().getInitParameter(CONFIG_PATH_NAME);
        if(StringUtils.isBlank(this.configPath)){
            configPath = config.getInitParameter(CONFIG_PATH_NAME);
        }
        
        if(StringUtils.isBlank(this.configPath)){
            logger.error("Can't found init parameter epgConfigLocation.");
            throw new ServletException();
        }
        
        try {
            this.loadEpgConfig(config.getServletContext());
        } catch (IOException ex) {
            throw new ServletException();
        }
        EpgBaseTagSupport.resourceLocator = new EpgResourceLocator();
    }
    
    /**
     * 装载系统配置.
     * 
     * @param configPath
     * @throws IOException 
     */
    private void loadEpgConfig(ServletContext context) throws IOException {
        String realPath = "";
        try {
            realPath = WebUtils.getRealPath(context, this.configPath);
            Properties props = new Properties();
            props.load(new FileInputStream(realPath));
            
            //装载到ServletContext中
            for (Object key : props.keySet()) {
                context.setAttribute((String)key, props.get(key));
            }
       
            //将参数存放到静态类中
            EpgConfigUtils.getInstance().addAll(props);
        } catch (FileNotFoundException ex) {
            logger.error("File not exist.File:" + realPath,ex);
            throw ex;
        } catch (IOException ex) {
            logger.error(ex);
            throw ex;
        }   
    }
}
