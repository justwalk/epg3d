<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
%>
<% 

	String leaveFocusId = request.getParameter("leaveFocusId");
	if(leaveFocusId!=null&&leaveFocusId!=""){
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId) ;
	}
%>
<html>



<!-- 查询节目信息 22-->
<epg:query queryName="queryProgramDetailByCode" var="program">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<epg:set value="1" var="ProgramBodyType"/>
<epg:set value="1" var="hdType"/>
<epg:set value="0" var="sdType"/>
<epg:if test="${program.relCode!=null}">
	<!-- HD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="HDrelContent" >
		<epg:param name="relCode" value="${program.relCode}" type="java.lang.String"/>
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
		<epg:param name="videoType" value="${hdType}" type="java.lang.Integer"/>
		<epg:param name="type" value="vod" type="java.lang.String"/>
	</epg:query>
	<!-- SD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="SDrelContent" >
		<epg:param name="relCode" value="${program.relCode}" type="java.lang.String"/>
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
		<epg:param name="videoType" value="${sdType}" type="java.lang.Integer"/>
		<epg:param name="type" value="vod" type="java.lang.String"/>
	</epg:query>
</epg:if>

<!-- 右下方推荐随机内容  -->
<epg:set var="tags" value="${fn:split(program.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>
<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="5" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String"/>
	<epg:param name="selfCode" value="${program.contentCode}" type="java.lang.String"/>
	<epg:param name="mainFolder" value="${program.mainFolder}" type="java.lang.String"/>
</epg:query>

<!-- 右下方推荐随机内容  -->
<epg:set var="tags" value="${fn:split(program.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>
<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="5" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String"/>
	<epg:param name="selfCode" value="${program.contentCode}" type="java.lang.String"/>
	<epg:param name="mainFolder" value="${program.mainFolder}" type="java.lang.String"/>
</epg:query>

<!-- 播放、收藏、返回 -->
<epg:navUrl obj="${program}" playUrlVar="playUrl" ></epg:navUrl>
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>

<!-- 节目简介与主演 -->
<epg:text left="0" top="0" width="850" height="210" chineseCharWidth="22"
 multi="true" output="false" lines="summarys" lineNum="3">${program.summaryMedium}</epg:text>

<!-- 回点播首页 -->
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style>
	img{	
		border:0px;
	}
	#info_span{
		display:block;
		line-height:41px;
		height:35px;
	}
	body{
		color:#FFFFFF;
		font-size:22;
		font-family:"黑体";
	}
	a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script type="text/javascript">
var imgPath = "${context['EPG_CONTEXT']}/common/images";
var _level = "${program.reserve1}";
var _ajaxObj = null;
var leaveFocusId;
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
function returnToBizOrHistory(){
	if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
		window.location.href="${returnUrl}";
	}else{
		history.back();
	}
}
function init(){
	setTimeout('$("play_a").focus()',400);
}
//收藏AJAX
function addCollection(){
	var encodeContentName = encodeURIComponent("${program.title}");
	var encodeContentImg = encodeURIComponent("${program.still}");
	var ajax_url = "${context['EPG_CONTEXT']}/addMyCollection.do?userMac=${EPG_USER.userAccount}&contentType=vod&contentCode=${program.contentCode}&contentName="+encodeContentName+"&still="+encodeContentImg+"&bizCode=${context['EPG_BUSINESS_CODE']}&categoryCode=${context['EPG_CATEGORY_CODE']}&hdType=${program.hdType}";
	_ajaxObj = new AJAX_OBJ(ajax_url,addColResponse);
	_ajaxObj.requestData();
}
function addColResponse(xmlHttpResponse){
	var result = eval("("+xmlHttpResponse.responseText+")");
	displayDiv("none");
	if(result.collectResult=='collectSuccess'){
		$("collectSuccess").style.display = "block";
		$("tsBtn").style.display = "block";
		$("successTs_span").innerHTML ="收藏夹中共有<font color=#00fcff>"+result.totalCount+"</font>部片子";
	}else if(result.collectResult=='collectExist'){
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="您已经收藏过此节目。";
	}else if(result.collectResult=='collectLimit'){
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="收藏节目数量超出最大限制。";
	}else{
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="节目收藏失败。";
	}
     setTimeout('$("enter_a").focus()',400);
}

