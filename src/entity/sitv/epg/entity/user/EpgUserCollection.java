package sitv.epg.entity.user;

import java.util.Date;

public class EpgUserCollection implements java.io.Serializable{
	private Long id;
	private String userId;
	private String macAddr;
	private String contentName;
	private String contentType;
	private String contentCode;
	private Date collectTime;
	//added by jason 4/6/2011
	private String bizCode; // 收藏的片子所在的看吧
	private String categoryCode; //收藏的片子所在的栏目
	private String indexUrl; //收藏的片子的链接URL
	private String delCollectionUrl; //删除收藏的片子的链接URL
	
	private String still; // 1280海报
	private String hdType; // 高标清标识
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getContentName() {
		return contentName;
	}
	public void setContentName(String contentName) {
		this.contentName = contentName;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public Date getCollectTime() {
		return collectTime;
	}
	public void setCollectTime(Date collectTime) {
		this.collectTime = collectTime;
	}
	public String getMacAddr() {
		return macAddr;
	}
	public void setMacAddr(String macAddr) {
		this.macAddr = macAddr;
	}
	@Override
	public String toString() {
		return new StringBuffer("collection id:").append(id).append(";contentType:").append(contentType)
		.append("contentName:").append(contentName).append("macAddress:")
		.append(this.macAddr).append("userId").append(this.userId).toString();
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
	public String getIndexUrl() {
		return indexUrl;
	}
	public void setIndexUrl(String indexUrl) {
		this.indexUrl = indexUrl;
	}
	public String getDelCollectionUrl() {
		return delCollectionUrl;
	}
	public void setDelCollectionUrl(String delCollectionUrl) {
		this.delCollectionUrl = delCollectionUrl;
	}
	public String getStill() {
	    return still;
	}
	public void setStill(String still) {
	    this.still = still;
	}
	public String getHdType() {
	    return hdType;
	}
	public void setHdType(String hdType) {
	    this.hdType = hdType;
	}
	
}
