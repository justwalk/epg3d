/*
 * Created on 2012-9-4
 * 版权所有 上海成思信息科技有限公司
 *
 * $HeadURL$:
 */
package sitv.epg.business.dao;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import chances.epg.exception.DaoException;

import sitv.epg.entity.customer.EpgCustomer;

/**
 * Class comments.
 * 
 * @author <a href="mailto:shenwl@chances.com.cn">shenwl</a>
 * @version 1.0
 */

@Service("customerService")
@Transactional("master")
public class CustomerService {
    @Autowired
    @Qualifier("customerDao")
    private CustomerDao customerDao;

    public void saveOrupdate(EpgCustomer epgCustomer, String accountId) {

        try {
            // 配置属性(新增)
            if (epgCustomer.getId() == null || epgCustomer.getId().equals("")) {
                epgCustomer.setAccountId(accountId);
                epgCustomer.setCreateTime(new Date());
                epgCustomer.setStatus(EpgCustomer.STATUS_EFFECT);
                // 保存属性
                customerDao.save(epgCustomer);
            }

            // 配置属性(修改)
            if (epgCustomer.getId() != null && !epgCustomer.getId().equals("")) {
                epgCustomer.setUpdateTime(new Date());
                // 保存属性
                customerDao.update(epgCustomer);
            }
        } catch (RuntimeException e) {
            throw new DaoException("An exception produced ;method:"
                    + "CustomerService.saveOrupdate()" + ";USER_MAC:'"
                    + accountId + "'", e);

        }

    }

    public CustomerDao getCustomerDao() {
        return customerDao;
    }

    public void setCustomerDao(CustomerDao customerDao) {
        this.customerDao = customerDao;
    }
}
