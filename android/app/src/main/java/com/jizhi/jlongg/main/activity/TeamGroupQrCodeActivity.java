package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Environment;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.QRCodeUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 班组、项目组二维码
 *
 * @author Xuj
 * @time 2016年9月7日 11:42:17
 * @Version 2.0
 */
public class TeamGroupQrCodeActivity extends BaseActivity implements View.OnClickListener {

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
     * 启动当前Acitivty
     *
     * @param context
     * @param groupName      项目组名称
     * @param groupId        项目组id
     * @param classType      项目组类型
     * @param membersHeadPic 头像
     */
    public static void actionStart(Activity context, String groupName, String groupId, String classType, List<String> membersHeadPic) {
        Intent intent = new Intent(context, TeamGroupQrCodeActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.GROUP_HEAD_IMAGE, (Serializable) membersHeadPic);
        intent.putExtra(Constance.CLASSTYPE, classType);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_teamgroup_aqcode);
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
        createQRCode(generateScanCodeForGroupTeam());
    }

    /**
     * 生成班组、群聊、项目组二维码地址
     *
     * @return
     */
    private String generateScanCodeForGroupTeam() {
        StringBuilder builder = new StringBuilder();
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        builder.append(NetWorkRequest.IP_ADDRESS + "v2/Qrcode/createQrCode?");
        builder.append("inviter_uid=" + UclientApplication.getUid(getApplicationContext()));//当前登录人UID
        builder.append("&time=" + System.currentTimeMillis() / 1000);
        builder.append("&class_type=" + classType);
        builder.append(classType.equals(WebSocketConstance.GROUP) || classType.equals(WebSocketConstance.GROUP_CHAT) ? "&group_id=" : "&team_id=");
        builder.append(getIntent().getStringExtra(Constance.GROUP_ID));
        return builder.toString();
    }

    private void initView() {
        scanCodeImage = getImageView(R.id.scan_code);
        getTextView(R.id.right_title).setText(R.string.save_photo);
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        TextView hintText = getTextView(R.id.hintText);
        switch (classType) {
            case WebSocketConstance.GROUP: //班组
                setTextTitle(R.string.group_scan_desc);
                hintText.setText(R.string.qrcode_hint_group);
                getTextView(R.id.group_name).setText(getIntent().getStringExtra(Constance.GROUP_NAME));
                break;
            case WebSocketConstance.TEAM: //项目组
                setTextTitle(R.string.team_scan_desc);
                hintText.setText(R.string.qrcode_hint_team);
                getTextView(R.id.group_name).setText(getIntent().getStringExtra(Constance.GROUP_NAME));
                break;
            case WebSocketConstance.GROUP_CHAT: //群聊
                setTextTitle(R.string.group_chat_scan);
                hintText.setText(R.string.qrcode_hint_group_chat);
                getTextView(R.id.group_name).setText(getIntent().getStringExtra(Constance.GROUP_NAME));
                break;
        }
        NineGroupChatGridImageView groupView = (NineGroupChatGridImageView) findViewById(R.id.groupIcon);
        List<String> listHead = (List<String>) getIntent().getSerializableExtra(Constance.GROUP_HEAD_IMAGE); //班组、讨论组、群聊头像
        groupView.setImagesData(listHead);
    }

    public void createQRCode(final String url) {
        scanCodeImageUrl = UtilFile.qRCodeDir() + "qr_" + System.currentTimeMillis() + ".jpg"; //图片保存路径
        //二维码图片较大时，生成图片、保存文件的时间可能较长，因此放在线程中来加载
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final boolean success = QRCodeUtil.createQRImage(url, 800, 800, false ? BitmapFactory.decodeResource(getResources(), R.drawable.launcher) : null, scanCodeImageUrl);
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
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case SAVE_PIC: //保存图片
                                CommonMethod.makeNoticeLong(getApplicationContext(), "已保存到手机相册", CommonMethod.SUCCESS);
                                if (isSave) {
                                    return;
                                }
                                if (takeScreenShotClip(TeamGroupQrCodeActivity.this)) {
                                    isSave = true;
                                }
//                                PicUtils.copyPicToDirection(getApplicationContext(), scanCodeImageUrl);
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
        }
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
     * 进行截取屏幕
     *
     * @param pActivity
     * @return
     */
    public Bitmap takeScreenShot(Activity pActivity) {
        Bitmap bitmap = null;
        View view = pActivity.getWindow().getDecorView();
//        View view = this.screentLayout;
        // 设置是否可以进行绘图缓存
        view.setDrawingCacheEnabled(true);
        // 如果绘图缓存无法，强制构建绘图缓存
        view.buildDrawingCache();
        // 返回这个缓存视图
        bitmap = view.getDrawingCache();
        // 获取状态栏高度
        Rect frame = new Rect();
        // 测量屏幕宽和高
        view.getWindowVisibleDisplayFrame(frame);
        int stautsHeight = frame.top + ((int) getResources().getDimension(R.dimen.head_height));
        int width = pActivity.getWindowManager().getDefaultDisplay().getWidth();
        int height = pActivity.getWindowManager().getDefaultDisplay().getHeight();
        // 根据坐标点和需要的宽和高创建bitmap
        bitmap = Bitmap.createBitmap(bitmap, 0, stautsHeight, width, height - stautsHeight);
        return bitmap;
    }

    /**
     * 保存图片到sdcard中
     *
     * @param pBitmap
     */
    private boolean savePic(Bitmap pBitmap, String strName) {
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(strName);
            if (null != fos) {
                pBitmap.compress(Bitmap.CompressFormat.PNG, 90, fos);
                fos.flush();
                fos.close();
                return true;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 截图
     *
     * @param pActivity
     * @return 截图并且保存sdcard成功返回true，否则返回false
     */
    public boolean takeScreenShotClip(Activity pActivity) {
        String directoryPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getAbsolutePath();
        File file = new File(directoryPath);
        if (!file.exists()) {
            file.mkdir();
        }
        return savePic(takeScreenShot(pActivity), file.getAbsolutePath() + File.separator + System.currentTimeMillis() + ".png");
    }
}