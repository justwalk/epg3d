package sitv.epg.entity.content;
/**
 * 高标清混排类型实体类
 * @author wangkai
 *
 */
public class EpgRelContent implements IContent {
	
	private Long id;
	private String relName;//包名（一个包对应多个视频）
	private String relCode;//包编码
	private String contentCode;//内容编码
	private int videoType;//视频类型：0、HD 1、SD 2、3D
	private int bodyType;//内容类型：1、正片   2、预告片  3、片花
	private int audioType;//语音类型：1、原声   2、国语    3、粤语
	private int status;//状态  0: 正常    1删除
	private String type;//剧集 ：单剧集 vod   多剧集series
	private String relCodeFlag;	//关联状态
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRelName() {
		return relName;
	}
	public void setRelName(String relName) {
		this.relName = relName;
	}
	public String getRelCode() {
		return relCode;
	}
	public void setRelCode(String relCode) {
		this.relCode = relCode;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public int getBodyType() {
		return bodyType;
	}
	public void setBodyType(int bodyType) {
		this.bodyType = bodyType;
	}
	public int getAudioType() {
		return audioType;
	}
	public void setAudioType(int audioType) {
		this.audioType = audioType;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getVideoType() {
		return videoType;
	}
	public void setVideoType(int videoType) {
		this.videoType = videoType;
	}
	public String getRelCodeFlag() {
		return relCodeFlag;
	}
	public void setRelCodeFlag(String relCodeFlag) {
		this.relCodeFlag = relCodeFlag;
	}

	
}
