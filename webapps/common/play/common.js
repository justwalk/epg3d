var userAgent = navigator.userAgent.toLowerCase();
var isIpanel = userAgent.indexOf("ipanel") != -1;
var isIpanelVane = userAgent.indexOf("ipanelvane") != -1 || (isIpanel == true && userAgent.indexOf("vane") != -1);

var util = {
	/**
	 * util.date对象，用来放置与Date有关的工具
	 */
	date: {
		/**
		 * util.date.format方法，将传入的日期对象d格式化为formatter指定的格式
		 * @param {object} d 传入要进行格式化的date对象
		 * @param {string} formatter 传入需要的格式，如“yyyy-MM-dd hh:mm:ss”
		 * @return {string} 格式化后的日期字符串，如“2008-09-01 14:00:00”							
		 */
		format: function(d, formatter) {
		    if(!formatter || formatter == "")
		    {
		        formatter = "yyyy-MM-dd";
		    }
			
			var weekdays = {
				chi: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
				eng: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
			};
		    var year	= d.getYear().toString();
		    var month	= (d.getMonth() + 1).toString();
		    var date	= d.getDate().toString();
		    var day		= d.getDay();
			var hour	= d.getHours().toString();
			var minute	= d.getMinutes().toString();
			var second	= d.getSeconds().toString();

			var yearMarker = formatter.replace(/[^y|Y]/g,'');
			if(yearMarker.length == 2) {
				year = year.substring(2,4);
			} else if (yearMarker.length == 0) {
				year = "";
			}

			var monthMarker = formatter.replace(/[^M]/g,'');
			if(monthMarker.length > 1) {
				if(month.length == 1) {
					month = "0" + month;
				}
			} else if (monthMarker.length == 0) {
				month = "";
			}

			var dateMarker = formatter.replace(/[^d]/g,'');
			if(dateMarker.length > 1) {
				if(date.length == 1) {
					date = "0" + date;
				}
			} else if (dateMarker.length == 0) {
				date = "";
			}

			var hourMarker = formatter.replace(/[^h]/g, '');
			if(hourMarker.length > 1) {
				if(hour.length == 1) {
					hour = "0" + hour;
				}
			} else if (hourMarker.length == 0) {
				hour = "";
			}

			var minuteMarker = formatter.replace(/[^m]/g, '');
			if(minuteMarker.length > 1) {
				if(minute.length == 1) {
					minute = "0" + minute;
				}
			} else if (minuteMarker.length == 0) {
				minute = "";
			}

			var secondMarker = formatter.replace(/[^s]/g, '');
			if(secondMarker.length > 1) {
				if(second.length == 1) {
					second = "0" + second;
				}
			} else if (secondMarker.length == 0) {
				second = "";
			}
		    
		    var dayMarker = formatter.replace(/[^w]/g, '');
		    var lang = "chi";
		    var result = formatter.replace(yearMarker,year).replace(monthMarker,month).replace(dateMarker,date).replace(hourMarker,hour).replace(minuteMarker,minute).replace(secondMarker,second); 
			if (dayMarker.length != 0) {
				result = result.replace(dayMarker,weekdays.chi[day]);
			}
		    return result;
		},
        
        getDate: function(offset) {
            var d		= new Date();
            var year	= d.getYear();
            var month	= d.getMonth();
            var date	= d.getDate();
            var hour	= d.getHours();
            var minute	= d.getMinutes();
            var second	= d.getSeconds();
            
            var dd = new Date(year, month, (date+offset), hour, minute, second);
			Utility.println(dd);
            return dd;
        }
	},
	url:{
		getParameter : function(url, parameter) {
			if (typeof (parameter) == "undefined" || parameter == "") {
				return null;
			}
			var index = url.indexOf("?");
			if (index != -1) {
				var parameterString = url.substr(index + 1);
				var reg = new RegExp("(^|&)" + parameter + "=([^&]*)(&|$)", "i");
				var r = parameterString.match(reg);
				if (r != null)
					return unescape(r[2]);
			}
			return null;
		}
	},
	str: {
		addZero: function(__str, __num){
			__str = __str.toString();
			for(var i = __str.length; i < __num; i++){
				__str = "0"+__str;
			}
			return __str;
		},
		
		getDuration: function(__t1, __t2){
			var t1 = __t1.split(":");
			var t2 = __t2.split(":");
			var duration = 0;
			duration = (Math.floor(t2[0])*60+Math.floor(t2[1])) - (Math.floor(t1[0])*60+Math.floor(t1[1]));
			if(t1[0] > t2[0]) duration = duration + 1440;
			return duration;
		},
		
		millisecondToMinute: function(__mili){			
			return parseInt((__mili/1000)/60);		
		},

		secondToStringTime: function(__sec){

			var hour = Math.floor(__sec/3600);
			var minute = Math.floor((__sec - hour*3600)/60);
			var second = __sec - hour*3600 - minute*60;
			hour = hour>9?hour:"0"+hour;
			minute = minute>9?minute:"0"+minute;
			second = second>9?second:"0"+second;
			return hour+":"+minute+":"+second;
		},
		
		/**
		 * 根据传入的字符串日期和时间格式转换为毫秒的整数格式时间
		 * @param string __str : 格式为“2008-09-01 14:00:00”的日期和时间字符串
		 * @return long int : 毫秒的时间格式
		 */
		stringDateTimeToMiliTime: function(__str){
			var y = Math.floor(__str.substring(0,4));
			var m = Math.floor(__str.substring(5,7))-1;
			var d = Math.floor(__str.substring(8,10));
			var t_h = Math.floor(__str.substring(11,13));
			var t_m = Math.floor(__str.substring(14,16));
			var t_s = Math.floor(__str.substring(17,19));
			var my_date = new Date();
			my_date.setYear(y);
			my_date.setMonth(m);
			my_date.setDate(d);
			my_date.setHours(t_h);
			my_date.setMinutes(t_m);
			my_date.setSeconds(t_s);
			my_date.setMilliseconds(0);
			return my_date.getTime();
		},

		/* ---------------------------
		 功能 - 将输入字串前补add_string至设定宽度
		 参数 -
			arg1: 输入, 可以是字符串或数字
			arg2: 欲补到多宽的字串
			arg3: 欲补的字串，一般为一个字符
		---------------------------*/
		toPaddedString: function(input,width,add_string){
			var str = input.toString();
			while(str.length<width){
				str = add_string + str;
			}
			return str;
		}
	}
};

