package sitv.epg.entity.edit;

import java.util.Date;

import sitv.epg.entity.content.EpgProgram;
/**
 * 分类编排项
 * @author zhangxs
 *
 */
public class EpgCategoryItem implements java.io.Serializable{
	
	public static final String ITEMTYPE_BUSINESS="tvbar";//看吧
	public static final String ITEMTYPE_POSITION="position"; //推荐位
	public static final String ITEMTYPE_CATEGORY="category"; //分类
	public static final String ITEMTYPE_SUBJECT="subject"; //专题
	public static final String ITEMTYPE_EPISODE="episode"; //剧集
	public static final String ITEMTYPE_VOD="vod"; //影片
	public static final String ITEMTYPE_SCHEDULE="schedule"; // 节目单
	public static final String ITEMTYPE_SERIES="series"; //电视剧
	public static final String ITEMTYPE_CHANNEL="cha";//频道
	public static final String ITEMTYPE_URL="url"; //外部链接
	public static final String ITEMTYPE_ICM="icm"; //ICM链接
	
	
	private Long id;
	private String  categoryCode;
	private String itemType;
	private String itemCode;
	private String title;
	private String subTitle;
	private int status;
	private int type;//编排类型
	private boolean showTag;
	private int itemOrder;
	private Date beginTime;
	private Date endTime;
	private Date validTime;
	private Date expireTime;
	private String itemIcon;
	private Date createTime;
	private String objType;
	private String linkObjType;
	
	private String itemIconFullPath;
	private String indexUrl;
	private String collectUrl;
	
	public String getCollectUrl() {
    	return collectUrl;
    }
	public void setCollectUrl(String collectUrl) {
    	this.collectUrl = collectUrl;
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
	public String getCategoryCode() {
		return categoryCode;
	}
	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}
	public String getItemType() {
		return itemType;
	}
	public void setItemType(String itemType) {
		this.itemType = itemType;
	}
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSubTitle() {
		return subTitle;
	}
	public void setSubTitle(String subTitle) {
		this.subTitle = subTitle;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public boolean isShowTag() {
		return showTag;
	}
	public void setShowTag(boolean showTag) {
		this.showTag = showTag;
	}
	public int getItemOrder() {
		return itemOrder;
	}
	public void setItemOrder(int itemOrder) {
		this.itemOrder = itemOrder;
	}
	public Date getBeginTime() {
		return beginTime;
	}
	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
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
	
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getItemIcon() {
		return itemIcon;
	}
	public void setItemIcon(String itemIcon) {
		this.itemIcon = itemIcon;
	}
	public String getObjType() {
		return objType;
	}
	public void setObjType(String objType) {
		this.objType = objType;
	}	
	
	public String getLinkObjType() {
		return objType;
	}
	public void setLinkObjType(String linkObjType) {
		this.linkObjType = linkObjType;
	}
    /**
     * @return the itemIconFullPath
     */
    public String getItemIconFullPath() {
        return itemIconFullPath;
    }
    /**
     * @param itemIconFullPath the itemIconFullPath to set
     */
    public void setItemIconFullPath(String itemIconFullPath) {
        this.itemIconFullPath = itemIconFullPath;
    }
}
