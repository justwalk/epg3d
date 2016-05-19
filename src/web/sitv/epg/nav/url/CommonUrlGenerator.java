package sitv.epg.nav.url;

import javax.servlet.http.HttpServletRequest;

import sitv.epg.zhangjiagang.EpgUserSession;



public class CommonUrlGenerator {
	public static final String DEFAULT_ENTRY = "sdvod";
	
	private static CommonUrlGenerator instance;
	
	protected CommonUrlGenerator() {
		
	}
	
	public static CommonUrlGenerator getInstance() {
		if(instance == null){
			instance = new CommonUrlGenerator();
		}
		
		return instance;
	}
	
	public String createCommonPage(HttpServletRequest request,String prefix){
		String entry = this.getEntry(request);
		return "/common"+prefix + "_" + entry;
	}
	
	public String createCommonPagePro(HttpServletRequest request,String prefix){
		return "/common"+prefix ;
	}
			
	public String createCommonPage(HttpServletRequest request,String prefix,String suffix){
		String entry = this.getEntry(request);
		return prefix + "_" + entry + "_" + suffix;
	}
	
	public String createCollectionPage(HttpServletRequest request){
		String entry = this.getEntry(request);
		
		return request.getContextPath()+"/index/"+entry+"collection.do";

	}
	
	public String createSearchPage(HttpServletRequest request){
		String entry = this.getEntry(request);

		return request.getContextPath()+"/index/"+entry+"search.do";
		
	}
	
	public String createBookmarkPage(HttpServletRequest request){
		String entry = this.getEntry(request);

		return request.getContextPath()+"/index/"+entry+"bookmark.do";
		
	}
	
	public String createEnterMobilePage(HttpServletRequest request){
		//String entry = this.getEntry(request);
		String bizType = request.getParameter("bizType");
		String returnUrl = request.getParameter("returnUrl");
		String macAddress = request.getParameter("macAddress");
		return new StringBuffer("/epg/common/user/mobile_")
				.append(bizType)
				.append(".jsp?")
				.append(EpgUserSession.createFixUrlParams(request))
				.append("&macAddress=")
				.append(macAddress)
				.append("&returnUrl=")
				.append(returnUrl).toString();
	}
	
	
	private String getEntry(HttpServletRequest request){
		EpgUserSession session = EpgUserSession.findUserSession(request);
		if(session != null) {
			return session.getEntry();
		}else{
			return DEFAULT_ENTRY;
		}
	}
	
	/**
	 * 生成公共历史页面入口地址
	 * @param request
	 * @return
	 */
	public String createHistoryPage(HttpServletRequest request) {
	    String entry = this.getEntry(request);
	    return request.getContextPath() + "/index/" + entry + "history.do";
	}

	/**
	 * 生成公共自助页面入口地址
	 * @param request
	 * @return
	 */
	public String createSelfPage(HttpServletRequest request) {
	    String entry = this.getEntry(request);
	    return request.getContextPath() + "/index/" + entry + "self.do";
	}
}
