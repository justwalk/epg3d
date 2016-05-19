/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.EpgLogGenerator;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.bo.BoException;
import chances.epg.exception.EpgRuntimeException;

/**
 * Class comments.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class EpgExceptionHandleResolver implements HandlerExceptionResolver {
    protected final Log logger = EpgLogFactory.getSystemLogger();

    /*
     * (non-Javadoc)
     * 
     * @see org.springframework.web.servlet.HandlerExceptionResolver#resolveException(javax.servlet.http.HttpServletRequest,
     *      javax.servlet.http.HttpServletResponse, java.lang.Object,
     *      java.lang.Exception)
     */
    public ModelAndView resolveException(HttpServletRequest req,
            HttpServletResponse res, Object handler, Exception ex) {
        ModelAndView mv = null;
        mv = new ModelAndView("/common/base/epgError");
        EpgUserSession eus = (EpgUserSession) EpgUserSession
                .getUserSession(req);

        String errorCode = null;
        if (ex instanceof EpgRuntimeException) {
            EpgRuntimeException ere = (EpgRuntimeException) ex;
            errorCode = ere.getErrorCode();
        } else {
            errorCode = EpgLogGenerator.SYSTEM_ERROR_CODE;
        }

        mv.addObject("errorCode", errorCode);
        logger.error(ex.getMessage(), ex);

        // record access error log
        if(!(ex instanceof BoException)){
	        if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
	            EpgLogFactory.getErrorLogger().info(
	                    EpgLogGenerator.createAccessErrorLog(eus, errorCode, req
	                            .getRequestURI()));
	        }
        }
        return mv;
    }
}
