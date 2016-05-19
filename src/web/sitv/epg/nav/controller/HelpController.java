package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;

@Controller
public class HelpController extends AbstractController {
	
	/**
	 * 帮助
	 * @return
	 */
	@RequestMapping(value = "/help", method = RequestMethod.GET)
	public String help(ModelMap model, HttpServletRequest request) {
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		setContext(model, request, epgContext);
	        
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/help/help");
	}
}
