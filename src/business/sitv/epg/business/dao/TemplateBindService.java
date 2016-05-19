package sitv.epg.business.dao;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.entity.business.EpgBusiness;
import sitv.epg.entity.business.EpgTemplateBind;
import sitv.epg.entity.edit.EpgCategory;
import chances.epg.exception.DaoException;

/**
 * 模板绑定DAO 服务
 * 
 * @author zhangxs
 * 
 */
@Repository
public class TemplateBindService extends EpgBaseDao {
    private static Log logger = EpgLogFactory.getSystemLogger();
	
	/**
	 * 得到看吧首页模板 看吧首页必须绑定模板,所以直接查询即可
	 * 
	 * @param businessCode
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public EpgTemplateBind getBusinessIndexTemplate(EpgBusiness business) {
	    String businessCode = business.getCode();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("businessCode", businessCode);
		params.put("templateType", EpgTemplateBind.TEMPLATE_TYPE_INDEX);
		
		if (logger.isDebugEnabled()) {
			logger.debug("getBusinessIndexTemplate. businesscode:" 
			        + businessCode		
			        + "; templateType="
			        + EpgTemplateBind.TEMPLATE_TYPE_INDEX);
		}
		
		List<EpgTemplateBind> epgTemplateBinds = Collections.EMPTY_LIST;
		try {
			epgTemplateBinds = baseDao.getSqlMapClientTemplate().queryForList(
					"getEpgTemplateBind", params);
		} catch (DataAccessException dae) {
			throw new DaoException("An exception produced when searching biz index template by biz code:" + businessCode, dae);
		} finally {
			params.clear();
			params = null;
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("find " + epgTemplateBinds.size() + " records");
		}
		
		return epgTemplateBinds.size() > 0 ? epgTemplateBinds.get(0) : null;
	}

	/**
	 * 取看吧栏目的列表页面 当某个栏目没有找到绑定的列表页面时,自动回搠到取其父栏目的列表页面,直到回搠到根 绑定关系中locate Str 格式为
	 * #bizCode#cat1Code#cat2Code#cat3Code#
	 * 
	 * @param businessCode
	 * @param categoryCode
	 * @param categoryLocateStr
	 *            栏目的locate Str a格式 #cat1Code#cat2Code#cat3Code#
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public EpgTemplateBind getBizCatListTmplate(String businessCode,
			String categoryCode, String categoryLocateStr) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("businessCode", businessCode);
		params.put("templateType", EpgTemplateBind.TEMPLATE_TYPE_LIST);
		if (logger.isDebugEnabled()) {
			logger.debug(
					"getBizCatListTmplate. businesscode:" + businessCode
							+ "; templateType="
							+ EpgTemplateBind.TEMPLATE_TYPE_LIST);
		}
		List<EpgTemplateBind> epgTemplateBinds = Collections.EMPTY_LIST;
		try {
			epgTemplateBinds = baseDao.getSqlMapClientTemplate().queryForList(
					"getEpgTemplateBind", params);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching list template by biz and cat ,biz code:"
							+ businessCode, dae);
		} finally {
			params.clear();
			params = null;
		}
		if (logger.isDebugEnabled()) {
			logger.debug(
					"find " + epgTemplateBinds.size() + " records");
		}
		return findTemplate(businessCode, categoryLocateStr, epgTemplateBinds);

	}
	
	

	/**
	 * 匹配出最短
	 * 
	 * @param businessCode
	 * @param categoryLocateStr
	 * @param epgTemplateBinds
	 * @return
	 */
	private EpgTemplateBind findTemplate(String businessCode,
			String categoryLocateStr, List<EpgTemplateBind> epgTemplateBinds) {
		if (categoryLocateStr == null || "".equals(categoryLocateStr))
			return null;
		
		String str = categoryLocateStr;
		EpgTemplateBind etb = null;
		if (logger.isDebugEnabled()) {
			logger.debug("match categoryLocateStr location str:"
									+ categoryLocateStr);
		}
		while (!"#".equals(str)) {
			for (int i = 0; i < epgTemplateBinds.size(); i++) {
				etb = epgTemplateBinds.get(i);
				if (logger.isDebugEnabled()) {
					logger.debug("match template,template location str:"
									+ etb.getLocationStr() + " ,successfull?"
									+ (etb.getLocationStr().endsWith(str)));
				}
				if (etb.getLocationStr() != null
						&& etb.getLocationStr().endsWith(str)) {
					return etb;
				}
			}
			// 自动回搠到栏目的父栏目
			str = str.substring(0, str.lastIndexOf("#")); // #cat1#cat2#cat3# 变成
			// #cat1#cat2#cat3
			str = str.substring(0, str.lastIndexOf("#") + 1); // #cat1#cat2#cat3
			// 变成
			// #cat1#cat2#
		}
		// 如果栏目匹配不到,则取看吧列表页面
		if (logger.isDebugEnabled()) {
			EpgLogFactory
					.getSystemLogger()
					.debug("cannot find category bind template, now get business list page");
		}
		str = "#" + businessCode + "#";
		for (int i = 0; i < epgTemplateBinds.size(); i++) {
			etb = epgTemplateBinds.get(i);
			if (etb.getLocationStr() != null
					&& etb.getLocationStr().equals(str)) {
				if (logger.isDebugEnabled()) {
					logger.debug("match business successfully: template locate str is "
									+ etb.getLocationStr());
				}
				return etb;
			}
		}
		if (logger.isDebugEnabled()) {
			logger.debug(
					"match filure, not found any template to use");
		}
		return null;
	}

	/**
	 * 获取看吧栏目下内容的详细页面
	 * 
	 * @param businessCode
	 * @param categoryCode
	 * @param categoryLocateStr
	 * @param contentType
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public EpgTemplateBind getBizCatContentDetailTemplate(String businessCode,
			String categoryCode, String categoryLocateStr, String contentType) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("businessCode", businessCode);
		params.put("contentType", contentType);
		params.put("templateType", EpgTemplateBind.TEMPLATE_TYPE_DETAIL);
		if (logger.isDebugEnabled()) {
			logger.debug("getBizCatContentDetailTemplate. businesscode:"
							+ businessCode + " ;contentType=" + contentType
							+ "; templateType="
							+ EpgTemplateBind.TEMPLATE_TYPE_DETAIL);
		}
		List<EpgTemplateBind> epgTemplateBinds = Collections.EMPTY_LIST;
		try {
			epgTemplateBinds = baseDao.getSqlMapClientTemplate().queryForList(
					"getEpgTemplateBind", params);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when searching detail template by biz, cat and content ,biz code:"
							+ businessCode + "; content type:" + contentType,
					dae);
		}
		if (logger.isDebugEnabled()) {
			logger.debug(
					"find " + epgTemplateBinds.size() + " records");
		}
		return findTemplate(businessCode, categoryLocateStr, epgTemplateBinds);
	}

    /**
     * 获取看吧下栏目的绑定模板.
     * @param biz
     * @param category
     * @return
     */
    public EpgTemplateBind getBizCatTemplate(EpgBusiness biz,EpgCategory category) {
        String locateStr = category.getLocationString();
        EpgTemplateBind epgTemplateBind = getBizCatListTmplate(biz.getCode(), category.getCode(),locateStr);
        return epgTemplateBind;
    }
}
