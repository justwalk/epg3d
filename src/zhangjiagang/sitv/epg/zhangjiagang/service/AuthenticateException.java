package sitv.epg.zhangjiagang.service;

import chances.epg.exception.EpgRuntimeException;


/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 *
 */
public class AuthenticateException extends EpgRuntimeException {

	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = -6708329417889971896L;
	
	public static final String NOT_LOGIN = "AUTH10001";
	public static final String NOT_SUPPORT_SERVICE_TYPE = "AUTH10002";
	
	private String errorCode;
	
	public AuthenticateException(String message,String errorCode) {
		super(message);
		this.errorCode = errorCode;
	}

	@Override
	public String getErrorCode() {
		return this.errorCode;
	}
}
