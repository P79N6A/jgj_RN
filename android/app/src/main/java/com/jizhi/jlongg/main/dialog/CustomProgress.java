package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.WindowManager;
import android.widget.LinearLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.jizhi.jlongg.R;

import pl.droidsonroids.gif.GifImageView;

public class CustomProgress extends Dialog {

    public CustomProgress(Context context) {
        super(context, R.style.Custom_Progress);
    }

    /**
     * 弹出自定义ProgressDialog
     *
     * @param context    上下文
     * @param message    提示
     * @param cancelable 是否按返回键取消
     * @return
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public CustomProgress show(final Context context, String message, boolean cancelable) {
        setContentView(R.layout.layout_progress_custom);

        WindowManager.LayoutParams lp = getWindow().getAttributes();
        lp.dimAmount = 0.0f;
        getWindow().setAttributes(lp);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);

        final GifImageView girView = (GifImageView) findViewById(R.id.ivGif);
        int width = DensityUtils.dp2px(context.getApplicationContext(), 65); //设置Gif的图片的宽和高
        int[] widthHeight = ImageUtils.getImageWidthHeight(context.getApplicationContext(), R.drawable.app_gif);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) girView.getLayoutParams();
        float widthScale = (float) width / (float) widthHeight[0];
        params.width = width;
        params.height = (int) (widthHeight[1] * widthScale);
        girView.setLayoutParams(params);
        //GifDrawable gifDrawable = (GifDrawable) gifImageView.getDrawable();
        //gifDrawable.start(); //开始播放
        //gifDrawable.stop(); //停止播放
        //gifDrawable.reset(); //复位，重新开始播放
        //gifDrawable.isRunning(); //是否正在播放
        //gifDrawable.setLoopCount( 2 ); //设置播放的次数，播放完了就自动停止
        //gifDrawable.getCurrentLoop()； //获取正在播放的次数
        //gifDrawable.getCurrentPosition ; //获取现在到从开始播放所经历的时间
        //gifDrawable.getDuration() ; //获取播放一次所需要的时间

        // 设置点击屏幕Dialog不消失
        setCanceledOnTouchOutside(false);
        setCancelable(cancelable);// 设置为false，按返回键不能退出。默认为true。
        show();
        return this;
    }

    public void closeDialog() {
        dismiss();
    }


}