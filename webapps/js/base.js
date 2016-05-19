
// 渐变 method: show or hide  默认为show 即从无到有
function fadeIn(elem,method) {
	if(method == 'hide'){
		setOpacity(elem, 0);
		for (var i = 0; i <= 100; i += 5) {
			new function() {
				var pos = i;
				setTimeout(function() {
							setOpacity(elem, 100-pos);
						}, (pos + 1) * 10);
			}
		}
	}else{
		setOpacity(elem, 0);
		for (var i = 0; i <= 100; i += 5) {
			new function() {
				var pos = i;
				setTimeout(function() {
							setOpacity(elem, pos);
						}, (pos + 1) * 10);
			}
		}
	}
	
}
// 设置透明度 setOpacity(elem,40)
function setOpacity(elem, num) {
	if (elem.filters) {
		elem.style.filter = "alpha(opacity=" + num + ")";
	} else {
		elem.style.opacity = num / 100;
	}
}
//选择器
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function bodyTransparent(){
	document.body.bgColor = "transparent";
}

// 获取元素可能，完整的高度和宽度
function getFullHeight(elem) {
	if (getStyle(elem, "display") != "none") {
		return getHeight(elem) || elem.offsetHeight;
	} else {
		var old = resetCss(elem, {
					display : "block",
					visibility : "hidden",
					position : "absolute"
				});
		var h = elem.clientHeight || getHeight(elem);
		restoreCss(elem, old);
		return h;
	}
}

// 获取元素的样式值。
function getStyle(elem, name) {
	if (elem.style[name]) {
		return elem.style[name];
	} else if (elem.currentStyle) {
		return elem.currentStyle[name];
	} else if (document.defaultView && document.defaultView.getComputedStyle) {
		name = name.replace(/([A-Z])/g, "-$1");
		name = name.toLowerCase();
		var s = document.defaultView.getComputedStyle(elem, "");
		return s && s.getPropertyValue(name);
	} else {
		return null
	}
}

// 获取元素使用css控制大小的高度和宽度
function getHeight(elem) {
	return parseInt(getStyle(elem, "height"));
}
function getWidth(elem) {
	return parseInt(getStyle(elem, "width"));
}
// 获取使用css定位的元素的x和y坐标。
function posX(elem) {
	return parseInt(getStyle(elem, "left"));
}
function posY(elem) {
	return parseInt(getStyle(elem, "top"));
}
// 设置元素位置。
function setX(elem, pos) {
	elem.style.left = pos + "px";
}
function setY(elem, pos) {
	elem.style.top = pos + "px";
}

function hidden(id){
	if ($(id)=='undefined' || $(id) == null){
		//alert(id+" is undefined");
		return;
	}
	$(id).style.visibility = 'hidden';
}
function appear(id){
	$(id).style.visibility = 'visible';
}
/*
 * duration: 动画需要的总时长，单位为ms fxs: 需要执行的动画集合，可以为一个函数或者函数组成的数组，fxs中每个元素如下 { type:
 * "top|left" elem: "elemid" s: 40, finish: a_function }
 */
function MultiFx(duration, fxs) {
	this.fps = 30;
	this.mspf = Math.floor(1000 / this.fps);
	this.frame = Math.floor(duration * this.fps / 1000); // need so much
															// frames to finish
															// the animation
	this.count = 0;
	me = this;
	if (fxs != undefined) {
		if (fxs.constructor == Array) {
			for (var i = 0; i < fxs.length; i++) {
				var fx = fxs[i];
				preHandler.call(fx, me);
			}
		} else {
			preHandler.call(fxs, me);
		}

		(function() {
			if (fxs.constructor == Array) {
				for (var i = 0; i < fxs.length; i++) {
					var fx = fxs[i];
					afterHandler.call(fx, me);
				}
			} else {
				afterHandler.call(fxs, me);
			}
			if (count++ == frame) {
				return;
			}
			setTimeout(arguments.callee, mspf);
		})();
	}

	function preHandler(me) {
		this.elem = typeof this.elem == "string" ? document
				.getElementById(this.elem) : this.elem;
		if (this.s > 0)
			this.step = Math.floor(this.s / me.frame);
		else
			this.step = Math.ceil(this.s / me.frame);

		if (this.type == "top") {
			this.from = posY(this.elem);
			this.to = posY(this.elem) + this.s;
		} else if (this.type == "left") {
			this.from = posX(this.elem);
			this.to = posX(this.elem) + this.s;
		}
	};

	function afterHandler(me) {
		if (me.count == me.frame) {
			if (this.type == "top") {
				if (posY(this.elem) != this.to)
					setY(this.elem, this.to);
			} else if (this.type == "left") {
				if (posX(this.elem) != this.to)
					setX(this.elem, this.to);
			}
			if (typeof this.finish == "function")
				this.finish();
			return false;
		} else if (me.count > me.frame) {
			return false;
		}

		if (this.type == "top") {
			setY(this.elem, posY(this.elem) + this.step);
		} else if (this.type == "left") {
			setX(this.elem, posX(this.elem) + this.step);
		}
	};
}
function subString(str, len, hasDot) { 
	var strLength = str.length;
	var newStr = str ;
	if(strLength>len){
		newStr = str.substring(0,len);
		if(hasDot){
			newStr+="...";
		}
	}
	return newStr; 
}
function focus(id){
	if (typeof(iPanel)!='undefined'){
		$(id).focus();
	}else{
		
	}
}
/**
 * 保存一个cookie,
 * name cookie名
 * value cookie值
 * expireHour 过期时间,小时
 */
function setCookie(name,value,expireHour)//两个参数，一个是cookie的名子，一个是值,
{
	//if (typeof(iPanel)!='undefined'){
	//	iPanel.setGlobalVar(name,value);
	//}else{
   	 	var exp  = new Date();    //new Date("December 31, 9998");
		exp.setTime(exp.getTime() + expireHour*60*60*1000);
    	document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
    	//alert(name + ":" + value);
    	//alert("set:"+document.cookie);
	//}
}

function setGlobalVar(name,value){
	if (typeof(iPanel)!='undefined'){
		iPanel.setGlobalVar("ch_bj_"+name,value);
	}else{
		setCookie(name,value,2);
	}
}

function getGlobalVar(name){
	if (typeof(iPanel)!='undefined'){
		return iPanel.getGlobalVar("ch_bj_"+name);
	}else{
		return getCookie(name);
	}
}

function deleteGlobalVar(name){
	if (typeof(iPanel)!='undefined'){
		 iPanel.delGlobalVar("ch_bj_"+name);
	}else{
		deleteCookie(name);
	}
}

function getCookie(name)//取cookies函数        
{
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
    if(arr != null) return unescape(arr[2]); return null;
}

function deleteCookie(name)//删除cookie
{
    var exp = new Date();   
    exp.setTime(exp.getTime() - 100);
    var cval=getCookie(name);
    //alert("deleft before:"+cval);
    if(cval!=null) {
    	document.cookie= name + "="+cval+";expires="+exp.toGMTString();
    }
    //alert("delete after:"+getCookie(name));
}