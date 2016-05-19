package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.content.SearchEpgProgram;
import chances.epg.exception.DaoException;

/**
 * 剧集数据访问类
 * 
 * @author cc
 *
 */
@Repository
public class EpisodeService extends EpgBaseDao {
	@SuppressWarnings("unchecked")
	
	public EpgEpisode getEpisodeByContentCode(String contentCode) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contentCode", contentCode);
		try {
			EpgEpisode ee = (EpgEpisode) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"querySeriesCodeByEpisodeCode", params);
			return ee;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching episode by contentCode "
							+ contentCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<EpgEpisode> getEpisodeByCode(String seriesCode) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("seriesCode", seriesCode);
		try {
			List<EpgEpisode> eeList =  (List<EpgEpisode>) baseDao
					.getSqlMapClientTemplate().queryForList(
							"queryEpisodeByCode", params);
			return eeList;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when getEpisodeByCode episode by seriesCode "
							+ seriesCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	@SuppressWarnings("unchecked")
	public List<EpgEpisode> getEpisodeListByEpisodeContentCode(String contentCode) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contentCode", contentCode);
		try {
			List<EpgEpisode> eeList =  (List<EpgEpisode>) baseDao
					.getSqlMapClientTemplate().queryForList(
							"queryEpisodeListByEpisodeContentCode", params);
			return eeList;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when getEpisodeListByEpisodeContentCode by contentCode "
							+ contentCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
}
