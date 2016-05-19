<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<epg:html>

<!-- 子菜单  -->
<epg:query queryName="getSeverialItems" maxRows="4" var="middleMenuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['middleMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左边推荐-->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
	body{
		color:#FFFFFF;
		font-size:22;
		font-family:"黑体";
	}
	a{outline:none;}
</style>
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _requester = null; 
var pageSize = 12;	
var pageIndex = 1;	
var pageTotal;
var pageCount="${pageBean.pageCount}";
var categoryList=[];

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
	if(typeof(itemId)!="undefined"){
	document.getElementById(itemId).style.opacity="1";
	document.getElementById(itemId).style.backgroundColor="#e69122";
	}
}
//失去焦点事件
function itemOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	if(typeof(itemId)!="undefined"){
	document.getElementById(itemId).style.opacity="0.8";
	document.getElementById(itemId).style.backgroundColor="#265ab5";
	}
}
//海报焦点事件
function textOnFocus(objId,img,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
}

function buttonOnFocus(objId,img){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
}
function buttonOnBlur(objId,img){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
}


function init()
{		
	//document.getElementById("categoryList0_a").focus();
}
function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
 }
  function pageUp(){
 	document.location.href = "${pageBean.previousUrl}";
 }
 function pageDown(){
 	document.location.href = "${pageBean.nextUrl}";
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
			iPanel.eventFrame.openIndex();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:body  bgcolor="#000000"  width="1280" height="720" >
<!-- 背景图片以logo -->
<epg:img id="main"  defaultSrc="./images/entertainmentIndex.jpg" src="../${templateParams['backgroundImg']}"
	     left="0" top="0" width="1280" height="720"/>
<div style="position:absolute;left:0px; top:0px; width:350px; height:85px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
</div>
<epg:resource src="./images/dot.gif" realSrcVar="realSrc" />
<epg:grid column="5" row="1" left="350" top="90" width="730" height="45" hcellspacing="20" items="${middleMenuCategoryItems}" var="middleMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${middleMenuCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="middleMenu${curIdx}" rememberFocus="true" 
			onfocus="buttonOnFocus('middleMenu${curIdx}','entertainmentTop${curIdx}');"  onblur="buttonOnBlur('middleMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="45" href="${indexUrl}"/>
</epg:grid>
<!-- 搜索,收藏,返回 -->
<epg:img src="./images/dot.gif" id="ss"  left="849" top="47" width="80" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />
<epg:img src="./images/dot.gif" id="zz"  left="949" top="47" width="80" height="38"
	href="${context['EPG_MYCOLLECTION_URL']}" onfocus="itemOnFocus('zz','focusMenuTop_2');"  onblur="itemOnBlur('zz');" />
<epg:img src="./images/dot.gif" id="ls"  left="1050" top="47" width="80" height="38"
	href="${context['EPG_CONTEXT']}/index/hdvodhistory.do" onfocus="itemOnFocus('ls','focusMenuTop_4');"  onblur="itemOnBlur('ls');" />
<epg:img src="./images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />
<!--上下页、确定 -->
<epg:img src="./images/prePage.png" id="area_upPage"  left="350" top="162" onfocus="buttonOnFocus('area_upPage','prePage_focus')" onblur="buttonOnBlur('area_upPage','prePage')"  pageop="up" keyop="pageup" width="130" height="32" href="#" onclick="pageUp()"/>
<epg:img src="./images/nextPage.png" id="area_downPage"  left="500" top="162" onfocus="buttonOnFocus('area_downPage','nextPage_focus')" onblur="buttonOnBlur('area_downPage','nextPage')" pageop="down" keyop="pagedown"  width="130" height="32" href="#" onclick="pageDown()"/>
<!-- 输入框 -->	
<div style="position:absolute; top:165px; left:665px; width:79px; height:22px; font-size:22px; " >
		<span id="pageIndex" style="color:#1978b8">${pageBean.pageIndex}</span><span id="pageCount" style="color:#646464">/${pageBean.pageCount}页</span>
</div>
<!-- 左侧内容 -->
<epg:if test="${leftCategoryItems[0] != null}">
			<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="contentImg0"  left="47" top="159" width="286" height="146"/>
			<epg:img rememberFocus="true" src="../${leftCategoryItems[0].itemIcon}"  left="50" top="162" width="280" height="140"  id="contentPoster0"
				href="${indexUrl}&pi=1" onfocus="itemOnFocus('contentImg0','orange1','leftItem0');"  onblur="itemOnBlur('contentImg0','leftItem0');"/>
			<div id="leftItem0" style="position:absolute;left:50px;top:260px;width:280px;height:42px;background-color:#265ab5;opacity:0.8;" >
				<epg:text  align="center" color="#ffffff" top="10" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
				${leftCategoryItems[0].title}
				</epg:text>
			</div>
	</epg:if>
	<epg:if test="${leftCategoryItems[1] != null}">
			<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="contentImg1"  left="47" top="336" width="286" height="146"/>
			<epg:img rememberFocus="true" src="../${leftCategoryItems[1].itemIcon}"  left="50" top="339" width="280" height="140"  id="contentPoster1"
				href="${indexUrl}&pi=2" onfocus="itemOnFocus('contentImg1','orange1','leftItem1');"  onblur="itemOnBlur('contentImg1','leftItem1');"/>
			<div id="leftItem1" style="position:absolute;left:50px;top:437px;width:280px;height:42px;background-color:#265ab5;opacity:0.8;" >
				<epg:text  align="center" color="#ffffff" top="10" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
				${leftCategoryItems[1].title}
				</epg:text>
			</div>
	</epg:if>
	<epg:if test="${leftCategoryItems[2] != null}">
			<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl"/>
			<epg:img src="./images/dot.gif" id="contentImg2"  left="47" top="513" width="286" height="146"/>
			<epg:img rememberFocus="true" src="../${leftCategoryItems[2].itemIcon}"  left="50" top="516" width="280" height="140"  id="contentPoster2"
				href="${indexUrl}&pi=2" onfocus="itemOnFocus('contentImg2','orange1','leftItem2');"  onblur="itemOnBlur('contentImg2','leftItem2');"/>
			<div id="leftItem2" style="position:absolute;left:50px;top:614px;width:280px;height:42px;background-color:#265ab5;opacity:0.8;" >
				<epg:text  align="center" color="#ffffff" top="10" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
				${leftCategoryItems[2].title}
				</epg:text>
			</div>
	</epg:if>
<!-- 海报内容 -->
<div style="position:absolute;left:350px;top:225px;width:882px;height:432px">
	<epg:forEach begin="0" end="1" varStatus="rowStatus">
		<epg:forEach begin="0" end="5" varStatus="colStatus">
			<epg:if test="${rightCategoryItems[rowStatus.index*6+colStatus.index]!=null}">
				<epg:navUrl obj="${rightCategoryItems[rowStatus.index*6+colStatus.index]}" indexUrlVar="indexUrl"/>
				<epg:if test="${rowStatus.index*6+colStatus.index<6}">	
					<epg:if test="${rowStatus.index*6+colStatus.index==0}">	
						<epg:img src="./images/dot.gif" id="posterImg${rowStatus.index*6+colStatus.index}"  left="${colStatus.index*150-3}" top="${rowStatus.index-3}" width="136" height="201"/>
						<epg:img id="categoryList${rowStatus.index*6+colStatus.index}"  defaultfocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}"  left="${colStatus.index*150}" 
						  onfocus="textOnFocus('posterImg${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
						  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index}"   width="130" height="195"/>
					</epg:if>
					<epg:if test="${rowStatus.index*6+colStatus.index>0}">	
						<epg:img src="./images/dot.gif" id="posterImg${rowStatus.index*6+colStatus.index}"  left="${colStatus.index*150-3}" top="${rowStatus.index-3}" width="136" height="201"/>
						<epg:img id="categoryList${rowStatus.index*6+colStatus.index}"  rememberFocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}"  left="${colStatus.index*150}" 
						  onfocus="textOnFocus('posterImg${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
						  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index}"   width="130" height="195"/>
					</epg:if>
				</epg:if>
				<epg:if test="${rowStatus.index*6+colStatus.index>=6}">
					<epg:img src="./images/dot.gif" id="posterImg${rowStatus.index*6+colStatus.index}"  left="${colStatus.index*150-3}" top="${232+rowStatus.index}" width="136" height="201"/>
					<epg:img id="categoryList${rowStatus.index*6+colStatus.index}" rememberFocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}" 
					 onfocus="textOnFocus('posterImg${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
					 left="${colStatus.index*150}" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz" top="${235+rowStatus.index}"  width="130" height="195"/>
				</epg:if>
			</epg:if>
			<epg:if test="${rightCategoryItems[rowStatus.index*6+colStatus.index]==null}">
				<epg:if test="${rowStatus.index*6+colStatus.index<6}">
					<div  id="categoryList${rowStatus.index*6+colStatus.index}_div"  style="position:absolute;left:${colStatus.index*150}px;top:${rowStatus.index}px;width:130px;height:195px;z-index:1;"  >
						<a id="categoryList${rowStatus.index*6+colStatus.index}_a"   >
							<img id="categoryList${rowStatus.index*6+colStatus.index}_img" src="${realSrc}" width="130" height="195" />
						</a>
					</div>
					<div id="categoryList${rowStatus.index*6+colStatus.index}_titlediv"  style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:${colStatus.index*150}px;top:${rowStatus.index+390}px;width:130px;height:44px;z-index:1;" >
					</div>
				</epg:if>
				<epg:if test="${rowStatus.index*6+colStatus.index>=6}">
					<div  id="categoryList${rowStatus.index*6+colStatus.index}_div"    style="position:absolute;left:${colStatus.index*150}px;top:${236+rowStatus.index}px;width:130px;height:195px;z-index:1;"  >
						<a id="categoryList${rowStatus.index*6+colStatus.index}_a" >
							<img id="categoryList${rowStatus.index*6+colStatus.index}_img" src="${realSrc}" width="130" height="195"/>
						</a>
					</div>
					<div id="categoryList${rowStatus.index*6+colStatus.index}_titlediv"  style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:${colStatus.index*150}px;top:${rowStatus.index+390}px;width:130px;height:44px;z-index:1;" >
					</div>
					</epg:if>
			</epg:if>
		</epg:forEach>
	</epg:forEach>
</div>
</epg:body>
</epg:html>