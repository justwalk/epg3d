<%@page contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<epg:navUrl returnTo="search" returnUrlVar="returnUrl"></epg:navUrl>
<%request.getSession().removeAttribute("PlayBackURL");%>
<epg:html>
<epg:head>
<% String  categoryCode = (String) request.getParameter("menuCategoryCode");%>
<style type="text/css">
	 .txt{
		 font-size:26px; color:#CCCCCC; 
	 }
	 .tab_txt{  
	      font-size:26px; color:#CCCCCC; 
	 }
 	a{
	 	color:#999999;
	 	text-decoration:none;
	 }
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/showList.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
//iPanel.focus.display = 0;
//iPanel.focus.border = 0;
var categoryCode ="<%=categoryCode%>";
var curor;
var currentFocusId;
var movielist=[];
var total;
var pagesize=7;
var startPage;
var page;
var showObject;
var movieajax;
var totalajax;
var programurl;
var totalurl;
var contentCurorDiv;
var back;
var flag = 0;
var resultUrl = window.location.href;
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "EIS_IRKEY_UP":
			if(currentFocusId=="cat0" && contentCurorDiv.style.visibility=="visible"){
				back.style.visibility="visible";
				document.getElementById("back_a").focus();
				contentCurorDiv.style.visibility="hidden";
			}
	    	break;
	    case "EIS_IRKEY_DOWN":
	    	break;	
		case "EIS_IRKEY_SELECT":
			if(contentCurorDiv.style.visibility == 'visible'){
				var position = parseInt(currentFocusId.substring(3,4));
				var indexUrl = movielist[position].indexUrl;	
		   		window.location.href = indexUrl;
			}
			break;
		case "EIS_IRKEY_LEFT":
			leftclick();
	    	break;
	    case "EIS_IRKEY_RIGHT":
			rightclick();
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
	contentCurorDiv=document.getElementById("contentCurorDiv");
	back=document.getElementById("back");
	startPage=1;
	showObject=new showContent(7,3,345,50);
	programurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgram.do?initals=${initals}&p=0&s="+pagesize+"&r="+Math.random();
	totalurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgramTotal.do?initals=${initals}";
	movieajax=new AJAX_OBJ(programurl,programResponse);
	movieajax.requestData();
	totalajax=new AJAX_OBJ(totalurl,totalResponse);
	totalajax.requestData();
	
}
function programResponse(xmlHttpResponse){
	movielist=eval(xmlHttpResponse.responseText);
	var dot="${context['EPG_CONTEXT']}/common/images/dot.gif";
	for(var i=0;i<7;i++){
			if(movielist[i]!=null){	
			var mov=movielist[i].title;
			var level=movielist[i].reserve1;
			if(level==0){
				level=6;
			}
			var str = "<div id=\"mov"+i+"\" style=\"position:absolute; top:17px; width:600px;height: 50px; left: 85px;\">";
			str +="<a id=\"cat"+i+"_a\" href=\"#\" onfocus=\"contentGetFocus(\'cat"+i+"\');\" >"
			str +="<img src=\""+dot+"\" width=\"250\" height=\"50\"></a><div style=\"position:absolute; top:0px; width:400px;height: 50px; left: 85px;\"><span id=\"cat"+i+"_title\" style=\"font-size:26px;color:#999999;\"></span></div></div>"; 
			str +="<div id=\"num"+i+"\" style=\"position:absolute; top:17px; width:300px; left: 765px; height: 50px;font-size:24px;color:#999999;\">"+level+"分</div>";
			document.getElementById("cat"+i).innerHTML=str;
			document.getElementById("cat"+i+"_title").innerHTML=showObject.showPartWord(mov);
			if(flag == 0){
				document.getElementById("cat0_a").focus();
			}
			flag=1;
			document.getElementById("cat"+i).style.visibility="visible";
			}else {
				document.getElementById("cat"+i).style.visibility="hidden";
			}
	}
}
function rightclick(){
	if(startPage<page){
	 	  	flag=0;
			startPage++;
			currentFocusId="cat0";
			programurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgram.do?initals=${initals}&p="+(startPage-1)+"&s="+pagesize+"&r="+Math.random();
			totalurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgramTotal.do?initals=${initals}";
			movieajax=new AJAX_OBJ(programurl,programResponse);
			movieajax.requestData();
			totalajax=new AJAX_OBJ(totalurl,totalResponse);
			totalajax.requestData();
		}
}
function leftclick(){
	if(startPage>1){
			flag=0;
			startPage--;
			currentFocusId="cat0";
			programurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgram.do?initals=${initals}&p="+(startPage-1)+"&s="+pagesize+"&r="+Math.random();
			totalurl=resultUrl.substring(0,resultUrl.indexOf(".do"))+"/getEpgProgramTotal.do?initals=${initals}";
			movieajax=new AJAX_OBJ(programurl,programResponse);
			movieajax.requestData();
			totalajax=new AJAX_OBJ(totalurl,totalResponse);
			totalajax.requestData();
		}
}
/**
 * 内容聚焦处理
 */
