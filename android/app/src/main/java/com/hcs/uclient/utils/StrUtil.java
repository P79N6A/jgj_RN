package com.hcs.uclient.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class StrUtil {
    /**
     * 按钮点击间隔时间
     */
    private static long lastClickTime;

    /**
     * 判断内容是否为空
     *
     * @param obj
     * @return
     */
    public static boolean isNull(String... obj) {
        for (String s : obj) {
            if (s == null || "".equals(s)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 判断是否是手机号
     *
     * @param num
     * @return
     */
    public static boolean isMobileNum(String num) {
        Pattern p = Pattern.compile("^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$");
        Matcher m = p.matcher(num);
        return m.matches();
    }

    /**
     * 判断是否为邮箱
     */
    public static boolean checkEmail(String email) {

        String check = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
        Pattern regex = Pattern.compile(check);
        Matcher matcher = regex.matcher(email);
        boolean isMatched = matcher.matches();
        return isMatched;

    }

    /**
     * 判断是否为身份证号码
     *
     * @param str
     * @return
     */
    public static boolean isIDCcard(String str) {
        Pattern pattern = Pattern.compile("([0-9]{17}([0-9]|X))|([0-9]{15})");
        return pattern.matcher(str).matches();
    }

    /**
     * 防止按钮重复点击
     *
     * @return
     */
    public static boolean isFastDoubleClick() {
        long time = System.currentTimeMillis();
        if (time - lastClickTime < 1000) {
            return true;
        }
        lastClickTime = time;
        return false;
    }

    /**
     * 防止按钮重复点击
     *
     * @return
     */
    public static boolean isFastDoubleClick300() {
        long time = System.currentTimeMillis();
        if (time - lastClickTime < 100) {
            return true;
        }
        lastClickTime = time;
        return false;
    }

    /**
     * 字符串首字母出现，其他的为*
     */
    public static String retainInitial(String str) {
        String string = "";
        if (("").equals(str)) {
            return "";
        } else {
            string = str.substring(0, 1);
            for (int i = 0; i < str.length() - 1; i++) {
                string += "*";
            }
        }
        return string;
    }

    /**
     * 判定输入汉字
     *
     * @param c
     * @return
     */

    public static boolean isChinese(char c) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
        return ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS;
    }

    /**
     * 检测String是否全是中文
     *
     * @param name
     * @return
     */
    public static boolean checkNameChese(String name) {
        boolean res = true;
        char[] cTemp = name.toCharArray();
        for (int i = 0; i < name.length(); i++) {
            if (!isChinese(cTemp[i])) {
                res = false;
                break;
            }
        }
        return res;
    }

    /**
     * 替换、过滤特殊字符*
     *
     * @param str
     * @return
     * @throws PatternSyntaxException
     */
    public static String StringFilter(String str) throws PatternSyntaxException {
        str = str.replaceAll("【", "[").replaceAll("】", "]").replaceAll("！", "!");// 将中文字符替换成英文字符
        String regEx = "[『』]"; // 清除掉特殊字符
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);
        return m.replaceAll("").trim();
    }

    /**
     * 字符全角化。即将所有的数字、字母及标点全部转为全角字符，使它们与汉字同占两个字节
     *
     * @param input
     * @return
     */
    public static String ToDBC(String input) {
        char[] c = input.toCharArray();
        for (int i = 0; i < c.length; i++) {
            if (c[i] == 12288) {
                c[i] = (char) 32;
                continue;
            }
            if (c[i] > 65280 && c[i] < 65375)
                c[i] = (char) (c[i] - 65248);
        }
        return new String(c);
    }
}
