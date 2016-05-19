<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!-- 最下跑马灯 -->
<epg:query queryName="getSeverialItems" maxRows="10" var="hotDownResults" >
	<epg:param name="categoryCode" value="${templateParams['hotDownCategoryCode']}" type="java.lang.String"/>
</epg:query>

<script>
var marquenNum = 0;
var marquenClearNum = 0;
var totalNums = ${fn:length(hotDownResults)};//总数

function $id(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

//获得失去焦点
function menuOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId + "_img").src = imgPath + "/" + img + ".png";
	}
}

function init(){
	//alert(totalNums);
	if(document.getElementById("marquenText0")){
		document.getElementById("marquenText0").style.visibility = 'visible';
		var intr = setInterval(changeTab,5000);
	 }
}

//跑马灯
function changeTab(){
	if(marquenNum==0){
		document.getElementById("marquenText"+marquenNum).style.visibility = 'visible';
		marquenNum++;
	}else{
		if(marquenNum>=totalNums){
			document.getElementById("marquenText"+marquenClearNum).style.visibility = 'hidden';
			marquenNum=0;
			marquenClearNum=0;
			document.getElementById("marquenText"+marquenNum).style.visibility = 'visible';
		}else{
			document.getElementById("marquenText"+marquenClearNum).style.visibility = 'hidden';
			document.getElementById("marquenText"+marquenNum).style.visibility = 'visible';
			marquenNum++;
			marquenClearNum++;
		}
	}
}

</script>

<!--最下方跑马灯-->
<div id="marquen" style="position:absolute;left:156px;top:646px;width:1060px;height:42px">
	<epg:forEach begin="0" end="9" varStatus="colStatus">
		<epg:if test="${hotDownResults[colStatus.index]!=null}">
			<div id="marquenText${colStatus.index}" style="position:absolute;left:8px;top:10px;width:1050px;height:42px;visibility:hidden;">
			<epg:text width="1050" height="42" color="#ffffff" chineseCharNumber="51" fontSize="22" dotdotdot="…">
				${hotDownResults[colStatus.index].title}</epg:text>	
			</div>	
		</epg:if>
	</epg:forEach>
</div>

<script>init();</script>