package sitv.epg.business.dao;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgHostProFile;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgLiveChannel;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.entity.edit.EpgCategoryItem;
import chances.epg.exception.DaoException;
import chances.epg.exception.InvalidConfigException;
import chances.epg.exception.InvalidDataException;

@Repository
public class PlayerService extends EpgBaseDao {
	
	private static Log logger = EpgLogFactory.getSystemLogger();
	
	public static final String PROGRAM = "PROGRAM";
	public static final String PARAMS = "PARAMS";	
	public static final String OFFERING = "OFFERING";
	

    /**
     * 获取可播放内容.
     * 
     * 根据给定的ServiceType，对Program的多个Offering进行过滤.
     * @param serviceType
     * @param contentCode
     * @return  若根据指定的ServiceType找不到相应的Offering则返回null
     */
	public EpgPlayableContent getPlayableContent(String serviceType,String contentCode) {
		if(serviceType.indexOf(",") >= 0){
			String[] serviceTypeArray = serviceType.split(",");
			serviceType = serviceTypeArray[0];
		}
		Map<String , Object> params = new HashMap<String , Object>();
		params.put("serviceType", serviceType);
		params.put("contentCode", contentCode);
		try{
			EpgPlayableContent epc = (EpgPlayableContent) baseDao.getSqlMapClientTemplate().queryForObject("queryPlayableProgramCodeByServiceTypeAndContentCode",params);
			return epc;
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player content by serviceType and contentCode:"
							+ serviceType + "," + contentCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	/**
     * 获取可播放内容.
     * 
     * 根据给定的SeriesCode,EpisodeIndex查询播放信息
     * @param seriesCode
     * @param episodeIndex
     * @return  若找不到则返回null
     */
	public EpgPlayableContent searchPlayableProgramBySeriesCodeAndEpisodeIndex(String seriesCode,int episodeIndex) {

		Map<String , Object> params = new HashMap<String , Object>();
		params.put("seriesCode", seriesCode);
		params.put("episodeIndex", episodeIndex);
		try{
			EpgPlayableContent epc = (EpgPlayableContent) baseDao.getSqlMapClientTemplate().queryForObject("queryPlayableProgramCodeBySeriesCodeAndEpisodeIndex",params);
			return epc;
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player content by seriesCode and episodeIndex:"
							+ seriesCode + "," + episodeIndex, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	private String  getHostName() {
		try {
			String hostName = InetAddress.getLocalHost().getHostName();
			if (logger.isDebugEnabled()){
				logger.debug("host name is "+hostName);
			}
			return hostName;
		} catch (UnknownHostException e) {
			throw new InvalidConfigException("host name has not been configed properly.",e);
		}
	}
	
	public List<EpgHostProFile> getPlayerParams() {
		//查找主机播放参数,首先根据主机编码查询,如果没有设置则从主机名查询		
		String hostCode = EpgConfigUtils.getInstance().getProperty("host.code");
		List<EpgHostProFile> playParams = Collections.EMPTY_LIST;
		if (StringUtils.isBlank(hostCode)){
			String hostName = getHostName();
			 playParams = searchPlayParamByHostName(hostName);
		}else{
			 playParams = searchPlayParamByHostCode(hostCode);
		}
		if (playParams == null || playParams.size() == 0){
			throw new InvalidConfigException("play params has not been set!");
		}
		return playParams;
	}
	
	public Map<String,String> parseParams(List<EpgHostProFile> playParams) {
		
		Map<String,String> params = new HashMap<String,String> ();
		EpgHostProFile ehpf = null;
		for(int i=0;playParams!=null && i<playParams.size();i++){
			ehpf = playParams.get(i);
			if (logger.isDebugEnabled()){
				logger.debug("play param:"+ehpf.getName()+":"+ehpf.getValue()+" status:"+ehpf.getStatus());
			}
			params.put(ehpf.getName(), ehpf.getValue());
			
		}
		return params;
	}
	
	public EpgPlayableContent searchContentByOfferingId (String offeringId){
		Map<String , Object> params = new HashMap<String , Object>();
		params.put("offeringId", offeringId);
		try{
			 List list = baseDao.getSqlMapClientTemplate().queryForList("queryPlayableProgramCodeByOfferingId",params);
			 if (list == null || list.size() == 0){
				 throw new  InvalidDataException("invalid offering id:"+offeringId);
			 }
			 return (EpgPlayableContent) list.get(0);
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player content by offeringId "
							+ offeringId, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
    
	public EpgPlayableContent searchContentByContentCode(String contentCode){
		//String regionCode = EpgConfigUtils.getInstance().getProperty("region.code");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contentCode", contentCode); 
		try{
			 List<EpgPlayableContent> list = baseDao.getSqlMapClientTemplate().queryForList("queryPlayableProgramCode",params);
			 if (list == null || list.size() == 0){
				 throw new  InvalidDataException("invalid content code:"+contentCode);
			 }
			 EpgPlayableContent epc = (EpgPlayableContent) list.get(0);
			 
			 List<EpgContentOffering> list1 = baseDao.getSqlMapClientTemplate().queryForList("getContentOffering", params);
			 
			 if(list1 == null || list1.size() == 0){
			     throw new  InvalidDataException("content not found offerings,invalid content code:"+contentCode);
			 }
			 epc.setEpgContentOfferings(list1);
			 
			 return epc;
			 
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player content by contentCode "
							+ contentCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	@SuppressWarnings("unchecked")
	public List<EpgHostProFile> searchPlayParamByHostName(String hostName){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("hostName", hostName); 
		try{
			return baseDao.getSqlMapClientTemplate().queryForList("getPlayerParamByHostName",params);
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player param by hostname "
							+ hostName, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<EpgHostProFile> searchPlayParamByHostCode(String hostCode){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("hostCode", hostCode); 
		try{
			return baseDao.getSqlMapClientTemplate().queryForList("getPlayerParamByHostCode",params);
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching player param by hostcode "
							+ hostCode, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public EpgCategory searchFirstCategoryByItemCode(String contentCode,String contentType){
		Map<String, Object> params = new HashMap<String, Object>();
		String code = contentCode;
		//如果是剧集单集,则查询其父剧集是否有编排而不是单集是否有编排
		if (EpgCategoryItem.ITEMTYPE_EPISODE.equals(contentType)){
			code = searchSeriesCodeByEpisodeCode(contentCode);
		}
		params.clear();
		params.put("itemCode", code); 
		List<EpgCategoryItem> list = Collections.EMPTY_LIST;
		try{
			list = baseDao.getSqlMapClientTemplate().queryForList("getFirstCategoryByItemCode",params);
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching category item by contentCode "
							+ contentCode, dae);
		}finally{
			params.clear();	
		}
		if (list == null || list.size() == 0) return null;
		
		String categoryCode = list.get(0).getCategoryCode();
		params.put("categoryCode", categoryCode); 
		try{
			return (EpgCategory) baseDao.getSqlMapClientTemplate().queryForObject("getCategoryByCode", params);
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching category by categoryCode "
							+ categoryCode, dae);
		}finally{
			params.clear();
			params = null;
		}
		
	}


	@SuppressWarnings("unchecked")
	public String searchSeriesCodeByEpisodeCode(String contentCode){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contentCode", contentCode);
		List<EpgEpisode> episodes = null;
		try{
			episodes =  baseDao.getSqlMapClientTemplate().queryForList("querySeriesCodeByEpisodeCode",params);
		}catch(DataAccessException e){
			throw new DaoException(
					"An exception produced  when searching episode by episodeCode "
							+ contentCode, e);
		}finally{
			params.clear();
			params = null;
		}
		if (episodes!=null && episodes.size()!=0){
			return episodes.get(0).getSeriesCode();
		}
		return null;
	}
	
	public EpgLiveChannel getChannleByCode(String channelCode) {
	    Map<String , Object> params = new HashMap<String , Object>();
        params.put("channelCode", channelCode);
        try{
            EpgLiveChannel epc = (EpgLiveChannel) baseDao.getSqlMapClientTemplate().queryForObject("getChannleByCode",params);
            return epc;
        }catch(DataAccessException dae){
            throw new DaoException(
                    "An exception produced  when searching channel by contentCode:" + channelCode, dae);
        }finally{
            params.clear();
            params = null;
        }
	}
	
	@SuppressWarnings("unchecked")
	public EpgEpisode searchContentCodeBySeriesCodeAndEpisodeIndex(String seriesCode,int episodeIndex){
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("seriesCode", seriesCode);
		params.put("episodeIndex", episodeIndex);
		try{
			return (EpgEpisode) baseDao.getSqlMapClientTemplate().queryForObject("queryContentCodeBySeriesCodeAndEpisodeIndex",params);
		}catch(DataAccessException e){
			throw new DaoException(
					"An exception produced  when searching episode by seriesCode and episodeIndex"
							+ seriesCode + "," + episodeIndex , e);
		}finally{
			params.clear();
			params = null;
		}
	}
}
