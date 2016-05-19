package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class LoginResponse implements Serializable {

    private static final long serialVersionUID = 1L;

	private String account;//设备账户(UserID,由BOSS/SMS同步的用户的账号信息)

    private String customerGroup;//终端所处的用户组
    
    private ZoneFreqInfo zoneFreqInfo;//区域频点列表（ODC根据区域频点锁频获取TSID作为区域码，S1规范中的QAM name可使用此TSID）

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getCustomerGroup() {
		return customerGroup;
	}

	public void setCustomerGroup(String customerGroup) {
		this.customerGroup = customerGroup;
	}

	public ZoneFreqInfo getZoneFreqInfo() {
		return zoneFreqInfo;
	}

	public void setZoneFreqInfo(ZoneFreqInfo zoneFreqInfo) {
		this.zoneFreqInfo = zoneFreqInfo;
	}
    
}