var timeStr = {
	//_args: {format: "YYYY-MM-DD W HH:mm:SS", param: 1281874905000, lang: "en-us"},
	//_args: {format: "YYYY-MM-DD W HH:mm:SS", param: "2010/8/15 20:21:45", lang: "en-us"},
	//_args: {format: "YYYY-MM-DD W HH:mm:SS", param: "Aug, 2010, 15, 20:21:45", lang: "en-us"},

	get: function(_args) {
		this.format = _args.format;
		this.param = _args.param;
		this.lang = _args.lang || "zh-cn";

		this.fullDigit = function(_t) {
			if (_t < 10) {
				_t = "0" + _t;
			}
			return _t;
		};

		this.getWeekday = function(_w, _lang) {
			var weekday = {
				"en-us": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fei", "Sat"],
				"zh-cn": ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
			};
			return weekday[_lang][_w];
		};

		var d = null;
		if (this.param) {
			if (typeof(this.param) == "long") {
				this.param = Math.floor(this.param); //fix iPanel bug, convert type long to number
			}
			d = new Date(this.param);
		} else {
			d = new Date();
		}
		var year = d.getFullYear();
		var month = d.getMonth() + 1;
		var day = d.getDate();
		var hour = d.getHours();
		var minute = d.getMinutes();
		var second = d.getSeconds();
		var millisecond = d.getMilliseconds();
		var weekday = this.getWeekday(d.getDay(), this.lang.toLowerCase());
		if (!this.format) {
			this.format = "YYYY-MM-DD W HH:mm:SS";
		}
		var str = this.format;
		//多位-年
		str = str.replace(/[y|Y]+/g, year.toString());
		//两位，与一位的前后顺序不能改
		str = str.replace(/[M]{2}/g, this.fullDigit(month).toString());
		str = str.replace(/[d|D]{2}/g, this.fullDigit(day).toString());
		str = str.replace(/[h|H]{2}/g, this.fullDigit(hour).toString());
		str = str.replace(/[m]{2}/g, this.fullDigit(minute).toString());
		str = str.replace(/[s|S]{2}/g, this.fullDigit(second).toString());
		//一位
		str = str.replace(/[M]{1}/g, month.toString());
		str = str.replace(/[d|D]{1}/g, day.toString());
		str = str.replace(/[h|H]{1}/g, hour.toString());
		str = str.replace(/[m]{1}/g, minute.toString());
		str = str.replace(/[s|S]{1}/g, second.toString());
		//多位-星期
		str = str.replace(/[w|W]+/g, weekday);
		return str;
	}
};

function secondsToTimeStr(_seconds, _type) { //type:有两种值，为"hh:mm:ss"和"hh:mm"，默认为前者
	/**
	 * 将秒数格式化为 "HH:mm:SS" 格式
	 * 当然想将分钟格式话为 "HH:mm:SS" ，调用此方法前，将分钟数乘以60
	 */
	function fullDigit(_num) {
		if (_num < 10) {
			_num = "0" + _num;
		}
		return _num;
	}

	if (!_seconds) {
		if (type.toLowerCase() == "hh:mm") {
			return "00:00";
		} else {
			return "00:00:00";
		}
	}

	var type = typeof(_type) == "undefined" ? "hh:mm:ss" : _type;

	var hour = Math.floor(_seconds / 3600);
	var minute = Math.floor((_seconds - hour * 3600) / 60);
	var second = Math.floor(_seconds - hour * 3600 - minute * 60);
	if (type.toLowerCase() == "hh:mm") {
		return fullDigit(hour) + ":" + fullDigit(minute);
	} else {
		return fullDigit(hour) + ":" + fullDigit(minute) + ":" + fullDigit(second);
	}
}

/*
 * showList对象的作用就是控制在页面列表数据信息上下滚动切换以及翻页；
 * @__listSize    列表显示的长度；
 * @__dataSize    所有数据的长度；
 * @__position    数据焦点的位置；
 * @__startplace  页面焦点Div开始位置的TOP值；
 */
function showList(__listSize, __dataSize, __position, __startplace, f){
	this.listSize = __listSize;  //列表显示的长度；
	this.dataSize = __dataSize;  //所有数据的长度；
	this.position = __position;  //数据焦点的位置；
	this.tempSize = this.dataSize<this.listSize?this.dataSize:this.listSize;
	this.focusPos = this.dataSize-this.position<this.tempSize?this.tempSize-(this.dataSize-this.position):0; //页面焦点的位置；

	this.listHigh = null;  //列表中每个行的高度，可以是数据或者数组，例如：40 或 [40,41,41,40,42];
	this.focusDiv = null;  //页面焦点的ID名称或者定义为滑动对象，例如："focusDiv" 或 new showSlip("focusDiv",0,3,40);
	this.focusPlace = new Array();  //记录每行页面焦点的位置值；
	this.startPlace = __startplace;	 //页面焦点Div开始位置的TOP值；
	
	this.haveData = function(){}; //在显示列表信息时，有数据信息就会调用该方法；
	this.notData = function(){}; //在显示列表信息时，无数据信息就会调用该方法；
	//调用以上两个方法都会收到参数为{idPos:Num, dataPos:Num}的对象，该对象属性idPos为页面焦点的值，属性dataPos为数据焦点的值；
	
	this.focusUp  = function(){this.changeList(-1);}; //焦点向上移动；
	this.focusDown= function(){this.changeList(1); }; //焦点向下移动；
	this.pageUp   = function(){this.changePage(-1);}; //列表向上鄱页；
	this.pageDown = function(){this.changePage(1); }; //列表向下鄱页；
	
	//开始显示列表信息
	this.startShow = function(){
		this.focusPlace[0]= this.startPlace;
		Utility.println("common__startShow__startPlace=" + this.startPlace + "__listHight=" + this.listHigh);
		if(typeof(this.listHigh)=="number"){
			for(var i=1; i<this.listSize; i++) this.focusPlace[i] = this.listHigh*i+this.startPlace;
		}else if(typeof(this.listHigh)=="object"){
			for(var i=1; i<this.listSize; i++) this.focusPlace[i] = typeof(this.listHigh[i-1])=="undefined"?this.listHigh[this.listHigh.length-1]+this.focusPlace[i-1]:this.listHigh[i-1]+this.focusPlace[i-1];
		}
		if(typeof(this.focusDiv)=="string"){
			if (typeof(f) == "object"){
				f.document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos]
			} else {
				document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos];
			}
		}else{
			this.focusDiv.tunePlace(this.focusPlace[this.focusPos]);
		}
		this.showList();
	}
	//切换数据焦点的位置
	this.changeList = function(__num){
		if(this.position+__num<0||this.position+__num>this.dataSize-1) return;
		this.position += __num;
		if(this.focusPos+__num<0||this.focusPos+__num>this.listSize-1){
			this.showList();
		}else{
			this.changeFocus(__num);
		}	
	}
	//切换页面列表翻页
	this.changePage = function(__num){
		var tempPos = this.position-this.focusPos;
		if((tempPos==0 && __num<0)||(tempPos==this.dataSize-this.tempSize && __num>0)) return;
		tempPos += __num*this.tempSize;
		if(tempPos<0){
			tempPos = 0;
		}else if(tempPos>this.dataSize-this.tempSize){
			tempPos = this.dataSize-this.tempSize;
		}
		if(this.focusPos!=0) this.changeFocus(this.focusPos*-1);
		this.position = tempPos;
		this.showList();
	}
	//切换页面焦点的位置
	this.changeFocus = function(__num){
		this.focusPos += __num;		
		if(typeof(this.focusDiv)=="string"){
			if (typeof(f) == "object"){
				f.document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos];
			} else {
				document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos];
			}
		}else{
			this.focusDiv.moveStart(__num/Math.abs(__num), Math.abs(this.focusPlace[this.focusPos-__num]-this.focusPlace[this.focusPos]));
		}
	}
	//显示列表信息
	this.showList = function(){
		var tempPos = this.position-this.focusPos;
		for(var i=tempPos; i<tempPos+this.listSize; i++){
			if(i<this.dataSize){
				this.haveData({idPos:i-tempPos, dataPos:i});
			}else{
				this.notData({idPos:i-tempPos, dataPos:i});
			}
		}
	}
}

