package sitv.epg.entity.content;

public class EpgDetailProgram extends EpgProgram {
	private int episodeNumber;
	private String programType;
	private String reserve1;
	private String tags;
	public String getReserve1() {
    	return reserve1;
    }

	public void setReserve1(String reserve1) {
    	this.reserve1 = reserve1;
    }

	public int getEpisodeNumber() {
		return episodeNumber;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public void setEpisodeNumber(int episodeNumber) {
		this.episodeNumber = episodeNumber;
	}

	public String getProgramType() {
		return programType;
	}

	public void setProgramType(String programType) {
		this.programType = programType;
	}

}
