package sitv.epg.web.tag.help;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.user.EpgUserBookmark;
import sitv.epg.nav.controller.AbstractController;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

/**
 * @author wangkai
 * 书签链接生成
 */
public class BookmarkUrlGenerator extends AbstractController {
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
        
        if (element instanceof EpgPlayableContent) {
        	EpgPlayableContent epc = (EpgPlayableContent) element;
            elementUrl = NavigatorFactory.createAddBookmarkUrl(epc, businessCode,categoryCode,request);
        } else {
            logger.error("Not support create add bookmark url for " + element.getClass().getName());
        }
        
        return elementUrl;
    }
    
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
        
        if (element instanceof EpgUserBookmark) {
        	EpgUserBookmark eub = (EpgUserBookmark)element;
            deleteUrl = NavigatorFactory.createDeleteBookmarkUrl(eub,businessCode, pageIndex,request);
        } else {
            logger.error("Not support create add bookmark url for " + element.getClass().getName());
        }
       
        return deleteUrl;
    }
}
