package sitv.epg.web.tag;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.jasper.runtime.JspRuntimeLibrary;

import chances.epg.exception.HtmlMeargeException;
/**
 * 推荐位标签
 * @author zhangxs
 *
 */
public  class PositionTag extends BodyTagSupport {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String url="position.do";
	private String code;
	public int left = 0;
	public int top = 0;
	public int width = 0;
	public int height = 0;	
	
	@Override
	public int doEndTag() throws JspException {
		ServletRequest request = pageContext.getRequest();
		request.setAttribute("code", code);
		request.setAttribute("left", left);
		request.setAttribute("top", top);
		request.setAttribute("width", width);
		request.setAttribute("height", height);
		try {
			JspRuntimeLibrary.include(pageContext.getRequest(), pageContext.getResponse(), url, pageContext.getOut(), false);
		} catch (IOException e) {
			throw new HtmlMeargeException(" IO error when include url:"+url,e);
		} catch (ServletException e) {
			throw new HtmlMeargeException(" Servlet error when include url:"+url,e);
		}
		return super.doEndTag();
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public int getLeft() {
		return left;
	}
	public void setLeft(int left) {
		this.left = left;
	}
	public int getTop() {
		return top;
	}
	public void setTop(int top) {
		this.top = top;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	
	

}
