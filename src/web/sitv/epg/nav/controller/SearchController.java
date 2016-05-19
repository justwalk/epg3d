package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;

/**
 * 交互相关的导航控制器
 * 
 * @author zhangxs
 * 
 */
@Controller
public class SearchController extends AbstractController {
	
	/**
	 * 搜索
	 * 
	 * @return
	 */
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String search(ModelMap model, HttpServletRequest request) {
		//String initals = request.getParameter("initals");
		String menuCategoryCode = request.getParameter("menuCategoryCode");
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		/*String keywords = "";
		
		if (initals != null) {
			keywords = keywords + initals;
		}
		*/
		model.put("menuCategoryCode", menuCategoryCode);
		
		setContext(model, request, epgContext);
		 
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/search/search");
	}
	/**
	 * 搜索结果
	 * 
	 * @return
	 */
	@RequestMapping(value = "/result", method = RequestMethod.GET)
	public String result(ModelMap model, HttpServletRequest request) {
		String initals = request.getParameter("initals");
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		String keywords = "";

		if (initals != null) {
			keywords = keywords + initals;
		}
		
		model.put("initals", keywords);
		
		setContext(model, request, epgContext);
		 
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/search/result");
	}
}
