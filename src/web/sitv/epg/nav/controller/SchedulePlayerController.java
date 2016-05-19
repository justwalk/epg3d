/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.nav.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import sitv.epg.business.dao.PlayerService;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.business.EpgHostProFile;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgLiveChannel;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;


/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
@Controller
public class SchedulePlayerController extends AbstractController {
    @Autowired
    private PlayerService playerService;
    
    /*@Autowired
    private AdManager adManager;*/
    /**
     * 点播播放导航
     * 经检查发现无需认证时跳往本页面播放
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/cha/{channelCode}/play/{contentType}/{contentCode}", method = RequestMethod.GET)
    public String play(@PathVariable String businessCode,
            @PathVariable String categoryCode,
            @PathVariable String channelCode,
            @PathVariable String contentType, @PathVariable String contentCode,
            ModelMap model, HttpServletRequest request) {
        //播放焦点处理
        playFocusHandle(request);
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.CONTENTTYPE, contentType);
        epgContext.addContextParams(EpgContext.CONTENTCODE, contentCode);
        
        // 查询看吧,可以没有
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);

        // 查询栏目,可以没有
        EpgCategory category = this.getEpgCategory(epgContext, categoryCode);
        
        //获取内容
        EpgPlayableContent epc = playerService.searchContentByContentCode(contentCode);
        EpgContentOffering select = this.selectContentOffering(channelCode, epc);
        
        model.put(PlayerService.PROGRAM, epc);
        model.put(PlayerService.OFFERING, select);
        
        List<EpgHostProFile> playParams = playerService.getPlayerParams();
        
        Map<String, String> params = playerService.parseParams(playParams);
        model.put(PlayerService.PARAMS, params);
        
        /*adManager.adLogicHandle(contentType, contentCode, model, request, epgContext, epc,
                params);*/
        
        setContext(model, request, epgContext);
         
        return "/common/play/playVod";
        
    }
    
    protected EpgContentOffering selectContentOffering(String channleCode,EpgPlayableContent epc) {
        EpgLiveChannel channle = playerService.getChannleByCode(channleCode);
        List<EpgContentOffering> contentOfferings = epc.getEpgContentOfferings();
        
        EpgContentOffering select = contentOfferings.get(0);
        
        for (EpgContentOffering epgContentOffering : contentOfferings) {
            if(epgContentOffering.getServiceName().equals(channle.getServiceName())){
                select = epgContentOffering;
                break;
            }
        }
        
        return select;
    }
    
    /**
     * @param playerService the playerService to set
     */
    public void setPlayerService(PlayerService playerService) {
        this.playerService = playerService;
    }
    /**
     * @param adManager the adManager to set
     */
    /*public void setAdManager(AdManager adManager) {
        this.adManager = adManager;
    }*/
}
