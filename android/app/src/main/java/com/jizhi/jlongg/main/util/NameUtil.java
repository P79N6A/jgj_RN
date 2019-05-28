package com.jizhi.jlongg.main.util;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Administrator on 2017/8/17 0017.
 */

public class NameUtil {

    public static String setName(String name) {
        if (TextUtils.isEmpty(name)) {
            return name;
        }
        if (name.length() == 4) {
            return name;
        }
        if (name.length() > 3) {
            return name.substring(0, 3) + "...";
        }
        return name;
    }

    public static String setRemark(String name, int maxLength) {
        if (TextUtils.isEmpty(name)) {
            return name;
        }
        if (name.length() == maxLength) {
            return name;
        }
        if (name.length() > maxLength) {
            return name.substring(0, maxLength) + "...";
        }
        return name;
    }

    public static SpannableStringBuilder matchTextAndFillRed(String compelteString, String matchString) {
        Pattern p = Pattern.compile(matchString);
        if (!TextUtils.isEmpty(compelteString)) { //姓名不为空的时才进行模糊匹配
            SpannableStringBuilder builder = new SpannableStringBuilder(compelteString);
            Matcher nameMatch = p.matcher(compelteString);
            while (nameMatch.find()) {
                ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            }
            //大写转小写
            Matcher lowerCaseNameMatch = p.matcher(compelteString.toLowerCase());
            while (lowerCaseNameMatch.find()) {
                ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                builder.setSpan(redSpan, lowerCaseNameMatch.start(), lowerCaseNameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            }
            return builder;
        }
        return null;
    }
}
