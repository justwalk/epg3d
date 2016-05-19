/*
 * Copyright (c) 2011 by Chances.
 * $CVSHeader$
 * $Author$
 * $Date$
 * $Revision$
 */
package sitv.epg.data;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import sitv.epg.business.EpgLogFactory;
import sitv.epg.business.EpgLogGenerator;
import sitv.epg.business.dao.BookmarkService;
import sitv.epg.business.dao.CategoryItemService;
import sitv.epg.business.dao.CollectionService;
import sitv.epg.business.dao.EpisodeService;
import sitv.epg.business.dao.PlayerService;
import sitv.epg.business.dao.ProgramService;
import sitv.epg.business.dao.SeriesmarkService;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.business.EpgHostProFile;
import sitv.epg.entity.content.EpgContentOffering;
import sitv.epg.entity.content.EpgEpisode;
import sitv.epg.entity.content.EpgLiveChannel;
import sitv.epg.entity.content.EpgPlayableContent;
import sitv.epg.entity.content.EpgProgram;
import sitv.epg.entity.content.EpgSchedule;
import sitv.epg.entity.content.EpgSeries;
import sitv.epg.entity.content.SearchEpgProgram;
import sitv.epg.entity.edit.EpgCategoryItem;
import sitv.epg.entity.edit.EpgCategoryItemWithPic;
import sitv.epg.entity.user.EpgUserBookmark;
import sitv.epg.entity.user.EpgUserCollection;
import sitv.epg.entity.user.EpgUserSeriesmark;
import sitv.epg.zhangjiagang.service.AuthenticateService;
import sitv.epg.zhangjiagang.bo.BoException;
import sitv.epg.zhangjiagang.http.response.StartResponse;

import sitv.epg.nav.controller.AbstractController;
import sitv.epg.nav.url.NavigatorFactory;
import sitv.epg.web.context.EpgContext;
import sitv.epg.web.context.EpgContextFactory;
import sitv.epg.web.tag.help.BookmarkUrlGenerator;
import sitv.epg.web.tag.help.CollectionUrlGenerator;
import sitv.epg.web.tag.help.IndexUrlGenerator;
import sitv.epg.zhangjiagang.EpgUserSession;
import chances.epg.utils.PathWraper;

/**
 * Class comments.
 *
 * @author <a href="mailto:libf@chances.com.cn">libf</a>
 */
@Controller
public class DataAccessController extends AbstractController {
    private static final int DEFAULT_PAGESIZE = 10;
    private static final String SUCCESS = "/common/data";
    private int totalCount = 0;
    private int totalPage = 0;
    String JSONResult = new String();
    String addCollctionJSONResult = new String();
    
    @Autowired
    private CategoryItemService categoryItemService;
    
    @Autowired
    private CollectionService collectionService;
    
    @Autowired
    private EpisodeService episodeService; 
    
    @Autowired
    private ProgramService programService;
    
    @Autowired
    private PlayerService playerService;
    
    @Autowired
    private BookmarkService bookmarkService;
    
    @Autowired
    private AuthenticateService aaaService;
    
	@Autowired
	private SeriesmarkService seriesmarkService;
    
