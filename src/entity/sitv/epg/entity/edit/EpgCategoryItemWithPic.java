package sitv.epg.entity.edit;
//With Program
public class EpgCategoryItemWithPic extends EpgCategoryItem {
	private String poster;
	private String still;
	private String icon;
	
	private String posterFullPath;
	private String stillFullPath;
	private String iconFullPath;
	
	private String reserve1;
	
	public String getReserve1() {
    	return reserve1;
    }
	public void setReserve1(String reserve1) {
    	this.reserve1 = reserve1;
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
    /**
     * @return the posterFullPath
     */
    public String getPosterFullPath() {
        return posterFullPath;
    }
    /**
     * @param posterFullPath the posterFullPath to set
     */
    public void setPosterFullPath(String posterFullPath) {
        this.posterFullPath = posterFullPath;
    }
    /**
     * @return the stillFullPath
     */
    public String getStillFullPath() {
        return stillFullPath;
    }
    /**
     * @param stillFullPath the stillFullPath to set
     */
    public void setStillFullPath(String stillFullPath) {
        this.stillFullPath = stillFullPath;
    }
    /**
     * @return the iconFullPath
     */
    public String getIconFullPath() {
        return iconFullPath;
    }
    /**
     * @param iconFullPath the iconFullPath to set
     */
    public void setIconFullPath(String iconFullPath) {
        this.iconFullPath = iconFullPath;
    }
	
	
	
	
}
