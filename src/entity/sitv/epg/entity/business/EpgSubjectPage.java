package sitv.epg.entity.business;
/**
 * 专题页面
 * @author zhangxs
 *
 */
public class EpgSubjectPage implements java.io.Serializable{
	private Long id;
	private String subjectTitle;
	private String subjectCode;
	private String pageName;
	private String pageCode;
	private String background;
	private boolean defaultFlag;
	private String highDefition;
	private String itemIcon;
	private String poster;
	private String still;
	private String icon;
	public String getHighDefition() {
		return highDefition;
	}
	public void setHighDefition(String highDefition) {
		this.highDefition = highDefition;
	}
	public String getItemIcon() {
		return itemIcon;
	}
	public void setItemIcon(String itemIcon) {
		this.itemIcon = itemIcon;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getSubjectTitle() {
		return subjectTitle;
	}
	public void setSubjectTitle(String subjectTitle) {
		this.subjectTitle = subjectTitle;
	}
	public String getSubjectCode() {
		return subjectCode;
	}
	public void setSubjectCode(String subjectCode) {
		this.subjectCode = subjectCode;
	}
	public String getPageName() {
		return pageName;
	}
	public void setPageName(String pageName) {
		this.pageName = pageName;
	}
	public String getPageCode() {
		return pageCode;
	}
	public void setPageCode(String pageCode) {
		this.pageCode = pageCode;
	}
	public String getBackground() {
		return background;
	}
	public void setBackground(String background) {
		this.background = background;
	}
	public boolean isDefaultFlag() {
		return defaultFlag;
	}
	public void setDefaultFlag(boolean defaultFlag) {
		this.defaultFlag = defaultFlag;
	}
	public String getPoster() {
		return poster;
	}
	public void setPoster(String poster) {
		this.poster = poster;
	}
	public String getStill() {
		return still;
	}
	public void setStill(String still) {
		this.still = still;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
}
