/*
 * Created on 2012-9-4
 * 版权所有 上海成思信息科技有限公司
 *
 * $HeadURL$:
 */
package sitv.epg.business.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.customer.EpgCustomer;

import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * Class comments.
 * 
 * @author <a href="mailto:shenwl@chances.com.cn">shenwl</a>
 * @version 1.0
 */
@Repository("customerDao")
public class CustomerDao extends SqlMapClientDaoSupport {

    public void save(EpgCustomer epgCustomer) {
        SqlMapClientTemplate sqlMapClientTemplate = this
                .getSqlMapClientTemplate();

        sqlMapClientTemplate.insert("insertCustomer", epgCustomer);
    }

    public void update(EpgCustomer epgCustomer) {
        SqlMapClientTemplate sqlMapClientTemplate = this
                .getSqlMapClientTemplate();

        sqlMapClientTemplate.update("updateCustomer", epgCustomer);
    }

    @Autowired
    @Qualifier("masterSqlMapClient")
    public void insertSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSqlMapClient(sqlMapClient);
    }

}
