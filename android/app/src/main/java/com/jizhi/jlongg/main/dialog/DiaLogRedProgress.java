package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jongg.widget.GifView;

/**
 * 功能:红色进度条
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogRedProgress extends Dialog {
    private DiaLogRedProgressSuccesss.OnLoadCompleteListener listener;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context, final String content) {
        setContentView(R.layout.red_progress);
        if (!TextUtils.isEmpty(content)) {
            ((TextView) findViewById(R.id.tv_content)).setText(content);
        }
        GifView gifView = (GifView) findViewById(R.id.gif_image);
        gifView.setPlayCompleteListener(new GifView.PlayGifCompleteListener() {
            @Override
            public void playComplete() {
                dismiss();
                if (TextUtils.isEmpty(content)) {
                    new DiaLogRedProgressSuccesss(context, listener).show();
                }
            }
        });
        gifView.setMovieResource(R.raw.red_progreedialog);
    }

    public DiaLogRedProgress(Activity context, DiaLogRedProgressSuccesss.OnLoadCompleteListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(context, null);
        commendAttribute(false);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}
