package sitv.epg.nav.url;

import org.apache.commons.lang.StringUtils;

import sitv.epg.config.EpgConfigUtils;

public class TemplateHelper {
	
	 public static final String DEFAULT_TEMPLATE_ROOT = "template";
	
	  public static String getTemplateRoot(){
	        String templateRoot = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.TEMPLATE_ROOT);
	        if(StringUtils.isBlank(templateRoot)){
	            templateRoot = DEFAULT_TEMPLATE_ROOT;
	        }
	        
	        return templateRoot;
	    }
}
