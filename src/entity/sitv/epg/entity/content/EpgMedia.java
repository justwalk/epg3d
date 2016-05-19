package sitv.epg.entity.content;

public class EpgMedia implements java.io.Serializable{
	private Long id;
	private EpgProgram epgProgram;
	private String assertName;
	private String assertId;
	private String type;
	private String audioType;
	private int fileSize;
	private String checkSum;
	private String fileName;
	private String format;
	private String birate;
	private boolean hd;
	private String reserve1;
	private String reserve2;
	private String reserve3;
	private String reserve4;
	private String reserve5;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public EpgProgram getEpgProgram() {
		return epgProgram;
	}
	public void setEpgProgram(EpgProgram epgProgram) {
		this.epgProgram = epgProgram;
	}
	public String getAssertName() {
		return assertName;
	}
	public void setAssertName(String assertName) {
		this.assertName = assertName;
	}
	public String getAssertId() {
		return assertId;
	}
	public void setAssertId(String assertId) {
		this.assertId = assertId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getAudioType() {
		return audioType;
	}
	public void setAudioType(String audioType) {
		this.audioType = audioType;
	}
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	public String getCheckSum() {
		return checkSum;
	}
	public void setCheckSum(String checkSum) {
		this.checkSum = checkSum;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getBirate() {
		return birate;
	}
	public void setBirate(String birate) {
		this.birate = birate;
	}
	public boolean isHd() {
		return hd;
	}
	public void setHd(boolean hd) {
		this.hd = hd;
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
	
	
	
}
