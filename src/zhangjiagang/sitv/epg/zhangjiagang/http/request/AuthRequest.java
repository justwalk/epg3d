package sitv.epg.zhangjiagang.http.request;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class AuthRequest implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private String portalId;//Portal 对应的ID
    
    private String client;//终端设备机身序列号
    
    private String account;//用户账号
    
    private String assetId;//节目资产ID
    
    private String providerId;//供应商ID
    
    private String serviceId;//商品ID
    
    private String isPreview;//是否播放片花，“Y”表示是

    //Request Format
    public String getXML() {
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
        xml.append("<ValidatePlayEligibility portalId=\"").append(portalId).append("\" ");
        xml.append("client=\"").append(client).append("\" ");
        xml.append("account=\"").append(account).append("\" ");
        xml.append("assetId=\"").append(assetId).append("\" ");
//        xml.append("providerId=\"").append(providerId).append("\" ");
        xml.append("serviceId=\"").append(serviceId).append("\" ");
        xml.append("isPreview=\"N").append("\"/>");
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

	public String getAssetId() {
		return assetId;
	}

	public void setAssetId(String assetId) {
		this.assetId = assetId;
	}

	public String getProviderId() {
		return providerId;
	}

	public void setProviderId(String providerId) {
		this.providerId = providerId;
	}

	public String getIsPreview() {
		return isPreview;
	}

	public void setIsPreview(String isPreview) {
		this.isPreview = isPreview;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceId() {
		return serviceId;
	}

}
