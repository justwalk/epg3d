package sitv.epg.nav.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.dao.HistoryService;
import sitv.epg.business.dao.PlayerService;
import sitv.epg.business.dao.SeriesmarkService;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.business.EpgHostProFile;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.entity.user.EpgUserHistory;
import sitv.epg.entity.user.EpgUserSeriesmark;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
/**
 * 播放控制
 * 播放各类节目
 * 如果需要播放广告,则获取广告信息
 * @author zhangxs
 *
 */
@Controller
public class PlayerController extends AbstractController {

	private static Log logger = EpgLogFactory.getSystemLogger();

	@Autowired
	private PlayerService playerService;
	
	/*@Autowired
	private AdManager adManager;*/
	
	@Autowired
	private SeriesmarkService seriesmarkService;
	
	private static final int MARK_FAILED=2;
	@Autowired
    private HistoryService historyService;
	/**
	 * 点播播放导航
	 * 经检查发现无需认证时跳往本页面播放
	 * @return
	 */
	@RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/play/{contentType}/{contentCode}", method = RequestMethod.GET)
	public String play(@PathVariable String businessCode,
			@PathVariable String categoryCode,
			@PathVariable String contentType, @PathVariable String contentCode,
		    @RequestParam(value="rp", required=false) String rp,
		    @RequestParam(value="pc", required=false) String pc,
		    @RequestParam(value="pi", required=false) String pi,
			ModelMap model, HttpServletRequest request) {
		//剧集书签处理
		String seriesCode=request.getParameter("seriesCode");
		String episodeIndex=request.getParameter("episodeIndex");
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		if(!StringUtils.isBlank(seriesCode)&&!StringUtils.isBlank(episodeIndex)) {
			EpgUserSeriesmark epgUserSeriesmark = new EpgUserSeriesmark();
			epgUserSeriesmark.setContentCode(seriesCode);
			epgUserSeriesmark.setEpisodeIndex(Integer.parseInt(episodeIndex));
			
			
			if(eus == null){
				logger.info("-------------------"+MARK_FAILED);
			}
			epgUserSeriesmark.setUserId(eus.getUserAccount());
			
			if (logger.isDebugEnabled()){
				logger.debug(epgUserSeriesmark.toString());
			}
			seriesmarkService.addSeriesmark(epgUserSeriesmark);
		}
		// 增加用户历史信息
        EpgUserHistory userHistory = new EpgUserHistory();
        userHistory.setUserId(eus.getUserAccount());
        userHistory.setContentType(contentType.toLowerCase());
        userHistory.setContentCode(contentCode);
        userHistory.setSeriesCode(seriesCode);
        userHistory.setBizCode(businessCode);
        userHistory.setCategoryCode(categoryCode);
        userHistory.setCreateTime(new Date());
        
        String contentName = historyService.getProgramName(userHistory, episodeIndex);
        userHistory.setContentName(contentName);
        boolean isExist = historyService.existHistory(userHistory);
        if(isExist){
            historyService.updateUserHistory(userHistory);
        }else{
            historyService.addUserHistory(userHistory);
        }
        
        boolean limitResult = historyService.limitHistory(userHistory);
        if (!limitResult) {
            historyService.delUserHistoryById(userHistory);
        }
		//播放焦点处理
		playFocusHandle(request);
		String elapsed = request.getParameter("contentElapsed");
		String zero = "0";
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		epgContext.addContextParams(EpgContext.CONTENTTYPE, contentType);
		epgContext.addContextParams(EpgContext.CONTENTCODE, contentCode);
		if(StringUtils.isBlank(rp)){
			rp = "";
        }
		if(StringUtils.isBlank(pc)){
			pc = "";
        }
		if(StringUtils.isBlank(pi)){
			pi = "";
        }
        epgContext.addContextParams(EpgContext.PAGECODE, rp);
        epgContext.addContextParams(EpgContext.POSTIONCODE, pc);
        epgContext.addContextParams(EpgContext.POSTIONINDEX, pi);
		
		// 查询看吧,可以没有
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);

        // 查询栏目,可以没有
        EpgCategory category = this.getEpgCategory(epgContext, categoryCode);
		
        //认证过以后内容可以从request获取
		EpgPlayableContent epc = (EpgPlayableContent) request.getAttribute(PlayerService.PROGRAM);
		EpgContentOffering eco = (EpgContentOffering) request.getAttribute(PlayerService.OFFERING);
		if (epc == null){
			//如果找不到,则从数据库中查询,这时offering还为未迁移数据之前的.
			epc = playerService.searchContentByContentCode(contentCode);
			model.put(PlayerService.PROGRAM, epc);
		}
		model.put(PlayerService.OFFERING,eco);
		
		/*List<EpgHostProFile> playParams = playerService.getPlayerParams();
		
		List<EpgHostProFile> playParams1 = paramsPreHandler(eco, playParams);		
		
		Map<String, String> params = playerService.parseParams(playParams1);
		model.put(PlayerService.PARAMS, params);*/
		
		/*adManager.adLogicHandle(contentType, contentCode, model, request, epgContext, epc,
				params);*/
		if(StringUtils.isEmpty(elapsed)){
			model.put("contentElapsed", zero);
		}else{
			model.put("contentElapsed", elapsed);
		}
		setContext(model, request, epgContext);
		return "/common/play/playVod";
        
	}
	
	/**
	 * 对收费类型的服务的purchaseType做设置
	 * @param eco
	 * @param playParams
	 */
	private List<EpgHostProFile> paramsPreHandler(EpgContentOffering eco,
			List<EpgHostProFile> playParams) {
		List<EpgHostProFile> params = new ArrayList<EpgHostProFile>();
		EpgHostProFile epf;
		for(EpgHostProFile profile:playParams){
			epf = new EpgHostProFile();
			epf.setGroupId(profile.getGroupId());
			epf.setHostCode(profile.getHostCode());
			epf.setHostIp(profile.getHostIp());
			epf.setHostName(profile.getHostName());
			epf.setId(profile.getId());
			epf.setName(profile.getName());
			epf.setStatus(profile.getStatus());
			epf.setValue(profile.getValue());
			params.add(epf);
		}
		String serviceTypes = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.NEED_AUTH_SERVICE_TYPE);
		String[] authServices = serviceTypes.split(",");		
		for(int i=0;i<authServices.length;i++){
			if (eco.getServiceType().equals(authServices[i])){
				 for(int k=0;params!=null && k<params.size();k++){
		                if("purchase_type".equals(params.get(k).getName())){
		                	params.get(k).setValue(HAS_ORDER_PURCHSE_TYPE);
		                    //break;
		                }
		          }
				break;
			}
		}
		return params;
	}
	
	/**
	 * 访问看吧栏目下直播频道
	 * 
	 * @return
	 */
	@RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/play/channel/{channelCode}", method = RequestMethod.GET)
	public String accessBusinessCategoryChannal(
			@PathVariable String businessCode,
			@PathVariable String categoryCode,
			@PathVariable String channelCode, ModelMap model,
			HttpServletRequest request) {
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		epgContext.addContextParams(EpgContext.CHACODE, channelCode);
		
		setContext(model, request, epgContext);
		
		return "/common/play/playChannel";
	}
}
