package sitv.epg.zhangjiagang.bo;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class TestHttp {
    public static void main(String[] args) {
        try {
            StringBuffer sb = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            //<NavCheck clientId=”1” deviceId=”12345” smcId=”1234”/>           
//            sb.append("<GetUpsellOffer portalId=\"1\" client=\"8512402357000134\" account=\"wg001\" serviceId=\"CS_vod\" />");
            sb.append("<SelectionStart portalId=\"1\" client=\"8512402357000134\" account=\"wg001\" titleAssetId=\"MOVI2010000004175117\" serviceId=\"CS_vod\" />");
//            sb.append("<NavCheck client=\"8512402357000134\" deviceId=\"1\" portalId=\"1\" />");
//            sb.append("<ValidatePlayEligibility portalId=\"1\" client=\"8512402357000134\" account=\"wg001\" assetId=\"MOVI2010000004175117\" providerId=\"sitv\" serviceId=\"CS_vod\" isPreview=\"N\" />");
            System.out.println(sb);
            //sb.append("<recNum>2010</recNum>");
            //sb.append("</getvData>");
            byte[] xmlbyte = sb.toString().getBytes("UTF-8");
            URL url = new URL("http://10.0.253.163:8080/SelectionStart");
//            URL url = new URL("http://10.0.253.160:8080/ValidatePlayEligibility");
//            URL url = new URL("http://10.0.253.160:8080/NavCheck");
//            URL url = new URL("http://10.0.253.160:8080/GetUpsellOffer");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            DataOutputStream outStream = new DataOutputStream(conn.getOutputStream());
            outStream.write(xmlbyte);
            outStream.flush();
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuffer sb2 = new StringBuffer();
            String lines = "";
            while (null != (lines = in.readLine())) {
                sb2.append(lines);
            }
            System.out.println(sb2.toString());
            // in.read(b)
            in.close();
            outStream.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