/*
 * showSlip对象的作用就是控制Div层的滑动；
 * @__name  所要滑动对象的ID名称；
 * @__sign  “0”表示上下滑动，“1”表示左右滑动；
 * @__delay 此值是控制步长的，每次滑动的步长就是到终点所剩距离的__delay分之一,默认值(4)；
 * @__time  滑动间隔时间,默认值(40)；
 */
function showSlip(__name, __sign, __delay, __time, __f){
	this.Windows	= typeof(__f)=="undefined" ? window : __f;
	this.moveObj	= this.Windows.document.getElementById(__name); //所要滑动的对象；
	this.moveSize	= 500;    //每一次滑动的距离；
	this.moveType	= 1;      //1表是正向滑动，-1表是反向滑动；
	this.moveSign	= typeof(__sign)=="number"?(__sign==0?"top":"left") : __sign; //0表示top属性，1表示left属性；

	this.endPlace	= this.moveObj.style[this.moveSign]; //滑动结束位置；
	this.currPlace	= this.endPlace; //滑动当前位置；
	
	this.loadtimer	= null;
	this.spaceTime	= __time;   //滑动间隔时间,默认值(40)；
	this.delayValue = __delay;  //此值是控制步长的，每次滑动的步长就是到终点所剩距离的this.delayValue分之一,默认值(4)；
	this.setpSize   = 2;	//每次移动的步长；
	this.setpType   = 0;	//控制步长的类型，默认值0表示取this.delayValue为步长的缓冲滑动效果，1表示取this.setpSize为步长的均速滑动效果；
	//监听器属性列表
	this.listener = ["onMoveStart", "onMoveProgress", "onMoveEnd"];
	//添加监听对象，以便在调用 showSlip 事件处理函数时接收通知;
	this.addListener = function(__obj){
		var temp = this.listener;
		for(var i=0; i<temp.length; i++) this[temp[i]] = typeof(__obj[temp[i]])=="function" ? __obj[temp[i]] : function(){};
	}
	//删除或初始化监听对象；
	this.delListener = function(){
		var temp = this.listener;
		for(var i=0; i<temp.length; i++) this[temp[i]] = function(){};
	}
	this.delListener();
	
	//开始滑动对象
	this.moveStart = function(__type, __size){
		this.moveStop();
		this.onMoveStart();
		this.moveType = __type;
		this.moveSize = __size;
		this.endPlace += this.moveSize*this.moveType;
		this.moveGoto();
	}
	//计算当前要滑动的位置
	this.moveGoto = function(){
		var tempStep = this.setpType == 0 ? Math.ceil(Math.abs((this.endPlace-this.currPlace)/this.delayValue))*this.moveType : this.setpSize*this.moveType; //计算步长
		this.currPlace += tempStep;
		if((this.moveType==-1&&this.currPlace<=this.endPlace)||(this.moveType==1&&this.currPlace>=this.endPlace)||tempStep==0){ //判断是否到达终点
			this.currPlace = this.endPlace;
			this.setcurrPlace();
			this.onMoveEnd();
		}else{
			var self = this;
			this.setcurrPlace();
			this.onMoveProgress();
			this.loadtimer = this.Windows.setTimeout(function(){self.moveGoto();},this.spaceTime);
		}
	}
	//设置滑动对象的位置
	this.setcurrPlace = function(){
		this.moveObj.style[this.moveSign] = this.currPlace;
	}
	//调整对象位置，参数__num是将要调整位置的值
	this.tunePlace = function(__num){
		this.endPlace  = __num; 
		this.currPlace = this.endPlace;
		this.setcurrPlace();
	}
	//对象停止滑动
	this.moveStop = function(){ this.Windows.clearTimeout(this.loadtimer);}
}


//*******************************获取标准URL的参数 start************************//
/**
 * 获取标准URL的参数
 * @_key：字符串，不支持数组参数（多个相同的key）
 * @_url：字符串，（window）.location.href，使用时别误传入非window对象
 * @_spliter：字符串，参数间分隔符
 * 注意：
 * 	1、如不存在指定键，返回空字符串，方便直接显示，使用时注意判断
 * 	2、非标准URL勿用
 * 	3、query（？）与hash（#）中存在键值一样时，以数组返回
 */
function getUrlParams(_key, _url, _spliter) {
	Utility.println("common.js===getUrlParams====_url" + _url);
	if (typeof(_url) == "object") {
		var url = _url.location.href;
	} else {
		var url = _url ? _url : window.location.href;
	}
	if (url.indexOf("?") == -1 && url.indexOf("#") == -1) {
		return "";
	}
	var spliter = _spliter || "&";
	var spliter_1 = "#";
	var haveQuery = false;
	var x_0 = url.indexOf(spliter);
	var x_1 = url.indexOf(spliter_1);
	var urlParams;
	if (x_0 != -1 || x_1 != -1 || url.indexOf("?") != -1) {
		if(url.indexOf("?") != -1) urlParams = url.split("?")[1];
		else if(url.indexOf("#") != -1) urlParams = url.split("#")[1];
		else urlParams = url.split(spliter)[1];
		if (urlParams.indexOf(spliter) != -1 || urlParams.indexOf(spliter_1) != -1) {//可能出现 url?a=1&b=3#c=2&d=5 url?a=1&b=2 url#a=1&b=2的情况。
			var v = [];
			if(urlParams.indexOf(spliter_1) != -1){
				v = urlParams.split(spliter_1);
				urlParams = [];
				for(var x = 0; x < v.length; x++){
					urlParams = urlParams.concat(v[x].split(spliter));
				}
			}else{
				urlParams = urlParams.split(spliter);
			}
		} else {
			urlParams = [urlParams];
		}
		haveQuery = true;
	} else {
		urlParams = [url];
	}
	var valueArr = [];
	for (var i = 0, len = urlParams.length; i < len; i++) {
		var params = urlParams[i].split("=");
		if (params[0] == _key) {
			valueArr.push(params[1]);
		}
	}
	if (valueArr.length > 0) {
		if (valueArr.length == 1) {
			return valueArr[0];
		}
		return valueArr;
	}
	return "";
}
//*****************************获取标准URL的参数 end********************//


