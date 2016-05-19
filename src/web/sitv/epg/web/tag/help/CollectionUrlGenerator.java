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

import sitv.epg.entity.content.EpgBaseContent;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class CollectionUrlGenerator extends AbstractUrlGenerator {
    @SuppressWarnings("unchecked")
    public static String createAddUrl(HttpServletRequest request,Object element) {
        String elementUrl = "";
        if(element == null) {
            logger.warn("Input param element is null.");
            return elementUrl;
        }
        
        String businessCode = "-";
        String categoryCode = "-";
        Map contextParams = (Map)request.getAttribute(EpgContext.CONTEXT_ATTR_NAME);
        if(contextParams != null) {
            businessCode = (String) contextParams.get(EpgContext.BIZCODE);
            categoryCode = (String) contextParams.get(EpgContext.CATCODE);
        }
        
        if (element instanceof EpgProgram) {
            EpgProgram ep = (EpgProgram) element;
            elementUrl = NavigatorFactory.createAddCollectionUrl(ep, businessCode,categoryCode,request);
        } else if (element instanceof EpgCategoryItem) {
            EpgCategoryItem item = (EpgCategoryItem)element;
            elementUrl = NavigatorFactory.createAddCollectionUrl(item, businessCode,categoryCode,request);
        } else if (element instanceof EpgSeries) {
            EpgSeries es = (EpgSeries) element;
            elementUrl = NavigatorFactory.createAddCollectionUrl(es, businessCode,categoryCode,request);
        } else  if (element instanceof EpgBaseContent){
        	EpgBaseContent ep = (EpgBaseContent) element;
            elementUrl = NavigatorFactory.createAddCollectionUrl(ep, businessCode,categoryCode,request);
        }else{
            logger.error("Not support create add collection url for " + element.getClass().getName());
        }
        
        return elementUrl;
    }
    
    @SuppressWarnings("unchecked")
    public static String createDeleteUrl(HttpServletRequest request,Object element){
        String deleteUrl = "";
        if(element == null) {
            logger.warn("Input param element is null.");
            return deleteUrl;
        }
        
        String pageIndex = request.getParameter("pageIndex");
        String businessCode = "-";
        Map contextParams = (Map)request.getAttribute(EpgContext.CONTEXT_ATTR_NAME);
        if(contextParams != null) {
            businessCode = (String) contextParams.get(EpgContext.BIZCODE);
        }
        
        if (element instanceof EpgUserCollection) {
            EpgUserCollection euc = (EpgUserCollection)element;
            deleteUrl = NavigatorFactory.createDeleteCollectionUrl(euc,businessCode, pageIndex,request);
        } else {
            logger.error("Not support create add collection url for " + element.getClass().getName());
        }
       
        return deleteUrl;
    }
}
