package sitv.epg.business.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;

import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

import java.util.Map;


/**
 * 数据访问基类
 * @author zhangxs
 *
 */
public class EpgBaseDao {
	
	@Autowired
	protected BaseDaoiBatis baseDao;

	public BaseDaoiBatis getBaseDao() {
		return baseDao;
	}

	public void setBaseDao(BaseDaoiBatis baseDao) {
		this.baseDao = baseDao;
	}
	
	public int getTotalCount(String queryName, Map<String, Object> paramMap) {
		
		try {
			return (int) baseDao.getObjectTotal(queryName, paramMap);
			//totalCount = 0;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when count total count:"
							+ queryName, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}

	}
}

