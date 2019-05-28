package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.text.Html;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * 功能:
 * * 1、新用户从注册登录开始，使用10次后，第11次登录吉工家，弹推荐提示框（第一次弹框）
 * 2、第一次弹框后，用户登录使用15次后，第26次登录吉工家，弹推荐提示框（第二次弹框）
 * 3、第二次弹框后，用户登录使用20次后，第46次登录吉工家，弹推荐提示框（第三次弹框）
 * 4、第三次弹框后，用户每登录使用20次后，就弹推荐提示框（即66次、86次、106次登录时，弹框推荐提示框）
 * 5、点击【残忍滴拒绝】，页面回到吉工家首页
 * 6、点击【马上去推荐】，页面跳转到推荐给他人界面
 * 时间: 2018年6月21日14:48:32
 * 作者:xuj
 */
public class DialogNewUser extends Dialog implements View.OnClickListener {

    private Activity context;

    public DialogNewUser(Activity context) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        createLayout(context);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Context content) {
        setContentView(R.layout.dialog_new_user);
        scaleImageView(content);
        setDesc();
        findViewById(R.id.goNow).setOnClickListener(this);
    }

    private void setDesc() {
        TextView textView = (TextView) findViewById(R.id.text3);
        textView.setText(Html.fromHtml("<font color='#666666'>以后在</font><font color='#000000'>&nbsp;我&nbsp;→&nbsp;帮助中心&nbsp;</font><font color='#666666'>看</font>"));
    }

    private void scaleImageView(Context context) {
        int[] widthHeight = ImageUtils.getImageWidthHeight(context, R.drawable.helper_background);
        float imageWidth = widthHeight[0]; //默认Banner图片的宽度
        int imageHeight = widthHeight[1]; //默认Banner图片的高度

        RelativeLayout loadingLayout = (RelativeLayout) findViewById(R.id.rootView);

        int adPadding = DensityUtils.dp2px(context.getApplicationContext(), 80); //图片左右的间距
        int screenWidth = DensityUtils.getScreenWidth(context) - adPadding; //获取屏幕宽度
        float weight = screenWidth / imageWidth; //计算屏幕和服务器返回图片大小的百分比  放大或缩小
        ImageView advertisementImage = (ImageView) findViewById(R.id.advertisementImage);

        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) loadingLayout.getLayoutParams();
        params.width = (int) (weight * imageWidth);
        params.height = (int) (weight * imageHeight);
        loadingLayout.setLayoutParams(params);

        RelativeLayout.LayoutParams imageParams = (RelativeLayout.LayoutParams) advertisementImage.getLayoutParams();
        imageParams.width = params.width;
        imageParams.height = params.height;
        advertisementImage.setLayoutParams(imageParams);

        advertisementImage.setImageResource(R.drawable.helper_background);
    }


    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.goNow: //马上去看按钮
                String url = NetWorkRequest.WEBURLS + "help/hpDetail?id=-1";
                X5WebViewActivity.actionStart(context, url);
                break;
        }
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}