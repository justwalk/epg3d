package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.user.EpgUserSeriesmark;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

/**
 * 剧集集数信息访问
 * @author wangkai
 *
 */
@Repository
public class SeriesmarkService extends EpgBaseDao {
	@Autowired
    protected BaseDaoiBatis masterDao;
	
	@SuppressWarnings("unchecked")
	public EpgUserSeriesmark getSeriesmark(String userId,String contentCode) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userId);
        paramMap.put("CONTENT_CODE", contentCode);
        try {
        	List<EpgUserSeriesmark> eusm = this.masterDao.getSqlMapClientTemplate().queryForList("userCouldMarkSeries", paramMap);
        	if(!eusm.isEmpty()) {
        		return eusm.get(0);
        	}else {
        		return null;
        	}
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist Seriesmark ,user id:"
                            + userId + "; content code:"
                            + contentCode, dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
    }
	
	private Long insertSeriesmark(EpgUserSeriesmark userSeriesmark) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userSeriesmark.getUserId());
        paramMap.put("CONTENT_CODE", userSeriesmark.getContentCode());
        paramMap.put("EPISODE_INDEX", userSeriesmark.getEpisodeIndex());
        try {
            Long id = (Long)masterDao.getSqlMapClientTemplate().insert(
                    "addUserSeriesmark", paramMap);
            userSeriesmark.setId(id);
            return id;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting Seriesmark into database ,user id:"
                            + userSeriesmark.getUserId() + "; content code:"
                            + userSeriesmark.getContentCode()+"\r\n"+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	private void updateSeriesmark(EpgUserSeriesmark oldSeriesmark,EpgUserSeriesmark newSeriesmark) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("EPISODE_INDEX", newSeriesmark.getEpisodeIndex());
        paramMap.put("USER_ID", newSeriesmark.getUserId());
        paramMap.put("CONTENT_CODE", newSeriesmark.getContentCode());
        try {
            masterDao.getSqlMapClientTemplate().update("updateUserSeriesmark", paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when updating Seriesmark into database ,user id:"
                            + newSeriesmark.getUserId() + "; content code:"
                            + newSeriesmark.getContentCode()+"\r\n"+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	public Long addSeriesmark(EpgUserSeriesmark userSeriesmark) {
		EpgUserSeriesmark oldMark = this.getSeriesmark(userSeriesmark.getUserId(),userSeriesmark.getContentCode());
	    if(oldMark != null) {
	        this.updateSeriesmark(oldMark, userSeriesmark);
	        return  oldMark.getId();
	    }else{
	        return this.insertSeriesmark(userSeriesmark);
	    }
	}
}
