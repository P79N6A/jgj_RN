package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.ReadInfo;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.WeatherInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.custom.MyEditText;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.message.WebSocketMeassgeParameter;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.popwindow.SelecteLogWeatherPopWindow;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * 功能: 发工作日志
 * 作者：胡常生
 * 时间: 2017年3月31日 14:52:59
 */
public class ReleaseLogActivity extends BaseActivity implements View.OnClickListener, SelecteLogWeatherPopWindow.SelectedWeatherListener, AccountPhotoGridAdapter.PhotoDeleteListener, OnSquaredImageRemoveClick {
    private ReleaseLogActivity mActivity;
    //项目名称；天气：上午，下午；
    private TextView tv_pro_name, tv_weather_morning, tv_weather_afternoon;
    //温度上午，下午；风力，上午，下午；备注：生产情况，工作记录；
    private EditText ed_temperature_morning, ed_temperature_afternoon, ed_wind_morning, ed_wind_afternoon;
    private MyEditText ed_remarks1, ed_remarks2;
    //选择天气上午，下午
    private SelecteLogWeatherPopWindow popWindowMorning, popWindowAfternoon;
    //1选择的是上午，选择的是下午
    private int weatherMorningOrAfternoon;
    // 图片数据
    public List<ImageItem> photos = new ArrayList<>();
    //拍照后面的文字
    private TextView textPhoto;
    // 图片适配器
    private SquaredImageAdapter adapter;
    //    /* 图片数据 */
//    private List<ImageItem> imageItems = new ArrayList<>();
    //组信息
    private GroupDiscussionInfo gnInfo;
    //消息类型
    private String msgType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_releaselog);
        initView();
        getIntentData();
        registerReceiver();
        hideSoftKeyboard();
        initOrUpDateAdapter();
        getWeatherDayByGroup();
    }

    private void initView() {
        mActivity = ReleaseLogActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "发工作日志");
        tv_pro_name = (TextView) findViewById(R.id.tv_pro_name);
        tv_weather_morning = (TextView) findViewById(R.id.tv_weather_morning);
        tv_weather_afternoon = (TextView) findViewById(R.id.tv_weather_afternoon);
        ed_temperature_morning = (EditText) findViewById(R.id.ed_temperature_morning);
        ed_temperature_afternoon = (EditText) findViewById(R.id.ed_temperature_afternoon);
        ed_wind_morning = (EditText) findViewById(R.id.ed_wind_morning);
        ed_wind_afternoon = (EditText) findViewById(R.id.ed_wind_afternoon);
        ed_remarks1 = (MyEditText) findViewById(R.id.ed_remarks1);
        ed_remarks2 = (MyEditText) findViewById(R.id.ed_remarks2);
        textPhoto = (TextView) findViewById(R.id.textPhoto);
        findViewById(R.id.save).setOnClickListener(this);
        findViewById(R.id.tv_weather_morning).setOnClickListener(this);
        findViewById(R.id.tv_weather_afternoon).setOnClickListener(this);


    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, ReleaseLogActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (gnInfo.getClass_type().equals("team")) {
            tv_pro_name.setText("当前项目：" + gnInfo.getAll_pro_name() + "\n接收对象：本项目组所有成员");
        } else {
//
            tv_pro_name.setText("当前班组：" + gnInfo.getAll_pro_name() + "\n接收对象：本项目组所有成员");
        }
    }


    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.gridView);
            adapter = new SquaredImageAdapter(this, this, photos, 9);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    if (position == photos.size()) {
                        Acp.getInstance(mActivity).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                                , Manifest.permission.CAMERA)
                                        .build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        ArrayList<String> mSelected = selectedPhotoPath();
                                        CameraPop.multiSelector(mActivity, mSelected, 9);
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });
                    } else {
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) photos);
                        bundle.putInt(Constance.BEAN_INT, position);
                        Intent intent = new Intent(mActivity, PhotoZoomActivity.class);
                        intent.putExtras(bundle);
                        startActivity(intent);
                    }
                }
            });
        } else {
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.save:
                savaClick();
                break;
            case R.id.tv_weather_morning:
                //上午天气
                hideSoftKeyboard();
                weatherMorningOrAfternoon = 1;
                if (popWindowMorning == null) {
                    popWindowMorning = new SelecteLogWeatherPopWindow(mActivity, this);
                }
                popWindowMorning.showAtLocation(findViewById(R.id.main_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                break;
            case R.id.tv_weather_afternoon:
                //下午天气
                hideSoftKeyboard();
                weatherMorningOrAfternoon = 2;
                if (popWindowAfternoon == null) {
                    popWindowAfternoon = new SelecteLogWeatherPopWindow(mActivity, this);
                }
                popWindowAfternoon.showAtLocation(findViewById(R.id.main_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                break;
        }
    }

    /**
     * 选择天气回调
     *
     * @param attribute1 天气1
     * @param attribute2 天气2
     */
    @Override
    public void selectedWather(WeatherAttribute attribute1, WeatherAttribute attribute2) {
        String attribute2Name = "";
        LUtils.e(new Gson().toJson(attribute1) + ",,,," + new Gson().toJson(attribute2));
        if (null != attribute2) {
            attribute2Name = attribute2.getWeatherName();
        }

        if (weatherMorningOrAfternoon == 1) {
            if (!TextUtils.isEmpty(attribute2Name)) {
                tv_weather_morning.setText(attribute1.getWeatherName() + ">" + attribute2.getWeatherName());
            } else {
                tv_weather_morning.setText(attribute1.getWeatherName());
            }
        } else if (weatherMorningOrAfternoon == 2) {
            if (!TextUtils.isEmpty(attribute2Name)) {
                tv_weather_afternoon.setText(attribute1.getWeatherName() + ">" + attribute2.getWeatherName());
            } else {
                tv_weather_afternoon.setText(attribute1.getWeatherName());
            }
        }

    }

    @Override
    public void dismissWather() {

    }

    public void initPictureDesc() {
        if (photos == null) {
            textPhoto.setVisibility(View.VISIBLE);
            return;
        }
        if (photos.size() == 1) {
            textPhoto.setVisibility(View.VISIBLE);
        } else {
            textPhoto.setVisibility(View.GONE);
        }
    }

    @Override
    public void imageSizeIsZero() {
        initPictureDesc();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            List<ImageItem> tempList = new ArrayList<ImageItem>();
            if (mSelected != null && mSelected.size() > 0) { //遍历添加本地选中图片
                for (String localpath : mSelected) {
                    ImageItem item = new ImageItem();
                    item.imagePath = localpath;
                    item.isNetPicture = false;
                    tempList.add(item);
                }
            }
            photos = tempList;
            adapter.updateGridView(photos);
        }
    }

    DiaLogRedLongProgress dialog;

    public void savaClick() {

        String text1 = ed_remarks1.getText().toString().trim();
        String text2 = ed_remarks2.getText().toString().trim();
        if ((selectedPhotoPath() == null || selectedPhotoPath().size() == 0) && TextUtils.isEmpty(text1) && TextUtils.isEmpty(text2)) {
            CommonMethod.makeNoticeShort(mActivity, "记录、图片至少填写一项", CommonMethod.ERROR);
            return;
        }
        if (null == dialog) {
            dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.syning));
        }
        if (null != photos && selectedPhotoPath().size() > 0) {
            dialog.show();
            FileUpData();

        } else {
            if (TextUtils.isEmpty(text1) && TextUtils.isEmpty(text2)) {
                CommonMethod.makeNoticeShort(mActivity, "请输入内容", CommonMethod.ERROR);
                return;
            }
            dialog.show();
            sendMsg(new ArrayList<String>());
        }
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    uploadPic();
                    break;
            }

        }
    };
    RequestParams params;

    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
