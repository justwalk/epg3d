package sitv.epg.zhangjiagang.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.user.EpgSubscriberFactory;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.zhangjiagang.EpgUserSessionFactory;
import sitv.epg.zhangjiagang.bo.UserData;
import sitv.epg.entity.user.EpgSubscriber;


/**
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 *
 */
@Repository("mockLoginService")
public class MockLoginService extends LoginService {
    /**
     * 登录.
     * @param account    用户帐号
     * @param passwd     登录密码
     * @param clientType 客户端类型
     * @param params     登录参数
     * @return
     */
    public boolean login(HttpServletRequest request,String account,String macAddress,String passwd,int clientType,Map<String,String> params) {
        if(EpgLogFactory.getSystemLogger().isDebugEnabled()){
            EpgLogFactory.getSystemLogger().debug("account=" + account + ",macAddress=" + macAddress + ",clientType=" + clientType);
        }
        
        EpgUserSession userSession = null;
        //UserRemoteService service = (UserRemoteService)ContextFactory.getContext().getBean("userRemoteService");
        
        if(StringUtils.isNotBlank(account)){
            account = account.replace("(", "");
            account = account.replace(")", "");
        }
        

        UserData userData = new UserData();
        userData.setAccount(account);
        userData.setClient(account);
        userData.setDeviceId(account);
        userSession = EpgUserSessionFactory.createEpgUserSession(userData, params);
        //保存登录日志
        logLogon(userSession);
        
        //检查并创建用户
        this.setSubscriber(userSession);
        
        request.getSession().setAttribute(EpgUserSession.USER_SESSION_NAME, userSession);
        return true;
      
    }
    
    /**
     * 记录登录日志.
     * 
     * @param userSession
     */
    private void logLogon(EpgUserSession userSession) {
        if (EpgLogFactory.getLogonLogger().isInfoEnabled()) {
            StringBuffer sb = new StringBuffer(userSession.getUserId()).append(
                    "|").append(userSession.getSmcId()).append("|")
                    .append(userSession.getStbMac()).append("|").append(
                            userSession.getStbType()).append("|")
                    .append(userSession.getNetIp()).append("|")
                    .append(userSession.getStbModel()).append("|").append(
                            userSession.getUsergroup()).append("|").append(
                            userSession.getMobile()).append("|").append(
                            userSession.getEmail()).append("|").append(
                            userSession.getEpgGroup()).append("|").append(
                            userSession.getUsertoken());

            EpgLogFactory.getLogonLogger().info(sb.toString());
        }
    }
    
    private void setSubscriber(EpgUserSession userSession) {
    	/* //查询订户
        EpgSubscriber subscriber = epgSubscriberService.getSubscriberByMacAddress(eus.getStbMac());
        
        //判断订户是否存在
        if (subscriber == null){
            //不存在则创建订户 save subscriber;
            subscriber = EpgSubscriberFactory.createEpgSubscriber(eus);
            //保存订户
            epgSubscriberService.saveSubscriber(subscriber);
        }
        
        //将订户信息放在userSession中
        eus.setEpgSubscriber(subscriber);
        
        EpgSubscriber subscriber = EpgSubscriberFactory.createEpgSubscriber(eus);
        eus.setEpgSubscriber(subscriber);
        */
        EpgSubscriber subscriber = EpgSubscriberFactory.createEpgSubscriber(userSession);
        userSession.setEpgSubscriber(subscriber);
    }

    public static void main(String[] args){
        String account = "4004652259(1)";
        
        System.out.println(account.replace("(","").replace(")", ""));
    }
}
