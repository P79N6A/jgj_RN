package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Picture;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow;

import com.google.gson.Gson;
import com.google.zxing.client.android.scanner.QRCodeUtil;
import com.hcs.uclient.utils.BitmapUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.tencent.smtt.sdk.WebView;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMWeb;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 面对面分享痰喘
 */
public class CustomFaceToFaceDialog extends BaseActivity implements View.OnClickListener {


    private Activity activity;
//    /* popview */
//    private View popView;


    public static void actionStartActivity(Activity activity, String url) {

        Intent intent = new Intent(activity, CustomShareDialog.class);
        intent.putExtra(Constance.BEAN_STRING, url);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_share_facetoface);
        initView(getIntent().getStringExtra(Constance.BEAN_STRING));
    }


    private void initView(String url) {
        findViewById(R.id.tv_calcel).setOnClickListener(this);
        findViewById(R.id.rea_top).setOnClickListener(this);
        findViewById(R.id.lin_bottom).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        createQRCode(url);

    }

    public void createQRCode(final String url) {
        LUtils.e("------url-----------" + url);

        final String scanCodeImageUrl = UtilFile.qRCodeDir() + "qr_" + System.currentTimeMillis() + ".jpg"; //图片保存路径
        //二维码图片较大时，生成图片、保存文件的时间可能较长，因此放在线程中来加载
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final boolean success = QRCodeUtil.createQRImage(url, 800, 800, false ? BitmapFactory.decodeResource(activity.getResources(), R.drawable.launcher) : null, scanCodeImageUrl);
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (success) {
                            ((ImageView) findViewById(R.id.img_qrcode)).setImageBitmap(BitmapFactory.decodeFile(scanCodeImageUrl));
                        } else {
                            CommonMethod.makeNoticeLong(activity, "二维码获取失败!", CommonMethod.ERROR);
                        }
                    }
                });
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {

            case R.id.tv_calcel: //取消
                finish();
                break;

        }
        finish();
    }

}
