package sitv.epg.entity.content;

import java.util.Date;

public class Content implements IContent {
	private Long contentId;// 内容标识
	private String contentCode;// 节目编码
	private String title; // 显示标题
	private String titleBrief; // 标题简写;
	private String provider;// 提供商;
	private String providerId;// 提供商标识;
	private Date createDate;// 入库日期;
	private String reserve1;
	private String reserve2;
	private String reserve3;
	private String reserve4;
	private String reserve5;
	private String poster; // 海报
	private String still; // 剧照
	private String icon; // 缩略图

	public Long getContentId() {
		return contentId;
	}

	public void setContentId(Long contentId) {
		this.contentId = contentId;
	}

	public String getContentCode() {
		return contentCode;
	}

	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitleBrief() {
		return titleBrief;
	}

	public void setTitleBrief(String titleBrief) {
		this.titleBrief = titleBrief;
	}

	public String getProvide() {
		return provider;
	}

	public void setProvide(String provide) {
		this.provider = provide;
	}

	public String getProvideId() {
		return providerId;
	}

	public void setProvideId(String provideId) {
		this.providerId = provideId;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getReserve1() {
		return reserve1;
	}

	public void setReserve1(String reserve1) {
		this.reserve1 = reserve1;
	}

	public String getReserve2() {
		return reserve2;
	}

	public void setReserve2(String reserve2) {
		this.reserve2 = reserve2;
	}

	public String getReserve3() {
		return reserve3;
	}

	public void setReserve3(String reserve3) {
		this.reserve3 = reserve3;
	}

	public String getReserve4() {
		return reserve4;
	}

	public void setReserve4(String reserve4) {
		this.reserve4 = reserve4;
	}

	public String getReserve5() {
		return reserve5;
	}

	public void setReserve5(String reserve5) {
		this.reserve5 = reserve5;
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
