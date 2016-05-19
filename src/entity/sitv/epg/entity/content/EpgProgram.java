package sitv.epg.entity.content;

/**
 * Module:  EpgProgram.java
 * Author:  zhangxs
 * Purpose: Defines the Class EpgProgram
 */
import java.math.BigDecimal;
import java.text.NumberFormat;

/**
 * 节目
 * 
 * @author zhangxs
 * 
 */
public class EpgProgram extends EpgBaseContent {

    /**
     * create with 2014-3-3 / 下午04:25:35
     */
    private static final long serialVersionUID = 8232809938196192296L;
    private String rating;// 影片分级;
    private String runTime; // 播出时长;
    private String displayRunTime;// 显示时长;
    private String maximumViewingLength;// 最大播出时长; dd:hh:MM 天:小时:分钟
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

    private String playUrl;
    private String bookMarkPlayUrl;

    private String posterFullPath;
    private String stillFullPath;
    private String iconFullPath;

    // 高标预混排提取模块
    private String indexUrl;
    private String packageAssetId;
    private String mainFolder;
    private String subFolder;
    private Integer hdType;
    private String relCode;

    public String getPosterFullPath() {
        return posterFullPath;
    }

    public void setPosterFullPath(String posterFullPath) {
        this.posterFullPath = posterFullPath;
    }

    public String getStillFullPath() {
        return stillFullPath;
    }

    public void setStillFullPath(String stillFullPath) {
        this.stillFullPath = stillFullPath;
    }

    public String getIconFullPath() {
        return iconFullPath;
    }

    public void setIconFullPath(String iconFullPath) {
        this.iconFullPath = iconFullPath;
    }

    public String getPlayUrl() {
        return playUrl;
    }

    public void setPlayUrl(String playUrl) {
        this.playUrl = playUrl;
    }

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
        double price = b1.divide(b2, 2, BigDecimal.ROUND_HALF_UP).floatValue();

        NumberFormat nbf = NumberFormat.getInstance();
        nbf.setMinimumFractionDigits(2);
        this.priceText = nbf.format(price);
        return priceText;
    }

    public static void main(String[] args) {
        EpgProgram program = new EpgProgram();
        // program.setSuggestedPrice(350);
        System.out.println(program.getPriceText());
    }

    public void setPriceText(String priceText) {
        this.priceText = priceText;
    }

    public String getBookMarkPlayUrl() {
        return bookMarkPlayUrl;
    }

    public void setBookMarkPlayUrl(String bookMarkPlayUrl) {
        this.bookMarkPlayUrl = bookMarkPlayUrl;
    }

    public String getIndexUrl() {
        return indexUrl;
    }

    public void setIndexUrl(String indexUrl) {
        this.indexUrl = indexUrl;
    }

    public String getPackageAssetId() {
        return packageAssetId;
    }

    public void setPackageAssetId(String packageAssetId) {
        this.packageAssetId = packageAssetId;
    }

    public String getMainFolder() {
        return mainFolder;
    }

    public void setMainFolder(String mainFolder) {
        this.mainFolder = mainFolder;
    }

    public String getSubFolder() {
        return subFolder;
    }

    public void setSubFolder(String subFolder) {
        this.subFolder = subFolder;
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
