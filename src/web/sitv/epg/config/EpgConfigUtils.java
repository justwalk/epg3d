/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.config;

import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import sitv.epg.business.EpgLogFactory;
import chances.epg.exception.InvalidConfigException;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class EpgConfigUtils {
    public static final String DIRECT_PLAYVOD = "navigator.vod.play.directly.otherwise.use.default.page";
    public static final String TEMPLATE_ROOT = "navigator.template.root.path";
    public static final String RESOURCE_ROOT = "resource.root.path";
    public static final String REMEMBER_PLAYFOCUS_USESESSION = "remember.play.focus.using.session";
    public static final String ADD_FIX_PARAMS="add.fix.params";
    
    public static final String AD_SERVICE_URL = "ad.service.url"; 
    public static final String AD_SERVICE_TIMEOUT = "ad.service.timeout";
    
    public static final String MYRENTAL_SERVICE_URL = "myrental.service.url"; 
    public static final String MYRENTAL_SERVICE_TIMEOUT = "myrental.service.timeout";
    
    public static final String MYRENTALSL_SERVICE_URL = "myrentalsl.service.url"; 
    public static final String MYRENTALSL_SERVICE_TIMEOUT = "myrentalsl.service.timeout";
    
    public static final String ADTH_HEAD_FLAG = "adth.head.flag";
    public static final String MYCOLLECTION_LIMITSIZE_NUM ="mycollection.limitsize.num";
    public static final String MYVOTE_LIMITSIZE_NUM ="myvote.limitsize.num";
    public static final String MYBOOKMARK_LIMITSIZE_NUM ="mybookmark.limitsize.num";
   
    public static final String NEED_AUTH_SERVICE_TYPE = "vod.need.auth.service.type";
    
    public static final String NOT_NEED_AUTH_SERVICE_TYPE = "vod.default.service.type";
    
    public static final String DEFAULT_PPV_ORDER_LENGTH = "default.ppv.order.length";
    
    public static final String IGNORE_MYRENTAL = "ingore.myrental";
    
    public static final String LOGIN_URL = "login.url";
    public static final String AUTH_URL = "auth.url";
    public static final String SELECTION_URL = "selection.url";
    public static final String GETOFFER_URL = "getoffer.url";
    public static final String USERHISTORY_LIMITSIZE_NUM = "userhistory.limitsize.num";
    private static EpgConfigUtils instance;
    private Properties params;
    private static Log logger = EpgLogFactory.getSystemLogger();
    
    protected EpgConfigUtils() {
        params = new Properties();
    }
    
    public static EpgConfigUtils getInstance() {
        if(instance == null){
            instance = new EpgConfigUtils();
        }
        
        return instance;
    }
    
    
    /**
     * 获取参数.
     */
    public String getProperty(String key) {
        if(this.params.containsKey(key)){
            return this.params.getProperty(key); 
        }else{
            if(logger.isDebugEnabled()){
                logger.debug("Parameter [" + key + "] not exist.");   
            }
            return "";
        }
        
    }
    
    public boolean getBooleanValue(String key){
    	 String boolValue = EpgConfigUtils.getInstance().getProperty(
    			 key);
         if (StringUtils.isBlank(boolValue)) {
             return true;
         }

         return Boolean.valueOf(boolValue).booleanValue();
    }
    
    
    public int getIntValue(String key,int defaultValue){
    	 String intValue = EpgConfigUtils.getInstance().getProperty(
    			 key);
         if (StringUtils.isBlank(intValue)) {
             return defaultValue;
         }
         try{
        	 int result = Integer.parseInt(intValue);
        	 return result;
		}catch(Exception e){
			throw new InvalidConfigException(intValue+ " should be integer value,invalid config key:"+key);
		}
    }
    
    /**
     * 获取所有的参数.
     * @return
     */
    public Properties getProperties() {
        return this.params;
    }
    
    /**
     * 设置参数.
     * @param props
     */
    public void addAll(Properties props) {
        this.params.putAll(props);
    }
}
