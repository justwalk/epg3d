/**
 * create with 2014-3-24 / 下午04:21:32
 */
package sitv.epg.entity.user;

import java.io.Serializable;
import java.util.Date;

/**
 * @author <a href="mailto:shenxw@chances.com.cn">shenxw</a>
 */
public class EpgUserHistory implements Serializable {

    /**
     * create with 2014-3-24 / 下午04:22:07
     */
    private static final long serialVersionUID = -7286414514956206146L;
    private Long id;
    private String userId;
    private String contentName;
    private String contentType;
    private String contentCode;
    private String seriesCode;
    private Date createTime;
    private String bizCode; // 片子所在的看吧
    private String categoryCode; // 片子所在的栏目

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getContentName() {
        return contentName;
    }

    public void setContentName(String contentName) {
        this.contentName = contentName;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getContentCode() {
        return contentCode;
    }

    public void setContentCode(String contentCode) {
        this.contentCode = contentCode;
    }

    public String getSeriesCode() {
        return seriesCode;
    }

    public void setSeriesCode(String seriesCode) {
        this.seriesCode = seriesCode;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getBizCode() {
        return bizCode;
    }

    public void setBizCode(String bizCode) {
        this.bizCode = bizCode;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }
}
