<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%request.getSession().removeAttribute("PlayBackURL");%>
<epg:html>
<epg:query queryName="getSeverialItems" maxRows="20" var="menuResults" >
	<epg:param name="categoryCode" value="${menuCategoryCode}" type="java.lang.String"/>
</epg:query>
<style type="text/css">
	ul{text-align:left;list-style-type:none; font-size:28px; color:#CCCCCC; }
    ul li{display:inline;list-style-type:none;  text-align:left}
	 .txt{
		 font-size:28px; color:#CCCCCC; line-height:50px; text-align:left; vertical-align:middle
	 }
	 .tab_txt{  
	      font-size:28px; color:#CCCCCC; 
	 }
	a{
	 	color:#999999;
	 	text-decoration:none;
	 }
	img{
		border:0px solid black; 
	}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script src="${context['EPG_CONTEXT']}/js/showList.js"></script>
<script>
//iPanel.focus.display = 0;
//iPanel.focus.border = 0;
var pagesize=8;
var startPage;
var page;
var flag=0;
var currslid = 0;
var slidint;
var rightup;
var rightId;
var curor;
var currentFocusId;
var upId;
var turnup;
var div1up;
var div1;
var div2;
var focusDiv1;
var focusDiv;
var focusDiv3;
var movurl;
var tot;
var toturl;
var totajax;
var movieajax;
var movielist=[];
var resultUrl = window.location.href;
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "EIS_IRKEY_UP":
		if(rightId=="img0" &&focusDiv.style.visibility=="visible"){
			if(startPage>1){
				flag=0;
				startPage--;
				rightId="img0";
				movurl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmark.do?p="+(startPage-1)+"&s="+pagesize+"&r="+Math.random();
				toturl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmarkTotal.do?r="+Math.random();
				movieajax= new AJAX_OBJ(movurl,movResponse);
				totajax= new AJAX_OBJ(toturl,totResponse); 
	    		movieajax.requestData();
	    		totajax.requestData();
	     }
		}
	    	break;
		case "EIS_IRKEY_DOWN":
		if(rightId=="img7"&&focusDiv.style.visibility=="visible"){	
			if(startPage<page){
				flag=0;
				startPage++;
				rightId="img0";
				movurl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmark.do?p="+(startPage-1)+"&s="+pagesize+"&r="+Math.random();
				toturl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmarkTotal.do?r="+Math.random();
				movieajax= new AJAX_OBJ(movurl,movResponse);
				totajax= new AJAX_OBJ(toturl,totResponse);
	   			movieajax.requestData();
	    		totajax.requestData();
				}	
			}
	    	break;
		case "EIS_IRKEY_SELECT":
			break;
		case "EIS_IRKEY_LEFT":
	    	break;
	    case "EIS_CA_SMARTCARD_EVULSION":
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
function init(){	
	focusDiv1 = document.getElementById("focusDiv1");
	focusDiv = document.getElementById("focusDiv");
	focusDiv3 = document.getElementById("focusDiv3");
	startPage=1;
	showObject=new showContent(8,3,245,60);
	movurl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmark.do?p=0&s="+pagesize+"&r="+Math.random();
	toturl=resultUrl.substring(0,resultUrl.indexOf("/myBookmark"))+"/getBookmarkTotal.do?r="+Math.random();
	movieajax= new AJAX_OBJ(movurl,movResponse);
	totajax= new AJAX_OBJ(toturl,totResponse);
	movieajax.requestData();
	totajax.requestData();
}
function movResponse(xmlHttpResponse){
	movielist=eval(xmlHttpResponse.responseText);
	if(movielist==null){
		document.getElementById("bookmark_a").focus();
	}
	for(var i=0;i<8;i++){
	var img=$("img"+i);
	if(movielist[i]!=null){
			var contentName=movielist[i].contentName;
			var elapsed=movielist[i].contentElapsed;
			var hour = parseInt(elapsed/3600);
			var minute = parseInt((elapsed - hour*3600)/60);
			var second = elapsed - (minute*60)-(hour*3600);
			if(hour<10)hour="0"+hour;
			if(minute<10)minute="0"+minute;
			if(second<10)second="0"+second;
			var dot="${context['EPG_CONTEXT']}/common/images/dot.gif";
			var str="<a id=\"img"+i+"_a\" href=\"#\" onfocus=\"posterup(\'img"+i+"\');\" >"
			str +="<img src=\""+dot+"\" width=\"250\" height=\"50\"></a><div style=\"position:absolute; top:0px; width:300px;height: 50px; left: 85px;\"><span id=\"img"+i+"_title\" style=\"font-size:26px;color:#999999;\"></span></div>"; 
			str +="<div id=\"add_time"+i+"\" style=\"position:absolute; top:10px; width:300px; left: 450px; height: 50px;font-size:24px;color:#999999;\">"+hour+":"+minute+":"+second+"</div>";
			img.style.visibility = "visible";
			img.innerHTML=str;
			var mov=document.getElementById("img"+i+"_title");
			var imga=document.getElementById("img"+i+"_a");
			mov.innerHTML = (i+1)+"."+showObject.showPartWord(contentName);
			imga.href=movielist[i].indexUrl;
			if(flag==0){
				 document.getElementById("img0_a").focus();
			 }
			
	    }
		else{
			img.innerHTML="";
			img.style.visibility = "hidden";
		}
	}
}
function getNum(pxValue){
	if (isNaN(pxValue)){
		return parseInt(pxValue.substring(0,pxValue.indexOf("px")));
	}else{
		return parseInt(pxValue);
		
	}
	
}
function trunup(actId){//左边的滑动
	if (typeof(turnup)!='undefined'){	
		if (!turnup.finished) {
			
			//将获得的焦点取消掉
			var ahref = document.getElementById(upId+'_a');
			if (upId != actId ){
				ahref.focus();
			}
			return; //如果动画未完成,则不响应.
		}	
	}
	leavemov();
	//将新获得的焦点保存
	upId=actId;
	var recDiv1 = document.getElementById(actId);
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (focusDiv1.style.visibility == "hidden"){
			//设置可见
			focusDiv1.style.top=getNum(recDiv1.style.top)-15;
			focusDiv1.style.visibility = 'visible';
			focusDiv.style.visibility="hidden";
			focusDiv3.style.visibility="hidden";
	}else{
		//比较焦点框和新获得的焦点之间垂直方向的差		
		var topDif = getNum(focusDiv1.style.top) - getNum(recDiv1.style.top)+15;
		var TTop = 0; //默认垂直方向.
		var selectedDiv = topDif; //默认垂直差
		//设置滑动动画
		turnup = new showSlip1("focusDiv1",TTop,2,40);	
		
		//开始动画
		if (selectedDiv>0){
			turnup.moveStart(-1,selectedDiv); //反向滑动	3
		}else{
			turnup.moveStart(1,-selectedDiv); //正向滑动.
		}
	}
	
	
}
function leavemov(){
	for(var j=0;j<movielist.length;j++){
	 	 $("add_time"+j).style.color="#999999";
		 $("img"+j+"_title").style.color="#999999";
		 $("img"+j+"_title").innerHTML=(j+1)+"."+showObject.showPartWord(movielist[j].contentName);
	}
}
function posterup(img){	//书签的滑动
	if (typeof(rightup)!='undefined'){
		if (!rightup.finished) {
			//将获得的焦点取消掉
			var ahref = document.getElementById(rightId+'_a');
			if (rightId != img ){			
				ahref.focus();
			}
			return; //如果动画未完成,则不响应.
		}	
	}
	if(rightId!=null){
		 $("add_time"+rightId.substr(3,4)).style.color="#999999";
		 $("img"+rightId.substr(3,4)+"_title").style.color="#999999";
	 	 $("img"+rightId.substr(3,4)+"_title").innerHTML=(parseInt(rightId.substr(3,4))+1)+"."+showObject.showPartWord(movielist[rightId.substr(3,4)].contentName);
	}
	//将新获得的焦点保存
	rightId=img;
	var imgDiv1 = document.getElementById(img);
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (focusDiv.style.visibility == "hidden"){
		//设置可见
		focusDiv.style.top=getNum(imgDiv1.style.top)-4;
		focusDiv.style.visibility = 'visible';
		focusDiv1.style.visibility="hidden";
		focusDiv3.style.visibility="hidden";
	}else{
		//比较焦点框和新获得的焦点之间垂直方向的差		
		var topDif = getNum(focusDiv.style.top) - getNum(imgDiv1.style.top)+4;
		var TTop = 0; //默认垂直方向.
		var selectedDiv = topDif; //默认垂直差
		//设置滑动动画
		rightup = new showSlip1("focusDiv",TTop,2,40);	
		//开始动画
		if (selectedDiv>0){
			rightup.moveStart(-1,selectedDiv); //反向滑动
		}else{
			rightup.moveStart(1,-selectedDiv); //正向滑动.
		}		
	}
	 
	 $("play_a").href=movielist[img.substr(3,4)].indexUrl;
	 $("del_a").href=movielist[img.substr(3,4)].deleteUrl+"&menuCategoryCode=${menuCategoryCode}&r="+Math.random();
	 $("play_a").focus();
	 $("add_time"+img.substr(3,4)).style.color="white";
	 $("img"+img.substr(3,4)+"_title").style.color="white";
	 $("img"+img.substr(3,4)+"_title").innerHTML=showObject.showAllWord(movielist[img.substr(3,4)].contentName);
}

var topup;
var topId;
function divupA(topa){
	
	if (typeof(topup)!='undefined'){
		if (!topup.finished) {
			//将获得的焦点取消掉
			var ahref = document.getElementById(topId+'_a');
			if (topId != topa ){
				ahref.focus();
			}
			return; //如果动画未完成,则不响应.
		}	
	}
	leavemov();
	//将新获得的焦点保存
	topId=topa;
	var topdiv = document.getElementById(topa);
	document.getElementById(topa+"_img").src="common/images/"+topa+"_2.png";
	
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (focusDiv3.style.visibility == "hidden"){
	
		//设置可见
		focusDiv3.style.top=getNum(topdiv.style.top);
		focusDiv3.style.visibility = 'visible';
	
		focusDiv1.style.visibility="hidden";
		focusDiv.style.visibility="hidden";
	}else{
		//比较焦点框和新获得的焦点之间垂直方向的差
		
		var topDif = getNum(focusDiv3.style.top) - getNum(topdiv.style.top);
		var TTop = 0; //默认垂直方向.
		var selectedDiv = topDif; //默认垂直差

		//设置滑动动画
		topup = new showSlip1("focusDiv3",TTop,2,40);	
		//开始动画
		if (selectedDiv>0){
			topup.moveStart(-1,selectedDiv); //反向滑动
		}else{
			topup.moveStart(1,-selectedDiv); //正向滑动.
		}

	}
	

}

function leavediv1(div1){	
	document.getElementById(div1+"_img").src="common/images/"+div1+"_1.png";	
}

function totResponse(xmlHttpResponse){
	tot= xmlHttpResponse.responseText;
	var up=$("up_img");
	var down=$("down_img");
	if(tot==0){
		$("page").innerHTML="0/0";
	}else{
		page= Math.ceil(tot/pagesize);
		$("page").innerHTML=startPage+"/"+page;
	}
	if(startPage>1){
		up.src="common/images/btn_up_00.png";
	}else{
		up.src="common/images/btn_up_0.png";
	}
	if(startPage<page){
		down.src="common/images/btn_down_00.png";	
	}else{
		down.src="common/images/btn_down_0.png";
	}

}
 function btnplay(){
 	$("play_img").src="common/images/btnplay_2.png";
 	$("del_img").src="common/images/btndelete_1.png";
 }
 function btndelete(){
 	$("del_img").src="common/images/btndelete_2.png";
    $("play_img").src="common/images/btnplay_1.png";
 }
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
</script>

<epg:body onload="init()" background="/common/images/sq_bg.gif" style="background-repeat:no-repeat;" width="1280" height="720">
<div id="parCat" style="position:absolute; left:45px; top:20px; width:216px; height:61px; height:61px; background-image:url(common/images/top1.png)"></div>
<div id="focusDiv1" style="position:absolute;visibility:hidden;left:39px; top:160px; width:190px; height:57px;z-index:24 ">
<epg:img src="/common/images/listFocus1.png" width="190" height="85" />
</div>
<div id="act0" style="position:absolute;  left:81px; top:199px; width="135" height="55"">
		<epg:if test="${menuResults[0]!=null}">
		  <epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
			<epg:img  id="act0" onfocus="trunup('act0')" defaultSrc="/common/images/act1_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
		</epg:if>
</div>
<div id="act1" style="position:absolute; left:81px; top:248px; width="135" height="55"">
<epg:if test="${menuResults[1]!=null}">
		  <epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
			<epg:img id="act1" onfocus="trunup('act1')" defaultSrc="/common/images/act2_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if>
</div>
<div id="act2" style="position:absolute; left:81px; top:297px; width="135" height="55"">
<epg:if test="${menuResults[2]!=null}">
		  <epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
			<epg:img  id="act2" onfocus="trunup('act2')" defaultSrc="/common/images/act3_03.png" src=""  href="${indexUrl}&returnTo=home" width="135" height="55" />			
</epg:if>
</div>
<div id="act3" style="position:absolute; left:81px; top:346px; width="135" height="55"">

<epg:if test="${menuResults[3]!=null}">
		  <epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
			<epg:img id="act3" onfocus="trunup('act3')" defaultSrc="/common/images/act4_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if>
</div>
<div id="act4" style="position:absolute; left:81px; top:395px; width:126px; height:44px;">
<epg:if test="${menuResults[4]!=null}">
		  <epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
			<epg:img id="act4" onfocus="trunup('act4')" defaultSrc="/common/images/act5_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if>
</div>
<div id="act5" style="position:absolute; left:81px; top:444px; width="135" height="55"">
<epg:if test="${menuResults[5]!=null}">
		  <epg:navUrl obj="${menuResults[5]}" indexUrlVar="indexUrl"/>
			<epg:img id="act5" onfocus="trunup('act5')" defaultSrc="/common/images/act7_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if></div>
<div id="act6" style="position:absolute; left:81px; top:493px; width="135" height="55"">
<epg:if test="${menuResults[6]!=null}">
		  <epg:navUrl obj="${menuResults[6]}" indexUrlVar="indexUrl"/>
			<epg:img id="act6" onfocus="trunup('act6')" defaultSrc="/common/images/act6_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if>
</div>
<div id="act7" style="position:absolute; left:81px; top:542px; width="135" height="55"">
<epg:if test="${menuResults[7]!=null}">
		  <epg:navUrl obj="${menuResults[7]}" indexUrlVar="indexUrl"/>
			<epg:img id="act7" onfocus="trunup('act7')" defaultSrc="/common/images/act8_03.png" src=""  href="${indexUrl}&returnTo=home"  width="135" height="55" />			
</epg:if>
</div>

  <div id="title" style="position:absolute; width:285px;height: 33px; left: 563px; top: 54px;  z-index:22" class="tab_txt">您所添加书签的节目</div>
  <div id="page" style="position:absolute; width:80px;height: 26px; left: 947px; top: 111px;  z-index:22" class="tab_txt"></div>
  <div id="up" style="position:absolute; width:55px;height: 20px; left: 670px; top: 114px;  z-index:22; " class="tab_txt">
  <epg:img id="up"  src="/common/images/btn_up_0.png" width="55" height="20" />
  </div>
    <div style="position:absolute; width:720px; left: 318px; top: 85px; height: 506px; z-index:18" >
  <div id="focusDiv" style="position:absolute;visibility:hidden; width:746px;height: 58px; left: 15px; top: 0px; ">
  <div style="position:absolute;width:357px;height:55px; left: 0px; top: 0px; z-index:1  ">
  		<epg:img id="play" onfocus="btnplay()" src="/common/images/btnplay_1.png" width="357"  height="57" href="#" />
  	</div>
  		<div style="position:absolute;width:357px;height:55px; left: 55px; top: 0px; z-index:2 ">
  		<epg:img id="del" onfocus="btndelete()" src="/common/images/btndelete_1.png" width="357"  height="57" href="#" />
  		</div>
  		 <div style="position:absolute; width:761px; height:55px;  left:0px; top:0px; z-index:3 ">
  		<epg:img  src="/common/images/line.png" width="661"  height="57" />
  		  </div>
  </div>
 <div id="img0" style="position:absolute;;width:697px;height: 57px; left: 40px; top: 57px;  z-index:99; padding-left:115px; line-height:50px; font-size:1px;">  
  </div>
   <div id="img1" style="position:absolute; width:695px; left: 40px; top: 114px;  height: 57px; z-index:99 ;padding-left:115px; line-height:50px; font-size:1px;">
  </div>
     <div id="img2" style="position:absolute; width:695px; left: 40px; top: 171px;  height: 57px; z-index:99;padding-left:115px; line-height:50px; font-size:1px;">
   </div>
 <div id="img3" style="position:absolute; width:695px; left: 40px; top: 228px;  height: 57px; z-index:99;padding-left:115px; line-height:50px; font-size:1px;">
 </div>
<div id="img4" style="position:absolute; width:695px; left: 40px; top: 285px;  height: 57px; z-index:99;padding-left:105px; line-height:50px; font-size:1px;">
  </div>
<div id="img5" style="position:absolute; width:695px; left: 40px; top: 342px;  height: 57px; z-index:99;padding-left:115px; line-height:50px; font-size:1px;">
 </div>
<div id="img6" style="position:absolute; width:695px; left: 40px; top: 399px;  height: 57px; z-index:99;padding-left:115px; line-height:50px; font-size:1px;">
</div>
  <div id="img7" style="position:absolute; width:695px; left: 40px; top: 456px;  height: 57px; z-index:99;padding-left:115px; line-height:50px; font-size:1px;">
  </div>
</div>
<div id="div1" style="position:absolute; left:1038px;  height:720px; width: 242px; display:block; ">
	<epg:img src="/common/images/back4.jpg" height="720"  width="242" />
	<div id="focusDiv3" style="position:absolute;visibility:hidden; left:21px; top:223px; width:135px; height:60px; "><epg:img src="/common/images/focus1.png" width="135" height="60" /></div>
		<div id="collection"  style="position:absolute; top:200px; width:123px; height:46px; left: 21px;"><epg:img id="collection" src="/common/images/collection_1.png" onfocus="divupA('collection')" onblur="leavediv1('collection')"  href="${context['EPG_MYCOLLECTION_URL']}&menuCategoryCode=${menuCategoryCode}"  width="135" height="55"  /></div>
	<div id="bookmark" style="position:absolute;top:300px; width:123px; height:46px; left: 21px;"><epg:img id="bookmark" src="/common/images/bookmark_1.png" onfocus="divupA('bookmark')" onblur="leavediv1('bookmark')" width="135" height="55"  href="${context['EPG_MYBOOKMARK_URL']}&menuCategoryCode=${menuCategoryCode}" /></div>
	<div id="search"  style="position:absolute; top:400px; width:123px; height:46px; left: 21px;">
			<epg:img id="search" src="/common/images/search_1.png"  onfocus="divupA('search')" onblur="leavediv1('search')"  width="135" height="55" href="${context['EPG_SEARCH_URL']}&menuCategoryCode=${menuCategoryCode}" />		
	</div>
</div>
<div id="down" style="position:absolute; width:55px;height: 21px; left: 670px; top: 597px;  z-index:22;" class="tab_txt">
	<epg:img id="down" src="/common/images/btn_down_00.png" width="55" height="21"/> 
</div>

<div id="tips" style="position:absolute; width:364px;height: 21px; left: 559px; top: 641px;  z-index:22; " class="tab_txt">
	(按<img src="common/images/sq_play.png">播放  <img src="common/images/sq_del.png"/>删除）</div>
</epg:body>
</epg:html>