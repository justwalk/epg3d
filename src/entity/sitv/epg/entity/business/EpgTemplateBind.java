package sitv.epg.entity.business;
/**
 * 模板绑定
 * @author zhangxs
 *
 */
public class EpgTemplateBind implements java.io.Serializable {
	
	public static final String TEMPLATE_TYPE_INDEX = "index";
	public static final String TEMPLATE_TYPE_LIST = "list";
	public static final String TEMPLATE_TYPE_DETAIL = "detail";
	
	
	private Long id;
	private String bizCode;
	private String categoryCode;
	private String locationStr;
	private String contentType;
	private String templateType;
	private String templateCode;
	private String templatePackageCode;
	private String templatePath;
	private String templateParams;
	//private boolean enableStatus;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getBizCode() {
		return bizCode;
	}
	public void setBizCode(String bizCode) {
		this.bizCode = bizCode;
	}
	public String getCategoryCode() {
		return categoryCode;
	}
	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}
	public String getLocationStr() {
		return locationStr;
	}
	public void setLocationStr(String locationStr) {
		this.locationStr = locationStr;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public String getTemplateType() {
		return templateType;
	}
	public void setTemplateType(String templateType) {
		this.templateType = templateType;
	}
	public String getTemplateCode() {
		return templateCode;
	}
	public void setTemplateCode(String templateCode) {
		this.templateCode = templateCode;
	}
	public String getTemplatePackageCode() {
		return templatePackageCode;
	}
	public void setTemplatePackageCode(String templatePackageCode) {
		this.templatePackageCode = templatePackageCode;
	}
	public String getTemplatePath() {
		return templatePath;
	}
	public void setTemplatePath(String templatePath) {
		this.templatePath = templatePath;
	}
	public String getTemplateParams() {
		return templateParams;
	}
	public void setTemplateParams(String templateParams) {
		this.templateParams = templateParams;
	}
}
