package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.dao.DetailService;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.business.EpgTemplateBind;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.nav.url.CommonUrlGenerator;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import chances.epg.exception.InvalidDataException;
import chances.epg.exception.NavigatorException;
import chances.epg.exception.TemplateCannotFoundException;

/**
 * 看吧首页,栏目列表页面,内容详细页面导航
 * 
 * @author zhangxs
 * 
 */
@Controller
public class BizCatController extends AbstractController {
  
	
	@Autowired
    private DetailService detailService;
	
    /**
     * 访问看吧首页
     */
    @RequestMapping(value = "/biz/{businessCode}")
    public String accessBusiness(@PathVariable
    String businessCode, ModelMap model, HttpServletRequest request) {
        if (logger.isDebugEnabled()) {
            logger.debug("explore index page of business,business code is "
                    + businessCode);
        }

        EpgContext epgContext = EpgContextFactory.createEpgContext(request);

        // 查询看吧
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);
        if (biz == null) {
            throw new InvalidDataException(
                    "Cannot found business,businessCode:" + businessCode);
        }

        // 查询绑定关系
        EpgTemplateBind epgTemplateBind = templateBindService
                .getBusinessIndexTemplate(biz);
        if (epgTemplateBind == null) {
            throw new TemplateCannotFoundException(
                    "Can not find proper template for biz index page, biz code:"
                            + businessCode);
        }

        // 生成模板路径
        String path = this.createTemplatePath(epgContext, epgTemplateBind,request);

        setContext(model, request, epgContext);

        if (logger.isDebugEnabled()) {
            logger.debug("navigate to url:" + path);
        }

