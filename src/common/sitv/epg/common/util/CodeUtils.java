package sitv.epg.common.util;
/*
 * Copyright (c) 2007 by Chances.
 * $CVSHeader: IPTV_VAS_Release1/src/commons/chances/vas/commons/utils/CodeUtils.java,v 1.1 2008/04/17 02:23:14 chenxx Exp $
 * $Author: chenxx $
 * $Date: 2008/04/17 02:23:14 $
 * $Revision: 1.1 $
 */


import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;

/**
 * 编码统一生成器.
 * 
 * @author <a href="mailto:chenxx@chances.com.cn">chenxx</a>
 */
public class CodeUtils {

    private static final int DEFAULT_NUM_LEN = 8;

    private static final Map<String, Integer> times = new HashMap<String, Integer>();

    /**
     * 生成以类名开头的编码.
     * 
     * @param clazz
     *            类
     * @return
     */
    public static String generate(final Object entity) {
        return generate(entity, DEFAULT_NUM_LEN);
    }

    /**
     * 生成以类名开头的编码.
     * 
     * @param entity
     *            类
     * @param numLen
     *            后缀数字字符串长度
     * @return
     */
    public static String generate(final Object entity, final int numLen) {
        synchronized (entity) {
            StringBuffer code = new StringBuffer(entity.getClass()
                    .getSimpleName().toLowerCase());
            code.append("_");
            code.append(RandomStringUtils.randomNumeric(numLen));
            return code.toString();
        }
    }

    public static String createDateSerialNo() {
        synchronized (times) {
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
            String result = df.format(calendar.getTime());
            int count = 1;
            if (null != times.get(result)) {
                count = ((Integer) times.get(result)).intValue();
                count++;
            }
            NumberFormat nFormat = NumberFormat.getNumberInstance();
            nFormat.setMinimumIntegerDigits(3);
            nFormat.setMaximumFractionDigits(0);
            times.put(result, count);
            return result + nFormat.format(count);
        }
    }

}
