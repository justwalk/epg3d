/**
 * create with 2013-9-15 / 下午07:26:27
 */
package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.dao.HistoryService;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.exception.NavigatorException;

/**
 * @author <a href="mailto:shenxw@chances.com.cn">shenxw</a>
 */
@Controller
public class HistoryController extends AbstractController {

    @Autowired
    private HistoryService historyService;

    @RequestMapping(value = "/deleteHistory", method = RequestMethod.GET)
    public void deleteCollection(HttpServletRequest request, ModelMap model,
            @RequestParam("bizCode") String bizCode, 
            @RequestParam("categoryCode") String categoryCode, 
            HttpServletResponse response) {

		EpgUserSession eus = (EpgUserSession) EpgUserSession.findUserSession(request);
        historyService.delUserHistoryByUserId(eus.getUserAccount());

        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        String url = NavigatorFactory.createBusinessIndexUrl(bizCode, request);
        setContext(model, request, epgContext);

        try {
            response.sendRedirect(url + "&randomNum="
                    + RandomStringUtils.randomAlphabetic(3));
        } catch (Exception e) {
            throw new NavigatorException("Failure to navigate to url:" + url, e);
        }

    }
}
