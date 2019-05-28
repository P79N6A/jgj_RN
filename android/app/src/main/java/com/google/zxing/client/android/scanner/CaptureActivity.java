package com.google.zxing.client.android.scanner;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.ChecksumException;
import com.google.zxing.DecodeHintType;
import com.google.zxing.FormatException;
import com.google.zxing.NotFoundException;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.Result;
import com.google.zxing.client.android.scanner.camera.CameraManager;
import com.google.zxing.client.android.scanner.decode.CaptureActivityHandler;
import com.google.zxing.client.android.scanner.view.ViewfinderView;
import com.google.zxing.client.result.ResultParser;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.QRCodeReader;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.ScanCodeAddTeamGroupActivity;
import com.jizhi.jlongg.main.activity.ScanLoginActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.ScanCode;
import com.jizhi.jlongg.main.dialog.DialogScanFail;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * 功能: 扫描二维码界面
 * 作者：huchangsheng
 * 时间: 2016-08-16 16:34
 */
public final class CaptureActivity extends BaseActivity implements SurfaceHolder.Callback, View.OnClickListener {
    private static final String TAG = CaptureActivity.class.getSimpleName();
    private static final int REQUEST_CODE = 100;
    private static final int PARSE_BARCODE_FAIL = 300;
    private static final int PARSE_BARCODE_SUC = 200;


    /**
     * 是否有预览
     */
    private boolean hasSurface;

    /**
     * 活动监控器。如果手机没有连接电源线，那么当相机开启后如果一直处于不被使用状态则该服务会将当前activity关闭。
     * 活动监控器全程监控扫描活跃状态，与CaptureActivity生命周期相同.每一次扫描过后都会重置该监控，即重新倒计时。
     */
    private InactivityTimer inactivityTimer;

//    /**
//     * 声音震动管理器。如果扫描成功后可以播放一段音频，也可以震动提醒，可以通过配置来决定扫描成功后的行为。
//     */
//    private BeepManager beepManager;

    /**
     * 闪光灯调节器。自动检测环境光线强弱并决定是否开启闪光灯
     */
    private AmbientLightManager ambientLightManager;

    private CameraManager cameraManager;
    /**
     * 扫描区域
     */
    private ViewfinderView viewfinderView;

    private CaptureActivityHandler handler;

    private Result lastResult;
    /**
     * 【辅助解码的参数(用作MultiFormatReader的参数)】 编码类型，该参数告诉扫描器采用何种编码方式解码，即EAN-13，QR
     * Code等等 对应于DecodeHintType.POSSIBLE_FORMATS类型
     * 参考DecodeThread构造函数中如下代码：hints.put(DecodeHintType.POSSIBLE_FORMATS,
     * decodeFormats);
     */
    private Collection<BarcodeFormat> decodeFormats;
    /**
     * 【辅助解码的参数(用作MultiFormatReader的参数)】 该参数最终会传入MultiFormatReader，
     * 上面的decodeFormats和characterSet最终会先加入到decodeHints中 最终被设置到MultiFormatReader中
     * 参考DecodeHandler构造器中如下代码：multiFormatReader.setHints(hints);
     */
    private Map<DecodeHintType, ?> decodeHints;

