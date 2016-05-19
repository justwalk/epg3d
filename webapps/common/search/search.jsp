<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@include file="/common/index/indexConfig.jsp" %>
<epg:html>
<style>
	body{ color:#FFFFFF;font-size:28}
</style>
<script src="<%=request.getContextPath()%>/js/base.js"></script>
<script src="<%=request.getContextPath()%>/js/showList.js"></script>
<script src="<%=request.getContextPath()%>/js/event.js"></script>
<script type="text/javascript">
var flag = 0;
document.onsystemevent = grabEvent;
document.onkeypress = grabEvent;
document.onirkeypress = grabEvent;
	function grabEvent(){
		var keycode = event.which;
		switch(keycode){
			case 2://down
				if(flag==1) return 0;
				break; 
			case 13://enter
				break; 
			case 374://pageup
				return 0;
				break; 
			case 375://pagedown
				return 0;
				break;
			case 339:
			case 340:
				window.parent.location = "<%= indexUrl%>";
				return 0;
			 	break;
		}
	}


function searchpin(){
	var initals = $id("keywords").innerHTML;
	//alert(initals);
	if(initals==""||initals=="请输入首字母"){
		return;
	}else{
		window.parent.location="<%=request.getContextPath()%>/search/result.do?initals="+initals+"&menuCategoryCode=${menuCategoryCode}";
	}
}

function clearPin(){
	var input = $id("keywords");
	if(input.innerHTML=="请输入首字母"){
		input.innerHTML="";
	}
}

function focusChar(obj){
	var id = obj.substr(0,obj.length-2);
	if(id=="search"||id=="S"||id=="T"||id=="U"||id=="V"||id=="W"||id=="X"||id=="Y"||id=="Z"){
		flag = 1;
	}
	//animation = new showSlip1("charBar_div",0,2,10);
	appear("charBar_div");
	//animation.moveToSameLocation(id,10,7);
	$id("charBar_div").style.top = $id(id).style.top-7;
	$id("charBar_div").style.left = $id(id).style.left-10;
	var id = obj.substr(0,obj.length-2)+"1";
	$id(id).style.color = 'black';
	parent.menuBar.style.visibility = "hidden";
}

function unfocusChar(obj){
	var id = obj.substr(0,obj.length-2)+"1";
	if(id=="search1"||id=="S1"||id=="T1"||id=="U1"||id=="V1"||id=="W1"||id=="X1"||id=="Y1"||id=="Z1"){
		flag = 0;
	}
	$id(id).style.color = 'white';
}

function focusSearch(){
	hidden("charBar_div");
	$id("btnsearch_img").src="<%=request.getContextPath()%>/common/images/tools/searchSelect.png";
}
function unfocusSearch(){
	$id("btnsearch_img").src="<%=request.getContextPath()%>/common/images/tools/search1.png";
}

function clickChar(objA){
	var id = objA.substr(0,objA.length-2);
	var input = $id("keywords");
	//alert(id+"_"+input.value);
	//alert("["+input.innerText+"]");
	if (input.innerHTML == '请输入首字母'){
		if (id == "backspace" || id == "clear" || id=="search"){
		}else{
		input.innerHTML = id;
		}
	}else if (id == "backspace"){
		if (input.innerHTML.length>0){
			input.innerHTML = input.innerHTML.substring(0,input.innerHTML.length-1);
		}
	}else if (id == "clear"){
		input.innerHTML = "";
	}else if (id =="search"){
		if (input.innerHTML!="请输入首字母" && input.innerHTML.length>0){
			searchpin();
		}
	}else{
		if(input.innerHTML.length <= 15){
			input.innerHTML = input.innerHTML+id;
		}
	}
	
}
</script>
<body  onload="init()"  bgcolor="transparent" style="position:absolute; top:0px;width:830px;height:655px; left:0px;">
<div id="focusDiv1" style="position:absolute;visibility:hidden;left:39px; top:160px; width:190px; height:57px;z-index:24 ">
<epg:img src="/common/images/listFocus1.png" width="190" height="85" />
</div>
<div style="position:absolute; left:206px; top:110px; width: 534px;">
 <strong style=" font-size:28px; color:#999999;">请选择您要搜索的节目或影片的首字母</br></strong>
</div>
<div style="position:absolute; left:206px; top:150px; width: 534px;">
 <strong style=" font-size:26px; color:#999999;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;例如:功夫熊猫=GFXM</strong>
</div>
<div id="searchbg" style="position:absolute; top:221px; left:120px; width: 655px;height:45px;"><epg:img src="/common/images/tools/searchBar.png" height="45" width="655" /></div>
<div id="keywords"  style="position:absolute; left: 142px; top: 230px; height:50px;width:200px;color:black;">
请输入首字母</div>
<div id="btnsearch" style="position:absolute; top:211px; left:653px; width: 114px;height:50px;"><epg:img id="btnsearch" onclick="searchpin()" onfocus="focusSearch();" onblur="unfocusSearch();" href="#"  src="/common/images/tools/search1.png" height="62" width="131" /></div>

<div id="searchArea" style="position:absolute; top:312px; left:50px; width: 615px;height:500px">
<div id="charBar_div" align="center" style="position: absolute;visibility:hidden;left:0px;top:3px;width:87px;height:73px;z-index:1">
		    <epg:img id="charBar" src="/common/images/tools/charBar.png" 	width="87" height="73"  />
 </div>	    			
    			
<div id="backspace" align="center" style="position: absolute;left:10px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="backspace" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('backspace_a')" onclick="clickChar('backspace_a')" onblur="unfocusChar('backspace_a')"  />
 </div>
 <div id="backspace1" align="center"  style="position: absolute;left:10px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    退格
 </div>
<div id="A" align="center" style="position: absolute;left:89px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="A" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('A_a')" onclick="clickChar('A_a')" onblur="unfocusChar('A_a')" />
 </div>
 <div id="A1" align="center"  style="position: absolute;left:89px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    A
 </div>
<div id="B" align="center" style="position: absolute;left:168px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="B" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('B_a')" onclick="clickChar('B_a')" onblur="unfocusChar('B_a')" />
 </div>
 <div id="B1" align="center"  style="position: absolute;left:168px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    B
 </div>
<div id="C" align="center" style="position: absolute;left:247px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="C" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('C_a')" onclick="clickChar('C_a')" onblur="unfocusChar('C_a')" />
 </div>
 <div id="C1" align="center"  style="position: absolute;left:247px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    C
 </div>	
<div id="D" align="center" style="position: absolute;left:326px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="D" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('D_a')" onclick="clickChar('D_a')" onblur="unfocusChar('D_a')" />
 </div>
 <div id="D1" align="center"  style="position: absolute;left:326px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    D
 </div>
<div id="E" align="center" style="position: absolute;left:405px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="E" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('E_a')" onclick="clickChar('E_a')" onblur="unfocusChar('E_a')" />
 </div>
 <div id="E1" align="center"  style="position: absolute;left:405px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    E
 </div>
<div id="F" align="center" style="position: absolute;left:484px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="F" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('F_a')" onclick="clickChar('F_a')" onblur="unfocusChar('F_a')" />
 </div>
 <div id="F1" align="center"  style="position: absolute;left:484px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    F
 </div>
<div id="G" align="center" style="position: absolute;left:563px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="G" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('G_a')" onclick="clickChar('G_a')" onblur="unfocusChar('G_a')" />
 </div>
 <div id="G1" align="center"  style="position: absolute;left:563px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    G
 </div>
<div id="H" align="center" style="position: absolute;left:642px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="H" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('H_a')" onclick="clickChar('H_a')" onblur="unfocusChar('H_a')" />
 </div>
 <div id="H1" align="center"  style="position: absolute;left:642px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    H
 </div>	
<div id="I" align="center" style="position: absolute;left:721px;top:10px;width:69px;height:60px;z-index:1">
		    <epg:img id="I" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('I_a')" onclick="clickChar('I_a')" onblur="unfocusChar('I_a')" />
 </div>
 <div id="I1" align="center"  style="position: absolute;left:721px;top:10px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    I
 </div>	
<div id="clear" align="center" style="position: absolute;left:10px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="clear" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('clear_a')" onclick="clickChar('clear_a')" onblur="unfocusChar('clear_a')" />
 </div>
 <div id="clear1" align="center"  style="position: absolute;left:10px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    清空
 </div>	
<div id="J" align="center" style="position: absolute;left:89px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="J" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('J_a')" onclick="clickChar('J_a')" onblur="unfocusChar('J_a')" />
 </div>
 <div id="J1" align="center"  style="position: absolute;left:89px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    J
 </div>
<div id="K" align="center" style="position: absolute;left:168px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="K" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('K_a')" onclick="clickChar('K_a')" onblur="unfocusChar('K_a')" />
 </div>
 <div id="K1" align="center"  style="position: absolute;left:168px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    K
 </div>
<div id="L" align="center" style="position: absolute;left:247px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="L" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('L_a')" onclick="clickChar('L_a')" onblur="unfocusChar('L_a')" />
 </div>
 <div id="L1" align="center"  style="position: absolute;left:247px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    L
 </div>
<div id="M" align="center" style="position: absolute;left:326px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="M" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('M_a')" onclick="clickChar('M_a')" onblur="unfocusChar('M_a')" />
 </div>
 <div id="M1" align="center"  style="position: absolute;left:326px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    M
 </div>	
<div id="N" align="center" style="position: absolute;left:405px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="N" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('N_a')" onclick="clickChar('N_a')" onblur="unfocusChar('N_a')" />
 </div>
 <div id="N1" align="center"  style="position: absolute;left:405px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    N
 </div>
<div id="O" align="center" style="position: absolute;left:484px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="O" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('O_a')" onclick="clickChar('O_a')" onblur="unfocusChar('O_a')" />
 </div>
 <div id="O1" align="center"  style="position: absolute;left:484px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    O
 </div>	
<div id="P" align="center" style="position: absolute;left:563px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="P" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('P_a')" onclick="clickChar('P_a')" onblur="unfocusChar('P_a')" />
 </div>
 <div id="P1" align="center"  style="position: absolute;left:563px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    P
 </div>	
<div id="Q" align="center" style="position: absolute;left:642px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="Q" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('Q_a')" onclick="clickChar('Q_a')" onblur="unfocusChar('Q_a')" />
 </div>
 <div id="Q1" align="center"  style="position: absolute;left:642px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    Q
 </div>
<div id="R" align="center" style="position: absolute;left:721px;top:90px;width:69px;height:60px;z-index:1">
		    <epg:img id="R" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('R_a')" onclick="clickChar('R_a')" onblur="unfocusChar('R_a')" />
 </div>
 <div id="R1" align="center"  style="position: absolute;left:721px;top:90px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    R
 </div>	
<div id="search" align="center" style="position: absolute;left:10px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="search" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('search_a')" onclick="clickChar('search_a')" onblur="unfocusChar('search_a')" />
 </div>
 <div id="search1" align="center"  style="position: absolute;left:10px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    搜索
 </div>	
<div id="S" align="center" style="position: absolute;left:89px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="S" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('S_a')" onclick="clickChar('S_a')" onblur="unfocusChar('S_a')" />
 </div>
 <div id="S1" align="center"  style="position: absolute;left:89px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    S
 </div>
<div id="T" align="center" style="position: absolute;left:168px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="T" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('T_a')" onclick="clickChar('T_a')" onblur="unfocusChar('T_a')" />
 </div>
 <div id="T1" align="center"  style="position: absolute;left:168px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    T
 </div>	
<div id="U" align="center" style="position: absolute;left:247px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="U" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('U_a')" onclick="clickChar('U_a')" onblur="unfocusChar('U_a')" />
 </div>
 <div id="U1" align="center"  style="position: absolute;left:247px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    U
 </div>	
<div id="V" align="center" style="position: absolute;left:326px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="V" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('V_a')" onclick="clickChar('V_a')" onblur="unfocusChar('V_a')" />
 </div>
 <div id="V1" align="center"  style="position: absolute;left:326px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    V
 </div>		
<div id="W" align="center" style="position: absolute;left:405px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="W" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('W_a')" onclick="clickChar('W_a')" onblur="unfocusChar('W_a')" />
 </div>
 <div id="W1" align="center"  style="position: absolute;left:405px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    W
 </div>		
<div id="X" align="center" style="position: absolute;left:484px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="X" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('X_a')" onclick="clickChar('X_a')" onblur="unfocusChar('X_a')" />
 </div>
 <div id="X1" align="center"  style="position: absolute;left:484px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    X
 </div>		
<div id="Y" align="center" style="position: absolute;left:563px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="Y" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('Y_a')" onclick="clickChar('Y_a')" onblur="unfocusChar('Y_a')" />
 </div>
 <div id="Y1" align="center"  style="position: absolute;left:563px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    Y
 </div>	
<div id="Z" align="center" style="position: absolute;left:642px;top:170px;width:69px;height:60px;z-index:1">
		    <epg:img id="Z" src="/common/images/tools/dot.gif" 	width="69" height="60" href="#" onfocus="focusChar('Z_a')" onclick="clickChar('Z_a')" onblur="unfocusChar('Z_a')" />
 </div>
 <div id="Z1" align="center"  style="position: absolute;left:642px;top:170px;width:69px;height:60px;text-align:center;vertical-align:middle;line-height:60px;z-index:3">
		    Z
 </div>
</div>
</body>
</epg:html>