package sitv.epg.web.context;

import javax.servlet.http.HttpServletRequest;

import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.zhangjiagang.EpgUserSession;

public class EpgContextFactory {
	/**
	 * 
	 * @param request
	 * @return
	 */
	public static EpgContext createEpgContext(HttpServletRequest request) {
	    
	    EpgContext epgContext = new EpgContext();
	    epgContext.addContextParams(EpgContext.EPG_CONTEXT, request.getContextPath());
	    epgContext.addContextParams(EpgContext.FIXPARAMS, EpgUserSession.createFixUrlParams(request));
	    epgContext.addContextParams(EpgContext.HELPURL, NavigatorFactory.createHelpUrl(request));
	    epgContext.addContextParams(EpgContext.MYCOLLECTIONURL, NavigatorFactory.createMyCollectionUrl(request));
	    epgContext.addContextParams(EpgContext.SEARCHURL, NavigatorFactory.createSearchUrl(request));
	    epgContext.addContextParams(EpgContext.MYBOOKMARKURL, NavigatorFactory.createMyBookmarkUrl(request));
	    epgContext.addContextParams(EpgContext.HISTORY, NavigatorFactory.createHistoryUrl(request));
	    epgContext.addContextParams(EpgContext.SELF, NavigatorFactory.createSelfUrl(request));
	    return epgContext;
	}
}
