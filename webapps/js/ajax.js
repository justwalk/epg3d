/*============================================AJAX 对象==================================
* 作用：通过get或post的方式请求异步（同步）数据
* @param{string} url: 将要去请求的路径
* @param{function} callback: 回调函数，即请求成功时所做的操作，带一个参数：new XMLHttpRequest()的返回值 
* @param{boolean} asyn: 是否异步调用，默认为true:异步，反之同步调用
* @param{number} timer: 请求失败时，隔timer时间重新请求一次
* @param{number} retrieval: 请求失败时，重新请求的次数，当为 -1 时，表示无数次
* @param{function} errorhandle: 请求失败时，所做的处理
*/
var objPool = [];
objPool[0] = createXMLHttpRequest();
objPool[1] = createXMLHttpRequest();
objPool[2] = createXMLHttpRequest();
objPool[3] = createXMLHttpRequest();
objPool[4] = createXMLHttpRequest();
objPool[5] = createXMLHttpRequest();

function AJAX_OBJ(url, callback, asyn, timer, retrieval, errorhandle){
	this.num = 0;
	this.url = url;
	this.urlParameters = "";
	this.callback = callback;
	this.errorhandle = errorhandle || this.errorHandle;
	this.timer = timer || 5000;
	this.timeout = -1;
	this.retrieval = retrieval || 1;	
	this.asyn = typeof asyn =="undefined"?true:asyn;
	this.xmlHttp = this.getInstance();
	this.backParam = null;
	this.timerout;
}
//请求实例
AJAX_OBJ.prototype.getInstance = function(){
	var request;
	try{
		request=new XMLHttpRequest;
	}
	catch(e){
		try{
			request=new ActiveXObject("MSXML2.XMLHTTP");
		}
		catch(e2){
			try{
				request=new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e3){
				request=false;
			}
		}
	}
	return request;
}

function createXMLHttpRequest(){
	var xmlh = null;
	if(window.XMLHttpRequest){
		xmlh = new XMLHttpRequest();
	}else if(window.ActiveXObject){
		xmlh = new ActiveXObject("Microsoft.XMLHTTP");
	}
	return xmlh;
}
//用GET方式请求数据
AJAX_OBJ.prototype.requestData = function(){
	var request_url = this.url + this.urlParameters;
	var self = this;
	this.xmlHttp.onreadystatechange = function(){
		self.stateChanged();
	};
	this.xmlHttp.open("GET", request_url, this.asyn);
	this.xmlHttp.send(null);
	
}
AJAX_OBJ.prototype.cancel = function(){
	this.xmlHttp.abort();
}

//用POST方式请求数据
AJAX_OBJ.prototype.requestDataPost = function() {
	var self = this;
	this.xmlHttp.onreadystatechange = function() {
		self.stateChanged();
	}
	this.xmlHttp.open("POST", this.url, this.asyn);
	//this.xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	//this.xmlHttp.setRequestHeader("Content-length", this.urlParameters.length);
	//this.xmlHttp.setRequestHeader("Connection", "close");
	this.xmlHttp.send(this.urlParameters);
	return 0;
}
//请求数据的处理
AJAX_OBJ.prototype.stateChanged = function(){
	var self=this;
	//iPanel.debug("this.xmlHttp.readyState =="+this.xmlHttp.readyState);
	//iPanel.debug("this.xmlHttp.status =="+this.xmlHttp.status);
	//iPanel.debug("this.timer == "+this.timer);
	if(this.xmlHttp.readyState == 2) this.timerout=window.setTimeout(function(){self.check()}, self.timer);
	if(this.xmlHttp.readyState == 4){
		if(this.xmlHttp.status == 200){
			window.clearTimeout(this.timerout);
			if(this.backParam == null) {
				var result = this.xmlHttp.responseText;
				if(result.indexOf("login")>-1){//session include login tag
					//window.location.href = "/epg/common/loginAgain.jsp?errorType=login";
					iPanel.mainFrame.location = "/zjg/common/loginAgain.jsp?errorType=login";
				}else if(result.indexOf("epgError")>-1){//session include epgError tag
					//iPanel.overlayFrame.location = "/zjg/common/loginAgain.jsp?errorType=epgError";
					//iPanel.overlayFrame.moveTo(0,0);
					//iPanel.overlayFrame.resizeTo(1280,720);
				}
				this.callback(this.xmlHttp);
			}
			else this.callback(this.xmlHttp,this.backParam);
		}
	}
}

AJAX_OBJ.prototype.check = function(){
	//iPanel.debug("this.xmlHttp.lastreadyState =="+this.xmlHttp.readyState);
	//iPanel.debug("this.xmlHttp.laststatus =="+this.xmlHttp.status);
	if(this.xmlHttp.readyState!=4||(this.xmlHttp.readyState==4&&this.xmlHttp.status!=200))
		this.errorhandle(this.xmlHttp.status);
}
//请求失败的处理
AJAX_OBJ.prototype.errorHandle = function(params){
	//iPanel.debug("请求失败"+this.url);
	
}
//参数的处理
AJAX_OBJ.prototype.addParameter = function(params,type){
	this.type =  typeof(type)=="undefined"?0:type;
	if(this.type == 0){
		if(params.length > 0){
			this.urlParameters = "";
			for(var i = 0; i < params.length; i++){
				var curr_param = params[i];
				if(i == 0) this.urlParameters += "?" + curr_param.name + "=" + curr_param.value;
				else this.urlParameters += "&" + curr_param.name + "=" + curr_param.value;
			}
		}
	}else if(this.type == 1){
		this.urlParameters = params;
	}
}

AJAX_OBJ.prototype.getText = function(){
	return this.xmlHttp.responseText;
}
//执行responseText
AJAX_OBJ.prototype.evalText = function(){
	return eval(this.xmlHttp.responseText);
}