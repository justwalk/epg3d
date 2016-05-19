package sitv.epg.business.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.user.EpgCollectionNum;
import sitv.epg.entity.user.EpgUserCollection;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;
/**
 * 收藏数据访问
 * @author zhangxs
 *
 */
@Repository
public class CollectionService extends EpgBaseDao {
	@Autowired
    protected BaseDaoiBatis masterDao;
	
	private  static final int defaultNum = 64;
	
	public boolean existCollection(EpgUserCollection userCollection) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userCollection.getMacAddr());
		paramMap.put("CONTENT_CODE", userCollection.getContentCode());
		try {
			EpgUserCollection euc = (EpgUserCollection) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"userCouldCollect", paramMap);
			if (euc == null)
				return false;
			return true;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching whether exist collection ,user id:"
							+ userCollection.getMacAddr() + "; content code:"
							+ userCollection.getContentCode(), dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}

	public boolean limitCollection(EpgUserCollection userCollection) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userCollection.getMacAddr());
		try {
			EpgCollectionNum en = (EpgCollectionNum)baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getCollectionNum", paramMap);
			int num = EpgConfigUtils.getInstance().getIntValue(EpgConfigUtils.MYCOLLECTION_LIMITSIZE_NUM, defaultNum);
			if (en.getNum()>=num)
				return false;
			return true;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching whether exist collection ,user id:"
							+ userCollection.getMacAddr() + "; content code:"
							+ userCollection.getContentCode(), dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	public Long addCollection(EpgUserCollection userCollection) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userCollection.getMacAddr());
		paramMap.put("CONTENT_TYPE", userCollection.getContentType());
		paramMap.put("CONTENT_NAME", userCollection.getContentName());
		paramMap.put("CONTENT_CODE", userCollection.getContentCode());
		paramMap.put("BIZ_CODE", userCollection.getBizCode());
		paramMap.put("CATEGORY_CODE", userCollection.getCategoryCode());
		paramMap.put("COLLECT_TIME", new Date());
		paramMap.put("STILL", userCollection.getStill());
		try {
			Long id = (Long) masterDao.getSqlMapClientTemplate().insert(
					"addUserCollection", paramMap);
			userCollection.setId(id);
			return id;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when inserting collection into database ,user id:"
							+ userCollection.getMacAddr() + "; content code:"
							+ userCollection.getContentCode()+"\r\n"+dae.getMessage(), dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}

	public int delectCollection(String collectionId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ID", collectionId);
		try {
			return masterDao.getSqlMapClientTemplate().delete(
					"delUserCollectionByContentCode", paramMap);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when deleting a collection ,collection id:"
							+ collectionId, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}

	public EpgUserCollection getEpgUserCollection(String collectionId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ID", collectionId);
		try {
			EpgUserCollection euc = (EpgUserCollection) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getCollectionById", paramMap);
			return euc;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching a collection ,collection id:"
							+ collectionId, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}

	
	/**
     * 获取用户收藏的节目数据.
     * @paramMap userMac
     * @paramMap startRow
     * @paramMap maxRow
     * @return
     */
	@SuppressWarnings("unchecked")
	public List<EpgUserCollection> getCollection(String userMac,int startRow,int maxRow) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("user_id", userMac);
		try {
			return baseDao.getSqlMapClientTemplate().queryForList("getSevrialCollectionByUserId", paramMap,startRow, maxRow);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced :"
							+ userMac, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	
	
}
