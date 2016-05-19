package sitv.epg.zhangjiagang.http.response;

import java.io.Serializable;

/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 * 
 */
public class NavServerResponse implements Serializable {

    private static final long serialVersionUID = 1L;

	private String code;//错误码
	
	private String message;//错误描述

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
