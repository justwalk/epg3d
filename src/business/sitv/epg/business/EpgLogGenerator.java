/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.business;

import org.apache.commons.lang.StringUtils;

import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.bo.Ticket;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.edit.EpgCategory;

/**
 * Class comments.
 * 
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class EpgLogGenerator {
    private static final String SEPRATOR = "|";
    public static final String SYSTEM_ERROR_CODE = "0000";
    public static final String LOGIN_OP = "login";
    public static final String ACCESS_OP = "access";
    public static final String AUTH_OP = "auth";
    public static final String ORDER_OP = "order";
    public static final String PLAY_OP = "play";
    

    public static String createLoginErrorLog(String macAddress, String account,
            String errorCode) {
        StringBuffer error = new StringBuffer();
        error.append(macAddress).append(SEPRATOR);
        error.append(account).append(SEPRATOR);
        error.append(LOGIN_OP).append(SEPRATOR);
        error.append(errorCode).append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        return error.toString();
    }

    public static String createAccessErrorLog(EpgUserSession userSession,String errorCode,String uri) {
        StringBuffer error = new StringBuffer();
        if(userSession != null && userSession.getUserData() != null) {
            error.append(userSession.getStbMac()).append(SEPRATOR);
            error.append(userSession.getUserAccount()).append(SEPRATOR);
        }else{
            error.append(SEPRATOR);
            error.append(SEPRATOR);
        }
        error.append(ACCESS_OP).append(SEPRATOR);
        error.append(errorCode).append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        error.append(uri);
        return error.toString();
    }

    public static String createAuthErrorLog(EpgUserSession userSession,
            String bizCode, String categoryCode, EpgContentOffering offering,String errorCode) {
        return createErrorLog(AUTH_OP,userSession, bizCode, categoryCode, offering, errorCode);
    }

    public static String createOrderErrorLog(EpgUserSession userSession,
            EpgBusiness biz, EpgCategory category, EpgContentOffering offering,String errorCode) {
        String bizCode = null;
        String categoryCode = null;
        if(biz != null) {
            bizCode = biz.getCode();
        }
        
        if(category != null) {
            categoryCode = category.getCode();
        }
        
        return createErrorLog(ORDER_OP,userSession, bizCode, categoryCode, offering, errorCode);
    }

    private static String createErrorLog(String opType,EpgUserSession userSession,
            String bizCode, String categoryCode, EpgContentOffering offering,String errorCode) {
        StringBuffer error = new StringBuffer();
        if(userSession != null && userSession.getUserData() != null) {
            error.append(userSession.getStbMac()).append(SEPRATOR);
            error.append(userSession.getUserAccount()).append(SEPRATOR);
        }else{
            error.append(SEPRATOR);
            error.append(SEPRATOR);
        }
        
        error.append(opType).append(SEPRATOR);
        if(StringUtils.isNotBlank(errorCode)) {
            error.append(errorCode).append(SEPRATOR);
        }else{
            error.append(SYSTEM_ERROR_CODE).append(SEPRATOR);
        }
        
        if(bizCode != null) {
            error.append(bizCode).append(SEPRATOR);
        }else{
            error.append(SEPRATOR);
        }
        
        if(categoryCode != null) {
            error.append(categoryCode).append(SEPRATOR);
        }else{
            error.append(SEPRATOR);
        }
        
        if(offering != null) {
            error.append(offering.getContentCode()).append(SEPRATOR);
            error.append(offering.getOfferingId()).append(SEPRATOR);
            error.append(offering.getServiceName()).append(SEPRATOR);
            error.append(offering.getServiceCode()).append(SEPRATOR);
        }else{
            error.append(SEPRATOR);
            error.append(SEPRATOR);
            error.append(SEPRATOR);
            error.append(SEPRATOR);
        }
        error.append(SEPRATOR);
        error.append(SEPRATOR);
        return error.toString();
    }
    
    public static String createAuthLog(EpgUserSession userSession,
            String bizCode, String categoryCode, EpgContentOffering offering,String contentType) {
      //鉴权时间|mac|userId|看吧编码|栏目编码|内容类型|内容编码|播放标识|服务编码|服务类型|订购类型|订购生效时间|订购失效时间
        StringBuffer info = new StringBuffer();
        if(userSession != null && userSession.getUserData() != null) {
            info.append(userSession.getStbMac()).append(SEPRATOR);
            info.append(userSession.getUserAccount()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
            info.append(SEPRATOR);
        }
        
        if(bizCode != null) {
            info.append(bizCode).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(categoryCode != null) {
            info.append(categoryCode).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(contentType != null) {
            info.append(contentType).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(offering != null) {
            info.append(offering.getContentCode()).append(SEPRATOR);
            info.append(offering.getOfferingId()).append(SEPRATOR);
            info.append(offering.getServiceCode()).append(SEPRATOR);
            info.append(offering.getServiceName()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
        }
        
        info.append(SEPRATOR);
        info.append(SEPRATOR);
        info.append(SEPRATOR);
        info.append(SEPRATOR);
        
        return info.toString();
    }
    
    
    public static String createOrderLog(EpgUserSession userSession,
            EpgBusiness biz, EpgCategory category, EpgContentOffering offering,String contentType,Ticket ticket) {
      //鉴权时间|mac|userId|看吧编码|栏目编码|内容类型|内容编码|播放标识|服务编码|服务类型|订购类型|订购生效时间|订购失效时间
        StringBuffer info = new StringBuffer();
        if(userSession != null && userSession.getUserData() != null) {
            info.append(userSession.getStbMac()).append(SEPRATOR);
            info.append(userSession.getUserAccount()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
            info.append(SEPRATOR);
        }
        
        if(biz != null) {
            info.append(biz.getCode()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(category != null) {
            info.append(category.getCode()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(contentType != null) {
            info.append(contentType).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
        }
        
        if(offering != null) {
            info.append(offering.getContentCode()).append(SEPRATOR);
            info.append(offering.getOfferingId()).append(SEPRATOR);
            info.append(offering.getServiceCode()).append(SEPRATOR);
            info.append(offering.getServiceName()).append(SEPRATOR);
        }else{
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
        }
        
        if(ticket != null) {
            info.append(ticket.getOrderType()).append(SEPRATOR);
            info.append(ticket.getValidTime()).append(SEPRATOR);
            info.append(ticket.getExpireTime()).append(SEPRATOR);
            info.append(ticket.getPrice()).append(SEPRATOR);
            info.append(ticket.getPurchaseTime());
        }else{
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
            info.append(SEPRATOR);
        }
        
        return info.toString();
    }
    
}