        return path;
    }

    /**
     * 访问看吧栏目首页
     * 
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}")
    public String accessBusinessCategory(@PathVariable
    String businessCode, @PathVariable
    String categoryCode, ModelMap model, HttpServletRequest request) {
        if (logger.isDebugEnabled()) {
            logger.debug("explore cateogory of business,business code: "
                    + businessCode + "; category code：" + categoryCode);
        }

        EpgContext epgContext = EpgContextFactory.createEpgContext(request);

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

        // 查询绑定关系
        EpgTemplateBind epgTemplateBind = templateBindService.getBizCatTemplate(biz,category);
        if (epgTemplateBind == null) {
            throw new TemplateCannotFoundException(
                    "Can not find proper template for category, biz code:"
                            + businessCode + ",category code:" + categoryCode);
        }

        // 生成模板路径
        String path = this.createTemplatePath(epgContext, epgTemplateBind,request);

        setContext(model, request, epgContext);
        
        if (logger.isDebugEnabled()) {
            logger.debug("navigate to url:" + path);
        }
        
        return path;
    }

    /**
     * 访问看吧频道首页 //TODO 频道需要编排
     * 
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}cha/{channelCode}")
    public String accessBusinessCategory(@PathVariable
    String businessCode, @PathVariable
    String categoryCode, @PathVariable
    String channelCode, ModelMap model, HttpServletRequest request) {
    	
    	if (logger.isDebugEnabled()) {
            logger.debug("explore channel of business,business code: "
                            + businessCode + ";category code:"+categoryCode+" channel code：" + channelCode);
        }
    	
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.CHACODE, channelCode);
        
        

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

        // 查询绑定关系
        EpgTemplateBind epgTemplateBind = templateBindService.getBizCatTemplate(biz,category);
        if (epgTemplateBind == null) {
            throw new TemplateCannotFoundException(
                    "Can not find proper template for category, biz code:"
                            + businessCode + ",category code:" + categoryCode);
        }

        // 生成模板路径
        String path = this.createTemplatePath(epgContext, epgTemplateBind,request);

        setContext(model, request, epgContext);
        
        
        if (logger.isDebugEnabled()) {
            logger.debug("navigate to url:" + path);
        }
        
        return path;
    }

    /**
     * 访问看吧栏目下的item详细页面
     * 
     * @return
     */
    @RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/det/{itemType}/{itemCode}", method = RequestMethod.GET)
    public String accessBusinessCategoryContentDetail(@PathVariable
    String businessCode, @PathVariable
    String categoryCode, @PathVariable
    String itemType, @PathVariable
    String itemCode, 
    @RequestParam(value="rb", required=false) String rb,
    @RequestParam(value="rc", required=false) String rc,
    @RequestParam(value="rp", required=false) String rp,
    @RequestParam(value="pc", required=false) String pc,
    @RequestParam(value="pi", required=false) String pi,
    ModelMap model, HttpServletRequest request, HttpServletResponse response) {

    	if (logger.isDebugEnabled()) {
            logger.debug("explore detail page: business code:" + businessCode
                    + "; category code：" + categoryCode + ";content type:"
                    + itemType + " content code:" + itemCode);
        }
    	
    	EpgContext epgContext = EpgContextFactory.createEpgContext(request);
    	
        epgContext.addContextParams(EpgContext.CONTENTTYPE, itemType);
        epgContext.addContextParams(EpgContext.CONTENTCODE, itemCode);
        
        if(StringUtils.isBlank(rp)){
        	rp = "";
        }
        epgContext.addContextParams(EpgContext.PAGECODE, rp);
        
        if(StringUtils.isBlank(pi)){
        	pi = "";
        }
        epgContext.addContextParams(EpgContext.POSTIONINDEX, pi);
        
        if(StringUtils.isBlank(pc)){
        	pc = "";
        }
        if(StringUtils.isBlank(rb)){
        	rb = "";
        }
        if(StringUtils.isBlank(rc)){
        	rc = "";
        }
        
        //如果是专题
        if (EpgCategoryItem.ITEMTYPE_SUBJECT.equals(itemType)) {
            epgContext.addContextParams(EpgContext.SUBCODE, itemCode);
            this.getEpgBusiness(epgContext, businessCode);
            this.getEpgCategory(epgContext, categoryCode);
            setContext(model, request, epgContext);
            return CommonUrlGenerator.getInstance().createCommonPage(request,
                    "/detail/subject");
        }
        
        // 查询看吧,可以没有
        EpgBusiness biz = this.getEpgBusiness(epgContext, businessCode);

        // 查询栏目,可以没有
        EpgCategory category = this.getEpgCategory(epgContext, categoryCode);
        
        String locationStr = null;
        if (category != null){
        	locationStr = category.getLocationString();
        }
        EpgTemplateBind epgTemplateBind = templateBindService.getBizCatContentDetailTemplate(
                businessCode, categoryCode, locationStr, itemType);

        setContext(model, request, epgContext);
        
        //判断栏目属性是否与节目属性匹配
        boolean isNotMixed = detailService.isNotMixed(categoryCode,itemType,itemCode); 
        
        //获取详情页的属性值
        String serviceType = detailService.getDetailServiceType(categoryCode,itemType,itemCode);
        
        //找到绑定详情页模板
        if (epgTemplateBind != null) {
           //栏目属性和节目属性匹配
        	if(isNotMixed) {
	        	String path = this.createTemplatePath(epgContext, epgTemplateBind,request);
	            
	            if (logger.isDebugEnabled()) {
	                logger.debug("navigate to url:" + path);
	            }
	            return path;
	        //栏目属性和节目属性不匹配
        	}else{
        		if (EpgCategoryItem.ITEMTYPE_VOD.equals(itemType)||EpgCategoryItem.ITEMTYPE_VOD.equals(itemType.toLowerCase())) {
        			return CommonUrlGenerator.getInstance().createCommonPage(
        					request, "/detail/"+serviceType+"_vod");
        		} else if (EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType)||EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType.toLowerCase())) {
                    //导向默认电视剧详细页面
             	   return CommonUrlGenerator.getInstance().createCommonPage(
                             request, "/detail/"+serviceType+"_series");
        		} else {
        			//其他类型不支持
        			throw new NavigatorException("Can not navigated for itemType:"
        					+ itemType);
        		}
        	}
        
        }
        
        //按次的片子一定要进详情页
        if("MOD".equals(serviceType)) {
        	return CommonUrlGenerator.getInstance().createCommonPage(
                    request, "/detail/"+serviceType+"_"+itemType.toLowerCase());
        }
        
        //找不到详细页面模板的默认页面导航处理
        if (EpgCategoryItem.ITEMTYPE_VOD.equals(itemType)||EpgCategoryItem.ITEMTYPE_VOD.equals(itemType.toLowerCase())) {
        	
            if (isDirectPlayVod()) {
                
            	//直接播放单集
            	if (logger.isDebugEnabled()) {
                    logger.debug("Can not find template bind from db, so play directly by config of 'navigator.vod.play.directly.otherwise.use.default.page' in system.properties");
                }
                String url = NavigatorFactory.createNoDetailPlayVodUrl(
                        EpgCategoryItem.ITEMTYPE_VOD, itemCode, categoryCode,
                        businessCode, request);
                String leaveFocusId = ServletRequestUtils.getStringParameter(
                        request, "leaveFocusId", null);
                String returnTo = ServletRequestUtils.getStringParameter(
                        request, "returnTo", null);
                String pageIndex = ServletRequestUtils.getStringParameter(
                        request, "pageIndex", null);
                String RB = ServletRequestUtils.getStringParameter(
                        request, "rb", null);
                String RC = ServletRequestUtils.getStringParameter(
                        request, "rc", null);
                String RP = ServletRequestUtils.getStringParameter(
                        request, "rp", null);
                String PC = ServletRequestUtils.getStringParameter(
                        request, "pc", null);
                String PI = ServletRequestUtils.getStringParameter(
                        request, "pi", null);
                if(leaveFocusId != null) {
                	url = new StringBuffer().append(url).append("&leaveFocusId=").append(leaveFocusId).toString();
                }
                if(returnTo != null){
                	url = new StringBuffer().append(url).append("&returnTo=").append(returnTo).toString();
                }
                if(pageIndex != null){
                	url = new StringBuffer().append(url).append("&pageIndex=").append(pageIndex).toString();
                }
                if(RB != null) {
                	url = new StringBuffer().append(url).append("&rb=").append(RB).toString();
                }
                if(RC != null) {
                	url = new StringBuffer().append(url).append("&rc=").append(RC).toString();
                }
                if(RP != null){
                	url = new StringBuffer().append(url).append("&rp=").append(RP).toString();
                }
                if(PC != null){
                	url = new StringBuffer().append(url).append("&pc=").append(PC).toString();
                }
                if(PI != null){
                	url = new StringBuffer().append(url).append("&pi=").append(PI).toString();
                }
                try {
                     response.sendRedirect(url);
                } catch (Exception e) {
                    throw new NavigatorException("Failure to navigate to url:"
                            + url, e);
                }
                
            } else {
            	
            	//导向单集默认详细页面
                  if (logger.isDebugEnabled()) { 
                	  logger.debug("Can not find template bind from db, open default vod play /detail/vod");
                  }
                return CommonUrlGenerator.getInstance().createCommonPage(
                        request, "/detail/"+serviceType+"_vod");
            }
        } else if (EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType)||EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType.toLowerCase())) {
        	
        	   return CommonUrlGenerator.getInstance().createCommonPage(
                        request, "/detail/"+serviceType+"_series");
        	
        } else {
        	
            //其他类型不支持
        	throw new NavigatorException("Can not navigated for itemType:"
                    + itemType);
        }
        return null;
    }

	

    /**
     * 没有绑定模板时是否直接播放.
     * 
     * @return
     */
    private boolean isDirectPlayVod() {
    	return EpgConfigUtils.getInstance().getBooleanValue(EpgConfigUtils.DIRECT_PLAYVOD);
    }
    
    
    /**
	 * 访问看吧频道首页
	 * //TODO 频道需要编排
	 * @return
	 */
	@RequestMapping(value = "/biz/{businessCode}/cat/{categoryCode}/cha/{channelCode}")
	public String accessBusinessChannel(@PathVariable String businessCode,
			@PathVariable String categoryCode,
			@PathVariable String channelCode, ModelMap model,
			HttpServletRequest request) {
		
		if (logger.isDebugEnabled()) {
			logger.debug(
					"explore channel of business,business code: "
							+ businessCode + "; channel code：" + channelCode+" categoryCode:"+categoryCode);
		}
		
		EpgContext epgContext = EpgContextFactory.createEpgContext( request);
		epgContext.addContextParams(EpgContext.CHACODE, channelCode);
		
		
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

        // 查询绑定关系
        EpgTemplateBind epgTemplateBind = templateBindService.getBizCatTemplate(biz,category);
        if (epgTemplateBind == null) {
            throw new TemplateCannotFoundException(
                    "Can not find proper template for category, biz code:"
                            + businessCode + ",category code:" + categoryCode);
        }

        // 生成模板路径
        String path = this.createTemplatePath(epgContext, epgTemplateBind,request);

        setContext(model, request, epgContext);
        
        
        if (logger.isDebugEnabled()) {
            logger.debug("navigate to url:" + path);
        }
        
		return path;
	}

}