    /**
     * 【辅助解码的参数(用作MultiFormatReader的参数)】 字符集，告诉扫描器该以何种字符集进行解码
     * 对应于DecodeHintType.CHARACTER_SET类型
     * 参考DecodeThread构造器如下代码：hints.put(DecodeHintType.CHARACTER_SET,
     * characterSet);
     */
    private String characterSet;
    private Result savedResultToShow;
    private IntentSource source;

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, CaptureActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        setContentView(R.layout.activity_scanner_qr);
        setTextTitleAndRight(R.string.scanner_title, R.string.album);
        hasSurface = false;
        inactivityTimer = new InactivityTimer(this);
//        beepManager = new BeepManager(this);
        ambientLightManager = new AmbientLightManager(this);

    }

    protected void onResume() {
        super.onResume();

        // 相机初始化的动作需要开启相机并测量屏幕大小
        cameraManager = new CameraManager(getApplication());
        viewfinderView = (ViewfinderView) findViewById(R.id.capture_viewfinder_view);
        viewfinderView.setCameraManager(cameraManager);
        handler = null;
        lastResult = null;
        SurfaceView surfaceView = (SurfaceView) findViewById(R.id.capture_preview_view); // 预览
        SurfaceHolder surfaceHolder = surfaceView.getHolder();
        if (hasSurface) {
            initCamera(surfaceHolder);
        } else {
            // 防止sdk8的设备初始化预览异常
            surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
            surfaceHolder.addCallback(this);
        }

        // 加载声音配置，其实在BeemManager的构造器中也会调用该方法，即在onCreate的时候会调用一次
//        beepManager.updatePrefs();
        // 启动闪光灯调节器
        ambientLightManager.start(cameraManager);
        // 恢复活动监控器
        inactivityTimer.onResume();

        source = IntentSource.NONE;
        decodeFormats = null;
        characterSet = null;
    }

    @Override
    protected void onPause() {
        if (handler != null) {
            handler.quitSynchronously();
            handler = null;
        }
        inactivityTimer.onPause();
        ambientLightManager.stop();
//        beepManager.close();

        // 关闭摄像头
        cameraManager.closeDriver();
        if (!hasSurface) {
            SurfaceView surfaceView = (SurfaceView) findViewById(R.id.capture_preview_view);
            SurfaceHolder surfaceHolder = surfaceView.getHolder();
            surfaceHolder.removeCallback(this);
        }
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        inactivityTimer.shutdown();
        super.onDestroy();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                if ((source == IntentSource.NONE) && lastResult != null) { // 重新进行扫描
                    restartPreviewAfterDelay(0L);
                    return true;
                }
                break;
            case KeyEvent.KEYCODE_FOCUS:
            case KeyEvent.KEYCODE_CAMERA:
                return true;
            case KeyEvent.KEYCODE_VOLUME_UP:
                cameraManager.zoomIn();
                return true;
            case KeyEvent.KEYCODE_VOLUME_DOWN:
                cameraManager.zoomOut();
                return true;

        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        if (holder == null) {
            Log.e(TAG, "*** WARNING *** surfaceCreated() gave us a null surface!");
        }
        if (!hasSurface) {
            hasSurface = true;
            initCamera(holder);
        }
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        hasSurface = false;
    }

    /**
     * 扫描成功回调
     *
     * @param rawResult   The contents of the barcode. 条形码的内容
     * @param scaleFactor amount by which thumbnail was scaled 缩略图的缩放量
     * @param barcode     A greyscale bitmap of the camera data which was decoded. 被解码的相机数据灰度位图。
     */
    public void handleDecode(Result rawResult, Bitmap barcode, float scaleFactor) {
        inactivityTimer.onActivity();   // 重新计时
        lastResult = rawResult;
//        beepManager.playBeepSoundAndVibrate();
        String scanResultUrl = ResultParser.parseResult(rawResult).toString();
        handlerResult(scanResultUrl);
    }

    public void restartPreviewAfterDelay(long delayMS) {
        if (handler != null) {
            handler.sendEmptyMessageDelayed(R.id.restart_preview, delayMS);
        }
        resetStatusView();
    }

    public ViewfinderView getViewfinderView() {
        return viewfinderView;
    }

    public Handler getHandler() {
        return handler;
    }

    public CameraManager getCameraManager() {
        return cameraManager;
    }

    private void resetStatusView() {
        viewfinderView.setVisibility(View.VISIBLE);
        lastResult = null;
    }

    public void drawViewfinder() {
        viewfinderView.drawViewfinder();
    }

    private SurfaceHolder surfaceHolders;

    private void initCamera(final SurfaceHolder surfaceHolder) {
        if (surfaceHolder == null) {
            throw new IllegalStateException("No SurfaceHolder provided");
        }

        if (cameraManager.isOpen()) {
            Log.w(TAG, "initCamera() while already open -- late SurfaceView callback?");
            return;
        }
        Acp.getInstance(CaptureActivity.this).request(new AcpOptions.Builder()
                        .setPermissions(Manifest.permission.CAMERA)
                        .build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                        openDriver(surfaceHolder);
                        surfaceHolders = surfaceHolder;
                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        CommonMethod.makeNoticeShort(CaptureActivity.this, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });
    }

    private void openDriver(SurfaceHolder surfaceHolder) {
        try {
            cameraManager.openDriver(surfaceHolder);
            if (handler == null) {
                handler = new CaptureActivityHandler(this, decodeFormats, decodeHints, characterSet, cameraManager);
            }
            decodeOrStoreSavedBitmap(null, null);
        } catch (Exception ioe) {
            ioe.printStackTrace();
            displayFrameworkBugMessageAndExit();
        }
    }


    /**
     * 检测权限之后的回调
     *
     * @param requestCode
     * @param permissions
     * @param grantResults
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case Constance.CHECKSELFPERMISSION:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //用户同意授权
                    openDriver(surfaceHolders);
                } else {
                    //用户拒绝授权
                    CaptureActivity.this.finish();
                }
                break;
        }
    }

    /**
     * 向CaptureActivityHandler中发送消息，并展示扫描到的图像
     *
     * @param bitmap
     * @param result
     */
    private void decodeOrStoreSavedBitmap(Bitmap bitmap, Result result) {
        if (handler == null) {
            savedResultToShow = result;
        } else {
            if (result != null) {
                savedResultToShow = result;
            }
            if (savedResultToShow != null) {
                Message message = Message.obtain(handler, R.id.decode_succeeded, savedResultToShow);
                handler.sendMessage(message);
            }
            savedResultToShow = null;
        }
    }

    private void displayFrameworkBugMessageAndExit() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(getString(R.string.app_name));
        builder.setMessage(getString(R.string.msg_camera_framework_bug));
        builder.setPositiveButton(R.string.button_ok, new FinishListener(this));
        builder.setOnCancelListener(new FinishListener(this));
        builder.show();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_GROUP_CHAT) { //添加人员成功
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {//点击单聊
            setResult(resultCode, data);
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //加入班组、项目组、群聊
            setResult(resultCode, data);
            finish();
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) { //选择相册的回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            if (mSelected == null || mSelected.size() == 0 || mSelected.size() > 1) { //选中的图片有误
                return;
            }
            Result result = decodeBarcodeRGB(mSelected.get(0));
            if (result != null) {
                handlerResult(result.getText());
            } else {
                new DialogScanFail(this).show(); //扫描失败的弹出框
            }
        }
    }

    @Override
    public void onClick(View view) {
        CameraPop.singleSelector(this, null);//选择相册
    }

    /**
     * 处理扫描的结果
     *
     * @param url 扫描的url
     */
    private void handlerResult(String url) {
        LUtils.e("url:" + url);
        if (!TextUtils.isEmpty(url) && url.contains(NetWorkRequest.API_DOMAIN) || url.contains(NetWorkRequest.WEB_DOMAIN)) {
            if (url.contains("equipment")) { //设备管理扫描二维码
                Intent intent = getIntent();
                intent.putExtra("url", url);
                setResult(Constance.SCAN_CODE_JUMP_DEVICE, intent);
                finish();
                return;
            } else if (url.contains("meeting")) { //扫描到会议
                Intent intent = getIntent();
                intent.putExtra("url", url);
                setResult(Constance.SCAN_MEETING_SUCCESS, intent);
                finish();
                return;
            }
            String uid = null;
            String parameters = url.substring(url.indexOf("?") + 1);
            ScanCode bean = new ScanCode();
            String[] parameter = parameters.split("&");
            for (String s : parameter) {
                String[] keyValues = s.split("=");
                String key = keyValues[0];
                String value = keyValues[1];
                if (key.equals("qrcode_token")) { //扫码登录
                    ScanLoginActivity.actionStart(CaptureActivity.this, value);
                    finish();
                    return;
                } else if (key.equals("inviter_uid")) { //邀请者id
                    bean.setInviter_uid(value);
                } else if (key.equals("time")) {
                    bean.setTime(value);
                } else if (key.equals("class_type")) {
                    bean.setClass_type(value);
                } else if (key.equals("group_id")) {
                    bean.setGroup_id(value);
                } else if (key.equals("team_id")) {
                    bean.setTeam_id(value);
                } else if (key.equals("uid")) {
                    uid = value;
                }
            }
            if (!TextUtils.isEmpty(bean.getClass_type())) {
                switch (bean.getClass_type()) {
                    case WebSocketConstance.GROUP: //班组
                    case WebSocketConstance.GROUP_CHAT: //群聊
                    case WebSocketConstance.TEAM: //项目组
                        ScanCodeAddTeamGroupActivity.actionStart(this, bean);
                        break;
                    case MessageType.MESSAGE_TYPE_ADD_FRIEND: //添加好友扫描
                        ChatUserInfoActivity.actionStart(this, uid);
                        break;
                }
            } else {
                if (isWebUrl(url)) {
                    X5WebViewActivity.actionStart(this, url);
                    finish();
                }
            }
        } else {
            if (isWebUrl(url)) {
                X5WebViewActivity.actionStart(this, url);
                finish();
            } else {
                new DialogScanFail(this).show();
//                CommonMethod.makeNoticeShort(this, getString(R.string.scan_error), CommonMethod.ERROR);
            }
        }
    }


    private boolean isWebUrl(String url) {
        String regex = "^([hH][tT]{2}[pP]:/*|[hH][tT]{2}[pP][sS]:/*|[fF][tT][pP]:/*)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+(\\?{0,1}(([A-Za-z0-9-~]+\\={0,1})([A-Za-z0-9-~]*)\\&{0,1})*)$";
        Pattern pattern = Pattern.compile(regex);
        if (pattern.matcher(url).matches()) { //跳转到url
            return true;
        }
        return false;
    }


    /**
     * 解析二维码（使用解析RGB编码数据的方式）
     *
     * @param path
     * @return
     */
    public static Result decodeBarcodeRGB(String path) {
        if (TextUtils.isEmpty(path)) {
            return null;
        }
        BitmapFactory.Options opts = new BitmapFactory.Options();
        opts.inSampleSize = 1;
        Bitmap barcode = BitmapFactory.decodeFile(path, opts);
        Result result = decodeBarcodeRGB(barcode);
        barcode.recycle();
        barcode = null;
        return result;
    }

    /**
     * 解析二维码 （使用解析RGB编码数据的方式）
     *
     * @param barcode
     * @return
     */
    public static Result decodeBarcodeRGB(Bitmap barcode) {
        int width = barcode.getWidth();
        int height = barcode.getHeight();
        int[] data = new int[width * height];
        barcode.getPixels(data, 0, width, 0, 0, width, height);
        RGBLuminanceSource source = new RGBLuminanceSource(width, height, data);
        BinaryBitmap bitmap1 = new BinaryBitmap(new HybridBinarizer(source));
        QRCodeReader reader = new QRCodeReader();
        Result result = null;
        try {
            result = reader.decode(bitmap1);
        } catch (NotFoundException e) {
            e.printStackTrace();
        } catch (ChecksumException e) {
            e.printStackTrace();
        } catch (FormatException e) {
            e.printStackTrace();
        }
        barcode.recycle();
        barcode = null;
        return result;
    }
}
