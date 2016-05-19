<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,java.text.*" %>
<epg:html>
<!-- 导航  -->
<epg:query queryName="getSeverialItems" maxRows="2" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 左侧导航 -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuLeftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuLeftCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!-- 左侧内容 -->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="2" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!-- 中间内容-->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="3" var="centerCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!-- 右测内容-->
<epg:query queryName="getSeverialItems" maxRows="3" var="rightCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnUrl"/>
<style type="text/css">
	body{
		color:#02296d;
		font-size:16px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
//监听事件
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
				return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				return 0;
	    	break;
	    case "SITV_KEY_BACK":
	    	window.location.href = "${returnUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			window.location.href = "${returnUrl}";
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
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";



function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,itemId){
	$(objId+"_img").src=imgPath+"/"+img+".png";
	$("r_"+objId+"_img").src=imgPath+"/"+img+".png";
	if(typeof(itemId)!="undefined"){
		$(itemId).style.opacity="1";
		$(itemId).style.backgroundColor="#fb7806";
		$("r_"+itemId).style.opacity="1";
		$("r_"+itemId).style.backgroundColor="#fb7806";
	}
}
//失去焦点事件
function itemOnBlur(objId,itemId){
	$(objId+"_img").src=imgPath+"/dot.gif";
	$("r_"+objId+"_img").src=imgPath+"/dot.gif";
	if(typeof(itemId)!="undefined"){
		$(itemId).style.opacity="0.7";
		$(itemId).style.backgroundColor="#020000";
		$("r_"+itemId).style.opacity="0.7";
		$("r_"+itemId).style.backgroundColor="#020000";
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId){
	$(objId).style.visibility="visible";
	$("r_"+objId).style.visibility="visible";
}

//文字节目失去焦点
function textOnBlur(objId){
	$(objId).style.visibility="hidden";
	$("r_"+objId).style.visibility="hidden";
}

function init()
{		
	document.getElementById("contentPoster0_a").focus();
}
</script>

<epg:body onload="init()"  bgcolor="#000000"  width="1280" height="720" >
<div id="leftDiv">
<!-- 背景图片 -->
<epg:img src="./images/Exclusive.jpg" id="main"  left="0" top="0" width="640" height="720"/>
<!-- 高清导航 -->
<epg:if test="${menuCategoryItems[0] != null}">
		<epg:navUrl obj="${menuCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img src="./images/dot.gif" id="ss"  left="193" top="104" width="83" height="40"
		onfocus="itemOnFocus('Navigation1','exclusiveTop1');"  onblur="itemOnBlur('Navigation1');"
		href="${indexUrl}" />
		<epg:img src="./images/dot.gif" id="Navigation1"  left="23" top="101" width="256" height="47"/>
</epg:if>
<epg:if test="${menuCategoryItems[1] != null}">
		<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img src="./images/dot.gif" id="zz"  left="362" top="104" width="83" height="40"
		onfocus="itemOnFocus('Navigation2','exclusiveTop2');"  onblur="itemOnBlur('Navigation2');"
		href="${indexUrl}" />
		<epg:img src="./images/dot.gif" id="Navigation2"  left="278" top="101" width="170" height="47"/>
</epg:if>


<epg:img src="./images/dot.gif"   left="552" top="58"  width="34" height="44" href="${returnUrl}" onfocus="itemOnFocus('backHome','exclusiveTop3');"  onblur="itemOnBlur('backHome');"/>
<epg:img src="./images/dot.gif" id="backHome"  left="548" width="45" height="115"/>
<!-- 左侧推荐 -->
	<epg:if test="${menuLeftCategoryItems[0] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg0"  left="49" top="190" width="73" height="152"/>
			<epg:img id="contentPoster0" src="../${menuLeftCategoryItems[0].itemIcon}"   left="52" top="196" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg0','orange2');"  onblur="itemOnBlur('leftImg0');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[1] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg1"  left="121" top="190" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[1].itemIcon}"   left="124" top="196" width="68" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg1','orange2');"  onblur="itemOnBlur('leftImg1');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[2] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg2"  left="193" top="190" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[2].itemIcon}"  left="196" top="196" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg2','orange2');"  onblur="itemOnBlur('leftImg2');"/>
	</epg:if>
	<epg:if test="${leftCategoryItems[0] != null}">
			<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg3"  left="48" top="340" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty leftCategoryItems[0].icon}">
					<epg:set value="${leftCategoryItems[0].icon}" var="leftsubjectImg0"/>
				</epg:when>
				<epg:otherwise><epg:set value="${leftCategoryItems[0].itemIcon}" var="leftsubjectImg0"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${leftsubjectImg0}"  left="51" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg3','orange11','leftDiv1');"  onblur="itemOnBlur('leftImg3','leftDiv1');"/>
			<div id="leftDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:51px;top:456px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${leftCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[3] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[3]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg4"  left="193" top="340" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[3].itemIcon}"   left="196" top="346" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg4','orange2');"  onblur="itemOnBlur('leftImg4');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[4] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[4]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg5"  left="48" top="490" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[4].itemIcon}"   left="51" top="496" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg5','orange2');"  onblur="itemOnBlur('leftImg5');"/>
	</epg:if>
	<epg:if test="${leftCategoryItems[1] != null}">
			<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg6"  left="121" top="490" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty leftCategoryItems[1].icon}">
					<epg:set value="${leftCategoryItems[1].icon}" var="leftsubjectImg1"/>
				</epg:when>
				<epg:otherwise><epg:set value="${leftCategoryItems[1].itemIcon}" var="leftsubjectImg1"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${leftsubjectImg1}"  left="124" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg6','orange11','leftDiv2');"  onblur="itemOnBlur('leftImg6','leftDiv2');"/>
			<div id="leftDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:124px;top:606px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${leftCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
