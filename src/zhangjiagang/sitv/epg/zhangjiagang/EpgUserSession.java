package sitv.epg.zhangjiagang;

import javax.servlet.http.HttpServletRequest;

import chances.epg.web.UserSession;
import sitv.epg.zhangjiagang.bo.UserData;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.user.EpgSubscriber;

/**
 * Class comments.
 *
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
public class EpgUserSession extends UserSession {
    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -7821562634520660852L;
    
    private String userAccount;
    
    private String smcId;
    
    private String entry;
    
    private String vmType;
    
    private EpgSubscriber epgSubscriber;
    
    private String pageIndex;
    
    private String leaveFocusId;
    
    private String historyBackMark;
    
    private UserData userData;
    /**
     * @return the userData
     */
    public UserData getUserData() {
        return userData;
    }
    /**
     * @param userData the userData to set
     */
    public void setUserData(UserData userData) {
        this.userData = userData;
    }
    
    public  static EpgUserSession findUserSession(HttpServletRequest httpRequest){
		return getUserSession(httpRequest);
	}
    
    public String getUserAccount() {
		return userData.getAccount();
	}

	public String getEntry() {
		return entry;
	}
	public void setEntry(String entry) {
		this.entry = entry;
	}
	public String getVmType() {
		return vmType;
	}
	public void setVmType(String vmType) {
		this.vmType = vmType;
	}
	public EpgSubscriber getEpgSubscriber() {
		return epgSubscriber;
	}
	public void setEpgSubscriber(EpgSubscriber epgSubscriber) {
		this.epgSubscriber = epgSubscriber;
	}
	public String getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(String pageIndex) {
		this.pageIndex = pageIndex;
	}
	public String getLeaveFocusId() {
		return leaveFocusId;
	}
	public void setLeaveFocusId(String leaveFocusId) {
		this.leaveFocusId = leaveFocusId;
	}
	public String getHistoryBackMark() {
		return historyBackMark;
	}
	public void setHistoryBackMark(String historyBackMark) {
		this.historyBackMark = historyBackMark;
	}
	/**
	 * 获取用户会话信息.
	 * @param httpRequest
	 * @return
	 */
	public static EpgUserSession getUserSession(HttpServletRequest httpRequest) {
	    return (EpgUserSession) httpRequest.getSession().getAttribute(UserSession.USER_SESSION_NAME);
	}
	
	public static String createFixUrlParams(HttpServletRequest httpRequest){
		EpgUserSession eus = findUserSession(httpRequest);
		if (!isAddFixParams()){
			return "vmType="+eus.getVmType();
		}
		StringBuffer sb = new StringBuffer();
		sb.append("vmType=").append(eus.getVmType()).append("&");
		sb.append("entry=").append(eus.getEntry());
		return sb.toString();
	}
	
	private static boolean isAddFixParams() {
		return EpgConfigUtils.getInstance().getBooleanValue(EpgConfigUtils.ADD_FIX_PARAMS);
	}
	public String getSmcId() {
		return smcId;
	}
	public void setSmcId(String smcId) {
		this.smcId = smcId;
	}
}
