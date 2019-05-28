package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.QRCodeUtil;
import com.hcs.uclient.utils.ImageUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * 班组、项目组二维码
 *
 * @author Xuj
 * @time 2016年9月7日 11:42:17
 * @Version 2.0
 */
public class MyScanQrCodeActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 二维码图片
     */
    private ImageView scanCodeImage;
    /**
     * 二维码图片地址
     */
    private String scanCodeImageUrl;
    /**
     * 保存二维码图片
     */
    private final String SAVE_PIC = "1"; //保存图片
    /**
     * 取消保存
     */
    private final String CANCEL = "2"; //取消
    /**
     * 是否已保存图片
     */
    private boolean isSave;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param realName  用户名称
     * @param headImage 用户头像
     */
    public static void actionStart(Activity context, String realName, String headImage) {
        Intent intent = new Intent(context, MyScanQrCodeActivity.class);
        intent.putExtra(Constance.USERNAME, realName); //我的名称
        intent.putExtra(Constance.HEAD_IMAGE, headImage);//我的头像
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_scan_qr_code);
        requestPermission();
    }


    private void requestPermission() {
        Acp.getInstance(this).request(new AcpOptions.Builder().setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE).build(),
                new AcpListener() {
                    @Override
                    public void onGranted() { //权限已开启
                        init();
                    }

                    @Override
                    public void onDenied(List<String> permissions) { //权限未开启
                        //已经禁止提示了
                        CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });
    }

    private void init() {
        initView();
    }

    /**
     * 生成我的二维码地址
     *
     * @return
     */
    private String generateScanCodeForMe() {
        String realName = UclientApplication.getRealName(getApplicationContext()); //当前登录人姓名
        String nickName = UclientApplication.getNickName(getApplicationContext()); //当前登录人昵称
        StringBuilder builder = new StringBuilder();
        builder.append(NetWorkRequest.WEBURLS + "page/business-card.html?");
        builder.append("uid=" + UclientApplication.getUid(getApplicationContext()));//当前登录人UID
        builder.append("&time=" + System.currentTimeMillis() / 1000);
        builder.append("&pic=" + UclientApplication.getHeadPic(getApplicationContext()));
        builder.append("&name=" + (!TextUtils.isEmpty(nickName) ? nickName : realName));
        builder.append("&class_type=addFriend");
        builder.append("&plat=person");
        return builder.toString();
    }

    private void initView() {
        setTextTitle(R.string.my_scan_code_title);
        scanCodeImage = getImageView(R.id.scan_code);
        getTextView(R.id.right_title).setText(R.string.save_photo);

        TextView userNameText = getTextView(R.id.userName); //我的名称
        RoundeImageHashCodeTextLayout myIcon = findViewById(R.id.ownIcon);

        Intent intent = getIntent();
        String headPic = intent.getStringExtra(Constance.HEAD_IMAGE);
        String userName = intent.getStringExtra(Constance.USERNAME);
        myIcon.setView(headPic, userName, 0);
        userNameText.setText(userName); //设置我的名称


        final View rootView = findViewById(R.id.rootView);
        rootView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
            @Override
            public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                ImageView backgroundImage = getImageView(R.id.background); //图片背景
                View backgroundLayout = findViewById(R.id.backgroundLayout);
                int resourceDrawable = getRandomImageBackground();

                int[] widthHeight = ImageUtils.getImageWidthHeight(getApplicationContext(), resourceDrawable); //获取背景图片的宽和高
                int imageWidth = widthHeight[0]; //图片宽
                int imageHeight = widthHeight[1]; //图片高

                //取大的压缩比 如果取小的话 那么可能会造成图片宽或 高缩放比不够
                float weight = Math.max(backgroundLayout.getWidth() * 1.0f / imageWidth, backgroundLayout.getHeight() * 1.0f / imageHeight);

                RelativeLayout.LayoutParams backgroundParams = (RelativeLayout.LayoutParams) backgroundImage.getLayoutParams();
                backgroundParams.width = (int) (imageWidth * weight);
                backgroundParams.height = (int) (imageHeight * weight);
                backgroundImage.setLayoutParams(backgroundParams);
                backgroundImage.setImageResource(resourceDrawable);

                //二维码图片设置宽高为背景图片的四分之三
                int scanCodeWidthHeight = (int) ((Math.max(backgroundParams.width, backgroundParams.height)) * 0.7);
                RelativeLayout.LayoutParams scanCodeImageLayoutParams = (RelativeLayout.LayoutParams) scanCodeImage.getLayoutParams();
                scanCodeImageLayoutParams.width = scanCodeWidthHeight;
                scanCodeImageLayoutParams.height = scanCodeWidthHeight;
                scanCodeImage.setLayoutParams(scanCodeImageLayoutParams);

                createQRCode(generateScanCodeForMe(), scanCodeImageLayoutParams.width, scanCodeImageLayoutParams.height);
                if (Build.VERSION.SDK_INT < 16) {
                    rootView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    rootView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }

    public void createQRCode(final String url, final int width, final int height) {
        scanCodeImageUrl = UtilFile.qRCodeDir() + "qr_" + System.currentTimeMillis() + ".jpg"; //图片保存路径
        //二维码图片较大时，生成图片、保存文件的时间可能较长，因此放在线程中来加载
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final boolean success = QRCodeUtil.createQRImage(url, width, height, false ? BitmapFactory.decodeResource(getResources(), R.drawable.launcher) : null, scanCodeImageUrl);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (success) {
                            scanCodeImage.setImageBitmap(BitmapFactory.decodeFile(scanCodeImageUrl));
                        } else {
                            CommonMethod.makeNoticeLong(getApplicationContext(), "二维码获取失败!", CommonMethod.ERROR);
                            finish();
                        }

                    }
                });
            }
        });
    }

    public List<SingleSelected> getItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected("保存图片", false, true, SAVE_PIC));
        list.add(new SingleSelected("取消", false, false, CANCEL, Color.parseColor("#999999")));
        return list;
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.right_title:
                if (Build.VERSION.SDK_INT >= 23) {
                    String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
                    ActivityCompat.requestPermissions(MyScanQrCodeActivity.this, mPermissionList, Constance.REQUEST_CAPTURE);
                } else {
                    showShareDialog();
                }
                break;
        }
    }

    /**
     * 权限
     */
    public void showShareDialog() {
        CustomShareDialog dialog = new CustomShareDialog(MyScanQrCodeActivity.this, false, new Share());
        dialog.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
        BackGroundUtil.backgroundAlpha(MyScanQrCodeActivity.this, 0.5F);
    }

    //所有权限申请完成
    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        showShareDialog();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        File destDir = new File(UtilFile.QRIMAGEPATH);// 文件目录
        if (destDir.exists()) {// 判断目录是否存在，不存在创建
            UtilFile.RecursionDeleteFile(destDir);
        }
    }

    /**
     * 获取随机生成的背景图
     *
     * @return
     */
    private int getRandomImageBackground() {
        Random random = new Random();
        int position = random.nextInt(3);
        LUtils.e("position:" + position);
        switch (position) {
            case 0:
                return R.drawable.scan_code_background1;
            case 1:
                return R.drawable.scan_code_background2;
            case 2:
                return R.drawable.scan_code_background3;
            case 3:
                return R.drawable.scan_code_background4;
            default:
                return R.drawable.scan_code_background4;
        }
    }

}