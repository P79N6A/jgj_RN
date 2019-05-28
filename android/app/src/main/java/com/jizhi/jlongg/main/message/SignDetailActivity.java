package com.jizhi.jlongg.main.message;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.GridView;
import android.widget.TextView;

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
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapterSign;
import com.jizhi.jlongg.main.adpter.PhotoGridAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.Sign;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MediaManager;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:签到详情
 * User: hcs
 * Date: 2016-04-21
 * Time: 16:55
 */
public class SignDetailActivity extends BaseActivity implements OnSquaredImageRemoveClick {

    private SignDetailActivity mActivity;
    /**
     * 图片适配器
     */
    private AccountPhotoGridAdapterSign adapter;
    /**
     * 时间
     */
    @ViewInject(R.id.tv_time)
    private TextView tv_time;

    private int MAXPHOTOCOUNT = 9;
    // 地图相关
    private MapView mMapView;
    private BaiduMap mBaiduMap;

    private String signRecordDetaill = "signRecordDetaill";


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        LUtils.e("签到详情");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_remarks);
        ViewUtils.inject(this);
        initView();
        registerReceiver();
        findViewById(R.id.bottom_layout).setVisibility(View.GONE);
        getSignData(getIntent().getStringExtra(Constance.sign_id));


    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = SignDetailActivity.this;
        setTextTitle(R.string.sign_in_detail);
        // 地图初始化
        mMapView = (MapView) findViewById(R.id.bmapView);
        mMapView.showZoomControls(false);
        mBaiduMap = mMapView.getMap();
        mBaiduMap.getUiSettings().setAllGesturesEnabled(false);
        // 设置放大倍数
        MapStatus mStatus = new MapStatus.Builder().zoom(16).build();
        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mStatus);
        mBaiduMap.setMapStatus(mMapStatusUpdate);
        tv_time.setText(TimesUtils.getHHMM());

    }

    public void initMap(double x, double y) {
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        MediaManager.release();
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }


    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(MessageType.MSG_SIGNIN_STRING);
        filter.addAction(signRecordDetaill);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }


    @Override
    public void remove(int position) {
    }

    /**
     * 获取签到详情
     *
     * @param sign_id
     */
    public void getSignData(String sign_id) {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setClass_type("manage");
            msgParmeter.setCtrl("team");
            msgParmeter.setAction(signRecordDetaill);
            msgParmeter.setSign_id(sign_id);
            webSocket.requestServerMessage(msgParmeter);
        }

    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(signRecordDetaill)) {//签到回执
                Sign bean = (Sign) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                tv_time.setText(bean.getSign_time());
                ((TextView) findViewById(R.id.tv_address)).setText(bean.getSign_addr() + "\n" + bean.getSign_addr2());
                if (!TextUtils.isEmpty(bean.getCoordinate())) {
                    mMapView.setVisibility(View.VISIBLE);
                    String[] coordinate = bean.getCoordinate().split(",");
                    double latitude = Double.parseDouble(coordinate[0]);
                    double longitude = Double.parseDouble(coordinate[1]);
                    initMap(longitude, latitude);

                } else {
                    mMapView.setVisibility(View.GONE);
                }
                if (!TextUtils.isEmpty(bean.getSign_desc())) {
                    ((TextView) findViewById(R.id.tv_remark)).setText(bean.getSign_desc());
                    (findViewById(R.id.rea_edmark)).setVisibility(View.VISIBLE);
                } else {
                    (findViewById(R.id.rea_edmark)).setVisibility(View.GONE);
                }
                if (null != bean.getSign_pic() && bean.getSign_pic().size() > 0) {
                    (findViewById(R.id.rea_photos)).setVisibility(View.VISIBLE);
                    List<ImageItem> tempList = new ArrayList<>();
                    for (String localpath : bean.getSign_pic()) {
                        ImageItem item = new ImageItem();
                        item.imagePath = localpath;
                        item.isNetPicture = true;
                        tempList.add(item);
                    }
                    GridView gridView = (GridView) findViewById(R.id.gridView);
                    gridView.setAdapter(new PhotoGridAdapter(SignDetailActivity.this, tempList));
                } else {
                    (findViewById(R.id.rea_photos)).setVisibility(View.GONE);
                }
            }


        }
    }

    @Override
    protected void onStart() {
        super.onStart();
    }
}
