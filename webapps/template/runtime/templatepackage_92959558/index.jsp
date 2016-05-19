<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<epg:html>
<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="7" var="jiChuMenuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['hdMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="8" var="zhuTiMenuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['sdMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!-- 左边大图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftPicCategoryCode" >
	<epg:param name="categoryCode" value="${templateParams['leftPicCategoryItems']}" type="java.lang.String"/>
</epg:query>
<!-- 左边文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 中图推荐-->
<epg:query queryName="getSeverialItems" maxRows="6" var="centerCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['centerCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右上推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightUpCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右下推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightDownCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
	body{
		color:#02296d;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
</style>
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function menuOnFocus(objId,focusImg){
	document.getElementById(objId+"_img").src=imgPath+"/"+focusImg+".png";
}
//失去焦点事件
function menuOnBlur(objId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
}



//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId){
		document.getElementById(objId+"_imgDiv").style.visibility = 'visible';
		document.getElementById(objId+"_titlediv").style.opacity="1";
		document.getElementById(objId+"_titlediv").style.backgroundColor="#f79922";
}
//失去焦点事件
function itemOnBlur(objId){
		document.getElementById(objId+"_imgDiv").style.visibility = 'hidden';
		document.getElementById(objId+"_titlediv").style.opacity="0.7";
		document.getElementById(objId+"_titlediv").style.backgroundColor="#020000";
}
//海报获得焦点
function iconOnfocus(objId,num){
	document.getElementById(objId+"_imgDiv").style.visibility = 'visible';
	if(typeof(num)!="undefined"){
		document.getElementById(objId+"_titlediv").style.visibility = 'hidden';
		document.getElementById(objId+"_Focustitlediv").style.visibility = 'visible';
	}
	
}
function iconOnblur(objId,num){
	document.getElementById(objId+"_imgDiv").style.visibility = 'hidden';
	if(typeof(num)!="undefined"){
		document.getElementById(objId+"_titlediv").style.visibility = 'visible';
		document.getElementById(objId+"_Focustitlediv").style.visibility = 'hidden';
	}
}


//文字节目失去焦点
function textOnBlur(objId,color,divBgColor){
	document.getElementById(objId+"_bg").style.background = divBgColor;
	if(typeof(color)!="undefined"){
		document.getElementById(objId+"_span").style.color=color;
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId,textColor,divBgColor){
	document.getElementById(objId+"_span").style.color=textColor;
	document.getElementById(objId+"_bg").style.background = divBgColor;
}

function init(){
	//document.getElementById("lfContent0_a").focus();
}
function back(){
 	document.location.href = SysSetting.getEnv("portalIndexUrl");
 }
 function exit(){
 	back();
  	//document.location.href = "http://192.168.11.153/epg/1.html";
 }
 
if("${rightDownCategoryItems.itemType}"=="channel"){
	var mediaPlayer = new MediaPlayer();
	var mediaID;
	mediaID = mediaPlayer.createPlayerInstance("video",2);
	mediaPlayer.bindPlayerInstance(mediaID);
	mediaPlayer.position="0,857,167,363,205";   //全屏  857 165
	mediaPlayer.source="delivery://371000.6875.64-QAM.1342.258.514";
	mediaPlayer.play();
	mediaPlayer.refresh();
}


function closeVideo() {
	if ("${rightDownCategoryItems.itemType}" == "channel") {
		mediaPlayer.releasePlayerInstance(); //释放播放  销毁播放器
		mediaPlayer.unBindPlayerInstance();//解除绑定
	}
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:body onload="init()" onunload="closeVideo();" bgcolor="#000000"  width="1280" height="720" >

<!-- 背景图片以及头部图片 -->
<epg:img src="./images/index.jpg" id="main"  left="0" top="0" width="1280" height="720"/>
<epg:img src="./images/logo.png" left="0" top="10" width="350" height="85"/>

<!-- HD导航 -->
<epg:grid column="7" row="1" left="51" top="97" width="668" height="94" hcellspacing="4" items="${jiChuMenuCategoryItems}" var="jiChuMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${jiChuMenuCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="jichumenu${curIdx}" src="./images/dot.gif"
			width="92"  href="${indexUrl}" onfocus="menuOnFocus('jichumenu${curIdx}','jiChufocusMenu${curIdx}');"  onblur="menuOnBlur('jichumenu${curIdx}');" 
			height="94" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
</epg:grid>

	<!-- SD导航 -->
<epg:grid column="4" row="2" left="723" top="97" width="508" height="94"  vcellspacing="4"  hcellspacing="4" items="${zhuTiMenuCategoryItems}" var="zhuTiMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${zhuTiMenuCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="zhutimenu${curIdx}" src="./images/dot.gif"
		 width="124"  href="${indexUrl}" onfocus="menuOnFocus('zhutimenu${curIdx}','zhutifocusMenu${curIdx}');"  onblur="menuOnBlur('zhutimenu${curIdx}');" 
		  height="45" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
</epg:grid>



<epg:img src="./images/dot.gif" id="ss"  left="950" top="52" width="80" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="menuOnFocus('ss','focusMenuTop_1');"  onblur="menuOnBlur('ss');" />

<epg:img src="./images/dot.gif" id="zz"  left="1050" top="52" width="80" height="38"
	href="${context['EPG_MYCOLLECTION_URL']}" onfocus="menuOnFocus('zz','zizhuFocus');"  onblur="menuOnBlur('zz');" />
<epg:img src="./images/dot.gif" id="zn"  left="1150" top="52"width="80" height="38" 
	 href="javascript:back();" onfocus="menuOnFocus('zn','exit');"  onblur="menuOnBlur('zn');" />

<!-- 左侧5推荐 -->
<epg:if test="${leftPicCategoryCode != null}">
	<epg:navUrl obj="${leftPicCategoryCode}" indexUrlVar="indexUrl"/>
	<div id="leftContent0_imgDiv" style="position:absolute;background-color:#f79922;visibility:hidden;left:47px;top:224px;width:286px;height:306px;" ></div>
	<epg:img id="lfContent0" 	
	 onblur="iconOnblur('leftContent0',1);" left="50" top="227" onfocus="iconOnfocus('leftContent0',1)" src="../${leftPicCategoryCode.itemIcon}" width="280" height="300" href="${indexUrl}&pi=1"/>
	<div id="leftContent0_titlediv" style="position:absolute;font-size:22px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#265cb6;left:50px;top:484px;width:280px;height:45px;z-index:1;opacity:0.8;">
		<epg:text id="leftContent0" color="#ffffff" width="280" left="11"  top="11" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>	 
    </div>
	<div id="leftContent0_Focustitlediv" style="visibility:hidden;position:absolute;font-size:22px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#f79922;left:50px;top:484px;width:280px;height:45px;z-index:1;opacity:1;">
		<epg:text id="leftContent0" color="#ffffff" width="280" left="11"  top="10" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>	 
    </div>
</epg:if>
<epg:if test="${leftCategoryItems[0] !=null}">
	<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
	<div id="lf1_bg" style="position:absolute;left:50px;top:527px;width:280px;height:40px;">
	<epg:img id="lf1" width="280" height="40" href="${indexUrl}&pi=1" 
		onblur="textOnBlur('lf1','#02296d','');" onfocus="textOnFocus('lf1','#ffffff','#f79922')" src="./images/dot.gif"  />
	</div>
</epg:if>
 <epg:if test="${leftCategoryItems[0] != null}">
	<epg:text id="lf1" left="60"  top="536" color="#02296d" width="267" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[0].title}</epg:text>
</epg:if>


<epg:if test="${leftCategoryItems[1] !=null}">
	<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
	<div id="lf2_bg" style="position:absolute;left:50px;top:569px;width:280px;height:40px;">
	<epg:img id="lf2" width="280" height="40" href="${indexUrl}&pi=2" 
		onblur="textOnBlur('lf2','#02296d','');" onfocus="textOnFocus('lf2','#ffffff','#f79922')"  src="./images/dot.gif"  />
	</div>
</epg:if>
<epg:if test="${leftCategoryItems[1] != null}">
	<epg:text id="lf2" left="60"  top="576" color="#02296d" width="267" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[1].title}</epg:text>
</epg:if>

<epg:if test="${leftCategoryItems[2] !=null}">
	<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl"/>
	<div id="lf3_bg" style="position:absolute;left:50px;top:611px;width:280px;height:40px;">
	<epg:img id="lf3" width="280" height="40" href="${indexUrl}&pi=3" 
		onblur="textOnBlur('lf3','#02296d','');" onfocus="textOnFocus('lf3','#ffffff','#f79922')"  src="./images/dot.gif"  />
	</div>
</epg:if>

<epg:if test="${leftCategoryItems[2] != null}">
	<epg:text id="lf3" left="60"  top="619" color="#02296d" width="267" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[2].title}</epg:text>
