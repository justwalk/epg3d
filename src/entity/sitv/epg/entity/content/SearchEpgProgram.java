package sitv.epg.entity.content;

/**
 * Module:  EpgProgram.java
 * Author:  zhangxs
 * Purpose: Defines the Class EpgProgram
 */


/**
 * 节目
 * 
 * @author zhangxs
 * 
 */
public class SearchEpgProgram {

	private String title;
	private int contentId; 
	private String contentCode;
	private String contentType;
	private int enableStatus;
	private String indexUrl;
	
	private int countAll;
	private int countMovie;
	private int countEpisode;
	
	public int getCountAll() {
	    return countAll;
	}
	public void setCountAll(int countAll) {
	    this.countAll = countAll;
	}
	public int getCountMovie() {
	    return countMovie;
	}
	public void setCountMovie(int countMovie) {
	    this.countMovie = countMovie;
	}
	public int getCountEpisode() {
	    return countEpisode;
	}
	public void setCountEpisode(int countEpisode) {
	    this.countEpisode = countEpisode;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getContentId() {
		return contentId;
	}
	public void setContentId(int contentId) {
		this.contentId = contentId;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public int getEnableStatus() {
		return enableStatus;
	}
	public void setEnableStatus(int enableStatus) {
		this.enableStatus = enableStatus;
	}
	public String getIndexUrl() {
		return indexUrl;
	}
	public void setIndexUrl(String indexUrl) {
		this.indexUrl = indexUrl;
	}
	
	
}
