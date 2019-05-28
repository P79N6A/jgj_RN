package com.jizhi.jlongg.main.message;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.TextView;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SignAddressChangeActivity;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;
import com.tbruyelle.rxpermissions2.RxPermissions;

import java.util.ArrayList;
import java.util.List;

import io.reactivex.functions.Consumer;
import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * CName:签到
 * User: hcs
 * Date: 2016-04-21
 * Time: 16:55
 */
public class SigninActivity extends BaseActivity implements OnSquaredImageRemoveClick, View.OnClickListener {

    private SigninActivity mActivity;
    /**
     * 语音路径
     */
    public static final String VOICE_PATH = "VOICE_PATH";
    /**
     * 语音长度
     */
    public static final String VOICE_LENGTH = "VOICE_LENGTH";
    /**
     * 备注描述
     */
    public static final String REMARK_DESC = "REMARK_DESC";

    /***
     * 备注信息
     */
    @ViewInject(R.id.ed_remark)
    private EditText ed_remark;

    /**
     * 图片适配器
     */
    private SquaredImageAdapter adapter;
    /**
     * 时间
     */
    @ViewInject(R.id.tv_time)
    private TextView tv_time;
    /**
     * 地点
     */
    @ViewInject(R.id.tv_address1)
    private TextView tv_address;
    /**
     * 地点
     */
    @ViewInject(R.id.tv_address2)
    private TextView tv_address2;
    private int MAXPHOTOCOUNT = 9;
    private String addr1, addr2;
    // 地图相关
    private MapView mMapView;
    private BaiduMap mBaiduMap;