//收藏提示消失
function hiddenTip(){
	$("failTs_span").innerHTML ="";
	$("successTs_span").innerHTML ="";
	$("collectSuccess").style.display = "none";
	$("collectFail").style.display = "none";
	$("tsBtn").style.display = "none";
	displayDiv("block");	
	$("addCol_a").focus();
}

//弹窗时隐藏层下a
function displayDiv(_set){
	 var el = [];
     el = document.getElementsByTagName('a'); 
     for(var i=0,len=el.length; i<len ;i++){
     	if(el[i].id !="Collection_a" && el[i].id !="enter_a"){
     		$(el[i].id).style.display = _set;
     	}
     }
}


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img){
	leaveFocusId = objId; 
	$(objId+"_img").src=imgPath+"/"+img+".png";
}
//失去焦点事件
function itemOnBlur(objId){
	$(objId+"_img").src=imgPath+"/dot.gif";
}

//获取字符长度
function len(s) { 
	var l = 0; 
	var a = s.split(""); 
	for (var i=0;i<a.length;i++) { 
	if (a[i].charCodeAt(0)<299) { 
	l++; 
	} else { 
	l+=2; 
	} 
	} 
	return l; 
}

//海报焦点事件
function textOnFocus(objId,img,itemId,title){
	document.getElementById("posterImg"+objId+"_img").src=imgPath+"/"+img+".png";
	document.getElementById(itemId).style.visibility="visible";
	var textContent = title;//document.getElementById("posterImg"+objId+"_span").innerHTML;
	var textLen = len(textContent);
	textContent = textContent.replace(/^\s+|\s+$/g,"");
	if(textContent.substring(0,3)=="HD_"){
		textContent = textContent.substring(3,textLen);
	}
	if(len(textContent)<=10){
	    document.getElementById(itemId).style.height="31px"; 
	 	document.getElementById(itemId).style.top="632px";
		 
	}else if(len(textContent)>10&&len(textContent)<=20){
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
	}else {
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
		 textContent = textContent.substring(0,8)+"…";
	}
	document.getElementById("posterImg"+objId+"_span").innerHTML = textContent;
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById(itemId).style.visibility="hidden";
}



//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function menuOnFocus(objId,focusImg){
	document.getElementById(objId+"_img").src=imgPath+"/"+focusImg+".png";
}
//失去焦点事件
function menuOnBlur(objId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
}
function back(){
 	returnToBizOrHistory();
 }
  function exit(){
 	document.location.href = "${returnToHomeUrl}";
 }
 
 function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SITV_KEY_UP":
	    	break;
		case "SITV_KEY_DOWN":
	    	break;
		case "EIS_IRKEY_SELECT":
			break;
		case "SITV_KEY_LEFT":
	    	break;
		case "SITV_KEY_RIGHT":
	    	break;
	    case "SITV_KEY_PAGEUP":
	    	break;
	    case "SITV_KEY_PAGEDOWN":
	    	break;
	    case "SITV_KEY_BACK":
	    	back();
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			exit();
			return 0;
			break;
	  case "SITV_KEY_MENU":
			iPanel.focus.display = 1;
			iPanel.focus.border = 1;
			iPanel.eventFrame.openIndex();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>
<epg:body onload="init();"   bgcolor="#000000" width="1280" height="720">
<epg:img src="/common/images/vod_detail.jpg" id="main"  left="0" top="0" width="1280" height="720"/>
<epg:img src="/common/images/logo.png" left="0" top="0" width="350" height="85"/>
<epg:if test="${fn:startsWith(program.title,'HD_') == true }">
	<epg:img src="/common/images/hd_cinema_title.png" left="229" top="42" width="118" height="44"/>
</epg:if>
<epg:if test="${fn:startsWith(program.title,'HD_') != true }">
	<epg:img src="/common/images/sd_cinema_title.png" left="229" top="42" width="118" height="44"/>
</epg:if>
<!-- 节目名 -->
<epg:text fontSize="32" color="#e74c3c" left="345" top="101" width="620" height="50" align="left" chineseCharNumber="17" text="${program.title}"></epg:text>

