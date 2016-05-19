package sitv.epg.zhangjiagang.http.request;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class LoginRequest implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private String portalId;//Portal 对应的ID
    
    private String deviceId;//终端设备机身序列号
    
    private String client;//终端设备机身序列号
    
    private String userType;//终端设备机身序列号

    //Request Format
    public String getXML() {
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
        xml.append("<NavCheck portalId=\"").append(portalId).append("\" ");
        xml.append("deviceId=\"").append(deviceId).append("\" ");
        xml.append("client=\"").append(client).append("\" ");
        xml.append("userType=\"").append(userType).append("\"/>");
        return xml.toString();
    }

	public String getPortalId() {
		return portalId;
	}

	public void setPortalId(String portalId) {
		this.portalId = portalId;
	}

	public String getDeviceId() {
		return deviceId;
	}

	public void setDeviceId(String deviceId) {
		this.deviceId = deviceId;
	}

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
}
