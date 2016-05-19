package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import chances.epg.exception.InvalidDataException;

/**
 * 专题页面导航控制器
 * 
 * @author zhangxs
 * 
 */
@Controller
public class SubjectController extends AbstractController{
	
	private static Log logger = EpgLogFactory.getSystemLogger();
	/**
	 * 访问看吧栏目下专题首页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/sub/{subjectCode}", method = RequestMethod.GET)
	public String accessBusinessCategorySubject(
			@PathVariable String businessCode,
			@PathVariable String categoryCode,
			@PathVariable String subjectCode, ModelMap model,
			HttpServletRequest request) {
		
		if (logger.isDebugEnabled()){
			logger.debug("explore subject index page;subject code :"+subjectCode+" ;navigate to url:/detail/subject");
		}
		
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		epgContext.addContextParams(EpgContext.SUBCODE, subjectCode);
		
		 // 查询看吧
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);
        if (biz == null) {
            throw new InvalidDataException(
                    "Cannot found business,businessCode:" + businessCode);
        }

        // 查询栏目
        EpgCategory category = this.getEpgCategory(epgContext, categoryCode);
        if (category == null) {
            throw new InvalidDataException(
                    "Cannot found category,categoryCode:" + categoryCode);
        }
        
        setContext(model, request, epgContext);
        
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/detail/subject");
	}

	/**
	 * 访问看吧栏目下专题内某个页面
	 * //TODO专题多页面测试
	 * @return
	 */
	@RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/page/{pageCode}", method = RequestMethod.GET)
	public String accessBusinessCategorySubjectPage(
			@PathVariable String businessCode,
			@PathVariable String categoryCode,
			@PathVariable String pageCode,
			ModelMap model, HttpServletRequest request) {
		
		if (logger.isDebugEnabled()){
			logger.debug("explore subject page page;subject page code :"+pageCode+" ;navigate to url:/detail/subject");
		}
		EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		epgContext.addContextParams(EpgContext.PAGECODE, pageCode);
		
		 // 查询看吧
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);
        if (biz == null) {
            throw new InvalidDataException(
                    "Cannot found business,businessCode:" + businessCode);
        }

        // 查询栏目
        EpgCategory category = this.getEpgCategory(epgContext, categoryCode);
        if (category == null) {
            throw new InvalidDataException(
                    "Cannot found category,categoryCode:" + categoryCode);
        }
		
        setContext(model, request, epgContext);
        
		return CommonUrlGenerator.getInstance().createCommonPage(request, "/detail/subject");
	}
		
}
