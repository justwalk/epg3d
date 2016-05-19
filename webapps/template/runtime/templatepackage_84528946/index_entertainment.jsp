<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
	String from = request.getParameter("from");
	EpgUserSession eus = EpgUserSession.findUserSession(request);
	String eusLeaveFocusId = eus.getPlayFocusId() ;
	if(eusLeaveFocusId!=null){
		request.setAttribute("leaveFocusId",eusLeaveFocusId) ;
	}else{
		String myleaveFocusId = request.getParameter("leaveFocusId");
		if(myleaveFocusId!=null&&myleaveFocusId!=""){
			request.setAttribute("leaveFocusId",myleaveFocusId) ;
		}
	}
%>

<epg:html>
<!-- 菜单  -->
<epg:query queryName="getSeverialItems" maxRows="6" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左侧大图推荐  -->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftBigImgCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftBigImgCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 最热排行榜 -->
<epg:query queryName="getSeverialItems" maxRows="5" var="hotCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['hotCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右下推荐 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="4" var="rightDownCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!--八卦爆料台  -->
<epg:query queryName="getSeverialItems" maxRows="4" var="gossipCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['gossipCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 中间推荐固定推荐写死1 running man -->
<epg:query queryName="getSeverialItems" maxRows="2" var="centerCategoryItems0" >
	<epg:param name="categoryCode" value="ccms_category_300962326682" type="java.lang.String"/>
</epg:query>
<!-- 中间推荐固定推荐写死2 康熙来了 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="centerCategoryItems1" >
	<epg:param name="categoryCode" value="ccms_category_300962326657" type="java.lang.String"/>
</epg:query>
<!-- 中间推荐固定推荐写死3 生活看吧 -->
<epg:query queryName="getSeverialItems" maxRows="6" var="centerCategoryItems2" >
	<epg:param name="categoryCode" value="category_30271845" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
<style type="text/css">
	img{border:0px solid black;}
	body{
		color:#FFFFFF;
		font-size:24;
		font-family:"黑体";
	}
	a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//监听事件
