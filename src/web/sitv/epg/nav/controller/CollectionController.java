package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.dao.CollectionService;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.exception.NavigatorException;
/**
 * 收藏导航控制
 * @author zhangxs
 *
 */
@Controller
public class CollectionController extends AbstractController {
	
	private static Log logger = EpgLogFactory.getSystemLogger();
	@Autowired
	private CollectionService collectionService;

	
	private static final int COLLECT_SUCCESS=1;
	private static final int COLLECT_FAILED=2;
	private static final int COLLECT_FULL=5;
	


	
	/**
	 * 添加收藏
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addCollection")
	public String addCollection(HttpServletRequest request,
			@RequestParam(value="contentType", required=false) String contentType,
			@RequestParam(value="contentCode", required=true) String contentCode,
			@RequestParam(value="contentName", required=true) String contentName,
			@RequestParam(value="bizCode", required=false) String bizCode,
			@RequestParam(value="categoryCode", required=false) String categoryCode,
			 ModelMap model) {
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		EpgUserCollection epgUserCollection = new EpgUserCollection();
		epgUserCollection.setContentType(contentType);
		epgUserCollection.setContentCode(contentCode);
		epgUserCollection.setContentName(contentName);	
		if (!"null".equals(bizCode)){
			epgUserCollection.setBizCode(bizCode);
		}
		if (!"null".equals(categoryCode)){
			epgUserCollection.setCategoryCode(categoryCode);
		}
		
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		epgUserCollection.setMacAddr(eus.getUserAccount());
		epgUserCollection.setUserId(eus.getUserAccount());
		model.put("contentName", contentName);
		String result = CommonUrlGenerator.getInstance().createCommonPage(request, "/collect/collectPage");
		boolean exist = collectionService.existCollection(epgUserCollection);
		if (exist) {
			model.put("isSuccess", COLLECT_FAILED);
			
			return result;
		}
		
		boolean limit = collectionService.limitCollection(epgUserCollection);
		if (!limit) {
			model.put("isSuccess", COLLECT_FULL);
			return result;
		}
		//
		collectionService.addCollection(epgUserCollection);
		if (logger.isDebugEnabled()){
			logger.debug(epgUserCollection.toString());
		}
		model.put("isSuccess", COLLECT_SUCCESS);
		setContext(model, request, epgContext);
		return result;
	}

/*	private EpgDetailProgram getProgram(HttpServletRequest request, String contentCode) {
		WebApplicationContext applicationContext = RequestContextUtils.getWebApplicationContext(request);
		BaseDaoiBatis baseDao = (BaseDaoiBatis) applicationContext.getBean("baseDao");
		Map  params = new HashMap();
		params.put("contentCode", contentCode);
		try{
			List edpList=baseDao.getSqlMapClientTemplate().queryForList("queryProgramDetailByCode", params);
			if (edpList == null || edpList.size() == 0){
				throw new InvalidDataException("invalid data of programCode:"+contentCode);
			}
			return (EpgDetailProgram) edpList.get(0);
		}catch(Exception e){
			throw new DaoException("error produced when query progaram "+contentCode);
		}finally{
			params.clear();
			params = null;
		}
		
	}
*/
	/**
	 * 删除收藏
	 * 
	 * @return
	 */
	@RequestMapping(value = "/deleteCollection")
	public void deleteCollection(HttpServletRequest request, ModelMap model,
			@RequestParam("id") String collectionId,HttpServletResponse response
			) {
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		collectionService.delectCollection(collectionId);
		
		String url = NavigatorFactory.createMyCollectionUrl(request);
		String pageIndex=request.getParameter("pageIndex");
		
		setContext(model, request, epgContext);
        
		
		if(pageIndex!=null){
			url= new StringBuffer(url).append("&pageIndex=").append(pageIndex).toString();
		}else{
			url = url+"?randomNum="+RandomStringUtils.randomAlphabetic(3);
		}
		try {			
			response.sendRedirect(url);							
		} catch (Exception e) {
			throw new NavigatorException("Failure to navigate to url:"
					+ url, e);
		}
	}

	/**
	 * 我的收藏
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myCollection")
	public String accessMyCollection(ModelMap model, HttpServletRequest request) {
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);

		epgContext.addContextParams("userId",EpgUserSession.findUserSession(request).getUserAccount());
		
		setContext(model, request, epgContext);
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/collect/myCollection");
	}

}
