package sitv.epg.business.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.user.EpgMarkNum;
import sitv.epg.entity.user.EpgUserBookmark;

import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;
/**
 * 书签数据访问
 * @author wangkai
 *
 */
@Repository
public class BookmarkService extends EpgBaseDao {
	@Autowired
    protected BaseDaoiBatis masterDao;
    
	private  static final int defaultNum = 64;
	
	/*
	public boolean existBookmark(EpgUserBookmark userBookmark) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userBookmark.getMacAddr());
        paramMap.put("CONTENT_CODE", userBookmark.getContentCode());
        try {
        	EpgUserBookmark eub = (EpgUserBookmark) this.masterDao
                    .getSqlMapClientTemplate().queryForObject(
                            "userCouldMark", paramMap);
            if (eub == null)
                return false;
            return true;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist Bookmark ,user id:"
                            + userBookmark.getMacAddr() + "; content code:"
                            + userBookmark.getContentCode(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	*/
	private boolean limitBookmark(EpgUserBookmark userBookmark) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userBookmark.getMacAddr());
        try {
            EpgMarkNum en = (EpgMarkNum)this.masterDao
                    .getSqlMapClientTemplate().queryForObject(
                            "getMarkNum", paramMap);
            int num = EpgConfigUtils.getInstance().getIntValue(EpgConfigUtils.MYBOOKMARK_LIMITSIZE_NUM, defaultNum);
            if (en.getNum()>=num)
                return false;
            return true;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist Bookmark ,user id:"
                            + userBookmark.getMacAddr() + "; content code:"
                            + userBookmark.getContentCode(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	public EpgUserBookmark getBookmark(String userId,String contentCode) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userId);
        paramMap.put("CONTENT_CODE", contentCode);
        try {
            return (EpgUserBookmark) this.masterDao.getSqlMapClientTemplate().queryForObject("userCouldMark", paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when searching whether exist Bookmark ,user id:"
                            + userId + "; content code:"
                            + contentCode, dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
    }
	
	private Long insertBookmark(EpgUserBookmark userBookmark) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ID", userBookmark.getMacAddr());
        paramMap.put("CONTENT_TYPE", userBookmark.getContentType());
        paramMap.put("CONTENT_NAME", userBookmark.getContentName());
        paramMap.put("CONTENT_CODE", userBookmark.getContentCode());
        paramMap.put("CONTENT_ELAPSED", userBookmark.getContentElapsed());
        paramMap.put("BIZ_CODE", userBookmark.getBizCode());
        paramMap.put("CATEGORY_CODE", userBookmark.getCategoryCode());
        paramMap.put("MARK_TIME", new Date());
        try {
            Long id = (Long)masterDao.getSqlMapClientTemplate().insert(
                    "addUserBookmark", paramMap);
            userBookmark.setId(id);
            return id;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting Bookmark into database ,user id:"
                            + userBookmark.getMacAddr() + "; content code:"
                            + userBookmark.getContentCode()+"\r\n"+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	private void updateBookmark(EpgUserBookmark oldBookmark,EpgUserBookmark newBookmark) {
	    Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("CONTENT_NAME", newBookmark.getContentName());
        paramMap.put("CONTENT_ELAPSED", newBookmark.getContentElapsed());
        paramMap.put("BIZ_CODE", newBookmark.getBizCode());
        paramMap.put("CATEGORY_CODE", newBookmark.getCategoryCode());
        paramMap.put("MARK_TIME", new Date());
        paramMap.put("ID", oldBookmark.getId());
        try {
            masterDao.getSqlMapClientTemplate().update("updateUserBookmark", paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting Bookmark into database ,user id:"
                            + newBookmark.getMacAddr() + "; content code:"
                            + newBookmark.getContentCode()+"\r\n"+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	public Long addBookmark(EpgUserBookmark userBookmark) {
	    EpgUserBookmark oldMark = this.getBookmark(userBookmark.getMacAddr(),userBookmark.getContentCode());
	    if(oldMark != null) {
	        this.updateBookmark(oldMark, userBookmark);
	        return  oldMark.getId();
	    }
	    
	    if(!this.limitBookmark(userBookmark)){
	        return new Long(-1);
	    }else{
	        return this.insertBookmark(userBookmark);
	    }
	}
	
	public int deleteBookmark(String bookmarkId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("ID", bookmarkId);
        try {
            return this.masterDao.getSqlMapClientTemplate().delete(
                    "delUserBookmarkById", paramMap);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when deleting a bookmark ,bookmark id:"
                            + bookmarkId, dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	public EpgUserBookmark getEpgUserBookmark(String bookmarkId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ID", bookmarkId);
		try {
			EpgUserBookmark eub = (EpgUserBookmark) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getBookmarkById", paramMap);
			return eub;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching a bookmark ,bookmark id:"
							+ bookmarkId, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<EpgUserBookmark> getEpgUserBookmarks(String userId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userId);
		try {
			return baseDao.getSqlMapClient().queryForList("getSevrialBookmarkByUserId", paramMap);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching bookmark list,user id:"
							+ userId, dae);
		} catch (SQLException ex) {
			throw new DaoException("An exception produced when searching bookmark list by user id " + userId, ex);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<EpgUserBookmark> getEpgUserBookmarks(String userId,int startRow,int maxRow) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userId);
		try {
			return baseDao.getSqlMapClient().queryForList("getSevrialBookmarkByUserId", paramMap, startRow, maxRow);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching bookmark list,user id:"
							+ userId, dae);
		} catch (SQLException ex) {
			throw new DaoException("An exception produced when searching bookmark list by user id " + userId, ex);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	public int getEpgUserBookmarkTotal(String userId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ID", userId);
		try {
			return (int) baseDao.getObjectTotal("getSevrialBookmarkByUserId", paramMap);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching collection list,user id:"
							+ userId, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}

    /**
     * @param masterDao the masterDao to set
     */
    public void setMasterDao(BaseDaoiBatis masterDao) {
        this.masterDao = masterDao;
    }
}
