<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<epg:html>


<epg:query queryName="selectCustomer" var="customer" maxRows="1">
	<epg:param name="accountId" value="${EPG_USER_SESSION.userId}" type="java.lang.String" />
</epg:query>

<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnindexCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 走马灯 -->
<epg:query queryName="getSeverialItems" maxRows="10" var="_newsContents">
	<epg:param name="categoryCode" value="${templateParams['newsCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>
<epg:navUrl obj="${returnindexResults}" indexUrlVar="returnindexResults"/>
<head>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />
<link rel="stylesheet" type="text/css" href="${context['EPG_CONTEXT']}/css/cinema.css">
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
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
if(typeof(iPanel)!='undefined'){
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
}
</script>
</head>


<epg:body  defaultBg="./images/islandHostShow.jpg" bgcolor="#000000" style="background-repeat:no-repeat;">
<!-- 表单 -->
<div style="position: absolute;left: 0; top: 0; width:640px; height: 526px;" >
<form name="customerForm" id="customerForm"  method="get" action="${context['EPG_CONTEXT']}/customer/addCustomer.do">
<input type="hidden" name="id" value="${customer.id}">
<input type="hidden" name="accountId" value="${EPG_USER_SESSION.userId}">

<!-- 性别 -->
<epg:div id="gendar_div" left="463" top="177" width="72" height="35">
<epg:img src="./images/dot.gif" width="72" height="35" id="gendar_focus" />
<input type="text" name="gendar" id="gendar" maxlength="1" value="${customer.gendar}" 
	 style="position:absolute; left:0; top: 0; width: 72; height:35;font-size:26px; "
	    onblur="clickedInfo('gendar','gendar')"   />
</epg:div>

<!-- 时间录入 -->
<epg:div id="my_year_div" left="463" top="320" width="100" height="39">
<input type="text"  maxlength="4" id="year" value='<fmt:formatDate pattern="yyyy"  value="${customer.birthday}"/>' style="position:absolute; left:0; top: 0;width: 100; height:38;font-size:26px; background-color:#FFFFFF"   onblur="clickedInfo('year','birthday')"  />
</epg:div>

<epg:div id="my_month_div" left="616" top="320" width="60" height="39">
<input type="text"  maxlength="2" id='month' value='<fmt:formatDate pattern="MM"  value="${customer.birthday}"/>' style="position:absolute; left:0; top: 0;width: 60; height:38;font-size:26px;background-color:#FFFFFF "   onblur="clickedInfo('month','birthday')" />
</epg:div>
<epg:div id="my_date_div" left="720" top="320" width="80" height="39">
<input type="text"  maxlength="2" id='date' value='<fmt:formatDate pattern="dd"  value="${customer.birthday}"/>' style=" position:absolute; left:0; top: 0;width: 60; height:38;font-size:26px;background-color:#FFFFFF "  onblur="clickedInfo('date','birthday')" />
</epg:div>
<input type="hidden" id="birthdayString" name="birthdayString" value='<fmt:formatDate pattern="yyyy-MM-dd"  value="${customer.birthday}"/>' />

<!-- 性别提示框 -->
<epg:text  fontSize="24"  align="left" color="#FF0000" text="" id="alert_gendar" left="870" top="177"  width="180"/>

<!-- 时间提示框 -->
<epg:text  fontSize="22"  align="left" color="#FF0000" text="" id="alert_year" left="870" top="322" width="180" />
<!-- <epg:text  fontSize="24"  align="left" color="#FF0000" text="" id="alert_month" left="870" top="322"  />
<epg:text  fontSize="24"  align="left" color="#FF0000" text="" id="alert_date" left="870" top="322"  /> -->

<!--手机号录入-->
<epg:div id="my_phoneNumber_div" left="463" top="370" width="277" height="39" >
<input type="text" name="phoneNumber" id="phoneNumber" maxlength="11" value="${customer.phoneNumber}" style="position:absolute; left:0; top: 0; width:275; height:38;font-size:26px;background-color:#FFFFFF "  size="25" onblur="clickedInfo('phoneNumber','phoneNumber');"  />
</epg:div>
<!-- 手机提示框 -->
<epg:text  fontSize="24"  align="left" color="#FF0000" text="" id="alert_text"  width="180"  left="760" top="370"  />