function back(){
 	document.location.href = "${returnHomeUrl}";
}
function exit(){
	document.location.href = "${returnHomeUrl}";
}
//监听事件
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SYSTEM_EVENT_ONLOAD":
			pageLoad = true;
			break;
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

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,color){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_focus"+"_img").src=imgPath+"/"+img+".png";
		document.getElementById("r_"+objId+"_focus"+"_img").src=imgPath+"/"+img+".png";
		if(typeof(color)!="undefined"){
			document.getElementById(objId+"_span").style.color=color;
			document.getElementById("r_"+objId+"_span").style.color=color;
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,color){
	if (pageLoad) {
		document.getElementById(objId+"_focus"+"_img").src=imgPath+"/dot.gif";
		document.getElementById("r_"+objId+"_focus"+"_img").src=imgPath+"/dot.gif";
		if(typeof(color)!="undefined"){
			document.getElementById(objId+"_span").style.color=color;
			document.getElementById("r_"+objId+"_span").style.color=color;
		}
	}
}

function init()
{
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("leftBigFocus_focus_a").focus();
	}
}
</script>
<epg:body onload="init()" width="1280" height="720" bgcolor="#000000" >
<div id="leftDiv">
	<!-- 背景图片以及头部图片 -->
		<epg:img src="../${templateParams['bgImg']}" id="main" left="0" top="0" width="640" height="720" />
		<!-- 菜单栏 -->		
		<epg:if test="${menuCategoryItems[1]!=null}">
			<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="menu0Url"/>
			<epg:img id="menu0_focus" onfocus="itemOnFocus('menu0','newsMenuFocus1');"  onblur="itemOnBlur('menu0');" 
				src="./images/dot.gif" href="${menu0Url}" left="34" top="35" width="68" height="76"/>
		</epg:if>	
		<epg:if test="${menuCategoryItems[2]!=null}">
			<epg:navUrl obj="${menuCategoryItems[2]}" indexUrlVar="menu1Url"/>
			<epg:img id="menu1_focus" onfocus="itemOnFocus('menu1','newsMenuFocus2');"  onblur="itemOnBlur('menu1');" 
				src="./images/dot.gif" href="${menu1Url}" left="102" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[3]!=null}">
			<epg:navUrl obj="${menuCategoryItems[3]}" indexUrlVar="menu2Url"/>
			<epg:img id="menu2_focus" onfocus="itemOnFocus('menu2','newsMenuFocus3');"  onblur="itemOnBlur('menu2');" 
				src="./images/dot.gif" href="${menu2Url}" left="170" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[4]!=null}">
			<epg:navUrl obj="${menuCategoryItems[4]}" indexUrlVar="menu3Url"/>
			<epg:img id="menu3_focus" onfocus="itemOnFocus('menu3','newsMenuFocus4');"  onblur="itemOnBlur('menu3');" 
				src="./images/dot.gif" href="${menu3Url}" left="405" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[5]!=null}">
			<epg:navUrl obj="${menuCategoryItems[5]}" indexUrlVar="menu4Url"/>
			<epg:img id="menu4_focus" onfocus="itemOnFocus('menu4','newsMenuFocus5');"  onblur="itemOnBlur('menu4');" 
				src="./images/dot.gif" href="${menu4Url}" left="473" top="35" width="68" height="76"/>
		</epg:if>
		<epg:img id="exit_focus" onfocus="itemOnFocus('exit','newsExit');"  onblur="itemOnBlur('exit');" 
			src="./images/dot.gif" href="${returnHomeUrl}" left="563" top="79" width="55" height="60"/>
		
		<!-- 左侧大图推荐 -->
		<epg:if test="${leftBigImgCategoryItems!=null}">
			<epg:navUrl obj="${leftBigImgCategoryItems}" indexUrlVar="indexUrl"/>
			<epg:img id="leftBigImg" src="../${leftBigImgCategoryItems.itemIcon}" left="36" top="161" width="233" height="250"/>
			<epg:img id="leftBigFocus_focus" rememberFocus="true" onfocus="itemOnFocus('leftBigFocus','newsLeftBigFocus');"  onblur="itemOnBlur('leftBigFocus');" src="./images/dot.gif" href="${indexUrl}&pi=1" left="31" top="151" width="243" height="270"/>
		</epg:if>
		
		<!-- 中间推荐 -->
		<epg:navUrl obj="${centerCategoryItems0[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="centerFocus1" src="./images/rman.jpg"
			width="70" height="80" left="284" top="165" rememberFocus="true" href="${indexUrl}&pi=1" onfocus="itemOnFocus('centerFocus1','centerFocus');"  onblur="itemOnBlur('centerFocus1');"/>
		<epg:img id="centerFocus1_focus" src="./images/dot.gif" left="281" top="159" width="76" height="92" />
		
		<epg:navUrl obj="${centerCategoryItems1}" indexUrlVar="indexUrl"/>
		<epg:img id="center2" src="./images/kxll.jpg"
			width="70" height="80" left="284" top="251" rememberFocus="true" href="${indexUrl}&pi=2" onfocus="itemOnFocus('centerFocus2','centerFocus');"  onblur="itemOnBlur('centerFocus2');"/>
		<epg:img id="centerFocus2_focus" src="./images/dot.gif" left="281" top="245" width="76" height="92" />
	
		<epg:navUrl obj="${centerCategoryItems2[4]}" indexUrlVar="indexUrl"/>
		<epg:img id="center3" src="./images/HDyl.jpg"
			width="70" height="80" left="284" top="337" rememberFocus="true" href="${indexUrl}&pi=2" onfocus="itemOnFocus('centerFocus3','centerFocus');"  onblur="itemOnBlur('centerFocus3');" />
		<epg:img id="centerFocus3_focus" src="./images/dot.gif" left="281" top="331" width="76" height="92" />
	
		
		<!-- 最热排行榜 -->
		<epg:grid column="1" row="5" left="365" top="177" width="242" height="243" hcellspacing="0" items="${hotCategoryItems}" var="hotCategoryItem"  indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${hotCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="wordsFocus${curIdx}" src="./images/dot.gif"
			 width="234"  href="${indexUrl}&pi=${curIdx}" rememberFocus="true" onfocus="itemOnFocus('wordsFocus${curIdx}','newsIndexWordsFocus','#FFFFFF');"  onblur="itemOnBlur('wordsFocus${curIdx}','#fcb393');" 
			  height="31" left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+11}"/>
			<epg:img id="wordsFocus${curIdx}_focus" src="./images/dot.gif" left="${positions[curIdx-1].x-1}" top="${positions[curIdx-1].y+6}" width="239" height="41" />
			<epg:text id="wordsFocus${curIdx}" align="left" left="${positions[curIdx-1].x+30}" top="${positions[curIdx-1].y+18}"
			 height="42" width="210" fontSize="12" color="#fcb393" dotdotdot="…" chineseCharNumber="16" text="${hotCategoryItem.title}"/>
		</epg:grid>
		
		<epg:img id="one" src="./images/newsIndex_one.png" left="368" top="182" width="22" height="41"/>
		<epg:img id="two" src="./images/newsIndex_two.png" left="368" top="229" width="22" height="41"/>
		<epg:img id="three" src="./images/newsIndex_three.png" left="368" top="278" width="22" height="41"/>
		<epg:img id="four" src="./images/newsIndex_four.png" left="368" top="326" width="22" height="41"/>
		<epg:img id="five" src="./images/newsIndex_five.png" left="368" top="374" width="22" height="41"/>
		
		<!-- 八卦爆料台 -->
		<epg:img id="more" src="./images/dot.gif" href="${menu0Url}" rememberFocus="true" left="33" top="436" width="93" height="50"
		 onfocus="itemOnFocus('more','moreFocus');"  onblur="itemOnBlur('more');" />
		<epg:img id="more_focus" src="./images/dot.gif" left="32" top="435" width="93" height="50" />
		
		<epg:grid column="1" row="4" left="33" top="484" width="238" height="164" hcellspacing="0" items="${gossipCategoryItems}" var="gossipCategoryItem"  indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${gossipCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="gossipWordsFocus${curIdx}" src="./images/dot.gif"
			 width="234"  href="${indexUrl}&pi=${curIdx}" rememberFocus="true" onfocus="itemOnFocus('gossipWordsFocus${curIdx}','newsIndexWordsFocus','#FFFFFF');"  onblur="itemOnBlur('gossipWordsFocus${curIdx}','#fcb393');" 
			  height="31" left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+7}"/>
			<epg:img id="gossipWordsFocus${curIdx}_focus" src="./images/dot.gif" left="${positions[curIdx-1].x-1}" top="${positions[curIdx-1].y+2}" width="239" height="41" />
			<epg:text id="gossipWordsFocus${curIdx}"  align="left" left="${positions[curIdx-1].x+15}" top="${positions[curIdx-1].y+16}" 
			 height="42" width="420" fontSize="12" color="#fcb393" dotdotdot="…" chineseCharNumber="16" text="${gossipCategoryItem.title}"/>
		</epg:grid>
			
		
	<epg:if test="${rightDownCategoryItems[0]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDown0" src="../${rightDownCategoryItems[0].poster}"
		 width="65" height="195" left="286" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown0','posterFocus');"onblur="itemOnBlur('rightDown0');" href="${indexUrl}&pi=1"/>
		<epg:img id="rightDown0_focus" src="./images/dot.gif" left="282" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[1]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDown1" src="../${rightDownCategoryItems[1].poster}"
		 width="65" height="195" left="370" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown1','posterFocus');"  onblur="itemOnBlur('rightDown1');"  href="${indexUrl}&pi=2" />
		<epg:img id="rightDown1_focus" src="./images/dot.gif" left="365" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[2]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDown2" src="../${rightDownCategoryItems[2].poster}"
		 width="65" height="195" left="453" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown2','posterFocus');"  onblur="itemOnBlur('rightDown2');" href="${indexUrl}&pi=3"/>
		<epg:img id="rightDown2_focus" src="./images/dot.gif" left="448" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[3]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDown3" src="../${rightDownCategoryItems[3].poster}"
		 width="65" height="195" left="536" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown3','posterFocus');"  onblur="itemOnBlur('rightDown3');"  href="${indexUrl}&pi=4" />
		<epg:img id="rightDown3_focus" src="./images/dot.gif" left="531" top="437" width="75" height="215" /> 
	</epg:if>
