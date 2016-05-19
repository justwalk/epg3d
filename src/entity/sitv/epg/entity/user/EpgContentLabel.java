package sitv.epg.entity.user;
/**
 * 用户连续播放书签
 * @author zhangxs
 *
 */
public class EpgContentLabel implements java.io.Serializable{
	private Long id;
	private String contentCode;
	private String userId;
	private int episodeIndex;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getEpisodeIndex() {
		return episodeIndex;
	}
	public void setEpisodeIndex(int episodeIndex) {
		this.episodeIndex = episodeIndex;
	}
	
	
}	
