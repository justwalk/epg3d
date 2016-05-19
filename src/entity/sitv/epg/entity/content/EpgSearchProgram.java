package sitv.epg.entity.content;

/**
 * Module:  EpgSearchProgram.java
 * Author:  chenjie
 * Purpose: Defines the Class EpgSearchProgram
 */
import java.math.BigDecimal;
import java.text.NumberFormat;

/**
 * 节目
 * 
 * @author zhangxs
 * 
 */
public class EpgSearchProgram extends EpgBaseContent {

	private String rating;// 影片分级;
	private String runTime; // 播出时长;
	private String displayRunTime;// 显示时长;
	private String maximumViewingLength;// 最大播出时长; dd:hh:MM  天:小时:分钟
	private String previewPeriod;// 预览片段时长;
	private String billingId;// 计费标识;
	private String product;// 产品标识;
	private int suggestedPrice;// 建议价格,单位 分;
	private String courtyard; // 院线信息
	private String sertitle;// 系列名
	private String tags; // 关联标签
	private String offeringId;
	private String serviceType;
	private String serviceName;
	private String serviceCode;
	private String priceText;

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getRunTime() {
		return runTime;
	}

	public void setRunTime(String runTime) {
		this.runTime = runTime;
	}

	public String getDisplayRunTime() {
		return displayRunTime;
	}

	public void setDisplayRunTime(String displayRunTime) {
		this.displayRunTime = displayRunTime;
	}

	public String getMaximumViewingLength() {
		return maximumViewingLength;
	}

	public void setMaximumViewingLength(String maximumViewingLength) {
		this.maximumViewingLength = maximumViewingLength;
	}

	public String getPreviewPeriod() {
		return previewPeriod;
	}

	public void setPreviewPeriod(String previewPeriod) {
		this.previewPeriod = previewPeriod;
	}

	public String getBillingId() {
		return billingId;
	}

	public void setBillingId(String billingId) {
		this.billingId = billingId;
	}

	public String getProduct() {
		return product;
	}

	public void setProduct(String product) {
		this.product = product;
	}

	public int getSuggestedPrice() {
		return suggestedPrice;
	}

	public void setSuggestedPrice(int suggestedPrice) {
		this.suggestedPrice = suggestedPrice;
	}

	public String getCourtyard() {
		return courtyard;
	}

	public void setCourtyard(String courtyard) {
		this.courtyard = courtyard;
	}

	public String getSertitle() {
		return sertitle;
	}

	public void setSertitle(String sertitle) {
		this.sertitle = sertitle;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getOfferingId() {
		return offeringId;
	}

	public void setOfferingId(String offeringId) {
		this.offeringId = offeringId;
	}

	public String getServiceType() {
		return serviceType;
	}

	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getServiceCode() {
		return serviceCode;
	}

	public void setServiceCode(String serviceCode) {
		this.serviceCode = serviceCode;
	}
	
	public String getPriceText() {
	    BigDecimal b1 = new BigDecimal(this.suggestedPrice);
        BigDecimal b2 = new BigDecimal(100);
        double price = b1.divide(b2,2,BigDecimal.ROUND_HALF_UP).floatValue();
        
        NumberFormat nbf= NumberFormat.getInstance(); 
        nbf.setMinimumFractionDigits(2); 
        this.priceText = nbf.format(price);
        return priceText;
	}
	
	public static void main(String[] args){
	    EpgProgram program = new EpgProgram();
	    //program.setSuggestedPrice(350);
	    System.out.println(program.getPriceText());
	}

	public void setPriceText(String priceText) {
		this.priceText = priceText;
	}
}
