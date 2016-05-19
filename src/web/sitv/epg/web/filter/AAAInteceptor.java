package sitv.epg.web.filter;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.EpgLogGenerator;
import sitv.epg.business.dao.PlayerService;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.bo.BoException;
import sitv.epg.zhangjiagang.http.response.StartResponse;
import sitv.epg.zhangjiagang.service.AuthenticateService;
import chances.epg.exception.InvalidDataException;

/**
 * 3A 认证拦截器,仅拦截播放控制器
 * 
 * @author zhangxs
 * 
 */
public class AAAInteceptor extends HandlerInterceptorAdapter {
    private static Log logger = EpgLogFactory.getSystemLogger();

    @Autowired
    private AuthenticateService aaaService;

    @Autowired
    private PlayerService playerService;

    @Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception {
    	if(logger.isDebugEnabled()){
    		logger.debug("begin access " + request.getRequestURI());
    	}

        // 仅拦截播放controller
        if (!"PlayerController".equals(handler.getClass().getSimpleName()))
            return true;

        // 从url取出看吧,栏目,内容类型和内容编码
        String uri = request.getRequestURI();
        uri = uri.substring(uri.indexOf("/biz/") + 5, uri.lastIndexOf("."));
        String[] uris = uri.split("/");
        String bizCode = uris[0];
        String categoryCode = uris[2];
        String contentType = uris[4];
        String contentCode = uris[5];

        String pageCode = request.getParameter("rp");
        String refPosCat = request.getParameter("pc");
        String refPosInx = request.getParameter("pi");
        if(StringUtils.isBlank(pageCode)){
        	pageCode = "";
        }
        if(StringUtils.isBlank(refPosCat)){
        	refPosCat = "";
        }
        if(StringUtils.isBlank(refPosInx)){
        	refPosInx = "";
        }
        // 查询内容, 包含了多个offering
        EpgPlayableContent epc = playerService.searchContentByContentCode(contentCode);
        
        EpgUserSession userSession = (EpgUserSession) EpgUserSession.getUserSession(request);

        EpgContentOffering offering = this.getOffering(epc);
        if (offering == null) {
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createAuthErrorLog(userSession, bizCode,
                                categoryCode, offering,
                                EpgLogGenerator.SYSTEM_ERROR_CODE));
            }
            throw new InvalidDataException(
                    "no proper contentoffering return for content, code:"
                            + epc.getContentCode());
        }

        boolean authFlag = false;
        try {
        	authFlag = aaaService.auth(request, offering);
        } catch (BoException ex) {
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createAuthErrorLog(userSession, bizCode,
                                categoryCode, offering, ex.getErrorCode()));
            }
            throw ex;
        }

        if (authFlag) {
            logger.debug("Auth success.UserAccount:"
                    + userSession.getEpgSubscriber().getUserAccount() + ",OfferingId:"
                    + offering.getOfferingId());
            
            logAuth(userSession,bizCode,categoryCode,offering,contentType,pageCode,refPosCat,refPosInx,1);
            
            StartResponse startResponse = aaaService.getRtspUrl(userSession.getUserData(), offering.getOfferingId(), offering.getServiceCode());
            
            request.setAttribute(PlayerService.PROGRAM, epc.copy(offering));
            request.setAttribute(PlayerService.OFFERING, offering);
          
            //福建播放页用多剧集code
            //--------begin-------
            String seriesCode=request.getParameter("seriesCode");
            if(!StringUtils.isBlank(seriesCode)) {
            	request.setAttribute("seriesCode", seriesCode);
            }
            //---------end-------------
            
            request.setAttribute("startResponse", startResponse);
            request.setAttribute("userData", userSession.getUserData());
            return true;
        } else {
            logger.debug("Auth failed.UserAccount:"
                    + userSession.getEpgSubscriber().getUserAccount() + ",OfferingId:"
                    + offering.getOfferingId());
            logAuth(userSession,bizCode,categoryCode,offering,contentType,pageCode,refPosCat,refPosInx,2);
            // 需要跳到服务订购页面订购.
            String aaaUrl = NavigatorFactory.createOrderPageUrl(bizCode,
                    categoryCode, contentType, contentCode, offering
                            .getOfferingId(), request);
            response.sendRedirect(aaaUrl);
            return false;
        }
    }

    @Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
    	if(logger.isDebugEnabled()){
    		logger.debug("end access " + request.getRequestURI());
    	}
		super.afterCompletion(request, response, handler, ex);
	}

	private void logAuth(EpgUserSession userSession, String bizCode,
            String categoryCode, EpgContentOffering offering,
            String contentType, String pageCode, String refPosCat, String refPosInx, int flag) {
        if (EpgLogFactory.getAuthLogger().isInfoEnabled()) {
            String info = EpgLogGenerator.createAuthLog(userSession, bizCode,
                    categoryCode, offering, contentType);
            EpgLogFactory.getAuthLogger().info(info);
        }
    }

    private EpgContentOffering getOffering(EpgPlayableContent content) {
        List<EpgContentOffering> contentOfferings = content
                .getEpgContentOfferings();
        if (contentOfferings == null || contentOfferings.size() <= 0) {
            return null;
        }

        return contentOfferings.get(0);
    }
}
