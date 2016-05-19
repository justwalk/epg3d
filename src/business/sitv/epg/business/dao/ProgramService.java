package sitv.epg.business.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.content.SearchEpgProgram;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.edit.EpgCategoryItem;
import chances.epg.exception.DaoException;

/**
 * 节目数据访问类
 * 
 * @author chenjie
 *
 */
@Repository
public class ProgramService extends EpgBaseDao {
	@SuppressWarnings("unchecked")
	public EpgProgram getProgramByContentCode(String contentCode) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contentCode", contentCode);
		try {
			EpgProgram ep = (EpgProgram) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"queryProgramDetailByCode", params);
			return ep;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching program by contentCode "
							+ contentCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	@SuppressWarnings("unchecked")
    public List<SearchEpgProgram> getProgramByKeyword(String keyword,int startRow,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("initals", keyword);
        try {
            return baseDao.getSqlMapClientTemplate().queryForList("queryProgramDetailByInitals", params,startRow, maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching program by keyword " + keyword, dae);
        }finally{
            params.clear();
            params = null;
        }
    }
	@SuppressWarnings("unchecked")
    public EpgSeries getSeriesByContentCode(String contentCode) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("contentCode", contentCode);
        try {
            return (EpgSeries) baseDao.getSqlMapClientTemplate().queryForObject("querySeriesByCode", params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching program by contentCode "
							+ contentCode, dae);
        }finally{
            params.clear();
            params = null;
        }
    }
}
