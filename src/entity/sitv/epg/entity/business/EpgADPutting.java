/*
 * Copyright (c) 2010 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.entity.business;

import java.io.Serializable;


/**
 * 广告投放.
 * 
 * @author <a href="mailto:zhangxb@chances.com.cn">zhangxb</a>
 */
public class EpgADPutting implements Serializable {

    private static final long serialVersionUID = 8744043164210624882L;

    private Long id;

    private Long categoryId;

    private String categoryCode;
    
    private boolean putting;
    
    private String property;

    /**
     */
    public EpgADPutting() {
    }

   
    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the categoryId
     */
    public Long getCategoryId() {
        return categoryId;
    }

    /**
     * @param categoryId
     *            the categoryId to set
     */
    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    /**
     * @return the categoryCode
     */
    public String getCategoryCode() {
        return categoryCode;
    }

    /**
     * @param categoryCode
     *            the categoryCode to set
     */
    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    /**
     * @return the putting
     */
    public boolean isPutting() {
        return putting;
    }

    /**
     * @param putting
     *            the putting to set
     */
    public void setPutting(boolean putting) {
        this.putting = putting;
    }


	public String getProperty() {
		return property;
	}


	public void setProperty(String property) {
		this.property = property;
	}

}
