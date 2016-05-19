package sitv.epg.zhangjiagang.bo;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import net.sf.json.JSONArray;
import org.apache.axis.components.logger.LogFactory;
import org.apache.commons.digester.Digester;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.stereotype.Repository;

import sitv.epg.zhangjiagang.http.request.AuthRequest;
import sitv.epg.zhangjiagang.http.request.GetUpsellOfferRequest;
import sitv.epg.zhangjiagang.http.request.LoginRequest;
import sitv.epg.zhangjiagang.http.request.SelectionRequest;
import sitv.epg.zhangjiagang.http.response.AuthResponse;
import sitv.epg.zhangjiagang.http.response.GetUpsellOfferResponse;
import sitv.epg.zhangjiagang.http.response.LoginResponse;
import sitv.epg.zhangjiagang.http.response.NavServerResponse;
import sitv.epg.zhangjiagang.http.response.StartResponse;
import sitv.epg.zhangjiagang.http.response.ZoneFreqInfo;
import sitv.epg.config.EpgConfigUtils;

/**
 * 调用A7接口的客户端.
 * @author <a href="mailto:wang_k@sitv.com.cn">wangkai</a>
 */
@Repository
public class BoClient {

    private static final Log logger = LogFactory.getLog("boclient");
    
    private String loginUrl = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.LOGIN_URL);
    private String authUrl = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.AUTH_URL);
    private String selectionUrl = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.SELECTION_URL);
    private String getofferUrl = EpgConfigUtils.getInstance().getProperty(EpgConfigUtils.GETOFFER_URL);
    
	/**
     * @param LoginRequest
     *  返回LoginResponse
     */
    public LoginResponse login(LoginRequest request) throws Exception {
    	String response = post(request.getXML(), loginUrl);
    	if(StringUtils.isBlank(response)) {
            logger.error("login response is null.device_id=" + request.getDeviceId() + ", client=" + request.getClient());
            LoginResponse loginResponse = new LoginResponse();
            ZoneFreqInfo zoneFreqInfo = new ZoneFreqInfo();
            zoneFreqInfo.setFrequency("68200");
            zoneFreqInfo.setQamMode("6875");
            zoneFreqInfo.setSymbolRate("64QAM");
            loginResponse.setAccount("sitv");
            loginResponse.setZoneFreqInfo(zoneFreqInfo);
            return loginResponse;
            //throw new BoException("login error.",BoException.LOGIN_ERROR);
        }
    	NavServerResponse errorResponse = parserError(response);
    	if(errorResponse.getCode()!=null){
        	logger.error("error code:" + errorResponse.getCode());
        	LoginResponse loginResponse = new LoginResponse();
            ZoneFreqInfo zoneFreqInfo = new ZoneFreqInfo();
            zoneFreqInfo.setFrequency("68200");
            zoneFreqInfo.setQamMode("6875");
            zoneFreqInfo.setSymbolRate("64QAM");
            loginResponse.setAccount("sitv");
            loginResponse.setZoneFreqInfo(zoneFreqInfo);
            return loginResponse;
        	//throw new BoException("error message:" + errorResponse.getMessage(), errorResponse.getCode());
        }
    	/*StringBuffer result = new StringBuffer();
        result.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?><NavCheckResult account=\"12345\" customerGroup=\"12123\">");
    	result.append("<ZoneFreqInfo qamMode=\"1\" symbolRate=\"2\" frequence=\"3\" />");
    	result.append("</NavCheckResult>");
        result.toString();
        System.out.println(result);*/
    	LoginResponse loginResponse = parserLogin(response);
        return loginResponse;
    }
    /**
     * @param AuthRequest
     *  返回AuthResponse
     * @throws Exception 
     */
    public AuthResponse auth(AuthRequest request) throws Exception {
    	String response = post(request.getXML(), authUrl);
    	if(StringUtils.isBlank(response)) {
            logger.error("auth response is null.account=" + request.getAccount() + ", assetId=" + request.getAssetId() + ", providerId=" + request.getProviderId());
            throw new BoException("auth error.",BoException.AUTH_ERROR);
        }
    	NavServerResponse errorResponse = parserError(response);
    	if(errorResponse.getCode()!=null){
        	logger.error("error code:" + errorResponse.getCode());
        	throw new BoException("error message:" + errorResponse.getMessage(), errorResponse.getCode());
        }
    	/*String result = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><PlayEligibility  price=\"50\" orderFlag =\"Y\" />";
    	System.out.println(result);*/
    	AuthResponse authResponse = parserAuth(response);
    	return authResponse;
    }
    /**
     * @param SelectionRequest
     *  返回StartResponse
     */
    public StartResponse selection(SelectionRequest request) throws Exception {
    	String response = post(request.getXML(), selectionUrl);
    	if(StringUtils.isBlank(response)) {
            logger.error("selection response is null.account=" + request.getAccount() + ", client=" + request.getClient() + ", titleAssetId=" + request.getTitleAssetId());
            throw new BoException("selectionStart error.",BoException.SELECTION_ERROR);
        }
    	NavServerResponse errorResponse = parserError(response);
    	if(errorResponse.getCode()!=null){
        	logger.error("error code:" + errorResponse.getCode());
        	throw new BoException("error message:" + errorResponse.getMessage(), errorResponse.getCode());
        }
    	/*String result = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><StartResponse purchaseToken=\"1111111111\"></StartResponse>";
    	System.out.println(result);*/
    	StartResponse startResponse = parserSelection(response);
    	return startResponse;
    }
    /**
     * @param GetUpsellOfferRequest
     *  返回GetUpsellOfferResponse
     */
    public GetUpsellOfferResponse getOffer(GetUpsellOfferRequest request) throws Exception {
    	String response = post(request.getXML(), getofferUrl);
    	if(StringUtils.isBlank(response)) {
            logger.error("getoffer response is null.account=" + request.getAccount() + ", client=" + request.getClient() + ", serviceId=" + request.getServiceId());
            throw new BoException("getoffer error.",BoException.GETOFFER_ERROR);
        }
    	NavServerResponse errorResponse = parserError(response);
    	if(errorResponse.getCode()!=null){
        	logger.error("error code:" + errorResponse.getCode());
        	throw new BoException("error message:" + errorResponse.getMessage(), errorResponse.getCode());
        }
    	/*String result = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><StartResponse purchaseToken=\"1111111111\"></StartResponse>";
    	System.out.println(result);*/
    	GetUpsellOfferResponse getUpsellOfferResponse = parserGetOffer(response);
    	return getUpsellOfferResponse;
    }
    
    /**
     * @param LoginRequest
     *  返回ErrorResponse
     */
    public NavServerResponse error(LoginRequest request) throws Exception {
    	/*String response = post(request.getXML(), loginUrl);
    	if(StringUtils.isBlank(response)) {
            logger.error("login response is null.device_id=" + request.getDeviceId() + ", client=" + request.getClient());
            throw new BoException("login error.",BoException.LOGIN_ERROR);
        }*/
    	String result = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><NavServerResponse code=\"405\" message=\"该资产已经超过有效期\" />";
    	System.out.println(result);
    	NavServerResponse errorResponse = parserError(result);
        return errorResponse;
    }
    
    /**
     * @param xml
     * @param urlLocation
     * @return
     * @throws Exception
     */
    private String post(String xml, String urlLocation) throws Exception{
    	if(logger.isDebugEnabled()){
            logger.debug("url = " + urlLocation + "|xml = " + xml);
        }
        URL url = new URL(urlLocation);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setUseCaches(false);
        connection.setInstanceFollowRedirects(true);
        connection.setConnectTimeout(1000 * 5);
        connection.setRequestProperty("Content-Type", "textml;charset=UTF-8");
        connection.setRequestProperty("Connection", "Keep-Alive");// 维持长连接
        connection.setRequestProperty("Charset", "UTF-8");
        connection.setDoOutput(true);
        connection.setDoInput(true);
        StringBuffer body = new StringBuffer();
        OutputStream os = null;
        InputStream is = null;
        try {
            os = connection.getOutputStream();
            os.write(xml.getBytes("UTF-8"));
            os.flush();
            os.close();
            if (connection.getResponseCode() == 200) {
                String line = null;
                is = connection.getInputStream();
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        is, "UTF-8"));
                while ((line = br.readLine()) != null) {
                    body.append(line);
                }
                if(logger.isDebugEnabled()){
                    logger.debug(body.toString());
                }
                return body.toString();
            }
        } catch (Exception e) {
            logger.error("url or xml error,service url:" + urlLocation + "xml:"+xml, e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
            if (os != null) {
                os.close();
            }
            if (is != null) {
                is.close();
            }
        }
        return "";
    }
    
    /**
     * @param result
     *	解析XML NavCheck 开机认证
     */
    private LoginResponse parserLogin(String result) throws Exception {
        Digester digester = new Digester();
        LoginResponse loginResponse = new LoginResponse();
        digester.push(loginResponse);
        this.setLoginRule(digester);
        BufferedReader xml = new BufferedReader(new StringReader(result));
        try {
            digester.parse(xml);
        } catch (Exception e) {
        	logger.error("LoginResponse error,return response content is wrong.response is " + result);
            throw new BoException("login error:" + e.getMessage() + ".",BoException.LOGIN_ERROR);
        } finally {
            if (xml != null) {
                xml.close();
            }
            digester.clear();
        }
        return loginResponse;
    }
    /**
     * @param result
     *	解析XML ValidatePlayEligibility 权限校验
     */
    private AuthResponse parserAuth(String result) throws Exception {
        Digester digester = new Digester();
        AuthResponse authResponse = new AuthResponse();
        digester.push(authResponse);
        this.setAuthRule(digester);
        BufferedReader xml = new BufferedReader(new StringReader(result));
        try {
            digester.parse(xml);
        } catch (Exception e) {
        	logger.error("AuthResponse error,return response content is wrong.response is " + result);
            throw new BoException("auth error:" + e.getMessage() + ".",BoException.AUTH_ERROR);
        } finally {
            if (xml != null) {
                xml.close();
            }
            digester.clear();
        }
        return authResponse;
    }
    /**
     * @param result
     *	解析XML SelectionStart 播放请求
     */
    private StartResponse parserSelection(String result) throws Exception {
        Digester digester = new Digester();
        StartResponse startResponse = new StartResponse();
        digester.push(startResponse);
        this.setSelectionRule(digester);
        BufferedReader xml = new BufferedReader(new StringReader(result));
        try {
            digester.parse(xml);
        } catch (Exception e) {
        	logger.error("StartResponse error,return response content is wrong.response is " + result);
            throw new BoException("auth error:" + e.getMessage() + ".",BoException.SELECTION_ERROR);
        } finally {
            if (xml != null) {
                xml.close();
            }
            digester.clear();
        }
        return startResponse;
    }
    /**
     * @param result
     *	解析XML GetUpsellOfferResponse 商品价格信息
     */
    private GetUpsellOfferResponse parserGetOffer(String result) throws Exception {
        Digester digester = new Digester();
        GetUpsellOfferResponse getUpsellOfferResponse = new GetUpsellOfferResponse();
        digester.push(getUpsellOfferResponse);
        this.setGetOfferRule(digester);
        BufferedReader xml = new BufferedReader(new StringReader(result));
        try {
            digester.parse(xml);
        } catch (Exception e) {
        	logger.error("GetUpsellOfferResponse error,return response content is wrong.response is " + result);
            throw new BoException("getOffer error:" + e.getMessage() + ".",BoException.GETOFFER_ERROR);
        } finally {
            if (xml != null) {
                xml.close();
            }
            digester.clear();
        }
        return getUpsellOfferResponse;
    }
    /**
     * @param result
     *	解析XML Error 错误信息
     */
    private NavServerResponse parserError(String result) throws Exception {
        Digester digester = new Digester();
        NavServerResponse navServerResponse = new NavServerResponse();
        digester.push(navServerResponse);
        this.setErrorRule(digester);
        BufferedReader xml = new BufferedReader(new StringReader(result));
        try {
            digester.parse(xml);
        } catch (Exception e) {
        } finally {
            if (xml != null) {
                xml.close();
            }
            digester.clear();
        }
        return navServerResponse;
    }
    /**
     * @param digester
     *	NavCheck 开机认证
     */
    private void setLoginRule(Digester digester) {
    	digester.addSetProperties("NavCheckResult", "account", "account");
    	digester.addSetProperties("NavCheckResult", "customerGroup", "customerGroup");
    	digester.addSetNext("account", "setAccount");
    	digester.addSetNext("customerGroup", "setCustomerGroup");
        digester.addObjectCreate("NavCheckResult/ZoneFreqInfo", ZoneFreqInfo.class);
        digester.addSetProperties("NavCheckResult/ZoneFreqInfo", "qamMode", "qamMode");
        digester.addSetProperties("NavCheckResult/ZoneFreqInfo", "symbolRate", "symbolRate");
        digester.addSetProperties("NavCheckResult/ZoneFreqInfo", "frequence", "frequence");
        digester.addSetNext("NavCheckResult/ZoneFreqInfo", "setZoneFreqInfo");
    }
    
    /**
     * @param digester
     *	ValidatePlayEligibility 权限校验
     */
    private void setAuthRule(Digester digester) {
    	digester.addSetProperties("PlayEligibility", "price", "price");
    	digester.addSetProperties("PlayEligibility", "orderFlag", "orderFlag");
    	digester.addSetProperties("PlayEligibility", "newRental", "newRental");
    	digester.addSetProperties("PlayEligibility", "rentalExpiration", "rentalExpiration");
    	digester.addSetProperties("PlayEligibility", "previewAssetId", "previewAssetId");
    	digester.addSetNext("price", "setPrice");
    	digester.addSetNext("orderFlag", "setOrderFlag");
    	digester.addSetNext("newRental", "setNewRental");
    	digester.addSetNext("rentalExpiration", "setRentalExpiration");
    	digester.addSetNext("previewAssetId", "setPreviewAssetId");
    }
    
    /**
     * @param digester
     *	SelectionStart 播放请求
     */
    private void setSelectionRule(Digester digester) {
    	digester.addSetProperties("StartResponse", "purchaseToken", "purchaseToken");
    	digester.addSetProperties("StartResponse", "previewAssetId", "previewAssetId");
    	digester.addSetNext("purchaseToken", "setPurchaseToken");
    	digester.addSetNext("previewAssetId", "setPreviewAssetId");
    }
    
    /**
     * @param digester
     *	GetUpsellOffer 商品价格信息
     */
    private void setGetOfferRule(Digester digester) {
    	digester.addSetProperties("UpsellOffer", "serviceId", "serviceId");
    	digester.addSetProperties("UpsellOffer", "title", "title");
    	digester.addSetProperties("UpsellOffer", "displayPrice", "displayPrice");
    	digester.addSetProperties("UpsellOffer", "displayText", "displayText");
    	digester.addSetNext("serviceId", "setServiceId");
    	digester.addSetNext("title", "setTitle");
    	digester.addSetNext("displayPrice", "setDisplayPrice");
    	digester.addSetNext("displayText", "setDisplayText");
    }
    
    /**
     * @param digester
     *	Error 错误信息
     */
    private void setErrorRule(Digester digester) {
    	digester.addSetProperties("NavServerResponse", "code", "code");
    	digester.addSetProperties("NavServerResponse", "message", "message");
    	digester.addSetNext("code", "setCode");
    	digester.addSetNext("message", "setMessage");
    }
    

    public static void main(String[] args) throws Exception{
        BoClient colent = new BoClient();
//        GetUpsellOfferRequest g = new GetUpsellOfferRequest();
//        g.setAccount("wg001");
//        g.setClient("8512402357000134");
//        g.setPortalId("1");
//        g.setServiceId("CS_vod");
//    	AuthRequest a = new AuthRequest();
//        a.setAssetId("MOVI2010000004175117");
//        a.setAccount("wg005");
//        a.setPortalId("1");
//        a.setClient("8512402357000219");//8512402357000219 8512402357000134
//        a.setProviderId("sitv");
//        a.setServiceId("CS_vod");
//        a.setIsPreview("N");
        LoginRequest l = new LoginRequest();
        l.setClient("8512402504479199");
        l.setPortalId("1");
        l.setDeviceId("11111111");
//        SelectionRequest s = new SelectionRequest();
//        s.setAccount("wg001");
//        s.setClient("8512402357000134");
//        s.setPortalId("1");
//        s.setTitleAssetId("MOVI2010000004175117");
//        s.setServiceId("CS_vod");
        System.out.println(l.getXML());
//        StartResponse ss = colent.selection(s);
        LoginResponse ll = colent.login(l);
//        AuthResponse aa = colent.auth(a);
        //NavServerResponse ll = colent.error(l);
//        GetUpsellOfferResponse gg = colent.getOffer(g);
        try {
        	//StartResponse ss = colent.selection(s);
            JSONArray param = JSONArray.fromObject(ll);
            System.out.println(param.toString());
            System.out.println(ll.getZoneFreqInfo().getFrequency());
//            System.out.println(gg.getDisplayPrice());
//            System.out.print(gg.getTitle());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
