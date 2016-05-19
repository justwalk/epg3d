package sitv.epg.nav.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import chances.epg.exception.EpgRuntimeException;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.EpgLogGenerator;
import sitv.epg.business.dao.PlayerService;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.bo.BoException;
import sitv.epg.zhangjiagang.bo.Ticket;
import sitv.epg.zhangjiagang.service.AuthenticateService;

/**
 * 订购处理
 * 
 * @author zhangxs
 * 
 */
@Controller
public class OrderController extends AbstractController {
    private static Log logger = EpgLogFactory.getSystemLogger();
    private static String SESSION_PRODUCT = "productInfo";

    @Autowired
    private PlayerService playerService;

    @Autowired
    private AuthenticateService authenticateService;

    /**
     * PPV订购保存,并播放
     * 
     * @param businessCode
     * @param categoryCode
     * @param contentType
     * @param contentCode
     * @param offeringId
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/orderPage/{contentType}/{contentCode}/{offeringId}/ajax", method = RequestMethod.GET)
    public String order(@PathVariable
    String businessCode, @PathVariable
    String categoryCode, @PathVariable
    String contentType, @PathVariable
    String contentCode, @PathVariable
    String offeringId, ModelMap model, HttpServletRequest request) {
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.CONTENTTYPE, contentType);
        epgContext.addContextParams(EpgContext.CONTENTCODE, contentCode);

        EpgUserSession eus = (EpgUserSession) EpgUserSession
                .findUserSession(request);
        if (eus == null) {
            logger.error("Order failed,not found userAccount.");
            request.setAttribute("data", "订购失败");
            return "/common/data";
        }

        EpgBusiness biz = null;
        EpgCategory category = null;
        EpgContentOffering eco = null;
        EpgPlayableContent epc = null;
        try {
            // 查询看吧,可以没有
            biz = this.getEpgBusiness(epgContext, businessCode);

            // 查询栏目,可以没有
            category = this.getEpgCategory(epgContext, categoryCode);

            // 订购信息记录
            epc = playerService.searchContentByContentCode(contentCode);
            eco = epc.getOfferingByOfferingId(offeringId);
            epgContext.addContextParams(PlayerService.PROGRAM, epc);
            epgContext.addContextParams(PlayerService.OFFERING, eco);
            Ticket ticket = null;//authenticateService.order(request, eco.getServiceCode(), eco.getOfferingId());
            request.getSession().removeAttribute(SESSION_PRODUCT);
            request.setAttribute("data", "OK");
            
            //记录订购日志.
            this.logOrder(eus, biz, category, eco, contentType, ticket);
        } catch (BoException ex) {
            logger.error(ex.getMessage(), ex);
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createOrderErrorLog(eus, biz, category,
                                eco, ex.getErrorCode()));
            }
            request.setAttribute("data", ex.getErrorCode());
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createOrderErrorLog(eus, biz, category,
                                eco, EpgLogGenerator.SYSTEM_ERROR_CODE));
            }
            request.setAttribute("data", "订购失败");
        }

        return "/common/data";
    }

    /**
     * 跳转到订购页面
     * 
     * @param businessCode
     * @param categoryCode
     * @param contentType
     * @param contentCode
     * @param offeringId
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/orderPage/{contentType}/{contentCode}/{offeringId}", method = RequestMethod.GET)
    public String orderPage(@PathVariable
    String businessCode, @PathVariable
    String categoryCode, @PathVariable
    String contentType, @PathVariable
    String contentCode, @PathVariable
    String offeringId, ModelMap model, HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        /*String playBackURL = (String) request.getSession().getAttribute(
                "PlayBackURL");
        if (playBackURL != null) {
            request.getSession().removeAttribute("PlayBackURL");
            response.sendRedirect(playBackURL);
            return null;
        }

        String referer = request.getHeader("referer");
        request.getSession().setAttribute("PlayBackURL", referer);*/

        // 播放焦点处理
        playFocusHandle(request);

        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.CONTENTTYPE, contentType);
        epgContext.addContextParams(EpgContext.CONTENTCODE, contentCode);

        EpgUserSession eus = (EpgUserSession) EpgUserSession
                .findUserSession(request);
        EpgBusiness biz = null;
        EpgCategory category = null;
        EpgContentOffering eco = null;
        EpgPlayableContent epc = null;

        try {
            // 查询看吧,可以没有
            biz = this.getEpgBusiness(epgContext, businessCode);

            // 查询栏目,可以没有
            category = this.getEpgCategory(epgContext, categoryCode);

            // 订购信息记录
            epc = playerService.searchContentByContentCode(contentCode);
            eco = epc.getOfferingByOfferingId(offeringId);
            epc = epc.copy(eco);
            model.put(PlayerService.PROGRAM, epc);
            model.put(PlayerService.OFFERING, eco);

            setContext(model, request, epgContext);

            // added by libf,2011/07/07
            String serviceType = epc.getServiceType();
            if ("1".equals(serviceType) || "3".equals(serviceType)) {
                Ticket ticket = null;//authenticateService.prePurchaseProduct(request, eco.getOfferingId(), eco.getServiceCode());
                request.getSession().setAttribute(SESSION_PRODUCT, ticket);
            }
        } catch (BoException ex) {
            logger.error(ex.getMessage(), ex);
            EpgLogFactory.getErrorLogger().info(
                    EpgLogGenerator.createOrderErrorLog(eus, biz, category,
                            eco, ex.getErrorCode()));
            throw ex;
        } catch (EpgRuntimeException ex) {
            logger.error(ex.getMessage(), ex);
            EpgLogFactory.getErrorLogger().info(
                    EpgLogGenerator.createOrderErrorLog(eus, biz, category,
                            eco, EpgLogGenerator.SYSTEM_ERROR_CODE));
            throw ex;
        }

        return "/common/order/order_"
                + EpgUserSession.findUserSession(request).getEntry();
    }

    private void logOrder(EpgUserSession userSession, EpgBusiness biz,
            EpgCategory category, EpgContentOffering offering,
            String contentType, Ticket ticket) {
        ticket.setOrderType(Ticket.RVOD_ORDER_TYPE);
        if (EpgLogFactory.getOrderLogger().isInfoEnabled()) {
            String info = EpgLogGenerator.createOrderLog(userSession, biz,
                    category, offering, contentType, ticket);
            EpgLogFactory.getOrderLogger().info(info);
        }
    }
}
