<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<epg:html>
<epg:query queryName="getSeverialItems" maxRows="5" var="upResults" >
	<epg:param name="categoryCode" value="${templateParams['upCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="4" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="2" var="downResults" >
	<epg:param name="categoryCode" value="${templateParams['downCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="3" var="recommendResults" >
	<epg:param name="categoryCode" value="${templateParams['recommendCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="selectCustomer" var="customer" maxRows="1">
	<epg:param name="accountId" value="${EPG_USER_SESSION.userId}" type="java.lang.String" />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>
<style>
 	a{outline:none;}
	img{border:0px solid black;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
function back(){
 	document.location.href = "${returnHome}";
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
var leaveFocus;

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
//获得焦点事件 
function itemOnFocus(objId,img){
	//alert(objId);
	leaveFocus = objId;
	$(objId+"_div").style.visibility = 'visible';//显示
	$("r_"+objId+"_div").style.visibility = 'visible';//显示
	document.getElementById(objId+"_img").src=imgPath+img+".png";
	document.getElementById("r_"+objId+"_img").src=imgPath+img+".png";
}
//失去焦点事件
function itemOnBlur(objId){
	$(objId+"_div").style.visibility='hidden';//隐藏
	document.getElementById(objId+"_img").src=imgPath+"dot.gif";
	$("r_"+objId+"_div").style.visibility='hidden';//隐藏
	document.getElementById("r_"+objId+"_img").src=imgPath+"dot.gif";
}


function init(){	
	document.getElementById("menu0_a").focus();	
}

</script>

<epg:body  onload="init()" autoflag="notall" width="1280" height="720" bgcolor="#000">
<div id="leftDiv">
<epg:img src="./images/rainbow.jpg" width="640" height="720" left="0" top="0"/>
<!-- 首页品牌专区 -->
<div style="position:absolute;width:315px;height:116px;left:177px;top:43px;"> 
	<div style="position:absolute;left:0px; top:5px;">
		<epg:if test="${upResults[0] != null}">
			<epg:navUrl obj="${upResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="up0" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea0','rainbowzhuanqu');"  onblur="itemOnBlur('uparea0');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:80px; top:5px;">
		<epg:if test="${upResults[1] != null}">
			<epg:navUrl obj="${upResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="up1" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea1','rainbowzhuanqu');"  onblur="itemOnBlur('uparea1');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:160px; top:5px;">
		<epg:if test="${upResults[2] != null}">
			<epg:navUrl obj="${upResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="up2" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea2','rainbowzhuanqu');"  onblur="itemOnBlur('uparea2');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:240px; top:5px;">
		<epg:if test="${upResults[3] != null}">
			<epg:navUrl obj="${upResults[3]}" indexUrlVar="indexUrl"/>
			<epg:img id="up3" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea3','rainbowzhuanqu');"  onblur="itemOnBlur('uparea3');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
</div>
<!-- 中间导航 -->
	<div style="position:absolute;left:48px; top:389px;">
		<epg:if test="${menuResults[0] != null}">
			<epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="menu0" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area0','rainbowdaohang');"  onblur="itemOnBlur('area0');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	
	<div style="position:absolute;left:211px; top:362px;">
		<epg:if test="${menuResults[1] != null}">
			<epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="menu1" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area1','rainbowdaohang');"  onblur="itemOnBlur('area1');"
				src="./images/dot.gif" />
		</epg:if>
	</div>

	<div style="position:absolute;left:370px; top:304px;">
		<epg:if test="${menuResults[2] != null}">
		<epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="menu2" height="74" width="80" 
				src="./images/dot.gif" />
			<epg:img id="menu2focus" height="74" width="80"  href="${indexUrl}"
				onfocus="itemOnFocus('area2','rainbowdaohang');"  onblur="itemOnBlur('area2');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	
	<div style="position:absolute;left:524px; top:391px;">
		<epg:if test="${menuResults[3] != null}">
			<epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
			<epg:img id="menu3" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area3','rainbowdaohang');"  onblur="itemOnBlur('area3');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
<!-- 首页底部导航 -->
<div style="position:absolute;width:320px;height:116px;left:107px;top:554px;"> 
	<div style="position:absolute;left:0px; top:5px;">
		<epg:if test="${downResults[0] != null}">
			<epg:navUrl obj="${downResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="down0" height="116" width="87"  href="${indexUrl}&returnTo=biz"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea0','rainbowbutton');"  onblur="itemOnBlur('downarea0');"
				src="./images/dot.gif" />
			<epg:img id="downImg0" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="./images/islandHostShowPic.jpg" />
		</epg:if>
	</div>
	<div style="position:absolute;left:92px; top:5px;">
		<epg:if test="${downResults[1] != null}">
			<epg:navUrl obj="${downResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="down1" height="116" width="87"  href="${indexUrl}&returnTo=biz"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea1','rainbowbutton');"  onblur="itemOnBlur('downarea1');"
				src="./images/dot.gif" />
			<epg:img id="downImg1" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="./images/superBigChallengePic.jpg" />
		</epg:if>
	</div>
	<div style="position:absolute;left:183px;top:5px;">
		<epg:if test="${recommendResults[0] != null}">
			<epg:navUrl obj="${recommendResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="down2" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=1"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea2','rainbowbutton');"  onblur="itemOnBlur('downarea2');"
				src="./images/dot.gif" />
			<epg:img id="downImg2"  style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[0].itemIcon}" />
		</epg:if>
	</div>
	<div style="position:absolute;left:275px; top:5px;">
		<epg:if test="${recommendResults[1] != null}">
			<epg:navUrl obj="${recommendResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="down3" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=2"  left="5" top="-2"
				onfocus="itemOnFocus('downarea3','rainbowbutton');"  onblur="itemOnBlur('downarea3');"
				src="./images/dot.gif" />
			<epg:img id="downImg3" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[1].itemIcon}" />
		</epg:if>
	</div>
	<div style="position:absolute;left:367px; top:5px;">
		<epg:if test="${recommendResults[2] != null}">
			<epg:navUrl obj="${recommendResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="down4" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=3"  left="5" top="-2"
				onfocus="itemOnFocus('downarea4','rainbowbutton');"  onblur="itemOnBlur('downarea4');"
				src="./images/dot.gif" />
			<epg:img id="downImg4" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[2].itemIcon}" />
		</epg:if>
	</div>