//                progressNumber = 0;
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                mHandler.sendEmptyMessage(Constance.LOADING);
                RequestParamsToken.compressImageAndUpLoad(params, selectedPhotoPath(), ReleaseLogActivity.this);
                Message message = Message.obtain();
                message.obj = params;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        });
        thread.start();
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = photos.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = photos.get(i);
            if (!TextUtils.isEmpty(item.imagePath)) {
                mSelected.add(item.imagePath);
            }

        }
        return mSelected;
    }

    public void uploadPic() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    JSONObject jsonObject = new JSONObject(responseInfo.result);
                    int state = jsonObject.getInt("state");
                    if (state != 0) {
                        List<String> list = new ArrayList<String>();
                        JSONArray jSONArray = jsonObject.getJSONArray("values");
                        for (int i = jSONArray.length() - 1; i >= 0; i--) {
                            list.add(jSONArray.get(i).toString());
                        }
                        sendMsg(list);
                    } else {
                        String errno = jsonObject.getString("errno");
                        String errmsg = jsonObject.getString("errmsg");
                        DataUtil.showErrOrMsg(mActivity, errno, errmsg);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {

                    if (null != dialog) {
                        dialog.dismissDialog();
                    }
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                if (null != dialog) {
                    dialog.dismissDialog();
                }
            }
        });
    }

    private void sendMsg(List<String> imgUrls) {
        hideSoftKeyboard();
        String userName = (String) SPUtils.get(mActivity, Constance.USERNAME, "", Constance.JLONGG);
        String headImage = SPUtils.get(mActivity, Constance.HEAD_IMAGE, "", Constance.JLONGG).toString(); //头像路径
        MessageEntity entity = new MessageEntity();
        entity.setDate(TimesUtils.getNowTime());
        entity.setMsg_type(MessageType.MSG_LOG_STRING);
        entity.setLocal_id((System.currentTimeMillis() / 1000) + "");
        entity.setUser_name(userName);
        entity.setMsg_src(imgUrls);
        entity.setMsg_state(2);
        ReadInfo readInfo = new ReadInfo();
        readInfo.setUnread_user_num("0");
        entity.setHead_pic(headImage);
        entity.setRead_info(readInfo);
        //生产记录记录情况
        if (!TextUtils.isEmpty(ed_remarks1.getText().toString().trim())) {
            entity.setMsg_text(ed_remarks1.getText().toString().trim());
        }
        //技术质量工作记录
        if (!TextUtils.isEmpty(ed_remarks2.getText().toString().trim())) {
            entity.setTechno_quali_log(ed_remarks2.getText().toString().trim());
        }
        //温度
        if (!TextUtils.isEmpty(ed_temperature_morning.getText().toString().trim())) {
            entity.setTemp_am(ed_temperature_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(ed_temperature_afternoon.getText().toString().trim())) {
            entity.setTemp_pm(ed_temperature_afternoon.getText().toString().trim());
        }
        //风力
        if (!TextUtils.isEmpty(ed_wind_morning.getText().toString().trim())) {
            entity.setWind_am(ed_wind_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(ed_wind_afternoon.getText().toString().trim())) {
            entity.setWind_pm(ed_wind_afternoon.getText().toString().trim());
        }
        //天气
        if (!TextUtils.isEmpty(tv_weather_morning.getText().toString().trim())) {
            entity.setWeat_am(tv_weather_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(tv_weather_afternoon.getText().toString().trim())) {
            entity.setWeat_pm(tv_weather_afternoon.getText().toString().trim());
        }

        sendMsgToService(entity);
    }

    /**
     * 发送消息到服务器
     *
     * @param msgData
     */
    public void sendMsgToService(MessageEntity msgData) {
        SocketManager socketManager = SocketManager.getInstance(getApplicationContext());
        WebSocket webSocket = socketManager.getWebSocket();
        if (webSocket == null) {
            return;
        }
        if (!socketManager.socketState.equals(SocketManager.SOCKET_OPEN)) {
            msgData.setMsg_state(1);
            return;
        }
        WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
        msgParmeter.setAction(WebSocketConstance.SENDMESSAGE);
        msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
        msgParmeter.setMsg_type(msgData.getMsg_type());
        msgParmeter.setClass_type(gnInfo.getClass_type());
        msgParmeter.setGroup_id(gnInfo.getGroup_id());
        if (!TextUtils.isEmpty(msgData.getMsg_text())) {
            msgParmeter.setMsg_text(msgData.getMsg_text());
        }
        msgParmeter.setLocal_id(msgData.getLocal_id() + "");
        if (null != msgData && null != msgData.getMsg_src() && msgData.getMsg_src().size() > 0) {
            msgParmeter.setMsg_src(msgData.getMsg_src());
        }
        if (!TextUtils.isEmpty(msgData.getTechno_quali_log())) {
            msgParmeter.setTechno_quali_log(msgData.getTechno_quali_log());
        }
        if (!TextUtils.isEmpty(msgData.getWeat_am())) {
            msgParmeter.setWeat_am(msgData.getWeat_am());
        }
        if (!TextUtils.isEmpty(msgData.getWeat_pm())) {
            msgParmeter.setWeat_pm(msgData.getWeat_pm());
        }
        if (!TextUtils.isEmpty(msgData.getWind_am())) {
            msgParmeter.setWind_am(msgData.getWind_am());
        }
        if (!TextUtils.isEmpty(msgData.getWind_pm())) {
            msgParmeter.setWind_pm(msgData.getWind_pm());
        }
        if (!TextUtils.isEmpty(msgData.getTemp_am())) {
            msgParmeter.setTemp_am(msgData.getTemp_am());
        }
        if (!TextUtils.isEmpty(msgData.getTemp_pm())) {
            msgParmeter.setTemp_pm(msgData.getTemp_pm());
        }
        webSocket.requestServerMessage(msgParmeter);
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.SENDMESSAGE);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    @Override
    public void remove(int position) {
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.SENDMESSAGE)) {//发送单挑消息回执
                MessageEntity bean = (MessageEntity) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (bean.getMsg_type() == null || bean.getClass_type().equals(MessageType.MESSAGE_TYPE_ADD_FRIEND)) {
                    return;
                }
//                //更新本地数据库消息
//                MessageUtils.updateMessage(bean);
                mActivity.setResult(Constance.RESULTCODE_FINISH, getIntent());
                CommonMethod.makeNoticeLong(mActivity, "发布成功", CommonMethod.SUCCESS);
                if (null != dialog) {
                    dialog.dismissDialog();
                }
                finish();
            }
        }
    }

    /**
     * 获取当天某组的最近天气信息
     */
    protected void getWeatherDayByGroup() {
        if (null == dialog) {
            dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.syning));
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
//        params.addBodyParameter("time", gnInfo.getClass_type());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WEATHER_DAYBYGROUP,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<WeatherInfo> bean = CommonJson.fromJson(responseInfo.result, WeatherInfo.class);
                            if (bean.getState() != 0) {
                                if (null != bean && null != bean.getValues().getWeather_info() && bean.getValues().getWeather_info().size() > 0) {
                                    setDefaultWeather(bean.getValues().getWeather_info().get(0));
                                }

                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                        finish();
                    }
                });
    }

    public void setDefaultWeather(WeatherInfo weather) {
        //温度上午，下午；风力，上午，下午；备注：生产情况，工作记录；
//        private EditText ed_temperature_morning, ed_temperature_afternoon, ed_wind_morning, ed_wind_afternoon, ed_remarks1, ed_remarks2;
        if (null == weather) {
            return;
        }
        //温度上午，下午
        if (!TextUtils.isEmpty(weather.getTemp_am())) {
            ed_temperature_morning.setText(weather.getTemp_am());
        }
        if (!TextUtils.isEmpty(weather.getTemp_pm())) {
            ed_temperature_afternoon.setText(weather.getTemp_pm());
        }
        //风力，上午，下午
        if (!TextUtils.isEmpty(weather.getWind_am())) {
            ed_wind_morning.setText(weather.getWind_am());
        }
        if (!TextUtils.isEmpty(weather.getWind_pm())) {
            ed_wind_afternoon.setText(weather.getWind_pm());
        }

        // • 如果晴雨表中当天只有1种天气，则上下午默认值都是该天气
        //• 如果晴雨表中当天有2种天气，则上下午默认值分别取第1个值 和 第2个值
        //• 如果晴雨表中当天有3种天气，则上午默认值取第1、2个值，下午取第3个值
        //• 如果晴雨表中当天有4种天气，则上午默认值取第1、2个值，下午取第3、4个值

        //如果只记录了1种天气
        if (TextUtils.isEmpty(weather.getWeat_two()) && !TextUtils.isEmpty(weather.getWeat_one())) {
            tv_weather_morning.setText(weather.getWeat_one());
            tv_weather_afternoon.setText(weather.getWeat_one());
        }
        //如果只记录了2种天气
        if (TextUtils.isEmpty(weather.getWeat_three()) && !TextUtils.isEmpty(weather.getWeat_one()) && !TextUtils.isEmpty(weather.getWeat_two())) {
            tv_weather_morning.setText(weather.getWeat_one());
            tv_weather_afternoon.setText(weather.getWeat_two());
        }
        //如果只记录了3种天气
        if (TextUtils.isEmpty(weather.getWeat_four()) && !TextUtils.isEmpty(weather.getWeat_one()) && !TextUtils.isEmpty(weather.getWeat_two()) && !TextUtils.isEmpty(weather.getWeat_three())) {
            tv_weather_morning.setText(weather.getWeat_one() + ">" + weather.getWeat_two());
            tv_weather_afternoon.setText(weather.getWeat_three());
        }
        //如果只记录了4种天气
        if (!TextUtils.isEmpty(weather.getWeat_one()) && !TextUtils.isEmpty(weather.getWeat_two()) && !TextUtils.isEmpty(weather.getWeat_three()) && !TextUtils.isEmpty(weather.getWeat_four())) {
            tv_weather_morning.setText(weather.getWeat_one() + ">" + weather.getWeat_two());
            tv_weather_afternoon.setText(weather.getWeat_three() + ">" + weather.getWeat_four());
        }
    }
}
