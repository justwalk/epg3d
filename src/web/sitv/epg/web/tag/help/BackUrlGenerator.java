/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.tag.help;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.exception.InvalidDataException;
import chances.epg.utils.PathWraper;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class BackUrlGenerator extends AbstractUrlGenerator {
    
    public static String createUrl(HttpServletRequest request,String returnType) {
        String contextPath = request.getContextPath();
        EpgUserSession eus = EpgUserSession.findUserSession(request);
        String url = null;
        
        if ("home".equals(returnType)) {
            url = generateHomeUrl(request, contextPath, eus);
            return url;
        } else if ("biz".equals(returnType)) {
        	url = generateBizIndexUrl(request);
            return url;
        } else if ("bizcat".equals(returnType)) {
        	url = generateCategoryIndexUrl(request);
            return url;
        } 
        /*
        else if ("search".equals(returnType)) {
        	url = generateSearchUrl(request);
            return url;
        } else if ("collection".equals(returnType)) {
        	url = generateMyCollectionUrl(request);
            return url;
        }*/
        return url;
    }
	/*
	private static String generateMyCollectionUrl(HttpServletRequest request) {
		String url;
		url = NavigatorFactory.createMyCollectionUrl(request);
		String queryStr = createFixUrlParamsByUrl(request);
		if (!StringUtils.isBlank(queryStr)){
			url = new StringBuffer(url).append("&").append(queryStr).toString();
		}
		return url;
	}

	private static String generateSearchUrl(HttpServletRequest request) {
		String url;
		url = NavigatorFactory.createSearchUrl(request);
		String queryStr = createFixUrlParamsByUrl(request);
		if (!StringUtils.isBlank(queryStr)){
			url = new StringBuffer(url).append("&").append(queryStr).toString();
		}
		return url;
	}
	*/
	private static String generateCategoryIndexUrl(HttpServletRequest request) {
		String url;
		EpgContext epgContext = (EpgContext) request.getAttribute(EpgContext.CONTEXT_OBJ);
		EpgBusiness biz = epgContext.getEpgBusiness();
         
		String bizCode = NavigatorFactory.GANG;
		if (biz != null){
			bizCode = biz.getCode();
		}
		
		EpgCategory category = epgContext.getCategory();
		String catCode = NavigatorFactory.GANG;
		if (category != null){
			catCode = category.getCode();
		}
		
		url = NavigatorFactory.createCategoryIndexUrl(catCode, bizCode, request);
		String queryStr = createFixUrlParamsByUrl(request);
		if (!StringUtils.isBlank(queryStr)){
			url = new StringBuffer(url).append(queryStr).toString();
		}
		
		return url;
	}

	private static String generateBizIndexUrl(HttpServletRequest request) {
		String url;
		EpgContext epgContext = (EpgContext) request.getAttribute(EpgContext.CONTEXT_OBJ);
		EpgBusiness biz = epgContext.getEpgBusiness();
		String bizCode = NavigatorFactory.GANG;
		if (biz != null){
			bizCode = biz.getCode();
		}
		url = NavigatorFactory.createBusinessIndexUrl(bizCode, request);
		String queryStr = createFixUrlParamsByUrl(request);
		if (!StringUtils.isBlank(queryStr)){
			url = new StringBuffer(url).append(queryStr).toString();
		}
		
		return url;
	}

	private static String generateHomeUrl(HttpServletRequest request,
			String contextPath, EpgUserSession eus) {
		String url;
		StringBuffer sb = new StringBuffer();
		sb.append(NavigatorFactory.getContextPath(request));
		sb.append("home/home_");
		if (eus!=null){
		    sb.append(eus.getEntry());
		}
		sb.append(".do?");
		url = sb.append(EpgUserSession.createFixUrlParams(request)).toString();
		String queryStr = createFixUrlParamsByUrl(request);
		if (!StringUtils.isBlank(queryStr)){
			url = new StringBuffer(url).append(queryStr).toString();
		}
		return url;
	}
}
