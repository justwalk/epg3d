<%@page contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<epg:html>

<epg:head>

<epg:query queryName="getSeverialItems" maxRows="20" var="menuResults" >
	<epg:param name="categoryCode" value="${menuCategoryCode}" type="java.lang.String"/>
</epg:query>
<style type="text/css">
	 #back1 { position:absolute; left:0; bottom:0; width:545px; height:35px; background:#cccccc; opacity:0.5; -moz-opacity:0.8; filter:alpha(opacity=80); }
	  #back2 { position:absolute; left:0; bottom:0; width:545px; height:35px; background:#cccccc; opacity:0.5; -moz-opacity:0.8; filter:alpha(opacity=80); }
	  #ifocus_tx {
	position:absolute;
	left:1px;
	bottom:7px;
	color:#FFF;
	width: 611px;
	height: 51px;
}
img{
	border:0px solid black; 
}
	a{
	 	color:#999999;
	 	text-decoration:none;
	 	border:0px;
	 }
</style>
<script src="${context['EPG_CONTEXT']}/js/showList.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
//iPanel.focus.display = 0;
//iPanel.focus.border = 0;
var PinyinUp1;
var PinyinUp2;
var pid;
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
var Pin;
var charfoucs;

var curorDiv;
var focusDiv3;
var focusDiv1;
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "EIS_IRKEY_UP":
	    	break;
		case "EIS_IRKEY_DOWN":
	    	break;
		case "EIS_IRKEY_SELECT":
		if(charfoucs.style.visibility=="visible"){
			if(Pin.value=="请输入首字母"){
				Pin.value=pid;
			}else{
				Pin.value+=pid;
			}
		}
			break;
		case "EIS_IRKEY_RIGHT":
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
	Pin=document.getElementById("Pin");
	charfoucs=document.getElementById("char_foucs");
    curorDiv=document.getElementById("curorDiv");
	focusDiv3=document.getElementById("focusDiv3");
	focusDiv1=document.getElementById("focusDiv1");
	document.getElementById("search_a").focus();
}
function getNum(pxValue){
	if (isNaN(pxValue)){
		return parseInt(pxValue.substring(0,pxValue.indexOf("px")));
	}else{
		return parseInt(pxValue);
		
	}
	
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
	//将新获得的焦点保存
	topId=topa;
	var topdiv = document.getElementById(topa);
	document.getElementById(topa+"_img").src="common/images/"+topa+"_2.png";
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (focusDiv3.style.visibility == "hidden"){
		//设置可见
		focusDiv3.style.top=getNum(topdiv.style.top);
		focusDiv3.style.visibility = 'visible';
		curorDiv.style.visibility="hidden";
		focusDiv1.style.visibility="hidden";
		
		charfoucs.style.visibility="hidden";
	}else{
		//比较焦点框和新获得的焦点之间垂直方向的差
		
		var topDif = getNum(focusDiv3.style.top) - getNum(topdiv.style.top);
		var TTop = 0; //默认垂直方向.
		var selectedDiv = topDif; //默认垂直差

		//设置滑动动画
		topup = new showSlip1("focusDiv3",TTop,2,40);	
		//开始动画
		if (selectedDiv>0){
			topup.moveStart(-1,selectedDiv); //反向滑动	3
		}else{
			topup.moveStart(1,-selectedDiv); //正向滑动.
		}

	}
	

}

