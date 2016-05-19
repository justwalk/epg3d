<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
%>
<epg:html>
<%-- 菜单 --%>
<epg:query queryName="getSeverialItems" maxRows="6" var="menuCatItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnindexCategoryCode']}" type="java.lang.String"/>
</epg:query>

<%-- 菜单 --%>
<epg:query queryName="getSeverialItems" maxRows="6" var="contentMenuCatItems" >
	<epg:param name="categoryCode" value="${templateParams['contentMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>


<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_yuwen" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[0].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_shuxue" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[1].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_yingyu" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[2].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_kexue" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[3].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_shenghuo" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[5].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="menuCatItemsConnet_gushiwu" >
	<epg:param name="categoryCode" value="${contentMenuCatItems[4].itemCode}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl obj="${returnindexResults}" indexUrlVar="returnindexResults"/>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />
<style>
	body{ color:#FFFFFF;font-size:23}
		a{display:block;outline:none}
</style>

<style type="text/css">
	img{
		border:0px solid black; 
	}
		a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
 function back(){
 	document.location.href = "${returnindexResults}";
 }
 function exit(){
 	document.location.href = "${returnUrl}";
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
			iPanel.focus.display = 0;
			iPanel.focus.border = 0;
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
function init(){
	//document.getElementById("content_0_a").focus();
	
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
<epg:body  onload="init();"  defaultBg="./images/index_nursery.jpg" background="../${templateParams['bgImg']}"  style="background-repeat:no-repeat;" width="1280" height="720" bgcolor="#000000">
<!-- 栏目 -->
<div  style="position:absolute;left:175px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[0]!=null}">
		<epg:navUrl obj="${menuCatItems[0]}"  indexUrlVar="indexUrl"/>
       	<epg:img  id="menu0" width="130" height="38"  
       		src="./images/dot.gif" />
		<epg:img  id="menu0focus" rememberFocus="true"  width="130" height="18"  
       		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu0','nurseryMenuFocus');" onblur="itemOnBlur('menu0');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:335px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[1]!=null}">
		<epg:navUrl obj="${menuCatItems[1]}"  indexUrlVar="indexUrl"/>
       	<epg:img  id="menu1"  width="130" height="38"  
       		src="./images/dot.gif"/>
		<epg:img  id="menu1focus" rememberFocus="true"  width="130" height="18"  
       		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu1','nurseryMenuFocus');" onblur="itemOnBlur('menu1');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:495px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[2]!=null}">
		<epg:navUrl obj="${menuCatItems[2]}"  indexUrlVar="indexUrl"/>
       		<epg:img  id="menu2" rememberFocus="true"  width="130" height="38"  
       		src="./images/dot.gif"/>
		<epg:img  id="menu2focus" rememberFocus="true"  width="130" height="18"  
       		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu2','nurseryMenuFocus');" onblur="itemOnBlur('menu2');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:655px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[3]!=null}">
       	<epg:navUrl obj="${menuCatItems[3]}"  indexUrlVar="indexUrl"/>
   		<epg:img  id="menu3" width="130" height="38"  
   		src="./images/dot.gif"/>
		<epg:img  id="menu3focus" width="130" height="18"  
   			src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu3','nurseryMenuFocus');" onblur="itemOnBlur('menu3');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:815px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[5]!=null}">
		<epg:navUrl obj="${menuCatItems[5]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu4" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif"/>
		<epg:img  id="menu4focus"   width="130" height="18"  
			src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu4','nurseryMenuFocus');" onblur="itemOnBlur('menu4');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:975px;top:167px; width:130px; height:38px">
	<epg:if test="${menuCatItems[4]!=null}">
		<epg:navUrl obj="${menuCatItems[4]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu5" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu5focus" rememberFocus="true"  width="130" height="18"  
		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu5','nurseryMenuFocus');" onblur="itemOnBlur('menu5');" />
	</epg:if>
</div>

<div  style=" position:absolute;left:175px;top:425px; width:130px; height:38px">
	<epg:if test="${menuCatItems[3]!=null}">
		<epg:navUrl obj="${menuCatItems[3]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu6" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu6focus" rememberFocus="true"  width="130" height="18"  
		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu6','nurseryMenuFocus');" onblur="itemOnBlur('menu6');" />
	</epg:if>
</div>
<div  style=" position:absolute;left:335px;top:425px; width:130px; height:38px">
	<epg:if test="${menuCatItems[4]!=null}">
		<epg:navUrl obj="${menuCatItems[4]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu7" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu7focus" rememberFocus="true"  width="130" height="18"  
			src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu7','nurseryMenuFocus');" onblur="itemOnBlur('menu7');" />
	</epg:if>
</div>

<div  style=" position:absolute;left:495px;top:425px; width:130px; height:38px">
	<epg:if test="${menuCatItems[0]!=null}">
		<epg:navUrl obj="${menuCatItems[0]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu8" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu8focus" rememberFocus="true"  width="130" height="18"  
		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu8','nurseryMenuFocus');" onblur="itemOnBlur('menu8');" />
	</epg:if>
</div>

<div style=" position:absolute;left:655px;top:425px; width:130px; height:38px">
	<epg:if test="${menuCatItems[1]!=null}">
		<epg:navUrl obj="${menuCatItems[1]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu9" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu9focus" rememberFocus="true"  width="130" height="18"  
			src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu9','nurseryMenuFocus');" onblur="itemOnBlur('menu9');" />
	</epg:if>
</div>

<div  style=" position:absolute;left:815px;top:425px; width:130px; height:38px">
	<epg:if test="${menuCatItems[2]!=null}">
		<epg:navUrl obj="${menuCatItems[2]}"  indexUrlVar="indexUrl"/>
		<epg:img  id="menu10" rememberFocus="true"  width="130" height="38"  
		src="./images/dot.gif" />
		<epg:img  id="menu10focus" rememberFocus="true"  width="130" height="18"  
		src="./images/dot.gif" href="${indexUrl}" onfocus="itemOnFocus('menu10','nurseryMenuFocus');" onblur="itemOnBlur('menu10');" />
	</epg:if>
</div>


<!-- 海报 -->
<div  style="position:absolute;left:175px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_yuwen[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_yuwen[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true" width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_yuwen[0].poster}" id="start_0"  />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_0"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_0','nurseryContent');" onblur="itemOnBlur('content_0');" />
	</epg:if>
</div>
<div  style="position:absolute;left:335px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_shuxue[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_shuxue[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_shuxue[0].poster}" id="start_1" />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_1"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_1','nurseryContent');" onblur="itemOnBlur('content_1');" />
	</epg:if>
</div>
<div  style="position:absolute;left:495px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_yingyu[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_yingyu[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_yingyu[0].poster}" id="start_2"  />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_2"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_2','nurseryContent');" onblur="itemOnBlur('content_2');" />
	</epg:if>
</div>
<div  style="position:absolute;left:655px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_kexue[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_kexue[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_kexue[0].poster}" id="start_3"  />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_3"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_3','nurseryContent');" onblur="itemOnBlur('content_3');" />
	</epg:if>
</div>
<div  style="position:absolute;left:815px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_shenghuo[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_shenghuo[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_shenghuo[0].poster}" id="start_4"   />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_4"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_4','nurseryContent');" onblur="itemOnBlur('content_4');" />
	</epg:if>
</div>
<div  style="position:absolute;left:975px;top:211px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_gushiwu[0]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_gushiwu[0]}"  indexUrlVar="indexUrl"/>
		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
		src="../${menuCatItemsConnet_gushiwu[0].poster}" id="start_4"   />
		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_5"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_5','nurseryContent');" onblur="itemOnBlur('content_5');" />
	</epg:if>
</div>

<div  style="position:absolute;left:175px;top:469px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_kexue[1]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_kexue[1]}"  indexUrlVar="indexUrl"/>
   		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
   		src="../${menuCatItemsConnet_kexue[1].poster}" id="start_5"   />
   		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_6"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_6','nurseryContent');" onblur="itemOnBlur('content_6');" />
	</epg:if>
</div>
<div  style="position:absolute;left:335px;top:469px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_gushiwu[1]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_gushiwu[1]}"  indexUrlVar="indexUrl"/>
  		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
  		src="../${menuCatItemsConnet_gushiwu[1].poster}" id="start_6"  />
  		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_7"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_7','nurseryContent');" onblur="itemOnBlur('content_7');" />
	</epg:if>
</div>
<div  style="position:absolute;left:495px;top:469px; width:130px; height:195px">
<epg:if test="${menuCatItemsConnet_yuwen[1]!=null}">
	<epg:navUrl obj="${menuCatItemsConnet_yuwen[1]}"  indexUrlVar="indexUrl"/>
 		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
 		src="../${menuCatItemsConnet_yuwen[1].poster}" id="start_7" />
 		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_8"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_8','nurseryContent');" onblur="itemOnBlur('content_8');" />
	</epg:if>
</div>
<div  style="position:absolute;left:655px;top:469px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_shuxue[1]!=null}">
       	<epg:navUrl obj="${menuCatItemsConnet_shuxue[1]}"  indexUrlVar="indexUrl"/>
   		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
   		src="../${menuCatItemsConnet_shuxue[1].poster}" id="start_8" />
   		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_9"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_9','nurseryContent');" onblur="itemOnBlur('content_9');" />
	</epg:if>
</div>
<div  style="position:absolute;left:815px;top:469px; width:130px; height:195px">
	<epg:if test="${menuCatItemsConnet_yingyu[1]!=null}">
		<epg:navUrl obj="${menuCatItemsConnet_yingyu[1]}"  indexUrlVar="indexUrl"/>
   		<epg:img   rememberFocus="true"  width="130" height="195"  style="border:1px solid #0c5899;"
   		src="../${menuCatItemsConnet_yingyu[1].poster}" id="start_10"  />
   		<epg:img   rememberFocus="true" width="155" height="219"  left="-11" top="-11"
		src="./images/dot.gif" id="content_10"  href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('content_10','nurseryContent');" onblur="itemOnBlur('content_10');" />
	</epg:if>
</div>

<div style="position:absolute;left:1112px;top:104px; width:82px; height:48px">
<epg:img id="rainbowIndex" src="./images/dot.gif" width="82" height="48" href="${returnindexResults}" onfocus="itemOnFocus('rainbowIndex','rainbowIndexFocus');" onblur="itemOnBlur('rainbowIndex');"/>
</div>

</epg:body>
</epg:html>