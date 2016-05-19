package sitv.epg.nav.url;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.support.RequestContextUtils;

import sitv.epg.business.dao.PlayerService;
import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.entity.business.EpgPosition;
import sitv.epg.entity.business.EpgSubjectArea;
import sitv.epg.entity.content.EpgBaseContent;
import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgRelContent;
import sitv.epg.entity.content.EpgSchedule;
import sitv.epg.entity.content.EpgSearchProgram;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.content.SearchEpgProgram;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.user.EpgContentVote;
import sitv.epg.entity.user.EpgSubscriberPPV;
import sitv.epg.entity.user.EpgUserBookmark;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.entity.user.EpgUserHistory;
import chances.epg.exception.InvalidDataException;
import chances.epg.exception.LinkProduceException;
import chances.epg.exception.NavigatorException;

/**
 * epg系统 各种链接的生成器
 * 
 * @author zhangxs
 * 
 */
public class NavigatorFactory {
	public static final String BUSINESS = "biz";
	public static final String CATEGORY = "cat";
	public static final String CONTENT = "det";
	public static final String SUBJECT = "sub";
	public static final String SCHEDULE = "sch";
	public static final String DETAIL = "det";
	public static final String PAGE = "page";
	public static final String CHANNEL="cha";
	public static final String GANG = "-";

	private static final String suffix = ".do";
	private static final String S = "/";
	private static final String Y = "?";
	private static final String V = "|";
	private static final String A = "&";
	private static final String RB = "rb=";
	private static final String RC = "rc=";
	private static final String PC = "pc=";
	private static final String RP = "rp=";
	private static final String POS = "pos=";
	private static final String NOLEAVEFOCUS = "nofocus:";
	
	@Autowired
	private PlayerService playerService;
	
