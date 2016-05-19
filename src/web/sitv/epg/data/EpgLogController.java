package sitv.epg.data;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.nav.controller.AbstractController;

/**
 * @author Administrator
 *
 */
@Controller
public class EpgLogController extends AbstractController {
	
	/**
	 * 记录播放日志，包括播放时出错日志和播放退出时日志
	 * @param request
	 */
	@RequestMapping(value = "/playErrorLog", method = RequestMethod.GET)
	public void getPlayErrorLog(HttpServletRequest request) {
		String log = request.getParameter("log");
		if(StringUtils.isEmpty(log)){
            throw new InvalidaQueryParameterException("Parameter(playLog) code must not been null.");
        }
		if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
			EpgLogFactory.getErrorLogger().info(log);
		}
	}
	
	@RequestMapping(value = "/playExitLog", method = RequestMethod.GET)
	public void getPlayExitLog(HttpServletRequest request) {
		String log = request.getParameter("log");
		if(StringUtils.isEmpty(log)){
            throw new InvalidaQueryParameterException("Parameter(playLog) code must not been null.");
        }
		if (EpgLogFactory.getPlayLogger().isInfoEnabled()) {
			EpgLogFactory.getPlayLogger().info(log);
		}
	}
	
}
