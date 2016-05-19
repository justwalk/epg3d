package sitv.epg.entity.edit;

import java.util.ArrayList;
import java.util.List;

/**
 * 分类
 * @author zhangxs
 *
 */
public class EpgCategory implements java.io.Serializable{
	private Long id;
	private String name;
	private String title;
	private String code;
	private int activeStatus; //生效状态
	private int chindIndex; //顺序
	private String parentCategoryCode;
	private String locationString;
	private String categoryIcon;
	private String backgroud;//bg pic
	private String description;
	private String serviceType;
	public Long getId() {
		return id;
	}
	
	public Long[] getIds(){
		if (locationString == null) return new Long[0];
		String[] ls = locationString.split("#");
		List ids = new ArrayList();
		for(int i=0;i<ls.length;i++){
			if (ls[i].length()>0){
				ids.add(Long.parseLong(ls[i]));
			}
		}
		return (Long[])ids.toArray(new Long[0]);
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public int getActiveStatus() {
		return activeStatus;
	}
	public void setActiveStatus(int activeStatus) {
		this.activeStatus = activeStatus;
	}
	public int getChindIndex() {
		return chindIndex;
	}
	public void setChindIndex(int chindIndex) {
		this.chindIndex = chindIndex;
	}
	public String getParentCategoryCode() {
		return parentCategoryCode;
	}
	public void setParentCategoryCode(String parentCategoryCode) {
		this.parentCategoryCode = parentCategoryCode;
	}
	public String getLocationString() {
		return locationString;
	}
	public void setLocationString(String locationString) {
		this.locationString = locationString;
	}
	public String getCategoryIcon() {
		return categoryIcon;
	}
	public void setCategoryIcon(String categoryIcon) {
		this.categoryIcon = categoryIcon;
	}
	public String getBackgroud() {
		return backgroud;
	}
	public void setBackgroud(String backgroud) {
		this.backgroud = backgroud;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

	public String getServiceType() {
		return serviceType;
	}

	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
	
	
}