function changeLocationHash(_params, _noHistory, _frame, _spliter) {
	/**
	 * @based on function getUrlParams
	 * @only replace the key and value at the first place
	 * @when _noHistory is true will change location without history, generally use to record position
	 */
	if (typeof(_frame) != "object") {
		_frame = window;
	}
	var spliter = _spliter || "&";
	var hash = _frame.location.hash.replace("#", "");
	for (var i = 0; i < _params.length; i++) {
		if (hash == "") {
			hash = _params[i][0] + "=" + _params[i][1];
		} else {
			if (hash.indexOf(_params[i][0] + "=") != -1) {
				var value = getUrlParams(_params[i][0], _frame.location.hash);
				var str = "";
				if (hash.indexOf(spliter + _params[i][0] + "=" + value) != -1) {
					str = spliter + _params[i][0] + "=" + value;
				} else if (hash.indexOf(_params[i][0] + "=" + value + spliter) != -1) {
					str = _params[i][0] + "=" + value + spliter;
				} else {
					str = _params[i][0] + "=" + value;
				}
				hash = hash.replace(str, "");
			}
			if (hash == "") {
				hash += _params[i][0] + "=" + _params[i][1];
			} else {
				hash += spliter + _params[i][0] + "=" + _params[i][1];
			}
		}
	}
	if (hash == "") {
		return;
	}
	if (_noHistory) {
		_frame.location.replace((_frame.location.pathname + _frame.location.search + "#" + hash));
		return;
	}
	_frame.location.hash = hash;
}

