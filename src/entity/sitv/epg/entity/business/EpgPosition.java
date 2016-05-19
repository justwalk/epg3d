package sitv.epg.entity.business;

import java.util.Date;
/**
 * 推荐位
 * @author zhangxs
 *
 */
public class EpgPosition implements java.io.Serializable {
	
	public static final String TYPE_IMAGE="image";
	public static final String TYPE_CHANNEL="channel";
	public static final String TYPE_TEXT="text";

	public static final String LINKOBJTYPE_VOD="vod";
	public static final String LINKOBJTYPE_SERIES="series";
	public static final String LINKOBJTYPE_EPISODE="episode";
	public static final String LINKOBJTYPE_CHANNEL="channel";
	public static final String LINKOBJTYPE_SUBJECT="subject";
	public static final String LINKOBJTYPE_CATEGORY="category";
	public static final String LINKOBJTYPE_TVBAR="tvbar";
	public static final String LINKOBJTYPE_URL="url";
	
	
	private Long id;
	private String code;
	private String type;
	private String adCode;
	private Date validTime;
	private Date expireTime;
	private int weight;
	private String objType;
	private String objValue;
	private String linkObjType;
	private String linkObjValue;
	private boolean defaultFlag;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getAdCode() {
		return adCode;
	}
	public void setAdCode(String adCode) {
		this.adCode = adCode;
	}
	public Date getValidTime() {
		return validTime;
	}
	public void setValidTime(Date validTime) {
		this.validTime = validTime;
	}
	public Date getExpireTime() {
		return expireTime;
	}
	public void setExpireTime(Date expireTime) {
		this.expireTime = expireTime;
	}
	public int getWeight() {
		return weight;
	}
	public void setWeight(int weight) {
		this.weight = weight;
	}
	public String getObjType() {
		return objType;
	}
	public void setObjType(String objType) {
		this.objType = objType;
	}
	public String getObjValue() {
		return objValue;
	}
	public void setObjValue(String objValue) {
		this.objValue = objValue;
	}
	public String getLinkObjType() {
		return linkObjType;
	}
	public void setLinkObjType(String linkObjType) {
		this.linkObjType = linkObjType;
	}
	public String getLinkObjValue() {
		return linkObjValue;
	}
	public void setLinkObjValue(String linkObjValue) {
		this.linkObjValue = linkObjValue;
	}
	public boolean isDefaultFlag() {
		return defaultFlag;
	}
	public void setDefaultFlag(boolean defaultFlag) {
		this.defaultFlag = defaultFlag;
	}
	
	
}
