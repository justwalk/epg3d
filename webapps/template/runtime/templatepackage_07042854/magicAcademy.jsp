<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<epg:html>
<%
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

<!-- 获取菜单结果 -->
<epg:query queryName="getSeverialItems" maxRows="7" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取栏目内容 -->
<epg:if test="${templateParams['gradeCategoryCode']!=7}">
<epg:query queryName="getSeverialItems" maxRows="3" var="contentResults">
	   <epg:param name="categoryCode" value="${menuResults[templateParams['gradeCategoryCode']-1].itemCode}" type="java.lang.String"/>
</epg:query>
</epg:if>

<!-- 获取科目结果 -->
<epg:if test="${templateParams['lessonCategoryCode']!=7}">
<epg:query queryName="getSeverialItems" maxRows="18" var="subjectResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${contentResults[templateParams['lessonCategoryCode']-1].itemCode}" type="java.lang.String"/>
</epg:query>
</epg:if>
<epg:if test="${templateParams['lessonCategoryCode']==7}">
<epg:query queryName="getSeverialItems" maxRows="18" var="subjectResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${menuResults[templateParams['gradeCategoryCode']-1].itemCode}" type="java.lang.String"/>
</epg:query>
</epg:if>

<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnindexCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>
<epg:navUrl obj="${returnindexResults}" indexUrlVar="returnindexResults"/>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />

<head>
<style>
a{
	text-decoration:none;
	display:block;
	color:#3a5c13;
}
body{
font-family:"黑体" ! important;
 font-size:25px; 
 color:#093d61;
 margin:0;
 padding:0;
 }
 a{display:block;outline:none}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
 function back(){
 	document.location.href = "${returnindexResults}";
 }
 function exit(){
 	document.location.href = "${returnHome}";
 }

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
	    	pageUp();
	    	break;
	    case "SITV_KEY_PAGEDOWN":
	    	pageDown();
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
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
var num;

	function init(){
		//document.getElementById("focus_0_a").focus();
		showContent();
		//var leaveFocusId = "${leaveFocusId}";
		//if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		//	document.getElementById(leaveFocusId+"_a").focus();
		//}else{
			document.getElementById("b0_a").focus();
		//}
	}

	function pageUp(){
		var previousUrl = "${pageBean.previousUrl}";
		var myPageIndex = "";
		if(previousUrl.indexOf("&pageIndex=")!=-1){
			myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
		}
		if(previousUrl.indexOf("&leaveFocusId=")!=-1){
			previousUrl = previousUrl.substring(0,previousUrl.indexOf("&leaveFocusId="));
		}
		document.location.href = previousUrl+"&leaveFocusId=pageUp"+myPageIndex;
	 }
 
	 function pageDown(){
		var nextUrl = "${pageBean.nextUrl}";
		var myPageIndex = "";
		if(nextUrl.indexOf("&pageIndex=")!=-1){
			myPageIndex = nextUrl.substring(nextUrl.indexOf("&pageIndex="),nextUrl.length);
		}
		if(nextUrl.indexOf("&leaveFocusId=")!=-1){
			nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
		}
		document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
	 }

	var title = new Array();
	function showContent(){
		if("${subjectResults[0].title}"!=null&&"${subjectResults[0].title}"!=""){
			title[0] = "${subjectResults[0].title}";
			document.getElementById("b0_span").innerHTML = subString(title[0],30,true);
		}
		if("${subjectResults[1].title}"!=null&&"${subjectResults[1].title}"!=""){
			title[1] = "${subjectResults[1].title}";
			document.getElementById("b1_span").innerHTML = subString(title[1],30,true);
		}
		if("${subjectResults[2].title}"!=null&&"${subjectResults[2].title}"!=""){
			title[2] = "${subjectResults[2].title}";
			document.getElementById("b2_span").innerHTML = subString(title[2],30,true);
		}
		if("${subjectResults[3].title}"!=null&&"${subjectResults[3].title}"!=""){
			title[3] = "${subjectResults[3].title}";
			document.getElementById("b3_span").innerHTML = subString(title[3],30,true);
		}
		if("${subjectResults[4].title}"!=null&&"${subjectResults[4].title}"!=""){
			title[4] = "${subjectResults[4].title}";
			document.getElementById("b4_span").innerHTML = subString(title[4],30,true);
		}
		if("${subjectResults[5].title}"!=null&&"${subjectResults[5].title}"!=""){
			title[5] = "${subjectResults[5].title}";
			document.getElementById("b5_span").innerHTML = subString(title[5],30,true);
		}
		if("${subjectResults[6].title}"!=null&&"${subjectResults[6].title}"!=""){
			title[6] = "${subjectResults[6].title}";
			document.getElementById("b6_span").innerHTML = subString(title[6],30,true);
		}
		if("${subjectResults[7].title}"!=null&&"${subjectResults[7].title}"!=""){
			title[7] = "${subjectResults[7].title}";
			document.getElementById("b7_span").innerHTML = subString(title[7],30,true);
		}
		if("${subjectResults[8].title}"!=null&&"${subjectResults[8].title}"!=""){
			title[8] = "${subjectResults[8].title}";
			document.getElementById("b8_span").innerHTML = subString(title[8],30,true);
		}
		if("${subjectResults[9].title}"!=null&&"${subjectResults[9].title}"!=""){
			title[9] = "${subjectResults[9].title}";
			document.getElementById("b9_span").innerHTML = subString(title[9],30,true);
		}
		if("${subjectResults[10].title}"!=null&&"${subjectResults[10].title}"!=""){
			title[10] = "${subjectResults[10].title}";
			document.getElementById("b10_span").innerHTML = subString(title[10],30,true);
		}
		if("${subjectResults[11].title}"!=null&&"${subjectResults[11].title}"!=""){
			title[11] = "${subjectResults[11].title}";
			document.getElementById("b11_span").innerHTML = subString(title[11],30,true);
		}
		if("${subjectResults[12].title}"!=null&&"${subjectResults[12].title}"!=""){
			title[12] = "${subjectResults[12].title}";
			document.getElementById("b12_span").innerHTML = subString(title[12],30,true);
		}
		if("${subjectResults[13].title}"!=null&&"${subjectResults[13].title}"!=""){
			title[13] = "${subjectResults[13].title}";
			document.getElementById("b13_span").innerHTML = subString(title[13],30,true);
		}
		if("${subjectResults[14].title}"!=null&&"${subjectResults[14].title}"!=""){
			title[14] = "${subjectResults[14].title}";
			document.getElementById("b14_span").innerHTML = subString(title[14],30,true);
		}
		if("${subjectResults[15].title}"!=null&&"${subjectResults[15].title}"!=""){
			title[15] = "${subjectResults[15].title}";
			document.getElementById("b15_span").innerHTML = subString(title[15],30,true);
		}
		if("${subjectResults[16].title}"!=null&&"${subjectResults[16].title}"!=""){
			title[16] = "${subjectResults[16].title}";
			document.getElementById("b16_span").innerHTML = subString(title[16],30,true);
		}
		if("${subjectResults[17].title}"!=null&&"${subjectResults[17].title}"!=""){
			title[17] = "${subjectResults[17].title}";
			document.getElementById("b17_span").innerHTML = subString(title[17],30,true);
		}
	}
	
	//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
	function itemOnFocus(objId,img){
		if (pageLoad) {
			document.getElementById(objId+"_img").src=imgPath+img+".png";
			if(objId.indexOf("b")==0){
				textMov(objId);
			}
		}
	}
	//失去焦点事件
	function itemOnBlur(objId){
		if (pageLoad) {
			document.getElementById(objId+"_img").src=imgPath+"dot.gif";
			if(objId.indexOf("b")==0){
				textStop(objId);
			}
		}
	}

	function textMov(objId){ //左右移动显示文字
		if(objId.substring(objId.indexOf("b")+2,objId.indexOf("b")+3)!=null&&objId.substring(objId.indexOf("b")+2,objId.indexOf("b")+3)!=""){
			num = objId.substring(objId.indexOf("b")+1,objId.indexOf("b")+3);
		}else{
			num = objId.substring(objId.indexOf("b")+1,objId.indexOf("b")+2);
		}
		if(objId!=undefined){
			if(subString(title[num],30,true).indexOf("…")!=-1){
				document.getElementById(objId+"_span").innerHTML = "<marquee direction='left' behavior='alternate' scrollamount='1' scrolldelay='10'>"+title[num]+"</marquee>";
			}else{
				document.getElementById(objId+"_span").innerHTML = subString(title[num],30,true);
			}
		}
	}

	function textStop(objId){//停止移动文字
		if(objId.substring(objId.indexOf("b")+2,objId.indexOf("b")+3)!=null&&objId.substring(objId.indexOf("b")+2,objId.indexOf("b")+3)!=""){
			num = objId.substring(objId.indexOf("b")+1,objId.indexOf("b")+3);
		}else{
			num = objId.substring(objId.indexOf("b")+1,objId.indexOf("b")+2);
		}
		if(objId!=undefined){
			document.getElementById(objId+"_span").innerHTML = subString(title[num],30,true);
		}
	}
	//截字
	function subString(str, len, hasDot){ 
		var newLength = 0; 
		var newStr = ""; 
		var chineseRegex = /[^\x00-\xff]/g; 
		var singleChar = ""; 
		var strLength = str.replace(chineseRegex,"**").length; 
		for(var i = 0;i < strLength;i++) 
		{ 
			singleChar = str.charAt(i).toString(); 
			if(singleChar.match(chineseRegex) != null) 
			{ 
				newLength += 2; 
			} 
			else 
			{ 
				newLength++; 
			} 
			if(newLength > len) 
			{ 
				break; 
			} 
			newStr += singleChar; 
		} 
		if(hasDot && strLength > len) 
		{ 
			newStr+="";
		} 
		return newStr; 
	}
	//background="../${templateParams['bgImg']}"
	
