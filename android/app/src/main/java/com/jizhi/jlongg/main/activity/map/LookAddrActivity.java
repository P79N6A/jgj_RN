package com.jizhi.jlongg.main.activity.map;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
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
import com.baidu.mapapi.navi.BaiduMapAppNotSupportNaviException;
import com.baidu.mapapi.navi.BaiduMapNavigation;
import com.baidu.mapapi.navi.IllegalNaviArgumentException;
import com.baidu.mapapi.navi.NaviParaOption;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.GroupManagerActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.service.MyLoctionService;

public class LookAddrActivity extends BaseActivity {
    // 地图相关
    private MapView mMapView;
    private BaiduMap mBaiduMap;

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, String location) {
        Intent intent = new Intent(context, LookAddrActivity.class);
        intent.putExtra("params", location);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.map);
        initView();
        String[] loc = getIntent().getStringExtra("params").split(",");
        if (loc.length != 2) {
            LookAddrActivity.this.finish();
        }
        final String x = loc[1];
        final String y = loc[0];

        LUtils.e(x + "------location----------" + y);
        // 地图初始化
        mMapView.showZoomControls(false);
        mBaiduMap = mMapView.getMap();
        // 设置覆盖物
        LatLng ll = new LatLng(Float.parseFloat(x), Float.parseFloat(y));
        MapStatusUpdate u = MapStatusUpdateFactory.newLatLng(ll);
        mBaiduMap.animateMapStatus(u);
        // 设置坐标
        LatLng llA = new LatLng(Float.parseFloat(x), Float.parseFloat(y));
        BitmapDescriptor bd = BitmapDescriptorFactory
                .fromResource(R.drawable.icon_gcoding);
        OverlayOptions ooA = new MarkerOptions().position(llA).icon(bd)
                .zIndex(9);
        mBaiduMap.addOverlay(ooA);
        // 设置放大倍数
        MapStatus mStatus = new MapStatus.Builder().zoom(16).build();
        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mStatus);
        mBaiduMap.setMapStatus(mMapStatusUpdate);
    }

    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.lookAddr));
        mMapView = findViewById(R.id.bmapView);
    }

    public void onFinish(View view) {
        finish();
    }

    @Override
    protected void onPause() {
        // activity 暂停时同时暂停地图控件
        if (null != mMapView) {
            mMapView.onPause();
        }
        super.onPause();

    }

    @Override
    protected void onResume() {
        // activity 恢复时同时恢复地图控件
        if (null != mMapView) {
            mMapView.onResume();
        }
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        if (null != mMapView) {
            // 关闭定位图层
            mBaiduMap.setMyLocationEnabled(false);
            try {
                mMapView.onDestroy();
            } catch (Exception e) {
                e.printStackTrace();
            }
            mBaiduMap = null;
            mMapView = null;
        }
        super.onDestroy();
    }

}
