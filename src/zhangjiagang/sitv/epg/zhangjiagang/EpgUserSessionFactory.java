package sitv.epg.zhangjiagang;

import java.util.Map;

import sitv.epg.zhangjiagang.bo.UserData;

/**
 * Class comments.
 *
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
public class EpgUserSessionFactory {
    public static EpgUserSession createEpgUserSession(UserData userData, Map<String,String> params){
        EpgUserSession userSession = new EpgUserSession();
        userSession.setUserData(userData);
        userSession.setUserId(userData.getAccount());
        userSession.setStbMac(userData.getDeviceId());
        userSession.setSmcId(userData.getClient());
        
        String vmType = params.get("vmType");
        if (vmType == null){
            vmType = "csdv";
        }
        
        userSession.setVmType(vmType);
        
        String stbType = params.get("stbType");
        if (stbType == null){
            stbType = "hd";
        }
        userSession.setStbType(stbType);
        
        String sdhd1 = params.get("entry");
        if (sdhd1 == null){
            sdhd1 = "hdvod"; 
        }
        userSession.setEntry(sdhd1);
        return userSession;
    }
}
