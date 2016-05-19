package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 *
 */
public class ZoneFreqInfo implements Serializable {
	
	/**
	 * 区域频点列表（ODC根据区域频点锁频获取TSID作为区域码，S1规范中的QAM name可使用此TSID）
	 */
	private static final long serialVersionUID = 1L;

	private String qamMode;//调制模式
	
	private String symbolRate;//符号率
	
	private String frequency;//频点频率（Hz）

	public String getQamMode() {
		return qamMode;
	}

	public void setQamMode(String qamMode) {
		this.qamMode = qamMode;
	}

	public String getSymbolRate() {
		return symbolRate;
	}

	public void setSymbolRate(String symbolRate) {
		this.symbolRate = symbolRate;
	}

	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	public String getFrequency() {
		return frequency;
	}

}
