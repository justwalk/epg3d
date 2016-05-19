/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.data;

import chances.epg.exception.EpgRuntimeException;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class InvalidaQueryParameterException extends EpgRuntimeException {

    /**
     * @param message
     */
    public InvalidaQueryParameterException(String message) {
        super(message);
        // TODO Auto-generated constructor stub
    }

    /* (non-Javadoc)
     * @see chances.epg.exception.EpgRuntimeException#getErrorCode()
     */
    @Override
    public String getErrorCode() {
        return "5001";
    }

    /* (non-Javadoc)
     * @see chances.epg.exception.EpgRuntimeException#getErrorInfo()
     */
    @Override
    public String getErrorInfo() {
        return "查询数据时参数错误";
    }
}
