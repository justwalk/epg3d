package sitv.epg.entity.content;

public class EpgLiveChannelParam implements java.io.Serializable{
	private Long id;
	private Long channelId;
	private String channelCode;
	private int channelNumber; //频道号
	private String networkId; //网络号
	private String casystemId; //ca系统id
	private String ecmpId; //
	private String videopId; 
	private String videoType;
	private String audiopId;
	private String audioType;
	private String pcrpId;
	private Long freq;
	private Long sym;
	private Long modId;
	private String serviceId;
	private String transportId;//码流标识
	
	public  String getDecimalValue(String value){
		if (value == null) return null;
		if (value.startsWith("0x")){
			value = value.substring(2);
		}
		return Integer.valueOf(value,16).toString();
	}
	
	/*public static void main(String[] args){
		System.out.println(EpgLiveChannelParam.getDecimalValue("0x1FFE"));
		System.out.println(EpgLiveChannelParam.getDecimalValue("0x2"));
	}*/
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getChannelId() {
		return channelId;
	}
	public void setChannelId(Long channelId) {
		this.channelId = channelId;
	}
	public String getChannelCode() {
		return channelCode;
	}
	public void setChannelCode(String channelCode) {
		this.channelCode = channelCode;
	}
	public int getChannelNumber() {
		return channelNumber;
	}
	public void setChannelNumber(int channelNumber) {
		this.channelNumber = channelNumber;
	}
	public String getNetworkId() {
		return networkId;
	}
	public void setNetworkId(String networkId) {
		this.networkId = networkId;
	}
	public String getCasystemId() {
		return casystemId;
	}
	public void setCasystemId(String casystemId) {
		this.casystemId = casystemId;
	}
	public String getEcmpIdDec(){
		return getDecimalValue(getEcmpId());
	}
	public String getEcmpId() {
		return ecmpId;
	}
	public void setEcmpId(String ecmpId) {
		this.ecmpId = ecmpId;
	}
	public String getVideopId() {
		return videopId;
	}
	
	public String getVideopIdDec(){
		return getDecimalValue(this.getVideopId());
	}
	public void setVideopId(String videopId) {
		this.videopId = videopId;
	}
	
	public String getVideoTypeDec(){
		return getDecimalValue(getVideoType());
	}
	public String getVideoType() {
		return videoType;
	}
	
	
	public void setVideoType(String videoType) {
		this.videoType = videoType;
	}
	
	public String getAudiopIdDec(){
		return getDecimalValue(getAudiopId());
	}
	
	public String getAudiopId() {
		return audiopId;
	}
	public void setAudiopId(String audiopId) {
		this.audiopId = audiopId;
	}
	public String getAudioType() {
		return audioType;
	}
	public void setAudioType(String audioType) {
		this.audioType = audioType;
	}
	
	public String getPcrpIdDec(){
		return getDecimalValue(getPcrpId());
	}
	public String getPcrpId() {
		return pcrpId;
	}
	public void setPcrpId(String pcrpId) {
		this.pcrpId = pcrpId;
	}
	public Long getFreq() {
		return freq;
	}
	public void setFreq(Long freq) {
		this.freq = freq;
	}
	public Long getSym() {
		return sym;
	}
	public void setSym(Long sym) {
		this.sym = sym;
	}
	public Long getModId() {
		return modId;
	}
	public void setModId(Long modId) {
		this.modId = modId;
	}
	public String getServiceId() {
		return serviceId;
	}
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
	public String getTransportId() {
		return transportId;
	}
	public void setTransportId(String transportId) {
		this.transportId = transportId;
	}
	
	
}