//左边焦点
function trunup(actId){
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
	//将新获得的焦点保存
	upId=actId;
	var recDiv1 = document.getElementById(actId);
	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦;
	if (focusDiv1.style.visibility=="hidden"){
			//设置可见
			focusDiv1.style.top=getNum(recDiv1.style.top)-15;
			focusDiv1.style.visibility="visible";
			curorDiv.style.visibility="hidden";
			focusDiv3.style.visibility="hidden";
			
			charfoucs.style.visibility="hidden";
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
//选项的焦点
function char_foucs(Pinyin){
		if (typeof(PinyinUp1)!='undefined' ||typeof(PinyinUp2)!='undefined'){
		if (!PinyinUp1.finished ||!PinyinUp2.finished) {
			//将获得的焦点取消掉
			var ahref = document.getElementById(pid+'_a');
			if (pid != Pinyin){
				ahref.focus();
			}
			return; //如果动画未完成,则不响应.
		}	
	}
	pid =Pinyin;
	var pinDiv = document.getElementById(Pinyin);
	

	//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
	if (charfoucs.style.visibility == "hidden"){
			//设置可见
			charfoucs.style.top=getNum(pinDiv.style.top)-15;		
			charfoucs.style.left=getNum(pinDiv.style.left)-15;		
			charfoucs.style.visibility = 'visible';
			curorDiv.style.visibility="hidden";
			focusDiv3.style.visibility="hidden";
			focusDiv1.style.visibility="hidden";
			
	}else{
		var leftDif = getNum(charfoucs.style.left) - getNum(pinDiv.style.left)+15;	
		var topDif = getNum(charfoucs.style.top) - getNum(pinDiv.style.top)+15;
		var leftOrTop = 0; //默认垂直方向
		var selectedDif = topDif; //默认垂直差
		if (Math.abs(leftDif)>Math.abs(topDif)){ // 水平差大于垂直差则水平运动
			leftOrTop = 1;
			selectedDif = leftDif;
		}
		//设置滑动动画
		PinyinUp1 = new showSlip1("char_foucs",1,2,40);	
		PinyinUp2 = new showSlip1("char_foucs",0,2,40);	
		//开始动画
		if (topDif>0){
			PinyinUp2.moveStart(-1,topDif); //反向滑动	
		}else{
			PinyinUp2.moveStart(1,-topDif); //正向滑动.
		}
		if (leftDif>0){
			PinyinUp1.moveStart(-1,leftDif); //反向滑动	
		}else{
			PinyinUp1.moveStart(1,-leftDif); //正向滑动.
		}
	}
	

}
function searchpin(){
	var initals=Pin.value;
	if(initals==""){
		return;
	}else{
		window.location="${context['EPG_RESULT_URL']}&initals="+initals+"&menuCategoryCode=${menuCategoryCode}";
	}
}

function leavefocus(f){
			document.getElementById(f+"_img").src="common/images/"+f+"_02.png";
			curorDiv.style.visibility="hidden";
			focusDiv3.style.visibility="hidden";
			focusDiv1.style.visibility="hidden";
			charfoucs.style.visibility="hidden";
}

function blurbtn(f){

		document.getElementById(f+"_img").src="common/images/"+f+"_01.png";
}
function clearPin(){
			curorDiv.style.visibility="hidden";
			focusDiv3.style.visibility="hidden";
			focusDiv1.style.visibility="hidden";
			
			charfoucs.style.visibility="hidden";
			Pin.classname="search";
			if(Pin.value=="请输入首字母"){
				Pin.value="";
			}
			
}
function leavediv1(div1){	
document.getElementById(div1+"_img").src="common/images/"+div1+"_1.png";
	
}
function del(){
	var b=Pin.value;
	if(b.length>0){
		Pin.value=b.substr(0,b.length-1);
	}else{
		Pin.value="";
	}
}
function clearP(){
	Pin.value="";
}
</script>
</epg:head> 

<epg:body  onload="init()" background="/common/images/back.gif" style="background-repeat:no-repeat; " width="1280" height="720">
<div id="parCat" style="position:absolute; left:45px; top:20px; width:216px; height:61px; background-image:url(common/images/top1.png)"></div>
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
<div  id="curorDiv" style="position:absolute; visibility:hidden; width:127px; height:199px; left: 310px; top: 473px;" ><epg:img id="curorImg" src="/common/images/curor.png"  width="127" height="178" /></div>
	
<div id="div1" style="position:absolute; left:1038px;  height:720px; width: 242px; display:block; ">
	<epg:img src="/common/images/back4.jpg" height="720"  width="242" />
	<div id="focusDiv3" style="position:absolute;visibility:hidden; left:21px; top:223px; width:135px; height:60px; "><epg:img src="/common/images/focus1.png" width="135"  height="60" /></div>
	<div id="collection"  style="position:absolute; top:200px; width:123px; height:46px; left: 21px;"><epg:img id="collection" src="/common/images/collection_1.png" onfocus="divupA('collection')" onblur="leavediv1('collection')"  href="${context['EPG_MYCOLLECTION_URL']}&menuCategoryCode=${menuCategoryCode}"  width="135" height="55"  /></div>
	<div id="bookmark" style="position:absolute;top:300px; width:123px; height:46px; left: 21px;"><epg:img id="bookmark" src="/common/images/bookmark_1.png" onfocus="divupA('bookmark')" onblur="leavediv1('bookmark')" width="135" height="55"  href="${context['EPG_MYBOOKMARK_URL']}&menuCategoryCode=${menuCategoryCode}"/></div>
	<div id="search"  style="position:absolute; top:400px; width:123px; height:46px; left: 21px;">
			<epg:img id="search" src="/common/images/search_1.png"  onfocus="divupA('search')" onblur="leavediv1('search')"  width="135" height="55" href="${context['EPG_SEARCH_URL']}&menuCategoryCode=${menuCategoryCode}" />		
	</div>
</div>
<div style="position:absolute; left:436px; top:140px; width: 534px;">
 <strong style=" font-size:24px; color:#999999;">请选择您要搜索的节目或影片的首字母</br></strong>
</div>
<div style="position:absolute; left:436px; top:165px; width: 534px;">
 <strong style=" font-size:24px; color:#999999;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;例如:功夫熊猫=GFXM</strong>
</div>
<div style="position:absolute;  height:50px; width:410px; left:411px; top:216px;  background-color:transparent;"> 
<epg:img src="/common/images/input.png" height="50" width="410" />
</div>
<div  style="position:absolute; left: 442px; top: 226px; height:33px; ">
<input  onfocus="clearPin()" type="text" id="Pin" style=" background-image:url(/common/images/searchback.png); font-size:20px;color:#999999; height:31px;border:0px solid;" value="请输入首字母" size="26" />
</div>
<div id="btnsearch" style="position:absolute; top:212px; left:850px; width: 115px;"><epg:img id="btnsearch" onclick="searchpin()" href="#" onblur="blurbtn('btnsearch')"  onfocus="leavefocus('btnsearch')" src="/common/images/btnsearch_01.png" height="61" width="111" /></div>
<div style="position:absolute; left:350px; top:316px;">
<div id="backspace" style="position:absolute; left:11px; top:11px;">
<epg:img id="backspace" src="/common/images/backspace_01.png" height="41" width="73" onfocus="leavefocus('backspace')" onblur="blurbtn('backspace')" onclick="del()" href="#" /></div>
<div id="char_foucs" style="position:absolute;visibility:hidden; left:85px; top:0px;">
<epg:img src="/common/images/char_foucs.png" height="66" width="66"   /></div>
<div id="a" style="position:absolute; left:100px; top:15px;">
<epg:img id="a"  src="/common/images/a.png" height="33" width="33" onfocus="char_foucs('a')" href="#" /></div>
<div  id="b" style="position:absolute; left:160px; top:15px;">
<epg:img  id="b"  src="/common/images/b.png" height="33" width="33" onfocus="char_foucs('b')" href="#"/></div>
<div id="c" style="position:absolute; left:220px; top:15px;">
<epg:img id="c"  src="/common/images/c.png" height="33" width="33"onfocus="char_foucs('c')" href="#" /></div>
<div id="d" style="position:absolute; left:280px; top:15px;">
<epg:img id="d" src="/common/images/d.png" height="33" width="33" onfocus="char_foucs('d')" href="#" /></div>
<div id="e" style="position:absolute; left:340px; top:15px;">
<epg:img id="e" src="/common/images/e.png" height="33" width="33"onfocus="char_foucs('e')" href="#"  /></div>
<div id="f" style="position:absolute; left:400px; top:15px;">
<epg:img id="f" src="/common/images/f.png" height="33" width="33"  onfocus="char_foucs('f')" href="#"/></div>
<div id="g" style="position:absolute; left:460px; top:15px;">
<epg:img id="g"  src="/common/images/g.png" height="33" width="33" onfocus="char_foucs('g')" href="#" /></div>
<div id="h" style="position:absolute; left:520px; top:15px;">
<epg:img id="h"  src="/common/images/h.png" height="33" width="33" onfocus="char_foucs('h')" href="#"/></div>
<div id="i" style="position:absolute; left:580px; top:15px;">
<epg:img id="i" src="/common/images/i.png" height="33" width="33" onfocus="char_foucs('i')" href="#" /></div>

<div id="clear" style="position:absolute; left:11px; top:81px;">
<epg:img id="clear" src="/common/images/clear_01.png" height="41" width="71" href="#" onblur="blurbtn('clear')"  onfocus="leavefocus('clear')"  onclick="clearP()"/></div>
<div id="j" style="position:absolute; left:100px; top:85px;">
<epg:img id="j" src="/common/images/j.png" height="33" width="33"onfocus="char_foucs('j')" href="#"  /></div>
<div id="k" style="position:absolute; left:160px; top:85px;">
<epg:img id="k" src="/common/images/k.png" height="33" width="33"onfocus="char_foucs('k')" href="#"  /></div>
<div id="l" style="position:absolute; left:220px; top:85px;">
<epg:img id="l"  src="/common/images/l.png" height="33" width="33" onfocus="char_foucs('l')" href="#" /></div>
<div id="m" style="position:absolute; left:280px; top:85px;">
<epg:img id="m"src="/common/images/m.png" height="33" width="33"onfocus="char_foucs('m')" href="#"  /></div>
<div id="n" style="position:absolute; left:340px; top:85px;">
<epg:img id="n"src="/common/images/n.png" height="33" width="33"onfocus="char_foucs('n')" href="#"  /></div>
<div id="o" style="position:absolute; left:400px; top:85px;">
<epg:img id="o" src="/common/images/o.png" height="33" width="33"onfocus="char_foucs('o')" href="#"  /></div>
<div id="p" style="position:absolute; left:460px; top:85px;">
<epg:img id="p" src="/common/images/p.png" height="33" width="33"onfocus="char_foucs('p')" href="#"  /></div>
<div id="q" style="position:absolute; left:520px; top:85px;">
<epg:img id="q" src="/common/images/q.png" height="33" width="33" onfocus="char_foucs('q')" href="#"  /></div>
<div id="r" style="position:absolute; left:580px; top:85px;">
<epg:img id="r" src="/common/images/r.png" height="33" width="33" onfocus="char_foucs('r')" href="#"  /></div>

<div id="asearch" style="position:absolute; left:11px; top:151px;;">
<epg:img id="asearch" src="/common/images/search_01.png" height="41" width="73" onclick="searchpin()" href="#" onblur="blurbtn('asearch')" onfocus="leavefocus('asearch')" /></div>
<div id="s" style="position:absolute; left:100px; top:155px;">
<epg:img id="s" src="/common/images/s.png" height="33" width="33" onfocus="char_foucs('s')" href="#"  /></div>
<div id="t" style="position:absolute; left:160px; top:155px;">
<epg:img id="t" src="/common/images/t.png" height="33" width="33" onfocus="char_foucs('t')" href="#"  /></div>
<div id="u" style="position:absolute; left:220px; top:155px;">
<epg:img id="u" src="/common/images/u.png" height="33" width="33" onfocus="char_foucs('u')" href="#"  /></div>
<div id="v" style="position:absolute; left:280px; top:155px;">
<epg:img id="v" src="/common/images/v.png" height="33" width="33" onfocus="char_foucs('v')" href="#"  /></div>
<div id="w" style="position:absolute; left:340px; top:155px;">
<epg:img id="w" src="/common/images/w.png" height="33" width="33"  onfocus="char_foucs('w')"href="#"  /></div>
<div id="x" style="position:absolute; left:400px; top:155px;">
<epg:img id="x" src="/common/images/x.png" height="33" width="33" onfocus="char_foucs('x')"  href="#" /></div>
<div id="y" style="position:absolute; left:460px; top:155px;">
<epg:img id="y" src="/common/images/y.png" height="33" width="33" onfocus="char_foucs('y')" href="#"  /></div>
<div id="z" style="position:absolute; left:520px; top:155px;">
<epg:img id="z" src="/common/images/z.png" height="33" width="33" onfocus="char_foucs('z')" href="#"  /></div>
</div>
	
	</epg:body>
</epg:html>