package sitv.epg.zhangjiagang.service;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.bo.BoClient;
import sitv.epg.zhangjiagang.bo.UserData;
import sitv.epg.zhangjiagang.http.request.AuthRequest;
import sitv.epg.zhangjiagang.http.request.GetUpsellOfferRequest;
import sitv.epg.zhangjiagang.http.request.SelectionRequest;
import sitv.epg.zhangjiagang.http.response.AuthResponse;
import sitv.epg.zhangjiagang.http.response.GetUpsellOfferResponse;
import sitv.epg.zhangjiagang.http.response.StartResponse;
import sitv.epg.entity.content.EpgContentOffering;

/**
 * Class comments.
 *
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
@Repository
public class AuthenticateService {
    private static Log logger = EpgLogFactory.getSystemLogger();
    public static final String SUCCESS = "11000";
    public static final String LANG_CN_TYPE = "zh_CN";
    
    @Autowired
    private BoClient boClient;
    
    /**
     * 业务鉴权.
     * @param request
     * @param serviceCode,Offering的serviceCode
     * @param serviceType,Offering的serviceType
     * @return
     * @throws Exception 
     */
    public boolean auth(HttpServletRequest request,EpgContentOffering offering) throws Exception {
    	EpgUserSession userSession = (EpgUserSession)EpgUserSession.getUserSession(request);
        if(userSession == null) {
            logger.error("Auth failed,user not login.");
            throw new AuthenticateException("User not login.",AuthenticateException.NOT_LOGIN);
        }
        
        String serviceType = offering.getServiceType();
        String offeringId = offering.getOfferingId();
        String serviceCode = offering.getServiceCode();
        //String serviceId = offering.getServiceId();
        
        //SVOD
        if("SVOD".equals(serviceType)){
            return this.authSVOD(userSession.getUserData(), offeringId, serviceCode);
        //MOD
        }else if("MOD".equals(serviceType)){
        	return this.authMOD(userSession.getUserData(), offeringId, serviceCode);
        //FVOD
        }else if("FVOD".equals(serviceType)){
        	logger.error("Not support service type:" + serviceType + ",offeringId=" + offeringId);
            throw new AuthenticateException("Not support service type.",AuthenticateException.NOT_SUPPORT_SERVICE_TYPE);
        }else{
            logger.error("Not support service type:" + serviceType + ",offeringId=" + offeringId);
            throw new AuthenticateException("Not support service type.",AuthenticateException.NOT_SUPPORT_SERVICE_TYPE);
        }
    }
    
    /**
     * 按次内容鉴权
     * @param userdata
     * @param offeringId
     * @param serviceCode
     * @return
     * @throws Exception
     */
    private boolean authMOD(UserData userdata,String offeringId,String serviceCode) throws Exception  {
    	return authSVOD(userdata, offeringId, serviceCode);
	}
    
    /**
     * 包月内容鉴权.
     * @param userdata
     * @param offeringId
     * @return
     * @throws Exception 
     */
    private boolean authSVOD(UserData userdata,String offeringId,String serviceCode) throws Exception  {
    	AuthRequest authRequest = new AuthRequest();
    	authRequest.setPortalId(userdata.getPortalId());
    	authRequest.setClient(userdata.getClient());
    	authRequest.setAccount(userdata.getAccount());
    	authRequest.setAssetId(offeringId);
    	authRequest.setServiceId(serviceCode);
    	
    	AuthResponse authResponse = this.boClient.auth(authRequest);
    	
    	if("Y".equals(authResponse.getOrderFlag())){
    		return true;
    	}else{
    		return false;
    	}
	}
    
    /**
     * 获取产品信息
     * @param userdata
     * @param serviceCode
     * @return
     * @throws Exception
     */
    public GetUpsellOfferResponse getUpsellOffer(UserData userdata, String serviceCode) throws Exception {
    	GetUpsellOfferRequest guoRes = new GetUpsellOfferRequest();
    	guoRes.setPortalId(userdata.getPortalId());
    	guoRes.setAccount(userdata.getAccount());
    	guoRes.setClient(userdata.getClient());
    	guoRes.setServiceId(serviceCode);
    	
    	return this.boClient.getOffer(guoRes);
    }
    
    /**
     * selection接口作为订购使用，同洲会在bo完成实时订购生成账单
     * @param userdata
     * @param offeringId
     * @param serviceCode
     * @return
     * @throws Exception
     */
    public StartResponse order(UserData userdata,String offeringId,String serviceCode) throws Exception {
    	return this.getRtspUrl(userdata, offeringId, serviceCode);
    }
    
    /**
     * selection接口获取rtsp播放串
     * @param userdata
     * @param offeringId
     * @param serviceCode
     * @return
     * @throws Exception
     */
    public StartResponse getRtspUrl(UserData userdata,String offeringId,String serviceCode) throws Exception {
    	SelectionRequest selectionRequest = new SelectionRequest();
		selectionRequest.setPortalId(userdata.getPortalId());
		selectionRequest.setClient(userdata.getClient());
        selectionRequest.setFolderAssetId("00000000000000050147");
		selectionRequest.setAccount(userdata.getAccount());
		selectionRequest.setTitleAssetId(offeringId);
		selectionRequest.setServiceId(serviceCode);
		
		return this.boClient.selection(selectionRequest);
    }

    /**
     * @param boClient the boClient to set
     */
    public void setBoClient(BoClient boClient) {
        this.boClient = boClient;
    }
}

