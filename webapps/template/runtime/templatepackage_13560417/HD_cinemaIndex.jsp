<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<epg:html>

<!-- 子菜单  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="middleMenuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['middleMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左边推荐大图-->
<epg:query queryName="getSeverialItems" maxRows="2" var="leftPicCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftPicCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左边推荐文字-->
<epg:query queryName="getSeverialItems" maxRows="6" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<epg:resource src="./images/left_lineBg.png" realSrcVar="leftBgSrc" />
<epg:resource src="./images/left_lineBg_Focus.png" realSrcVar="leftBgFocusSrc" />
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
function itemOnFocus(objId,img){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
	if(document.getElementById(objId+"_span")){
		document.getElementById(objId+"_span").style.color="#ffffff";
	}
}
//失去焦点事件
function itemOnBlur(objId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	if(document.getElementById(objId+"_span")){
		document.getElementById(objId+"_span").style.color="#02296d";
	}
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
function textOnFocus(objId,img,itemId){
	document.getElementById("posterImg"+objId+"_img").src=imgPath+"/"+img+".png";
	document.getElementById(itemId).style.visibility="visible";
	var textContent = document.getElementById("posterImg"+objId+"_span").innerHTML;
	var textLen = len(textContent);
	textContent = textContent.replace(/^\s+|\s+$/g,"");
	if(textContent.substring(0,3)=="HD_"){
		textContent = textContent.substring(3,textLen);
	}
	 document.getElementById(itemId).style.height="58px"; 
	 if(objId<=5){
	     document.getElementById(itemId).style.top="138px";
	 }else{
		 document.getElementById(itemId).style.top="374px";
	 }
	if(len(textContent)<=10){
		document.getElementById("posterImg"+objId).style.top="20px";
	}else if(len(textContent)>10&&len(textContent)<=20){
	    
	}else {
		 textContent = textContent.substring(0,9)+"…";
	}
	document.getElementById("posterImg"+objId+"_span").innerHTML = textContent;
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById(itemId).style.visibility="hidden";
}


function buttonOnFocus(objId,img){
	document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
}
function buttonOnBlur(objId,img){
	if(img){
		document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
	}else{
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	}
}


function init()
{		
	document.getElementById("categoryList0_a").focus();
	document.getElementById("blockTogether").style.display = "block";
}

//左侧图片获得焦点
function iconOnfocus(objId,img,itemId){
	document.getElementById(objId).style.visibility="visible";
	document.getElementById(itemId).style.background="url('${leftBgFocusSrc}')";
	document.getElementById(objId+"_bg").style.zIndex =1;
}
function iconOnblur(objId,itemId){
	document.getElementById(objId).style.visibility="hidden";
	document.getElementById(itemId).style.background="url('${leftBgSrc}')";
	document.getElementById(objId+"_bg").style.zIndex = 0;
}

 function formSubmit(){   
     document.actionForm.submit();   
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

<epg:body    bgcolor="#000000"  width="1280" height="720" >
<!--<div id="blockTogether" style="display:none;width:1280;height:720;position:absolute;left:0;top:0;">-->
<!-- 背景图片以logo -->
<epg:img id="main"  defaultSrc="./images/cinemaIndex.jpg" src="../${templateParams['backgroundImg']}"
	     left="0" top="0" width="1280" height="720"/>
<div style="position:absolute;left:0px; top:0px; width:350px; height:85px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
</div>
<epg:resource src="./images/dot.gif" realSrcVar="realSrc" />
<epg:grid column="5" row="1" left="350" top="90" width="730" height="45" hcellspacing="20" items="${middleMenuCategoryItems}" var="middleMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${middleMenuCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="middleMenu${curIdx}" rememberFocus="true" 
			onfocus="buttonOnFocus('middleMenu${curIdx}','cinemaTop${curIdx}');"  onblur="buttonOnBlur('middleMenu${curIdx}','dot');" 
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

<!-- 左侧图片 -->
	<epg:if test="${leftPicCategoryItems[0]!=null}">
		<epg:navUrl obj="${leftPicCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<div id="contentImg0_bg" style="position:absolute;left:46px;top:132px;">
			<div id="contentImg0" style="position:absolute;background-color:#f79922;visibility:hidden;left:1px;top:0px;width:286px;height:146px;" ></div>
			<div id="leftItem0"  style="z-index:10;position:absolute;font-size:22;font-family:'黑体';color:#ffffff;text-align:center;background:url(${leftBgSrc});
				left:4px;top:103px;width:280px;height:40px;" >
				<epg:text left="10" id="leftCategory1" color="#ffffff" top="14" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">1 ${leftPicCategoryItems[0].title}</epg:text>
			</div>
			<epg:img id="leftCategory1"  rememberFocus="true" src="../${leftPicCategoryItems[0].itemIcon}" 
			onblur="iconOnblur('contentImg0','leftItem0');" onfocus="iconOnfocus('contentImg0','orange1','leftItem0')"
			 href="${indexUrl}&pi=1&returnTo=biz" left="4" top="3" width="280" height="140"/>
		</div>
	</epg:if>
	<epg:if test="${leftPicCategoryItems[1]!=null}">
		<epg:navUrl obj="${leftPicCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<div id="contentImg1_bg" style="position:absolute;left:46px;top:272px;">
			<div id="contentImg1" style="position:absolute;background-color:#f79922;visibility:hidden;left:1px;top:2px;width:286px;height:146px;" ></div>
			<div id="leftItem1"  style="z-index:10;position:absolute;font-size:22;font-family:'黑体';color:#ffffff;
				text-align:center;background:url(${leftBgSrc});left:4px;top:105px;width:280px;height:40px;" >
				<epg:text left="10" id="leftCategory2" color="#ffffff" top="14" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">2 ${leftPicCategoryItems[1].title}</epg:text>
			</div>
			<epg:img id="leftCategory2"  rememberFocus="true" src="../${leftPicCategoryItems[1].itemIcon}" 
			onblur="iconOnblur('contentImg1','leftItem1');" onfocus="iconOnfocus('contentImg1','orange1','leftItem1')"
			href="${indexUrl}&returnTo=biz&pi=2" left="4" top="5" width="280" height="140"/>
		</div>
	</epg:if>
<!-- 左侧文字 -->
	<epg:if test="${leftCategoryItems[0]!=null}">
		<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory3_bgdiv" style="position:absolute;left:50px;top:417px;width:280px;height:42px;" >
			<epg:img id="leftCategory3" rememberFocus="true" src="./images/dot.gif"
		onfocus="itemOnFocus('leftCategory3','leftFocus')" onblur="itemOnBlur('leftCategory3')" 
		 href="${indexUrl}&returnTo=biz&pi=1" width="280" height="42"/>
		</div>
		<epg:text left="59" color="#02296d" top="428" height="22" id="leftCategory3"
		 chineseCharNumber="11" width="280" fontSize="21" dotdotdot="…">3 ${leftCategoryItems[0].title}</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[1]!=null}">
		<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory4_bgdiv" style="position:absolute;left:50px;top:461px;width:280px;height:42px;" >
		<epg:img id="leftCategory4" rememberFocus="true" src="./images/dot.gif"
		onfocus="itemOnFocus('leftCategory4','leftFocus')" onblur="itemOnBlur('leftCategory4')" 
		 href="${indexUrl}&returnTo=biz&pi=2" width="280" height="42"/>
		</div>
		<epg:text left="59" color="#02296d" top="471" height="22" id="leftCategory4"
		 chineseCharNumber="11" width="280" fontSize="21"  dotdotdot="…">4 ${leftCategoryItems[1].title}</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[2]!=null}">
		<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory5_bgdiv" style="position:absolute;left:50px;top:503px;width:280px;height:42px;" >
		<epg:img id="leftCategory5" rememberFocus="true" src="./images/dot.gif"
		onfocus="itemOnFocus('leftCategory5','leftFocus')" onblur="itemOnBlur('leftCategory5')" 
		 href="${indexUrl}&returnTo=biz&pi=3" width="280" height="42"/>
		</div>
		<epg:text left="59" color="#02296d" top="513" height="22" id="leftCategory5"
		 chineseCharNumber="11" width="280"  fontSize="21" dotdotdot="…">5 ${leftCategoryItems[2].title}</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[3]!=null}">
		<epg:navUrl obj="${leftCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory6_bgdiv" style="position:absolute;left:50px;top:545px;width:280px;height:42px;" >
		<epg:img id="leftCategory6" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory6','leftFocus')" onblur="itemOnBlur('leftCategory6')" 
		 href="${indexUrl}&returnTo=biz&pi=4" width="280" height="42"/>
		</div>
		<epg:text left="59" color="#02296d" top="555" height="22" id="leftCategory6"
		 chineseCharNumber="11" width="280"  fontSize="21" dotdotdot="…">6 ${leftCategoryItems[3].title}</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[4]!=null}">
		<epg:navUrl obj="${leftCategoryItems[4]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory7_bgdiv" style="position:absolute;left:50px;top:587px;width:280px;height:42px;" >
		<epg:img id="leftCategory7" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory7','leftFocus')" onblur="itemOnBlur('leftCategory7')" 
		 href="${indexUrl}&returnTo=biz&pi=5" width="280" height="42"/>
		 </div>
		<epg:text left="59" color="#02296d" top="597" height="22" id="leftCategory7"
		 chineseCharNumber="11" width="280"  fontSize="21" dotdotdot="…">7 ${leftCategoryItems[4].title}</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[5]!=null}">
		<epg:navUrl obj="${leftCategoryItems[5]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory8_bgdiv" style="position:absolute;left:50px;top:630px;width:280px;height:42px;" >
		<epg:img id="leftCategory8" rememberFocus="true" src="./images/dot.gif"
		onfocus="itemOnFocus('leftCategory8','leftFocus')" onblur="itemOnBlur('leftCategory8')" 
		 href="${indexUrl}&returnTo=biz&pi=6" width="280" height="42"/>
		</div>
		<epg:text left="59" color="#02296d" top="640" height="22" id="leftCategory8"
		 chineseCharNumber="11" width="280"  fontSize="21" dotdotdot="…">8 ${leftCategoryItems[5].title}</epg:text>
	</epg:if>
