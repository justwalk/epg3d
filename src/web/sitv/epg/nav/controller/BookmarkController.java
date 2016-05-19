package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.dao.BookmarkService;
import sitv.epg.entity.user.EpgUserBookmark;
import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.exception.NavigatorException;

/**
 * @author wangkai
 *	书签导航控制
 */
@Controller
public class BookmarkController extends AbstractController {
	private static Log logger = EpgLogFactory.getSystemLogger();
	
	@Autowired
	private BookmarkService bookmarkService;
	
	private static final int MARK_SUCCESS=1;
	private static final int MARK_FAILED=2;
	//private static final int MARK_FULL=5;
	
	/**
	 * 添加书签
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addBookmark", method = RequestMethod.GET)
	public String addBookmark(HttpServletRequest request,
			@RequestParam(value="contentType", required=false) String contentType,
			@RequestParam(value="contentCode", required=true) String contentCode,
			@RequestParam(value="contentName", required=true) String contentName,
			@RequestParam(value="contentElapsed", required=true) int contentElapsed,
			@RequestParam(value="bizCode", required=false) String bizCode,
			@RequestParam(value="categoryCode", required=false) String categoryCode,
			 ModelMap model) {
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		EpgUserBookmark epgUserBookmark = new EpgUserBookmark();
		epgUserBookmark.setContentType(contentType);
		epgUserBookmark.setContentCode(contentCode);
		epgUserBookmark.setContentName(contentName);
		epgUserBookmark.setContentElapsed(contentElapsed);
		if (!"null".equals(bizCode)){
			epgUserBookmark.setBizCode(bizCode);
		}
		if (!"null".equals(categoryCode)){
			epgUserBookmark.setCategoryCode(categoryCode);
		}
		
		//EpgUserSession eus = EpgUserSession.findUserSession(request);
		EpgUserSession cseus = (EpgUserSession) EpgUserSession.findUserSession(request);
		if(cseus == null){
			logger.info("-------------------"+MARK_FAILED);
			model.addAttribute("isSuccess", MARK_FAILED);
			return "/common/bookmark";
		}
		epgUserBookmark.setMacAddr(cseus.getUserData().getDeviceId());
		epgUserBookmark.setUserId(cseus.getUserData().getDeviceId());
		
		/*boolean exist = bookmarkService.existBookmark(epgUserBookmark);
		if (exist) {
			logger.info("-------------------"+MARK_EXIST);
			model.addAttribute("isSuccess", MARK_EXIST);
			return "/common/bookmark";
		}
		
		boolean limit = bookmarkService.limitBookmark(epgUserBookmark);
		if (!limit) {
			logger.info("-------------------"+MARK_FULL);
			model.addAttribute("isSuccess", MARK_FULL);
			return "/common/bookmark";
		}*/
		
		
		if (logger.isDebugEnabled()){
			logger.debug(epgUserBookmark.toString());
		}
		//logger.info("-------------------"+MARK_SUCCESS);
		model.addAttribute("isSuccess", bookmarkService.addBookmark(epgUserBookmark));
		
		return "/common/bookmark";
	}
	
	/**
	 * 删除书签
	 * 
	 * @return
	 */
	@RequestMapping(value = "/deleteBookmark", method = RequestMethod.GET)
	public String deleteBookmark(HttpServletRequest request, ModelMap model,
			@RequestParam("id") String bookmarkId,HttpServletResponse response
			) {
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		//delete by libf,2011/11/28
		/*
		String menuCategoryCode = request.getParameter("menuCategoryCode");
		
		if(StringUtils.isEmpty(menuCategoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        */
		bookmarkService.deleteBookmark(bookmarkId);
		model.addAttribute("isSuccess", MARK_SUCCESS);
		
		return "/common/bookmark";
		
		//delete by wangkai,2013/4/16
		/*bookmarkService.deleteBookmark(bookmarkId);
		
		String url = NavigatorFactory.createMyBookmarkUrl(request);
		String pageIndex=request.getParameter("pageIndex");
		
		setContext(model, request, epgContext);
        
		//delete by libf,2011/11/28
		//url = new StringBuffer(url).append("&menuCategoryCode=").append(menuCategoryCode).toString();
		
		if(pageIndex!=null){
			url= new StringBuffer(url).append("&pageIndex=").append(pageIndex).toString();
		}
		try {			
			response.sendRedirect(url);		//+"&randomNum="+RandomStringUtils.randomAlphabetic(3)					
		} catch (Exception e) {
			throw new NavigatorException("Failure to navigate to url:"
					+ url, e);
		}*/
	}
	
	/**
	 * 我的书签
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myBookmark", method = RequestMethod.GET)
	public String accessMyCollection(ModelMap model, HttpServletRequest request) {
		String menuCategoryCode = request.getParameter("menuCategoryCode");
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);

		epgContext.addContextParams("userId",EpgUserSession.findUserSession(request).getUserAccount());
		
		model.put("menuCategoryCode", menuCategoryCode);
		
		setContext(model, request, epgContext);
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/mark/myBookmark");
	}
}