function getCharByte(_content, _limit) { //获取字符串的总字节数
	var byteCount = 0;
	for (var i = 0; i < _content.length; i++) {
		byteCount = (_content.charCodeAt(i) <= 255) ? byteCount + 1 : byteCount + 2;
		if (typeof(_limit) != "undefined") {
			if (byteCount > _limit) {
				return true;
			}
		}
	}
	return byteCount;
}
function subStr(_str, _bytes, _suffix) {
	/**
	 * 以一个汉字为2个字母截取字母汉字混合字符串（临界字符是汉字的话，不返回这个汉字，所以返回长度可能少一字节）
	 * iPanel.misc.interceptString(_str, _bytes) 接口有问题，在utf-8页面编码下，误把一个汉字当3 Byte处理
	 * @_bytes：字节数
	 */
	if (!_str) {
		return "";
	}
	if (!_bytes) {
		return _str;
	}
	var charLen = 0; //预期计数：中文2字节，英文1字节
	var tempStr = ""; //临时字串
	for (var i = 0; i < _str.length; i++) {
		if (_str.charCodeAt(i) > 255) { //按照预期计数增加2
			charLen += 2;
		} else {
			charLen++;
		}
		if (charLen > _bytes) { //如果增加计数后长度大于限定长度，就直接返回临时字符串
			if (_suffix) {
				return tempStr + _suffix;
			}
			return tempStr;
		}
		tempStr += _str.charAt(i); //将当前内容加到临时字符串
	}
	if (_suffix && charLen > _bytes) {
		return _str + _suffix;
	}
	return _str; //如果全部是单字节字符，就直接返回源字符串
}
//转化JSON对象成字符串
function jsonToString(o) {
	if (o == undefined) {
		return "";
	}
	var r = [];
	if (typeof o == "string") return "\"" + o.replace(/([\"\\])/g, "\\$1").replace(/(\n)/g, "\\n").replace(/(\r)/g, "\\r").replace(/(\t)/g, "\\t") + "\"";
	if (typeof o == "object") {
		if (!o.sort) {
			for (var i in o) r.push("\"" + i + "\":" + jsonToString(o[i]));
			if ( !! document.all && !/^\n?function\s*toString\(\)\s*\{\n?\s*\[native code\]\n?\s*\}\n?\s*$/.test(o.toString)) {
				r.push("toString:" + o.toString.toString());
			}
			r = "{" + r.join() + "}";
		} else {
			for (var i = 0; i < o.length; i++) r.push(jsonToString(o[i]));
			r = "[" + r.join() + "]";
		}
		return r;
	}
	return o.toString().replace(/\"\:/g, '":""');
}

// BOF XML Document and String
function xmlStrToXmlDoc(_xmlStr) {
	if (window.DOMParser) {
		return (new DOMParser()).parseFromString(_xmlStr, "text/xml");
	} else {
		var DOMParser = new ActiveXObject("Microsoft.XMLDOM");
		DOMParser.async = false;
		return DOMParser.loadXML(_xmlStr);
	}
}

function xmlDocToXmlStr(_xmlDoc) {
	if (window.XMLSerializer) {
		return (new XMLSerializer()).serializeToString(_xmlDoc);
	} else {
		return _xmlDoc.xml;
	}
}
// EOF XML Document and String

function getXmlValue(_xmlNode, _nodeName, _flag) {
	var value = null;
	var flag = _flag.toLowerCase();
	var nodes = _xmlNode.getElementsByTagName(_nodeName);
	if (nodes.length == 0) {
	} else if (flag == "nodevalue") {
		value = nodes[0].childNodes[0].nodeValue;
	} else if (flag == "object") {
		value = nodes[0];
	} else if (flag == "array") {
		value = nodes;
	}
	return value;
}

function fillDigitLen(_num, _len) {
	var number = "";
	if (_len == 1) {
		if (_num < 10) {
			number = "0" + _num;
		} else {
			number = "" + _num;
		}
	} else if (_len == 2) {
		if (_num < 10) {
			number = "00" + _num;
		} else if (_num < 100) {
			number = "0" + _num;
		} else {
			number = "" + _num;
		}
	} else if (_len == 3) {
		if (_num < 10) {
			number = "000" + _num;
		} else if (_num < 100) {
			number = "00" + _num;
		} else if (_num < 1000) {
			number = "0" + _num;
		} else {
			number = "" + _num;
		}
	} else {
		return "" + _num;
	}
	return number;
}


/****************************ajax请求 start**************************************/
function ajaxClass(_url, _successCallback, _failureCallback, _urlParameters, _callbackParams, _async, _charset, _timeout, _frequency, _requestTimes, _frame) {
	/**
	 * AJAX通过GET或POST的方式进行异步或同步请求数据
	 * 注意：
	 * 	1、服务器240 No Content是被HTTP标准视为请求成功的
	 * 	2、要使用responseXML就不能设置_charset，需要直接传入null
	 * 	3、_frame，就是实例化本对象的页面对象，请尽量保证准确，避免出现难以解释的异常
	 */
	/**
	 * @param{string} _url: 请求路径
	 * @param{function} _successCallback: 请求成功后执行的回调函数，带一个参数（可扩展一个）：new XMLHttpRequest()的返回值
	 * @param{function} _failureCallback: 请求失败/超时后执行的回调函数，参数同成功回调，常用.status，.statusText
	 * @param{string} _urlParameters: 请求路径所需要传递的url参数/数据
	 * @param{*} _callbackParams: 请求结束时在回调函数中传入的参数，自定义内容
	 * @param{boolean} _async: 是否异步调用，默认为true：异步，false：同步
	 * @param{string} _charset: 请求返回的数据的编码格式，部分iPanel浏览器和IE6不支持，需要返回XML对象时不能使用
	 * @param{number} _timeout: 每次发出请求后多长时间内没有成功返回数据视为请求失败而结束请求（超时）
	 * @param{number} _frequency: 请求失败后隔多长时间重新请求一次
	 * @param{number} _requestTimes: 请求失败后重新请求多少次
	 * @param{object} _frame: 窗体对象，需要严格控制，否则会有可能出现页面已经被销毁，回调还执行的情况
	 */
	this.url = _url || "";
	this.successCallback = _successCallback || function(_xmlHttp, _params) {
		Utility.println("[xmlHttp] responseText: " + _xmlHttp.responseText);
	};
	this.failureCallback = _failureCallback || function(_xmlHttp, _params) {
		Utility.println("[xmlHttp] status: " + _xmlHttp.status + ", statusText: " + _xmlHttp.statusText);
	};
	this.urlParameters = _urlParameters || "";
	this.callbackParams = _callbackParams || null;
	this.async = typeof(_async) == "undefined" ? true : _async;
	this.charset = _charset || null;
	this.timeout = _timeout || 5000; //20s
	this.frequency = _frequency || 500; //10s
	this.requestTimes = _requestTimes || 1;
	this.frame = _frame || window;

	this.timer = -1;
	this.counter = 0;

	this.method = "GET";
	this.headers = null;
	this.username = "";
	this.password = "";

	this.createXmlHttpRequest = function() {
		var xmlHttp = null;
		try { //Standard
			xmlHttp = new XMLHttpRequest();
		} catch (exception) { //Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (exception) {
				try {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (exception) {
					return false;
				}
			}
		}
		return xmlHttp;
	};
	this.xmlHttp = this.createXmlHttpRequest();

	this.requestData = function(_method, _headers, _username, _password) {
		/**
		 * @param{string} _method: 传递数据的方式，POST/GET
		 * @param{string} _headers: 传递数据的头信息，json格式
		 * @param{string} _username: 服务器需要认证时的用户名
		 * @param{string} _password: 服务器需要认证时的用户密码
		 */
		this.frame.clearTimeout(this.timer);
		this.method = typeof(_method) == "undefined" ? "GET" : (_method.toLowerCase() == "post") ? "POST" : "GET";
		this.headers = typeof(_headers) == "undefined" ? null : _headers;
		this.username = typeof(_username) == "undefined" ? "" : _username;
		this.password = typeof(_password) == "undefined" ? "" : _password;
		Utility.println("[xmlHttp] method=" + this.method + "-->headers=" + _headers + "-->username=" +  this.username + "-->password=" + this.password);
		var target = this;
		var url;
		var data;
		this.xmlHttp.onreadystatechange = function() {
			target.stateChanged();
		};
		if (this.method == "POST") { //encodeURIComponent
			url = encodeURI(this.url);
			data = this.urlParameters;
		} else {
			url = encodeURI(this.url + (((this.urlParameters != "" && this.urlParameters.indexOf("?") == -1) && this.url.indexOf("?") == -1) ? ("?" + this.urlParameters) : this.urlParameters));
			data = null;
		}
		Utility.println("[xmlHttp] username=" + this.username + "-->xmlHttp=" + this.xmlHttp + "typeof(open)=" + typeof(this.xmlHttp.open));
		if (this.username != "") {
			this.xmlHttp.open(this.method, url, this.async, this.username, this.password);
		} else {
			this.xmlHttp.open(this.method, url, this.async);
		}
		Utility.println("[xmlHttp] method=" + this.method + "-->url=" + url + "-->async=" + this.async);
		var contentType = false;
		if (this.headers != null) {
			for (var key in this.headers) {
				if (key.toLowerCase() == "content-type") {
					contentType = true;
				}
				Utility.println("common__contentType=" + contentType);
				this.xmlHttp.setRequestHeader(key, this.headers[key]);
			}
		}
		if (!contentType) {
			Utility.println("[xmlHttp] setRequestHeader");
			//this.xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			//this.xmlHttp.setRequestHeader("Content-type","text/xml;charset=utf-8");
			this.xmlHttp.setRequestHeader("Content-type","application/xml;charset=utf-8")
		}
		if (this.charset != null) { //要使用responseXML就不能设置此属性
			this.xmlHttp.overrideMimeType("text/html; charset=" + this.charset);
		}
		Utility.println("[xmlHttp] " + this.method + " url: " + url + ", data: " + data);
		this.xmlHttp.send(data);
	};
	this.stateChanged = function() { //状态处理
		if (this.xmlHttp.readyState < 2) {
			Utility.println("[xmlHttp] readyState=" + this.xmlHttp.readyState);
		} else {
			Utility.println("[xmlHttp] readyState=" + this.xmlHttp.readyState + ", status=" + this.xmlHttp.status);
		}

		var target = this;
		if (this.xmlHttp.readyState == 2) {
			this.timer = this.frame.setTimeout(function() {
				target.checkStatus();
			}, this.timeout);
		} else if (this.xmlHttp.readyState == 3) {
			if (this.xmlHttp.status == 401) {
				Utility.println("[xmlHttp] Authentication, need correct username and pasword");
			}
		} else if (this.xmlHttp.readyState == 4) {
			this.frame.clearTimeout(this.timer);
			if (this.xmlHttp.status == 200 || this.xmlHttp.status == 204) {
				this.success();
			} else {
				this.failed();
			}
		}
	};
	this.success = function() {
		if (this.callbackParams == null) {
			this.successCallback(this.xmlHttp);
		} else {
			this.successCallback(this.xmlHttp, this.callbackParams);
		}
		this.counter = 0;
	};
	this.failed = function() {
		if (this.callbackParams == null) {
			this.failureCallback(this.xmlHttp);
		} else {
			this.failureCallback(this.xmlHttp, this.callbackParams);
		}
		this.counter = 0;
	};
	this.checkStatus = function() { //超时处理，指定时间内没有成功返回信息按照失败处理
		if (this.xmlHttp.readyState != 4) {
			if (this.counter < this.requestTimes) {
				this.requestAgain();
			} else {
				Utility.println("[xmlHttp] readyState=" + this.xmlHttp.readyState + ", status=" + this.xmlHttp.status + " timeout");
				this.failed();
				this.requestAbort();
			}
		}
	};
	this.requestAgain = function() {
		this.requestAbort();
		var target = this;
		this.frame.clearTimeout(this.timer);
		this.timer = this.frame.setTimeout(function() {
			Utility.println("[xmlHttp] request again");
			target.counter++;
			target.requestData(target.method, target.headers, target.username, target.password);
		}, this.frequency);
	};
	this.requestAbort = function() {
		Utility.println("[xmlHttp] call abort");
		this.frame.clearTimeout(this.timer);
		this.xmlHttp.abort();
		Utility.println("[xmlHttp] call abort has called");
	};
	this.addParameter = function(_json) {
		/**
		 * @param{object} _json: 传递的参数数据处理，只支持json格式
		 */
		var url = this.url;
		var str = this.urlParameters;
		for (var key in _json) {
			if (url.indexOf("?") != -1) {
				url = "";
				if (str == "") {
					str = "&" + key + "=" + _json[key];
				} else {
					str += "&" + key + "=" + _json[key];
				}
				continue;
			}
			if (str == "") {
				str += "?";
			} else {
				str += "&";
			}
			str += key + "=" + _json[key];
		}
		this.urlParameters = str;
		return str;
	};
	this.getResponseXML = function() { //reponseXML of AJAX is null when response header 'Content-Type' is not include string 'xml', not like 'text/xml', 'application/xml' or 'application/xhtml+xml'
		if (this.xmlHttp.responseXML != null) {
			return this.xmlHttp.responseXML;
		} else if (this.xmlHttp.responseText.indexOf("<?xml") != -1) {
			return typeof(DOMParser) == "function" ? (new DOMParser()).parseFromString(this.xmlHttp.responseText, "text/xml") : (new ActivexObject("MSXML2.DOMDocument")).loadXML(this.xmlHttp.responseText);
		}
		return null;
	};
}
/****************************ajax请求 end**************************************/



//******************************解析XML文件 start**********************************//
function xmlDocToJson(_xmlDoc, _arrayNames, _attributes) {
	/**
	 * xmlDocToJson 非 attributes 方法：存在多个相同名称子节点时需要指定父节点及子节点名称，子节点作为数组
	 * xmlDocToJson attributes 方法：属性与子节点并存时，没有其他方案能够表现在JSON中，所以解决方案为给属性0赋值，访问子节点属性时要使用[0]
	 * 解析XML格式情况有限，存在的问题有：
	 *    1. 节点下有文本且有其他子节点时，会忽略文本
	 *    2. 如果没有指定子节点是数组形式，没有子节点时，节点的值为字符串格式，而非对象
	 *    3. 非 attributes 方法，子节点是数组形式，孙节点是数组形式，数组形式不能延续下去了，attributes 方法孙节点不能数组形式
	 * xmlDocToJson(xmlDoc, [{"AppInfos": "AppInfo"}, {"AppRelatedPics": "appRelatedPic"}, {"AppGenres": "appGenreInfo"}]);
	 * xmlDocToJson(xmlDoc, [{"AppInfos": "AppInfo"}, {"AppRelatedPics": "appRelatedPic"}, {"AppGenres": "appGenreInfo"}], true);
	 */
	function xmlStrToXmlDoc(_xmlStr) {
		if (window.DOMParser) {
			return (new DOMParser()).parseFromString(_xmlStr, "text/xml");
		} else {
			var DOMParser = new ActiveXObject("Microsoft.XMLDOM");
			DOMParser.async = false;
			return DOMParser.loadXML(_xmlStr);
		}
	}
	if (typeof(_xmlDoc) == "string") {
		_xmlDoc = xmlStrToXmlDoc(_xmlDoc);
	}
	if (_xmlDoc == null) {
		Utility.println("[ERROR] the argument '_xmlDoc' is equal to null. (reponseXML of AJAX is null when response header 'Content-Type' is not include string 'xml', not like 'text/xml', 'application/xml' or 'application/xhtml+xml')");
		return {};
	}
	/*if (_arrayNames instanceof Array == false) { //instanceof Array test fails when using iframes
		if (typeof(_arrayNames) == "object" && _arrayNames != null) {
			_arrayNames = [_arrayNames];
		} else {
			_arrayNames = [];
		}
	}*/
	if (typeof(_arrayNames) == "undefined" || _arrayNames == null) {
		_arrayNames = [];
	}
	var obj = {};
	for (var i = 0; i < _xmlDoc.childNodes.length; i++) {
		var nodeName = ["", ""];
		out_1:
		for (var j = 0; j < _arrayNames.length; j++) {
			for (var key in _arrayNames[j]) {
				if (key == _xmlDoc.childNodes[i].nodeName || (arguments.length > 3 && _arrayNames[j][key] == _xmlDoc.childNodes[i].nodeName)) {
					nodeName = [_arrayNames[j][key], key];
					obj[_xmlDoc.childNodes[i].nodeName] = {};
					//_arrayNames.splice(j, 1);
					break out_1;
				}
			}
		}
		if (_attributes) {
			if (_xmlDoc.childNodes[i].nodeName == "#text") {
				continue;
			}
			if (nodeName[0] != "") {
				if (_xmlDoc.childNodes[i].nodeName == nodeName[1]) {
					if (_xmlDoc.childNodes[i].childNodes.length == 0 || (_xmlDoc.childNodes[i].childNodes.length == 1 && _xmlDoc.childNodes[i].childNodes[0].nodeName == "#text")) {
						out_5:
						for (var j = 0; j < _arrayNames.length; j++) {
							for (var key in _arrayNames[j]) {
								if (key == nodeName[1]) {
									if (typeof(obj[_xmlDoc.childNodes[i].nodeName]) == "undefined") {
										obj[_xmlDoc.childNodes[i].nodeName] = {};
									}
									obj[_xmlDoc.childNodes[i].nodeName][_arrayNames[j][key]] = [];
									break out_5;
								}
							}
						}
					}
				}
				for (var j = 0; j < _xmlDoc.childNodes[i].childNodes.length; j++) {
					if (_xmlDoc.childNodes[i].childNodes[j].nodeName == "#text") {
						continue;
					}
					if (_xmlDoc.childNodes[i].childNodes[j].nodeName == nodeName[0]) {
						if ((_xmlDoc.childNodes[i].childNodes[j].childNodes.length == 0 && _xmlDoc.childNodes[i].childNodes[j].nodeName != "#text") || (_xmlDoc.childNodes[i].childNodes[j].childNodes.length == 1 && _xmlDoc.childNodes[i].childNodes[j].childNodes[0].nodeName == "#text")) {
							var attrObj = {};
							for (var k = 0; k < _xmlDoc.childNodes[i].childNodes[j].attributes.length; k++) {
								var attr = _xmlDoc.childNodes[i].childNodes[j].attributes[k];
								attrObj[attr.name] = attr.value;
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]] = [];
							}
							obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]].push(attrObj);
						} else {
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][0]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName]["0"] = {};
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]] = {};
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]]["0"]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]]["0"] = [];
							}
							obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]]["0"].push(xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames, true));
							for (var k = 0; k < _xmlDoc.childNodes[i].childNodes[j].attributes.length; k++) {
								var attr = _xmlDoc.childNodes[i].childNodes[j].attributes[k];
								obj[_xmlDoc.childNodes[i].nodeName]["0"][nodeName[0]][attr.name] = attr.value;
							}
						}
					} else {
						var arrFormat = false;
						out_6:
						for (var k = 0; k < _arrayNames.length; k++) {
							for (var key in _arrayNames[k]) {
								if (key == nodeName[1] && _xmlDoc.childNodes[i].childNodes[j].nodeName == _arrayNames[k][key]) {
									arrFormat = true;
									break out_6;
								}
							}
						}
						if (arrFormat == true) {
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName] = {};
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName]["0"]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName]["0"] = [];
							}
							obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName]["0"].push(xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames, true));
						} else {
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][0]) == "undefined") {
								for (var j = 0; j < _xmlDoc.childNodes[i].attributes.length; j++) {
									var attr = _xmlDoc.childNodes[i].attributes[j];
									obj[_xmlDoc.childNodes[i].nodeName][attr.name] = attr.value;
								}
								obj[_xmlDoc.childNodes[i].nodeName]["0"] = {};
							}
							if (_xmlDoc.childNodes[i].childNodes[j].nodeName == "#text") {
								continue;
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName]["0"][_xmlDoc.childNodes[i].childNodes[j].nodeName]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName]["0"][_xmlDoc.childNodes[i].childNodes[j].nodeName] = {};
							}
							obj[_xmlDoc.childNodes[i].nodeName]["0"][_xmlDoc.childNodes[i].childNodes[j].nodeName]["0"] = xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames, true);
						}
					}
				}
			} else {
				obj[_xmlDoc.childNodes[i].nodeName] = {};
				for (var j = 0; j < _xmlDoc.childNodes[i].attributes.length; j++) {
					var attr = _xmlDoc.childNodes[i].attributes[j];
					obj[_xmlDoc.childNodes[i].nodeName][attr.name] = attr.value;
				}
				obj[_xmlDoc.childNodes[i].nodeName]["0"] = xmlDocToJson(_xmlDoc.childNodes[i], _arrayNames, true);
			}
		} else {
			if (_xmlDoc.childNodes[i].childNodes.length == 0 && _xmlDoc.childNodes[i].nodeName != "#text") { //no character(space) between xml tags
				if (_xmlDoc.childNodes[i].nodeName == nodeName[1]) {
					out_2:
					for (var j = 0; j < _arrayNames.length; j++) {
						for (var key in _arrayNames[j]) {
							if (key == nodeName[1]) {
								if (typeof(obj[_xmlDoc.childNodes[i].nodeName]) == "undefined") {
									obj[_xmlDoc.childNodes[i].nodeName] = {};
								}
								obj[_xmlDoc.childNodes[i].nodeName][_arrayNames[j][key]] = [];
								break out_2;
							}
						}
					}
				} else {
					obj[_xmlDoc.childNodes[i].nodeName] = "";
				}
			} else if (_xmlDoc.childNodes[i].childNodes.length == 1 && _xmlDoc.childNodes[i].childNodes[0].nodeName == "#text") { //have character(s) between xml tags
				if (_xmlDoc.childNodes[i].nodeName == nodeName[1]) {
					out_3:
					for (var j = 0; j < _arrayNames.length; j++) {
						for (var key in _arrayNames[j]) {
							if (key == nodeName[1]) {
								if (typeof(obj[_xmlDoc.childNodes[i].nodeName]) == "undefined") {
									obj[_xmlDoc.childNodes[i].nodeName] = {};
								}
								obj[_xmlDoc.childNodes[i].nodeName][_arrayNames[j][key]] = [];
								break out_3;
							}
						}
					}
				} else {
					obj[_xmlDoc.childNodes[i].nodeName] = _xmlDoc.childNodes[i].childNodes[0].nodeValue;
				}
			} else {
				if (_xmlDoc.childNodes[i].nodeName == "#text") {
					if (_xmlDoc.childNodes[i].childNodes.length == 0 && _xmlDoc.childNodes[i].parentNode.childNodes.length == 1) {
						obj = _xmlDoc.childNodes[i].nodeValue;
					}
					continue;
				}
				if (nodeName[0] != "") {
					for (var j = 0; j < _xmlDoc.childNodes[i].childNodes.length; j++) {
						if (_xmlDoc.childNodes[i].childNodes[j].nodeName == "#text") {
							continue;
						}
						if (_xmlDoc.childNodes[i].childNodes[j].nodeName == nodeName[0] || (arguments.length > 3 && _xmlDoc.childNodes[i].nodeName == nodeName[0])) {
							if (arguments.length > 3) {
								if (typeof(obj[_xmlDoc.childNodes[i].nodeName]) == "undefined" || obj[_xmlDoc.childNodes[i].nodeName] instanceof Array == false) {
									obj[_xmlDoc.childNodes[i].nodeName] = [];
								}
								obj[_xmlDoc.childNodes[i].nodeName].push(xmlDocToJson(_xmlDoc.childNodes[i], _arrayNames));
								break;
							}
							if (typeof(obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]]) == "undefined") {
								obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]] = [];
							}
							if (_xmlDoc.childNodes[i].childNodes[j].childNodes.length == 0 && _xmlDoc.childNodes[i].childNodes[j].nodeName != "#text") {
								obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]].push("");
							} else if (_xmlDoc.childNodes[i].childNodes[j].childNodes.length == 1 && _xmlDoc.childNodes[i].childNodes[j].childNodes[0].nodeName == "#text") {
								obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]].push(_xmlDoc.childNodes[i].childNodes[j].childNodes[0].nodeValue);
							} else {
								obj[_xmlDoc.childNodes[i].nodeName][nodeName[0]].push(xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames, false, true));
							}
						} else {
							var arrFormat = false;
							out_4:
							for (var k = 0; k < _arrayNames.length; k++) {
								for (var key in _arrayNames[k]) {
									if (key == nodeName[1] && _xmlDoc.childNodes[i].childNodes[j].nodeName == _arrayNames[k][key]) {
										arrFormat = true;
										break out_4;
									}
								}
							}
							if (arrFormat == true) {
								if (typeof(obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName]) == "undefined") {
									obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName] = [];
								}
								obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName].push(xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames));
							} else {
								obj[_xmlDoc.childNodes[i].nodeName][_xmlDoc.childNodes[i].childNodes[j].nodeName] = xmlDocToJson(_xmlDoc.childNodes[i].childNodes[j], _arrayNames);
							}
						}
					}
				} else {
					obj[_xmlDoc.childNodes[i].nodeName] = xmlDocToJson(_xmlDoc.childNodes[i], _arrayNames);
				}
			}
		}
	}
	return obj;
}
//*******************************解析XML文件 end****************************//


