/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.business;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
public class ContextFactoryHelper implements ApplicationContextAware{
    private static ApplicationContext context ;
    
    /* (non-Javadoc)
     * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
     */
    public void setApplicationContext(ApplicationContext applicationContext)
            throws BeansException {
        ContextFactoryHelper.context = applicationContext;
    }
    
    
    public static Object getBean(String beanName) {
        return context.getBean(beanName);
    }
}
