package com.jizhi.jlongg.screenshot;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ShareActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 作者    你的名字
 * 时间    2019-2-19 上午 11:51
 * 文件    MyTest
 * 描述
 */
public class ScreenShotView extends LinearLayout implements View.OnClickListener {
    /**
     * 本地截屏文件的url
     */
    private String imageUrl;
    private Context context;

    public ScreenShotView(Context context) {
        super(context);
        this.context = context;
        init(context);
    }

    public ScreenShotView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public ScreenShotView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }


    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.screenshot_dialog, this);
        findViewById(R.id.share_friend).setOnClickListener(this);
        findViewById(R.id.feed_back).setOnClickListener(this);
        findViewById(R.id.close_icon).setOnClickListener(this);
        findViewById(R.id.translate_view).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.share_friend: //分享好友
                LUtils.e("-11---------");
                ///storage/emulated/0/Pictures/Screenshots/S90220-180322.jpg
                if (TextUtils.isEmpty(imageUrl)) {
                    return;
                }
                Intent intent = new Intent(context.getApplicationContext(), ShareActivity.class);
                intent.putExtra(Constance.BEAN_STRING, imageUrl);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                ScreenShotManager.removeScreenShotView((Activity) getContext());
                break;
            case R.id.feed_back: //问题反馈
                LUtils.e("-11-----22----");
                if (TextUtils.isEmpty(imageUrl)) {
                    return;
                }
                intent = new Intent(context.getApplicationContext(), X5WebViewActivity.class);
                intent.putExtra("imageUrl", imageUrl);
                intent.putExtra("url", NetWorkRequest.FEEDBACK_POST);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                ScreenShotManager.removeScreenShotView((Activity) getContext());
//                fileUpData();
                break;
            case R.id.close_icon: //关闭按钮
            case R.id.translate_view: //透明view
                ScreenShotManager.removeScreenShotView((Activity) getContext());
                break;
        }
    }

    /**
     * 加载截屏图片
     *
     * @param imageUrl
     */
    public void loadScreenShotImage(String imageUrl) {
        this.imageUrl = imageUrl;
        int widthHeight = DensityUtil.dp2px(74);
        ImageView screenShotImageView = findViewById(R.id.screenshot_image);
        Glide.with(this).load(new File(imageUrl))
                .apply(RequestOptions.centerCropTransform().override(widthHeight, widthHeight).placeholder(droidninja.filepicker.R.drawable.image_placeholder))
                .into(screenShotImageView);
    }

    public void fileUpData() {
//        createCustomDialog();
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                RequestParams params = RequestParamsToken.getExpandRequestParams(context);
                List<String> localUploadList = new ArrayList<>();
                localUploadList.add(imageUrl);
                if (localUploadList.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, localUploadList, context);
                    upLoadImage(params);
                }

            }
        });
    }
//    public void closeDialog() {
//        if (null != customProgress && customProgress.isShowing()) {
//            customProgress.closeDialog();
//            customProgress = null;
//        }
//    }
//
//    public CustomProgress customProgress;
//
//    public void createCustomDialog() {
//        if (customProgress != null) {
//            customProgress.setMessage(null);
//        } else {
//            customProgress = new CustomProgress(context);
//            customProgress.show(context, null, false);
//        }
//    }

    /**
     * 上传图片
     */
    public void upLoadImage(RequestParams params) {
        String httpUrl = NetWorkRequest.UPLOAD_NEW;
        CommonHttpRequest.commonRequest(context, httpUrl, String.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
//                closeDialog();

                List<String> localUploadList = (ArrayList<String>) object;
                if (null != localUploadList && localUploadList.size() > 0) {
                    Intent intent = new Intent(context.getApplicationContext(), X5WebViewActivity.class);
                    intent.putExtra("imageUrl", localUploadList.get(0));
                    intent.putExtra("url", NetWorkRequest.FEEDBACK_POST + "?pic=" + localUploadList.get(0));
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    context.startActivity(intent);
                }


            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
//                closeDialog();
            }
        });
    }

}
