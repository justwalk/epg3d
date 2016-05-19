/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.tag.help;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgRelContent;
import sitv.epg.entity.content.EpgSchedule;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.user.EpgSubscriberPPV;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class PlayUrlGenerator extends AbstractUrlGenerator {
    /**
     * 
     * @param request
     * @param element
     * @return
     */
    @SuppressWarnings("unchecked")
    public static String createUrl(HttpServletRequest request,Object element,String paramCode) {
        String purl = "";
        if(element == null) {
            logger.warn("Input param element is null.");
            return purl;
        }
        
        String businessCode = "-";
        String categoryCode = "-";
        Map contextParams = (Map)request.getAttribute(EpgContext.CONTEXT_ATTR_NAME);
        if(contextParams != null) {
            businessCode = (String) contextParams.get(EpgContext.BIZCODE);
            categoryCode = (String) contextParams.get(EpgContext.CATCODE);
        }
        
        if (element instanceof EpgCategoryItem) {
            EpgCategoryItem item = (EpgCategoryItem)element;
            purl = NavigatorFactory.createPlayVodUrl(item.getItemType(),item.getItemCode(),item.getCategoryCode(),businessCode,businessCode,categoryCode,request);
        } else if (element instanceof EpgProgram) {
            EpgProgram ep = (EpgProgram)element;
            purl = NavigatorFactory.createPlayVodUrl(ep,businessCode, categoryCode,request);
            String queryStr = createFixLogParams(request);
            if (!StringUtils.isBlank(queryStr)){
            	purl = new StringBuffer(purl).append(queryStr).toString();
    		}
        }
        /**
         *高标清混排 20140313 wangkai
         */
        else if (element instanceof EpgRelContent) {
        	EpgRelContent erc = (EpgRelContent)element;
            purl = NavigatorFactory.createPlayVodUrl(erc,businessCode,categoryCode,request);
		} 
        else if (element instanceof EpgUserCollection) {
            EpgUserCollection euc = (EpgUserCollection)element;
            purl = NavigatorFactory.createPlayVodUrl(euc, businessCode,request);
            String queryStr = createFixLogParams(request);
            if (!StringUtils.isBlank(queryStr)){
            	purl = new StringBuffer(purl).append(queryStr).toString();
    		}
        } else if (element instanceof EpgEpisode) {
            EpgEpisode eep = (EpgEpisode)element;
            purl = NavigatorFactory.createPlayVodUrl(eep,businessCode,categoryCode,request);
            String queryStr = createFixLogParams(request);
            if (!StringUtils.isBlank(queryStr)){
            	purl = new StringBuffer(purl).append(queryStr).toString();
    		}
        } else if (element instanceof EpgSchedule) {
        	EpgSchedule es = (EpgSchedule) element;
        	if(categoryCode == null){
        		purl = NavigatorFactory.createPlayScheduleUrl(EpgCategoryItem.ITEMTYPE_VOD, es.getContentCode(), paramCode, businessCode, es.getChannelCode(),request);
        	}
        	else{
        	//purl = NavigatorFactory.createPlayVodUrl(EpgCategoryItem.ITEMTYPE_VOD, es.getContentCode(), categoryCode, businessCode, request);
        		purl = NavigatorFactory.createPlayScheduleUrl(EpgCategoryItem.ITEMTYPE_VOD, es.getContentCode(), categoryCode, businessCode, es.getChannelCode(),request);
        	}
        } else if (element instanceof EpgSubscriberPPV) {
        	EpgSubscriberPPV ppv = (EpgSubscriberPPV) element;
        	purl = NavigatorFactory.createPlayVodUrl(ppv, request);
        } else{
            logger.error("Not support create play url for " + element.getClass().getName());
        }
        
        return purl;
    }
}
