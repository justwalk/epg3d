<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
%>
<epg:query queryName="getSeverialItems" maxRows="1" var="returnResults" >
	<epg:param name="categoryCode" value="${templateParams['returnCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="4" var="twoToSevenCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['twoToSevenCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="4" var="sevenToTwelveCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['sevenToTwelveCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="1" var="twoToSevenStarCategory">
	<epg:param name="categoryCode" value="${templateParams['twoToSevenStarCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="1" var="sevenToTwelveStarCategory">
	<epg:param name="categoryCode" value="${templateParams['sevenToTwelveStarCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${returnResults}"  indexUrlVar="returnResults"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>

<epg:html>
<style>
	a{display:block;outline:none}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
 function back(){
 	document.location.href = "${returnResults}";
 }
 function exit(){
 	document.location.href = "${returnHome}";
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
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
	var leaveFocusId="";
	function init(){
		//document.getElementById("customeFocus1_a").focus();
	}

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	document.getElementById(objId+"_img").src=imgPath+img+".png";
}
//失去焦点事件
function itemOnBlur(objId){
	document.getElementById(objId+"_img").src=imgPath+"dot.gif";
}
</script>


<epg:body onload="init()" style="background-repeat:no-repeat;" defaultBg="./images/index_superBigChallenge.jpg"   bgcolor="#000000">
	<!-- 明星擂主的图片 -->
	<epg:if test="${twoToSevenStarCategory!=null}">
		<epg:img src="../${twoToSevenStarCategory.itemIcon}" height="135" left="95" top="212" width="235"  />
	</epg:if>
	<epg:if test="${sevenToTwelveStarCategory!=null}">
		<epg:img src="../${sevenToTwelveStarCategory.itemIcon}" height="135" left="95" top="452" width="235"  />
	</epg:if>
	
	<epg:grid items="${twoToSevenCategoryItem}" column="4" row="1" left="371"  posVar="customePosition" top="185" height="199" width="818" var="catagotyItem" indexVar="currentIndex" hcellspacing="18">
		<epg:navUrl obj="${catagotyItem}" indexUrlVar="gaoqinghuikanUrlFirst" />
		<epg:choose>
			<epg:when test="${!empty catagotyItem.icon}">
				<epg:img id="customePosition${currentIndex}" src="../${catagotyItem.icon}" style="border:2px solid #e6b26d"  width="185"  height="190" left="${customePosition[currentIndex-1].x}" top="${customePosition[currentIndex-1].y}"  />
			</epg:when>
			<epg:otherwise>
				<epg:img id="customePosition${currentIndex}" src="../${catagotyItem.itemIcon}" style="border:2px solid #e6b26d"  width="185"  height="190" left="${customePosition[currentIndex-1].x}" top="${customePosition[currentIndex-1].y}"  />
			</epg:otherwise>
		</epg:choose>
		<epg:img id="customeFocus${currentIndex}" src="./images/dot.gif"   width="202"  height="213" left="${customePosition[currentIndex-1].x-5}" top="${customePosition[currentIndex-1].y-8}" onfocus="itemOnFocus('customeFocus${currentIndex}','superChallengeQuestFocus');" onblur="itemOnBlur('customeFocus${currentIndex}');" href="${gaoqinghuikanUrlFirst}" />
	</epg:grid>
	
	<epg:grid items="${sevenToTwelveCategoryItem}" column="4" row="1" left="371"  posVar="customePositionSecond" top="425" height="199" width="818" var="catagotyItemSecond" indexVar="currentIndexSecond" hcellspacing="18">
		<epg:navUrl obj="${catagotyItemSecond}" indexUrlVar="gaoqinghuikanUrlSecond" />
		<epg:choose>
			<epg:when test="${!empty catagotyItemSecond.icon}">
				<epg:img id="customePositionSecond${currentIndexSecond}"style="border:2px solid #e6b26d"  src="../${catagotyItemSecond.icon}"    width="185" height="190"  left="${customePositionSecond[currentIndexSecond-1].x}" top="${customePositionSecond[currentIndexSecond-1].y}"  />
			</epg:when>
			<epg:otherwise>
				<epg:img id="customePositionSecond${currentIndexSecond}"style="border:2px solid #e6b26d"  src="../${catagotyItemSecond.itemIcon}"    width="185" height="190"  left="${customePositionSecond[currentIndexSecond-1].x}" top="${customePositionSecond[currentIndexSecond-1].y}"  />
			</epg:otherwise>
		</epg:choose>
		<epg:img id="custome2Focus${currentIndexSecond}" src="./images/dot.gif"   width="202"  height="213" left="${customePositionSecond[currentIndexSecond-1].x-5}" top="${customePositionSecond[currentIndexSecond-1].y-8}" onfocus="itemOnFocus('custome2Focus${currentIndexSecond}','superChallengeQuestFocus');" onblur="itemOnBlur('custome2Focus${currentIndexSecond}');"  href="${gaoqinghuikanUrlSecond}"/>
	</epg:grid>
	
	<epg:img id="firstPage" left="917" top="104" src="./images/dot.gif" onfocus="itemOnFocus('firstPage','rainbowIndexFocus');" onblur="itemOnBlur('firstPage');" href="${returnResults}"  width="82" height="48"/>
</epg:body>
</epg:html>
