package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;

import com.hcs.uclient.utils.DensityUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 跟App相关的辅助类
 *
 * @author zhy
 */
public class MoneyUtils {

    public static Spannable setMoney(Context activity, String moneyDesc) {
        Pattern p = Pattern.compile("¥ ");
        if (!TextUtils.isEmpty(moneyDesc)) { //姓名不为空的时才进行模糊匹配
            Spannable spannable = new SpannableString(moneyDesc);
            Matcher nameMatch = p.matcher(moneyDesc);
            while (nameMatch.find()) {
                ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#eb4e4e"));
                spannable.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                spannable.setSpan(new AbsoluteSizeSpan(DensityUtils.dp2px(activity, 12)), nameMatch.start(), nameMatch.end(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            }
            return spannable;
        }
        return null;
    }
}