//***************************************hashMap  start*******************************//
function hashTableClass(_maxLength) {
	/**
	 * 仿写java中的hashmap对象，在eventFrame里进行数据缓存
	 * @_maxLength：整型，缓存条目数量
	 * 注意：
	 * 	1、自行判定条目是否已存在，控制是否覆盖数据（也可在使用put方法时传入第三个布尔参数进行控制），否则将视为更新已存在的数据
	 * 	2、delete系统方法，可能不被一些vane版本中间件支持
	 */
	this.maxLength = typeof(_maxLength) == "undefined" ? 50 : _maxLength;

	this.hash = new Object();
	this.arry = new Array(); //记录条目的key

	this.put = function(_key, _value, _notCover) {
		/**
		 * @_key：字符串型
		 * @_value：不限制类型
		 * @_notCover：布尔型，设定为真后不进行覆盖
		 */
		if (typeof(_key) == "undefined") {
			return false;
		}
		if (this.contains(_key) == true) {
			if (_notCover) {
				return false;
			}
		}
		this.limit();
		if (this.contains(_key) == false) {
			this.arry.push(_key);
		}
		this.hash[_key] = typeof(_value) == "undefined" ? null : _value;
		return true;
	};
	this.get = function(_key) {
		if (typeof(_key) != "undefined") {
			if (this.contains(_key) == true) {
				return this.hash[_key];
			} else {
				return false;
			}
		} else {
			return false;
		}
	};
	this.remove = function(_key) {
		if (this.contains(_key) == true) {
			delete this.hash[_key];
			for (var i = 0, len = this.arry.length; i < len; i++) {
				if (this.arry[i] == _key) {
					this.arry.splice(i, 1);
					break;
				}
			}
			return true;
		} else {
			return false;
		}
	};
	//this.count = function() {var i = 0; for(var key in this.hash) {i++;} return i;};
	this.contains = function(_key) {
		return typeof(this.hash[_key]) != "undefined";
	};
	this.clear = function() {
		this.hash = {};
		this.arry = [];
	};
	this.limit = function() {
		if (this.arry.length >= this.maxLength) { //保存的对象数大于规定的最大数量
			var key = this.arry.shift(); //删除数组第一个数据，并返回数组原来第一个元素的值
			this.remove(key);
		}
	};
}
/***************************************hashMap  end*******************************/


