package sitv.epg.entity.business;
/**
 * 专题页面热区
 * @author zhangxs
 *
 */
public class EpgSubjectArea implements java.io.Serializable {
	
	public static final String LINKOBJTYPE_VOD="vod";
	public static final String LINKOBJTYPE_SERIES="series";
	public static final String LINKOBJTYPE_CHANNEL="channel";
	public static final String LINKOBJTYPE_SUBJECT="subject";
	public static final String LINKOBJTYPE_CATEGORY="category";
	public static final String LINKOBJTYPE_TVBAR="tvbar";
	public static final String LINKOBJTYPE_URL="url";
	public static final String LINKOBJTYPE_PAGE="page";
	
	
	private Long id;
	private String title;
	private String subjectTitle;
	private String pageCode;
	private String location;
	private int left;
	private int top;
	private int width;
	private int height;
	private String objType;
	private String objCode;
	private int defaultArea;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSubjectTitle() {
		return subjectTitle;
	}
	public void setSubjectTitle(String subjectTitle) {
		this.subjectTitle = subjectTitle;
	}
	public String getPageCode() {
		return pageCode;
	}
	public void setPageCode(String pageCode) {
		this.pageCode = pageCode;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getObjType() {
		return objType;
	}
	public void setObjType(String objType) {
		this.objType = objType;
	}
	public String getObjCode() {
		return objCode;
	}
	public void setObjCode(String objCode) {
		this.objCode = objCode;
	}
    public int getDefaultArea() {
        return defaultArea;
    }
    public void setDefaultArea(int defaultArea) {
        this.defaultArea = defaultArea;
    }
	
	public int getLeft() {
		String[] posItems = this.getLocation().split(",");
		return Integer.parseInt(posItems[0]);
	}
	public void setLeft(int left) {
		this.left = left;
	}
	public int getTop() {
		String[] posItems = this.getLocation().split(",");
		return Integer.parseInt(posItems[1]);
	}
	public void setTop(int top) {
		this.top = top;
	}
	public int getWidth() {
		String[] posItems = this.getLocation().split(",");
		int left1 = Integer.parseInt(posItems[0]);
		int left2 = Integer.parseInt(posItems[2]);
		return left2-left1;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public int getHeight() {
		String[] posItems = this.getLocation().split(",");
		int top1 = Integer.parseInt(posItems[1]);
		int top2 = Integer.parseInt(posItems[3]);
		return top2-top1;
	}
	public void setHeight(int height) {
		this.height = height;
	}

	
}
