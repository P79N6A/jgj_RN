package com.jizhi.jlongg.main.activity;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
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
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.CheckHistoryImageAdapter;
import com.jizhi.jlongg.main.adpter.PhotoGridAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.SignListBean;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapGridview;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:签到详情
 * User: hcs
 * Date: 2016-04-21
 * Time: 16:55
 */
public class SigninDetailActivity extends BaseActivity implements OnSquaredImageRemoveClick {

    private SigninDetailActivity mActivity;
    /**
     * 时间
     */
    @ViewInject(R.id.tv_time)
    private TextView tv_time;
    // 地图相关
    private MapView mMapView;
    private BaiduMap mBaiduMap;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_sign_detail);
        LUtils.e("签到详情，，，SigninDetailActivity");
        ViewUtils.inject(this);
        initView();
        getSignDetail();

    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, int sign_id) {
        Intent intent = new Intent(context, SigninDetailActivity.class);
        intent.putExtra(Constance.BEAN_INT, sign_id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = SigninDetailActivity.this;
        setTextTitle(R.string.sign_in_detail);
        // 地图初始化
        mMapView = findViewById(R.id.bmapView);
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
    public void remove(int position) {
    }

    /**
     * 签到
     */
    public void getSignDetail() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("sign_id", getIntent().getIntExtra(Constance.BEAN_INT, 0) + "");
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SIGN_RECORD_DETAIL, SignListBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                initData((SignListBean) object);
                closeDialog();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();

            }
        });
    }

    /**
     * 设置签到数据
     *
     * @param bean
     */
    public void initData(final SignListBean bean) {
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


        (findViewById(R.id.tv_remark)).setVisibility(!TextUtils.isEmpty(bean.getSign_desc()) ? View.VISIBLE : View.GONE);
        ((TextView) findViewById(R.id.tv_remark)).setText(bean.getSign_desc());
        (findViewById(R.id.rea_photos)).setVisibility((null != bean.getSign_pic() && bean.getSign_pic().size() > 0) ? View.VISIBLE : View.GONE);
        findViewById(R.id.rea_edmark).setVisibility((TextUtils.isEmpty(bean.getSign_desc()) && bean.getSign_pic().size() == 0) ? View.GONE : View.VISIBLE);
        if (null != bean.getSign_pic() && bean.getSign_pic().size() > 0) {
            CheckHistoryImageAdapter squaredImageAdapter = new CheckHistoryImageAdapter(mActivity, bean.getSign_pic());
            WrapGridview ngl_images = findViewById(R.id.ngl_images);
            ngl_images.setAdapter(squaredImageAdapter);
            ngl_images.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    ImageView image = view.findViewById(R.id.image);
                    MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(image.getMeasuredWidth(), image.getMeasuredHeight());
                    MessageImagePagerActivity.startImagePagerActivity(mActivity, bean.getSign_pic(), position, imageSize);
                }
            });
        }
    }
}
