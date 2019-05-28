package com.jizhi.jlongg.main.activity;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

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
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiNearbySearchOption;
import com.baidu.mapapi.search.poi.PoiResult;
import com.baidu.mapapi.search.poi.PoiSearch;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SignNearByInfoAdapter;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.util.List;

/**
 * CName 签到微调 2.3.0
 * User: hcs
 * Date: 2017-07-28
 * Time: 10:40
 */

public class SignAddressChangeActivity extends BaseActivity {
    private SignAddressChangeActivity mActivity;
    // 地图相关
    private MapView mMapView;
    private BaiduMap mBaiduMap;
    //经度和纬度
    private double longitude, latitude;
    private ListView listView;
    /**
     * 搜索类
     */
    private PoiSearch mPoiSearch;
    /**
     * 城市列表ddapter
     */
    private SignNearByInfoAdapter adapter;
    private int positionSelect;
    private Intent intent;
    private BDLocation bdLocation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_change);
        initView();
        initLoc();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                PoiInfo list = (PoiInfo) listView.getAdapter().getItem(position);
                intent = new Intent();
                LUtils.e("--------------- fial-----------------" +new Gson().toJson(list));

                Bundle bundle = new Bundle();
                bundle.putParcelable("location", bdLocation);
                bundle.putString("address1", list.address);
                bundle.putString("address2", list.name);
                bundle.putDouble("latitude", list.location.latitude);
                bundle.putDouble("longitude", list.location.longitude);
                intent.putExtras(bundle);
                initMap(list.location.latitude, list.location.longitude);
                adapter = new SignNearByInfoAdapter(mActivity, poiInfos, position);
                listView.setAdapter(adapter);
                listView.setSelection(position);

            }
        });

        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != intent) {
                    setResult(Constance.REQUEST, intent);
                    finish();
                }

            }
        });
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String addr2) {
        Intent intent = new Intent(context, SignAddressChangeActivity.class);
        intent.putExtra("addr", addr2);
        context.startActivityForResult(intent, Constance.REQUESTCODE_LOCATION);
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = SignAddressChangeActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "地点微调");
        SetTitleName.setTitle(findViewById(R.id.right_title), "确定");
        listView = (ListView) findViewById(R.id.listView);
        // 地图初始化
        mMapView = (MapView) findViewById(R.id.bmapView);
        mMapView.showZoomControls(false);
        mBaiduMap = mMapView.getMap();
        mBaiduMap.getUiSettings().setAllGesturesEnabled(false);

        // 设置放大倍数
        MapStatus mStatus = new MapStatus.Builder().zoom(16).build();
        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mStatus);
        mBaiduMap.setMapStatus(mMapStatusUpdate);

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

    public void serachAddr(double x, double y, String address) {
        if (TextUtils.isEmpty(address)) {
            return;
        }

        PoiNearbySearchOption poiNearbySearchOption = new PoiNearbySearchOption();
        LatLng llA = new LatLng(x, y);
        poiNearbySearchOption.keyword(address);

        poiNearbySearchOption.location(llA);
        poiNearbySearchOption.pageCapacity(30);
        poiNearbySearchOption.pageNum(0);
        poiNearbySearchOption.radius(500);
        mPoiSearch.searchNearby(poiNearbySearchOption);


    }

    @Override
    protected void onDestroy() {
        mPoiSearch.destroy();
        super.onDestroy();
    }

    private MyLocationListenner myListener = new MyLocationListenner();
    private LocationClient mLocClient;

    public void initLoc() {
        mMapView.setVisibility(View.VISIBLE);
        mLocClient = new LocationClient(mActivity);
        mLocClient.registerLocationListener(myListener);
        LocationClientOption option = new LocationClientOption();

        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        option.setCoorType("bd09ll");//可选，默认gcj02，设置返回的定位结果坐标系，如果配合百度地图使用，建议设置为bd09ll;
        //mOption.setScanSpan(0);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setIsNeedLocationDescribe(true);//可选，设置是否需要地址描述
        option.setNeedDeviceDirect(false);//可选，设置是否需要设备方向结果
        option.setLocationNotify(false);//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        option.setIgnoreKillProcess(true);//可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死
        option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        option.setIsNeedLocationPoiList(true);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
        // option.setScanSpan(1000);
        mLocClient.setLocOption(option);
        mLocClient.start();
    }

    public class MyLocationListenner implements BDLocationListener {

        @Override
        public void onReceiveLocation(BDLocation location) {
            if (null != location && location.getLocType() != BDLocation.TypeServerError) {
                bdLocation = location;
                latitude = location.getLatitude();
                longitude = location.getLongitude();
                String addr1 = location.getAddress().street;
                initBaiduSearchConfiguration(latitude, longitude, addr1);
                LUtils.e("-------------------:" + new Gson().toJson(location));
            } else {
            }
//            if (null != mLocClient) {
//                mLocClient.stop();
//            }
        }
    }

    private void initBaiduSearchConfiguration(double latitude, double longitude, String address) {
        mPoiSearch = PoiSearch.newInstance();
        mPoiSearch.setOnGetPoiSearchResultListener(new OnGetPoiSearchResultListener() {
            @Override
            public void onGetPoiResult(PoiResult result) {
                if (result == null || result.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {
//                    searchFail();
                    LUtils.e("--------------- fial-----------------");
                    return;
                }
                List<PoiInfo> poiInfo = result.getAllPoi();
                poiInfos = poiInfo;
                if (null != poiInfo && poiInfo.size() > 0) {
                    positionSelect = 0;
                    initMap(poiInfo.get(0).location.latitude, poiInfo.get(0).location.longitude);
                    setAdapterData(poiInfo);
                }
            }

            @Override
            public void onGetPoiDetailResult(PoiDetailResult poiDetailResult) {
            }
        });

        LUtils.e("-----------------address: " + address);
        serachAddr(latitude, longitude, address);
    }

    private List<PoiInfo> poiInfos;

    private void setAdapterData(List<PoiInfo> list) {
        if (null != list && list.size() > 0) {
            intent = new Intent();
            intent.putExtra("address1", list.get(0).name);
            intent.putExtra("address2", list.get(0).address);
            intent.putExtra("latitude", list.get(0).location.longitude);
            intent.putExtra("longitude", list.get(0).location.latitude);
        }


        if (adapter == null) {
            adapter = new SignNearByInfoAdapter(this, list, positionSelect);
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(list);
        }
    }
}
