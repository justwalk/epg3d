package sitv.epg.zhangjiagang.bo;

import chances.epg.exception.EpgRuntimeException;

/**
 * Class comments.
 *
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
@SuppressWarnings("serial")
public class BoException extends EpgRuntimeException {
	public static final String LOGIN_ERROR = "BO10001";
	public static final String AUTH_ERROR = "BO10002";
	public static final String SELECTION_ERROR = "BO10003";
	public static final String GETOFFER_ERROR = "BO10004";
	public static final String NAVERROR_ERROR = "BO10000";
	
	private String errorCode;

    /**
     * @param arg0
     */
    public BoException(String msg,String errorCode) {
        super(msg);
        this.errorCode = errorCode;
    }

	@Override
	public String getErrorCode() {
		return this.errorCode;
	}

	@Override
	public String getErrorInfo() {
		return this.getMessage();
	}
}