<!-- 中间推荐 -->
	<epg:if test="${centerCategoryItems[0] != null}">
			<epg:navUrl obj="${centerCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg7"  left="293" top="190" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[0].icon}">
					<epg:set value="${centerCategoryItems[0].icon}" var="centersubjectImg0"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[0].itemIcon}" var="centersubjectImg0"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg0}"  left="296" top="196" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg7','orange11','centerDiv1');"  onblur="itemOnBlur('leftImg7','centerDiv1');"/>
			<div id="centerDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:296px;top:306px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${centerCategoryItems[1] != null}">
			<epg:navUrl obj="${centerCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg8"  left="293" top="340" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[1].icon}">
					<epg:set value="${centerCategoryItems[1].icon}" var="centersubjectImg1"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[1].itemIcon}" var="centersubjectImg1"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg1}"  left="296" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg8','orange11','centerDiv2');"  onblur="itemOnBlur('leftImg8','centerDiv2');"/>
			<div id="centerDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:296px;top:456px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${centerCategoryItems[2] != null}">
			<epg:navUrl obj="${centerCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg9"  left="293" top="490" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[2].icon}">
					<epg:set value="${centerCategoryItems[2].icon}" var="centersubjectImg2"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[1].itemIcon}" var="centersubjectImg2"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg2}"  left="296" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=3" onfocus="itemOnFocus('leftImg9','orange11','centerDiv3');"  onblur="itemOnBlur('leftImg9','centerDiv3');"/>
			<div id="centerDiv3" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:296px;top:606px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[2].title}
			</epg:text>
			</div>
	</epg:if>
<!-- 右侧推荐 -->
	<epg:if test="${rightCategoryItems[0] != null}">
			<epg:navUrl obj="${rightCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg10"  left="462" top="190" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[0].itemIcon}" var="rightsubjectImg0"/>
			<epg:img src="../${rightsubjectImg0}"  left="465" top="196" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg10','orange11','rightDiv1');"  onblur="itemOnBlur('leftImg10','rightDiv1');"/>
			<div id="rightDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:465px;top:306px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[1] != null}">
			<epg:navUrl obj="${rightCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg11"  left="462" top="340" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[1].itemIcon}" var="rightsubjectImg1"/>
			<epg:img src="../${rightsubjectImg1}"  left="465" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg11','orange11','rightDiv2');"  onblur="itemOnBlur('leftImg11','rightDiv2');"/>
			<div id="rightDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:465px;top:456px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[2] != null}">
			<epg:navUrl obj="${rightCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="leftImg12"  left="462" top="490" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[2].itemIcon}" var="rightsubjectImg2"/>
			<epg:img src="../${rightsubjectImg2}"  left="465" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=3" onfocus="itemOnFocus('leftImg12','orange11','rightDiv3');"  onblur="itemOnBlur('leftImg12','rightDiv3');"/>
			<div id="rightDiv3" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:465px;top:606px;width:140px;height:30px;" >
			<epg:text id="posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[2].title}
			</epg:text>
			</div>
	</epg:if>
