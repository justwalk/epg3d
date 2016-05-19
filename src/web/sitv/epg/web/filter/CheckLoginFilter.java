/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;
import org.apache.oro.text.perl.Perl5Util;
import org.springframework.beans.factory.annotation.Autowired;
import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.dao.CategoryItemService;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.web.UserSession;

/**
 * 用于检查用户是否登录的过滤器. 
 * 如果检查到用户未登录，则将用户请求转向到登录页面。
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class CheckLoginFilter implements Filter {
	
    private String loginRedirectUrl; // 未登录转向页面链接

    private String loginSkipPattern; // 检查登录过滤条件
    
    protected Perl5Util perl;

    @Autowired
    protected CategoryItemService categoryItemService;

    /* (non-Javadoc)
     * @see javax.servlet.Filter#destroy()
     */
    public void destroy() {
        perl = null;
    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
     */
    public void doFilter(ServletRequest _request, ServletResponse _response,
            FilterChain chain) throws IOException, ServletException {
        if (perl == null) {
            perl = new Perl5Util();
        }
        
        HttpServletRequest request = (HttpServletRequest) _request;
        HttpServletResponse response = (HttpServletResponse) _response;
        String servletPath = request.getServletPath();
        
        String refBiz = "";//进入该页面之前页面的看吧编码
        String itemCode = "";//编排的code
        String curCat = "";//当前编排该内容的栏目
        //---2013.12.09修改---
        //int seq = 0;
        //---9.30修改---
    	//List<EpgCategoryItem> items = null;
    	
        String URI = request.getRequestURI();//当前路径
        String QS = request.getQueryString();//当前路径参数
        String[] parameterURIs = URI.split("/");
        //获取上一次浏览的页面的biz、cat
        if(StringUtils.isNotBlank(QS)){
        	String[] parametersQuerys = QS.contains("&")?QS.split("&"):null;
        	if(parametersQuerys!=null){
        		for(int i=0; i<parametersQuerys.length; i++){
        			if(StringUtils.isBlank(refBiz) && parametersQuerys[i].contains("rb=")){
        				if(parametersQuerys[i].split("rb=").length > 1){
            				refBiz = parametersQuerys[i].split("rb=")[1];
        				}
        			}
        			if(StringUtils.isBlank(curCat) && parametersQuerys[i].contains("pc=")){
        				if(parametersQuerys[i].split("pc=").length > 1){
        					curCat = parametersQuerys[i].split("pc=")[1];
        				}
        			}
        		}
        	}
        }
        //获取编排在对应栏目的位置
        if(StringUtils.isNotBlank(refBiz)){
        	//获取当前栏目
        	if(StringUtils.isBlank(curCat)){
	        	for(int i=0 ; i<parameterURIs.length ; i++){
	        		if("cat".equals(parameterURIs[i])){
	        			curCat = parameterURIs[i+1];
	        			if(curCat.contains(".do")){
	        				String[] curCats = curCat.split(".do");
	        				curCat = curCats[0];
	        				break;
	        			}
	        		}
	        	}
        	}
        	//计算SEQ
//        	if(URI.contains("/biz/")){
//            	String codeIncludeDo = parameterURIs[parameterURIs.length-1];
//            	String[] c = codeIncludeDo.split(".do");
//            	itemCode = c[0];
                //---9.30修改---
            	/*if(StringUtils.isNotBlank(curCat)){
            		if(itemCode.equals(curCat)){
            			items = categoryItemService.getCategoryItems(
            					categoryItemService.getCategoryItemsByItemCode(itemCode).get(0).getCategoryCode());
            		}else{
            			items = categoryItemService.getCategoryItems(curCat);
            		}
            		for(int j=0; j<items.size(); j++){
            			if(itemCode.equals(items.get(j).getItemCode())){
            				seq = j+1;
            				break;
            			}
            		}
            	}*/
//            }
        }
                
        this.logAccessLog(request, curCat);
        
        if (!"".equals(servletPath) && !"/".equals(servletPath)) {
            if (!perl.match(loginSkipPattern, servletPath)) {
                //检查用户Session
                if (!UserSession.existUserSession(request)){
                	
                    response.sendRedirect(this.createRedirectURL(request));
                    return;
                    
                }else{
                	String account = request.getParameter("account");
                	if(StringUtils.isNotBlank(account)){
                		if(!account.equals(UserSession.getUserSession(request).getStbMac())){
                			response.sendRedirect(this.createRedirectURL(request));
                            return;
                		}
                	}else if("".equals(account)){
                		response.sendRedirect(this.createRedirectURL(request));
                        return;
                	}
                }
            }
        }

        request.setAttribute("urlBase", request.getRequestURI());
		request.setAttribute("queryStr", request.getQueryString());

        chain.doFilter(request, response);
    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
     */
    public void init(FilterConfig config) throws ServletException {
//        loginRedirectUrl = config.getInitParameter("loginRedirectUrl");
//        loginSkipPattern = config.getInitParameter("loginSkipPattern");
        perl = new Perl5Util();
    }
    
    
    private String createRedirectURL(HttpServletRequest request) throws IOException {
        String backURI = request.getRequestURI();
        String queryString = request.getQueryString();
        if(StringUtils.isNotBlank(queryString)){
            backURI = backURI + "?" + queryString;
        }
        
        backURI = URLEncoder.encode(backURI, "UTF-8");
        
        
        StringBuffer buff = new StringBuffer();
        if(StringUtils.isNotBlank(queryString)){
            buff.append("?").append(queryString);
            buff.append("&backurl=").append(backURI);
        }else{
            buff.append("?backurl=").append(backURI);
        }
        
        if (!loginRedirectUrl.startsWith("http")) {
            return request.getContextPath() + loginRedirectUrl + buff.toString();
        } else {
            return loginRedirectUrl + buff.toString();
        }
    }
    
    private void logAccessLog(HttpServletRequest request, String curCat) {//HttpServletRequest request,int seq,String curCat
        EpgUserSession eus = EpgUserSession.getUserSession(request);
        if(eus != null){
        	String stbMac = eus.getStbMac().toString();
        	//----------2013.12.09修改--------------
        	//if(seq==0){
        		if(request.getQueryString() != null && request.getQueryString().contains("pc=")){
        			EpgLogFactory.getPageLogger().info(new StringBuffer(eus.getSmcId()).append("|").append(stbMac).append("|").append(request.getRequestURL())
            				.append("?"+request.getQueryString()).toString());
        		}else if(request.getQueryString() != null && !StringUtils.isBlank(curCat)){
        			EpgLogFactory.getPageLogger().info(new StringBuffer(eus.getSmcId()).append("|").append(stbMac).append("|").append(request.getRequestURL())
            				.append("?pc="+curCat+"&"+request.getQueryString()).toString());
        		}else{
        			EpgLogFactory.getPageLogger().info(new StringBuffer(eus.getSmcId()).append("|").append(stbMac).append("|").append(request.getRequestURL())
            				.append((request.getQueryString() == null) ? "" : ("?"+request.getQueryString())).toString());
        		}
            //----------2013.12.09修改--------------
        	/*}else{
        		if(request.getQueryString() != null && request.getQueryString().contains("pc=")){
        			EpgLogFactory.getPageLogger().info(new StringBuffer(eus.getSmcId()).append("|").append(stbMac).append("|").append(request.getRequestURL())
                    	    .append("?pi="+seq+"&"+request.getQueryString()).toString());
        		}else{
        			EpgLogFactory.getPageLogger().info(new StringBuffer(eus.getSmcId()).append("|").append(stbMac).append("|").append(request.getRequestURL())
                    	    .append((request.getQueryString() == null) ? "" : ("?pi="+seq+"&pc="+curCat+"&"+request.getQueryString())).toString());
        		}
        	}*/
        }
    }
    
    public String getLoginRedirectUrl() {
		return loginRedirectUrl;
	}

	public void setLoginRedirectUrl(String loginRedirectUrl) {
		this.loginRedirectUrl = loginRedirectUrl;
	}

	public String getLoginSkipPattern() {
		return loginSkipPattern;
	}

	public void setLoginSkipPattern(String loginSkipPattern) {
		this.loginSkipPattern = loginSkipPattern;
	}
    
    public static void main(String[] args) {
//    	for (int i = 0; i < 100; i++) {
//			System.out.println(RandomUtils.nextInt(100000));
//		}
    	String a = "/epg/biz/biz_88149754/cat/ccms_category_74215561/det/vod/program_imsp_544782.do";
    	String[] b = a.split("/");
    	String c = b[b.length-1];
    	String[] d = c.split(".do");
    	String e = d[0];
    	System.out.println(e);
    	boolean aa = StringUtils.isNotBlank("");
    	System.out.println(aa);
    	String[] refBiz = "ref=biz_60150362|null".split("ref=")[1].split("\\|");
    	System.out.println(refBiz[0]);
//    	System.out.println(a.split("&").length);
    }
}
