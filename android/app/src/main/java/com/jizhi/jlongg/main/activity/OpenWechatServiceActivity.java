package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.zxing.client.android.scanner.QRCodeUtil;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WechatBean;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.DialogLogMore;
import com.jizhi.jlongg.main.dialog.DialogMore;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 开通微信服务
 */
public class OpenWechatServiceActivity extends BaseActivity implements View.OnClickListener {
    private OpenWechatServiceActivity mActivity;
    private ImageView qrcode;
    private Bitmap bitmap;
    /**
     * 当前微信绑定状态1：已经绑定  0：未绑定
     */
    private int wechatBindStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_open_wechat_service);
        SetTitleName.setTitle(findViewById(R.id.title), "开通微信服务");
        initView();


    }

    public void initView() {
        setTextTitleAndRight(R.string.open_service, R.string.more);
        qrcode = findViewById(R.id.img_qrcode);
        mActivity = OpenWechatServiceActivity.this;
        findViewById(R.id.btn_save).setOnClickListener(this);
//        ((TextView) findViewById(R.id.tv_hint)).setText(Html.fromHtml("如果不需要通过微信接收工作消息<br>点击<font color='#eb4e4e'><b><font size=20>关闭微信服务</font></b></font>即可"));
        wechatBindStatus = getIntent().getIntExtra(Constance.BEAN_INT, 0);
        findViewById(R.id.btn_receive).setOnClickListener(this);
        //没绑定就显示绑定界面，获取二维码
        if (wechatBindStatus == 0) {
            getWechatQrCode();
        }
        //设置绑定状态
        setWechatBindStatus();

    }

    @Override
    protected void onResume() {
        super.onResume();
        getWechatstatus();
    }

    /**
     * @param context
     * @param wechatBindStatus 当前微信绑定状态1：已经绑定  0：未绑定
     * @param isToWeb          true 网页跳转显示领取红包按钮  false 普通绑定
     */
    public static void actionStart(Activity context, int wechatBindStatus, boolean isToWeb) {
        Intent intent = new Intent(context, OpenWechatServiceActivity.class);
        intent.putExtra(Constance.BEAN_INT, wechatBindStatus);
        intent.putExtra(Constance.BEAN_BOOLEAN, isToWeb);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    public void createQRCode(final String url) {
        final String scanCodeImageUrl = UtilFile.qRCodeDir() + "qr_" + System.currentTimeMillis() + ".jpg"; //图片保存路径
        //二维码图片较大时，生成图片、保存文件的时间可能较长，因此放在线程中来加载
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final boolean success = QRCodeUtil.createQRImage(url, 800, 800, false ? BitmapFactory.decodeResource(getResources(), R.drawable.launcher) : null, scanCodeImageUrl);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (success) {
                            bitmap = BitmapFactory.decodeFile(scanCodeImageUrl);
                            qrcode.setImageBitmap(bitmap);
                        } else {
                            CommonMethod.makeNoticeLong(getApplicationContext(), "二维码获取失败!", CommonMethod.ERROR);
                        }
                    }
                });
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_save:
                if (Build.VERSION.SDK_INT >= 23) {
                    String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
                    ActivityCompat.requestPermissions(OpenWechatServiceActivity.this, mPermissionList, Constance.REQUEST_CAPTURE);
                } else {
                    saveImage();
                }
                break;
            case R.id.right_title:
                DialogMore dialogMore = new DialogMore(mActivity, DialogMore.getDeleteBean(), new DialogMore.DialogMoreInterFace() {
                    @Override
                    public void delete() {
                        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(mActivity, null, "解除绑定可能导致错过重要的工作信息和活动消息", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                            @Override
                            public void clickLeftBtnCallBack() {

                            }

                            @Override
                            public void clickRightBtnCallBack() {
                                getUnbindWechat();
                            }
                        });
                        dialogLeftRightBtnConfirm.setLeftBtnText("以后再说");
                        dialogLeftRightBtnConfirm.show();
                    }

                    @Override
                    public void success() {

                    }
                });
                dialogMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
                break;
            case R.id.btn_receive:
                Intent intent = new Intent();
                intent.putExtra(Constance.BEAN_INT, wechatBindStatus);
                setResult(Constance.OPEN_WECHAT_WERVICE, intent);
                finish();
                break;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {

        if (requestCode == Constance.REQUEST_CAPTURE) {
            saveImage();
        }
    }

    public void saveImage() {
        Bitmap bm = ((BitmapDrawable) qrcode.getDrawable()).getBitmap();
        if (null != bm) {
            boolean issave = Utils.saveBitmap(OpenWechatServiceActivity.this, bm);
            if (issave) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "已保存到手机相册", CommonMethod.SUCCESS);
            } else {
                CommonMethod.makeNoticeLong(getApplicationContext(), "保存失败", CommonMethod.SUCCESS);
            }
            openWeixinToQE_Code(OpenWechatServiceActivity.this);
        } else {
        }
    }

    /**
     * 打开微信并跳入到二维码扫描页面
     *
     * @param context
     */
    public void openWeixinToQE_Code(Context context) {
        try {
            CommonMethod.makeNoticeShort(getApplicationContext(), "打开微信扫一扫，点右上角【相册】选图扫码", CommonMethod.SUCCESS);
            Intent intent = context.getPackageManager().getLaunchIntentForPackage("com.tencent.mm");
            intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
            context.startActivity(intent);
        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), "无法跳转到微信，请检查是否安装了微信", Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * 微信二维码
     */
    public void getWechatQrCode() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.CREATE_WX_QRCODE, WechatBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                WechatBean wechatBean = (WechatBean) object;
                LUtils.e("url" + wechatBean.getUrl());
                if (!TextUtils.isEmpty(wechatBean.getUrl())) {
                    createQRCode(wechatBean.getUrl());
                } else {
                    CommonMethod.makeNoticeShort(mActivity, "微信二维码请求失败", CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
                CommonMethod.makeNoticeShort(mActivity, "微信二维码请求失败", CommonMethod.ERROR);
            }
        });
    }

    /**
     * 设置微信绑定状态
     */
    public void setWechatBindStatus() {
        if (wechatBindStatus == 0) {
            findViewById(R.id.layout_unbind).setVisibility(View.VISIBLE);
            findViewById(R.id.layout_bind).setVisibility(View.GONE);
            findViewById(R.id.right_title).setVisibility(View.GONE);
        } else {
            findViewById(R.id.layout_unbind).setVisibility(View.GONE);
            findViewById(R.id.layout_bind).setVisibility(View.VISIBLE);
            findViewById(R.id.right_title).setVisibility(View.VISIBLE);
            //网页跳转的显示领红包按钮
            if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                findViewById(R.id.tv_hint).setVisibility(View.GONE);
                findViewById(R.id.btn_receive).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.tv_hint).setVisibility(View.GONE);
                findViewById(R.id.btn_receive).setVisibility(View.GONE);
            }
        }
    }

    /**
     * 微信绑定状态
     */
    public void getWechatstatus() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.CREATE_WX_STATUS, WechatBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                WechatBean wechatBean = (WechatBean) object;
                wechatBindStatus = wechatBean.getStatus();
                setWechatBindStatus();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
                CommonMethod.makeNoticeShort(mActivity, "微信二维码请求失败", CommonMethod.ERROR);
            }
        });
    }

    /**
     * 解除微信绑定状态
     */
    public void getUnbindWechat() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_EX_UNBOND, WechatBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                wechatBindStatus = 0;
//                setWechatBindStatus();
                CommonMethod.makeNoticeShort(mActivity, "解绑成功", CommonMethod.SUCCESS);
                Intent intent = new Intent();
                intent.putExtra(Constance.BEAN_INT, wechatBindStatus);
                setResult(Constance.OPEN_WECHAT_WERVICE, intent);
                mActivity.finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();

            }
        });
    }

    @Override
    public void onFinish(View view) {
        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_INT, wechatBindStatus);
        setResult(Constance.OPEN_WECHAT_WERVICE, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_INT, wechatBindStatus);
        setResult(Constance.OPEN_WECHAT_WERVICE, intent);
        super.onBackPressed();
    }
}
