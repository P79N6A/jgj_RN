package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.popwindow.SelecteLogWeatherPopWindow;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.WrapGridview;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能: 发工作日志
 * 作者：胡常生
 * 时间: 2017年3月31日 14:52:59
 */
public class UpdateLogActivity extends BaseActivity implements View.OnClickListener, SelecteLogWeatherPopWindow.SelectedWeatherListener, OnSquaredImageRemoveClick, AccountPhotoGridAdapter.PhotoDeleteListener {
    private UpdateLogActivity mActivity;
    //项目名称；天气：上午，下午；
    private TextView tv_pro_name, tv_weather_morning, tv_weather_afternoon;
    //温度上午，下午；风力，上午，下午；备注：生产情况，工作记录；
    private EditText ed_temperature_morning, ed_temperature_afternoon, ed_wind_morning, ed_wind_afternoon, ed_remarks1, ed_remarks2;
    //选择天气上午，下午
    private SelecteLogWeatherPopWindow popWindowMorning, popWindowAfternoon;
    //1选择的是上午，选择的是下午
    private int weatherMorningOrAfternoon;
    // 图片数据
    public List<ImageItem> photos = new ArrayList<>();
    // 图片适配器
    private SquaredImageAdapter adapter;
    //    /* 图片数据 */
//    private List<ImageItem> imageItems = new ArrayList<>();
    //组信息
    private GroupDiscussionInfo gnInfo;
    //消息类型
    private String msg_id, msgType;
    private MessageEntity msgEntity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_releaselog);
        initView();
        getIntentData();
        setData();
        hideSoftKeyboard();
    }

    private void initView() {
        mActivity = UpdateLogActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "发工作日志");
        ((Button) findViewById(R.id.save)).setText("发工作日志");
        tv_pro_name = (TextView) findViewById(R.id.tv_pro_name);
        tv_weather_morning = (TextView) findViewById(R.id.tv_weather_morning);
        tv_weather_afternoon = (TextView) findViewById(R.id.tv_weather_afternoon);
        ed_temperature_morning = (EditText) findViewById(R.id.ed_temperature_morning);
        ed_temperature_afternoon = (EditText) findViewById(R.id.ed_temperature_afternoon);
        ed_wind_morning = (EditText) findViewById(R.id.ed_wind_morning);
        ed_wind_afternoon = (EditText) findViewById(R.id.ed_wind_afternoon);
        ed_remarks1 = (EditText) findViewById(R.id.ed_remarks1);
        ed_remarks2 = (EditText) findViewById(R.id.ed_remarks2);
        findViewById(R.id.save).setOnClickListener(this);
        findViewById(R.id.tv_weather_morning).setOnClickListener(this);
        findViewById(R.id.tv_weather_afternoon).setOnClickListener(this);


    }

    /**
     * 设置显示内容
     */
    private void setData() {
        LUtils.e("--------------setHeadData：" + new Gson().toJson(msgEntity));
        ((TextView) findViewById(R.id.tv_weather_morning)).setText(msgEntity.getWeat_am() == null ? "" : msgEntity.getWeat_am());
        ((TextView) findViewById(R.id.tv_weather_afternoon)).setText(msgEntity.getWeat_pm() == null ? "" : msgEntity.getWeat_pm());
        ((EditText) findViewById(R.id.ed_temperature_morning)).setText(msgEntity.getTemp_am() == null ? "" : msgEntity.getTemp_am());
        ((EditText) findViewById(R.id.ed_temperature_afternoon)).setText(msgEntity.getTemp_pm() == null ? "" : msgEntity.getTemp_pm());
        ((EditText) findViewById(R.id.ed_wind_morning)).setText(msgEntity.getWind_am() == null ? "" : msgEntity.getWind_am());
        ((EditText) findViewById(R.id.ed_wind_afternoon)).setText(msgEntity.getWind_pm() == null ? "" : msgEntity.getWind_pm());
        ((EditText) findViewById(R.id.ed_remarks1)).setText(msgEntity.getMsg_text() == null ? "" : msgEntity.getMsg_text());
        ((EditText) findViewById(R.id.ed_remarks2)).setText(msgEntity.getTechno_quali_log() == null ? "" : msgEntity.getTechno_quali_log());
        List<String> imagePaths = msgEntity.getMsg_src();
        if (imagePaths != null && imagePaths.size() > 0) {
            int size = imagePaths.size();
            for (int i = 0; i < size; i++) {
                ImageItem item = new ImageItem();
                item.imagePath = imagePaths.get(i);
                item.isNetPicture = true;
                photos.add(item);
                LUtils.e("-------------------------:" + photos.get(i).imagePath);
            }
        }
        initPhoto();
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo gnInfo, MessageEntity messageEntity, String msg_id, String msg_type) {
        Intent intent = new Intent(context, UpdateLogActivity.class);
        intent.putExtra("msgEntity", messageEntity);
        intent.putExtra("msg_id", msg_id);
        intent.putExtra("msg_type", msg_type);
        intent.putExtra(Constance.BEAN_CONSTANCE, gnInfo);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        msgEntity = (MessageEntity) getIntent().getSerializableExtra("msgEntity");
        msg_id = getIntent().getStringExtra("msg_id");
        msgType = getIntent().getStringExtra("msg_type");
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (gnInfo.getClass_type().equals("team")) {
            tv_pro_name.setText("当前项目：" + gnInfo.getPro_name() + "\n接收对象：本项目组所有成员");
        } else {
            tv_pro_name.setText("当前班组：" + gnInfo.getPro_name() + "\n接收对象：本项目组所有成员");
        }
    }

    public void initPhoto() {
        adapter = new SquaredImageAdapter(mActivity, this, photos, 9);
        WrapGridview gridView = (WrapGridview) findViewById(R.id.gridView);
        gridView.setAdapter(adapter);
        gridView.setOnItemClickListener(onItemClickListener);
    }

    AdapterView.OnItemClickListener onItemClickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            if (position == photos.size()) { //进入图片选择器
                //6.0需要获取读取本地内存卡权限
                Acp.getInstance(getApplicationContext()).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA).build(),
                            new AcpListener() {
                                @Override
                                public void onGranted() {
                                    ArrayList<String> mSelected = getSelectedPhotoPath();
                                    CameraPop.multiSelector(mActivity, mSelected, 9);
                                }

                                @Override
                                public void onDenied(List<String> permissions) {
                                    CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                }
                            });
            } else { //查看图片
                Bundle bundle = new Bundle();
                bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) photos);
                bundle.putInt(Constance.BEAN_INT, position);
                Intent intent = new Intent(mActivity, PhotoZoomActivity.class);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        }
    };

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> getSelectedPhotoPath() {
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

    @Override
    public void imageSizeIsZero() {
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


    //    @Override
//    public void imageSizeIsZero() {
//        initPictureDesc();
//    }
    StringBuffer stringBuffer;

    @Override
    public void remove(int position) {
        if (!photos.get(position).imagePath.contains("/storage/")) {
            if (null == stringBuffer) {
                stringBuffer = new StringBuffer();
            }
            LUtils.e("删除了---------------------");
            stringBuffer.append(photos.get(position).imagePath + ",");
        }else{
            LUtils.e("没有删除-----------------");
        }
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            List<ImageItem> tempList = new ArrayList<>();
            if (mSelected != null && mSelected.size() > 0) { //遍历添加本地选中图片
                for (String localpath : mSelected) {
                    ImageItem item = new ImageItem();
                    item.imagePath = localpath;
                    item.isNetPicture = false;
                    tempList.add(item);
                }
            }

            for (int i = 0; i < tempList.size(); i++) {
                tempList.get(i).isNetPicture = false;
                for (int j = 0; j < photos.size(); j++) {
                    if (tempList.get(i).imagePath.equals(photos.get(j).imagePath) && !tempList.get(i).imagePath.contains("/storage/")) {
                        tempList.get(i).isNetPicture = true;
                    }
                }
                LUtils.e("---------------:" + tempList.get(i).imagePath + ",,," + tempList.get(i).isNetPicture);
                photos = tempList;
                adapter.updateGridView(photos);
            }
        }
    }

    /**
     * 设置图片默认值
     */

    public void loadDefaultPhotoGridViewData() {
        if (photos == null) {
            photos = new ArrayList<ImageItem>();
        }
        photos.add(CameraPop.initPhotos());
    }

    DiaLogRedLongProgress dialog;

    public void savaClick() {

        String text1 = ed_remarks1.getText().toString().trim();
        String text2 = ed_remarks2.getText().toString().trim();
        if ((photos == null || photos.size() == 0) && TextUtils.isEmpty(text1) && TextUtils.isEmpty(text2)) {
            CommonMethod.makeNoticeShort(mActivity, "记录、图片至少填写一项", CommonMethod.SUCCESS);
            return;
        }
        if (null == dialog) {
            dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.syning));
        }
        dialog.show();
        FileUpData();
    }

    //1修改日志
    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                params = getParams();
                upLoadImage();
                mHandler.sendEmptyMessage(1);
            }
        });
        thread.start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    modifyLog();
                    break;
            }

        }
    };
    RequestParams params;

    public void upLoadImage() {
        List<String> tempPhoto = null;
        if (null != photos && photos.size() > 0) {
            if (tempPhoto == null) {
                tempPhoto = new ArrayList<>();
            }
            int size = photos.size();
            for (int i = 0; i < size; i++) {
                ImageItem item = photos.get(i);
                if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                    tempPhoto.add(photos.get(i).imagePath);
                }
            }
            if (tempPhoto.size() > 0) {
                RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, mActivity);
            }
        }
    }

    /**
     * 保存日志信息
     */
    public void modifyLog() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFY_LOG, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        Intent intent = new Intent();
                        Bundle bundle = new Bundle();
                        bundle.putSerializable("msgEntity", getMsgEntity());
                        intent.putExtras(bundle);
                        setResult(Constance.RESULTCODE_FINISH, intent);
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(mActivity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    if (null != dialog) {
                        dialog.dismiss();
                    }
                }
            }

            @Override
            public void onFailure(HttpException e, String msg) {
                printNetLog(msg, mActivity);
            }
        });
    }

    /**
     * 重新设置msgentity
     *
     * @return
     */
    public MessageEntity getMsgEntity() {
        if (!TextUtils.isEmpty(ed_remarks1.getText().toString().trim())) {
            msgEntity.setMsg_text(ed_remarks1.getText().toString().trim());
        }
        //技术质量工作记录
        if (!TextUtils.isEmpty(ed_remarks2.getText().toString().trim())) {
            msgEntity.setTechno_quali_log(ed_remarks2.getText().toString().trim());
        }


        //温度
        if (!TextUtils.isEmpty(ed_temperature_morning.getText().toString().trim())) {
            msgEntity.setTemp_am(ed_temperature_morning.getText().toString().trim());

        }
        if (!TextUtils.isEmpty(ed_temperature_afternoon.getText().toString().trim())) {
            msgEntity.setTemp_pm(ed_temperature_afternoon.getText().toString().trim());

        }
        //风力
        if (!TextUtils.isEmpty(ed_wind_morning.getText().toString().trim())) {
            msgEntity.setWind_am(ed_wind_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(ed_wind_afternoon.getText().toString().trim())) {
            msgEntity.setWind_pm(ed_wind_afternoon.getText().toString().trim());
        }
        //天气
        if (!TextUtils.isEmpty(tv_weather_morning.getText().toString().trim())) {
            msgEntity.setWeat_am(tv_weather_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(tv_weather_afternoon.getText().toString().trim())) {
            msgEntity.setWeat_pm(tv_weather_afternoon.getText().toString().trim());
        }
        if (null != photos && photos.size() > 0) {
            List<String> temp = new ArrayList<>();
            for (int i = 0; i < photos.size(); i++) {
                temp.add(photos.get(i).imagePath);
                LUtils.e("----------------temp--" + temp.get(i));
            }
            msgEntity.setMsg_src(temp);
        }


        return msgEntity;
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


    private RequestParams getParams() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("msg_id", msg_id);
        params.addBodyParameter("msg_type", msgType);
//        params.addBodyParameter("msg_src","msg_src");
        //生产记录记录情况
        if (!TextUtils.isEmpty(ed_remarks1.getText().toString().trim())) {
            params.addBodyParameter("msg_text", ed_remarks1.getText().toString().trim());
        }
        //技术质量工作记录
        if (!TextUtils.isEmpty(ed_remarks2.getText().toString().trim())) {
            params.addBodyParameter("techno_quali_log", ed_remarks2.getText().toString().trim());
        }


        //温度
        if (!TextUtils.isEmpty(ed_temperature_morning.getText().toString().trim())) {
            params.addBodyParameter("temp_am", ed_temperature_morning.getText().toString().trim());

        }
        if (!TextUtils.isEmpty(ed_temperature_afternoon.getText().toString().trim())) {
            params.addBodyParameter("temp_am", ed_temperature_afternoon.getText().toString().trim());
        }
        //风力
        if (!TextUtils.isEmpty(ed_wind_morning.getText().toString().trim())) {
            params.addBodyParameter("wind_am", ed_wind_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(ed_wind_afternoon.getText().toString().trim())) {
            params.addBodyParameter("wind_pm", ed_wind_afternoon.getText().toString().trim());
        }
        //天气
        if (!TextUtils.isEmpty(tv_weather_morning.getText().toString().trim())) {
            params.addBodyParameter("weat_am", tv_weather_morning.getText().toString().trim());
        }
        if (!TextUtils.isEmpty(tv_weather_afternoon.getText().toString().trim())) {
            params.addBodyParameter("weat_pm", tv_weather_afternoon.getText().toString().trim());
        }
        if (null != stringBuffer && stringBuffer.toString().length() > 1) {
            params.addBodyParameter("delimg", stringBuffer.toString());
        }
        return params;
    }


}

