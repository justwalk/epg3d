/**
 * create with 2013-9-12 / 下午11:09:52
 */
package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.content.EpgDetailProgram;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.user.EpgUserHistory;
import sitv.epg.entity.user.EpgUserHistoryNum;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

/**
 * @author <a href="mailto:shenxw@chances.com.cn">shenxw</a>
 */
@Repository
public class HistoryService extends EpgBaseDao {

	@Autowired
    protected BaseDaoiBatis masterDao;
    private static final int DEFAULTNUM = 20;

    public boolean limitHistory(EpgUserHistory userHistory) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userHistory.getUserId());
        try {
            EpgUserHistoryNum euhn = (EpgUserHistoryNum) baseDao
                    .getSqlMapClientTemplate().queryForObject("getHistoryNum",
                            paramMap);
            int num = EpgConfigUtils.getInstance().getIntValue(
                    EpgConfigUtils.USERHISTORY_LIMITSIZE_NUM, DEFAULTNUM);
            if (euhn.getNum() >= num) {
                return false;
            } else {
                return true;
            }
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist history ,user id:"
                            + userHistory.getUserId() + "; content code:"
                            + userHistory.getContentCode(), dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }

    }

    public void addUserHistory(EpgUserHistory userHistory) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userHistory.getUserId());
        paramMap.put("CONTENT_NAME", userHistory.getContentName());
        paramMap.put("CONTENT_TYPE", userHistory.getContentType());
        paramMap.put("CONTENT_CODE", userHistory.getContentCode());
        paramMap.put("SERIES_CODE", userHistory.getSeriesCode());
        paramMap.put("BIZ_CODE", userHistory.getBizCode());
        paramMap.put("CATEGORY_CODE", userHistory.getCategoryCode());
        paramMap.put("CREATE_TIME", userHistory.getCreateTime());

        try {
        	masterDao.getSqlMapClientTemplate().insert("addUserHistory",
                    paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting history into database ,user id:"
                            + userHistory.getUserId() + "; content code:"
                            + userHistory.getContentCode() + "\r\n"
                            + dae.getMessage(), dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }
    }

    public void delUserHistoryById(EpgUserHistory userHistory) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userHistory.getUserId());
        try {
        	masterDao.getSqlMapClientTemplate().delete(
                    "delUserHistoryById", paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when delete history from database ",
                    dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }
    }

    public void delUserHistoryByUserId(String userId) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userId);
        try {
        	masterDao.getSqlMapClientTemplate().delete("delUserHistoryByUserId",
                    paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when delete all history from database ",
                    dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }
    }

    public boolean existHistory(EpgUserHistory userHistory) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userHistory.getUserId());
        paramMap.put("CONTENT_CODE", userHistory.getContentCode());
        paramMap.put("SERIES_CODE", userHistory.getSeriesCode());
        try {
            String queryName = "";
            if (userHistory.getContentType().equals("vod")) {
                queryName = "findUserHistoryByContentCode";
            } else {
                queryName = "findUserHistoryBySeriesCode";
            }
            EpgUserHistory euh = (EpgUserHistory) baseDao
                    .getSqlMapClientTemplate().queryForObject(queryName,
                            paramMap);
            if (euh != null) {
                return true;
            } else {
                return false;
            }
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist history ,user id:"
                            + userHistory.getUserId() + "; content code:"
                            + userHistory.getContentCode(), dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }
    }

    public void updateUserHistory(EpgUserHistory userHistory) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userHistory.getUserId());
        paramMap.put("CONTENT_NAME", userHistory.getContentName());
        paramMap.put("CONTENT_CODE", userHistory.getContentCode());
        paramMap.put("SERIES_CODE", userHistory.getSeriesCode());
        paramMap.put("CREATE_TIME", userHistory.getCreateTime());
        paramMap.put("BIZ_CODE", userHistory.getBizCode());
        paramMap.put("CATEGORY_CODE", userHistory.getCategoryCode());
        try {
            String queryName = "";
            if (userHistory.getContentType().equals("vod")) {
                queryName = "updateHistory";
            } else {
                queryName = "updateHistoryByseriesCode";
            }
            masterDao.getSqlMapClientTemplate().update(queryName,
                    paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when update history ,user id:"
                            + userHistory.getUserId() + "; content code:"
                            + userHistory.getContentCode(), dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }

    }

    public String getProgramName(EpgUserHistory userHistory, String episodeIndex) {
        String contentCode = "";
        String contentName = "";
        Map<String, Object> paramMap = new HashMap<String, Object>();
        try {
            if (userHistory.getContentType().equals("vod")) {
                contentCode = userHistory.getContentCode();
                paramMap.put("contentCode", contentCode);
                EpgDetailProgram vodProgram = (EpgDetailProgram) baseDao
                        .getSqlMapClientTemplate().queryForObject(
                                "queryProgramDetailByCode", paramMap);
                contentName = vodProgram.getTitle();
            } else {
                contentCode = userHistory.getSeriesCode();
                paramMap.put("contentCode", contentCode);
                EpgSeries seriesProgram = (EpgSeries) baseDao
                        .getSqlMapClientTemplate().queryForObject(
                                "querySeriesByCode", paramMap);
                contentName = seriesProgram.getTitle() + " 第(" + episodeIndex
                        + ")集";
            }
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when find program , content code:"
                            + userHistory.getContentCode(), dae);
        } finally {
            paramMap.clear();
            paramMap = null;
        }
        return contentName;
    }
}
