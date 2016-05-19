package sitv.epg.zhangjiagang.bo;

import java.io.Serializable;

/**
 * Class comments.
 *
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
public class UserData implements Serializable {
    /**
	 * 用户信息
	 */
	private static final long serialVersionUID = 1L;
	
	private String portalId;//portal客户端ID
	
	private String deviceId;//终端设备机身序列号
	
    private String client;//智能卡号
    
    private String account;//设备账户(UserID,由BOSS/SMS同步的用户的账号信息)
    
    private String qamMode;//调制模式
    
    private String symbolRate;//符号率
    
    private String frequence;//频点频率（Hz）
    
	public String getPortalId() {
		return portalId;
	}
	public void setPortalId(String portalId) {
		this.portalId = portalId;
	}
	public String getDeviceId() {
		return deviceId;
	}
	public void setDeviceId(String deviceId) {
		this.deviceId = deviceId;
	}
	public String getClient() {
		return client;
	}
	public void setClient(String client) {
		this.client = client;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getQamMode() {
		return qamMode;
	}
	public void setQamMode(String qamMode) {
		this.qamMode = qamMode;
	}
	public String getSymbolRate() {
		return symbolRate;
	}
	public void setSymbolRate(String symbolRate) {
		this.symbolRate = symbolRate;
	}
	public String getFrequence() {
		return frequence;
	}
	public void setFrequence(String frequence) {
		this.frequence = frequence;
	}
}
