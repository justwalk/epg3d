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

import sitv.epg.entity.business.EpgPosition;
import sitv.epg.entity.business.EpgSubjectArea;
import sitv.epg.entity.content.EpgBaseContent;
import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgRelContent;
import sitv.epg.entity.content.EpgSchedule;
import sitv.epg.entity.content.SearchEpgProgram;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.user.EpgUserBookmark;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.entity.user.EpgUserHistory;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

/**
 * Class comments.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class IndexUrlGenerator extends AbstractUrlGenerator {
    @SuppressWarnings("unchecked")
    public static String createUrl(HttpServletRequest request, Object element) {
        String elementUrl = "";
        if (element == null) {
            logger.warn("Input param element is null.");
            return elementUrl;
        }

        String businessCode = "-";
        String categoryCode = "-";
        Map contextParams = (Map) request
                .getAttribute(EpgContext.CONTEXT_ATTR_NAME);
        if (contextParams != null) {
            businessCode = (String) contextParams.get(EpgContext.BIZCODE);
            categoryCode = (String) contextParams.get(EpgContext.CATCODE);
        }

        if (element instanceof EpgCategoryItem) {
            EpgCategoryItem item = (EpgCategoryItem) element;
            elementUrl = NavigatorFactory.createCatetoryItemIndexUrl(item,
                    businessCode, categoryCode, request);
        } else if (element instanceof EpgBaseContent) {
        	EpgBaseContent ep = (EpgBaseContent) element;
            elementUrl = NavigatorFactory.createVODIndexUrl(
                    ep.getContentType(), ep.getContentCode(), categoryCode,
                    businessCode, businessCode, categoryCode, request);
        } else if (element instanceof EpgUserCollection) {
            EpgUserCollection euc = (EpgUserCollection) element;
            elementUrl = NavigatorFactory.createUserCollectionIndexUrl(euc,
                    businessCode, request);
        } else if (element instanceof EpgUserBookmark) {
        	EpgUserBookmark eub = (EpgUserBookmark) element;
            elementUrl = NavigatorFactory.createUserBookmarkIndexUrl(eub,
                    businessCode, request);
        } else if (element instanceof EpgPosition) {
            EpgPosition ep = (EpgPosition) element;
            elementUrl = NavigatorFactory.createPositionLinkUrl(ep,
                    businessCode, request);
        } else if (element instanceof EpgSubjectArea) {
            EpgSubjectArea esa = (EpgSubjectArea) element;
            elementUrl = NavigatorFactory.createSubjectLinkUrl(
                    esa.getObjType(), esa.getObjCode(), esa.getPageCode(), businessCode,
                    categoryCode, businessCode, categoryCode, request);
        } else if (element instanceof EpgEpisode) {
            EpgEpisode ee = (EpgEpisode) element;
            elementUrl = NavigatorFactory.createEpisodeIndexUrl(
                    EpgCategoryItem.ITEMTYPE_EPISODE, ee.getContentCode(),
                    categoryCode, businessCode, businessCode, categoryCode, request);
        } else if (element instanceof EpgSchedule) {
            EpgSchedule es = (EpgSchedule) element;
            elementUrl = NavigatorFactory.createScheduleIndexUrl(es,
                    categoryCode, businessCode, request);
        }  else if (element instanceof EpgUserHistory) {
            EpgUserHistory esp = (EpgUserHistory) element;
            elementUrl = NavigatorFactory.createPlayVodUrl(esp, businessCode,
                    "history", request);
        } else if (element instanceof SearchEpgProgram) {
            SearchEpgProgram esp = (SearchEpgProgram) element;
            elementUrl = NavigatorFactory.createUserSearchIndexUrl(esp,
                    businessCode,"search",request);
        }/**
         *高标清混排 20140313 wangkai
         */
        else if (element instanceof EpgRelContent) {
        	EpgRelContent erc = (EpgRelContent)element;
        	elementUrl = NavigatorFactory.createEpgRelContentIndexUrl(erc,businessCode,categoryCode,request);
		}else {
            //logger.warn("Not support create index url for "
            //        + element.getClass().getName() +" object is "+element);
        	return elementUrl;
        }

        return appendExtraParams(request, elementUrl);
    }
}