	/**
	 * 按item生成首页链接，不同的itemType可能生成不同类型的首页链接
	 * 
	 * @param item
	 * @param businessCode
	 * @param categoryCode
	 * @return
	 */
	public static String createCatetoryItemIndexUrl(EpgCategoryItem item,
			String businessCode, String categoryCode,HttpServletRequest request) {
		if (EpgCategoryItem.ITEMTYPE_BUSINESS.equals(item.getItemType())) {
			
			return createBusinessIndexUrl(item.getItemCode(), businessCode, categoryCode, item.getCategoryCode(), request);
			
		} else if (EpgCategoryItem.ITEMTYPE_CATEGORY.equals(item.getItemType())) {
			
			return createCategoryIndexUrl(item.getItemCode(), businessCode, businessCode, categoryCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_CHANNEL.equals(item.getItemType())) {
			
			return createChannelIndexUrl(item.getItemType(),
					item.getItemCode(), item.getCategoryCode(), businessCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_EPISODE.equals(item.getItemType())) {
			
			return createEpisodeIndexUrl(item.getItemType(),
					item.getItemCode(), item.getCategoryCode(), businessCode, businessCode, categoryCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_POSITION.equals(item.getItemType())) {
			
			// return createPositionAccessUrl(item, businessCode);
			throw new LinkProduceException(
					"positon cannot be edited into category,create position link faulure.item. type:"
							+ item.getItemType()
							+ " item code:"
							+ item.getItemCode());
			
		} else if (EpgCategoryItem.ITEMTYPE_SCHEDULE.equals(item.getItemType())) {
			
			return createScheduleIndexUrl(item.getItemCode(),item.getCategoryCode(), businessCode,request);
			
		} else if (EpgCategoryItem.ITEMTYPE_SERIES.equals(item.getItemType())) {
			
			return createSeriesIndexUrl(item.getItemType(), item.getItemCode(),
					item.getCategoryCode(), businessCode, businessCode, categoryCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_SUBJECT.equals(item.getItemType())) {
			
			return createSubjectIndexUrl(item.getItemCode(), item
					.getCategoryCode(), businessCode, businessCode, categoryCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_VOD.equals(item.getItemType())) {
			
			return createVODIndexUrl(item.getItemType(), item.getItemCode(),
					item.getCategoryCode(), businessCode, businessCode, categoryCode, request);
			
		} else if (EpgCategoryItem.ITEMTYPE_URL.equals(item.getItemType())) {
			
			return produceExterUrl(item.getItemCode(), businessCode, categoryCode, item.getCategoryCode(), request);
			
		} else if (EpgCategoryItem.ITEMTYPE_ICM.equals(item.getItemType())) {
			
			return produceExterIcm(item.getItemCode(), request);
			
		}
		throw new LinkProduceException(
				"Creating link faulure for Category item. type:"
						+ item.getItemType() + " item code:"
						+ item.getItemCode());
	}

	/**
	 * 生成内容的首页，比如节目的详细页面，二级分类的首页
	 * 
	 * @param objType
	 * @param objCode
	 * @param categoryCode
	 * @param businessCode
	 * @return
	 */
	public static String createVODIndexUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String refBiz, String refCat, HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(CONTENT).append(S)
			.append(contentType).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
	}
	
	/**
	 * 生成内容的首页，比如节目的详细页面，二级分类的首页带pageCode
	 * 
	 * @param objType
	 * @param objCode
	 * @param categoryCode
	 * @param businessCode
	 * @return
	 */
	public static String createVODIndexUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String refBiz, String refCat, String pageCode, HttpServletRequest request) {
				
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(CONTENT).append(S)
			.append(contentType).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();
	}
	
	/**
	 * 生成内容的首页，比如节目的详细页面，二级分类的首页带posCode
	 * @param contentType
	 * @param contentCode
	 * @param categoryCode
	 * @param businessCode
	 * @param posCode
	 * @param request
	 * @return
	 */
	public static String createVODIndexUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String posCode, HttpServletRequest request) {
				
		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(CONTENT).append(S)
			.append(contentType).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(POS).append(posCode).toString();
	}
	
	public static String getBizCode(String businessCode){
		if (businessCode == null){
			return GANG;
		}
		return businessCode;
	}
	
	public static String getCatCode(String categoryCode){
		if (categoryCode == null){
			return GANG;
		}
		return categoryCode;
	}
	
	public static String createUserCollectionIndexUrl(EpgUserCollection epgUserCollection, String businessCode,HttpServletRequest request) {
		String bizCode = epgUserCollection.getBizCode();
		if (StringUtils.isBlank(bizCode)){
			bizCode = getBizCode(businessCode);
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)			
			.append(bizCode).append(S)
			.append(CATEGORY).append(S)
			.append(epgUserCollection.getCategoryCode()).append(S)
			.append(CONTENT).append(S)
			.append(epgUserCollection.getContentType()).append(S)
			.append(epgUserCollection.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	/**
	 * 生成看吧首页
	 * 
	 * @param itemCode
	 * @param businessCode
	 * @return
	 */
	public static String createBusinessIndexUrl(String bizCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(bizCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}
	
	/**
	 * 生成看吧首页带REF
	 * 
	 * @param bizCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createBusinessIndexUrl(String bizCode,String refBiz,String refCat,String curCat,HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(bizCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(PC).append(curCat).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
		
	}
	
	/**
	 * 生成看吧首页带REF带pageCode
	 * 
	 * @param bizCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createBusinessIndexUrl(String bizCode,String refBiz,String refCat,String curCat,String pageCode,HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(bizCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(PC).append(curCat).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();
		
	}
	
	/**
	 * 生成看吧首页带posCode
	 * @param bizCode
	 * @param posCode
	 * @param request
	 * @return
	 */
	public static String createBusinessIndexUrl(String bizCode, String posCode, HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(bizCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	/**
	 * 生成看吧下栏目的首页
	 * 
	 * @param catCode
	 * @param businessCode
	 * @param categoryCode
	 * @return
	 */
	public static String createCategoryIndexUrl(String categoryCode,
			String businessCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	/**
	 * 生成看吧下栏目的首页带REF
	 * 
	 * @param categoryCode
	 * @param businessCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createCategoryIndexUrl(String categoryCode,
			String businessCode,String refBiz,String refCat,HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();

	}
	
	/**
	 * 生成看吧下栏目的首页带REF带pageCode
	 * 
	 * @param categoryCode
	 * @param businessCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createCategoryIndexUrl(String categoryCode,
			String businessCode,String refBiz,String refCat,String pageCode,HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();

	}
	
	/**
	 * 生成看吧下栏目的首页带posCode
	 * 
	 * @param categoryCode
	 * @param businessCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createCategoryIndexUrl(String categoryCode,
			String businessCode,String posCode,HttpServletRequest request) {
		
		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(POS).append(posCode).toString();

	}

	/**
	 * 生成剧集的详细页面
	 * 
	 * @param objType
	 * @param objCode
	 * @param categoryCode
	 * @param businessCode
	 * @return
	 */
	public static String createSeriesIndexUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String refBiz, String refCat, HttpServletRequest request) {
		
		return createVODIndexUrl(contentType, contentCode, categoryCode,
				businessCode, businessCode, categoryCode, request);
	}

	/**
	 * 生成专题的首页
	 * 
	 * @param categoryCode
	 * @param subjectCode
	 * @param businessCode
	 * @return
	 */
	public static String createSubjectIndexUrl(String subjectCode,
			String categoryCode, String businessCode, String refBiz, String refCat, HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(SUBJECT).append(S)
			.append(subjectCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
		
	}

	/**
	 * 生成专题的首页pageCode
	 * 
	 * @param categoryCode
	 * @param subjectCode
	 * @param businessCode
	 * @return
	 */
	public static String createSubjectIndexUrl(String subjectCode,
			String categoryCode, String businessCode, String refBiz, String refCat, String pageCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(SUBJECT).append(S)
			.append(subjectCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();
		
	}
	
	/**
	 * 生成专题的首页posCode
	 * @param subjectCode
	 * @param categoryCode
	 * @param businessCode
	 * @param posCode
	 * @param request
	 * @return
	 */
	public static String createSubjectIndexUrl(String subjectCode,
			String categoryCode, String businessCode, String posCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(SUBJECT).append(S)
			.append(subjectCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(POS).append(posCode).toString();
		
	}
	
	/**
	 * 生成专题的某个页面的url
	 * 
	 * @param categoryCode
	 * @param subjectCode
	 * @param businessCode
	 * @return
	 */
	public static String createSubjectPageIndexUrl(String pageCode,
			String categoryCode, String businessCode, String refBiz, String refCat, String rePageCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(PAGE).append(S).append(pageCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A)
			.append(RP).append(rePageCode).toString();
		
	}

	/**
	 * 生成单集的播放链接
	 * 
	 * @param objType
	 * @param objCode
	 * @param categoryCode
	 * @param businessCode
	 * @param refBiz
	 * @param refCat
	 * @return
	 */
	public static String createEpisodeIndexUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String refBiz, String refCat, HttpServletRequest request) {
		
		return createPlayVodUrl(contentType, contentCode, categoryCode,
				businessCode, refBiz, refCat, request);
		
	}

	/**
	 * 生成频道的播放链接
	 * 
	 * @param objType
	 * @param objCode
	 * @param categoryCode
	 * @param businessCode
	 * @return
	 */
	public static String createChannelIndexUrl(String contentType, String channelCode,
			String categoryCode, String businessCode,HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(CHANNEL).append(S)
			.append(channelCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
	}

	/**
	 * 生成节目单的首页
	 * 
	 * @param scheduleCode
	 * @param categoryCode
	 * @param businessCode
	 * @return
	 */
	public static String createScheduleIndexUrl(EpgSchedule epgSchedule,
			String categoryCode, String businessCode,HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append(CONTENT).append(S)
			.append(EpgCategoryItem.ITEMTYPE_VOD).append(S)
			.append(epgSchedule.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}
	
	public static String createScheduleIndexUrl(String itemCode,
			String categoryCode, String businessCode,HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
		.append(BUSINESS).append(S)
		.append(getBizCode(businessCode)).append(S)
		.append(CATEGORY).append(S)
		.append(getCatCode(categoryCode)).append(S)
		.append(CONTENT).append(S)
		.append(EpgCategoryItem.ITEMTYPE_VOD).append(S)
		.append(itemCode).append(suffix).append(Y)
		.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	/**
	 * 推荐位不能编排,只能定义为模板参数
	 * 
	 * @param item
	 * @param businessCode
	 * @return
	 */
	public static String createPositionLinkUrl(String linkType, String linkValue,
			String businessCode, String posCode, HttpServletRequest request) {
		
		if (linkType == null) return "";
		
		if (linkType.equals(EpgPosition.LINKOBJTYPE_CATEGORY)) {
			
			return NOLEAVEFOCUS+createCategoryIndexUrl(linkValue, businessCode, posCode, request);
			
		} else if (linkType.equals(EpgPosition.LINKOBJTYPE_CHANNEL)) {
			/*return createChannelIndexUrl(EpgCategoryItem.ITEMTYPE_CHANNEL,
					linkValue, "-", businessCode);*/
			return createPlayChannelUrl(EpgCategoryItem.ITEMTYPE_CHANNEL, linkValue, null, businessCode, posCode, request);
			
		} else if (linkType.equals(EpgPosition.LINKOBJTYPE_SUBJECT)) {
			
			return createSubjectIndexUrl(linkValue, null, businessCode, posCode, request);
			
		} else if (linkType.equals(EpgPosition.LINKOBJTYPE_TVBAR)) {
			
			return NOLEAVEFOCUS+createBusinessIndexUrl(linkValue, posCode, request);
			
		} else if (linkType.equals(EpgPosition.LINKOBJTYPE_URL)) {
			
			return produceExterUrl(linkValue, posCode, request);
			
		} else if (linkType.equals(EpgPosition.LINKOBJTYPE_VOD)) {
			
			return createVODIndexUrl(EpgCategoryItem.ITEMTYPE_VOD, linkValue,
					null, businessCode, posCode, request);
			
		}else if (linkType.equals(EpgPosition.LINKOBJTYPE_SERIES)){
			
			return createVODIndexUrl(EpgCategoryItem.ITEMTYPE_SERIES, linkValue,
					null, businessCode, posCode, request);
			
		}else if (linkType.equals(EpgPosition.LINKOBJTYPE_EPISODE)){
			
			return createEpisodePlayVodUrl(linkValue,null,businessCode,request);
			
		}
		return "";
	}

	public static String createPositionLinkUrl(EpgPosition epgPosition,
			String businessCode, HttpServletRequest request) {
		
		return createPositionLinkUrl(epgPosition.getLinkObjType(), epgPosition
				.getLinkObjValue(), businessCode, epgPosition.getCode(), request);
		
	}

	public static String createSubjectLinkUrl(String linkType, String linkValue, String pageCode,
			String businessCode, String categoryCode, String refBiz, String refCat, HttpServletRequest request) {
		
		if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_CATEGORY)) {
			
			return createCategoryIndexUrl(linkValue, businessCode, refBiz, refCat, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_CHANNEL)) {
			
			//return createChannelIndexUrl(EpgCategoryItem.ITEMTYPE_CHANNEL,
			//		linkValue, GANG, businessCode);
			return createPlayChannelUrl(EpgCategoryItem.ITEMTYPE_CHANNEL, linkValue,categoryCode, businessCode, refBiz, refCat, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_SUBJECT)) {
			
			return createSubjectIndexUrl(linkValue, null, businessCode, refBiz, refCat, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_TVBAR)) {
			
			return createBusinessIndexUrl(linkValue, refBiz, refCat, categoryCode, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_URL)) {
			
			return produceExterUrl(linkValue, refBiz, refCat, categoryCode, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_VOD)) {
			
			return createVODIndexUrl(EpgCategoryItem.ITEMTYPE_VOD, linkValue,
					categoryCode, businessCode, refBiz, refCat, pageCode, request);
			
		} else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_PAGE)) {
			
			return createSubjectPageIndexUrl(linkValue, categoryCode, businessCode, refBiz, refCat, pageCode, request);
			
		}else if (linkType.equals(EpgSubjectArea.LINKOBJTYPE_SERIES)){
			
			return createVODIndexUrl(EpgCategoryItem.ITEMTYPE_SERIES, linkValue,
					categoryCode, businessCode, refBiz, refCat, pageCode, request);
			
		}
		return "";
	}

	private static String produceExterUrl(String linkValue, String refBiz, String refCat, String curCat, 
			HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(curCat)){
			curCat = "";
		}
		if (StringUtils.isBlank(linkValue)) {
			throw new InvalidDataException("linkValue is blank! ");
		}
		
		StringBuffer sb = new StringBuffer(NOLEAVEFOCUS);
		
		if (linkValue.startsWith("http://") || linkValue.startsWith("HTTP://")){
			sb.append(linkValue);
		}else if (linkValue.startsWith("/")){
			String contextPath = request.getContextPath();
			
			if ("".equals(contextPath)|| "/".equals(contextPath)){
				sb.append(linkValue);
			}else{
				sb.append(contextPath).append(linkValue);
			}
			
		}else {
			sb.append("http://").append(linkValue);
		}
		
		if (sb.indexOf("?")==-1){
			sb.append("?").append(EpgUserSession.createFixUrlParams(request));
		}else{
			sb.append("&").append(EpgUserSession.createFixUrlParams(request));
		}
		return sb.append(A)
		.append(PC).append(curCat).append(A)
		.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
	}
	/**
	 * produceExterUrl带pageCode
	 * @param linkValue
	 * @param refBiz
	 * @param refCat
	 * @param curCat
	 * @param pageCode
	 * @param request
	 * @return
	 */
	private static String produceExterUrl(String linkValue, String refBiz, String refCat, String curCat, String pageCode,
			HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(curCat)){
			curCat = "";
		}
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		if (StringUtils.isBlank(linkValue)) {
			throw new InvalidDataException("linkValue is blank! ");
		}
		
		StringBuffer sb = new StringBuffer(NOLEAVEFOCUS);
		
		if (linkValue.startsWith("http://") || linkValue.startsWith("HTTP://")){
			sb.append(linkValue);
		}else if (linkValue.startsWith("/")){
			String contextPath = request.getContextPath();
			
			if ("".equals(contextPath)|| "/".equals(contextPath)){
				sb.append(linkValue);
			}else{
				sb.append(contextPath).append(linkValue);
			}
			
		}else {
			sb.append("http://").append(linkValue);
		}
		
		if (sb.indexOf("?")==-1){
			sb.append("?").append(EpgUserSession.createFixUrlParams(request));
		}else{
			sb.append("&").append(EpgUserSession.createFixUrlParams(request));
		}
		return sb.append(A)
		.append(PC).append(curCat).append(A)
		.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();
	}
	/**
	 * produceExterUrl带posCode
	 * @param linkValue
	 * @param posCode
	 * @param request
	 * @return
	 */
	private static String produceExterUrl(String linkValue, String posCode, 
			HttpServletRequest request) {

		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		if (StringUtils.isBlank(linkValue)) {
			throw new InvalidDataException("linkValue is blank! ");
		}
		
		StringBuffer sb = new StringBuffer(NOLEAVEFOCUS);
		
		if (linkValue.startsWith("http://") || linkValue.startsWith("HTTP://")){
			sb.append(linkValue);
		}else if (linkValue.startsWith("/")){
			String contextPath = request.getContextPath();
			
			if ("".equals(contextPath)|| "/".equals(contextPath)){
				sb.append(linkValue);
			}else{
				sb.append(contextPath).append(linkValue);
			}
			
		}else {
			sb.append("http://").append(linkValue);
		}
		
		if (sb.indexOf("?")==-1){
			sb.append("?").append(EpgUserSession.createFixUrlParams(request));
		}else{
			sb.append("&").append(EpgUserSession.createFixUrlParams(request));
		}
		return sb.append(A)
		.append(POS).append(posCode).toString();
	}
	
	private static String produceExterIcm(String linkValue,
			HttpServletRequest request) {
		
		if (StringUtils.isBlank(linkValue)) {
			throw new InvalidDataException("linkValue is blank! ");
		}
		
		StringBuffer sb = new StringBuffer().append(linkValue);
		
		return sb.toString();
	}
	
	//生成订购链接
	public static String createOrderUrl(String businessCode, String categoryCode, 
			String contentType, String contentCode, String offeringId, HttpServletRequest request){
		
		return new StringBuffer(getContextPath(request))
		.append(BUSINESS).append(S)
		.append(getBizCode(businessCode)).append(S)
		.append(CATEGORY).append(S)
		.append(getCatCode(categoryCode)).append(S)
		.append("order").append(S)
		.append(contentType).append(S)
		.append(contentCode).append(S)
		.append(offeringId).append(suffix).append(Y)
		.append(EpgUserSession.createFixUrlParams(request)).toString();
	}
	
	//生成订购页面链接
	public static String createOrderPageUrl(String businessCode, String categoryCode, 
			String contentType, String contentCode,String offeringId, HttpServletRequest request){
		
		String returnUrl = (String)request.getParameter("returnUrl");
		String returnUrlUtf8 = new String();
		try{
			returnUrlUtf8 = URLEncoder.encode(returnUrl , "UTF-8");
		} catch (Exception e) {
			
		}
		
		String leaveFocusId = request.getParameter("leaveFocusId");
		String lf = "";
		if (!StringUtils.isBlank(leaveFocusId)){
			lf  = "&leaveFocusId="+leaveFocusId;
		}
		String seriesCode=request.getParameter("seriesCode");
		String episodeIndex=request.getParameter("episodeIndex");
		String book = "";
		if (!StringUtils.isBlank(seriesCode)&&!StringUtils.isBlank(episodeIndex)){
			book  = "&seriesCode="+seriesCode+"&episodeIndex="+episodeIndex;
		}
		
		return new StringBuffer(getContextPath(request))
		.append(BUSINESS).append(S)
		.append(getBizCode(businessCode)).append(S)
		.append(CATEGORY).append(S)
		.append(getCatCode(categoryCode)).append(S)
		.append("orderPage").append(S)
		.append(contentType).append(S)
		.append(contentCode).append(S)
		.append(offeringId).append(suffix).append(Y)
		.append(EpgUserSession.createFixUrlParams(request))
		.append(lf)
		.append(book)
		.append("&returnUrl=")
		.append(returnUrlUtf8).toString();
	}

	public static String createNoDetailPlayVodUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, HttpServletRequest request) {
		
		StringBuffer sb = new StringBuffer();
		sb.append(getContextPath(request))
		.append(BUSINESS).append(S)
		.append(getBizCode(businessCode)).append(S)
		.append(CATEGORY).append(S)
		.append(getCatCode(categoryCode)).append(S)
		.append("play").append(S)
		.append(contentType).append(S)
		.append(contentCode).append(suffix).append(Y)
		.append(EpgUserSession.createFixUrlParams(request));
		return sb.toString(); 
	}
	
	
	public static String createPlayVodUrl(String contentType, String contentCode,
			String categoryCode, String businessCode, String refBiz, String refCat, HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if("channel".equals(contentType)) {
			return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("playchannel").append(S)
			.append(contentType).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
		}else{
			return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(contentType).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).toString();
		}


	}
	
	/**
	 * 高标清混排 20140313 wangkai
	 * @param erc
	 * @param businessCode
	 * @param categoryCode
	 * @param request
	 * @return
	 */
	public static String createPlayVodUrl(EpgRelContent erc, 
			String businessCode, String categoryCode, HttpServletRequest request) {
		String playType = "play";
        String returnUrl = (String)request.getParameter("returnUrl");       
        String returnUrlUtf8 = new String();
        try{
            returnUrlUtf8 = URLEncoder.encode(returnUrl , "UTF-8");
            if(returnUrlUtf8.indexOf("&returnUrl")!=-1) {
                returnUrlUtf8 = returnUrlUtf8.substring(0, returnUrlUtf8.indexOf("&returnUrl"));
            }
        } catch (Exception e) {
        }
        // 如果是预告片或片花，走正常AAA鉴权, 否则表示页面经ajax调用 无需再走play时的AAA鉴权
        //if (erc.getBodyType() == 1) {
            //playType = "noAuthPlay";
        //}
        return new StringBuffer(getContextPath(request))
            .append(BUSINESS).append(S)
            .append(getBizCode(businessCode)).append(S)
            .append(CATEGORY).append(S)
            .append(getCatCode(categoryCode)).append(S)
            .append(playType).append(S)
            .append(EpgCategoryItem.ITEMTYPE_VOD).append(S)
            .append(erc.getContentCode()).append(suffix).append(Y)
            .append(EpgUserSession.createFixUrlParams(request))
            .append("&returnUrl=")
            .append(returnUrlUtf8).toString();
    }
	
	/**
	 * 高标清混排 20140313 wangkai
	 * @param erc
	 * @param businessCode
	 * @param categoryCode
	 * @param request
	 * @return
	 */
	public static String createEpgRelContentIndexUrl(EpgRelContent erc, 
			String businessCode, String categoryCode, HttpServletRequest request) {
		
        String returnUrl = (String)request.getParameter("returnUrl");       
        String returnUrlUtf8 = new String();
        try{
            returnUrlUtf8 = URLEncoder.encode(returnUrl , "UTF-8");
            if(returnUrlUtf8.indexOf("&returnUrl")!=-1) {
                returnUrlUtf8 = returnUrlUtf8.substring(0, returnUrlUtf8.indexOf("&returnUrl"));
            }
        } catch (Exception e) {
        }
        return new StringBuffer(getContextPath(request))
            .append(BUSINESS).append(S)
            .append(getBizCode(businessCode)).append(S)
            .append(CATEGORY).append(S)
            .append(getCatCode(categoryCode)).append(S)
            .append(CONTENT).append(S)
            .append(erc.getType()).append(S)
            .append(erc.getContentCode()).append(suffix).append(Y)
            .append(EpgUserSession.createFixUrlParams(request))
            .append("&returnUrl=")
            .append(returnUrlUtf8).toString();
    }
	
	public static String createPlayScheduleUrl(String contentType, String contentCode,
            String categoryCode, String businessCode,String channleCode,HttpServletRequest request) {
        
		return new StringBuffer(getContextPath(request))
        .append(BUSINESS).append(S)
        .append(getBizCode(businessCode)).append(S)
        .append(CATEGORY).append(S)
        .append(getCatCode(categoryCode)).append(S)
        .append(CHANNEL).append(S)
        .append(channleCode).append(S)
        .append("play").append(S)
        .append(contentType).append(S)
        .append(contentCode).append(suffix).append(Y)
        .append(EpgUserSession.createFixUrlParams(request)).toString();


    }

	public static String createPlayVodUrl(EpgProgram program, String businessCode,String categoryCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(program.getContentType()).append(S)
			.append(program.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();


	}

	public static String createPlayVodUrl(EpgEpisode episode, String businessCode,String categoryCode,HttpServletRequest request) {
		
		return createEpisodePlayVodUrl(episode.getContentCode(),businessCode,categoryCode,request);
	
	}
	/**
	 * 
	 * @param contentCode
	 * @param businessCode
	 * @param categoryCode
	 * @param request
	 * @return
	 */
	public static String createEpisodePlayVodUrl(String contentCode, String businessCode,String categoryCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(EpgCategoryItem.ITEMTYPE_EPISODE).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
	}
	/**
	 * createEpisodePlayVodUrl带posCode
	 * @param contentCode
	 * @param businessCode
	 * @param categoryCode
	 * @param posCode
	 * @param request
	 * @return
	 */
	public static String createEpisodePlayVodUrl(String contentCode, String businessCode, String categoryCode, String posCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(EpgCategoryItem.ITEMTYPE_EPISODE).append(S)
			.append(contentCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(POS).append(posCode).toString();
	}

	
	public static String createUserCollectionIndexUrl(EpgUserCollection collection, String businessCode, String categoryCode,HttpServletRequest request) {

		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)			
			.append(businessCode).append(S)
			.append(CATEGORY).append(S)
			.append(categoryCode).append(S)
			.append(CONTENT).append(S)
			.append(collection.getContentType()).append(S)
			.append(collection.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}
	
	public static String createUserSearchIndexUrl(EpgSearchProgram esp, String businessCode, String categoryCode,HttpServletRequest request) {

		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)			
			.append(businessCode).append(S)
			.append(CATEGORY).append(S)
			.append(categoryCode).append(S)
			.append(CONTENT).append(S)
			.append(esp.getContentType()).append(S)
			.append(esp.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}
	
	
	
	public static String createPlayVodUrl(EpgUserCollection collection,
			String businessCode,HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(GANG).append(S)
			.append("play").append(S)
			.append(collection.getContentType()).append(S)
			.append(collection.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	public static String createPlayVodUrl(EpgSubscriberPPV subscriberPPV,
			HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(subscriberPPV.getBizCode())).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(subscriberPPV.getCategoryCode())).append(S)
			.append("play").append(S)
			.append(subscriberPPV.getProgramType()).append(S)
			.append(subscriberPPV.getProgramCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	public static String createPlayVodUrl(EpgContentVote ecv,String businessCode,String categoryCode,
			HttpServletRequest request) {
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(businessCode).append(S)
			.append(CATEGORY).append(S)
			.append(categoryCode).append(S)
			.append("play").append(S)
			.append(ecv.getContentType()).append(S)
			.append(ecv.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	public static String createPlayChannelUrl(String contentType, String channelCode,
			String categoryCode, String businessCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(contentType).append(S)
			.append(channelCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
	
	}
	
	/**
	 * createPlayChannelUrl带posCode（推荐位）
	 * @param contentType
	 * @param channelCode
	 * @param categoryCode
	 * @param businessCode
	 * @param posCode
	 * @param request
	 * @return
	 */
	public static String createPlayChannelUrl(String contentType, String channelCode,
			String categoryCode, String businessCode, String posCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(posCode)){
			posCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(contentType).append(S)
			.append(channelCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(POS).append(posCode).toString();
	
	}
	
	/**
	 * createPlayChannelUrl带REF带pageCode（专辑）
	 * @param contentType
	 * @param channelCode
	 * @param categoryCode
	 * @param businessCode
	 * @param refBiz
	 * @param refCat
	 * @param pageCode
	 * @param request
	 * @return
	 */
	public static String createPlayChannelUrl(String contentType, String channelCode,
			String categoryCode, String businessCode, String refBiz, String refCat, String pageCode, HttpServletRequest request) {
		
		if(StringUtils.isBlank(refBiz)){
			refBiz = "";
		}
		if(StringUtils.isBlank(refCat)){
			refCat = "";
		}
		if(StringUtils.isBlank(pageCode)){
			pageCode = "";
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)
			.append(getBizCode(businessCode)).append(S)
			.append(CATEGORY).append(S)
			.append(getCatCode(categoryCode)).append(S)
			.append("play").append(S)
			.append(contentType).append(S)
			.append(channelCode).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).append(A)
			.append(RB).append(refBiz).append(A).append(RC).append(refCat).append(A).append(RP).append(pageCode).toString();
	
	}
	
	
	/**
	 * 生成历史页面入口链接
	 * 
	 * @param request
	 * @return
	 */
	public static String createHistoryUrl(HttpServletRequest request) {
	    return CommonUrlGenerator.getInstance().createHistoryPage(request);
	}

	/**
	 * 生成自助页面入口链接
	 * 
	 * @param request
	 * @return
	 */
	public static String createSelfUrl(HttpServletRequest request) {
	    return CommonUrlGenerator.getInstance().createSelfPage(request);
	}
	

	public static String createHelpUrl(HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append("help").append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	public static String createSearchUrl(HttpServletRequest request) {
		//return new StringBuffer(getContextPath(request)).append("search").append(
		//		suffix).append(Y).append(EpgUserSession.createFixUrlParams(request)).toString();
		return CommonUrlGenerator.getInstance().createSearchPage(request);
	}

	public static String createMyCollectionUrl(HttpServletRequest request) {
		//return new StringBuffer(getContextPath(request)).append("myCollection")
		//		.append(suffix).append(Y).append(EpgUserSession.createFixUrlParams(request)).toString();
		return CommonUrlGenerator.getInstance().createCollectionPage(request);
	}
	
	public static String createMyBookmarkUrl(HttpServletRequest request) {
		//return new StringBuffer(getContextPath(request)).append("myBookmark")
		//		.append(suffix).append(Y).append(EpgUserSession.createFixUrlParams(request)).toString();
		return CommonUrlGenerator.getInstance().createBookmarkPage(request);
	}
	
	public static String createHomeUrl(HttpServletRequest request) {
		return new StringBuffer(getContextPath(request)).append("home/home_").append(EpgUserSession.findUserSession(request).getEntry())
				.append(suffix).append(Y).append(EpgUserSession.createFixUrlParams(request)).toString();
	}

	private static String encode(String content){
		try {
			return  URLEncoder.encode(content,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new NavigatorException("unsupport for encoding chars "+content+" using UTG-8");
		}
	}

	public static String createAddCollectionUrl(EpgCategoryItem item,
			String businessCode,String categoryCode,HttpServletRequest request) {
		
		String contentName = encode(item.getTitle());
		String cc = categoryCode;
		if (StringUtils.isBlank(cc)){
			cc = item.getCategoryCode();
		}
		return new StringBuffer(getContextPath(request))
			.append("addCollection").append(suffix)
			.append("?contentType=").append(item.getItemType())
			.append("&contentCode=").append(item.getItemCode())
			.append("&contentName=").append(contentName)
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(cc)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	public static String createAddCollectionUrl(EpgSeries series,
			String businessCode,String categoryCode,HttpServletRequest request) {
		
		String contentName = encode(series.getTitle());
		
		return new StringBuffer(getContextPath(request))
			.append("addCollection").append(suffix)
			.append("?contentType=").append(EpgCategoryItem.ITEMTYPE_SERIES)
			.append("&contentCode=").append(series.getContentCode())
			.append("&contentName=").append(contentName)
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	public static String createAddCollectionUrl(EpgProgram program, String businessCode,String categoryCode,HttpServletRequest request) {
		
		String contentName = encode(program.getTitle());
		
		return new StringBuffer(getContextPath(request))
			.append("addCollection").append(suffix)
			.append("?contentType=").append(program.getContentType())
			.append("&contentCode=").append(program.getContentCode())
			.append("&contentName=").append(contentName)
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	public static String createAddCollectionUrl(EpgBaseContent program, String businessCode,String categoryCode,HttpServletRequest request) {
		
		String contentName = encode(program.getTitle());
		
		return new StringBuffer(getContextPath(request))
			.append("addCollection").append(suffix)
			.append("?contentType=").append(program.getContentType())
			.append("&contentCode=").append(program.getContentCode())
			.append("&contentName=").append(contentName)
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();

	}

	
	public static String createDeleteCollectionUrl(EpgUserCollection item,
			String businessCode,String pageIndex,HttpServletRequest request) {
		
		if(pageIndex!=null){
			
			return new StringBuffer(getContextPath(request))
				.append("deleteCollection").append(suffix)
				.append("?id=").append(item.getId())
				.append("&").append(EpgUserSession.createFixUrlParams(request))
				.append("&").append("pageIndex=").append(pageIndex).toString();
			
		}
		else {
			
			return new StringBuffer(getContextPath(request))
				.append("deleteCollection").append(suffix)
				.append("?id=").append(item.getId())
				.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
		
		}
	}
	
	
	
	public static String createVoteUrl(EpgCategoryItem item,
			String businessCode,String categoryCode,HttpServletRequest request) {
		
		String cc = categoryCode;
		if (StringUtils.isBlank(cc)){
			cc = item.getCategoryCode();
		}
		return new StringBuffer(getContextPath(request))
			.append("vote").append(suffix)
			.append("?contentType=").append(item.getItemType())
			.append("&contentCode=").append(item.getItemCode())
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
	}
	
	public static String createVoteUrl(EpgContentVote ecv,
			String businessCode,String categoryCode,HttpServletRequest request) {
		
		return new StringBuffer(getContextPath(request))
			.append("vote").append(suffix)
			.append("?contentType=").append(ecv.getContentType())
			.append("&contentCode=").append(ecv.getContentCode())
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
	}
	
	
	public static String createVoteUrl(EpgSeries series,
			String businessCode,String categoryCode,HttpServletRequest request) {
				
		return new StringBuffer(getContextPath(request))
			.append("vote").append(suffix)
			.append("?contentType=").append(EpgCategoryItem.ITEMTYPE_SERIES)
			.append("&contentCode=").append(series.getContentCode())
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
		
	}

	public static String createVoteUrl(EpgProgram program, String businessCode,String categoryCode,HttpServletRequest request) {
				
		return new StringBuffer(getContextPath(request))
			.append("vote").append(suffix)
			.append("?contentType=").append(program.getContentType())
			.append("&contentCode=").append(program.getContentCode())
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode)
			.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();

	}
	
	
	
	public static String getContextPath(HttpServletRequest request) {
		
	    String contextPath = request.getContextPath();
	    
	    if(StringUtils.isBlank(contextPath)){
	        return S;
	    }
	    
	    if("/".equals(contextPath)){
	        return contextPath;
	    }
	    
	    return contextPath + S;
	}
	
	public static String createOrderBackPath(String businessCode,String categoryCode,String contentType,String contentCode,HttpServletRequest request) {
		String contentType1 = contentType;
		String contentCode1 = contentCode;
    	if("episode".equals(contentType)){
    		contentType1 = "series";    		
    		WebApplicationContext applicationContext = RequestContextUtils
			.getWebApplicationContext(request,request.getSession().getServletContext());
			PlayerService playerService = (PlayerService) applicationContext.getBean("playerService");
			contentCode1 =  playerService.searchSeriesCodeByEpisodeCode(contentCode);
    	}
    	return NavigatorFactory.createVODIndexUrl(contentType1, contentCode1, categoryCode, businessCode, businessCode, categoryCode, request);	
	}
	
	public static String createAddBookmarkUrl(EpgPlayableContent epc, String businessCode,String categoryCode,HttpServletRequest request) {
		
	    String contentName = encode(epc.getTitle());
		
		return new StringBuffer(getContextPath(request))
			.append("addBookmark").append(suffix)
			.append("?contentType=").append(epc.getProgramType())
			.append("&contentCode=").append(epc.getContentCode())
			.append("&contentName=").append(contentName)
			.append("&bizCode=").append(businessCode)
			.append("&categoryCode=").append(categoryCode).toString();
			//.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();

	}

	public static String createUserBookmarkIndexUrl(EpgUserBookmark epgUserBookmark, String businessCode,HttpServletRequest request) {
		String bizCode = epgUserBookmark.getBizCode();
		if (StringUtils.isBlank(bizCode)){
			bizCode = getBizCode(businessCode);
		}
		return new StringBuffer(getContextPath(request))
			.append(BUSINESS).append(S)			
			.append(bizCode).append(S)
			.append(CATEGORY).append(S)
			.append(epgUserBookmark.getCategoryCode()).append(S)
			.append("play").append(S)
			.append(epgUserBookmark.getContentType()).append(S)
			.append(epgUserBookmark.getContentCode()).append(suffix).append(Y)
			.append(EpgUserSession.createFixUrlParams(request))
			.append("&contentElapsed=").append(epgUserBookmark.getContentElapsed()).toString();
		
	}

	public static String createDeleteBookmarkUrl(EpgUserBookmark item,
			String businessCode,String pageIndex,HttpServletRequest request) {
		
		if(pageIndex!=null){
			
			return new StringBuffer(getContextPath(request))
				.append("deleteBookmark").append(suffix)
				.append("?id=").append(item.getId())
				.append("&").append(EpgUserSession.createFixUrlParams(request))
				.append("&").append("pageIndex=").append(pageIndex).toString();
			
		}
		else {
			
			return new StringBuffer(getContextPath(request))
				.append("deleteBookmark").append(suffix)
				.append("?id=").append(item.getId())
				.append("&").append(EpgUserSession.createFixUrlParams(request)).toString();
		
		}
	}

    /**
     * 删除历史
     * 
     * @param euh
     * @param businessCode
     * @param categoryCode 
     * @param request
     * @return
     */
    public static String createDeleteHistoryUrl(EpgUserHistory euh,
            String businessCode, String categoryCode, HttpServletRequest request) {

        return new StringBuffer(getContextPath(request))
            .append("deleteHistory")
            .append(suffix).append(Y)
            .append(EpgUserSession.createFixUrlParams(request))
            .append("&bizCode=").append(businessCode)
            .append("&categoryCode=").append(categoryCode)
            .toString();
    }
    
    /**
     * 生成搜索页面播放链接
     * 
     * @param esp
     * @param businessCode
     * @param categoryCode
     * @param request
     * @return
     */
    public static String createUserSearchIndexUrl(SearchEpgProgram esp, String businessCode, 
            String categoryCode,HttpServletRequest request) {
        return createVODIndexUrl(esp.getContentType(), esp.getContentCode(), categoryCode,
                businessCode, businessCode, categoryCode, request);
    }

    
    /**
     * 历史播放链接
     * 
     * @param euh
     * @param request
     * @return
     */
    public static String createPlayVodUrl(EpgUserHistory euh, String businessCode,
            String categoryCode, HttpServletRequest request) {
        String urlBase = (String) request.getAttribute("urlBase");
        String queryStr = (String) request.getAttribute("queryStr");
        String returnUrl = new StringBuffer(urlBase).append("?").append(
                queryStr).toString();
        String returnUrlUtf8 = new String();
        try {
            returnUrlUtf8 = URLEncoder.encode(returnUrl, "UTF-8");
            if (returnUrlUtf8.indexOf("&returnUrl") != -1) {
                returnUrlUtf8 = returnUrlUtf8.substring(0, returnUrlUtf8
                        .indexOf("&returnUrl"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String flag = "play";
        if(euh.getContentType().equals(EpgCategoryItem.ITEMTYPE_SERIES)){
            flag = DETAIL;
        }

        return new StringBuffer(
                getContextPath(request))
                .append(BUSINESS).append(S)
                .append(businessCode).append(S)
                .append(CATEGORY).append(S)
                .append(categoryCode).append(S)
                .append(flag).append(S)
                .append("vod").append(S)
                .append(euh.getContentCode()).append(suffix).append(Y)
                .append(EpgUserSession.createFixUrlParams(request))
                .append("&returnUrl=").append(returnUrlUtf8)
                .toString();
    }


}
