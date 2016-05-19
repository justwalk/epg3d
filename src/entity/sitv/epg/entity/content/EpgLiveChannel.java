package sitv.epg.entity.content;

public class EpgLiveChannel extends Content {
	private String channelCode;
	private String serviceName;
	private String channelNum;
	private String playUrl;
	private String liveCode;
	private String playChannelUrl;
	

	public String getPlayUrl() {
    	return playUrl;
    }

	public void setPlayUrl(String playUrl) {
    	this.playUrl = playUrl;
    }

	public String getLiveCode() {
    	return liveCode;
    }

	public void setLiveCode(String liveCode) {
    	this.liveCode = liveCode;
    }

	public String getChannelNum() {
    	return channelNum;
    }

	public void setChannelNum(String channelNum) {
    	this.channelNum = channelNum;
    }
    public String getChannelCode() {
        return channelCode;
    }
    /**
     * @param channelCode the channelCode to set
     */
    public void setChannelCode(String channelCode) {
        this.channelCode = channelCode;
    }
    /**
     * @return the serviceName
     */
    public String getServiceName() {
        return serviceName;
    }
    /**
     * @param serviceName the serviceName to set
     */
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

	public String getPlayChannelUrl() {
		return playChannelUrl;
	}

	public void setPlayChannelUrl(String playChannelUrl) {
		this.playChannelUrl = playChannelUrl;
	}
}
