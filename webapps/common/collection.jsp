<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@page import="java.util.*" %>
<%@page import="net.sf.json.*" %>
<%
String flag = request.getAttribute("isSuccess").toString();

if ("1".equals(flag)){
	request.setAttribute("note","收藏成功");
}else if ("2".equals(flag)){
	request.setAttribute("note","收藏失败");
}else if ("3".equals(flag)){
	request.setAttribute("note","该片已收藏");
}else if ("5".equals(flag)){
	request.setAttribute("note","超过收藏上限");
}

%>
<epg:html>
<script src="<%=request.getContextPath()%>/js/base.js"></script>
<script>
document.onsystemevent = grabEventDetail;
document.onkeypress = grabEventDetail;
document.onirkeypress = grabEventDetail;
function grabEventDetail(){
	var keycode = event.which;
	switch(keycode){
		case 1://up
			return 0;
			break; 
		case 2://down
			return 0;
			break; 
		case 3://left
			return 0;
			break; 
		case 4://right
			return 0;
			break; 
		case 339:
		case 340:
			closeOverLayFrame();
			return 0;
		  break;
	}
}
function init(){
	$id("main").style.display = "block";
}
</script>

<body onload="init()" bgcolor="transparent">
<div  id="main" style="position:absolute; display:none;  background-color: black; z-index: 1; filter:alpha(opacity=50);opacity: 0.9;width:100%;height:720;left0;top:0">
<epg:div left="338" top="184" width="500" height="330" style="z-index: 1" ><epg:img width="500" height="330" src="/common/images/bg_collection.png"/>
<div style="position: absolute;left: 60;top: 80">
<epg:if test="${isSuccess!=1}"><epg:img src="/common/images/collect_fail.png" width="113" height="109" left="0" top="0"/></epg:if>
<epg:if test="${isSuccess==1}"><epg:img src="/common/images/collect_success.png" width="113" height="109" left="0" top="0"/></epg:if>
<epg:text text="${note}" color="#ffffff" left="120" top="55" fontSize="36" width="250"></epg:text>
</div>
<div style="position: absolute; left: 200;top: 230">
<epg:img src="/common/images/dot.gif" width="110" height="50" href="#" onclick="closeOverLayFrame();"/>
</div>
</epg:div>
</div>
</body>
</epg:html>