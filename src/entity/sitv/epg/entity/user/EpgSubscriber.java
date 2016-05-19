package sitv.epg.entity.user;

import java.io.Serializable;
/**
 * epg 订户
 * @author zhangxs
 *
 */
public class EpgSubscriber implements Serializable {
	
	private Long id;
	private String userAccount;
	private String macAddress;
	private String ossUserId;
	private String userName;
	private String address;
	private String zipCode;
	private  String phoneNumber;
	private String email;
	//added by jason 4/6/2011
	private String group;	
	private String exploreName;
	private String exploreVersion;
	private String networkId;
	private String stbModel;
	private String stbType;
	private String rtspd;
	private String protocolType;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getUserAccount() {
		return userAccount;
	}
	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}
	public String getMacAddress() {
		return macAddress;
	}
	public void setMacAddress(String macAddress) {
		this.macAddress = macAddress;
	}
	public String getOssUserId() {
		return ossUserId;
	}
	public void setOssUserId(String ossUserId) {
		this.ossUserId = ossUserId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getZipCode() {
		return zipCode;
	}
	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getGroup() {
		return group;
	}
	public void setGroup(String group) {
		this.group = group;
	}
	
	public String getExploreName() {
		return exploreName;
	}
	public void setExploreName(String exploreName) {
		this.exploreName = exploreName;
	}
	public String getExploreVersion() {
		return exploreVersion;
	}
	public void setExploreVersion(String exploreVersion) {
		this.exploreVersion = exploreVersion;
	}
	public String getNetworkId() {
		return networkId;
	}
	public void setNetworkId(String networkId) {
		this.networkId = networkId;
	}
	public String getStbModel() {
		return stbModel;
	}
	public void setStbModel(String stbModel) {
		this.stbModel = stbModel;
	}
	public String getStbType() {
		return stbType;
	}
	public void setStbType(String stbType) {
		this.stbType = stbType;
	}
	public String getRtspd() {
		return rtspd;
	}
	public void setRtspd(String rtspd) {
		this.rtspd = rtspd;
	}
	public String getProtocolType() {
		return protocolType;
	}
	public void setProtocolType(String protocolType) {
		this.protocolType = protocolType;
	}
	
	
}
