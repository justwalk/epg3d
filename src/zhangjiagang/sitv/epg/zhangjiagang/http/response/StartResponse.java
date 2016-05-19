package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 *
 */
public class StartResponse implements Serializable{
	
	private static final long serialVersionUID = 1L;

    private String purchaseToken;//结果的响应值

    private String previewAssetId;//片花资产ID

	public String getPurchaseToken() {
		return purchaseToken;
	}

	public void setPurchaseToken(String purchaseToken) {
		this.purchaseToken = purchaseToken;
	}

	public String getPreviewAssetId() {
		return previewAssetId;
	}

	public void setPreviewAssetId(String previewAssetId) {
		this.previewAssetId = previewAssetId;
	}
}