</div>
<!-- 返回点播首页 -->
<div  style="position:absolute;width:80px;height:71px;left:530px;top:42px;"> 
	<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
	<epg:img height="70" width="70"  href="${returnUrl}" 
		onfocus="itemOnFocus('back','backToIndex');"  onblur="itemOnBlur('back');"
		src="./images/dot.gif" />
</div>
<!-- 彩虹形象 -->
<epg:if test="${customer.icon!=null}">
	<div style="position:absolute;width:54px;height:168px;left:38px;top:462px;">
		<epg:img id="rainbowFigure" height="168" width="54"  src="../${customer.icon}" />
	</div>
</epg:if>
<epg:if test="${customer.icon==null}">
	<div style="position:absolute;width:54px;height:168px;left:38px;top:462px;">
		<epg:img id="rainbowFigure"  src="./images/dot.gif" />
	</div>
</epg:if>

<div id="uparea0_div" style="position:absolute;width:73px;height:87px;left:177px;top:48px;visibility:hidden;"><epg:img id="uparea0" width="73" height="87" src="./images/dot.gif" /></div>
<div id="uparea1_div" style="position:absolute;width:73px;height:87px;left:256px;top:48px;visibility:hidden;"><epg:img id="uparea1" width="73" height="87" src="./images/dot.gif" /></div>
<div id="uparea2_div" style="position:absolute;width:73px;height:87px;left:337px;top:48px;visibility:hidden;"><epg:img id="uparea2" width="73" height="87" src="./images/dot.gif" /></div>
<div id="uparea3_div" style="position:absolute;width:73px;height:87px;left:417px;top:48px;visibility:hidden;"><epg:img id="uparea3" width="73" height="87" src="./images/dot.gif" /></div>
<!-- <div id="uparea4_div" style="position:absolute;width:73px;height:87px;left:942px;top:48px; border:#FF0000 4px solid;visibility:hidden;"><epg:img id="uparea4" width="73" height="87" src="./images/dot.gif" /></div> -->
<div id="area0_div" style="position:absolute;width:80px;height:74px;left:48px;top:389px;visibility:hidden;"><epg:img id="area0" width="76" height="74" src="./images/dot.gif" /></div>
<div id="area1_div" style="position:absolute;width:80px;height:74px;left:211px;top:362px;visibility:hidden;"><epg:img id="area1" width="76" height="74" src="./images/dot.gif" /></div>
<div id="area2_div" style="position:absolute;width:80px;height:74px;left:370px;top:304px;visibility:hidden;"><epg:img id="area2" width="76" height="74" src="./images/dot.gif" /></div>
<div id="area3_div" style="position:absolute;width:80px;height:74px;left:524px;top:391px;visibility:hidden;"><epg:img id="area3" width="76" height="74" src="./images/dot.gif" /></div>
<div id="back_div" style="position:absolute;width:70px;height:70px;left:530px;top:40px;visibility:hidden;"><epg:img id="back" width="70" height="74" src="./images/dot.gif" /></div>
<div id="downarea0_div" style="position:absolute;width:87px;height:116px;left:105px;top:555px; visibility:hidden;"><epg:img id="downarea0" width="87" height="116" src="./images/dot.gif" /></div>
<div id="downarea1_div" style="position:absolute;width:87px;height:116px;left:197px;top:555px; visibility:hidden;"><epg:img id="downarea1" width="87" height="116" src="./images/dot.gif" /></div>
<div id="downarea2_div" style="position:absolute;width:87px;height:116px;left:288px;top:555px; visibility:hidden;"><epg:img id="downarea2" width="87" height="116" src="./images/dot.gif" /></div>
<div id="downarea3_div" style="position:absolute;width:87px;height:116px;left:380px;top:555px; visibility:hidden;"><epg:img id="downarea3" width="87" height="116" src="./images/dot.gif" /></div>
<div id="downarea4_div" style="position:absolute;width:87px;height:116px;left:471px;top:555px; visibility:hidden;"><epg:img id="downarea4" width="87" height="116" src="./images/dot.gif" /></div>
</div>
<!-- ******************************************************** -->
<div id="rightDiv">
<epg:img src="./images/rainbow.jpg" width="640" height="720" left="642" top="0"/>
<!-- 首页品牌专区 -->
<div style="position:absolute;width:315px;height:116px;left:817px;top:43px;"> 
	<div style="position:absolute;left:0px; top:5px;">
		<epg:if test="${upResults[0] != null}">
			<epg:navUrl obj="${upResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_up0" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea0','rainbowzhuanqu');"  onblur="itemOnBlur('uparea0');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:80px; top:5px;">
		<epg:if test="${upResults[1] != null}">
			<epg:navUrl obj="${upResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_up1" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea1','rainbowzhuanqu');"  onblur="itemOnBlur('uparea1');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:160px; top:5px;">
		<epg:if test="${upResults[2] != null}">
			<epg:navUrl obj="${upResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_up2" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea2','rainbowzhuanqu');"  onblur="itemOnBlur('uparea2');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	<div style="position:absolute;left:240px; top:5px;">
		<epg:if test="${upResults[3] != null}">
			<epg:navUrl obj="${upResults[3]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_up3" height="87" width="73"  href="${indexUrl}" 
				onfocus="itemOnFocus('uparea3','rainbowzhuanqu');"  onblur="itemOnBlur('uparea3');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