/**********************************将xml对象转化为json对象 start***********************/

/*
** Dom解析函数
** 适用xml文件和dom文档
** @frag:dom对象, xml文件数据
** @return: 返回一个可直接被引用的数据对象
*/
function parseDom(frag) {
	var obj = new Object;
	var childs = getChilds(frag);
	var len = childs.length;
	var attrs = frag.attributes;
	if(attrs != null) {
		for(var i = 0; i < attrs.length; i++) {
			Utility.println("common__parseDom__nodeName=" + attrs[i].nodeName + "__nodeValue=" + attrs[i].nodeValue);
			obj[attrs[i].nodeName] = attrs[i].nodeValue;
		}
	}
	if(len == 0){
		return obj;
	}
	else
	{
		var tags = new Array();
		for(var i = 0; i < len; i++) {
			if(!inArray(childs[i].nodeName, tags)) tags.push(childs[i].nodeName);
		}

		for(var i = 0; i < tags.length; i++) {
			var nodes = getChildByTag(tags[i]);
			obj[tags[i]] = new Array;
			for(var j = 0; j < nodes.length; j++) {
				obj[tags[i]].push(getValue(nodes[j]));
			}
		}
	}
	return obj;
	
	//判断是否存在于数组的私有方法
	function inArray(a, arr) {
		for(var i = 0; i < arr.length; i++) {
			if(arr[i] == a) return true;
		}
		return false;
	}
	
	/*
	* nodeType:1(元素element),2:(属性attr),3:(文本text),8:(注释comments),9:(文档documents)
	*/
	//获取非文本类型子节点
	function getChilds(node) {
		var c = node.childNodes;// 返回包含被选节点的子节点的NodeList,如果选定的节点没有子节点，则该属性返回不包含节点的 NodeList。
		var a = new Array;
		if(c != null) {
			for(var i = 0; i < c.length; i++) {
				if(c[i].nodeType != 3) a.push(c[i]);
			}
		}
		return a;
	}
	
	//子元素中根据节点名来获取元素集合
	function getChildByTag(tag) {
		var a = new Array;
		for(var i = 0; i < len; i++) {
			if(childs[i].nodeName == tag) a.push(childs[i]);
		}
		return a;
	}
	
	//获取节点的文本，如果存在子节点则递归
	function getValue(node) {
		var c = getChilds(node);
		var obj_arr = new Object;
		if(c.length == 0) {
			if(node.firstChild){//文本
				obj_arr.value = node.firstChild.nodeValue;
			}
			var attrs = node.attributes;
			if(attrs != null){
				for(var i = 0; i < attrs.length; i++) {
					obj_arr[attrs[i].nodeName] = attrs[i].nodeValue;
				}
			}
			return obj_arr;
		}
		else return parseDom(node);
	}
}

