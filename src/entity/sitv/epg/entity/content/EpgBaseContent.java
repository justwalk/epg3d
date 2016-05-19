package sitv.epg.entity.content;

import java.util.Date;

public class EpgBaseContent extends Content {	   
	   private String  countryOfOrigin;//发行国家;
	   private String year;//发行年份;
	   private String studio;//发行公司;
	   private String producers;//制片;
	   private String actors;//演员;
	   private String director;//导演;
	   private String writer;//编剧;
	   private String summaryMedium;//内容简介;
	   private String summaryShort;//内容看点;	  
	   private int level; //评分
	   private String dub;//配音
	   private String caption; //字幕
	   private String keyword; //关键字
	   private String remark; //备注
	   private String contentType;
	   private boolean enableStatus;
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
	   
	public String getCountryOfOrigin() {
		return countryOfOrigin;
	}
	public void setCountryOfOrigin(String countryOfOrigin) {
		this.countryOfOrigin = countryOfOrigin;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getStudio() {
		return studio;
	}
	public void setStudio(String studio) {
		this.studio = studio;
	}
	public String getProducers() {
		return producers;
	}
	public void setProducers(String producers) {
		this.producers = producers;
	}
	public String getActors() {
		return actors;
	}
	public void setActors(String actors) {
		this.actors = actors;
	}
	public String getDirector() {
		return director;
	}
	public void setDirector(String director) {
		this.director = director;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	
	public String getSummaryMedium() {
		return summaryMedium;
	}
	public void setSummaryMedium(String summaryMedium) {
		this.summaryMedium = summaryMedium;
	}
	public String getSummaryShort() {
		return summaryShort;
	}
	public void setSummaryShort(String summaryShort) {
		this.summaryShort = summaryShort;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public String getDub() {
		return dub;
	}
	public void setDub(String dub) {
		this.dub = dub;
	}
	public String getCaption() {
		return caption;
	}
	public void setCaption(String caption) {
		this.caption = caption;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public boolean isEnableStatus() {
		return enableStatus;
	}
	public void setEnableStatus(boolean enableStatus) {
		this.enableStatus = enableStatus;
	}
	   
	  
}