<!-- 海报内容 -->
<div style="position:absolute;left:350px;top:225px;width:882px;height:432px">
	<epg:forEach begin="0" end="1" varStatus="rowStatus">
		<epg:forEach begin="0" end="5" varStatus="colStatus">
			<epg:if test="${rightCategoryItems[rowStatus.index*6+colStatus.index]!=null}">
				<epg:navUrl obj="${rightCategoryItems[rowStatus.index*6+colStatus.index]}" indexUrlVar="indexUrl"/>
				<epg:if test="${rowStatus.index*6+colStatus.index<6}">	
					<epg:img src="./images/dot.gif" id="posterImg${rowStatus.index*6+colStatus.index}"  left="${colStatus.index*150-3}" top="${rowStatus.index-3}" width="136" height="201"/>
					<div id="categoryList${rowStatus.index*6+colStatus.index}_titlediv"  style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:${colStatus.index*150}px;top:${rowStatus.index+142}px;width:130px;height:56px;z-index:1;" >
						<epg:text id="posterImg${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="7" height="56"  width="130" fontSize="22" >
							${rightCategoryItems[rowStatus.index*6+colStatus.index].title}
						</epg:text>
					</div>
					<epg:if test="${rowStatus.index*6+colStatus.index==0}">	
						<epg:img id="categoryList${rowStatus.index*6+colStatus.index}" defaultfocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}"  left="${colStatus.index*150}" 
						onfocus="textOnFocus('${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
						  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index}"   width="130" height="195"/>
					</epg:if>
					<epg:if test="${rowStatus.index*6+colStatus.index>0}">	
						<epg:img id="categoryList${rowStatus.index*6+colStatus.index}" rememberFocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}"  left="${colStatus.index*150}" 
						onfocus="textOnFocus('${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
						  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index}"   width="130" height="195"/>
					</epg:if>			
				</epg:if>
				<epg:if test="${rowStatus.index*6+colStatus.index>=6}">
					<epg:img src="./images/dot.gif" id="posterImg${rowStatus.index*6+colStatus.index}"  left="${colStatus.index*150-3}" top="${232+rowStatus.index}" width="136" height="201"/>
					<div id="categoryList${rowStatus.index*6+colStatus.index}_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:${colStatus.index*150}px;top:${rowStatus.index+403}px;width:130px;height:31px;z-index:1;" >
						<epg:text id="posterImg${rowStatus.index*6+colStatus.index}" align="center" color="#ffffff" top="7" height="31"  width="130" fontSize="22" >
						${rightCategoryItems[rowStatus.index*6+colStatus.index].title}
						</epg:text>
					</div>
					<epg:img id="categoryList${rowStatus.index*6+colStatus.index}" rememberFocus="true" src="../${rightCategoryItems[rowStatus.index*6+colStatus.index].still}" 
					 onfocus="textOnFocus('${rowStatus.index*6+colStatus.index}','orange3','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"  onblur="textOnBlur('posterImg${rowStatus.index*6+colStatus.index}','categoryList${rowStatus.index*6+colStatus.index}_titlediv');"
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
<!--</div>-->
</epg:body>
</epg:html>