package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.jizhi.jlongg.R;


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
public class DialogLikeApp extends Dialog implements View.OnClickListener {


    /**
     *
     */
    private LikeAppListener likeAppListener;

    public DialogLikeApp(Activity context, LikeAppListener likeAppListener) {
        super(context, R.style.Custom_Progress);
        this.likeAppListener = likeAppListener;
        createLayout(context);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Context content) {
        setContentView(R.layout.dialog_like);
        scaleImageView(content);
        findViewById(R.id.toRecommend).setOnClickListener(this);
        findViewById(R.id.refuseIcon).setOnClickListener(this);
    }


    private void scaleImageView(Context context) {
        int[] widthHeight = ImageUtils.getImageWidthHeight(context, R.drawable.like_tan_kuang);
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

        advertisementImage.setImageResource(R.drawable.like_tan_kuang);


    }


    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.toRecommend: //去推荐
                if (likeAppListener != null) {
                    likeAppListener.toRecommend();
                }
                break;
            case R.id.refuseIcon: //拒绝按钮
                if (likeAppListener != null) {
                    likeAppListener.refuse();
                }
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


    public interface LikeAppListener {
        public void toRecommend(); //推荐

        public void refuse();//拒绝
    }

}