</script>
</head>

<epg:body  onload="init();"  width="1280" height="720"   style="background-repeat:no-repeat;" defaultBg="./images/magicAcademy.jpg" bgcolor="#000000">
  <!--导航条start-->
	 <!--内容部分start-->
  <div style="position:absolute;top:226px;left:164px;width:850px;height:380px;color:#3a5c13;">
	<epg:forEach begin="0" end="8" varStatus="rowStatus">
		<epg:forEach begin="0" end="1" varStatus="colStatus">
			<epg:if test="${subjectResults[rowStatus.index*2+colStatus.index].title!=null}">
   		 		<epg:navUrl obj="${subjectResults[rowStatus.index*2+colStatus.index]}" indexUrlVar="indexUrl"/>
   		 		<epg:if test="${rowStatus.index*2+colStatus.index<9}">
   		 			<epg:text id="b${rowStatus.index*2+colStatus.index}" left="0" top="${(rowStatus.index*2+colStatus.index)*42+6}" rememberFocus="true" height="42" width="378" text=""/>
   		 			<epg:img id="b${rowStatus.index*2+colStatus.index}" left="-13" top="${(rowStatus.index*2+colStatus.index)*42}" src="./images/dot.gif" href="${indexUrl}" height="42" width="420"  onfocus="itemOnFocus('b${rowStatus.index*2+colStatus.index}','magicContentFocus');" onblur="itemOnBlur('b${rowStatus.index*2+colStatus.index}');"/>
   		 		</epg:if>
   		 		<epg:if test="${rowStatus.index*2+colStatus.index>8}">
   		 			<epg:text id="b${rowStatus.index*2+colStatus.index}" left="425" top="${(rowStatus.index*2+colStatus.index)*42-372}" rememberFocus="true"  height="42" width="378" text=""/>
   		 			<epg:img id="b${rowStatus.index*2+colStatus.index}"  left="412" top="${(rowStatus.index*2+colStatus.index)*42-378}" src="./images/dot.gif" href="${indexUrl}" height="42" width="420" onfocus="itemOnFocus('b${rowStatus.index*2+colStatus.index}','magicContentFocus');" onblur="itemOnBlur('b${rowStatus.index*2+colStatus.index}');"/>
   		 		</epg:if>
   		 	</epg:if>
		</epg:forEach>
	</epg:forEach>
	</div>
  <!--内容部分end-->
	<div id="Navigation" style="position:absolute;width:740px;height:52px;left:323px;top:108px;"> 
	 <!-- 年级背景图 -->
	<epg:forEach begin="1" end="6" varStatus="rowStatus">
		<div style="position:absolute;left:${rowStatus.index*102-75}px;top:14px;">
			<epg:if test="${rowStatus.index==templateParams['gradeCategoryCode']}">
				<epg:img height="26" width="72"  src="./images/grade${rowStatus.index}_L.png" />
			</epg:if>
			<epg:if test="${rowStatus.index!=templateParams['gradeCategoryCode']}">
				<epg:img height="26" width="72"  src="./images/grade${rowStatus.index}_H.png" />
			</epg:if>
		</div>
		<epg:if test="${rowStatus.index==templateParams['gradeCategoryCode']}">
			<div style="position:absolute;left:${rowStatus.index*102-95}px;top:16px;">
				<epg:img height="20" width="20"  src="./images/star.png" />
			</div>
		</epg:if>
	</epg:forEach>
	<div class="topSelected" style="position:absolute;left:5px;">
	<epg:if test="${menuResults[0] != null}">
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top0" src="./images/dot.gif" onfocus="itemOnFocus('top0','magicGradeFocus');" onblur="itemOnBlur('top0');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:115px;">
	<epg:if test="${menuResults[1] != null}">
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top1" src="./images/dot.gif" onfocus="itemOnFocus('top1','magicGradeFocus');" onblur="itemOnBlur('top1');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:216px;">
	<epg:if test="${menuResults[2] != null}">
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top2" src="./images/dot.gif" onfocus="itemOnFocus('top2','magicGradeFocus');" onblur="itemOnBlur('top2');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:315px;">
	<epg:if test="${menuResults[3] != null}">
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top3" src="./images/dot.gif" onfocus="itemOnFocus('top3','magicGradeFocus');" onblur="itemOnBlur('top3');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:418px;">
	<epg:if test="${menuResults[4] != null}">
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top4" src="./images/dot.gif" onfocus="itemOnFocus('top4','magicGradeFocus');" onblur="itemOnBlur('top4');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:517px;">
	<epg:if test="${menuResults[5] != null}">
	<epg:navUrl obj="${menuResults[5]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100"  href="${indexUrl}" rememberFocus="true" id="top5" src="./images/dot.gif" onfocus="itemOnFocus('top5','magicGradeFocus');" onblur="itemOnBlur('top5');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:637px;">
	<epg:if test="${menuResults[6] != null}">
	<epg:navUrl obj="${menuResults[6]}" indexUrlVar="indexUrl"/>
	<epg:img height="52" width="100" onfocus="itemOnFocus('top6')" href="${indexUrl}" rememberFocus="true" id="top6" src="./images/dot.gif" onfocus="itemOnFocus('top6','magicGradeFocus');" onblur="itemOnBlur('top6');"/>
	</epg:if>
	</div>
  </div>

   <!--返回首页-->
   <div style="position:absolute;left:1112px;top:104px; width:82px; height:48px">
	<epg:img id="rainbowIndex" src="./images/dot.gif" width="82" height="48" href="${returnindexResults}" onfocus="itemOnFocus('rainbowIndex','rainbowIndexFocus');" onblur="itemOnBlur('rainbowIndex');"/>
	</div>
   <!--导航条end-->
   
   <!--科目start-->
    <div id="Subject" style="position:absolute;width:80px;height:377px;left:70px;top:160px;">  
    	<!-- 科目星星选择 -->
	    	<epg:if test="${templateParams['lessonCategoryCode']==1}">
		    	<epg:img height="118" width="80" left="0" top="11" src="./images/chineseFoucs.png" />
		    	<epg:img height="118" width="80" left="0" top="130" src="./images/math.png" />
		    	<epg:img height="118" width="80" left="0" top="249" src="./images/english.png" />
	    	</epg:if>
	    	<epg:if test="${templateParams['lessonCategoryCode']==2}">
		    	<epg:img height="118" width="80" left="0" top="11" src="./images/chinese.png" />
		    	<epg:img height="118" width="80" left="0" top="130" src="./images/mathFocus.png" />
		    	<epg:img height="118" width="80" left="0" top="249" src="./images/english.png" />
	    	</epg:if>
	    	<epg:if test="${templateParams['lessonCategoryCode']==3}">
		    	<epg:img height="118" width="80" left="0" top="11" src="./images/chinese.png" />
		    	<epg:img height="118" width="80" left="0" top="130" src="./images/math.png" />
		    	<epg:img height="118" width="80" left="0" top="249" src="./images/englishFocus.png" />
	    	</epg:if>
	<div class="leftmenu" style="position:absolute;top:11px;">
	<epg:if test="${contentResults[0] != null}">
	<epg:navUrl obj="${contentResults[0]}" indexUrlVar="indexUrl"/>
	<epg:img height="117" width="80" onfocus="itemOnFocus('yuwen')" href="${indexUrl}" rememberFocus="true" id="yuwen" src="./images/dot.gif" onfocus="itemOnFocus('yuwen','magicSubjectFocus');" onblur="itemOnBlur('yuwen');"/>
	</epg:if>
	</div>
	<div class="leftmenu" style="position:absolute;top:129px;">
	<epg:if test="${contentResults[1] != null}">
	<epg:navUrl obj="${contentResults[1]}" indexUrlVar="indexUrl"/>
	<epg:img height="117" width="80" onfocus="itemOnFocus('shuxue')" href="${indexUrl}" rememberFocus="true" id="shuxue" src="./images/dot.gif" onfocus="itemOnFocus('shuxue','magicSubjectFocus');" onblur="itemOnBlur('shuxue');"/>
	</epg:if>
	</div>
	<div class="leftmenu" style="position:absolute;top:247px;">
	<epg:if test="${contentResults[2] != null}">
	<epg:navUrl obj="${contentResults[2]}" indexUrlVar="indexUrl"/>
	<epg:img height="117" width="80" onfocus="itemOnFocus('yingyu')" href="${indexUrl}" rememberFocus="true" id="yingyu" src="./images/dot.gif" onfocus="itemOnFocus('yingyu','magicSubjectFocus');" onblur="itemOnBlur('yingyu');"/>
	</epg:if>
	</div>
	
	</div>
   <!--科目end-->
   <!--科目显示 -->
    <div  style="position:absolute;width:158px;height:78px;left:1003px;top:173px;">  
    	<epg:if test="${templateParams['lessonCategoryCode']==1}">
    		<epg:img height="78" width="158"  src="./images/chineseWord.png" />
    	</epg:if>
    	<epg:if test="${templateParams['lessonCategoryCode']==2}">
    		<epg:img height="78" width="158"  src="./images/mathWord.png" />
    	</epg:if>
    	<epg:if test="${templateParams['lessonCategoryCode']==3}">
    		<epg:img height="78" width="158"  src="./images/englishWord.png" />
    	</epg:if>
    </div>
    <!--上下页-->
    <div style="position:absolute; left:159px; top:182px;">
    <epg:img id="pageUp" src="./images/dot.gif" width="90" height="40" href="#" onclick="pageUp()" onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');"/>
    </div>
	<div style="position:absolute; left:271px; top:182px;">
	<epg:img id="pageDown" src="./images/dot.gif" width="90" height="40" href="#" onclick="pageDown()" onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');"/>
	</div>
    <div style="position:absolute; left:402px; top:185px; width:108px; height:40px; line-height:40px;">
    <font color="#063787">${pageBean.pageIndex}/${pageBean.pageCount}页</font>
    </div>

 
</epg:body>
</epg:html>