function contentGetFocus(recId){
	if (typeof(curor)!='undefined'){
		if (!curor.finished) {
			//将获得的焦点取消掉
			var ahref = document.getElementById(currentFocusId+'_a');
			if (currentFocusId != recId ){
				ahref.focus();
			}		
			return; //如果动画未完成,则不响应.
		}	
	}
	
	if(currentFocusId!=null){
		document.getElementById(currentFocusId+"_title").style.color="#999999";
		document.getElementById(currentFocusId+"_title").innerHTML=showObject.showPartWord(movielist[currentFocusId.substring(3,4)].title);  
		document.getElementById("num"+currentFocusId.substring(3,4)).style.color="#999999";
	}
	//将新获得的焦点保存
	currentFocusId=recId;
	var recDiv = document.getElementById(recId);
	var i=parseInt(recId.substring(3,4));
	
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (contentCurorDiv.style.visibility == "hidden"){
			contentCurorDiv.style.top = getNum(recDiv.style.top);
			contentCurorDiv.style.left = getNum(recDiv.style.left);
			//设置可见
			contentCurorDiv.style.visibility ="visible";
	}else{
		//比较焦点框和新获得的焦点之间水平和垂直方向的差	
		var topDif = getNum(contentCurorDiv.style.top) - getNum(recDiv.style.top);
		var leftOrTop = 0; //默认垂直方向
		var selectedDif = topDif; //默认垂直差
		//设置滑动动画
		curor = new showSlip1("contentCurorDiv",leftOrTop,2,40);	
		//开始动画
		if (selectedDif>0){
			curor.moveStart(-1,selectedDif); //反向滑动
		}else{
			curor.moveStart(1,-selectedDif); //正向滑动.
		}
		
	}
	
	document.getElementById(recId+"_title").style.color = "white";
	document.getElementById("num"+i).style.color="white";
	document.getElementById(recId+"_title").innerHTML=showObject.showAllWord(movielist[i].title);
	back.style.visibility="hidden";
}


function totalResponse(xmlHttpResponse){

	total=xmlHttpResponse.responseText;
	var btnleft=document.getElementById("btnleft_img");
	var btnright=document.getElementById("btnright_img");
	var p=document.getElementById("page");
	document.getElementById("searchresult").innerHTML="找到"+total+"条记录";
	if(total==0){
		back.style.visibility="visible";
		p.innerHTML="0/0";
	}else{
		page= Math.ceil(total/pagesize);
		p.innerText=startPage+"/"+page;
	}
		if(startPage>1){
			btnleft.src="common/images/btn_left_00.png";
		}else{
			btnleft.src="common/images/btn_left_0.png";
		}
		if(startPage<page){
			btnright.src="common/images/btn_right_00.png";
			
		}else{
			btnright.src="common/images/btn_right_0.png";
		}
		
}

function leave(){
	for(var j=0;j<movielist.length;j++){
		document.getElementById("cat"+j+"_title").style.color="#999999";
		document.getElementById("cat"+j+"_title").innerHTML=showObject.showPartWord(movielist[j].title);  
		document.getElementById("num"+j).style.color="#999999";
	}
}

function backGetFocus(){
		 document.getElementById("back_id").src="common/images/btn_back00.png";
		 contentCurorDiv.style.visibility ="hidden";
		 leave();
	}
	
	function backLostFocus(){
		 document.getElementById("back_id").src="common/images/btn_back0.png";
		 contentCurorDiv.style.visibility="visible";
	}
	function l(){
		
		window.location="${returnUrl}&menuCategoryCode="+categoryCode;
	}
	
</script>
</epg:head>

<epg:body onload="init()" background="/common/images/ssjg.gif" style="background-repeat:no-repeat;" width="1280" height="720">
<div style="position:absolute; left:64px; top:52px; width:172px; height:48px; background:url(common/images/ssjg_title.png)"></div>
<div id="searchresult" style="position:absolute; left:238px; top:60px; width:290px; height:50px;" class="txt"></div>
<div id="page" style="position:absolute; left:1133px; top:132px; width:73px; height:48px;" class="txt"></div>
<div id="btnleft" style="position:absolute; left:116px; top:358px; width:22px; height:54px;"><epg:img id="btnleft" src="/common/images/btn_left_0.png" width="22" height="54" /></div>
<div id="btnright" style="position:absolute; left:1142px; top:358px; width:22px; height:54px;"><epg:img id="btnright" src="/common/images/btn_right_00.png"  width="22" height="54" /></div>

<div id="contentCurorDiv" style="position:absolute;visibility:hidden; left:158px; top:138px;  width:914px; height:81px;">
		<epg:img id="parCatCurorImg" defaultSrc="/common/images/line_bg.png" src=""  width="914" height="81" />
</div>
<div id="cat0" style="position:absolute; left:178px; top:158px; width:914px; height:67px; z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div id="cat1" style="position:absolute; left:178px; top:225px; width:914px; height:67px; z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div id="cat2" style="position:absolute; left:178px; top:292px; width:914px; height:67px; z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div id="cat3" style="position:absolute; left:178px; top:359px; width:914px; height:67px; z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div id="cat4" style="position:absolute; left:178px; top:426px; width:914px; height:67px; z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div  id="cat5" style="position:absolute; left:178px; top:493px; width:914px; height:67px;z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div id="cat6" style="position:absolute; left:178px; top:560px; width:914px; height:67px;z-index:99;line-height:50px; font-size:10px;padding-left:80px; line-height:50px;">
</div>
<div  style="position:absolute; left:1123px; top:52px; width:111px; height:63px; background:url(common/images/btn_back0.png)" >
<div id="back" style="position:absolute;visibility:hidden; left:0px; top:0px; width:111px; height:63px; ">
<a id="back_a" href="#" onclick="l()" onFocus="backGetFocus();"  onblur="backLostFocus();"><img id="back_id" src="common/images/btn_back0.png" style="border:0px solid white;" border="0" /></a>
</div>
</div>

</epg:body>
</epg:html> 