/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.zhangjiagang.bo;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class Ticket {
    public static int FVOD_ORDER_TYPE = 0;//免费
    public static int SVOD_ORDER_TYPE = 1;//包月
    public static int RVOD_ORDER_TYPE = 2;//按次
    
    
    private String ticketId;
    private String localEntryUID;
    private String price;
    private String assetId;
    private String validTime;
    private String expireTime;
    
    private int orderType;
    private String purchaseTime;

    /**
     * @return the ticketId
     */
    public String getTicketId() {
        return ticketId;
    }

    /**
     * @param ticketId the ticketId to set
     */
    public void setTicketId(String ticketId) {
        this.ticketId = ticketId;
    }

    /**
     * @return the localEntryUID
     */
    public String getLocalEntryUID() {
        return localEntryUID;
    }

    /**
     * @param localEntryUID the localEntryUID to set
     */
    public void setLocalEntryUID(String localEntryUID) {
        this.localEntryUID = localEntryUID;
    }

    /**
     * @return the price
     */
    public String getPrice() {
        return price;
    }

    /**
     * @param price the price to set
     */
    public void setPrice(String price) {
        this.price = price;
    }

    /**
     * @return the assetId
     */
    public String getAssetId() {
        return assetId;
    }

    /**
     * @param assetId the assetId to set
     */
    public void setAssetId(String assetId) {
        this.assetId = assetId;
    }

	public String getValidTime() {
		return validTime;
	}

	public void setValidTime(String validTime) {
		this.validTime = validTime;
	}

	public String getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(String expireTime) {
		this.expireTime = expireTime;
	}

    /**
     * @return the orderType
     */
    public int getOrderType() {
        return orderType;
    }

    /**
     * @param orderType the orderType to set
     */
    public void setOrderType(int orderType) {
        this.orderType = orderType;
    }

    /**
     * @return the purchaseTime
     */
    public String getPurchaseTime() {
        return purchaseTime;
    }

    /**
     * @param purchaseTime the purchaseTime to set
     */
    public void setPurchaseTime(String purchaseTime) {
        this.purchaseTime = purchaseTime;
    }
}
