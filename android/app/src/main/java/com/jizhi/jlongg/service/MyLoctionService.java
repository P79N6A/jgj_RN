package com.jizhi.jlongg.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.text.TextUtils;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.db.BaseInfoDB;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * Android Service 示例
 *
 * @author dev
 */
public class MyLoctionService extends Service {
    private String TAG = getClass().getName();
    // 定位相关
    private LocationClient mLocClient;
    //    private LocationMode mCurrentMode;
    private BaseInfoService baseInfoService;


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        // 定位初始化
        mLocClient = new LocationClient(this);
        mLocClient.registerLocationListener(new MyLocationListenner());
        LocationClientOption option = new LocationClientOption();
        option.setOpenGps(true);// 打开gps
        option.setCoorType("bd09ll"); // 设置坐标类型
        option.setScanSpan(6000);
        option.setIsNeedAddress(true);
        mLocClient.setLocOption(option);
        mLocClient.start();
    }

    /**
     * 定位SDK监听函数
     */
    public class MyLocationListenner implements BDLocationListener {

        @Override
        public void onReceiveLocation(BDLocation location) {
            if (location == null) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "定位失败", CommonMethod.ERROR);
                return;
            }
            UclientApplication application = (UclientApplication) getApplicationContext();
            SPUtils.put(application, "address", location.getAddress().address, Constance.JLONGG);
            SPUtils.put(application, "loc_city_code", location.getCity(), Constance.JLONGG);
            baseInfoService = BaseInfoService.getInstance(application);
            String city_code = baseInfoService.selectCityCode(BaseInfoDB.jlg_city_data, location.getCity());
            if (TextUtils.isEmpty(city_code)) {
                city_code = "0";
            }
            SPUtils.put(application, "loc_city_code", city_code, Constance.JLONGG);
            upLocation(location.getLatitude(), location.getLongitude(), city_code);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (null != mLocClient) {
            mLocClient.stop();
        }
    }

    public void upLocation(final double lat, final double lng, String city_code) {
        LUtils.e("----11----AAAAA------------", "---------");
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String token = SPUtils.get(this, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
        if (!TextUtils.isEmpty(token)) {
            params.setHeader(Constance.REQUEST_HEAD, token); // token
            params.addBodyParameter("location", lng + "," + lat);
            params.addBodyParameter("region", city_code);
            HttpUtils http = SingsHttpUtils.getHttp();
            http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOC, params,
                    new RequestCallBack<String>() {
                        @Override
                        public void onFailure(HttpException arg0, String arg1) {
                            stopSelf();
                        }

                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {

                            LUtils.e("-----22---AAAAA------------", responseInfo.result);
                            try {
                                Gson gson = new Gson();
                                BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                                if (base.getState() == 1) {
                                    SPUtils.put(getApplicationContext(), "lat", lat, Constance.JLONGG);
                                    SPUtils.put(getApplicationContext(), "lng", lng, Constance.JLONGG);
                                }
                            } catch (Exception e) {
                                e.getMessage();
                            } finally {
                                stopSelf();
                            }
                        }
                    });
        } else {
            stopSelf();
        }
    }
}