</div>
<!-- 中间导航 -->
	<div style="position:absolute;left:688px; top:389px;">
		<epg:if test="${menuResults[0] != null}">
			<epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_menu0" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area0','rainbowdaohang');"  onblur="itemOnBlur('area0');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	
	<div style="position:absolute;left:851px; top:362px;">
		<epg:if test="${menuResults[1] != null}">
			<epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_menu1" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area1','rainbowdaohang');"  onblur="itemOnBlur('area1');"
				src="./images/dot.gif" />
		</epg:if>
	</div>

	<div style="position:absolute;left:1010px; top:304px;">
		<epg:if test="${menuResults[2] != null}">
		<epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_menu2" height="74" width="80" 
				src="./images/dot.gif" />
			<epg:img id="r_menu2focus" height="74" width="80"  href="${indexUrl}"
				onfocus="itemOnFocus('area2','rainbowdaohang');"  onblur="itemOnBlur('area2');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
	
	<div style="position:absolute;left:1164px; top:391px;">
		<epg:if test="${menuResults[3] != null}">
			<epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_menu3" height="74" width="80"  href="${indexUrl}" 
				onfocus="itemOnFocus('area3','rainbowdaohang');"  onblur="itemOnBlur('area3');"
				src="./images/dot.gif" />
		</epg:if>
	</div>
