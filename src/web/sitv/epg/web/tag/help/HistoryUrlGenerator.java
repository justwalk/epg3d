/**
 * create with 2013-9-13 / 下午08:26:24
 */
package sitv.epg.web.tag.help;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import sitv.epg.entity.user.EpgUserHistory;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;

/**
 * @author <a href="mailto:shenxw@chances.com.cn">shenxw</a>
 */
public class HistoryUrlGenerator extends AbstractUrlGenerator {

    public static String createDeleteUrl(HttpServletRequest request,
            Object element) {
        String deleteUrl = "";
        if (element == null) {
            logger.warn("Input param element is null.");
            return deleteUrl;
        }

        String businessCode = "-";
        String categoryCode = "-";
        Map contextParams = (Map) request
                .getAttribute(EpgContext.CONTEXT_ATTR_NAME);
        if (contextParams != null) {
            businessCode = (String) contextParams.get(EpgContext.BIZCODE);
            categoryCode = (String) contextParams.get(EpgContext.CATCODE);
        }

        if (element instanceof EpgUserHistory) {
            EpgUserHistory euh = (EpgUserHistory) element;
            deleteUrl = NavigatorFactory.createDeleteHistoryUrl(euh,
                    businessCode, categoryCode, request);
        }
        return deleteUrl;
    }

}
