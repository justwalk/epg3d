package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class AuthResponse implements Serializable {

    private static final long serialVersionUID = 1L;

	private String price;//价格，单位分，当地的货币单位，如果该值不存在或为0则表示不收费

    private String orderFlag;//订购标识：“Y”：已订购，“N”：未订购
    
    private String newRental;//"Y"：用户第一次订购 "N"：用户不是首次订购
    
    private String rentalExpiration;//如果是已订购，则指过期时间
    
    private String previewAssetId;//片花资产ID

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getOrderFlag() {
		return orderFlag;
	}

	public void setOrderFlag(String orderFlag) {
		this.orderFlag = orderFlag;
	}

	public String getNewRental() {
		return newRental;
	}

	public void setNewRental(String newRental) {
		this.newRental = newRental;
	}

	public String getRentalExpiration() {
		return rentalExpiration;
	}

	public void setRentalExpiration(String rentalExpiration) {
		this.rentalExpiration = rentalExpiration;
	}

	public String getPreviewAssetId() {
		return previewAssetId;
	}

	public void setPreviewAssetId(String previewAssetId) {
		this.previewAssetId = previewAssetId;
	}

}
