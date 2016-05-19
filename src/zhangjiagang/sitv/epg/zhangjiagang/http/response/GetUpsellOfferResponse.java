package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 *
 */
public class GetUpsellOfferResponse implements Serializable{
	
	private static final long serialVersionUID = 1L;

    private String serviceId;//服务ID
    
    private String title;//显示的标题
    
    private String displayPrice;//当地的货币单位
    
    private String displayText;//对商品的描述

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDisplayPrice() {
		return displayPrice;
	}

	public void setDisplayPrice(String displayPrice) {
		this.displayPrice = displayPrice;
	}

	public String getDisplayText() {
		return displayText;
	}

	public void setDisplayText(String displayText) {
		this.displayText = displayText;
	}
    
}