</div>
<!-- ***********************************************************************8 -->
<div id="rightDiv">
	<!-- 背景图片以及头部图片 -->
		<epg:img src="../${templateParams['bgImg']}" id="r_main" left="640" top="0" width="640" height="720" />
		<!-- 菜单栏 -->		
		<epg:if test="${menuCategoryItems[1]!=null}">
			<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="menu0Url"/>
			<epg:img id="r_menu0_focus" onfocus="itemOnFocus('menu0','newsMenuFocus1');"  onblur="itemOnBlur('menu0');" 
				src="./images/dot.gif" href="${menu0Url}" left="674" top="35" width="68" height="76"/>
		</epg:if>	
		<epg:if test="${menuCategoryItems[2]!=null}">
			<epg:navUrl obj="${menuCategoryItems[2]}" indexUrlVar="menu1Url"/>
			<epg:img id="r_menu1_focus" onfocus="itemOnFocus('menu1','newsMenuFocus2');"  onblur="itemOnBlur('menu1');" 
				src="./images/dot.gif" href="${menu1Url}" left="742" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[3]!=null}">
			<epg:navUrl obj="${menuCategoryItems[3]}" indexUrlVar="menu2Url"/>
			<epg:img id="r_menu2_focus" onfocus="itemOnFocus('menu2','newsMenuFocus3');"  onblur="itemOnBlur('menu2');" 
				src="./images/dot.gif" href="${menu2Url}" left="810" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[4]!=null}">
			<epg:navUrl obj="${menuCategoryItems[4]}" indexUrlVar="menu3Url"/>
			<epg:img id="r_menu3_focus" onfocus="itemOnFocus('menu3','newsMenuFocus4');"  onblur="itemOnBlur('menu3');" 
				src="./images/dot.gif" href="${menu3Url}" left="1045" top="35" width="68" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[5]!=null}">
			<epg:navUrl obj="${menuCategoryItems[5]}" indexUrlVar="menu4Url"/>
			<epg:img id="r_menu4_focus" onfocus="itemOnFocus('menu4','newsMenuFocus5');"  onblur="itemOnBlur('menu4');" 
				src="./images/dot.gif" href="${menu4Url}" left="1113" top="35" width="68" height="76"/>
		</epg:if>
		<epg:img id="exit_focus" onfocus="itemOnFocus('exit','newsExit');"  onblur="itemOnBlur('exit');" 
			src="./images/dot.gif" href="${returnHomeUrl}" left="1203" top="79" width="55" height="60"/>
		
		<!-- 左侧大图推荐 -->
		<epg:if test="${leftBigImgCategoryItems!=null}">
			<epg:navUrl obj="${leftBigImgCategoryItems}" indexUrlVar="indexUrl"/>
			<epg:img id="r_leftBigImg" src="../${leftBigImgCategoryItems.itemIcon}" left="686" top="161" width="233" height="250"/>
			<epg:img id="r_leftBigFocus_focus" rememberFocus="true" onfocus="itemOnFocus('leftBigFocus','newsLeftBigFocus');"  onblur="itemOnBlur('leftBigFocus');" src="./images/dot.gif" href="${indexUrl}&pi=1" left="681" top="151" width="243" height="270"/>
		</epg:if>
		
		<!-- 中间推荐 -->
		<epg:navUrl obj="${centerCategoryItems0[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="centerFocus1" src="./images/rman.jpg"
			width="70" height="80" left="934" top="165" rememberFocus="true" href="${indexUrl}&pi=1" onfocus="itemOnFocus('centerFocus1','centerFocus');"  onblur="itemOnBlur('centerFocus1');"/>
		<epg:img id="r_centerFocus1_focus" src="./images/dot.gif" left="931" top="159" width="76" height="92" />
		
		<epg:navUrl obj="${centerCategoryItems1}" indexUrlVar="indexUrl"/>
		<epg:img id="r_center2" src="./images/kxll.jpg"
			width="70" height="80" left="934" top="251" rememberFocus="true" href="${indexUrl}&pi=2" onfocus="itemOnFocus('centerFocus2','centerFocus');"  onblur="itemOnBlur('centerFocus2');"/>
		<epg:img id="r_centerFocus2_focus" src="./images/dot.gif" left="931" top="245" width="76" height="92" />
	
		<epg:navUrl obj="${centerCategoryItems2[4]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_center3" src="./images/HDyl.jpg"
			width="70" height="80" left="934" top="337" rememberFocus="true" href="${indexUrl}&pi=2" onfocus="itemOnFocus('centerFocus3','centerFocus');"  onblur="itemOnBlur('centerFocus3');" />
		<epg:img id="r_centerFocus3_focus" src="./images/dot.gif" left="931" top="331" width="76" height="92" />
	
		
		<!-- 最热排行榜 -->
		<epg:grid column="1" row="5" left="1005" top="177" width="242" height="243" hcellspacing="0" items="${hotCategoryItems}" var="hotCategoryItem"  indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${hotCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="r_wordsFocus${curIdx}" src="./images/dot.gif"
			 width="234"  href="${indexUrl}&pi=${curIdx}" rememberFocus="true" onfocus="itemOnFocus('wordsFocus${curIdx}','newsIndexWordsFocus','#FFFFFF');"  onblur="itemOnBlur('wordsFocus${curIdx}','#fcb393');" 
			  height="31" left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+11}"/>
			<epg:img id="r_wordsFocus${curIdx}_focus" src="./images/dot.gif" left="${positions[curIdx-1].x-1}" top="${positions[curIdx-1].y+6}" width="239" height="41" />
			<epg:text id="r_wordsFocus${curIdx}" align="left" left="${positions[curIdx-1].x+30}" top="${positions[curIdx-1].y+18}"
			 height="42" width="210" fontSize="12" color="#fcb393" dotdotdot="…" chineseCharNumber="16" text="${hotCategoryItem.title}"/>
		</epg:grid>
		
		<epg:img id="r_one" src="./images/newsIndex_one.png" left="1008" top="182" width="22" height="41"/>
		<epg:img id="r_two" src="./images/newsIndex_two.png" left="1008" top="229" width="22" height="41"/>
		<epg:img id="r_three" src="./images/newsIndex_three.png" left="1008" top="278" width="22" height="41"/>
		<epg:img id="r_four" src="./images/newsIndex_four.png" left="1008" top="326" width="22" height="41"/>
		<epg:img id="r_five" src="./images/newsIndex_five.png" left="1008" top="374" width="22" height="41"/>
		
		<!-- 八卦爆料台 -->
		<epg:img id="r_more" src="./images/dot.gif" href="${menu0Url}" rememberFocus="true" left="673" top="436" width="93" height="50"
		 onfocus="itemOnFocus('more','moreFocus');"  onblur="itemOnBlur('more');" />
		<epg:img id="r_more_focus" src="./images/dot.gif" left="672" top="435" width="93" height="50" />
		
		<epg:grid column="1" row="4" left="673" top="484" width="238" height="164" hcellspacing="0" items="${gossipCategoryItems}" var="gossipCategoryItem"  indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${gossipCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="r_gossipWordsFocus${curIdx}" src="./images/dot.gif"
			 width="234"  href="${indexUrl}&pi=${curIdx}" rememberFocus="true" onfocus="itemOnFocus('gossipWordsFocus${curIdx}','newsIndexWordsFocus','#FFFFFF');"  onblur="itemOnBlur('gossipWordsFocus${curIdx}','#fcb393');" 
			  height="31" left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+7}"/>
			<epg:img id="r_gossipWordsFocus${curIdx}_focus" src="./images/dot.gif" left="${positions[curIdx-1].x-1}" top="${positions[curIdx-1].y+2}" width="239" height="41" />
			<epg:text id="r_gossipWordsFocus${curIdx}"  align="left" left="${positions[curIdx-1].x+15}" top="${positions[curIdx-1].y+16}" 
			 height="42" width="420" fontSize="12" color="#fcb393" dotdotdot="…" chineseCharNumber="16" text="${gossipCategoryItem.title}"/>
		</epg:grid>
			
		
	<epg:if test="${rightDownCategoryItems[0]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDown0" src="../${rightDownCategoryItems[0].poster}"
		 width="65" height="195" left="936" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown0','posterFocus');"onblur="itemOnBlur('rightDown0');" href="${indexUrl}&pi=1"/>
		<epg:img id="r_rightDown0_focus" src="./images/dot.gif" left="932" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[1]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDown1" src="../${rightDownCategoryItems[1].poster}"
		 width="65" height="195" left="1020" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown1','posterFocus');"  onblur="itemOnBlur('rightDown1');"  href="${indexUrl}&pi=2" />
		<epg:img id="r_rightDown1_focus" src="./images/dot.gif" left="1015" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[2]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDown2" src="../${rightDownCategoryItems[2].poster}"
		 width="65" height="195" left="1103" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown2','posterFocus');"  onblur="itemOnBlur('rightDown2');" href="${indexUrl}&pi=3"/>
		<epg:img id="r_rightDown2_focus" src="./images/dot.gif" left="1098" top="437" width="75" height="215" /> 
	</epg:if>
	<epg:if test="${rightDownCategoryItems[3]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDown3" src="../${rightDownCategoryItems[3].poster}"
		 width="65" height="195" left="1186" top="447" rememberFocus="true" onfocus="itemOnFocus('rightDown3','posterFocus');"  onblur="itemOnBlur('rightDown3');"  href="${indexUrl}&pi=4" />
		<epg:img id="r_rightDown3_focus" src="./images/dot.gif" left="1181" top="437" width="75" height="215" /> 
	</epg:if>
</div>
</epg:body>
</epg:html>