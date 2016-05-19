/*
 * Created on 2012-9-4
 * 版权所有 上海成思信息科技有限公司
 *
 * $HeadURL$:
 */
package sitv.epg.entity.customer;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import sitv.epg.common.util.CodeUtils;

/**
 * Class comments.
 * 
 * @author <a href="mailto:shenwl@chances.com.cn">shenwl</a>
 * @version 1.0
 */

public class EpgCustomer implements Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = -1717487116600542524L;

    public static final int STATUS_DELETED = -1;
    public static final int STATUS_EFFECT = 1;

    private Long id;
    private Integer gendar; // 女：1 | 男 ：2
    private String code;
    private String accountId;
    private Date birthday;
    private String phoneNumber;
    private String icon;
    private String bigIcon;
    private int status;
    private Date createTime;
    private Date updateTime;

    private String birthdayString;

    private String reserve1;
    private String reserve2;
    private String reserve3;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getGendar() {
        return gendar;
    }

    public void setGendar(Integer gendar) {
        this.gendar = gendar;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getReserve1() {
        return reserve1;
    }

    public void setReserve1(String reserve1) {
        this.reserve1 = reserve1;
    }

    public String getReserve2() {
        return reserve2;
    }

    public void setReserve2(String reserve2) {
        this.reserve2 = reserve2;
    }

    public String getReserve3() {
        return reserve3;
    }

    public void setReserve3(String reserve3) {
        this.reserve3 = reserve3;
    }

    public String getCode() {
        if (this.code == null) {
            this.code = CodeUtils.generate(this);
        }
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getBigIcon() {
        return bigIcon;
    }

    public void setBigIcon(String bigIcon) {
        this.bigIcon = bigIcon;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getBirthdayString() {
        return birthdayString;
    }

    public void setBirthdayString(String birthdayString) throws Exception {

        if (birthdayString != null && !birthdayString.equals("") ) {

            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
                    "yyyy-MM-dd");
            this.birthday = simpleDateFormat.parse(birthdayString);

        }

        this.birthdayString = birthdayString;
    }

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public static int getSTATUS_DELETED() {
        return STATUS_DELETED;
    }

    public static int getSTATUS_EFFECT() {
        return STATUS_EFFECT;
    }

}
