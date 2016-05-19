package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.business.user.UserIdCreator;
import sitv.epg.entity.user.EpgSubscriber;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

@Repository("epgSubscriberService")
public class EpgSubscriberService extends EpgBaseDao{
    @Autowired
    protected BaseDaoiBatis masterDao;
	
//	@Autowired
//	private UserIdCreator userIdCreator;
	
	public EpgSubscriber getSubscriberByAccount(String userAccount) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userAccount", userAccount);
		try {
			EpgSubscriber epgUser = (EpgSubscriber) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getSubscriberByAccount", params);
			return epgUser;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching subscriber by account "
							+ userAccount, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	public EpgSubscriber getSubscriberByMacAddress(String macAddress) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("macAddress", macAddress);
		try {
			EpgSubscriber epgUser = (EpgSubscriber) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getSubscriberByMacAddress", params);
			return epgUser;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching subscriber by macAddress "
							+ macAddress, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	public List<EpgSubscriber> getSubscriberByOSSUserId(String ossUserId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ossUserId", ossUserId);
		try {
			List<EpgSubscriber> epgUsers =  baseDao
					.getSqlMapClientTemplate().queryForList(
							"getSubscriberByOSSUserId", params);
			return epgUsers;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced  when searching subscribers by ossUserId "
							+ ossUserId, dae);
		}finally{
			params.clear();
			params = null;
		}
	}
	
	
	public Long saveSubscriber(EpgSubscriber epgUser) {
	    //新增时判断是否已存在
	    EpgSubscriber subscriber = this.getSubscriberByMacAddressFromMaster(epgUser.getMacAddress());
	    if(subscriber != null) {
	        epgUser.setUserAccount(subscriber.getUserAccount());
	        return subscriber.getId();
	    }
	    
//	    if (epgUser.getUserAccount()==null){
//            epgUser.setUserAccount(userIdCreator.createId(epgUser.getMacAddress()));
//        }
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("USER_ACCOUNT", epgUser.getUserAccount());
        paramMap.put("MAC_ADDRESS", epgUser.getMacAddress());
        paramMap.put("OSS_USER_ID", epgUser.getOssUserId());
        paramMap.put("USER_NAME", epgUser.getUserName());
        paramMap.put("ADDRESS", epgUser.getAddress());
        paramMap.put("ZIP_CODE", epgUser.getZipCode());
        paramMap.put("PHONE_NUMBER", epgUser.getPhoneNumber());
        paramMap.put("EMAIL", epgUser.getEmail());
        paramMap.put("USER_GROUP", epgUser.getGroup());
        paramMap.put("EXPLORE_NAME", epgUser.getExploreName());
        paramMap.put("EXPLORE_VERSION", epgUser.getExploreVersion());
        paramMap.put("NETWORK_ID", epgUser.getNetworkId());
        paramMap.put("STB_MODEL", epgUser.getStbModel());
        paramMap.put("STB_TYPE", epgUser.getStbType());
        paramMap.put("RTSPD", epgUser.getRtspd());
        paramMap.put("PROTOCOL_TYPE", epgUser.getProtocolType());
        
        try {
            Long id = (Long) this.masterDao.getSqlMapClientTemplate().insert(
                    "saveSubscriber", paramMap);
            return id;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced when inserting epg subscriber into database ,user mac:"
                            + epgUser.getMacAddress() + "; userId:"+epgUser.getUserAccount() +"   "+dae.getMessage(), dae);
        }finally{
            paramMap.clear();
            paramMap = null;
        }
	}
	
	private EpgSubscriber getSubscriberByMacAddressFromMaster(String macAddress) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("macAddress", macAddress);
        try {
            EpgSubscriber epgUser = (EpgSubscriber) this.masterDao
                    .getSqlMapClientTemplate().queryForObject(
                            "getSubscriberByMacAddress", params);
            return epgUser;
        } catch (DataAccessException dae) {
            throw new DaoException(
                    "An exception produced  when searching subscriber by macAddress "
                            + macAddress, dae);
        }finally{
            params.clear();
            params = null;
        }
    }

}
