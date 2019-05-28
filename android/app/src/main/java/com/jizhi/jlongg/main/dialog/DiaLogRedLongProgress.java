package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jongg.widget.LongGifView;


/**
 * 功能:红色进度条
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogRedLongProgress extends Dialog {
    private LongGifView gifView;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context, final String content) {
        setContentView(R.layout.red_progress_long);
        if (!TextUtils.isEmpty(content)) {
            ((TextView) findViewById(R.id.tv_content)).setText(content);
        }
        gifView = (LongGifView) findViewById(R.id.gif_image);
        gifView.setIsplay(true);
        gifView.setPlayCompleteListener(new LongGifView.PlayGifCompleteListener() {
            @Override
            public void playComplete() {
                dismiss();
            }
        });
        gifView.setMovieResource(R.raw.red_progreedialog);
    }



    public void dismissDialog() {
        gifView.setIsplay(false);
//        dismiss();
    }

    public DiaLogRedLongProgress(Activity context, String content) {
        super(context, R.style.Custom_Progress);
        createLayout(context, content);
        commendAttribute(false);
        setCancelable(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}
