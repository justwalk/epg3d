package sitv.epg.zhangjiagang.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.EpgLogGenerator;
import sitv.epg.business.user.EpgSubscriberFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.EpgUserSessionFactory;
import sitv.epg.zhangjiagang.bo.BoClient;
import sitv.epg.zhangjiagang.bo.BoException;
import sitv.epg.zhangjiagang.bo.UserData;
import sitv.epg.zhangjiagang.http.request.LoginRequest;
import sitv.epg.zhangjiagang.http.response.LoginResponse;
import sitv.epg.entity.user.EpgSubscriber;


/**
 * Class comments.
 * 
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
@Repository("loginService")
public class LoginService {
	
    @Autowired
    private BoClient boClient;

    /**
     * 登录.
     * 
     * @param portalId
     *            Portal对应的ID
     * @param deviceId
     *            终端设备机身序列号
     * @param client
     *            智能卡号
     * @param userType
     *            用户类型：老人型，儿童型
     * @param params
     *            登录参数
     * @return
     * @throws Exception 
     */
    public boolean login(HttpServletRequest request, String portalId, String deviceId,
            String client, String userType, Map<String, String> params) throws Exception {
        if (EpgLogFactory.getSystemLogger().isDebugEnabled()) {
            EpgLogFactory.getSystemLogger().debug(
            		"portalId=" + portalId + ",deviceId=" + deviceId
                            + ",client=" + client);
        }

        EpgUserSession userSession = null;
        
        LoginRequest loginRequest = new LoginRequest();
        loginRequest.setPortalId(portalId);
        //loginRequest.setDeviceId(deviceId);
        loginRequest.setClient(client);
        loginRequest.setUserType(userType);

        try {
        	//LoginResponse loginResponse = this.boClient.login(loginRequest);
        	UserData userData = new UserData();
        	userData.setPortalId(portalId);
        	//userData.setAccount(loginResponse.getAccount());
        	userData.setClient(client);
        	userData.setDeviceId(deviceId);
        	//userData.setFrequence(loginResponse.getZoneFreqInfo().getFrequency());
        	//userData.setQamMode(loginResponse.getZoneFreqInfo().getQamMode());
        	//userData.setSymbolRate(loginResponse.getZoneFreqInfo().getSymbolRate());
        	
            userSession = EpgUserSessionFactory.createEpgUserSession(userData, params);
            // 保存登录日志
            logLogon(userSession);

            // 检查并创建用户
            this.setSubscriber(userSession);

            request.getSession().setAttribute(EpgUserSession.USER_SESSION_NAME,
                    userSession);
            return true;
        } catch (BoException ex) {
            EpgLogFactory.getSystemLogger().error("Login failed.", ex);

            // 记录错误日志
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createLoginErrorLog(deviceId,
                        		client, ex.getErrorCode()));
            }
            return false;
        }
    }

    /**
     * 记录登录日志.
     * 
     * @param userSession
     */
    private void logLogon(EpgUserSession userSession) {
        if (EpgLogFactory.getLogonLogger().isInfoEnabled()) {
            StringBuffer sb = new StringBuffer(StringUtils.isBlank(userSession.getSmcId()) ? "" : userSession.getSmcId()).append("|")
                    .append(StringUtils.isBlank(userSession.getStbMac()) ? "" : userSession.getStbMac()).append("|").append(
                    		StringUtils.isBlank(userSession.getNetIp()) ? "" : userSession.getNetIp()).append("|")
                    .append(StringUtils.isBlank(userSession.getStbType()) ? "" : userSession.getStbType()).append("|")
                    .append(StringUtils.isBlank(userSession.getStbModel()) ? "" : userSession.getStbModel()).append("|")
                    .append(StringUtils.isBlank(userSession.getUsergroup()) ? "" : userSession.getUsergroup()).append("|")
                    .append(StringUtils.isBlank(userSession.getEpgGroup()) ? "" : userSession.getEpgGroup()).append("|")
                    .append(StringUtils.isBlank(userSession.getUserData().getAccount()) ? "" : userSession.getUserData().getAccount())
                    .append("|").append(StringUtils.isBlank(userSession.getEntry()) ? "" : userSession.getEntry())
                    .append("|").append(StringUtils.isBlank(userSession.getStbType()) ? "" : userSession.getStbType());

            EpgLogFactory.getLogonLogger().info(sb.toString());
        }
    }

    private void setSubscriber(EpgUserSession userSession) {
        /*
         * //查询订户 EpgSubscriber subscriber =
         * epgSubscriberService.getSubscriberByMacAddress(eus.getStbMac());
         * 
         * //判断订户是否存在 if (subscriber == null){ //不存在则创建订户 save subscriber;
         * subscriber = EpgSubscriberFactory.createEpgSubscriber(eus); //保存订户
         * epgSubscriberService.saveSubscriber(subscriber); }
         * 
         * //将订户信息放在userSession中 eus.setEpgSubscriber(subscriber);
         */
        EpgSubscriber subscriber = EpgSubscriberFactory.createEpgSubscriber(userSession);
        userSession.setEpgSubscriber(subscriber);
    }

    /**
     * @param boClient
     *            the boClient to set
     */
    public void setBoClient(BoClient boClient) {
        this.boClient = boClient;
    }

    public static void main(String[] args) {
        String account = "4004652259(1)";

        System.out.println(account.replace("(", "").replace(")", ""));
    }
}