</epg:if>

<!-- 中推荐 -->
<epg:grid column="2" row="3" left="350" top="226" width="480" height="426" vcellspacing="10" hcellspacing="10"  items="${centerCategoryItems}" var="centerCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${centerCategoryItem}" indexUrlVar="indexUrl"/>
			<div id="midContent${curIdx-1}_imgDiv" style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:241px;height:141px;" ></div>
			<epg:img id="midContent${curIdx-1}" src="../${centerCategoryItem.itemIcon}" 
				left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="235" height="135"/>
			<epg:img id="midContentFocus${curIdx-1}" 
			 onblur="iconOnblur('midContent${curIdx-1}',1)" onfocus="iconOnfocus('midContent${curIdx-1}',1)"
				 src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="241" height="146" href="${indexUrl}&pi=${curIdx}"/>
			 <div id="midContent${curIdx-1}_titlediv" 
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+105}px;width:235px;height:30px;z-index:1;">
				<epg:text   id="midContent${curIdx-1}"  align="left" left="11"  top="3"  color="#ffffff"  height="22"  chineseCharNumber="10" width="235" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
			<div id="midContent${curIdx-1}_Focustitlediv" 
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+93}px;width:235px;height:42px;z-index:1;">
				<epg:text   id="midContent${curIdx-1}"  align="left" left="11"  color="#ffffff" top="10" height="22"  chineseCharNumber="10" width="235" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