<!-- 首页底部导航 -->
<div style="position:absolute;width:960px;height:116px;left:757px;top:554px;"> 
	<div style="position:absolute;left:0px; top:5px;">
		<epg:if test="${downResults[0] != null}">
			<epg:navUrl obj="${downResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_down0" height="116" width="87"  href="${indexUrl}&returnTo=biz"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea0','rainbowbutton');"  onblur="itemOnBlur('downarea0');"
				src="./images/dot.gif" />
			<epg:img id="r_downImg0" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="./images/islandHostShowPic.jpg" />
		</epg:if>
	</div>
	<div style="position:absolute;left:92px; top:5px;">
		<epg:if test="${downResults[1] != null}">
			<epg:navUrl obj="${downResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_down1" height="116" width="87"  href="${indexUrl}&returnTo=biz"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea1','rainbowbutton');"  onblur="itemOnBlur('downarea1');"
				src="./images/dot.gif" />
			<epg:img id="r_downImg1" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="./images/superBigChallengePic.jpg" />
		</epg:if>
	</div>
	<div style="position:absolute;left:183px;top:5px;">
		<epg:if test="${recommendResults[0] != null}">
			<epg:navUrl obj="${recommendResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_down2" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=1"  left="-5" top="-2"
				onfocus="itemOnFocus('downarea2','rainbowbutton');"  onblur="itemOnBlur('downarea2');"
				src="./images/dot.gif" />
			<epg:img id="r_downImg2"  style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[0].itemIcon}" />
		</epg:if>
	</div>
	<div style="position:absolute;left:275px; top:5px;">
		<epg:if test="${recommendResults[1] != null}">
			<epg:navUrl obj="${recommendResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_down3" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=2"  left="5" top="-2"
				onfocus="itemOnFocus('downarea3','rainbowbutton');"  onblur="itemOnBlur('downarea3');"
				src="./images/dot.gif" />
			<epg:img id="r_downImg3" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[1].itemIcon}" />
		</epg:if>
	</div>
	<div style="position:absolute;left:367px; top:5px;">
		<epg:if test="${recommendResults[2] != null}">
			<epg:navUrl obj="${recommendResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img id="r_down4" height="116" width="87"  href="${indexUrl}&returnTo=biz&pi=3"  left="5" top="-2"
				onfocus="itemOnFocus('downarea4','rainbowbutton');"  onblur="itemOnBlur('downarea4');"
				src="./images/dot.gif" />
			<epg:img id="r_downImg4" style="border:#6a3d21 2px solid;" height="90" width="75" left="5" top="5" src="../${recommendResults[2].itemIcon}" />
		</epg:if>
	</div>
</div>
<!-- 返回点播首页 -->
<div  style="position:absolute;width:80px;height:71px;left:1170px;top:42px;"> 
	<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
	<epg:img height="70" width="70"  href="${returnUrl}" 
		onfocus="itemOnFocus('back','backToIndex');"  onblur="itemOnBlur('back');"
		src="./images/dot.gif" />
