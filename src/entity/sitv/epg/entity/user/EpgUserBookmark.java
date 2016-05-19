package sitv.epg.entity.user;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.SimpleFormatter;

public class EpgUserBookmark implements Serializable {
	private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	private Long id;
	private String userId;
	private String macAddr;
	private String contentName;
	private String contentType;
	private String contentCode;
	private int contentElapsed;
	private Date markTime;
	//added by jason 4/6/2011
	private String bizCode; // 收藏的片子所在的看吧
	private String categoryCode; //收藏的片子所在的栏目
	private String indexUrl;
	private String deleteUrl;
	
	//added by libf,2011/11/25
	private String markTimeStr;
	
	public String getDeleteUrl() {
		return deleteUrl;
	}
	public void setDeleteUrl(String deleteUrl) {
		this.deleteUrl = deleteUrl;
	}
	public String getIndexUrl() {
		return indexUrl;
	}
	public void setIndexUrl(String indexUrl) {
		this.indexUrl = indexUrl;
	}
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
	public int getContentElapsed() {
		return contentElapsed;
	}
	public void setContentElapsed(int contentElapsed) {
		this.contentElapsed = contentElapsed;
	}
	public Date getMarkTime() {
		return markTime;
	}
	public void setMarkTime(Date markTime) {
		this.markTime = markTime;
		
		if(this.markTime != null) {
			this.markTimeStr = sdf.format(markTime);
		}
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
	
	public String getMarkTimeStr() {
		if(this.markTimeStr == null) {
			this.markTimeStr =  "1970-01-01 00:00:00";
		}
		return this.markTimeStr;
	}
}
