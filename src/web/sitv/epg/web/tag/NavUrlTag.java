package sitv.epg.web.tag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;

import org.apache.commons.lang.StringUtils;

import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.tag.help.BackUrlGenerator;
import sitv.epg.web.tag.help.BookmarkUrlGenerator;
import sitv.epg.web.tag.help.CollectionUrlGenerator;
import sitv.epg.web.tag.help.HistoryUrlGenerator;
import sitv.epg.web.tag.help.IndexUrlGenerator;
import sitv.epg.web.tag.help.OrderUrlGenerator;
import sitv.epg.web.tag.help.PlayUrlGenerator;

/**
 * 导航链接生成url.
 * @author zhangxs
 * 
 */
public class NavUrlTag extends SitvEpgBaseTag {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1450254416374736389L;
	private Object obj;
	private String indexUrlVar;
	private String playUrlVar; // 仅在页面明确播放的时候用
	private String orderUrlVar; //用户需订购的时候用
	private String addCollectionUrlVar; // 仅在页面明确是收藏的时候用
	private String delectCollectionUrlVar; // 仅在页面明确是删除收藏的时候用
	private String addBookmarkUrlVar; // 仅在页面明确是添加书签的时候用
	private String returnTo;
	private String returnUrlVar = "returnUrl";
	private String paramCode;
	
	public String getHistoryPlayUrlVar() {
		return historyPlayUrlVar;
	}


	public void setHistoryPlayUrlVar(String historyPlayUrlVar) {
		this.historyPlayUrlVar = historyPlayUrlVar;
	}


	public String getDelectHistoryUrlVar() {
		return delectHistoryUrlVar;
	}


	public void setDelectHistoryUrlVar(String delectHistoryUrlVar) {
		this.delectHistoryUrlVar = delectHistoryUrlVar;
	}

	private String historyPlayUrlVar; // 仅在页面明确是历史的时候用
	private String delectHistoryUrlVar; // 仅在页面明确是清空历史的时候用
	@Override
	public int doEndTag() throws JspException {
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		
		//生成返回链接
		if(!StringUtils.isBlank(this.returnTo)) {
		    String url = BackUrlGenerator.createUrl(request,returnTo);
		    pageContext.setAttribute(returnUrlVar, url);
		}
		
		if (obj == null) {
			return super.doEndTag();
		}
		
		//生成当前对象的链接
		if(!StringUtils.isBlank(this.indexUrlVar)){
		    String url = IndexUrlGenerator.createUrl(request, obj);
            pageContext.setAttribute(indexUrlVar, url);
		}
		
		//生成播放链接
		if(!StringUtils.isBlank(this.playUrlVar)){
		    String url = PlayUrlGenerator.createUrl(request, obj, paramCode);
		    pageContext.setAttribute(playUrlVar, url);
		}
		
		//生成添加收藏的链接
		if(!StringUtils.isBlank(this.addCollectionUrlVar)){
		    String url = CollectionUrlGenerator.createAddUrl(request, obj);
		    pageContext.setAttribute(addCollectionUrlVar, url);
		}
		
		//生成删除收藏的链接
		if(!StringUtils.isBlank(this.delectCollectionUrlVar)){
		    String url = CollectionUrlGenerator.createDeleteUrl(request, obj);
            pageContext.setAttribute(delectCollectionUrlVar, url);
		}
		
		//生成添加书签的链接
		if(!StringUtils.isBlank(this.addBookmarkUrlVar)){
		    String url = BookmarkUrlGenerator.createAddUrl(request, obj);
		    pageContext.setAttribute(addBookmarkUrlVar, url);
		}
		
		//生成订购链接
		if(!StringUtils.isBlank(this.orderUrlVar)){
			String url = OrderUrlGenerator.createUrl(request, obj);
			pageContext.setAttribute(orderUrlVar, url);
		}
		 // 生成历史播放链接
        if (!StringUtils.isBlank(this.historyPlayUrlVar)) {
            String url = PlayUrlGenerator.createUrl(request, obj, paramCode);
            pageContext.setAttribute(historyPlayUrlVar, url);
        }

        // 生成删除历史链接
        if (!StringUtils.isBlank(this.delectHistoryUrlVar)) {
            String url = HistoryUrlGenerator.createDeleteUrl(request, obj);
            pageContext.setAttribute(delectHistoryUrlVar, url);
        }
		return super.doEndTag();
	}
	
	
	public String getAddBookmarkUrlVar() {
		return addBookmarkUrlVar;
	}

	public void setAddBookmarkUrlVar(String addBookmarkUrlVar) {
		this.addBookmarkUrlVar = addBookmarkUrlVar;
	}

	public String getOrderUrlVar() {
		return orderUrlVar;
	}

	public void setOrderUrlVar(String orderUrlVar) {
		this.orderUrlVar = orderUrlVar;
	}

	public Object getObj() {
		return obj;
	}

	public void setObj(Object obj) {
		this.obj = obj;
	}

	public String getIndexUrlVar() {
		return indexUrlVar;
	}

	public void setIndexUrlVar(String indexUrlVar) {
		this.indexUrlVar = indexUrlVar;
	}

	public String getPlayUrlVar() {
		return playUrlVar;
	}

	public void setPlayUrlVar(String playUrlVar) {
		this.playUrlVar = playUrlVar;
	}

	public String getAddCollectionUrlVar() {
		return addCollectionUrlVar;
	}

	public void setAddCollectionUrlVar(String addCollectionUrlVar) {
		this.addCollectionUrlVar = addCollectionUrlVar;
	}

	public String getDelectCollectionUrlVar() {
		return delectCollectionUrlVar;
	}

	public void setDelectCollectionUrlVar(String delectCollectionUrlVar) {
		this.delectCollectionUrlVar = delectCollectionUrlVar;
	}

	public String getReturnTo() {
		return returnTo;
	}

	public void setReturnTo(String returnTo1) {
		this.returnTo = returnTo1;
	}

	public String getReturnUrlVar() {
		return returnUrlVar;
	}

	public void setReturnUrlVar(String returnUrlVar) {
		this.returnUrlVar = returnUrlVar;
	}

	public String getParamCode() {
		return paramCode;
	}

	public void setParamCode(String paramCode) {
		this.paramCode = paramCode;
	}
}
