/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.tag.help;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.exception.NavigatorException;
import chances.epg.utils.PathWraper;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class AbstractUrlGenerator {
    protected static Log logger = EpgLogFactory.getSystemLogger();
    
    public static String appendExtraParams(HttpServletRequest request,String url) {
        String queryStr = (String) request.getAttribute("queryStr");
        String[] paramsNames = new String[] { "protocolType", "rtsp_d",
                "stbType", "trailer", "vmType", "leaveFocusId", "enterFocusId","backParams","entry" };
        String extraParamStr = PathWraper.getExtraParamsStr(paramsNames,
                queryStr);
        if (!StringUtils.isEmpty(extraParamStr)) {
            try {
                if (!StringUtils.isEmpty(url) && url.indexOf("?")!=-1 ){
                    url = url + "&backParams="
                        + URLEncoder.encode(extraParamStr, "UTF-8");
                }else{
                    url = url + "?backParams="
                    + URLEncoder.encode(extraParamStr, "UTF-8");
                }
            } catch (UnsupportedEncodingException e) {
                throw new NavigatorException("Cannot encode string '"
                        + extraParamStr + "' using UTF-8", e);
            }
        }
        return url;
    }
    
    public static String createFixUrlParamsByUrl(HttpServletRequest httpRequest) {
        //StringBuffer sb = new StringBuffer(EpgUserSession.createFixUrlParams(httpRequest));
    	StringBuffer sb = new StringBuffer();
        String leaveFocusId = httpRequest.getParameter("leaveFocusId");
        if (!StringUtils.isBlank(leaveFocusId)) {
            sb.append("&enterFocusId=").append(leaveFocusId);
        }
        /*String backParams = httpRequest.getParameter("backParams");
        if (!StringUtils.isBlank(backParams)) {
            sb.append("&backParams=").append(backParams);
        }*/
        String pageIndex = httpRequest.getParameter("pageIndex");
        if(!StringUtils.isBlank(pageIndex)){
        	sb.append("&pageIndex=").append(pageIndex);
        }
        return sb.toString();
    }
    
    public static String createFixLogParams(HttpServletRequest httpRequest) {
    	StringBuffer sb = new StringBuffer();
        String RB = httpRequest.getParameter("rb");
        if (!StringUtils.isBlank(RB)) {
            sb.append("&rb=").append(RB);
        }
        String RC = httpRequest.getParameter("rc");
        if (!StringUtils.isBlank(RC)) {
            sb.append("&rc=").append(RC);
        }
        String RP = httpRequest.getParameter("rp");
        if (!StringUtils.isBlank(RP)) {
            sb.append("&rp=").append(RP);
        }
        String PC = httpRequest.getParameter("pc");
        if (!StringUtils.isBlank(PC)) {
            sb.append("&pc=").append(PC);
        }
        String PI = httpRequest.getParameter("pi");
        if (!StringUtils.isBlank(PI)) {
            sb.append("&pi=").append(PI);
        }
        return sb.toString();
    }
}
