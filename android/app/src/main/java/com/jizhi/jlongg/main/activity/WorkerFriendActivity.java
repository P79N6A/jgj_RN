//package com.jizhi.jlongg.main.activity;
//
//import android.annotation.SuppressLint;
//import android.annotation.TargetApi;
//import android.content.Intent;
//import android.database.Cursor;
//import android.net.Uri;
//import android.os.Build;
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Message;
//import android.provider.MediaStore;
//import android.text.TextUtils;
//import android.util.Base64;
//import android.view.Gravity;
//import android.view.KeyEvent;
//import android.view.View;
//import android.webkit.JavascriptInterface;
//import android.widget.ImageView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.bean.Share;
//import com.jizhi.jlongg.main.dialog.CustomShareDialog;
//import com.jizhi.jlongg.main.util.BackGroundUtil;
//import com.jizhi.jlongg.main.util.CameraPop;
//import com.jizhi.jlongg.main.util.CommonMethod;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.MyWebViewClient;
//import com.jizhi.jlongg.main.util.WebUitils;
//import com.jizhi.jlongg.network.NetWorkRequest;
//import com.jizhi.jongg.widget.LJWebView;
//import com.lidroid.xutils.ViewUtils;
//
//import java.io.ByteArrayOutputStream;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.IOException;
//import java.util.ArrayList;
//
//import me.nereo.multi_image_selector.MultiImageSelectorActivity;
//
///**
// * @author ${lpei}
// * @version 1.0 * SuppressLint一定要加上去！！！ 低版本可能没问题，高版本JS铁定调不了Android里面的方法
// * @time 2016/3/17 17:04
// */
//@SuppressLint({"SetJavaScriptEnabled", "JavascriptInterface"})
//public class WorkerFriendActivity extends BaseActivity implements MyWebViewClient.LoadEndingListener {
//
//
//    public LJWebView webView;
//    private RelativeLayout rea_webfail;
//    private WorkerFriendActivity mActivity;
//    private TextView tv_title;
//    private MyWebViewClient myWebViewClient;
//    private RelativeLayout layout_title;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.layout_friend);
//        ViewUtils.inject(this);
//        initView();
//        WebUitils uitils = new WebUitils(webView);
//        uitils.initWebView();
//        uitils.synCookies(mActivity, NetWorkRequest.FRIENDWORK);
//        String url = getIntent().getStringExtra("url");
//        webView.loadUrl(url);
//        myWebViewClient = new MyWebViewClient(url, this, rea_webfail, this);
//        webView.setWebViewClient(myWebViewClient);
//        myWebViewClient.setTv_title(tv_title);
//        webView.getmWebView().addJavascriptInterface(this, "jsPhone");
//    }
//
//    private void initView() {
//        mActivity = WorkerFriendActivity.this;
//        webView = (LJWebView) findViewById(R.id.webview);
//        rea_webfail = (RelativeLayout) findViewById(R.id.rea_webfail);
//        tv_title = (TextView) findViewById(R.id.title);
//        tv_title.setText("");
//        webView.setTv_title(tv_title);
//        ImageView btn_refresh = (ImageView) findViewById(R.id.btn_refresh);
//        layout_title = (RelativeLayout) findViewById(R.id.layout_title);
//        webView.setLayout_title(layout_title);
//        btn_refresh.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                webView.getmWebView().reload();
//            }
//        });
//    }
//
//    private ArrayList<String> mSelectPath;
//
//    @JavascriptInterface
//    public void choicePhoto() {
//        CameraPop.singleSelector(this, mSelectPath);
//    }
//
//    // 分享
//    @JavascriptInterface
//    public void fork(String img, String desc, String title, String url) {
//        if (TextUtils.isEmpty(title)) {
//            title = "吉工家";
//        }
//        final Share shareBean = new Share();
//        // 图标 描述 标题 url
//        shareBean.setWxshare_img(img);
//        shareBean.setWxshare_desc(desc);
//        shareBean.setWxshare_title(title);
//        shareBean.setWxshare_uri(url);
//        mActivity.runOnUiThread(new Runnable() {
//            @Override
//            public void run() {
//                CustomShareDialog dialog = new CustomShareDialog(mActivity, true, shareBean);
//                //显示窗口
//                dialog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//                BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
//            }
//        });
//
//    }
//
//    // 举报消息
//    @JavascriptInterface
//    public void reportMsg(String msgId) {
//        Intent intent = new Intent(mActivity, ReportActivity.class);
//        intent.putExtra(Constance.PID, Integer.parseInt(msgId));
//        startActivity(intent);
//    }
//
//    // 举报个人
//    @JavascriptInterface
//    public void reportPerson(String uid) {
////        getReportList("person", Integer.parseInt(uid));
////        startActivity(new Intent(mActivity, ReportActivity.class));
//        Intent intent = new Intent(mActivity, ReportActivity.class);
//        intent.putExtra(Constance.PID, Integer.parseInt(uid));
//        startActivity(intent);
//    }
//
//    Handler Handler = new Handler();
//
//    @JavascriptInterface
//    public void backToHomePage() {
//        Handler.post(new Runnable() {
//            @Override
//            public void run() {
//                webView.getmWebView().goBack();
//            }
//        });
//    }
//
//    @Override
//    public void loadEnding(String url) {
//
//    }
//
//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (keyCode == KeyEvent.KEYCODE_BACK && webView.getmWebView().canGoBack()) {
//            webView.getmWebView().goBack();
//            return true;
//        }
//
//        return super.onKeyDown(keyCode, event);
//    }
//
//    public void onFinish(View view) {
//        if (webView.getmWebView().canGoBack()) { //工友 资讯 是否能回退上一个页面
//            webView.getmWebView().goBack(); //回退WebView
//        } else {
//            mActivity.finish();
//        }
//    }
//
//
//    private final int REQUEST_IMAGE = 2;
//
//    @SuppressWarnings("static-access")
//    @Override
//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (requestCode == REQUEST_IMAGE) {
//            if (resultCode == RESULT_OK) {
//                mSelectPath = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//                upPic(mSelectPath.get(0));
//            }
//        }
//    }
//
//    public void compressionPic(String paths) {
//        if (paths.length() < 7) {
//            CommonMethod.makeNoticeShort(mActivity, "照片获取失败", CommonMethod.ERROR);
//            return;
//        }
//        String img_path;
//        if (paths.substring(0, 7).equals("file://")) {
//            img_path = paths.replace("file://", "");
//        } else {
//            Uri uri = Uri.parse(paths);
//            String[] proj = {MediaStore.Images.Media.DATA};
//            Cursor actualimagecursor = mActivity.getContentResolver().query(uri, proj, null, null, null);
//            int actual_image_column_index = actualimagecursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
//            actualimagecursor.moveToFirst();
//            img_path = actualimagecursor.getString(actual_image_column_index);
//        }
//        upPic(img_path);
//    }
//
//    private final int UPLOAD_PICTURE = 0;
//    private final int LOADING = 1;
//    private final int LOADING_ERROR = 2;
//    private String base64Str = null;
//    private String endStr = null;
//
//    public Handler mHandler = new Handler() {
//            switch (msg.what) {
//                case UPLOAD_PICTURE: //上传图片
//                    closeDialog();
//                    String script = String.format("javascript:getPhotoStream('" + base64Str + "','" + endStr + "')");
//                    webView.loadUrl("javascript:getPhotoStream('" + base64Str + "','" + endStr + "')");
//                    break;
//                case LOADING: //加载对话框
//                    setString_for_dialog("图片加载中!");
//                    createCustomDialog();
//                    break;
//                case LOADING_ERROR: //图片加载失败
//                    CommonMethod.makeNoticeLong(mActivity, "图片加载失败", CommonMethod.ERROR);
//                    break;
//                default:
//                    break;
//            }
//        }
//    };
//
//
//    @TargetApi(Build.VERSION_CODES.ECLAIR_MR1)
//    @SuppressLint("NewApi")
//    private void upPic(final String img_path) {
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                mHandler.sendEmptyMessage(LOADING);
//                File file = new File(img_path);
//                int dot = file.getName().lastIndexOf('.');
//                if (dot != -1) {
//                    endStr = file.getName().substring(dot + 1);
//                    base64Str = Bitmap2StrByBase64(file);
//                    mHandler.sendEmptyMessage(UPLOAD_PICTURE);
//                } else {
//                    mHandler.sendEmptyMessage(LOADING_ERROR);
//                }
//            }
//        }).start();
//    }
//
//    public String Bitmap2StrByBase64(File file) {
//        ByteArrayOutputStream bos = new ByteArrayOutputStream();
//        FileInputStream input = null;
//        byte[] by = new byte[1024];
//        try {
//            input = new FileInputStream(file);
//            int len = -1;
//            while ((len = input.read(by)) != -1) {
//                bos.write(by, 0, len);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            by = bos.toByteArray();
//            if (input != null) {
//                try {
//                    input.close();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//            try {
//                bos.close();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//        return Base64.encodeToString(by, Base64.DEFAULT);
//    }
//}
