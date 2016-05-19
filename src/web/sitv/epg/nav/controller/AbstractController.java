/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.dao.BusinessService;
import sitv.epg.business.dao.CategoryService;
import sitv.epg.business.dao.TemplateBindService;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.business.EpgTemplateBind;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.nav.url.TemplateHelper;
import sitv.epg.web.context.EpgContext;
import sitv.epg.zhangjiagang.EpgUserSession;

/**
 * 导航基类.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */

public abstract class AbstractController {
    protected static Log logger = EpgLogFactory.getSystemLogger();
    
    
    public static final String FIRST_ORDER_PURCHSE_TYPE  = "1";
    public static final String HAS_ORDER_PURCHSE_TYPE  = "3";
   

    @Autowired
    protected TemplateBindService templateBindService;
    
    @Autowired
    protected BusinessService businessService;
    
    @Autowired
    protected CategoryService categoryService;

   
    /**
     * 查询看吧.
     * @param epgContext
     * @param businessCode
     * @return
     */
    protected EpgBusiness getEpgBusiness(EpgContext epgContext,String businessCode) {
        if (StringUtils.isBlank(businessCode)) {
            return null;
        }
        if (NavigatorFactory.GANG.equals(businessCode)) {
            return null;
        }

        EpgBusiness epgBusiness = businessService.getBusinessByCode(businessCode);
        
        if(epgBusiness != null) {
            epgContext.setEpgBusiness(epgBusiness);
        }
        return epgBusiness;
    }
    
    /**
     * 查询栏目.
     * @param epgContext
     * @param businessCode
     * @return
     */
    protected EpgCategory getEpgCategory(EpgContext epgContext,String categoryCode) {
        if (StringUtils.isBlank(categoryCode)) {
            return null;
        }

        if ( NavigatorFactory.GANG.equals(categoryCode)) {
            return null;
        }
             
        EpgCategory epgCategory = categoryService.getCategoryByCode(categoryCode);
        
        if(epgCategory != null) {
            epgContext.setCategory(epgCategory);
        }
        
        return epgCategory;
    }
    
    /**
     * 生成模板路径.
     * @param context
     * @param bind
     * @return
     */
    protected String createTemplatePath(EpgContext context,EpgTemplateBind bind,HttpServletRequest request){
        StringBuffer buff = new StringBuffer("/");
        buff.append(TemplateHelper.getTemplateRoot()).append("/");
        buff.append(bind.getTemplatePackageCode()).append("/");
        
        context.setCurrentTemplatePackageCode(bind.getTemplatePackageCode());
        
        String templatePath = bind.getTemplatePath();
        int index = templatePath.lastIndexOf(".");
        if(index != -1) {
            buff.append(templatePath.substring(0, index));
        }else{
            buff.append(templatePath);
        }
        
        String fixparams = EpgUserSession.createFixUrlParams(request);
        String url = new StringBuffer().append("?").append(fixparams).toString();
        
        //设置模板参数到上下文中
        if (bind.getTemplateParams() != null) {
            String[] templateParams = StringUtils.split(bind.getTemplateParams(), "|");
            String[] params = null;
            String v = null;
            for (int i = 0; templateParams != null && i < templateParams.length; i++) {
                params = templateParams[i].split("=");
                if (params.length==3){
                	if(params[1].equals("url")){
                		params[2] = new StringBuffer().append(params[2]).append(url).toString();
                		context.addTemplateParams(params[0], params[2]);
                    	v = params[2];
                	}else{
                		context.addTemplateParams(params[0], params[2]);
                    	v = params[2];
                	}
                }else{
                	context.addTemplateParams(params[0], "");
                	v = "";
                }
                if (logger.isDebugEnabled()){
                    logger.debug("template parameters:" + params[0] + " type:"+ params[1] + " value:" + v);
                }
            }
        }
        
        return buff.toString();
    }
    
    
    protected void setContext(ModelMap model, HttpServletRequest request,
			EpgContext epgContext) {
		model.put(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        model.put(EpgContext.TEMPLATE_PARAMS_ATTR_NAME, epgContext.getTemplateParams());
        model.put(EpgContext.USER, EpgUserSession.getUserSession(request));
        model.put(EpgContext.CONTEXT_OBJ, epgContext);
	}
    
    protected void playFocusHandle(HttpServletRequest request) {
        boolean rememberPlayFocus = true;
        //全景5505EU-PK不计播放焦点,因为有cache
        
        EpgUserSession eus = EpgUserSession.findUserSession(request);
        
        if (isRememberPlayFocus()) {
            rememberPlayFocus = true;
        } else {
            rememberPlayFocus = false;
        }
        if (rememberPlayFocus ) {
            String leaveFocusId = request.getParameter("leaveFocusId");
            eus.setPlayFocusId(leaveFocusId);
        }
    }
    
    /**
     * 没有绑定模板时是否直接播放.
     * 
     * @return
     */
    protected boolean isRememberPlayFocus() {
        return EpgConfigUtils.getInstance().getBooleanValue(EpgConfigUtils.REMEMBER_PLAYFOCUS_USESESSION);
    }
    
  
   public static void main(String[] args){
	   String str = "bgImg=image=";
	   String[] ss = str.split("=");
	   System.out.println(ss.length);
   }

}