    //经度和纬度
    private double longitude, latitude;
    /* 图片数据 */
    private List<ImageItem> imageItems = new ArrayList<>();
    //存储拍照的图片
    private List<String> cameraList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_remarks);
        ViewUtils.inject(this);
        findViewById(R.id.tv_sign_change).setOnClickListener(this);
        findViewById(R.id.rea_photos).setVisibility(View.VISIBLE);
        initView();
        getPersimmions();
        initOrUpDateAdapter();

    }

    /**
     * 获取定位信息
     */
    public void getPersimmions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            /**
             * 定位权限为必须权限，用户如果禁止，则每次进入都会申请
             * 读写权限和电话状态权限非必要权限(建议授予)只会申请一次，用户同意或者禁止，只会弹一次
             */
            disposable = new RxPermissions(this).request(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE).subscribe(new Consumer<Boolean>() {
                @Override
                public void accept(Boolean granted) {
                    if (granted) {
                        //同意授权
                        initLoc();
                    } else {
                        //处理授权失败操作
                        LUtils.e("拒绝权限");
                    }
                }

            });
        } else {
            initLoc();

        }

    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String group_id, String class_type) {
        Intent intent = new Intent(context, SigninActivity.class);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.putExtra(Constance.CLASSTYPE, class_type);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = SigninActivity.this;
        setTextTitle(R.string.sign_in);
        // 地图初始化
        mMapView = (MapView) findViewById(R.id.bmapView);
        mMapView.showZoomControls(false);
        mBaiduMap = mMapView.getMap();
        mBaiduMap.getUiSettings().setAllGesturesEnabled(false);
        cameraList = new ArrayList<>();
        // 设置放大倍数
        MapStatus mStatus = new MapStatus.Builder().zoom(16).build();
        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mStatus);
        mBaiduMap.setMapStatus(mMapStatusUpdate);
        setBottomBtnText();
        Intent intent = getIntent();
        ed_remark.setText(intent.getStringExtra(REMARK_DESC));//获取备注信息
        tv_time.setText(TimesUtils.getHHMM());
        ed_remark.setHint("请描述一下今天的工作情况吧");

    }

    public void initMap(double x, double y) {
        mBaiduMap.clear();
        // 设置覆盖物
        LatLng ll = new LatLng(x, y);
        MapStatusUpdate u = MapStatusUpdateFactory.newLatLng(ll);
        mBaiduMap.animateMapStatus(u);
        // 设置坐标
        LatLng llA = new LatLng(x, y);
        BitmapDescriptor bd = BitmapDescriptorFactory
                .fromResource(R.drawable.icon_gcoding);
        OverlayOptions ooA = new MarkerOptions().position(llA).icon(bd)
                .zIndex(16);
        mBaiduMap.addOverlay(ooA);


    }

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = findViewById(R.id.gridView);
            adapter = new SquaredImageAdapter(this, this, imageItems, MAXPHOTOCOUNT);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    if (position == imageItems.size()) {
                        Acp.getInstance(mActivity).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                                , Manifest.permission.CAMERA)
                                        .build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        ArrayList<String> mSelected = selectedPhotoPath();
                                        CameraPop.multiSelector(mActivity, mSelected, MAXPHOTOCOUNT);
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });
                    } else {
                        PhotoZoomActivity.actionStart(mActivity, (ArrayList<ImageItem>) imageItems, position, false);
                    }
                }
            });
        } else {
            adapter.notifyDataSetChanged();
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        hideSoftKeyboard();
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        hideSoftKeyboard();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            String waterPic = data.getStringExtra(MultiImageSelectorActivity.EXTRA_CAMERA_FINISH);
            //拍照之后返回
            if (!TextUtils.isEmpty(waterPic)) {
                cameraList.add(waterPic);
            }
            imageItems = Utils.getImages(mSelected, cameraList);
            adapter.updateGridView(imageItems);
        } else if (requestCode == Constance.REQUESTCODE_LOCATION && resultCode == Constance.REQUEST) {//地点微调回调
            addr1 = data.getStringExtra("address1");
            addr2 = data.getStringExtra("address2");
            longitude = data.getDoubleExtra("longitude", longitude);
            latitude = data.getDoubleExtra("latitude", latitude);
            tv_address.setText(addr1);
            tv_address2.setText(addr2);
            initMap(latitude, longitude);
        }

    }

    private void setBottomBtnText() {
        Button nextBtn = getButton(R.id.red_btn);
        nextBtn.setText(getString(R.string.sign_in));
    }

    DiaLogRedLongProgress dialog;

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.red_btn: //下一步
                if (Utils.isFastDoubleClick()) {
                    return;
                }
                String text = tv_address.getText().toString().trim();
                if (text.equals("定位失败") || text.equals("正在定位")) {
                    CommonMethod.makeNoticeShort(mActivity, "定位失败,请进入系统【设置】中检查定位权限是否开启", CommonMethod.ERROR);
                    return;
                }
                if (null == dialog) {
                    dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.signing));
                }
                dialog.show();
                FileUpData();
                break;
            case R.id.tv_sign_change:
                SignAddressChangeActivity.actionStart(mActivity, addr2);
                break;
        }


    }

    RequestParams params;

    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                if (imageItems != null && imageItems.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoadWater(params, imageItems, mActivity);
                }
                Message message = Message.obtain();
                message.obj = params;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        });
        thread.start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    putSignIn();
                    break;
            }

        }
    };


    @Override
    public void remove(int position) {
        imageItems.remove(position);
        adapter.notifyDataSetChanged();
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);
        }
        return mSelected;
    }

    /**
     * 签到
     */
    public void putSignIn() {
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID) + "");
        params.addBodyParameter("class_type", getIntent().getStringExtra(Constance.CLASSTYPE) + "");
        params.addBodyParameter("sign_addr", TextUtils.isEmpty(addr1) ? "" : addr1);
        params.addBodyParameter("sign_addr2", TextUtils.isEmpty(addr2) ? "" : addr2);
        String remark_text = ed_remark.getText().toString().trim();
        params.addBodyParameter("sign_desc", TextUtils.isEmpty(remark_text) ? "" : remark_text);
        params.addBodyParameter("coordinate", longitude + "," + latitude);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SIGN_IN, MessageBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                SigninActivity.this.setResult(Constance.RESULTCODE_FINISH, new Intent());
                hideSoftKeyboard();
                //保存消息到本地
                NewMessageUtils.saveMessage((MessageBean) object, mActivity);
                CommonMethod.makeNoticeShort(SigninActivity.this, "签到成功", CommonMethod.SUCCESS);
                finish();
                if (null != dialog) {
                    dialog.dismissDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                if (null != dialog) {
                    dialog.dismissDialog();
                }

            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }


    @OnClick(R.id.tv_address)
    public void tv_address(View view) {
        String text = tv_address.getText().toString().trim();
        if (text.equals("定位失败")) {
            initLoc();
            tv_address.setText("正在定位");
        }
    }

    private MyLocationListenner myListener = new MyLocationListenner();
    private LocationClient mLocClient;

    public void initLoc() {
        mMapView.setVisibility(View.VISIBLE);
        mLocClient = new LocationClient(mActivity);
        mLocClient.registerLocationListener(myListener);
        LocationClientOption option = new LocationClientOption();
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setIsNeedLocationDescribe(true);
        option.setIsNeedLocationDescribe(true);
        option.setIsNeedLocationPoiList(true);
        option.setOpenGps(true);// 打开gps
        option.setCoorType("bd09ll"); // 设置坐标类型
        // option.setScanSpan(1000);
        option.setIsNeedAddress(true);
        mLocClient.setLocOption(option);
        mLocClient.start();
    }

    public class MyLocationListenner implements BDLocationListener {

        @Override
        public void onReceiveLocation(BDLocation location) {
            if (null != location && location.getLocType() != BDLocation.TypeServerError && null != location.getProvince() && !location.getProvince().equals("null")) {
                addr1 = location.getCity() + "" + location.getDistrict() + "" + location.getStreet();
                tv_address.setText(addr1);
                if (null != location.getLocationDescribe()) {
                    addr2 = location.getLocationDescribe();
                    tv_address2.setText(addr2);
                }
                latitude = location.getLatitude();
                longitude = location.getLongitude();
                initMap(latitude, longitude);
            } else {
                tv_address.setText("定位失败");
            }
            if (null != mLocClient) {
                mLocClient.stop();
            }
        }
    }
}
