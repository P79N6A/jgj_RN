package com.jizhi.jlongg.main.util;

import android.content.Context;
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
import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 定位
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-11 上午11:19:44
 */
public class LoctionUtils {
    /**
     * 百度定位工具
     */
    private LocationClient mLocClient;
    /**
     * 百度定位回调
     */
    private MyLocationListenner myListener = new MyLocationListenner();
    /**
     * 上下文
     */
    private Context context;
    /**
     * 定位回调
     */
    private LoctionListener loctionListener;
    private BaseInfoService baseInfoService;


    public LoctionUtils(Context context, LoctionListener loctionListener) {
        this.context = context;
        this.loctionListener = loctionListener;
    }

    public void initLoc() {
        mLocClient = new LocationClient(context);
        mLocClient.registerLocationListener(myListener);
        LocationClientOption option = new LocationClientOption();
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
            if (location == null) {
                loctionListener.loctionFail();
                if (null != mLocClient) {
                    mLocClient.stop();
                }
                return;
            }
            try {
                String cityCode = location.getCityCode();
                String cityName = location.getCity();
                String cityProvice = location.getProvince();
                SPUtils.put(context, Constance.PROVICECITY, cityProvice + "  " + cityName, Constance.JLONGG);
                SPUtils.put(context, "lat", location.getLatitude() + "", Constance.JLONGG); //纬度 Latitude
                SPUtils.put(context, "lng", location.getLongitude() + "", Constance.JLONGG); //经度 Longitude
                SPUtils.put(context, "nation", location.getCountry(), Constance.JLONGG); //国家
                SPUtils.put(context, "province", location.getProvince(), Constance.JLONGG); //省
                SPUtils.put(context, Constance.ADDRESS, location.getAddress().address, Constance.JLONGG); //

                LUtils.e("----ccccc----定位成功--------33-------------" + new Gson().toJson(location));

                baseInfoService = BaseInfoService.getInstance(context);
                String city_code = baseInfoService.selectCityCode(BaseInfoDB.jlg_city_data, location.getCity());
                if (TextUtils.isEmpty(city_code)) {
                    city_code = "0";
                }
                SPUtils.put(context, "loc_city_code", city_code, Constance.JLONGG);
                SPUtils.put(context, "adcode", city_code, Constance.JLONGG); //国家城市编码

                upLocation(location.getLatitude(), location.getLongitude(), city_code);

                loctionListener.loctionSuccess(location.getCity());
            } catch (Exception e) {
                LUtils.e("----ccccc----定位成功--------4-------------");

                e.getMessage();
            }
            if (null != mLocClient) {
                mLocClient.stop();
            }
        }
    }

    public void upLocation(final double lat, final double lng, String city_code) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        String token = SPUtils.get(context, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
        if (!TextUtils.isEmpty(token)) {
            params.setHeader(Constance.REQUEST_HEAD, token); // token
            params.addBodyParameter("location", lng + "," + lat);
            params.addBodyParameter("region", city_code);
            HttpUtils http = SingsHttpUtils.getHttp();
            http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOC, params,
                    new RequestCallBack<String>() {
                        @Override
                        public void onFailure(HttpException arg0, String arg1) {
//                            stopSelf();
                        }

                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            if (UclientApplication.isLogin(context)) {
                                SocketManager socketManager = SocketManager.getInstance(context);
                                if (socketManager.getWebSocket() != null && socketManager.socketState.equals(SocketManager.SOCKET_OPEN)) {
                                    WebSocketBaseParameter request = new WebSocketBaseParameter();
                                    request.setAction(WebSocketConstance.ACTION_HEARTBEAT);
                                    request.setCtrl(WebSocketConstance.MESSAGE);
                                    socketManager.getWebSocket().requestServerMessage(request);
                                }
                            }
                            LUtils.e("-----重新发送心跳------------" + responseInfo.result);


                            try {
                                Gson gson = new Gson();
                                BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                                if (base.getState() == 1) {
                                    SPUtils.put(context, "lat", lat, Constance.JLONGG);
                                    SPUtils.put(context, "lng", lng, Constance.JLONGG);
                                }
                            } catch (Exception e) {
                                e.getMessage();
                            } finally {
//                                stopSelf();
                            }
                        }
                    });
        } else {
//            stopSelf();
        }
    }

    public void close() {
        if (null != mLocClient) {
            mLocClient.stop();
        }
    }

    public interface LoctionListener {
        /**
         * 定位失败
         */
        void loctionFail();

        /**
         * 定位成功
         */
        void loctionSuccess(String city_name);

    }
}
