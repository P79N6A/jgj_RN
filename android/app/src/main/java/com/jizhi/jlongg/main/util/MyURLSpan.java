package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Context;
import android.text.style.ClickableSpan;
import android.view.View;

import com.jizhi.jlongg.main.activity.X5WebViewActivity;

/**
 * textview点击网页时候跳转回调
 */

public class MyURLSpan extends ClickableSpan {

    private String url;
    private Context context;

    public MyURLSpan(Context context, String url) {
        this.url = url;
        this.context = context;
    }

    @Override
    public void onClick(View arg0) {
        X5WebViewActivity.actionStart((Activity) context, url,true);
    }

}
