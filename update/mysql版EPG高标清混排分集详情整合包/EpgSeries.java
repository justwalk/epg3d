package sitv.epg.entity.content;
/**
 * 连续剧
 * @author zhangxs
 *
 */
public class EpgSeries  extends  EpgBaseContent{
	private int episodeNumber;
	private String reserve1;
	private String tags;
	private String mainFolder;
	private Integer hdType;//integer防止字段为空
	/**
	 * 高标清混排 20140311 wangkai
	 */
	private String relCode;

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getReserve1() {
    	return reserve1;
    }

	public void setReserve1(String reserve1) {
    	this.reserve1 = reserve1;
    }

	public int getEpisodeNumber() {
		return episodeNumber;
	}

	public void setEpisodeNumber(int episodeNumber) {
		this.episodeNumber = episodeNumber;
	}

	public String getMainFolder() {
		return mainFolder;
	}

	public void setMainFolder(String mainFolder) {
		this.mainFolder = mainFolder;
	}

	public Integer getHdType() {
		return hdType;
	}

	public void setHdType(Integer hdType) {
		this.hdType = hdType;
	}

	public String getRelCode() {
		return relCode;
	}

	public void setRelCode(String relCode) {
		this.relCode = relCode;
	}
	
}
