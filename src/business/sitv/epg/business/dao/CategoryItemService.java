/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.business.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.edit.EpgCategoryItemWithPic;
import chances.epg.exception.DaoException;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
@Repository
public class CategoryItemService extends EpgBaseDao {
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItem> getCategoryItems(String categoryCode) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemsByPage",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItem> getCategoryItems(String categoryCode,int startRow,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemsByPage", params,startRow, maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItem> getRandomCategoryItems(String categoryCode,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getSeverialItemsByRandom",params,0,maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    /**
     * 获取栏目编排记录
     * @param itemCode
     * @return 
     */
    @SuppressWarnings("unchecked")
	public List<EpgCategoryItem> getCategoryItemsByItemCode(String itemCode){
    	Map<String, Object> params = new HashMap<String, Object>();
        params.put("itemCode", itemCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getCategoryItemsByItemCode",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItems by itemCode " + itemCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItems by itemCode " + itemCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getCategoryItemsWithPoster(String categoryCode) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemsIncludePicByPage",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    /**
     * 获取栏目编排带专辑海报 20140326 wangkai
     * @param categoryCode
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getCategoryItemsWithSubjectPic(String categoryCode) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getSeverialItemsWithSubjectPic",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getMovieByIndex(String categoryCode,int idx) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        idx--;
        params.put("idx", idx);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemsByIndex",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getMovieListByIndex(String categoryCode,int idx,int count) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        idx--;
        params.put("idx", idx);
        params.put("count", count);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemListByIndex",params);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getCategoryItemsWithPoster(String categoryCode,int startRow,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getItemsIncludePicByPage",params,startRow,maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    /**
     * 获取栏目编排带专辑海报 20140326 wangkai
     * @param categoryCode
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getCategoryItemsWithSubjectPic(String categoryCode,int startRow,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        try {
            return baseDao.getSqlMapClient().queryForList("getSeverialItemsWithSubjectPic",params,startRow,maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
    
    @SuppressWarnings("unchecked")
    public List<EpgCategoryItemWithPic> getRandomCategoryItemsByTypeWithPoster(String categoryCode,String itemType,int maxRow) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("categoryCode", categoryCode);
        params.put("contentType", itemType);
        try {
            return baseDao.getSqlMapClient().queryForList("getSeverialItemsByRandomByContentType",params,0,maxRow);
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching categoryItem by code " + categoryCode, dae);
        } catch (SQLException ex) {
            throw new DaoException("An exception produced  when searching categoryItem by code " + categoryCode, ex);
        }finally{
            params.clear();
            params = null;
        }
    }
}