<!-- 地区 -->
<epg:text fontSize="22" color="#333333" left="350" top="193" width="85" height="32" align="left"  text="地区："></epg:text>
<epg:text fontSize="22" color="#333333" left="419" top="193" width="546" height="32" chineseCharNumber="17" align="left" text="${program.countryOfOrigin}"></epg:text>

<!-- 年份 -->
<epg:text fontSize="22" color="#333333" left="350" top="225" width="85" height="32" align="left"  text="年份："></epg:text>
<epg:text fontSize="22" color="#333333" left="419" top="225" width="546" height="32" chineseCharNumber="17" align="left" text="${program.year}"></epg:text>


<!-- 片长 -->
<epg:text fontSize="22" color="#333333" left="350" top="258" width="85" height="32" align="left"  text="片长："></epg:text>
<epg:text fontSize="22" color="#333333" left="419" top="258" width="546" height="32" chineseCharNumber="17" align="left" text="${program.displayRunTime}分钟"></epg:text>
<!-- 导演 -->
<epg:text fontSize="21" color="#333333" left="80" top="433" width="80" height="27" align="left"  text="导演："></epg:text>
<epg:if test="${program.director!=null}">
	<epg:text id="directorImg" fontSize="21" color="#333333" left="137" top="433" width="200" height="30" chineseCharNumber="9" align="left"  dotdotdot="…" text="${program.director}"></epg:text>
</epg:if>
<!-- 主演 -->
<epg:text fontSize="21" color="#333333" left="80" top="465" width="80" height="27" align="left"  text="主演："></epg:text>
<epg:set var="actors" value="${fn:replace(program.actors, '，',',')}"></epg:set>
<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>

<epg:if test="${actors==''}">
<epg:text fontSize="21" color="#333333" left="137" top="465" width="133" height="22" align="left" text="无"></epg:text>
</epg:if>
<epg:text fontSize="21" color="#333333" left="137" top="465" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[0]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="505" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[1]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="545" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[2]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="585" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[3]}"></epg:text>

<!-- 播放收藏 -->
<epg:img id="play" onblur="itemOnBlur('play');" left="350" top="151" onfocus="itemOnFocus('play','playFocus')" src="/common/images/dot.gif" width="130" height="30"  href="${playUrl}" />
<epg:if test="${program.hdType=='1'}">
	<epg:if test="${SDrelContent!=null}">
		<epg:if test="${SDrelContent.relCodeFlag==1}">
			<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl"/>
			<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="490" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="/common/images/goSDBtn.png" width="130" height="30"  href="${SDplayUrl}"/>
			
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="630" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="630" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
		<epg:if test="${SDrelContent.relCodeFlag==0}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
	</epg:if>
	<epg:if test="${SDrelContent==null}">
		<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
		<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
		<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
	</epg:if>
</epg:if>

<epg:if test="${program.hdType=='0'}">
	<epg:if test="${HDrelContent!=null}">
		<epg:if test="${HDrelContent.relCodeFlag==1}">
			<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl"/>
			<epg:img  onblur="itemOnBlur('goHDorSDFocus');" left="490" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="/common/images/goHDBtn.png" width="130" height="30"  href="${HDplayUrl}"/>
			
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="630" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="630" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
		<epg:if test="${HDrelContent.relCodeFlag==0}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
	</epg:if>
	<epg:if test="${HDrelContent==null}">
		<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl"/>
		<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
		<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
	</epg:if>
</epg:if>
<epg:img id="goHDorSDFocus" left="490" top="151" src="/common/images/dot.gif" width="130" height="30" />
	<!-- 内容详情 -->

