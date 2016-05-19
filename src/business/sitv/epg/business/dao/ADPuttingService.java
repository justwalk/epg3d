package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.entity.business.EpgADPutting;
import chances.epg.exception.DaoException;
/**
 *  栏目广告投放
 * @author zhangxs
 *
 */
@Repository
public class ADPuttingService extends EpgBaseDao {
	private static Log logger = EpgLogFactory.getSystemLogger();
	/**
	 * 查询栏目是否投放广告
	 * @param categoryCode
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public EpgADPutting getCategoryAdPutting(String categoryCode){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("catCode", categoryCode);
		List<EpgADPutting> list = null;
		try {
			 list = baseDao.getSqlMapClientTemplate().queryForList(
							"getADPuttingByCode", params);
			 
			 if (list == null || list.size() == 0) return null;
			 
			 EpgADPutting eap = list.get(0);
			 
			 if (logger.isDebugEnabled()){
				 logger.debug(" The category "+categoryCode+"  should play ad or not:"+eap.isPutting()+" property:"+eap.getProperty());
			 }
			 return eap;
			 
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching adputting by categoryCode "
							+ categoryCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
}
