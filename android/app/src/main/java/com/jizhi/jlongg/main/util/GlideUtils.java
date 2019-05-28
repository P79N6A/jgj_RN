package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.widget.ImageView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.GlideApp;

public class GlideUtils {
    public void glideImage(Context context, String url, ImageView imageView) {
        GlideApp.with(context).load(url).into(imageView);

    }

    public void glideImage(Context context, String url, ImageView imageView, int defaultImage, int errorImage) {
        GlideApp.with(context).load(url).placeholder(defaultImage).error(errorImage).into(imageView);

    }
}