</div>
<!-- 彩虹形象 -->
<epg:if test="${customer.icon!=null}">
	<div style="position:absolute;width:54px;height:168px;left:38px;top:462px;">
		<epg:img id="r_rainbowFigure" height="168" width="54"  src="../${customer.icon}" />
	</div>
</epg:if>
<epg:if test="${customer.icon==null}">
	<div style="position:absolute;width:54px;height:168px;left:38px;top:462px;">
		<epg:img id="r_rainbowFigure"  src="./images/dot.gif" />
	</div>
</epg:if>

<div id="r_uparea0_div" style="position:absolute;width:73px;height:87px;left:817px;top:48px;visibility:hidden;"><epg:img id="r_uparea0" width="73" height="87" src="./images/dot.gif" /></div>
<div id="r_uparea1_div" style="position:absolute;width:73px;height:87px;left:896px;top:48px;visibility:hidden;"><epg:img id="r_uparea1" width="73" height="87" src="./images/dot.gif" /></div>
<div id="r_uparea2_div" style="position:absolute;width:73px;height:87px;left:977px;top:48px;visibility:hidden;"><epg:img id="r_uparea2" width="73" height="87" src="./images/dot.gif" /></div>
<div id="r_uparea3_div" style="position:absolute;width:73px;height:87px;left:1057px;top:48px;visibility:hidden;"><epg:img id="r_uparea3" width="73" height="87" src="./images/dot.gif" /></div>
<!-- <div id="r_uparea4_div" style="position:absolute;width:73px;height:87px;left:942px;top:48px; border:#FF0000 4px solid;visibility:hidden;"><epg:img id="r_uparea4" width="73" height="87" src="./images/dot.gif" /></div> -->
<div id="r_area0_div" style="position:absolute;width:80px;height:74px;left:688px;top:389px;visibility:hidden;"><epg:img id="r_area0" width="76" height="74" src="./images/dot.gif" /></div>
<div id="r_area1_div" style="position:absolute;width:80px;height:74px;left:851px;top:362px;visibility:hidden;"><epg:img id="r_area1" width="76" height="74" src="./images/dot.gif" /></div>
<div id="r_area2_div" style="position:absolute;width:80px;height:74px;left:1010px;top:304px;visibility:hidden;"><epg:img id="r_area2" width="76" height="74" src="./images/dot.gif" /></div>
<div id="r_area3_div" style="position:absolute;width:80px;height:74px;left:1164px;top:391px;visibility:hidden;"><epg:img id="r_area3" width="76" height="74" src="./images/dot.gif" /></div>
<div id="r_back_div" style="position:absolute;width:70px;height:70px;left:1170px;top:40px;visibility:hidden;"><epg:img id="r_back" width="70" height="74" src="./images/dot.gif" /></div>
<div id="r_downarea0_div" style="position:absolute;width:87px;height:116px;left:745px;top:555px; visibility:hidden;"><epg:img id="r_downarea0" width="87" height="116" src="./images/dot.gif" /></div>
<div id="r_downarea1_div" style="position:absolute;width:87px;height:116px;left:837px;top:555px; visibility:hidden;"><epg:img id="r_downarea1" width="87" height="116" src="./images/dot.gif" /></div>
<div id="r_downarea2_div" style="position:absolute;width:87px;height:116px;left:928px;top:555px; visibility:hidden;"><epg:img id="r_downarea2" width="87" height="116" src="./images/dot.gif" /></div>
<div id="r_downarea3_div" style="position:absolute;width:87px;height:116px;left:1020px;top:555px; visibility:hidden;"><epg:img id="r_downarea3" width="87" height="116" src="./images/dot.gif" /></div>
<div id="r_downarea4_div" style="position:absolute;width:87px;height:116px;left:1111px;top:555px; visibility:hidden;"><epg:img id="r_downarea4" width="87" height="116" src="./images/dot.gif" /></div>
</div>
</epg:body>
</epg:html>