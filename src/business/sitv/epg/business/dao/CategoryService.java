package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import chances.epg.exception.DaoException;

import sitv.epg.entity.edit.EpgCategory;
/**
 * 分类数据访问
 * @author zhangxs
 *
 */
@Repository
public class CategoryService extends EpgBaseDao {

	public EpgCategory getCategoryById(String id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("categroyId", id);
		try {
			EpgCategory epgCategory = (EpgCategory) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getCategoryById", params);
			return epgCategory;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching category by id "
							+ id, dae);
		}finally{
			params.clear();
			params = null;
		}
	}

	public EpgCategory getCategoryByCode(String code) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("categoryCode", code);
		try {
			EpgCategory epgCategory = (EpgCategory) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getCategoryByCode", params);
			return epgCategory;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching business by code "
							+ code, dae);
		}finally{
			params.clear();
			params = null;
		}

	}

}
