package sitv.epg.nav.url;

import org.apache.commons.lang.StringUtils;

import sitv.epg.config.EpgConfigUtils;

public class ResourceHelper {
	 public static final String DEFAULT_RESOURCE_ROOT = "resource";
		
	  public static String getResourceRoot(){
	        String resourceRoot = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.RESOURCE_ROOT);
	        if(StringUtils.isBlank(resourceRoot)){
	        	resourceRoot = DEFAULT_RESOURCE_ROOT;
	        }
	        
	        return resourceRoot;
	    }
}
