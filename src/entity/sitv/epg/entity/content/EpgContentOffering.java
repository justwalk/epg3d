package sitv.epg.entity.content;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.NumberFormat;

public class EpgContentOffering implements Serializable {
	private Long id;
	private String offeringId;
	private String serviceType;
	private String contentCode;
	private String serviceName;
	private String serviceCode;
	private int suggestedPrice;// 建议价格,单位 分;
	private String priceText;
	private int price;
	private int rentalDuration;
	
	private String region;//RESERVE1
	private String serviceId;//RESERVE2
	
	public int getRentalDuration() {
		return rentalDuration;
	}
	public void setRentalDuration(int rentalDuration) {
		this.rentalDuration = rentalDuration;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getPriceText() {
	    BigDecimal b1 = new BigDecimal(this.price);
        BigDecimal b2 = new BigDecimal(100);
        double price = b1.divide(b2,2,BigDecimal.ROUND_HALF_UP).floatValue();
        
        NumberFormat nbf= NumberFormat.getInstance(); 
        nbf.setMinimumFractionDigits(2); 
        this.priceText = nbf.format(price);
        return priceText;
	}
	public void setPriceText(String priceText) {
		this.priceText = priceText;
	}
	public int getSuggestedPrice() {
		return suggestedPrice;
	}
	public void setSuggestedPrice(int suggestedPrice) {
		this.suggestedPrice = suggestedPrice;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
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
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
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
    /**
     * @return the region
     */
    public String getRegion() {
        return region;
    }
    /**
     * @param region the region to set
     */
    public void setRegion(String region) {
        this.region = region;
    }
    /**
     * @return the serviceId
     */
    public String getServiceId() {
        return serviceId;
    }
    /**
     * @param serviceId the serviceId to set
     */
    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }
}
