package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.web.context.EpgContextFactory;

/**
 * OCN VOD视频点播跳转进入的入口页面
 * 
 * @author zhangxs
 * 
 */
@Controller
public class EntryController extends AbstractController {
	
	private static final Log logger = EpgLogFactory.getSystemLogger();
	
	

	/**
	 * /index/sdvod.do 标清点播入口
	 * /index/sd1vod.do 标清简版点播入口
	 * /index/hdvod.do 高清点播入口
	 * /index/hd1vod.do 高清简版点播入口
	 * /index/sdlookback.do标清回看入口
	 * /index/hdlookback.do 高清回看入口
	 * /index/sdshop.do 标清商城入口
	 * /index/hdshop.do 高清商城入口
	 * //TODO 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/index/*")
	public String accessIndexPage(HttpServletRequest request, ModelMap model,HttpServletResponse response) {
		EpgContextFactory.createEpgContext(request);
		String uri = request.getServletPath();
		return "/common"+uri.substring(0, uri.indexOf("."));
	}
	
	
	

	@RequestMapping(value = "/*/*")
	public String accessHomePage(HttpServletRequest request, ModelMap model,HttpServletResponse response) {
		String uri = request.getServletPath();
		uri = "/common"+uri.substring(0, uri.indexOf("."));
		if (logger.isDebugEnabled()){
			logger.debug("access jsp:"+uri+".jsp");
		}
		return uri ;
	}	
	
	@RequestMapping(value = "/*")
	public String accessRootPage(HttpServletRequest request, ModelMap model,HttpServletResponse response) {
		String uri = request.getServletPath();
		uri = "/common"+uri.substring(0, uri.indexOf("."));
		if (logger.isDebugEnabled()){
			logger.debug("access jsp:"+uri+".jsp");
		}
		return uri ;
	}	

	

}
