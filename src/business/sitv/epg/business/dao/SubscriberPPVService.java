package sitv.epg.business.dao;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.entity.user.EpgSubscriber;
import sitv.epg.entity.user.EpgSubscriberPPV;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

@Repository
public class SubscriberPPVService extends EpgBaseDao {
    @Autowired
    protected BaseDaoiBatis masterDao;
    
	public boolean hasSubscriberPPVByMacAddress(String macAddress,EpgContentOffering content){
		Map<String, Object> params = new HashMap<String, Object>();
    	params.put("macAddress", macAddress);
    	params.put("contentCode", content.getContentCode());
    	params.put("offeringId", content.getOfferingId());
    	try{
			 List list = baseDao.getSqlMapClientTemplate().queryForList("getEpgSubscriberPPVByMac",params);
			 if (list == null || list.isEmpty()){
				 return false;
			 }else{
				 return true;
			 }
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching EPG_SUBSCRIBER_PPV by userId,contentCode,offeringId "
							+ macAddress + "|" + content.getContentCode() + "|" + content.getOfferingId(), dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	public boolean hasSubscriberPPVByUserAccount(String userAccount,EpgContentOffering content){
	    Map<String, Object> params = new HashMap<String, Object>();
        params.put("userAccount", userAccount);
        params.put("contentCode", content.getContentCode());
        params.put("offeringId", content.getOfferingId());
        params.put("nowDate", new Date());
        try{
             List list = baseDao.getSqlMapClientTemplate().queryForList("getEpgSubscriberPPVByUserAccount",params);
             if (list == null || list.isEmpty()){
                 return false;
             }else{
                 return true;
             }
        }catch(DataAccessException dae){
            throw new DaoException(
                    "An exception produced  when searching EPG_SUBSCRIBER_PPV by userId,contentCode,offeringId "
                            + userAccount + "|" + content.getContentCode() + "|" + content.getOfferingId(), dae);
        }finally{
            params.clear();
            params = null;
        }
	}
	
	public boolean hasSubscriberPPVByOssUserId(String ossUserId,EpgContentOffering content){
		return false;
	}
	
	public void saveSubscriberPPV(EpgSubscriber epgSubscriber,
			EpgPlayableContent content,EpgContentOffering contentOffering,
			EpgBusiness biz,EpgCategory category){
	    /*
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("USER_ACCOUNT", epgSubscriber.getUserAccount());
		paramMap.put("USER_MAC", epgSubscriber.getMacAddress());
		if (biz!=null){
			paramMap.put("BIZ_CODE", biz.getCode());
		}else{
			paramMap.put("BIZ_CODE",null);
		}
		if (category!=null){
			paramMap.put("CATEGORY_CODE", category.getCode());
			paramMap.put("CATEGORY_NAME", category.getTitle());
		}else{
			paramMap.put("CATEGORY_CODE", null);
			paramMap.put("CATEGORY_NAME", null);
		}
		paramMap.put("PROGRAM_CODE", content.getContentCode());
		paramMap.put("PROGRAM_TITLE", content.getTitle());
		paramMap.put("OFFERINGID", content.getOfferingId());
		paramMap.put("SERVICENAME", content.getServiceName());
		paramMap.put("SERVICECODE", content.getServiceCode());
		paramMap.put("SERVICETYPE", content.getServiceType());
		paramMap.put("PRICE", contentOffering.getPrice());
		Date orderTime = new Date();
		Calendar cal = Calendar.getInstance();
		
	    //String duration = content.getMaximumViewingLength();
		int duration = contentOffering.getRentalDuration();
		
	    if (duration == 0){
	    	duration = EpgConfigUtils.getInstance().getIntValue(EpgConfigUtils.DEFAULT_PPV_ORDER_LENGTH, 240);
	    	cal.add(Calendar.HOUR_OF_DAY, duration);
	    }else{
	    	cal.add(Calendar.HOUR_OF_DAY, duration);
	    }
		
		paramMap.put("ORDER_TIME", orderTime);
		paramMap.put("VALID_TIME", orderTime);
		paramMap.put("EXPIRE_TIME", cal.getTime());
		paramMap.put("PROGRAM_TYPE", content.getProgramType());
		paramMap.put("PROTOCOL_TYPE", epgSubscriber.getProtocolType());
		paramMap.put("FILE_NAME", content.getFileName());
		try{
			baseDao.getSqlMapClientTemplate().insert("addSubscriberPpv", paramMap);
		}catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when inserting SubscriberPpv into database ,user mac:"
							 + "\r\n"+dae.getMessage(), dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
		*/
	    
	    Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ACCOUNT", epgSubscriber.getUserAccount());
        paramMap.put("USER_MAC", epgSubscriber.getMacAddress());
        if (biz!=null){
            paramMap.put("BIZ_CODE", biz.getCode());
        }else{
            paramMap.put("BIZ_CODE",null);
        }
        if (category!=null){
            paramMap.put("CATEGORY_CODE", category.getCode());
            paramMap.put("CATEGORY_NAME", category.getTitle());
        }else{
            paramMap.put("CATEGORY_CODE", null);
            paramMap.put("CATEGORY_NAME", null);
        }
        paramMap.put("PROGRAM_CODE", content.getContentCode());
        paramMap.put("PROGRAM_TITLE", content.getTitle());
        paramMap.put("OFFERINGID", content.getOfferingId());
        paramMap.put("SERVICENAME", content.getServiceName());
        paramMap.put("SERVICECODE", content.getServiceCode());
        paramMap.put("SERVICETYPE", content.getServiceType());
        paramMap.put("PRICE", contentOffering.getPrice());
        Date orderTime = new Date();
        Calendar cal = Calendar.getInstance();
        
        int duration = contentOffering.getRentalDuration();
        
        if (duration == 0){
            duration = EpgConfigUtils.getInstance().getIntValue(EpgConfigUtils.DEFAULT_PPV_ORDER_LENGTH, 240);
            cal.add(Calendar.HOUR_OF_DAY, duration);
        }else{
            cal.add(Calendar.HOUR_OF_DAY, duration);
        }
        
        paramMap.put("ORDER_TIME", orderTime);
        paramMap.put("VALID_TIME", orderTime);
        paramMap.put("EXPIRE_TIME", cal.getTime());
        paramMap.put("PROGRAM_TYPE", content.getProgramType());
        paramMap.put("PROTOCOL_TYPE", epgSubscriber.getProtocolType());
        paramMap.put("FILE_NAME", content.getFileName());
        try{
            this.masterDao.getSqlMapClientTemplate().insert("addSubscriberPpv", paramMap);
        }catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting SubscriberPpv into database ,user mac:"
                             + "\r\n"+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	public List getSubscriberPPVByUserAssets(String stbMac,String files){
		Map<String, Object> params = new HashMap<String, Object>();
    	params.put("stbMac", stbMac);
    	params.put("fileNames", files);
    	try{
    		List<EpgSubscriberPPV> results =baseDao.getSqlMapClientTemplate().queryForList("getSubscriberPPVByUserAssets",params);
    		return results;
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching EPG_SUBSCRIBER_PPV by stbMac:"+stbMac+" files:"+files, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	public EpgSubscriberPPV getSubscriberPPVByMacAddressAndOfferingId(String macAddress,String fileName,String RentalTime,String rentalExpireTime) {
		
		//String OfferId = Long.toString(OfferingId);
		Map<String, Object> params = new HashMap<String, Object>();
    	params.put("macAddress", macAddress);
    	params.put("fileName", fileName);
    	params.put("RentalTime", RentalTime);
    	params.put("rentalExpireTime", rentalExpireTime);
    	
    	try{
    		EpgSubscriberPPV epgSubscriberPPV =(EpgSubscriberPPV)baseDao.getSqlMapClientTemplate().queryForList("getSubscriberPPVByMacAddressAndOfferingId",params).get(0);
    		return epgSubscriberPPV;
		}catch(DataAccessException dae){
			throw new DaoException(
					"An exception produced  when searching EPG_SUBSCRIBER_PPV by userId,offeringId "
							+ macAddress +  "|" + fileName, dae);
		}finally{
			params.clear();
			params = null;
		}
	}

    /**
     * @param masterDao the masterDao to set
     */
    public void setMasterDao(BaseDaoiBatis masterDao) {
        this.masterDao = masterDao;
    }
}