</epg:grid>


<!-- 右上推荐 -->
<epg:grid column="2" row="1" left="850" top="224" width="380" height="190" hcellspacing="10"  items="${rightUpCategoryItems}" var="rightUpCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${rightUpCategoryItem}" indexUrlVar="indexUrl"/>
			<div id="rightUpContent${curIdx-1}_imgDiv" style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:191px;height:196px;" ></div>
			<epg:img id="rightUpContent${curIdx-1}" src="../${rightUpCategoryItem.itemIcon}" 
				left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="185" height="190"/>
			<epg:img id="midContentFocus${curIdx-1}" 
			 onblur="iconOnblur('rightUpContent${curIdx-1}',1)" onfocus="iconOnfocus('rightUpContent${curIdx-1}',1)"
				 src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="185" height="190" href="${indexUrl}&pi=${curIdx}"/>
			 <div id="rightUpContent${curIdx-1}_titlediv" 
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+160}px;width:185px;height:30px;z-index:1;">
				<epg:text   id="rightUpContent${curIdx-1}"  top="3"  align="left" left="11"  color="#ffffff"  height="22"  chineseCharNumber="8" width="185" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
			<div id="rightUpContent${curIdx-1}_Focustitlediv" 
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+148}px;width:185px;height:42px;z-index:1;">
				<epg:text   id="rightUpContent${curIdx-1}"  align="left" left="11"  color="#ffffff" top="10" height="22"  chineseCharNumber="8" width="185" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
</epg:grid>


<epg:if test="${rightDownCategoryItems != null}">
	<epg:if test="${rightDownCategoryItems.itemType=='channel'}">
		<epg:navUrl obj="${rightDownCategoryItems}" playUrlVar="indexUrl"/>
		<epg:img  src="./images/dot.png" left="850"  top="434" width="380" height="215" href="${indexUrl}"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems.itemType!='channel'}">
		<epg:navUrl obj="${rightDownCategoryItems}" indexUrlVar="indexUrl"/>
		<div id="rightDownContent0_imgDiv" style="position:absolute;background-color:#f79922;visibility:hidden;left:847px;top:431px;width:386px;height:221px;" ></div>
		<epg:img id="rightDownContent0" 	
		 onblur="iconOnblur('rightDownContent0',1);" left="850" top="434" onfocus="iconOnfocus('rightDownContent0',1)" src="../${rightDownCategoryItems.itemIcon}" width="380" height="215" href="${indexUrl}&pi=1"/>
		<div id="rightDownContent0_titlediv" style="position:absolute;font-size:22px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#000000;left:850px;top:619px;width:380px;height:30px;z-index:1;opacity:0.8;">
			<epg:text id="rightDownContent0" color="#ffffff" width="380" left="11"  top="3" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>	 
	    </div>
		<div id="rightDownContent0_Focustitlediv" style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#f79922;left:850px;top:607px;width:380px;height:42px;z-index:1;opacity:1;">
			<epg:text id="rightDownContent0" color="#ffffff" width="380" left="11"  top="10" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>	 
	    </div>
	</epg:if>
	
</epg:if>

</epg:body>
</epg:html>