<!-- 彩虹形象 -->
<epg:div id="my_icon_div" left="463" top="423" width="57" height="39" >
<epg:choose>
<epg:when test="${templateParams['smallImg1']==customer.icon}">   
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='1' onblur="clickedInfo('${templateParams['smallImg1']}','figure');"/>
</epg:when>
<epg:when test="${templateParams['smallImg2']==customer.icon}">  
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='2' onblur="clickedInfo('${templateParams['smallImg2']}','figure');"/> 
</epg:when>
<epg:when test="${templateParams['smallImg3']==customer.icon}"> 
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='3' onblur="clickedInfo('${templateParams['smallImg3']}','figure');"/>  
</epg:when>
<epg:when test="${templateParams['smallImg4']==customer.icon}">   
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='4' onblur="clickedInfo('${templateParams['smallImg4']}','figure');"/>
</epg:when>
<epg:when test="${templateParams['smallImg5']==customer.icon}">   
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='5' onblur="clickedInfo('${templateParams['smallImg5']}','figure');"/>
</epg:when>
<epg:when test="${templateParams['smallImg6']==customer.icon}"> 
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" value='6' onblur="clickedInfo('${templateParams['smallImg6']}','figure');"/>  
</epg:when>
<epg:otherwise>
	<input type="text" id="iconId" name="iconId"   maxlength="1" size="3" style="width:65px; height:35px;   font-size:26px;background-color:#FFFFFF" onblur="clickedInfo('icon','figure');" />
</epg:otherwise>
</epg:choose>
</epg:div>
<input type="hidden" id="icon" name='icon' value="${customer.icon}" /> 
<!-- 彩虹形象提示框 -->
<div id="alert_icon" align="left" style="font-size:24px;position:absolute;left:820px;top:424px;width:180px;height:26px;color: #FF0000"></div>
<!--<epg:text  fontSize="24"  align="left" color="#FF0000" text="" id="alert_icon" left="820" top="432" width="180" />-->


<epg:img src="./images/dot.gif" height="122" left="1087" top="31" width="127" href="${returnindexResults}"  />


<input type="hidden" name="homeUrl" value="${returnindexResults}" />

<!-- 完成 -->
<epg:img  src="./images/dot.gif" left="534" top="593" width="203" height="39" href="#" onclick="submitForm();" />
</form>
</div>

<!-- 底部跑马灯 -->
<div id="marqueeItem" style="position: absolute;left:267px;top:637px;width:744px;height:52px;color: #ffffff;font-size: 24px;line-height:52px;" align="center"; >
<marquee id="marqueeItem" style="font-size: 24px;color:#ffffff">
	<!-- <epg:forEach var="re" items="${_newsContents}" varStatus="idx" >
		<epg:query queryName="getValidPositionByCode" maxRows="1" var="pos">
			<epg:param name="code" value="${_newsContents[idx.index].itemCode}" type="java.lang.String"/>
		</epg:query>
		<span>${pos.objValue}&nbsp;&nbsp;&nbsp;&nbsp;</span>
	</epg:forEach> -->
	<span>注册成为小岛主，秀形象，赢惊喜！&nbsp;&nbsp;&nbsp;&nbsp;</span>
</marquee>
</div>
<script type="text/javascript">

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色

