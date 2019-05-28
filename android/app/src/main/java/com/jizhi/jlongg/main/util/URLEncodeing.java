//package com.jizhi.jlongg.main.util;
//
//import java.io.UnsupportedEncodingException;
//import java.net.URLDecoder;
//import java.net.URLEncoder;
//
//public class URLEncodeing {
//
//    /**
//     * URLEncoder编码
//     */
//    public static String toURLEncoded(String paramString) {
//        if (paramString == null || paramString.equals("")) {
//            return "";
//        }
//        try {
//            String str = new String(paramString.getBytes(), "UTF-8");
//            str = URLEncoder.encode(str, "UTF-8");
//            return str;
//        } catch (Exception localException) {
//        }
//        return "";
//    }
//
//    /**
//     * URLDecoder解码
//     */
//    public static String toURLDecoder(String paramString) {
//        if (paramString == null || paramString.equals("")) {
//            return "";
//        }
//        try {
//            String url = new String(paramString.getBytes(), "UTF-8");
//            url = URLDecoder.decode(url, "UTF-8");
//            return url;
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//        return "";
//    }
//}
//
