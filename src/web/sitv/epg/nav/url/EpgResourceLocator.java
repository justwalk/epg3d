package sitv.epg.nav.url;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import sitv.epg.web.context.EpgContext;
import chances.epg.exception.PathHandlerException;
import chances.epg.utils.PathWraper;
import chances.epg.web.ResourceContext;
import chances.epg.web.ResourceLocator;

/**
 * 图片路径拼接工具
 * 
 * @author zhangxs
 *
 */
public class EpgResourceLocator implements ResourceLocator {

	/*
	 * (non-Javadoc)
	 * @see chances.epg.web.ResourceLocator#getRealResourceLocation(chances.epg.web.ResourceContext)
	 */
	public String getRealResourceLocation(ResourceContext resourceContext) {
		String templateRoot = TemplateHelper.getTemplateRoot();
		String resourceRoot = ResourceHelper.getResourceRoot();		
		int width = resourceContext.getWidth();
		int height = resourceContext.getHeight();
		String src = resourceContext.getSrc();
		String defaultSrc = resourceContext.getDefaultSrc();
		HttpServletRequest request = resourceContext.getRequest();
		if (templateRoot == null)
			throw new PathHandlerException("templateRoot has not been set");
		if (templateRoot == null)
			throw new PathHandlerException(
					"template root path has not been set");
		
		//没有设src
		if (StringUtils.isBlank(src)){ 
			//默认图也没有设,返回null
			if (StringUtils.isBlank(defaultSrc)) return null;
			
			//默认图也没有设,但为资源图,所以取默认图片l,(基本不存在该种可能)
			if ("../".equals(defaultSrc) || "../null".equals(defaultSrc)){
				return this.getDefaultPic(width, height, request.getContextPath());
			}
			//默认图也没有设,返回null,//默认图没有设对,此种情况为程序开发错误,不应该
			if ("./".equals(defaultSrc) || "/".equals(defaultSrc)){
				return null;
			}
			//默认图设置且有值,取默认图设置
			return getRealResourceLocation(defaultSrc,width,height,request,templateRoot,resourceRoot);
		}else if ("../".equals(src) || "../null".equals(src)){  // 资源图,但数据无值
			
			//默认图没有,返回默认图片
			if (StringUtils.isBlank(defaultSrc)){
				return this.getDefaultPic(width, height, request.getContextPath());
			}
			//默认图也为资源图(基本不存在该种可能),返回默认图片
			if ("../".equals(defaultSrc) || "../null".equals(defaultSrc)){
				return this.getDefaultPic(width, height, request.getContextPath());
			}
			//默认图没有设对,此种情况为程序开发错误,不应该
			if ("./".equals(defaultSrc) || "/".equals(defaultSrc)){
				return this.getDefaultPic(width, height, request.getContextPath());
			}
			//默认图设置且有值,取默认图设置
			return getRealResourceLocation(defaultSrc,width,height,request,templateRoot,resourceRoot);
			
		}else if ("./".equals(src) || "/".equals(src)){ //此种情况为页面开发错误,不太可能
			if (StringUtils.isBlank(defaultSrc)){
				return null;
			}
			if ("../".equals(defaultSrc) || "../null".equals(defaultSrc)){
				return this.getDefaultPic(width, height, request.getContextPath());
			}
			if ("./".equals(defaultSrc) || "/".equals(defaultSrc)){
				return null;
			}
			return getRealResourceLocation(defaultSrc,width,height,request,templateRoot,resourceRoot);
		}else{
			//取实际的图片
			return getRealResourceLocation(src,width,height,request,templateRoot,resourceRoot);
		}
	}
	

	/**
	 * 取实际图片
	 * @param src 图片源,这时src 肯定有具体值,不再是 ./ ../  / or null 
	 * @param width
	 * @param height
	 * @param request
	 * @param templateRoot
	 * @param resourceRoot
	 * @return
	 */
	private String getRealResourceLocation(String src,int width,int height,HttpServletRequest request,
			String templateRoot,String resourceRoot ) {
		
		if (src.startsWith("/")) { // 取上下文资源
			return  getContextResource(src, request);
			
		} else if (src.startsWith("./")) { // 取模板内资源
			return getTemplateResource(src, request, templateRoot);
			
		} else if (src.startsWith("../")) { // 取内容资源

			String realSrc = src.substring(3); 			
			return getContentResource(request, resourceRoot, realSrc);
			
		}
		return null;
	}

	/**
	 * 取内容和编排资源图
	 * @param request
	 * @param resourceRoot
	 * @param realSrc
	 * @return
	 */
	private String getContentResource(HttpServletRequest request,
			String resourceRoot, String realSrc) {
		
		if (realSrc.startsWith("http://")) return realSrc;
			
		if (resourceRoot.toLowerCase().startsWith("http://")) { 
			if (realSrc.startsWith("/")){
				if (resourceRoot.endsWith("/")){
					return resourceRoot+realSrc.substring(1);
				}else{
					return resourceRoot + realSrc;
				}
			}else{
				if (resourceRoot.endsWith("/")){
					return resourceRoot+realSrc;
				}else{
					return resourceRoot + "/" + realSrc;
				}
			}
			
		}else{
			return  PathWraper.wrape(new String[] { request.getContextPath(),
					resourceRoot, realSrc }, true);
		}
	}

	/**
	 * 取模板包内图片
	 * @param src
	 * @param request
	 * @param templateRoot
	 * @return
	 */
	private String getTemplateResource(String src, HttpServletRequest request,
			String templateRoot) {
		String path;
		EpgContext epgContext = (EpgContext) request.getAttribute(EpgContext.CONTEXT_OBJ);
		String templatePackageCode = "";
		if (epgContext!=null){
			templatePackageCode = epgContext.getCurrentTemplatePackageCode();
		}
		path = PathWraper.wrape(new String[] { request.getContextPath(), templateRoot,
				templatePackageCode, src.substring(2) }, true);
		return path;
	}

	/**
	 * 取上下文图片
	 * @param src
	 * @param request
	 * @return
	 */
	private String getContextResource(String src, HttpServletRequest request) {
		String path;
		path = PathWraper.wrape(new String[] { request.getContextPath(), src }, true);
		return path;
	}

	/**
	 * 取默认图片,默认图片放在 /common/images/default 目录下,width-height.jpg
	 * @param width
	 * @param height
	 * @param contextPath
	 * @return
	 */
	private String getDefaultPic(int width, int height,String contextPath) {
		if (width==0) return null;
		String realSrc = new StringBuffer().append("common/images/default/").append(width)
		.append("-").append(height).append(".jpg").toString();
		String path = PathWraper.wrape(new String[] { contextPath,
				realSrc}, true);
		return path;
	}
	
	
	
	//TODO 资源testcase
}
