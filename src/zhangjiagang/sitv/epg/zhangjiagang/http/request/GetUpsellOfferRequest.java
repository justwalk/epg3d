package sitv.epg.zhangjiagang.http.request;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class GetUpsellOfferRequest implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private String portalId;//Portal 对应的ID
    
    private String client;//终端设备机身序列号
    
    private String account;//用户账号
    
    private String serviceId;//商品ID
    
    private String profile;//查询策略标识，服务器端定义
    
    //Request Format
    public String getXML() {
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
        xml.append("<GetUpsellOffer portalId=\"").append(portalId).append("\" ");
        xml.append("client=\"").append(client).append("\" ");
        xml.append("account=\"").append(account).append("\" ");
//        xml.append("serviceId=\"").append(serviceId).append("\" ");
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
	
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public String getProfile() {
		return profile;
	}
}
