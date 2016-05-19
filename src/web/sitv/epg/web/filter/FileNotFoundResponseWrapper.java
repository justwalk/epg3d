/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.web.filter;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

/**
 * Class comments.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class FileNotFoundResponseWrapper extends
        HttpServletResponseWrapper {
    private int statusCode;

    /**
     * @param response
     */
    public FileNotFoundResponseWrapper(HttpServletResponse response) {
        super(response);
        this.statusCode = HttpServletResponse.SC_OK;  //默认的状态是200
    }

    @Override
    public void sendError(int sc) throws IOException {
        if(sc == HttpServletResponse.SC_NOT_FOUND){
            statusCode = sc;
        }else{
            super.sendError(sc);
        }
    }

    @Override
    public void sendError(int sc, String msg) throws IOException {
        if(sc == HttpServletResponse.SC_NOT_FOUND){
            statusCode = sc;
        }else{
            super.sendError(sc, msg);
        }
    }

    @Override
    public void setStatus(int sc) {
        if(sc == HttpServletResponse.SC_NOT_FOUND){
            statusCode = sc;
        }else{
            super.setStatus(sc);
        }
    }

    public int getStatusCode() {
        return this.statusCode;
    }
}