function clickedInfo(value,type,id){
<!--角色-->
if(type=='gendar'){
	var gendar = document.getElementById('gendar').value;
	if(gendar!='1'&&gendar!='2'){
		document.getElementById('alert_gendar_span').innerHTML='输入错误!';
		//document.getElementById("gendar").focus();
	}else{
		document.getElementById('alert_gendar_span').innerHTML='';
	}
}

<!--生日-->
if(type=='birthday'){

<!--年 -->
if(value=='year'){
var year=document.getElementById('year').value;
<!-- 验证年 -->
 var d = new Date();
var regex=/^\d{4}$/;
	if(!regex.test(year)){
		document.getElementById('alert_year_span').innerHTML='年份输错啦!';
		//document.getElementById("year").focus();
	}else{
		document.getElementById('alert_year_span').innerHTML='';
	}
}

<!--月 -->
if(value=='month'){
var month=document.getElementById('month').value;
<!-- 验证月 -->
var regex=/^\d{1,2}$/;
	if(!regex.test(month)||month>12){
		document.getElementById('alert_year_span').innerHTML='月份输错啦!';
		//document.getElementById("month").focus();
	}else{
		document.getElementById('alert_year_span').innerHTML='';
	}
}

<!-- 日 -->
if(value=='date'){
var date=document.getElementById('date').value;
<!-- 验证日 -->
var regex=/^\d{1,2}$/;
	if(!regex.test(date)||date>31){
		document.getElementById('alert_year_span').innerHTML='日期输错啦!';
		//document.getElementById("date").focus();
	}else{
		document.getElementById('alert_year_span').innerHTML='';
	}
}

var yearPara=document.getElementById('year').value;
var monthPara=document.getElementById('month').value;
var dataPara=document.getElementById('date').value;

if(yearPara==null||yearPara==''||monthPara==null||monthPara==''||dataPara==null||dataPara==''){
document.getElementById('birthdayString').value='';
return;
}

document.getElementById('birthdayString').value=yearPara+'-'+monthPara+'-'+dataPara;

}


//验证手机号
if(value=='phoneNumber'){
var phoneNumber=document.getElementById("phoneNumber").value;

var regex=/^\d{0,12}$/;
	if(!regex.test(phoneNumber)){
		document.getElementById('alert_text_span').innerHTML='号码输错啦!';
		//document.getElementById("phoneNumber").focus();
	}else{
		document.getElementById('alert_text_span').innerHTML='';
	}
}


<!--用户头像-->
if(type=='figure'){
	//alert(document.getElementById("iconId").value);
	if(document.getElementById("iconId").value!=""&&document.getElementById("iconId").value!=null){
		var figureNum = document.getElementById("iconId").value;
		var smallImg1 = "${templateParams['smallImg1']}";
		var smallImg2 = "${templateParams['smallImg2']}";
		var smallImg3 = "${templateParams['smallImg3']}";
		var smallImg4 = "${templateParams['smallImg4']}";
		var smallImg5 = "${templateParams['smallImg5']}";
		var smallImg6 = "${templateParams['smallImg6']}";
		if(figureNum==1){
			var icon = smallImg1;
		}else if(figureNum==2){
			var icon = smallImg2;
		}else if(figureNum==3){
			var icon = smallImg3;
		}else if(figureNum==4){
			var icon = smallImg4;
		}else if(figureNum==5){
			var icon = smallImg5;
		}else if(figureNum==6){
			var icon = smallImg6;
		}
	}else{
		if("${customer.icon}"==smallImg1){
			document.getElementById("iconId").value = "1";
		}else if("${customer.icon}"==smallImg2){
			document.getElementById("iconId").value = "2";
		}else if("${customer.icon}"==smallImg3){
			document.getElementById("iconId").value = "3";
		}else if("${customer.icon}"==smallImg4){
			document.getElementById("iconId").value = "4";
		}else if("${customer.icon}"==smallImg5){
			document.getElementById("iconId").value = "5";
		}else if("${customer.icon}"==smallImg6){
			document.getElementById("iconId").value = "6";
		}
	}
	document.getElementById("icon").value = icon;
	if(figureNum!="1"&&figureNum!="2"&&figureNum!="3"&&figureNum!="4"&&figureNum!="5"&&figureNum!="6"){
		document.getElementById('alert_icon').innerHTML='输入错误!';
		//document.getElementById("iconId").focus();
	}else{
		document.getElementById('alert_icon').innerHTML='';
	}
}
}

<!--提交-->
function submitForm(){
document.customerForm.submit();
}


<epg:if test="${customer.gendar!=''&&customer.gendar!=null}">
clickedInfo('${customer.gendar}','gendar');
</epg:if>

<epg:if test="${customer.birthday!=''&&customer.birthday!=null}">
clickedInfo(0,'birthday');
</epg:if>

<epg:if test="${customer.icon!=''&&customer.icon!=null}">
function checkedIcon(){
	clickedInfo('${customer.icon}','figure');
}
document.body.onload=checkedIcon();
</epg:if>

</script>
</epg:body>
</epg:html>