    /**
     * 获取用户书签.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getBookmark", method = RequestMethod.GET)
    public String getUserBookmark(ModelMap model, HttpServletRequest request) {
        //String userId = request.getParameter("userId");
        String currentPage = request.getParameter("p");
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        
        EpgUserSession eus = (EpgUserSession) EpgUserSession.findUserSession(request);
        String userId = eus.getUserData().getDeviceId();

        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(userId)){
            throw new InvalidaQueryParameterException("userId code must not been null.");
        }
        
        List<EpgUserBookmark> eubs = null;
        
        //查找所有的书签数据
        if(StringUtils.isEmpty(currentPage) || StringUtils.isEmpty(pageSize)
                || !StringUtils.isNumeric(currentPage) || !StringUtils.isNumeric(pageSize)){
        	eubs = bookmarkService.getEpgUserBookmarks(userId);
        }else{
            int cPage = Integer.parseInt(currentPage);
            int cPs = Integer.parseInt(pageSize);
            
            eubs = bookmarkService.getEpgUserBookmarks(userId, caculateStartRow(cPage,cPs), cPs);
        }
        
        this.fillBookmarkIndexAndDeleteUrl(request, eubs);
        //System.out.println(JSONArray.fromCollection(items).toString());
        model.addAttribute("data", JSONArray.fromCollection(eubs).toString());
        
        return SUCCESS;
    }
    
    /**
     * 获取书签的总和.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getBookmarkTotal", method = RequestMethod.GET)
    public String getBookmarkTotal(ModelMap model, HttpServletRequest request) {
    	//String userId = request.getParameter("userId");
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);

        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        EpgUserSession eus = (EpgUserSession) EpgUserSession.findUserSession(request);
        String userId = eus.getUserData().getDeviceId();
        
        if(StringUtils.isEmpty(userId)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        int count = bookmarkService.getEpgUserBookmarkTotal(userId);
        
        request.setAttribute("data", count);
        
        return SUCCESS;
    }
    
    
    
    /**
     * 获取指定栏目中的编排数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getCategoryItems", method = RequestMethod.GET)
    public String getCategoryItems(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        String currentPage = request.getParameter("p");
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        List<EpgCategoryItem> items = null;
        
        
        //查找栏目中所有的编排对象
        if(StringUtils.isEmpty(currentPage) || StringUtils.isEmpty(pageSize)
                || !StringUtils.isNumeric(currentPage) || !StringUtils.isNumeric(pageSize)){
            items = categoryItemService.getCategoryItems(categoryCode);
            
            this.fillPictureFullPath(request, items);
            //System.out.println(JSONArray.fromCollection(items).toString());
            model.addAttribute("data", JSONArray.fromCollection(items).toString());
            
        }else{
            int cPage = Integer.parseInt(currentPage);
            int cPs = Integer.parseInt(pageSize);
            
            //获取总页数
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("categoryCode", categoryCode);
    		totalCount = collectionService.getTotalCount("getSeverialItems",paramMap);
    		totalPage = (int)Math.ceil((double)totalCount/cPs);
            
            items = categoryItemService.getCategoryItems(categoryCode, caculateStartRow(cPage,cPs), cPs);
       
            this.fillPictureFullPath(request, items);
            //System.out.println(JSONArray.fromCollection(items).toString());
            JSONResult = new StringBuffer().append("{'totalPage':'")
			   .append(totalPage)
			   .append("','JSONArray':")
			   .append(JSONArray.fromCollection(items).toString())
			   .append("}").toString();

            model.addAttribute("data", JSONResult);
            
        }
        
        
        
        return SUCCESS;
    }
    
    /**
     * 随机获取指定栏目中的编排数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getRandomCategoryItems", method = RequestMethod.GET)
    public String getRandomCategoryItems(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        int pSize = DEFAULT_PAGESIZE;
        
        if(!StringUtils.isEmpty(pageSize) && StringUtils.isNumeric(pageSize)){
            pSize = Integer.parseInt(pageSize);
        }
        
        
        
        
        List<EpgCategoryItem> items = categoryItemService.getRandomCategoryItems(categoryCode, pSize);
        this.fillPictureFullPath(request, items);
        
        model.addAttribute("data", JSONArray.fromCollection(items).toString());
        return SUCCESS;
    }
    
    /**
     * 获取指定栏目中的编排数据，带内容的海报.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getCategoryItemsWithPoster", method = RequestMethod.GET)
    public String getCategoryItemsWithPoster(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        String currentPage = request.getParameter("p");
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        List<EpgCategoryItemWithPic> items = null;
        
        //查找栏目中所有的编排对象
        if(StringUtils.isEmpty(currentPage) || StringUtils.isEmpty(pageSize)
                || !StringUtils.isNumeric(currentPage) || !StringUtils.isNumeric(pageSize)){
        	items = categoryItemService.getCategoryItemsWithPoster(categoryCode);
        
            this.fillContentPictureFullPath(request, items);
            //System.out.println(JSONArray.fromCollection(items).toString());
            model.addAttribute("data", JSONArray.fromCollection(items).toString());

        
        
        }else{
            int cPage = Integer.parseInt(currentPage);
            int cPs = Integer.parseInt(pageSize);
            
            items = categoryItemService.getCategoryItemsWithPoster(categoryCode, caculateStartRow(cPage,cPs), cPs);
        
          //获取总页数
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("categoryCode", categoryCode);
    		totalCount = collectionService.getTotalCount("getSeverialItems",paramMap);
    		totalPage = (int)Math.ceil((double)totalCount/cPs);
            
            items = categoryItemService.getCategoryItemsWithPoster(categoryCode, caculateStartRow(cPage,cPs), cPs);
       
            this.fillContentPictureFullPath(request, items);

            JSONResult = new StringBuffer().append("{'totalPage':'")
			   .append(totalPage)
			   .append("','JSONArray':")
			   .append(JSONArray.fromCollection(items).toString())
			   .append("}").toString();

            model.addAttribute("data", JSONResult);
        
        }
       
        return SUCCESS;
        
        
    }
    
    
    /**
     * 获取指定栏目中的编排数据，带专辑的海报.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getCategoryItemsWithSubjectPic", method = RequestMethod.GET)
    public String getCategoryItemsWithSubjectPic(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        String currentPage = request.getParameter("p");
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        List<EpgCategoryItemWithPic> items = null;
        
        //查找栏目中所有的编排对象
        if(StringUtils.isEmpty(currentPage) || StringUtils.isEmpty(pageSize)
                || !StringUtils.isNumeric(currentPage) || !StringUtils.isNumeric(pageSize)){
        	items = categoryItemService.getCategoryItemsWithSubjectPic(categoryCode);
        
            this.fillContentPictureFullPath(request, items);
            model.addAttribute("data", JSONArray.fromCollection(items).toString());

        
        
        }else{
            int cPage = Integer.parseInt(currentPage);
            int cPs = Integer.parseInt(pageSize);
            
            items = categoryItemService.getCategoryItemsWithSubjectPic(categoryCode, caculateStartRow(cPage,cPs), cPs);
        
          //获取总页数
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("categoryCode", categoryCode);
    		totalCount = collectionService.getTotalCount("getSeverialItems",paramMap);
    		totalPage = (int)Math.ceil((double)totalCount/cPs);
            
            items = categoryItemService.getCategoryItemsWithSubjectPic(categoryCode, caculateStartRow(cPage,cPs), cPs);
       
            this.fillContentPictureFullPath(request, items);

            JSONResult = new StringBuffer().append("{'totalPage':'")
			   .append(totalPage)
			   .append("','JSONArray':")
			   .append(JSONArray.fromCollection(items).toString())
			   .append("}").toString();

            model.addAttribute("data", JSONResult);
        
        }
       
        return SUCCESS;
        
        
    }
    
    
    /**
     * 获取指定栏目中指定序号的编排数据，带内容的海报.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getMovieByIndex", method = RequestMethod.GET)
    public String getMovieByIndex(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        int idx = Integer.parseInt(request.getParameter("idx"));
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        List<EpgCategoryItemWithPic> items = null;
        
        items = categoryItemService.getMovieByIndex(categoryCode,idx);
      
        this.fillContentPictureFullPath(request, items);

        model.addAttribute("data", JSONObject.fromObject(items.get(0)).toString());

        return SUCCESS;
        
        
    }
    
    
    
    
    /**
     * 获取指定栏目中指定序号的编排数据，带内容的海报.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getMovieListByIndex", method = RequestMethod.GET)
    public String getMovieListByIndex(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        int idx = Integer.parseInt(request.getParameter("idx"));
        int count = Integer.parseInt(request.getParameter("count"));
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        List<EpgCategoryItemWithPic> items = null;
        
        items = categoryItemService.getMovieListByIndex(categoryCode,idx,count);
      
        this.fillContentPictureFullPath(request, items);

        model.addAttribute("data", JSONArray.fromCollection(items).toString());

        return SUCCESS;
        
        
    }
    
    
  
    
    
    /**
     * 随机获取指定栏目中的编排数据，带内容的海报.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getRandomCategoryItemsByTypeWithPoster", method = RequestMethod.GET)
    public String getRandomCategoryItemsByTypeWithPoster(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
        String itemType = request.getParameter("type");
        String pageSize = request.getParameter("s");
        
        EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        epgContext.addContextParams(EpgContext.CATCODE, categoryCode);
        request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        if(StringUtils.isEmpty(categoryCode)){
            throw new InvalidaQueryParameterException("Parameter code must not been null.");
        }
        
        if(StringUtils.isEmpty(itemType)){
            itemType = "vod";
        }
        
        int pSize = DEFAULT_PAGESIZE;
        
        if(!StringUtils.isEmpty(pageSize) && StringUtils.isNumeric(pageSize)){
            pSize = Integer.parseInt(pageSize);
        }
        
        List<EpgCategoryItemWithPic> items = this.categoryItemService.getRandomCategoryItemsByTypeWithPoster(categoryCode, itemType, pSize);
        this.fillContentPictureFullPath(request, items);
        
        model.addAttribute("data", JSONArray.fromCollection(items).toString());
        return SUCCESS;
    }
    
    
    /**
     * 获取用户搜索的节目数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getSearchResult", method = RequestMethod.GET)
    public String getSearchResult(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
    	String currentPage = request.getParameter("p");
    	String pageSize = request.getParameter("s");
    	String keyword = request.getParameter("keyword");
        
        //EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        //epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        //epgContext.addContextParams(EpgContext.CATCODE, "collection");
        //request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        //if(StringUtils.isEmpty(businessCode)){
            //throw new InvalidaQueryParameterException("Parameter code must not been null.");
        //}
        
        int pSize = DEFAULT_PAGESIZE;
        int startRow = 0;
        
        if(!StringUtils.isEmpty(pageSize) && StringUtils.isNumeric(pageSize)){
            pSize = Integer.parseInt(pageSize);
        }
        
        if(!StringUtils.isEmpty(currentPage) && StringUtils.isNumeric(currentPage)) {
            int cPage = Integer.parseInt(currentPage);
        	if(cPage>0) {
        		startRow = caculateStartRow(cPage,pSize);
        	}
        }
        
        
      //获取总个数、总页数
        Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("initals", keyword);
		totalCount = programService.getTotalCount("queryProgramDetailByInitals",paramMap);
		totalPage = (int)Math.ceil((double)totalCount/pSize);
		
        List<SearchEpgProgram> items = programService.getProgramByKeyword(keyword,startRow,pSize);
        fillSearchPath(businessCode,categoryCode,request,items);
        
        JSONResult = new StringBuffer().append("{'totalCount':'")
        							   .append(totalCount)
        							   .append("','totalPage':'")
        							   .append(totalPage)
        							   .append("','JSONArray':")
        							   .append(JSONArray.fromCollection(items).toString())
        							   .append("}").toString();
        	
        
        model.addAttribute("data", JSONResult);
        return SUCCESS;
        
    }
    
    
    
    /**
     * 获取用户收藏的节目数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getMyCollection", method = RequestMethod.GET)
    public String getMyCollection(
    		@RequestParam(value="userMac", required=true) String userMac,
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
    	String currentPage = request.getParameter("p");
    	String pageSize = request.getParameter("s");
        
        //EpgContext epgContext = EpgContextFactory.createEpgContext(request);
        //epgContext.addContextParams(EpgContext.BIZCODE, businessCode);
        //epgContext.addContextParams(EpgContext.CATCODE, "collection");
        //request.setAttribute(EpgContext.CONTEXT_ATTR_NAME, epgContext.getContextParams());
        
        //if(StringUtils.isEmpty(businessCode)){
            //throw new InvalidaQueryParameterException("Parameter code must not been null.");
        //}
        
        int pSize = DEFAULT_PAGESIZE;
        int startRow = 0;
        
        if(!StringUtils.isEmpty(pageSize) && StringUtils.isNumeric(pageSize)){
            pSize = Integer.parseInt(pageSize);
        }
        
        if(!StringUtils.isEmpty(currentPage) && StringUtils.isNumeric(currentPage)) {
            int cPage = Integer.parseInt(currentPage);
        	if(cPage>0) {
        		startRow = caculateStartRow(cPage,pSize);
        	}
        }
       
        //EpgUserSession eus = EpgUserSession.findUserSession(request);
        
        //获取总页数
        Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("user_id", userMac);
		totalCount = collectionService.getTotalCount("getSevrialCollectionByUserId",paramMap);
		totalPage = (int)Math.ceil((double)totalCount/pSize);
		
		
        List<EpgUserCollection> items = collectionService.getCollection(userMac,startRow,pSize);
        fillCollectionPath(businessCode,categoryCode,request,items);
        
        JSONResult = new StringBuffer().append("{'totalPage':'")
        							   .append(totalPage)
        							   .append("','JSONArray':")
        							   .append(JSONArray.fromCollection(items).toString())
        							   .append("}").toString();
        	
        
        model.addAttribute("data", JSONResult);
        return SUCCESS;
    }
    
    /**
     * 节目加入用户收藏.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/addMyCollection", method = RequestMethod.GET)
    public String addMyCollection(
    		@RequestParam(value="userMac", required=true) String userMac,
    		@RequestParam(value="contentType", required=false) String contentType,
			@RequestParam(value="contentCode", required=true) String contentCode,
			@RequestParam(value="contentName", required=true) String contentName,
			@RequestParam(value="still", required=false) String still,
		        @RequestParam(value="hdType", required=false) String hdType,
			@RequestParam(value="bizCode", required=false) String bizCode,
			@RequestParam(value="categoryCode", required=false) String categoryCode,
			ModelMap model, HttpServletRequest request) {
    	
    	//EpgContext epgContext = EpgContextFactory.createEpgContext(request);
		
		EpgUserCollection epgUserCollection = new EpgUserCollection();
		epgUserCollection.setMacAddr(userMac);
		epgUserCollection.setUserId(userMac);
		epgUserCollection.setContentType(contentType);
		epgUserCollection.setContentCode(contentCode);
		epgUserCollection.setContentName(contentName);	
		epgUserCollection.setStill(still);
		epgUserCollection.setHdType(hdType);
		if (!"null".equals(bizCode)){
			epgUserCollection.setBizCode(bizCode);
		}
		if (!"null".equals(categoryCode)){
			epgUserCollection.setCategoryCode(categoryCode);
		}
		
		String collectResult = "collectSuccess";
		boolean exist = collectionService.existCollection(epgUserCollection);
		if (exist) {
			collectResult = "collectExist";
		}
		
		boolean limit = collectionService.limitCollection(epgUserCollection);
		if (!limit) {
			collectResult = "collectLimit";	
		}
		if("collectSuccess".equals(collectResult)) {
			collectionService.addCollection(epgUserCollection);
		}
		
		if (logger.isDebugEnabled()){
			logger.debug(epgUserCollection.toString());
		}
		//获取记录数
	        Map<String, Object> paramMap = new HashMap<String, Object>();
	        paramMap.put("user_id", userMac);
	        totalCount = collectionService.getTotalCount("getSevrialCollectionByUserId", paramMap);
	        addCollctionJSONResult = new StringBuffer().append("{'collectResult':")
	        	.append("'" + collectResult + "'").append(",'totalCount':'")
	        	.append(totalCount).append("'").append("}").toString();
		model.addAttribute("data", addCollctionJSONResult);
		return SUCCESS;
    }
    
    /**
     * 删除用户收藏的节目数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/delMyCollection", method = RequestMethod.GET)
    public String delMyCollection(@RequestParam("id") 
    		String collectionId, ModelMap model, HttpServletRequest request) {
    	
    	collectionService.delectCollection(collectionId);
    	model.addAttribute("data", "");
        return SUCCESS;
    }
    /**
     * 获取节目信息数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getProgramDetail", method = RequestMethod.GET)
    public String getProgramDetail(
    		@RequestParam(value="businessCode", required=true) String businessCode,
    		@RequestParam(value="categoryCode", required=false) String categoryCode,
    		@RequestParam(value="contentType", required=true) String contentType,
    		@RequestParam(value="contentCode", required=false) String contentCode,
			ModelMap model, HttpServletRequest request) {
    	
    	//if(StringUtils.isEmpty(categoryCode)){
        	//throw new InvalidaQueryParameterException("Parameter code must not been null.");
    	//}
    	EpgProgram ep = this.programService.getProgramByContentCode(contentCode);
    	ep.setPosterFullPath(this.getPictureRealPath(request, ep.getPoster()));
    	String url = NavigatorFactory.createVODIndexUrl(
                ep.getContentType(), ep.getContentCode(), categoryCode,
                businessCode, businessCode, categoryCode, request);
    		//IndexUrlGenerator.createUrl(request, ep);
    	ep.setIndexUrl(url);
    			
    	model.addAttribute("data", JSONObject.fromObject(ep).toString());
        return SUCCESS;
    }
    
    
    
    
    /**
     * 获取节目播放数据.
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getPlayableContentByContentCode", method = RequestMethod.GET)
    public String getPlayableContentByContentCode(ModelMap model, HttpServletRequest request) {
    	
    	//if(StringUtils.isEmpty(categoryCode)){
        	//throw new InvalidaQueryParameterException("Parameter code must not been null.");
    	//}
    	String contentCode = request.getParameter("contentCode");
    	
    	EpgPlayableContent epc = playerService.searchContentByContentCode(contentCode);
    			
    	model.addAttribute("data", JSONObject.fromObject(epc).toString());
        return SUCCESS;
    }
    
    
    
    
    
    /**
	 * 对收费类型的服务的purchaseType做设置
	 * @param eco
	 * @param playParams
	 */
	private List<EpgHostProFile> paramsPreHandler(EpgContentOffering eco,
			List<EpgHostProFile> playParams) {
		List<EpgHostProFile> params = new ArrayList<EpgHostProFile>();
		EpgHostProFile epf;
		for(EpgHostProFile profile:playParams){
			epf = new EpgHostProFile();
			epf.setGroupId(profile.getGroupId());
			epf.setHostCode(profile.getHostCode());
			epf.setHostIp(profile.getHostIp());
			epf.setHostName(profile.getHostName());
			epf.setId(profile.getId());
			epf.setName(profile.getName());
			epf.setStatus(profile.getStatus());
			epf.setValue(profile.getValue());
			params.add(epf);
		}
		String serviceTypes = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.NEED_AUTH_SERVICE_TYPE);
		String[] authServices = serviceTypes.split(",");		
		for(int i=0;i<authServices.length;i++){
			if (eco.getServiceType().equals(authServices[i])){
				 for(int k=0;params!=null && k<params.size();k++){
		                if("purchase_type".equals(params.get(k).getName())){
		                	params.get(k).setValue(HAS_ORDER_PURCHSE_TYPE);
		                    //break;
		                }
		          }
				break;
			}
		}
		return params;
	} 
    
    /**
     * 返回连续剧的单集的contentCode
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getSeriesProgramContentCode", method = RequestMethod.GET)
    public String getSeriesProgramContentCode(
    		@RequestParam(value="seriesCode", required=true) String seriesCode,
    		@RequestParam(value="episodeIndex", required=true) int episodeIndex,
    		ModelMap model, HttpServletRequest request) {
    	
    	EpgEpisode epi = this.playerService.searchContentCodeBySeriesCodeAndEpisodeIndex(seriesCode,episodeIndex);

    	model.addAttribute("data", JSONObject.fromObject(epi).toString());
        return SUCCESS;
    }
    
    
    
    /**
     * 返回连续剧的单集的播放信息
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getPlayableProgramBySeriesCodeAndEpisodeIndex", method = RequestMethod.GET)
    public String getPlayableProgramBySeriesCodeAndEpisodeIndex(
    		@RequestParam(value="seriesCode", required=true) String seriesCode,
    		@RequestParam(value="episodeIndex", required=true) int episodeIndex,
    		ModelMap model, HttpServletRequest request) {
    	
    	EpgPlayableContent epc = this.playerService.searchPlayableProgramBySeriesCodeAndEpisodeIndex(seriesCode,episodeIndex);

    	model.addAttribute("data", JSONObject.fromObject(epc).toString());
        return SUCCESS;
    }
    
    /**
     * 页面离开时获取当前页面页数及焦点位置
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getPageIndexAndLeaveFocusId", method = RequestMethod.GET)
    public void getPageIndexAndLeaveFocusId(
    		@RequestParam(value="pageIndex", required=true) String pageIndex,
    		@RequestParam(value="leaveFocusId", required=true) String leaveFocusId,
    		@RequestParam(value="isRemember", required=true) String isRemember,
    		HttpServletRequest request) {

    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	
    	if("1".equals(isRemember)) {
    		eus.setPageIndex(pageIndex);
    		eus.setLeaveFocusId(leaveFocusId);
    	}else{
    		eus.setPageIndex(null);
    		eus.setLeaveFocusId(null);
    	}
    	
    }
    
    
    /**
     * 按返回按钮时执行设置当前页面是按返回键返回的
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getHistoryBackMark", method = RequestMethod.GET)
    public String getHistoryBackMark(ModelMap model,HttpServletRequest request) {

    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	
    	eus.setHistoryBackMark("1");
  
    	model.addAttribute("data", "1");
    	return SUCCESS;
    	
    }
    
    /**
     * 页面加载完时设置清空当前页面的返回值标记
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/getNoHistoryBackMark", method = RequestMethod.GET)
    public void getNoHistoryBackMark(HttpServletRequest request) {

    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	
    	eus.setPageIndex(null);
		eus.setLeaveFocusId(null);
    	eus.setHistoryBackMark(null);

    }
    /**
     * 异步鉴权获取多剧集下一集播放地址. by cc
     * @param 
     * @param 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getNextSeriesPlayUrl", method = RequestMethod.GET)
    public String getNextSeriesPlayUrl(
    		@RequestParam(value="contentCode", required=true) String contentCode,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	EpgContentOffering nextOffering = null;//下一集offering
    	StartResponse nextStartResponse = null;//下一集rtsp链接
    	EpgPlayableContent nextEpc = null;//下一集内容信息
    	EpgContentOffering previousOffering = null;//上一集offering
    	StartResponse previousStartResponse = null;//上一集rtsp链接
    	EpgPlayableContent previousEpc = null;//上一集内容信息
    	String nextContentCode = "";
    	String previousContentCode = "";
    	EpgEpisode ee = episodeService.getEpisodeByContentCode(contentCode);//获取当前剧头信息
    	int episodeIndex = ee.getEpisodeIndex();//当前集数
    	//获取剧集列表
    	List<EpgEpisode> eeList = episodeService.getEpisodeByCode(ee.getSeriesCode());
    	//获取剧头
    	EpgSeries series =  programService.getSeriesByContentCode(ee.getSeriesCode());
    	
    	//上一集
//    	int previousEpisodeIndex = 1;
//    	if(episodeIndex == eeList.get(0).getEpisodeIndex()){
//    		//若当前集数为第一集
//    		previousEpisodeIndex = episodeIndex;
//    	}else{
//    		previousEpisodeIndex = episodeIndex - 1;//上一集集数
//    	}
    	
    	int previousEpisodeIndex = episodeIndex - 1;//上一集集数 如果无下一集 返回json为空
    	
    	//下一集集数
//    	int nextEpisodeIndex = eeList.get((eeList.size()-1)).getEpisodeIndex();
//    	if(episodeIndex == nextEpisodeIndex){
//    		nextEpisodeIndex = episodeIndex;
//    	}else{
//    		nextEpisodeIndex = episodeIndex + 1;
//    	}
    	int nextEpisodeIndex = episodeIndex + 1; //下一集集数 如果无下一集 返回json为空
    	
    	//取上下集的contentcode
    	for (int i = 0; i<eeList.size(); i++) {
    		EpgEpisode epgEpisode = eeList.get(i);
    		if(epgEpisode.getEpisodeIndex() == nextEpisodeIndex){
    			nextContentCode =  epgEpisode.getContentCode();
    		}else if(epgEpisode.getEpisodeIndex() == previousEpisodeIndex){
    			previousContentCode = epgEpisode.getContentCode();
    		}
		}
    	
    	try {
    		if (!StringUtils.isEmpty(nextContentCode)){
    			nextEpc = playerService.searchContentByContentCode(nextContentCode);
        		if(nextEpc.getEpgContentOfferings().size()<=0 || nextEpc.getEpgContentOfferings() == null) {
        			model.addAttribute("data", JSONResult);
        	        return SUCCESS;
        		}
        		nextOffering = nextEpc.getEpgContentOfferings().get(0);
        		nextStartResponse = aaaService.getRtspUrl(eus.getUserData(), nextOffering.getOfferingId(), nextOffering.getServiceCode());
    		}

    		if(!StringUtils.isEmpty(previousContentCode)){
    			previousEpc = playerService.searchContentByContentCode(previousContentCode);
    			if(previousEpc.getEpgContentOfferings().size()<=0 || previousEpc.getEpgContentOfferings() == null) {
        			model.addAttribute("data", JSONResult);
        	        return SUCCESS;
        		}
    			previousOffering = previousEpc.getEpgContentOfferings().get(0);
    			previousStartResponse = aaaService.getRtspUrl(eus.getUserData(), previousOffering.getOfferingId(), previousOffering.getServiceCode());
    		}
		} catch (BoException ex) {
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createAuthErrorLog(eus, "-",
                                "-", nextOffering, ex.getErrorCode()));
            }
            throw ex;
        }
    	
		StringBuffer result = new StringBuffer();
		result = new StringBuffer().append("{\"EpgData\":").append("[");
		if (!StringUtils.isEmpty(previousContentCode)){													//有上一集
			result.append("{\"tagName\":") 
			.append("\"previousAsset\"").append(",\"tagAttribute\":")
			.append("{\"code\":").append("\"0\"")														//code: 0 有上一集或下一集, 1 当前第一集或最后一集
			.append(",\"contentCode\":").append("\"" + previousContentCode + "\"")
			.append(",\"seriesCode\":").append("\"" + ee.getSeriesCode() + "\"")
			.append(",\"episodeIndex\":").append("\"" + previousEpisodeIndex + "\"")
			.append(",\"startResponse\":")
	    	.append(JSONObject.fromObject(previousStartResponse).toString())
	    	.append(",\"PROGRAM\":")
	    	.append(JSONObject.fromObject(previousEpc.copy(previousOffering)).toString())
	    	.append("}}");
		}else if(episodeIndex == 1){																	//第一集
			result.append("{\"tagName\":") 
			.append("\"previousAsset\"").append(",\"tagAttribute\":")
			.append("{\"code\":").append("\"1\"")
			.append("}}");
		}
		if ((!StringUtils.isEmpty(previousContentCode)||episodeIndex == 1)&&(!StringUtils.isEmpty(nextContentCode)||episodeIndex == series.getEpisodeNumber())){			
			result.append(",");
		}
		if (!StringUtils.isEmpty(nextContentCode)){
			result.append("{\"tagName\":")
			.append("\"nextAsset\"").append(",\"tagAttribute\":")
			.append("{\"code\":").append("\"0\"")	
	    	.append(",\"contentCode\":").append("\"" + nextContentCode + "\"")
	    	.append(",\"seriesCode\":").append("\"" + ee.getSeriesCode() + "\"")
	    	.append(",\"episodeIndex\":").append("\"" + nextEpisodeIndex + "\"")
	    	.append(",\"startResponse\":")
	    	.append(JSONObject.fromObject(nextStartResponse).toString())
	    	.append(",\"PROGRAM\":")
	    	.append(JSONObject.fromObject(nextEpc.copy(nextOffering)).toString())
	    	.append("}}");
		}else if(episodeIndex == series.getEpisodeNumber()){											//最后一集
			result.append("{\"tagName\":") 
			.append("\"nextAsset\"").append(",\"tagAttribute\":")
			.append("{\"code\":").append("\"1\"")
			.append("}}");
		}
		result.append("]}");
    	JSONResult = result.toString();
    	model.addAttribute("data", JSONResult);
    	
		return SUCCESS;
    }
    
    /**
     * 异步鉴权某个节目. by cc
     * @param 
     * @param 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getRtsp", method = RequestMethod.GET)
    public String getRtsp(
    		@RequestParam(value="contentCode", required=true) String contentCode,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	EpgContentOffering offering = null;
    	StartResponse startResponse = null;
    	EpgPlayableContent epc = null;

    	try {
			epc = playerService.searchContentByContentCode(contentCode);
    		if(epc.getEpgContentOfferings().size()<=0 || epc.getEpgContentOfferings() == null) {
    			model.addAttribute("data", JSONResult);
    	        return SUCCESS;
    		}
    		offering = epc.getEpgContentOfferings().get(0);
    		startResponse = aaaService.getRtspUrl(eus.getUserData(), offering.getOfferingId(), offering.getServiceCode());
		} catch (BoException ex) {
            if (EpgLogFactory.getErrorLogger().isInfoEnabled()) {
                EpgLogFactory.getErrorLogger().info(
                        EpgLogGenerator.createAuthErrorLog(eus, "-",
                                "-", offering, ex.getErrorCode()));
            }
            throw ex;
        }
        if(startResponse != null){
        	JSONResult = new StringBuffer().append("{\"contentCode\":")
				.append("\"" + contentCode + "\"").append(",\"startResponse\":")
				.append(JSONObject.fromObject(startResponse).toString())
				.append(",\"PROGRAM\":")
				.append(JSONObject.fromObject(epc.copy(offering)).toString())
				.append("}").toString();
        	model.addAttribute("data", JSONResult);
        }
		return SUCCESS;
    }
    
    /**
     * 异步获取某个节目的书签. by cc
     * @param 
     * @param 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getProgramBookmark", method = RequestMethod.GET)
    public String getProgramBookmark(
    		@RequestParam(value="userId", required=true) String userId,
    		@RequestParam(value="contentCode", required=true) String contentCode,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	EpgUserBookmark eub = bookmarkService.getBookmark(userId, contentCode);
    	
    	//if(eub != null){
        	model.addAttribute("data", JSONObject.fromObject(eub));
        //}else{
        //	model.addAttribute("data", "null");
        //}
		return SUCCESS;
    	
    }
    /**
     * 异步获取添加剧集书签. by cc
     * @param 
     * @param 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/addSeriesMark", method = RequestMethod.GET)
    public String addSeriesMark(
    		@RequestParam(value="seriesCode", required=true) String seriesCode,
    		@RequestParam(value="episodeIndex", required=true) String episodeIndex,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	EpgUserSession eus = EpgUserSession.findUserSession(request);
    	if(!StringUtils.isBlank(seriesCode)&&!StringUtils.isBlank(episodeIndex)) {
			EpgUserSeriesmark epgUserSeriesmark = new EpgUserSeriesmark();
			epgUserSeriesmark.setContentCode(seriesCode);
			epgUserSeriesmark.setEpisodeIndex(Integer.parseInt(episodeIndex));
			
			epgUserSeriesmark.setUserId(eus.getUserAccount());
			
			seriesmarkService.addSeriesmark(epgUserSeriesmark);
		}
		return SUCCESS;
    	
    }
    
    
    /**
     * 计算查询开始位置.
     * @param currentPage
     * @param pageSize
     * @return
     */
    private int caculateStartRow(int currentPage,int pageSize) {
        return (currentPage-1) * pageSize;
    }
    
    
    private void fillPictureFullPath(HttpServletRequest request,List<EpgCategoryItem> items){
        for (EpgCategoryItem epgCategoryItem : items) {
            if(StringUtils.isNotBlank(epgCategoryItem.getItemIcon())){
                epgCategoryItem.setItemIconFullPath(this.getPictureRealPath(request, epgCategoryItem.getItemIcon()));
            }
            String url = IndexUrlGenerator.createUrl(request, epgCategoryItem);
            epgCategoryItem.setIndexUrl(url);
        }
    }
    
    private void fillContentPictureFullPath(HttpServletRequest request,List<EpgCategoryItemWithPic> items){
        for (EpgCategoryItemWithPic item : items) {
            if(!StringUtils.isBlank(item.getIcon())){
                item.setIconFullPath(this.getPictureRealPath(request,item.getIcon()));
            }
            
            //if(!StringUtils.isBlank(item.getPoster())){
                item.setPosterFullPath(this.getPictureRealPath(request, item.getPoster()));
            //}
            
            if(!StringUtils.isBlank(item.getStill())){
                item.setStillFullPath(this.getPictureRealPath(request, item.getStill()));
            }
            if(!StringUtils.isBlank(item.getItemIcon())){
            	item.setItemIconFullPath(this.getPictureRealPath(request, item.getItemIcon()));
            }
            String url = IndexUrlGenerator.createUrl(request, item);
            item.setIndexUrl(url);
        }
    }
    
    private void fillCollectionPath(String businessCode,String categoryCode,HttpServletRequest request,List<EpgUserCollection> items) {
    	for (EpgUserCollection epgUserCollection : items) {
    		String url = NavigatorFactory.createUserCollectionIndexUrl(epgUserCollection,businessCode,categoryCode,request);
    		String delUrl = CollectionUrlGenerator.createDeleteUrl(request, epgUserCollection);
    		epgUserCollection.setIndexUrl(url);
    		epgUserCollection.setDelCollectionUrl(delUrl);
        }
    	
    }
    
    private void fillSearchPath(String businessCode,String categoryCode,HttpServletRequest request,List<SearchEpgProgram> items) {
    	for (SearchEpgProgram sep : items) {
    		String url = NavigatorFactory.createVODIndexUrl(sep.getContentType(), sep.getContentCode(), categoryCode, businessCode, businessCode, categoryCode, request);
    		sep.setIndexUrl(url);
        }
    }
    
    private String getPictureRealPath(HttpServletRequest request,String resourcePath) {
        String resourceRoot = EpgConfigUtils.getInstance().getProperty("resource.root.path");
        return PathWraper.wrape(new String[]{request.getContextPath(),resourceRoot,resourcePath}, true);
    }
    

    private void fillBookmarkIndexAndDeleteUrl(HttpServletRequest request, List<EpgUserBookmark> eubs){
        for (EpgUserBookmark epgUserBookmark : eubs) {
            String indexUrl = IndexUrlGenerator.createUrl(request, epgUserBookmark);
            String deleteUrl = BookmarkUrlGenerator.createDeleteUrl(request, epgUserBookmark);
            epgUserBookmark.setIndexUrl(indexUrl);
            epgUserBookmark.setDeleteUrl(deleteUrl);
        }
    }
    
    
    public static void main(String[] args) {
        EpgCategoryItem[] items = new EpgCategoryItem[5];
        for(int i = 0; i < 5; i++){
            EpgCategoryItem item = new EpgCategoryItem();
            item.setId(new Long(i));
            item.setItemCode("code_" + i);
            items[i] = item;
            
        }
        System.out.println(JSONArray.fromArray(items).toString());
    }
    
    
}
