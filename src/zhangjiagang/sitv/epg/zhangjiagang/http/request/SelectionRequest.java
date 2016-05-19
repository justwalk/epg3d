package sitv.epg.zhangjiagang.http.request;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class SelectionRequest implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private String portalId;//Portal 对应的ID
    
    private String client;//终端设备机身序列号
    
    private String account;//用户账号
    
    private String serviceId;//商品ID
    
    private String titleProviderId;//供应商ID
    
    private String titleAssetId;//资产ID
    
    private String audioLanguage;//音频语言代码
    
    private String folderAssetId;//对应栏目的资产ID
    
    private String subtitleLanguage;//字幕语言代码
    
    private String format;//格式，“SD”或“HD”
    
    private String indefiniteRental;//租期
    
    private String rentalPeriod;//单位分钟
    
    private String price;//价格
    
    private String playPreview;//如果出现只能是“Y”，只播放片花

    //Request Format
    public String getXML() {
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
        xml.append("<SelectionStart portalId=\"").append(portalId).append("\" ");
        xml.append("client=\"").append(client).append("\" ");
        xml.append("account=\"").append(account).append("\" ");
        xml.append("titleAssetId=\"").append(titleAssetId).append("\" ");
        xml.append("folderAssetId=\"").append(folderAssetId).append("\" ");
        xml.append("serviceId=\"").append(serviceId).append("\"/>");
        return xml.toString();
    }

	public String getPortalId() {
		return portalId;
	}

	public void setPortalId(String portalId) {
		this.portalId = portalId;
	}

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getTitleProviderId() {
		return titleProviderId;
	}

	public void setTitleProviderId(String titleProviderId) {
		this.titleProviderId = titleProviderId;
	}

	public String getTitleAssetId() {
		return titleAssetId;
	}

	public void setTitleAssetId(String titleAssetId) {
		this.titleAssetId = titleAssetId;
	}

	public String getAudioLanguage() {
		return audioLanguage;
	}

	public void setAudioLanguage(String audioLanguage) {
		this.audioLanguage = audioLanguage;
	}

	public String getFolderAssetId() {
		return folderAssetId;
	}

	public void setFolderAssetId(String folderAssetId) {
		this.folderAssetId = folderAssetId;
	}

	public String getSubtitleLanguage() {
		return subtitleLanguage;
	}

	public void setSubtitleLanguage(String subtitleLanguage) {
		this.subtitleLanguage = subtitleLanguage;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String getIndefiniteRental() {
		return indefiniteRental;
	}

	public void setIndefiniteRental(String indefiniteRental) {
		this.indefiniteRental = indefiniteRental;
	}

	public String getRentalPeriod() {
		return rentalPeriod;
	}

	public void setRentalPeriod(String rentalPeriod) {
		this.rentalPeriod = rentalPeriod;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getPlayPreview() {
		return playPreview;
	}

	public void setPlayPreview(String playPreview) {
		this.playPreview = playPreview;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceId() {
		return serviceId;
	}
}