function parseJson(str) {
	//Utility.println("parse.js_parseJson_str="+str);
	eval('var val = ' + str + ';');
	return val;
}

//在数组原型上添加一个数组转json字符串的方法，需要对象转json方法
Array.prototype.toJson = function () {
	var arr = new Array;
	for(var i = 0; i < this.length; i++) {
		switch(typeof this[i]) {
			case 'number':
				arr[i] = this[i];
				break;
			case 'boolean':
				arr[i] = this[i];
				break;
			case 'string':
				arr[i] = '"' + this[i].replace(/"/g, '\\\"') + '"';
				break;
			case 'object':
				arr[i] = this[i].toJson();
				break;
		}
	}
	return '[' + arr.join(', ') + ']';
};

//在对象原型上添加一个数组转json字符串的方法，需要数组转json方法
Object.prototype.toJson = function () {
	if(typeof this == 'object') {
		if(this instanceof Array) {
			return this.toJson();
		} else {
			var arr = new Array;
			var str = '';
			for(var p in this) {
				if(typeof this[p] == 'function') break;
				switch(typeof this[p]) {
					case 'number':
						str = this[p];
						break;
					case 'boolean':
						str = this[p];
						break;
					case 'string':
						str = '"' + this[p].replace(/"/g, '\\\"') + '"';
						break;
					case 'object':
						str = this[p].toJson();
						break;
				}
				arr.push(p + ':' + str);
			}
			return '{' + arr.join(', ') + '}';
		}
	} else return 'not object';
};

/*****************************************将xml对象转换为json对象 end****************************/


