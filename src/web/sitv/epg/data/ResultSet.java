package sitv.epg.data;

import java.io.Serializable;

public class ResultSet implements Serializable {
	private int totalNumber;
	private String resultList;
	
	public ResultSet(int totalNumber,String resultList) {
		this.totalNumber = totalNumber;
		this.resultList = resultList;
	}

	public int getTotalNumber() {
		return totalNumber;
	}

	public void setTotalNumber(int totalNumber) {
		this.totalNumber = totalNumber;
	}

	public String getResultList() {
		return resultList;
	}

	public void setResultList(String resultList) {
		this.resultList = resultList;
	}
}
