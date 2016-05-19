package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.business.EpgBusiness;
import chances.epg.exception.DaoException;

/**
 * 看吧数据访问类
 * 
 * @author zhangxs
 * 
 */
@Repository
public class BusinessService extends EpgBaseDao {

	public EpgBusiness getBusinessByCode(String code) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bizCode", code);
		try {
			EpgBusiness epgBusiness = (EpgBusiness) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getBusinessByCode", params);
			return epgBusiness;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching business by code "
							+ code, dae);
		}finally{
			params.clear();
			params = null;
		}
	}

	public EpgBusiness getBusinessById(String id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bizId", id);
		try {
			EpgBusiness epgBusiness = (EpgBusiness) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getBusinessById", params);
			return epgBusiness;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching business by id "
							+ id, dae);
		}finally{
			params.clear();
			params = null;
		}
	}

}