<epg:text fontSize="22" color="#333333" id="info" left="350" top="287" width="850" height="35" align="left" text="${summarys[0].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="350" top="320" width="850" height="35" align="left" text="${summarys[1].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="350" top="353" width="850" height="35" align="left" text="${summarys[2].content}"></epg:text>
<!-- 内容海报 -->
<epg:img id="poster" left="80" top="93"  width="220" height="330" src="../${program.icon}"/>
<!-- 猜你喜欢内容 -->
<epg:if test="${bottomCategoryItems[0]!=null}">
	<epg:img id="posterImg0" src="/common/images/dot.gif" left="347" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1" ></epg:navUrl>
	<epg:img id="poster1" src="../${bottomCategoryItems[0].still}" left="350" 
		top="468" width="130" height="195"/>
	<epg:img id="poster1focus" src="/common/images/dot.gif" left="350" 
		top="468" width="130" height="195"  href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','${bottomCategoryItems[0].title}');" 
		onblur="textOnBlur('posterImg0','categoryList0_titlediv');"/>
	<div id="categoryList0_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:350px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg0"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg0_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>
	</div>
</epg:if>

<epg:if test="${bottomCategoryItems[1]!=null}">
	<epg:img id="posterImg1" src="/common/images/dot.gif" left="527" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2" ></epg:navUrl>
	<epg:img id="poster2" src="../${bottomCategoryItems[1].still}" left="530" 
		top="468" width="130" height="195"/>
	<epg:img id="poster2focus" src="/common/images/dot.gif" left="530" 
		top="468" width="130" height="195"  href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','${bottomCategoryItems[1].title}');" 
		onblur="textOnBlur('posterImg1','categoryList1_titlediv');"/>
	<div id="categoryList1_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:530px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg1"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg1_span"  style="color:#ffffff;font-size:22;height:26px"  ></span>
	    </div>  	
	</div>
</epg:if>
	
<epg:if test="${bottomCategoryItems[2]!=null}">
	<epg:img id="posterImg2" src="/common/images/dot.gif" left="707" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3" ></epg:navUrl>
	<epg:img id="poster3" src="../${bottomCategoryItems[2].still}" left="710" 
		top="468" width="130" height="195" />
	<epg:img id="poster3focus" src="/common/images/dot.gif" left="710" 
		top="468" width="130" height="195"  href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','${bottomCategoryItems[2].title}');" 
		onblur="textOnBlur('posterImg2','categoryList2_titlediv');"/>		
	<div id="categoryList2_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:710px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg2"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg2_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[3]!=null}">
	<epg:img id="posterImg3" src="/common/images/dot.gif" left="887" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4" ></epg:navUrl>
	<epg:img id="poster4" src="../${bottomCategoryItems[3].still}" left="890" 
		top="468" width="130" height="195"/>
	<epg:img id="poster4focus" src="/common/images/dot.gif" left="890" 
		top="468" width="130" height="195"  href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','${bottomCategoryItems[3].title}');" 
		onblur="textOnBlur('posterImg3','categoryList3_titlediv');"/>
	<div id="categoryList3_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:890px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg3"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg3_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[4]!=null}">
	<epg:img id="posterImg4" src="/common/images/dot.gif" left="1067" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5" ></epg:navUrl>
	<epg:img id="poster5" src="../${bottomCategoryItems[4].still}" left="1070" 
		top="468" width="130" height="195"/>
	<epg:img id="poster5focus" src="/common/images/dot.gif" left="1070" 
		top="468" width="130" height="195"  href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','${bottomCategoryItems[4].title}');" 
		onblur="textOnBlur('posterImg4','categoryList4_titlediv');"/>
	<div id="categoryList4_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:1070px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg4"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg4_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>

<!-- 搜索,收藏,历史,返回 -->
<epg:img src="/common/images/dot.gif" id="ss"  left="949" top="47" width="80" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />

<epg:img src="/common/images/dot.gif" id="zz"  left="1050" top="47" width="80" height="38"
	href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');"  onblur="itemOnBlur('zz');" />

<epg:img src="/common/images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />

<!-- 收藏提示框 -->
<div id="collectSuccess" style="display:none;" >
	<epg:img id="tip"  src="/common/images/collectSuccess.png" left="0" top="0" width="1280" height="720"/>
	<epg:text id="successTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="collectFail" style="display:none;" >
	<epg:img id="tip"  src="/common/images/collectFail.png"  left="0" top="0" width="1280" height="720"/>
	<epg:text id="failTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="tsBtn" style="display:none;" >
	<epg:img id="Collection"   left="481" top="412"  onfocus="itemOnFocus('Collection','enterColl');"  onblur="itemOnBlur('Collection');"  src="/common/images/dot.gif" width="130" height="40"  href="${context['EPG_MYCOLLECTION_URL']}" />
	<epg:img id="enter"   left="671" top="412"  onfocus="itemOnFocus('enter','closeWin');"  onblur="itemOnBlur('enter');"  src="/common/images/dot.gif" width="130" height="40"  href="javascript:hiddenTip()" />
</div>

</epg:body>
</html>