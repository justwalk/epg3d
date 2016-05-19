/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.business;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class EpgLogFactory {
    protected static Log logonLogger = LogFactory.getLog("logon");
    protected static Log playLogger = LogFactory.getLog("play");
    protected static Log systemLogger = LogFactory.getLog("syslog");
    protected static Log pageLogger = LogFactory.getLog("page");
    protected static Log adLogger = LogFactory.getLog("ad");
    protected static Log errorLogger = LogFactory.getLog("errorlog");
    protected static Log authLogger = LogFactory.getLog("auth");
    protected static Log orderLogger = LogFactory.getLog("order");
    
    /**
     * 首次登录log
     * @return
     */
    public static Log getLogonLogger() {
        return logonLogger; 
    }
    
    /**
     * 播放log
     * @return
     */
    public static Log getPlayLogger() {
        return playLogger;  
    }
    
    /**
     * 系统log,调试debug都是用该log
     * @return
     */
    public static Log getSystemLogger(){
        return systemLogger;
    }
    
    /**
     * 页面访问log
     * @return
     */
    public static Log getPageLogger(){
        return pageLogger;
    }
    
    /**
     * 广告播放log
     * @return
     */
    public static Log getAdLogger(){
        return adLogger;
    }
    
    /**
     * 用户错误日志
     * @return
     */
    public static Log getErrorLogger() {
        return errorLogger;
    }
    
    /**
     * 鉴权日志.
     * @return
     */
    public static Log getAuthLogger() {
        return authLogger;
    }
    
    /**
     * 订购日志.
     * @return
     */
    public static Log getOrderLogger() {
        return orderLogger;
    }
}