</div>

<!-- ********************************************************** -->
<div id="r_leftDiv">
<!-- 背景图片 -->
<epg:img src="./images/Exclusive.jpg" id="r_main"  left="640" top="0" width="640" height="720"/>
<!-- 高清导航 -->
<epg:if test="${menuCategoryItems[0] != null}">
		<epg:navUrl obj="${menuCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img src="./images/dot.gif" id="r_ss"  left="833" top="104" width="83" height="40"
		onfocus="itemOnFocus('Navigation1','exclusiveTop1');"  onblur="itemOnBlur('Navigation1');"
		href="${indexUrl}" />
		<epg:img src="./images/dot.gif" id="r_Navigation1"  left="663" top="101" width="256" height="47"/>
</epg:if>
<epg:if test="${menuCategoryItems[1] != null}">
		<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img src="./images/dot.gif" id="r_zz"  left="1002" top="104" width="83" height="40"
		onfocus="itemOnFocus('Navigation2','exclusiveTop2');"  onblur="itemOnBlur('Navigation2');"
		href="${indexUrl}" />
		<epg:img src="./images/dot.gif" id="r_Navigation2"  left="918" top="101" width="170" height="47"/>
</epg:if>


<epg:img src="./images/dot.gif"   left="1192" top="58"  width="34" height="44" href="${returnUrl}" onfocus="itemOnFocus('backHome','exclusiveTop3');"  onblur="itemOnBlur('backHome');"/>
<epg:img src="./images/dot.gif" id="r_backHome"  left="1188" width="45" height="115"/>
<!-- 左侧推荐 -->
	<epg:if test="${menuLeftCategoryItems[0] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg0"  left="699" top="190" width="73" height="152"/>
			<epg:img id="r_contentPoster0" src="../${menuLeftCategoryItems[0].itemIcon}"   left="702" top="196" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg0','orange2');"  onblur="itemOnBlur('leftImg0');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[1] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg1"  left="771" top="190" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[1].itemIcon}"   left="774" top="196" width="68" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg1','orange2');"  onblur="itemOnBlur('leftImg1');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[2] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg2"  left="843" top="190" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[2].itemIcon}"  left="846" top="196" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg2','orange2');"  onblur="itemOnBlur('leftImg2');"/>
	</epg:if>
	<epg:if test="${leftCategoryItems[0] != null}">
			<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg3"  left="698" top="340" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty leftCategoryItems[0].icon}">
					<epg:set value="${leftCategoryItems[0].icon}" var="leftsubjectImg0"/>
				</epg:when>
				<epg:otherwise><epg:set value="${leftCategoryItems[0].itemIcon}" var="leftsubjectImg0"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${leftsubjectImg0}"  left="701" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg3','orange11','leftDiv1');"  onblur="itemOnBlur('leftImg3','leftDiv1');"/>
			<div id="r_leftDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:701px;top:456px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${leftCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[3] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[3]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg4"  left="843" top="340" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[3].itemIcon}"   left="846" top="346" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg4','orange2');"  onblur="itemOnBlur('leftImg4');"/>
	</epg:if>
	<epg:if test="${menuLeftCategoryItems[4] != null}">
			<epg:navUrl obj="${menuLeftCategoryItems[4]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg5"  left="698" top="490" width="73" height="152"/>
			<epg:img src="../${menuLeftCategoryItems[4].itemIcon}"   left="701" top="496" width="67" height="140"
		href="${indexUrl}" onfocus="itemOnFocus('leftImg5','orange2');"  onblur="itemOnBlur('leftImg5');"/>
	</epg:if>
	<epg:if test="${leftCategoryItems[1] != null}">
			<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg6"  left="771" top="490" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty leftCategoryItems[1].icon}">
					<epg:set value="${leftCategoryItems[1].icon}" var="leftsubjectImg1"/>
				</epg:when>
				<epg:otherwise><epg:set value="${leftCategoryItems[1].itemIcon}" var="leftsubjectImg1"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${leftsubjectImg1}"  left="774" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg6','orange11','leftDiv2');"  onblur="itemOnBlur('leftImg6','leftDiv2');"/>
			<div id="r_leftDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:774px;top:606px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${leftCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
