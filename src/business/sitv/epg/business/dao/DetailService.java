/**
 * 
 */
package sitv.epg.business.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.edit.EpgCategory;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.content.EpgEpisode;
import chances.epg.exception.DaoException;
import chances.epg.exception.InvalidDataException;

/**
 * @chenjie
 *
 */
@Repository
public class DetailService extends EpgBaseDao {
	
	private static Log logger = EpgLogFactory.getSystemLogger();
	public static final String SVOD = "SVOD";
	
	String defaultServiceTypes = EpgConfigUtils.getInstance().getProperty(
            EpgConfigUtils.NOT_NEED_AUTH_SERVICE_TYPE);
	
	@Autowired
    private CategoryService categoryService;
	
	@Autowired
	private PlayerService playerService;
	
	/**
     * 判断是否符合混编状态.
     * 
     * @param categoryCode
     * @param itemType
     * @param itemCode
     * @return  
     */
	public boolean isNotMixed(String categoryCode,String itemType,String itemCode) {
		
		EpgCategory epgCategory = categoryService
        .getCategoryByCode(categoryCode);
		
		//如果栏目没有配ServiceType,则默认为SVOD
		String serviceTypeStr;
		if (null==epgCategory||StringUtils.isBlank(epgCategory.getServiceType())) {
			serviceTypeStr = SVOD;	
	    }else{
	    	serviceTypeStr = epgCategory.getServiceType();
	    }
            
		String[] serviceTypes = serviceTypeStr.split(",");
		
		//找出节目的content Offering
		List<EpgContentOffering> contentOfferings = getContentOfferings(itemType,itemCode);
		
		
		String serviceType = "";
		for (int i = 0; i < serviceTypes.length; i++) {
            serviceType = serviceTypes[i];            
            for (EpgContentOffering offering : contentOfferings) {
                if(serviceType.equals(offering.getServiceType())){
                    return true;
                }
            }
        }
		return false;
		
	}
	
	public String getDetailServiceType(String categoryCode,String itemType,String itemCode) {
	
		EpgCategory epgCategory = categoryService
        .getCategoryByCode(categoryCode);
		
		//如果栏目没有配ServiceType,则默认为SVOD
		String serviceTypeStr;
		if (null==epgCategory||StringUtils.isBlank(epgCategory.getServiceType())) {
			serviceTypeStr = SVOD;	
	    }else{
	    	serviceTypeStr = epgCategory.getServiceType();
	    }
            
		String[] serviceTypeArray = serviceTypeStr.split(",");
		
		//找出节目的content Offering
		List<EpgContentOffering> contentOfferings = getContentOfferings(itemType,itemCode);
		
		//返回交集的第一个ServiceType属性
		EpgContentOffering select = getOfferingByServiceTypes(contentOfferings,serviceTypeArray);
		if(select != null) {
			return select.getServiceType();
		}
		
		//如果没有交集且没设置默认顺序，则返回节目的第一个ServiceType属性
		if(StringUtils.isBlank(this.defaultServiceTypes)){
            return contentOfferings.get(0).getServiceType();
        }
		
		//如果没有交集但设置默认顺序，则返回匹配默认顺序的第一个ServiceType属性，如找不到则返回节目的第一个ServiceType属性
		String[] defaultServiceTypeArray = this.defaultServiceTypes.split(",");
	    select = getOfferingByServiceTypes(contentOfferings,defaultServiceTypeArray);
	        if(select == null){
	            return contentOfferings.get(0).getServiceType();    
	        }else{
	            return select.getServiceType();
	        }
	
	}
	
	
	public List<EpgContentOffering>  getContentOfferings(String itemType,String itemCode) {
		
		String contentCode = itemCode;
		
		//如果是电视剧则取第一集的contentCode
		if(EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType) || EpgCategoryItem.ITEMTYPE_SERIES.equals(itemType.toLowerCase())) {
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("seriesCode", itemCode);
			try {
				List<EpgEpisode> list = baseDao.getSqlMapClientTemplate().queryForList("queryEpisodeContentCodeByCode",params);
				 if (list == null || list.size() == 0){
					 throw new  InvalidDataException("invalid seriesCode :"+itemCode);
				 }
				 EpgEpisode epgEpisode = (EpgEpisode) list.get(0);
				 contentCode = epgEpisode.getContentCode();
				 
			} catch (DataAccessException dae) {
				throw new DaoException(
						"An exception produced  when searching epgEpisodeCode by seriesCode "
								+ itemCode, dae);
			}finally{
				params.clear();
				params = null;
			}	
		}
		
	    //查询内容, 包含了多个offering
	    EpgPlayableContent epc = playerService.searchContentByContentCode(contentCode);
	    return epc.getEpgContentOfferings();
	
	}
	
	
	/**
     * 
     * @param contentOfferings
     * @param serviceTypes
     * @return
     */
    private EpgContentOffering getOfferingByServiceTypes(List<EpgContentOffering> contentOfferings,String[] serviceTypes){
        String serviceType = "";
        for (int i = 0; i < serviceTypes.length; i++) {
            serviceType = serviceTypes[i];            
            for (EpgContentOffering offering : contentOfferings) {
                if(serviceType.equals(offering.getServiceType())){
                    return offering;
                }
            }
        }
        return null;
    }

	

}
