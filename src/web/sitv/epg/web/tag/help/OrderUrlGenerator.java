package sitv.epg.web.tag.help;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgSchedule;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

public class OrderUrlGenerator extends AbstractUrlGenerator {
	
	
	@SuppressWarnings("unchecked")
    public static String createUrl(HttpServletRequest request,Object element) {
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
        
        if (element instanceof EpgPlayableContent) {
        	EpgPlayableContent ep = (EpgPlayableContent)element;
            purl = NavigatorFactory.createOrderUrl(businessCode, categoryCode, ep.getProgramType(), ep.getContentCode(), ep.getOfferingId(), request);
        } else{
            logger.error("Not support create order url for " + element.getClass().getName());
        }
        
        return purl;
    }
}