<!-- 中间推荐 -->
	<epg:if test="${centerCategoryItems[0] != null}">
			<epg:navUrl obj="${centerCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg7"  left="943" top="190" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[0].icon}">
					<epg:set value="${centerCategoryItems[0].icon}" var="centersubjectImg0"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[0].itemIcon}" var="centersubjectImg0"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg0}"  left="946" top="196" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg7','orange11','centerDiv1');"  onblur="itemOnBlur('leftImg7','centerDiv1');"/>
			<div id="r_centerDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:946px;top:306px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${centerCategoryItems[1] != null}">
			<epg:navUrl obj="${centerCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg8"  left="943" top="340" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[1].icon}">
					<epg:set value="${centerCategoryItems[1].icon}" var="centersubjectImg1"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[1].itemIcon}" var="centersubjectImg1"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg1}"  left="946" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg8','orange11','centerDiv2');"  onblur="itemOnBlur('leftImg8','centerDiv2');"/>
			<div id="r_centerDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:946px;top:456px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${centerCategoryItems[2] != null}">
			<epg:navUrl obj="${centerCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg9"  left="943" top="490" width="146" height="152"/>
			<epg:choose>
				<epg:when test="${!empty centerCategoryItems[2].icon}">
					<epg:set value="${centerCategoryItems[2].icon}" var="centersubjectImg2"/>
				</epg:when>
				<epg:otherwise><epg:set value="${centerCategoryItems[1].itemIcon}" var="centersubjectImg2"/></epg:otherwise>
			</epg:choose>
			<epg:img src="../${centersubjectImg2}"  left="946" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=3" onfocus="itemOnFocus('leftImg9','orange11','centerDiv3');"  onblur="itemOnBlur('leftImg9','centerDiv3');"/>
			<div id="r_centerDiv3" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:946px;top:606px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${centerCategoryItems[2].title}
			</epg:text>
			</div>
	</epg:if>
<!-- 右侧推荐 -->
	<epg:if test="${rightCategoryItems[0] != null}">
			<epg:navUrl obj="${rightCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg10"  left="1112" top="190" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[0].itemIcon}" var="rightsubjectImg0"/>
			<epg:img src="../${rightsubjectImg0}"  left="1115" top="196" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=1" onfocus="itemOnFocus('leftImg10','orange11','rightDiv1');"  onblur="itemOnBlur('leftImg10','rightDiv1');"/>
			<div id="r_rightDiv1" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:1115px;top:306px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[1] != null}">
			<epg:navUrl obj="${rightCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg11"  left="1112" top="340" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[1].itemIcon}" var="rightsubjectImg1"/>
			<epg:img src="../${rightsubjectImg1}"  left="1115" top="346" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=2" onfocus="itemOnFocus('leftImg11','orange11','rightDiv2');"  onblur="itemOnBlur('leftImg11','rightDiv2');"/>
			<div id="r_rightDiv2" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:1115px;top:456px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[2] != null}">
			<epg:navUrl obj="${rightCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="r_leftImg12"  left="1112" top="490" width="146" height="152"/>
			<epg:set value="${rightCategoryItems[2].itemIcon}" var="rightsubjectImg2"/>
			<epg:img src="../${rightsubjectImg2}"  left="1115" top="496" width="140" height="140"
		href="${indexUrl}&returnTo=biz&pi=3" onfocus="itemOnFocus('leftImg12','orange11','rightDiv3');"  onblur="itemOnBlur('leftImg12','rightDiv3');"/>
			<div id="r_rightDiv3" style="position:absolute;font-size:16;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#020000;opacity:0.7;left:1115px;top:606px;width:140px;height:30px;" >
			<epg:text id="r_posterText${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="1" height="31" chineseCharNumber="12"  width="140" fontSize="16" dotdotdot="…">
			${rightCategoryItems[2].title}
			</epg:text>
			</div>
	</epg:if>
</div>
</epg:body>
</epg:html>