package sitv.epg.web.tag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;

import chances.epg.taglib.EpgBaseTagSupport;
import chances.epg.web.ResourceContext;

/**
 * 获取资源真实访问路径的标签
 * 
 *
 */
public class ResourceTag extends SitvEpgBaseTag {
	
	/**
	 * 详情页面集数背景图资源
	 */
	private static final long serialVersionUID = 148711540368187327L;
	private String src;
	private String defaultSrc;
	private String realSrcVar;
	private int width;
	private int height;
	
	public int doEndTag() throws JspException {
		if (EpgBaseTagSupport.resourceLocator !=null){
			pageContext.setAttribute(realSrcVar, EpgBaseTagSupport.resourceLocator.getRealResourceLocation(new ResourceContext(src,defaultSrc,width,height,(HttpServletRequest) pageContext.getRequest())));
		}
		return super.doEndTag();
	}

	public String getSrc() {
		return src;
	}

	public void setSrc(String src) {
		this.src = src;
	}

	public String getRealSrcVar() {
		return realSrcVar;
	}

	public void setRealSrcVar(String realSrcVar) {
		this.realSrcVar = realSrcVar;
	}

	public String getDefaultSrc() {
		return defaultSrc;
	}

	public void setDefaultSrc(String defaultSrc) {
		this.defaultSrc = defaultSrc;
	}

}
