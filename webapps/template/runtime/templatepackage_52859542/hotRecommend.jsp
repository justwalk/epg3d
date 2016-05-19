<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String from = request.getParameter("from");
%>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
div{position: absolute;}
</style>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function itemOnFocus(objId){
	$(objId+"_img").style.visibility = "visible";
}

function itemOnBlur(objId){
	$(objId+"_img").style.visibility = "hidden";
}

function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
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
	    	document.location.href = "${returnUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			var ipanelOrSiTV = iPanel.getGlobalVar("from");
			if(ipanelOrSiTV == "iPanel"){
				var cardId = CA.card.serialNumber;
				if(cardId == "" || typeof(cardId) == "undefined"){
					window.location.href = "ui://index.htm";
				}else{
					window.setTimeout('window.location.href = "ui://index.htm";',8000);
					window.location.href = "http://192.168.11.162/portaltest2013/index.htm?STB_ID=" + HardwareInfo.STB.serialnumber + "&type=512&smid=" + cardId;
				}
			}else{
				exit();
			}
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
function init(){
	//$("koreaBigCategoryItem_a").focus();
}
var from = "<%=from%>";
if(from!="null"){
	iPanel.setGlobalVar("from",from);
}
</script>
<epg:html>
<!-- 菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="2" var="menuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['menuCode']}" type="java.lang.String"/>
</epg:query>
<!-- 韩国左上大图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="koreaBigCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['koreaLeftUpRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- 欧美左上大图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="europeBigCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['europeLeftUpRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- 韩国右侧推荐-->
<epg:query queryName="getSeverialItems" maxRows="3" var="koreaRightCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['koreaRightRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- 欧美右侧&左下推荐-->
<epg:query queryName="getSeverialItems" maxRows="4" var="europeRightCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['europeRightRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- 看点-->
<epg:query queryName="getSeverialItems" maxRows="2" var="viewCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['watchingFocus']}" type="java.lang.String"/>
</epg:query>

<epg:body bgcolor="#000000" onload="init()">
<epg:img defaultSrc="./images/hotRecommend.jpg" src="../${templateParams['backgroundImg']}"
		 left="0" top="0" width="1280" height="720"/>
	
<!-- menus -->
<epg:grid left="50" top="129" width="1181" height="38" row="1" column="2" items="${menuCategoryItems}"
		  var="menuCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
    <epg:img id="menu${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="580" height="38"
     		 onblur="itemOnBlur('menu${curIdx}bg');" onfocus="itemOnFocus('menu${curIdx}bg')" 
     		 src="./images/dot.png" href="${indexUrl}" />
    <epg:img id="menu${curIdx}bg" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="580" height="38" style="border:3px solid #ffcc00;visibility: hidden;" />		 
</epg:grid>

<!-- big recommend -->
<epg:if test="${koreaBigCategoryItem != null}">
<epg:navUrl obj="${koreaBigCategoryItem}" indexUrlVar="indexUrl"/>
<epg:img id="koreaBigCategoryItembg" src="./images/dot.png" left="47" top="184"
	 width="280" height="300" style="border:3px solid #ffcc00;visibility: hidden;" />		
<epg:img id="koreaBigCategoryItem" left="50" top="187" width="280" height="300" src="../${koreaBigCategoryItem.itemIcon}"
		 onblur="itemOnBlur('koreaBigCategoryItembg');" onfocus="itemOnFocus('koreaBigCategoryItembg')" 
		 href="${indexUrl}&returnTo=biz&pi=1" />
</epg:if>

<epg:if test="${europeBigCategoryItem != null}">
<epg:navUrl obj="${europeBigCategoryItem}" indexUrlVar="indexUrl"/>
<epg:img id="europeBigCategoryItem" left="650" top="187" width="280" height="300" src="../${europeBigCategoryItem.itemIcon}"
		 onblur="itemOnBlur('europeBigCategoryItembg');" onfocus="itemOnFocus('europeBigCategoryItembg')" 
		 href="${indexUrl}&returnTo=biz&pi=1" />
<epg:img id="europeBigCategoryItembg" src="./images/dot.png" left="647" top="184"
	 width="280" height="300" style="border:3px solid #ffcc00;visibility: hidden;" />	
</epg:if>
<!-- long recommend -->
<epg:if test="${koreaRightCategoryItems[0] != null}">
<epg:navUrl obj="${koreaRightCategoryItems[0]}" indexUrlVar="indexUrl"/>
<epg:img id="koreaRightCategoryItems0" left="350" top="187" width="280" height="140" src="../${koreaRightCategoryItems[0].itemIcon}"
		 onblur="itemOnBlur('koreaRightCategoryItems0bg');" onfocus="itemOnFocus('koreaRightCategoryItems0bg')" 
		 href="${indexUrl}&returnTo=biz&pi=1" />
<epg:img id="koreaRightCategoryItems0bg" src="./images/dot.png" left="347" top="184"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />	
</epg:if>
<epg:if test="${koreaRightCategoryItems[1] != null}">
<epg:navUrl obj="${koreaRightCategoryItems[1]}" indexUrlVar="indexUrl"/>
<epg:img id="koreaRightCategoryItems1" left="350" top="347" width="280" height="140" src="../${koreaRightCategoryItems[1].itemIcon}"
		 onblur="itemOnBlur('koreaRightCategoryItems1bg');" onfocus="itemOnFocus('koreaRightCategoryItems1bg')" 
		 href="${indexUrl}&returnTo=biz&pi=2" />
<epg:img id="koreaRightCategoryItems1bg" src="./images/dot.png" left="347" top="344"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />	
</epg:if>
<epg:if test="${koreaRightCategoryItems[2] != null}">
<epg:navUrl obj="${koreaRightCategoryItems[2]}" indexUrlVar="indexUrl"/>
<epg:img id="koreaRightCategoryItems2" left="350" top="507" width="280" height="140" src="../${koreaRightCategoryItems[2].itemIcon}"
		 onblur="itemOnBlur('koreaRightCategoryItems2bg');" onfocus="itemOnFocus('koreaRightCategoryItems2bg')" 
		 href="${indexUrl}&returnTo=biz&pi=3" />
<epg:img id="koreaRightCategoryItems2bg" src="./images/dot.png" left="347" top="504"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />	 
</epg:if>
<!-- 欧美右上和欧美左下 -->
<epg:if test="${europeRightCategoryItems[0] != null}">
<epg:navUrl obj="${europeRightCategoryItems[0]}" indexUrlVar="indexUrl"/>
<epg:img id="europeRightCategoryItems0" left="950" top="187" width="280" height="140" src="../${europeRightCategoryItems[0].itemIcon}"
		 onblur="itemOnBlur('europeRightCategoryItems0bg');" onfocus="itemOnFocus('europeRightCategoryItems0bg')" 
		 href="${indexUrl}&returnTo=biz&pi=1" />
<epg:img id="europeRightCategoryItems0bg" src="./images/dot.png" left="947" top="184"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />
</epg:if>
<epg:if test="${europeRightCategoryItems[1] != null}">
<epg:navUrl obj="${europeRightCategoryItems[1]}" indexUrlVar="indexUrl"/>
<epg:img id="europeRightCategoryItems1" left="950" top="347" width="280" height="140" src="../${europeRightCategoryItems[1].itemIcon}"
		 onblur="itemOnBlur('europeRightCategoryItems1bg');" onfocus="itemOnFocus('europeRightCategoryItems1bg')" 
		 href="${indexUrl}&returnTo=biz&pi=2" />
<epg:img id="europeRightCategoryItems1bg" src="./images/dot.png" left="947" top="344"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />
</epg:if>
<epg:if test="${europeRightCategoryItems[2] != null}">
<epg:navUrl obj="${europeRightCategoryItems[2]}" indexUrlVar="indexUrl"/>
<epg:img id="europeRightCategoryItem2" left="950" top="507" width="280" height="140" src="../${europeRightCategoryItems[2].itemIcon}"
		 onblur="itemOnBlur('europeRightCategoryItem2bg');" onfocus="itemOnFocus('europeRightCategoryItem2bg')" 
		 href="${indexUrl}&returnTo=biz&pi=3" />
<epg:img id="europeRightCategoryItem2bg" src="./images/dot.png" left="947" top="504"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />
</epg:if>
<!-- oumei leftDown-->
<epg:if test="${europeRightCategoryItems[3] != null}">
<epg:navUrl obj="${europeRightCategoryItems[3]}" indexUrlVar="indexUrl"/>
<epg:img id="europeRightCategoryItem3" left="650" top="507" width="280" height="140" src="../${europeRightCategoryItems[3].itemIcon}"
		 onblur="itemOnBlur('europeRightCategoryItem3bg');" onfocus="itemOnFocus('europeRightCategoryItem3bg')" 
		 href="${indexUrl}&returnTo=biz&pi=4" />
<epg:img id="europeRightCategoryItem3bg" src="./images/dot.png" left="647" top="504"
	 width="280" height="140" style="border:3px solid #ffcc00;visibility: hidden;" />
</epg:if>
<!-- watching focus -->
<epg:if test="${viewCategoryItems[0] != null}">
<epg:navUrl obj="${viewCategoryItems[0]}" indexUrlVar="indexUrl"/>
<epg:img id="watch1" left="50" top="507" width="280" height="64" src="../${viewCategoryItems[0].itemIcon}"
		onblur="itemOnBlur('watch1bg');" onfocus="itemOnFocus('watch1bg')" 
		 href="${indexUrl}&returnTo=biz&pi=1" />
<epg:img id="watch1bg" src="./images/dot.png" left="47" top="504"
	 width="280" height="64" style="border:3px solid #ffcc00;visibility: hidden;" />			 
</epg:if>
<epg:if test="${viewCategoryItems[1] != null}">
<epg:navUrl obj="${viewCategoryItems[1]}" indexUrlVar="indexUrl"/>
<epg:img id="watch2" left="50" top="583" width="280" height="64" src="../${viewCategoryItems[1].itemIcon}"
		 onblur="itemOnBlur('watch2bg');" onfocus="itemOnFocus('watch2bg')" 
		 href="${indexUrl}&returnTo=biz&pi=2" />
<epg:img id="watch2bg" src="./images/dot.png" left="47" top="580"
	 width="280" height="64" style="border:3px solid #ffcc00;visibility: hidden;" />		 	
</epg:if>

<!-- exit -->
<epg:img id="exit" left="1155" top="45" width="80" height="38" src="./images/dot.png" href="${returnUrl}"
	 onblur="itemOnBlur('exitbg');" onfocus="itemOnFocus('exitbg')"/>
<epg:img id="exitbg" src="./images/dot.png" left="1152" top="42"
	 width="80" height="38" style="border:3px solid #ffcc00;visibility: hidden;" />	
</epg:body>
</epg:html>