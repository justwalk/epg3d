package sitv.epg.entity.content;

import java.math.BigDecimal;
import java.text.NumberFormat;

/**
 * 单集
 * @author zhangxs
 *
 */
public class EpgEpisode implements IContent,java.io.Serializable {
	private Long id;
	private Long  contentId;
	private Long seriesId;
	private String contentCode;
	private String seriesCode;
	private int episodeIndex;
	private int suggestedPrice;// 建议价格,单位 分;
	private String priceText;
	/**
	 * 高标清混排 20140311 wangkai
	 */
    private String title;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getContentId() {
		return contentId;
	}
	public void setContentId(Long contentId) {
		this.contentId = contentId;
	}
	public Long getSeriesId() {
		return seriesId;
	}
	public void setSeriesId(Long seriesId) {
		this.seriesId = seriesId;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public String getSeriesCode() {
		return seriesCode;
	}
	public void setSeriesCode(String seriesCode) {
		this.seriesCode = seriesCode;
	}
	public int getEpisodeIndex() {
		return episodeIndex;
	}
	public void setEpisodeIndex(int episodeIndex) {
		this.episodeIndex = episodeIndex;
	}
	public int getSuggestedPrice() {
		return suggestedPrice;
	}
	public void setSuggestedPrice(int suggestedPrice) {
		this.suggestedPrice = suggestedPrice;
	}
	public String getPriceText() {
	    BigDecimal b1 = new BigDecimal(this.suggestedPrice);
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
}
