package sitv.epg.entity.user;

import java.io.Serializable;

public class EpgUserSeriesmark implements Serializable {
	
	private Long id;
	private String userId;
	private String contentCode;
	private int episodeIndex;
	
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
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public int getEpisodeIndex() {
		return episodeIndex;
	}
	public void setEpisodeIndex(int episodeIndex) {
		this.episodeIndex = episodeIndex;
	}
}
