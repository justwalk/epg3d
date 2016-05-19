package sitv.epg.web.context;

import java.util.HashMap;
import java.util.Map;

import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.edit.EpgCategory;
public class EpgContext {
	private Map<String,Object> templateParams = new HashMap<String,Object>();
	private Map<String,Object> contextParams = new HashMap<String,Object>();

	public static final String CONTEXT_ATTR_NAME = "context";
	public static final String TEMPLATE_PARAMS_ATTR_NAME = "templateParams";
	
	public static final String EPG_CONTEXT = "EPG_CONTEXT";
	public static final String CONTEXT_OBJ = "CONTEXT_OBJ";
	
	public static final String BIZCODE = "EPG_BUSINESS_CODE";
	public static final String BIZ = "EPG_BUSINESS";
	public static final String CATCODE = "EPG_CATEGORY_CODE";
	public static final String CHACODE = "EPG_CHANNEL_CODE";
	//public static final String CHA = "EPG_CHANNEL";
	
	public static final String SUBCODE = "EPG_SUBJECT_CODE";
	public static final String PAGECODE = "EPG_PAGE_CODE";
	public static final String POSTIONCODE = "EPG_POS_CODE";
	public static final String POSTIONINDEX = "EPG_PC_PI";
	//public static final String CHANCODE = "EPG_CHANNEL_CODE";
	
	//public static final String OPERESULT = "EPG_OPERATE_RESULT_CODE";
	
	public static final String CAT = "EPG_CATEGORY";
	public static final String FIXPARAMS = "EPG_FIXPARAMS";
	
	public static final String USER = "EPG_USER";
	
	public static final String CONTENTTYPE = "EPG_CONTENT_TYPE";
	public static final String CONTENTCODE = "EPG_CONTENT_CODE";
	
	public static final String OFFERINGID = "EPG_OFFERING_ID";
	
	public static final String HELPURL = "EPG_HELP_URL";
	public static final String MYCOLLECTIONURL = "EPG_MYCOLLECTION_URL";
	public static final String SEARCHURL = "EPG_SEARCH_URL";
	public static final String RESULTURL = "EPG_RESULT_URL";
	public static final String MYBOOKMARKURL = "EPG_MYBOOKMARK_URL";
	/*public static final String RETURNHOME = "EPG_RETURNHOME_URL";
	public static final String RETURNBIZ = "EPG_RETURNBIZ_URL";
	public static final String RETURNBIZCAT = "EPG_RETURNBIZCAT_URL";
	
	public static final String TEMPLATE_TYPE = "TEMPLATE_TYPE";*/
	public static final String HISTORY = "EPG_HISTORY_URL";
	public static final String SELF = "EPG_SELF_URL";
	
	private EpgBusiness epgBusiness;
	private EpgCategory category;
	private String currentTemplatePackageCode;
	
	public void addContextParams(String key,Object value){
		if (key == null) return ;
		contextParams.put(key, value);
	}
	
	public void addTemplateParams(String paramName,String paramValue){
		if (paramName == null) return ;
		templateParams.put(paramName, paramValue);
	}
	
	public Object getTempParam(String templateName){
		return templateParams.get(templateName);
	}
	
	public Object getValue(String contextName){
		return contextParams.get(contextName);
	}
	
	public Object getParam(String templateParamName){
		return templateParams.get(templateParamName);
	}

	
	public Map<String, Object> getTemplateParams() {
		return templateParams;
	}

	public void setTemplateParams(Map<String, Object> templateParams) {
		this.templateParams = templateParams;
	}

	public Map<String, Object> getContextParams() {
		return contextParams;
	}

	public void setContextParams(Map<String, Object> contextParams) {
		this.contextParams = contextParams;
	}

	public EpgBusiness getEpgBusiness() {
		return epgBusiness;
	}

	/**
	 * 设置看吧.
	 * @param epgBusiness
	 */
	public void setEpgBusiness(EpgBusiness epgBusiness) {
	    if(epgBusiness != null) {
	        this.epgBusiness = epgBusiness;
	        this.addContextParams(BIZ, epgBusiness);
	        this.addContextParams(BIZCODE, epgBusiness.getCode());    
	    }
	}

	public EpgCategory getCategory() {
		return category;
	}

	/**
	 * 设置栏目.
	 * @param category
	 */
	public void setCategory(EpgCategory category) {
	    if(category != null) {
	        this.category = category;
	        this.addContextParams(CATCODE, category.getCode());
	        this.addContextParams(CAT, category);
	    }
	}

	public String getCurrentTemplatePackageCode() {
		return currentTemplatePackageCode;
	}

	public void setCurrentTemplatePackageCode(String currentTemplatePackageCode) {
		this.currentTemplatePackageCode = currentTemplatePackageCode;
	}

	

	
	
}
