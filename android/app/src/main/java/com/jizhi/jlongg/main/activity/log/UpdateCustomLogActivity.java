package com.jizhi.jlongg.main.activity.log;

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
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.bigkoo.pickerview.TimePickerView;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SelecteActorActivity;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.MembersNoTagAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.LocationInfo;
import com.jizhi.jlongg.main.bean.LogModeBean;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.WeatherInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
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
import com.jizhi.jongg.widget.MyGridView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * CName:更新日志页2.3.0
 * User: hcs
 * Date: 2017-07-26
 * Time: 17:19
 */
public class UpdateCustomLogActivity extends BaseActivity implements MessageNewLogAdapter.TimeClickListener, View.OnClickListener, OnSquaredImageRemoveClick, AccountPhotoGridAdapter.PhotoDeleteListener {
    private UpdateCustomLogActivity mActivity;
    private ListView listView;
    private GroupDiscussionInfo gnInfo;
    private String cat_id;//模版id
    private List<LogModeBean> logModeBeanList;
    private MessageNewLogAdapter messageNewLogAdapter;
    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    private GridView gridView;
    //选择天气上午，下午
    private SelecteLogWeatherPopWindow popWindowMorning, popWindowAfternoon;
    //1选择的是上午，选择的是下午
    private int weatherMorningOrAfternoon;
    //选中时间，开始时间，结束时间
    private Calendar selectedDate, startDate, endDate;
    private MembersNoTagAdapter executeMemberAdapter;
    //是否选择全部成员
    private boolean isSelectedAll;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_log_new);
        initView();
        getIntentData();
        getApprovalTemplate();
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = UpdateCustomLogActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        findViewById(R.id.right_title).setOnClickListener(this);
        View bottomView = getLayoutInflater().inflate(R.layout.layout_bottom_view_log, null); // 添加底部信息
        listView.addFooterView(bottomView, null, false);
        initExecureGridview(bottomView);

        logModeBeanList = new ArrayList<>();
        messageNewLogAdapter = new MessageNewLogAdapter(mActivity, logModeBeanList, mActivity);
        listView.setAdapter(messageNewLogAdapter);
        messageNewLogAdapter.setUpdateLog(true);
        findViewById(R.id.lin_people).setVisibility(View.VISIBLE);
        findViewById(R.id.executeGridView).setVisibility(View.VISIBLE);
        gridView = (GridView) bottomView.findViewById(R.id.gridView);
        //初始化时间选择器开始跟结束时间
        startDate = Calendar.getInstance();
        startDate.set(2014, 0, 23);
        endDate = Calendar.getInstance();
        endDate.set(2020, 11, 28);
    }

    /**
     * 选择接收人
     */
    public void initExecureGridview(View view) {
        List<GroupMemberInfo> list = (List<GroupMemberInfo>) getIntent().getSerializableExtra("list");
        executeMemberAdapter = new MembersNoTagAdapter(this, list, new AddMemberListener() {
            @Override
            public void add(int state) { //添加执行人
                LUtils.e("uids:" + getExecutePersonUids());
                SelecteActorActivity.actionStart(mActivity, getExecutePersonUids(), getString(R.string.selecte_recive), gnInfo.getGroup_id(), gnInfo.getGroup_name(), gnInfo.getClass_type(), true);
            }

            @Override
            public void remove(int state) { //删除执行人
                isSelectedAll = false;

            }
        });
        GridView gridView = view.findViewById(R.id.executeGridView);
        gridView.setAdapter(executeMemberAdapter);
//        getLastRecUid();
    }

    /**
     * 获取执行人ids
     *
     * @return
     */
    private String getExecutePersonUids() {
        if (executeMemberAdapter != null && executeMemberAdapter.getList() != null && executeMemberAdapter.getList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            for (GroupMemberInfo groupMemberInfo : executeMemberAdapter.getList()) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
            }
            return builder.toString();
        }
        return null;
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        cat_id = getIntent().getStringExtra("cat_id");
        SetTitleName.setTitle(findViewById(R.id.title), "发" + gnInfo.getCat_name());
        TextView tv_pro_name = (TextView) findViewById(R.id.tv_pro_name);
        if (gnInfo.getClass_type().equals("team")) {
            tv_pro_name.setText("当前项目：" + gnInfo.getAll_pro_name());
        } else {
            tv_pro_name.setText("当前班组：" + gnInfo.getAll_pro_name());
        }
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String cat_id, List<LogModeBean> element_list, List<String> msg_src, String receiver_uid, List<GroupMemberInfo> list) {
        Intent intent = new Intent(context, UpdateCustomLogActivity.class);

        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra("cat_id", cat_id);
        intent.putExtra("receiver_uid", receiver_uid);
        Bundle bundle = new Bundle();
        bundle.putSerializable("element_list", (Serializable) element_list);
        bundle.putSerializable("msg_src", (Serializable) msg_src);
        bundle.putSerializable("list", (Serializable) list);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    public void initOrUpDateAdapter() {
        adapter = new SquaredImageAdapter(mActivity, this, photos, 9);
        MyGridView gridView = (MyGridView) findViewById(R.id.gridView);
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
                                ArrayList<String> mSelected = selectedPhotoPath();
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

    /**
     * 获取日志模板
     */
    protected void getApprovalTemplate() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("cat_id", gnInfo.getCat_id());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_APPOVALtTEMPLATE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<LogModeBean> bean = CommonListJson.fromJson(responseInfo.result, LogModeBean.class);
                            if (bean.getState() != 0) {
                                logModeBeanList = bean.getValues();
                                initListData();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            mActivity.finish();
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                    }
                });


    }

    public void initListData() {
        List<LogModeBean> logModeBeen = new ArrayList<>();
        for (int i = 0; i < logModeBeanList.size(); i++) {
            if (!logModeBeanList.get(i).getElement_type().equals("spacer") && !logModeBeanList.get(i).getElement_type().equals("upimg")) {
                logModeBeen.add(logModeBeanList.get(i));
            }
        }
        for (int i = 0; i < logModeBeen.size(); i++) {
            if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXT_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_TEXT);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXTAREA_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_TEXTAREA);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_NUMBER_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_NUMBER);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_SELECT_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_SELECT);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATE_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_DATE);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATEFRAME_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_DATEFRAME);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_WEATHER_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_WEATHER);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOGDATE_STR)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_LOGDATE);
            } else if (logModeBeen.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOG_LOC)) {
                logModeBeen.get(i).setElement_type_number(LogBaseAdapter.TYPE_LOGLOC);
                LUtils.e("-------------有位置了--------");

            }
        }
        logModeBeanList.clear();
        logModeBeanList.addAll(logModeBeen);
        messageNewLogAdapter = new MessageNewLogAdapter(mActivity, logModeBeanList, mActivity);
        listView.setAdapter(messageNewLogAdapter);
        messageNewLogAdapter.setUpdateLog(true);
        LUtils.e("=============================");
        List<LogModeBean> element_list = (List<LogModeBean>) getIntent().getSerializableExtra("element_list");
        LUtils.e("element_list:" + new Gson().toJson(element_list));
        //设置初始默认值
        for (int i = 0; i < logModeBeanList.size(); i++) {
            for (int j = 0; j < element_list.size(); j++) {
                if (logModeBeanList.get(i).getElement_key().equals(element_list.get(j).getElement_key())) {
                    if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXTAREA_STR)
                            || logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_NUMBER_STR)
                            || logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXT_STR)) {
                        //文本框
                        logModeBeanList.get(i).setElement_value(element_list.get(j).getElement_value());
                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_SELECT_STR)) {
                        //单选
                        logModeBeanList.get(i).setElement_value(element_list.get(j).getElement_value());
                        logModeBeanList.get(i).setSelect_id(element_list.get(j).getSelect_id());
                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATEFRAME_STR)) {
                        //TODO 时间此处需要优化
                        //日期多选
                        if (element_list.get(j).getPosition() == 1) {
                            logModeBeanList.get(i).getList().get(0).setElement_value(element_list.get(j).getElement_value());
                            initTime(element_list.get(j).getElement_value(), i, 0, LogBaseAdapter.DATE_TYPE_DAY);
                        } else if (element_list.get(j).getPosition() == 2) {
                            logModeBeanList.get(i).getList().get(1).setElement_value(element_list.get(j).getElement_value());
                            initTime(element_list.get(j).getElement_value(), i, 1, LogBaseAdapter.DATE_TYPE_DAY);
                        }

                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATE_STR)) {
                        //时间单选
                        logModeBeanList.get(i).setElement_value(element_list.get(j).getElement_value());
                        initTime(element_list.get(j).getElement_value(), i, -1, logModeBeanList.get(i).getDate_type());
                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOGDATE_STR)) {
                        logModeBeanList.get(i).setElement_value(element_list.get(j).getElement_value());
                        //发布时间的date_type默认为day
                        initTime(element_list.get(j).getElement_value(), i, -1, LogBaseAdapter.DATE_TYPE_DAY);
                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_WEATHER_STR)) {
                        Gson gson = new Gson();
                        WeatherInfo weatherInfo = gson.fromJson(element_list.get(j).getWeather_value(), WeatherInfo.class);
                        logModeBeanList.get(i).setWeather_info(weatherInfo);
                    } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOG_LOC)) {
                        Gson gson = new Gson();
                        if (!TextUtils.isEmpty(element_list.get(j).getElement_value())) {
                            LocationInfo info = gson.fromJson(element_list.get(j).getElement_value(), LocationInfo.class);
                            localStr = element_list.get(j).getElement_value();
                            if (!TextUtils.isEmpty(info.getAddress()) && !TextUtils.isEmpty(info.getName())) {
                                logModeBeanList.get(i).setElement_value(info.getAddress() + "\n" + info.getName());
                            } else if (TextUtils.isEmpty(info.getAddress()) && !TextUtils.isEmpty(info.getName())) {
                                logModeBeanList.get(i).setElement_value(info.getName());
                            } else if (!TextUtils.isEmpty(info.getAddress()) && TextUtils.isEmpty(info.getName())) {
                                logModeBeanList.get(i).setElement_value(info.getAddress());
                            }
                        }
                    }
                }
            }
        }
        messageNewLogAdapter.notifyDataSetChanged();

        List<String> imagePaths = getIntent().getStringArrayListExtra("msg_src");
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
        initOrUpDateAdapter();
    }

    private String localStr;

    public void initTime(String element_value, int position, int childPosition, String date_type) {
        try {
            if (childPosition == -1) {
                LUtils.e("---------发布时间--22----" + logModeBeanList.get(position).getDate_type());
                if (date_type.equals(LogBaseAdapter.DATE_TYPE_DAY)) {
                    // 日期 yyyy-mm-dd
                    String[] time = element_value.split("-");
                    if (time.length == 3) {
                        logModeBeanList.get(position).getDateAndTime().setYear(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getDateAndTime().setMonth(Integer.parseInt(time[1]));
                        logModeBeanList.get(position).getDateAndTime().setDayOfMonth(Integer.parseInt(time[2]));
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
                    //时间 H:i
                    String[] time = element_value.split(":");
                    if (time.length == 2) {

                        Calendar calendar = Calendar.getInstance();
                        //没有年月日的情况下需要手动设置一个年月日
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(calendar.get(Calendar.YEAR));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(calendar.get(Calendar.MONTH));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setHourOfDay(calendar.get(Calendar.DAY_OF_MONTH));
                        //-------------------------------------

                        logModeBeanList.get(position).getDateAndTime().setHourOfDay(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getDateAndTime().setMinute(Integer.parseInt(time[1]));
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
                    //日期和时间 yyyy-mm-dd H:i
                    String[] split = element_value.split(" ");
                    String[] startTime = split[0].split("-");
                    String[] endTime = split[1].split(":");
                    if (startTime.length == 3) {
                        logModeBeanList.get(position).getDateAndTime().setYear(Integer.parseInt(startTime[0]));
                        logModeBeanList.get(position).getDateAndTime().setMonth(Integer.parseInt(startTime[1]));
                        logModeBeanList.get(position).getDateAndTime().setDayOfMonth(Integer.parseInt(startTime[2]));
                    }
                    if (endTime.length == 2) {
                        logModeBeanList.get(position).getDateAndTime().setHourOfDay(Integer.parseInt(endTime[0]));
                        logModeBeanList.get(position).getDateAndTime().setMinute(Integer.parseInt(endTime[1]));
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
                    // 年月yyyy-mm
                    String[] time = element_value.split("-");
                    if (time.length == 2) {
                        logModeBeanList.get(position).getDateAndTime().setYear(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getDateAndTime().setMonth(Integer.parseInt(time[1]) + 1);
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
                    //年 yyyy
                    logModeBeanList.get(position).getDateAndTime().setYear(Integer.parseInt(element_value) + 1);
                }


            } else {
                LUtils.e("---------发布时间--22----" + logModeBeanList.get(position).getDate_type());
                if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_DAY)) {
                    // 日期 yyyy-mm-dd
                    String[] time = element_value.split("-");
                    if (time.length == 3) {
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(Integer.parseInt(time[1]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setDayOfMonth(Integer.parseInt(time[2]));
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
                    //时间 H:i
                    String[] time = element_value.split(":");
                    LUtils.e(time + "---------//时间 H:i----------------");
                    if (time.length == 2) {

                        Calendar calendar = Calendar.getInstance();
                        //没有年月日的情况下需要手动设置一个年月日
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(calendar.get(Calendar.YEAR));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(calendar.get(Calendar.MONTH));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setHourOfDay(calendar.get(Calendar.DAY_OF_MONTH));
                        //-------------------------------------


                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setHourOfDay(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMinute(Integer.parseInt(time[1]));
                        LUtils.e(time[0] + "---------//时间 H:i----------------" + time[1]);

                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
                    //日期和时间 yyyy-mm-dd H:i
                    String[] split = element_value.split(" ");
                    String[] startTime = split[0].split("-");
                    String[] endTime = split[1].split(":");
                    if (startTime.length == 3) {
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(Integer.parseInt(startTime[0]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(Integer.parseInt(startTime[1]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setDayOfMonth(Integer.parseInt(startTime[2]));
                    }
                    if (endTime.length == 2) {
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setHourOfDay(Integer.parseInt(endTime[0]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMinute(Integer.parseInt(endTime[1]));
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
                    // 年月yyyy-mm
                    String[] time = element_value.split("-");
                    if (time.length == 2) {
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(Integer.parseInt(time[0]));
                        logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(Integer.parseInt(time[1]) + 1);
                    }
                } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
                    //年 yyyy
                    logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(Integer.parseInt(element_value) + 1);
                }
            }
        } catch (Exception e) {
            e.getMessage();
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == Constance.REQUEST) {
            //单行选择框
            int position = data.getIntExtra("position", -1);
            if (position != -1) {
                List<ProjectLevel> list = (List<ProjectLevel>) data.getSerializableExtra("list");
                logModeBeanList.get(position).setSelect_value_list(list);
                logModeBeanList.get(position).setElement_value(data.getStringExtra("text"));
                logModeBeanList.get(position).setElement_id(data.getStringExtra("id"));
                messageNewLogAdapter.notifyDataSetChanged();
            }
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
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
        } else if (resultCode == Constance.SELECTED_ACTOR) { //选择执行者
            List<GroupMemberInfo> groupMemberInfos = (List<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            executeMemberAdapter.updateListView(groupMemberInfos);
            isSelectedAll = data.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            LUtils.e(new Gson().toJson("-------选择执行者---------" + new Gson().toJson(groupMemberInfos)));
        }

    }

    /**
     * 时间开始
     *
     * @param position
     */
    @Override
    public void startTimeClick(int position, int childposition) {
        selectedDate = Calendar.getInstance();
        if (TextUtils.isEmpty(logModeBeanList.get(position).getList().get(childposition).getElement_value())) {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, selectedDate.get(Calendar.YEAR));
            selectedDate.set(Calendar.MONTH, selectedDate.get(Calendar.MONTH));
            selectedDate.set(Calendar.DAY_OF_MONTH, selectedDate.get(Calendar.DAY_OF_MONTH));
            selectedDate.set(Calendar.HOUR_OF_DAY, selectedDate.get(Calendar.HOUR_OF_DAY));
            selectedDate.set(Calendar.MINUTE, selectedDate.get(Calendar.MINUTE));
            showPickerViewStyle(position, childposition);

            LUtils.e(selectedDate.get(Calendar.HOUR_OF_DAY) + "--------startTimeClick-11--------------" + selectedDate.get(Calendar.MINUTE));
        } else {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getYear());
            selectedDate.set(Calendar.MONTH, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getMonth() - 1);
            selectedDate.set(Calendar.DAY_OF_MONTH, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getDayOfMonth());
            selectedDate.set(Calendar.HOUR_OF_DAY, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getHourOfDay());
            selectedDate.set(Calendar.MINUTE, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getMinute());
            LUtils.e(logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getHourOfDay() + "--------startTimeClick-22--------------" + logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getMinute());
            showPickerViewStyle(position, childposition);
        }
    }

    /**
     * 时间结束
     *
     * @param position
     */
    @Override
    public void endTimeClick(int position, int childposition) {
        //判断是否选择了开始时间，没有选择就提示
        if (TextUtils.isEmpty(logModeBeanList.get(position).getList().get(0).getElement_value())) {
            CommonMethod.makeNoticeLong(mActivity, "请选择" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.ERROR);
            return;
        }
        selectedDate = Calendar.getInstance();
        if (TextUtils.isEmpty(logModeBeanList.get(position).getList().get(childposition).getElement_value())) {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, selectedDate.get(Calendar.YEAR));
            selectedDate.set(Calendar.MONTH, selectedDate.get(Calendar.MONTH));
            selectedDate.set(Calendar.DAY_OF_MONTH, selectedDate.get(Calendar.DAY_OF_MONTH));
            selectedDate.set(Calendar.HOUR_OF_DAY, selectedDate.get(Calendar.HOUR_OF_DAY));
            selectedDate.set(Calendar.MINUTE, selectedDate.get(Calendar.MINUTE));
            showPickerViewStyle(position, childposition);
        } else {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getYear());
            selectedDate.set(Calendar.MONTH, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getMonth() - 1);
            selectedDate.set(Calendar.DAY_OF_MONTH, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getDayOfMonth());
            selectedDate.set(Calendar.HOUR_OF_DAY, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getHourOfDay());
            selectedDate.set(Calendar.MINUTE, logModeBeanList.get(position).getList().get(childposition).getDateAndTime().getMinute());
            showPickerViewStyle(position, childposition);
        }
    }

    /**
     * 时间单选
     *
     * @param position
     */
    @Override
    public void singleTimeClick(int position) {
        selectedDate = Calendar.getInstance();
        if (TextUtils.isEmpty(logModeBeanList.get(position).getElement_value())) {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, selectedDate.get(Calendar.YEAR));
            selectedDate.set(Calendar.MONTH, selectedDate.get(Calendar.MONTH));
            selectedDate.set(Calendar.DAY_OF_MONTH, selectedDate.get(Calendar.DAY_OF_MONTH));
            selectedDate.set(Calendar.HOUR_OF_DAY, selectedDate.get(Calendar.HOUR_OF_DAY));
            selectedDate.set(Calendar.MINUTE, selectedDate.get(Calendar.MINUTE));
            LUtils.e(selectedDate.get(Calendar.HOUR_OF_DAY) + "--------------------111---------" + selectedDate.get(Calendar.MINUTE));
            showPickerViewStyle(position, -1);
        } else {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, logModeBeanList.get(position).getDateAndTime().getYear());
            selectedDate.set(Calendar.MONTH, logModeBeanList.get(position).getDateAndTime().getMonth() - 1);
            selectedDate.set(Calendar.DAY_OF_MONTH, logModeBeanList.get(position).getDateAndTime().getDayOfMonth());
            selectedDate.set(Calendar.HOUR_OF_DAY, logModeBeanList.get(position).getDateAndTime().getHourOfDay());
            selectedDate.set(Calendar.MINUTE, logModeBeanList.get(position).getDateAndTime().getMinute());
            showPickerViewStyle(position, -1);
        }

    }


    /**
     * 日志发送时间
     *
     * @param position
     */
    @Override
    public void sendTimeClick(int position) {
        hideSoftKeyboard();
        selectedDate = Calendar.getInstance();
        if (TextUtils.isEmpty(logModeBeanList.get(position).getElement_value())) {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, selectedDate.get(Calendar.YEAR));
            selectedDate.set(Calendar.MONTH, selectedDate.get(Calendar.MONTH));
            selectedDate.set(Calendar.DAY_OF_MONTH, selectedDate.get(Calendar.DAY_OF_MONTH));
            showTimePickView(position, -1, true, true, true, false, false);
        } else {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, logModeBeanList.get(position).getDateAndTime().getYear());
            selectedDate.set(Calendar.MONTH, logModeBeanList.get(position).getDateAndTime().getMonth() - 1);
            selectedDate.set(Calendar.DAY_OF_MONTH, logModeBeanList.get(position).getDateAndTime().getDayOfMonth());
            showTimePickView(position, -1, true, true, true, false, false);
        }

    }

    /**
     * 时间显示的样式设置
     *
     * @param position
     * @param childPosition
     */
    public void showPickerViewStyle(int position, int childPosition) {
        if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_DAY)) {
            // 日期 yyyy-mm-dd
            showTimePickView(position, childPosition, true, true, true, false, false);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
            //时间 H:i
            showTimePickView(position, childPosition, false, false, false, true, true);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
            //日期和时间 yyyy-mm-dd H:i
            showTimePickView(position, childPosition, true, true, true, true, true);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
            // 年月yyyy-mm
            showTimePickView(position, childPosition, true, true, false, false, false);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
            //年 yyyy
            showTimePickView(position, childPosition, true, false, false, false, false);
        }
    }

    /**
     * 显示时间view
     *
     * @param position            listview下标
     * @param childPosition       时间多选开始或者结束下标 0：开始 1：借宿
     * @param isVisibleYear       是否显示年
     * @param isVisibleMonth      是否显月
     * @param isVisibleDayOfmonth 是否日
     * @param isVisibleHourOfDay  是否时
     * @param isVisibleMinute     是否分
     */
    public void showTimePickView(final int position, final int childPosition, boolean isVisibleYear, boolean isVisibleMonth, boolean isVisibleDayOfmonth, boolean isVisibleHourOfDay, boolean isVisibleMinute) {
        TimePickerView pvTime = new TimePickerView.Builder(this, new TimePickerView.OnTimeSelectListener() {
            @Override
            public void onTimeSelect(Date date, View v) {
                //选中事件回调
                setListTime(date, position, childPosition);

            }
        })
                //年月日时分秒 的显示与否，不设置则默认全部显示
                .setType(new boolean[]{isVisibleYear, isVisibleMonth, isVisibleDayOfmonth, isVisibleHourOfDay, isVisibleMinute, false})
                .setCancelText("取消")
                .setSubmitText("确定")
                .setTitleText("请选择时间")
                .setCancelColor(getResources().getColor(R.color.white))
                .setSubmitColor(getResources().getColor(R.color.white))
                .setTitleColor(getResources().getColor(R.color.white))
                .setTitleBgColor(getResources().getColor(R.color.app_color))//标题背景颜色 Night mode
                .setSubCalSize(14)//确定取消字体大小
                .setTitleSize(16)
                .setOutSideCancelable(true)
                .isCyclic(false)
                .setContentSize(18)
                .setTextColorCenter(getResources().getColor(R.color.app_color))
                .isCenterLabel(false) //是否只显示中间选中项的label文字，false则每项item全部都带有label。
                .setDividerColor(getResources().getColor(R.color.app_color))
                .setDate(selectedDate)
                .setRangDate(startDate, endDate)
                .setBackgroundId(0x66000000) //设置外部遮罩颜色
                .setDecorView(null)
                .build();

        pvTime.show();
        LUtils.e(selectedDate.get(Calendar.HOUR_OF_DAY) + "--------------------2222---------" + selectedDate.get(Calendar.MINUTE));
    }

    /**
     * 解析选择时间以及数据显示
     *
     * @param date
     * @param position
     * @param childPosition
     */
    private void setListTime(Date date, int position, final int childPosition) {
        //解析选中时间的 年月日时分
        int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
        int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
        int dayOfMonth = Integer.parseInt(new SimpleDateFormat("dd").format(date));
        int houtOfDay = Integer.parseInt(new SimpleDateFormat("HH").format(date));
        int minute = Integer.parseInt(new SimpleDateFormat("mm").format(date));
        String timeFont = year + "-" + (month < 10 ? "0" + month : month) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth);
        String timeBack = (houtOfDay < 10 ? "0" + houtOfDay : houtOfDay) + ":" + (minute < 10 ? "0" + minute : minute);
        LUtils.e("--------getElement_type---------------" + logModeBeanList.get(position).getElement_type());
        if (logModeBeanList.get(position).getElement_type().equals(LogBaseAdapter.TYPE_LOGDATE_STR)) {
            String values = year + "-" + (month < 10 ? "0" + month : month) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth);
            Calendar calendarN = Calendar.getInstance();
            int yearN = calendarN.get(Calendar.YEAR);
            int monthN = calendarN.get(Calendar.MONTH) + 1;
            int dayOfMonthN = calendarN.get(Calendar.DAY_OF_MONTH);
            String valuesN = yearN + "-" + (monthN < 10 ? "0" + monthN : monthN) + "-" + (dayOfMonthN < 10 ? "0" + dayOfMonthN : dayOfMonthN);
            // 日期 yyyy-mm-dd
            long selectTime = TimesUtils.strToLongYYYYMMDD(values);
            long nowTime = TimesUtils.strToLongYYYYMMDD(valuesN);
            if (selectTime > nowTime) {
                CommonMethod.makeNoticeShort(mActivity, "不能选择今天以后的时间", CommonMethod.SUCCESS);
                return;
            }
            //发布时间单个
            logModeBeanList.get(position).getDateAndTime().setYear(year);
            logModeBeanList.get(position).getDateAndTime().setMonth(month);
            logModeBeanList.get(position).getDateAndTime().setDayOfMonth(dayOfMonth);
            logModeBeanList.get(position).setElement_value(year + "-" + (month < 10 ? "0" + month : month) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth));
            messageNewLogAdapter.notifyDataSetChanged();
        } else if (logModeBeanList.get(position).getElement_type().equals(LogBaseAdapter.TYPE_DATE_STR)) {
            if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_DAY)) {
                // 日期 yyyy-mm-dd
                logModeBeanList.get(position).setElement_value(timeFont);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
                //时间 H:i
                logModeBeanList.get(position).setElement_value(timeBack);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
                //日期和时间 yyyy-mm-dd H:i
                logModeBeanList.get(position).setElement_value(timeFont + " " + timeBack);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
                // 年月yyyy-mm
                logModeBeanList.get(position).setElement_value(year + "-" + (month < 10 ? "0" + month : month));
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
                //年 yyyy
                logModeBeanList.get(position).setElement_value(year + "");
            }

            //时间单个
            logModeBeanList.get(position).getDateAndTime().setYear(year);
            logModeBeanList.get(position).getDateAndTime().setMonth(month);
            logModeBeanList.get(position).getDateAndTime().setDayOfMonth(dayOfMonth);
            logModeBeanList.get(position).getDateAndTime().setHourOfDay(houtOfDay);
            logModeBeanList.get(position).getDateAndTime().setMinute(minute);
            messageNewLogAdapter.notifyDataSetChanged();
        } else if (logModeBeanList.get(position).getElement_type().equals(LogBaseAdapter.TYPE_DATEFRAME_STR)) {

            if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_DAY)) {
                if (childPosition == 0 && !isEndTimeBig(timeFont, logModeBeanList.get(position).getList().get(1).getElement_value(), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                } else if (childPosition == 1 && !isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), timeFont, position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                }
                LUtils.e(isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), timeFont, position) + "--------getElement_type-----22----------" + logModeBeanList.get(position).getDate_type());
                // 日期 yyyy-mm-dd
                logModeBeanList.get(position).getList().get(childPosition).setElement_value(timeFont);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
                //时间 H:i
                if (childPosition == 1 && !isEndTimeBig(timeBack, logModeBeanList.get(position).getList().get(1).getElement_value(), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                } else if (childPosition == 1 && !isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), timeBack, position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                }
                logModeBeanList.get(position).getList().get(childPosition).setElement_value(timeBack);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
                //日期和时间 yyyy-mm-dd H:i
                if (childPosition == 0 && !isEndTimeBig(timeFont + " " + timeBack, logModeBeanList.get(position).getList().get(0).getElement_value(), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                } else if (childPosition == 1 && !isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), timeFont + " " + timeBack, position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                }
                logModeBeanList.get(position).getList().get(childPosition).setElement_value(timeFont + " " + timeBack);
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
                // 年月yyyy-mm
                if (childPosition == 0 && !isEndTimeBig(year + "-" + (month < 10 ? "0" + month : month), logModeBeanList.get(position).getList().get(1).getElement_value(), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                } else if (childPosition == 1 && !isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), year + "-" + (month < 10 ? "0" + month : month), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                }
                logModeBeanList.get(position).getList().get(childPosition).setElement_value(year + "-" + (month < 10 ? "0" + month : month));
            } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
                //年 yyyy
                if (childPosition == 0 && !isEndTimeBig(year + "", logModeBeanList.get(position).getList().get(1).getElement_value(), position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                } else if (childPosition == 1 && !isEndTimeBig(logModeBeanList.get(position).getList().get(0).getElement_value(), year + "", position)) {
                    CommonMethod.makeNoticeShort(mActivity, logModeBeanList.get(position).getList().get(1).getElement_name() + "必须大于" + logModeBeanList.get(position).getList().get(0).getElement_name(), CommonMethod.SUCCESS);
                    return;
                }
                logModeBeanList.get(position).getList().get(childPosition).setElement_value(year + "");
            }
            //时间两个
            logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setYear(year);
            logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMonth(month);
            logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setDayOfMonth(dayOfMonth);
            logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setHourOfDay(houtOfDay);
            logModeBeanList.get(position).getList().get(childPosition).getDateAndTime().setMinute(minute);
            messageNewLogAdapter.notifyDataSetChanged();
        }
    }


    /**
     * 判断当前时间与本地时间谁大 当前时间大返回true需要跟新
     *
     * @return
     */
    public boolean isEndTimeBig(String startTime, String endTime, int position) {

        long starttime = 0;
        long endtime = 0;

        if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_DAY)) {
            // 日期 yyyy-mm-dd
            starttime = TimesUtils.strToLongYYYYMMDD(startTime);
            endtime = TimesUtils.strToLongYYYYMMDD(endTime);

        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_TIME)) {
            //时间 H:i
            starttime = TimesUtils.strToLongHHMM(startTime);
            endtime = TimesUtils.strToLongHHMM(endTime);

        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_ALL)) {
            //日期和时间 yyyy-mm-dd H:i
            starttime = TimesUtils.strToLongYYYYMMDDHHMM(startTime);
            endtime = TimesUtils.strToLongYYYYMMDDHHMM(endTime);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_MONTH)) {
            // 年月yyyy-mm
            starttime = TimesUtils.strToLongYYYYMM(startTime);
            endtime = TimesUtils.strToLongYYYYMM(endTime);
        } else if (logModeBeanList.get(position).getDate_type().equals(LogBaseAdapter.DATE_TYPE_YEAR)) {
            //年 yyyy
            starttime = TimesUtils.strToLongYYYY(startTime);
            endtime = TimesUtils.strToLongYYYY(endTime);
        }
        LUtils.e(startTime + "---------------:" + endTime);
        LUtils.e(starttime + "---------------:" + endtime);
        if (endtime >= starttime || endtime == 0) {
            LUtils.e(starttime + "----------true-----:" + endtime);
            return true;
        }
        return false;
    }

    @Override
    public void setEditText(int position, String str, boolean isWeather, String weatherType) {
        LUtils.e("--------------------str:" + position);
        if (isWeather) {
            //天气输入框变化监听
            if (null == logModeBeanList.get(position).getWeather_info()) {
                WeatherInfo weatherInfo = new WeatherInfo();
                logModeBeanList.get(position).setWeather_info(weatherInfo);
            }
            if (weatherType.equals("wind_am")) {
                logModeBeanList.get(position).getWeather_info().setWind_am(str);
            } else if (weatherType.equals("wind_pm")) {
                logModeBeanList.get(position).getWeather_info().setWind_pm(str);
            } else if (weatherType.equals("temp_am")) {
                logModeBeanList.get(position).getWeather_info().setTemp_am(str);
            } else if (weatherType.equals("temp_pm")) {
                logModeBeanList.get(position).getWeather_info().setTemp_pm(str);
            }

            LUtils.e("--------------------str:" + str);
        } else {
            //其他文本类型输入框变化监听
            logModeBeanList.get(position).setElement_value(str);
        }

    }

    private int weatherPosition;

    public void selectedWathers(WeatherAttribute attribute1, WeatherAttribute attribute2) {
        String attribute2Name = "";
        LUtils.e(new Gson().toJson(attribute1) + ",,,," + new Gson().toJson(attribute2));
        if (null != attribute2) {
            attribute2Name = attribute2.getWeatherName();
        }
        if (null == logModeBeanList.get(weatherPosition).getWeather_info()) {
            WeatherInfo weatherInfo = new WeatherInfo();
            logModeBeanList.get(weatherPosition).setWeather_info(weatherInfo);
        }
        if (weatherMorningOrAfternoon == 1) {
            if (!TextUtils.isEmpty(attribute2Name)) {
                logModeBeanList.get(weatherPosition).getWeather_info().setWeat_am(attribute1.getWeatherName() + ">" + attribute2.getWeatherName());
            } else {
                logModeBeanList.get(weatherPosition).getWeather_info().setWeat_am(attribute1.getWeatherName());
            }
        } else if (weatherMorningOrAfternoon == 2) {
            if (!TextUtils.isEmpty(attribute2Name)) {
                logModeBeanList.get(weatherPosition).getWeather_info().setWeat_pm(attribute1.getWeatherName() + ">" + attribute2.getWeatherName());
            } else {
                logModeBeanList.get(weatherPosition).getWeather_info().setWeat_pm(attribute1.getWeatherName());
            }
        }
        messageNewLogAdapter.notifyDataSetChanged();
    }


    @Override
    public void setWeatherClick(int position, int id) {
        switch (id) {
            case R.id.tv_weather_morning:
                hideSoftKeyboard();
                weatherMorningOrAfternoon = 1;
                logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_amAnim(true);
                logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_pmAnim(false);
                messageNewLogAdapter.notifyDataSetChanged();
                if (popWindowMorning == null) {
                    popWindowMorning = new SelecteLogWeatherPopWindow(mActivity, new SelecteLogWeatherPopWindow.SelectedWeatherListener() {
                        @Override
                        public void selectedWather(WeatherAttribute attribute1, WeatherAttribute attribute2) {
                            selectedWathers(attribute1, attribute2);
                        }

                        @Override
                        public void dismissWather() {
                            logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_amAnim(false);
                            logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_pmAnim(false);
                            messageNewLogAdapter.notifyDataSetChanged();


                        }
                    });
                }
                popWindowMorning.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                weatherPosition = position;

                break;
            case R.id.tv_weather_afternoon:
                //下午天气
                hideSoftKeyboard();
                weatherMorningOrAfternoon = 2;
                logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_amAnim(false);
                logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_pmAnim(true);
                messageNewLogAdapter.notifyDataSetChanged();
                if (popWindowAfternoon == null) {
                    popWindowAfternoon = new SelecteLogWeatherPopWindow(mActivity, new SelecteLogWeatherPopWindow.SelectedWeatherListener() {
                        @Override
                        public void selectedWather(WeatherAttribute attribute1, WeatherAttribute attribute2) {
                            selectedWathers(attribute1, attribute2);
                        }

                        @Override
                        public void dismissWather() {
                            logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_amAnim(false);
                            logModeBeanList.get(weatherPosition).getWeather_info().setShowWear_pmAnim(false);
                            messageNewLogAdapter.notifyDataSetChanged();


                        }
                    });
                }
                popWindowAfternoon.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                weatherPosition = position;
                break;
        }
    }

    @Override
    public void location() {

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                FileUpData();
                break;
        }
    }

    RequestParams params;

    public void FileUpData() {
        params = RequestParamsToken.getExpandRequestParams(mActivity);

//
        for (int i = 0; i < logModeBeanList.size(); i++) {
            //列表
            if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_SELECT_STR)) {
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请选择" + logModeBeanList.get(i).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getSelect_id());
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATEFRAME_STR)) {
                //时间多选
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getList().get(0).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请选择" + logModeBeanList.get(i).getList().get(0).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getList().get(1).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请选择" + logModeBeanList.get(i).getList().get(1).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(logModeBeanList.get(i).getList().get(0).getElement_value()) && !TextUtils.isEmpty(logModeBeanList.get(i).getList().get(1).getElement_value())) {
                    String values = logModeBeanList.get(i).getList().get(0).getElement_value() + "," + logModeBeanList.get(i).getList().get(1).getElement_value();
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), values);
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_DATE_STR)) {
                //时间单选
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请选择" + logModeBeanList.get(i).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getElement_value());
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXTAREA_STR) || logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_TEXT_STR)) {
                //单行多行输入框
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    LUtils.e("-------00-----------------");
                    CommonMethod.makeNoticeLong(mActivity, "请输入" + logModeBeanList.get(i).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                String length_range = logModeBeanList.get(i).getLength_range();
                String[] strings = length_range.split(",");
                LUtils.e(length_range + "-------11-----------------" + strings.length + ",,,," + logModeBeanList.get(i).getElement_value());
                LUtils.e("-------11a-----------------" + i);
                if (!TextUtils.isEmpty(length_range) && length_range.length() > 1 && (length_range.endsWith(",") || strings.length == 2)) {
                    if (strings.length == 2) {
                        if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value()) && !TextUtils.isEmpty(strings[0]) && logModeBeanList.get(i).getElement_value().length() < Integer.parseInt(strings[0])) {
                            CommonMethod.makeNoticeLong(mActivity, logModeBeanList.get(i).getElement_name() + "长度不能小于" + strings[0] + "个字", CommonMethod.ERROR);
                            return;
                        }
                    } else {
                        if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value()) && !TextUtils.isEmpty(length_range.replace(",", "")) && logModeBeanList.get(i).getElement_value().length() < Integer.parseInt(length_range.replace(",", ""))) {
                            CommonMethod.makeNoticeLong(mActivity, logModeBeanList.get(i).getElement_name() + "长度不能小于" + length_range.replace(",", "") + "个字", CommonMethod.ERROR);
                            return;
                        }
                        LUtils.e(length_range.replace(",", "") + "-------22-----------------" + strings.length);

                    }
                }
                if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getElement_value());
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_NUMBER_STR)) {
                //数字输入框
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请输入" + logModeBeanList.get(i).getElement_name(), CommonMethod.ERROR);
                    return;
                }
                //如果包含小数并且最后一位是点就把点去掉
                if (logModeBeanList.get(i).getElement_value().endsWith(".")) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getElement_value().replace(".", ""));
                } else {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getElement_value());
                }

            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_WEATHER_STR)) {
                //天气
                if (logModeBeanList.get(i).getIs_require() == 1 && null == logModeBeanList.get(i).getWeather_info()) {
                    CommonMethod.makeNoticeLong(mActivity, "天气请输入完整", CommonMethod.ERROR);
                    return;
                }
                if (null != logModeBeanList.get(i).getWeather_info()) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), new Gson().toJson(logModeBeanList.get(i).getWeather_info()));
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOGDATE_STR)) {
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "请选择发布时间", CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), logModeBeanList.get(i).getElement_value());
                }
            } else if (logModeBeanList.get(i).getElement_type().equals(LogBaseAdapter.TYPE_LOG_LOC)) {
                if (logModeBeanList.get(i).getIs_require() == 1 && TextUtils.isEmpty(logModeBeanList.get(i).getElement_value())) {
                    CommonMethod.makeNoticeLong(mActivity, "定位失败", CommonMethod.ERROR);
                    return;
                }

                if (!TextUtils.isEmpty(localStr)) {
                    params.addBodyParameter(logModeBeanList.get(i).getElement_key(), localStr);
                }
            }
        }
        String receiver_uid = getIntent().getStringExtra("receiver_uid");
        if (!TextUtils.isEmpty(receiver_uid)) {
            params.addBodyParameter("rec_uid", receiver_uid);
        }
        params.addBodyParameter("cat_id", gnInfo.getCat_id());
        params.addBodyParameter("id", gnInfo.getId() + "");
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        //接收对象
        if (isSelectedAll) {
            params.addBodyParameter("rec_uid", "-1");
        } else {
            if (!TextUtils.isEmpty(getSelecteExecuteIds())) {
                params.addBodyParameter("rec_uid", getSelecteExecuteIds());
            }
        }
        if (null != stringBuffer && stringBuffer.toString().

                length() > 1) {
            params.addBodyParameter("delimg", stringBuffer.toString());
        }

        createCustomDialog();

        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                List<String> tempPhoto = null;
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
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
//                    }
                }
                Message message = Message.obtain();
                message.obj = params;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        });
        thread.start();
    }

    /**
     * 获取已选的执行人id
     *
     * @return
     */
    private String getSelecteExecuteIds() {
        if (executeMemberAdapter != null && executeMemberAdapter.getList() != null && executeMemberAdapter.getList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            List<GroupMemberInfo> memberList = executeMemberAdapter.getList();
            for (GroupMemberInfo groupMemberInfo : memberList) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
            }
            return builder.toString();
        } else {
            return null;
        }
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    releaseLog();
                    break;
            }

        }
    };

    /**
     * 发布日志
     */

    protected void releaseLog() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PUBLOG,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                mActivity.setResult(Constance.RESULTCODE_FINISH, getIntent());
                                finish();
                                CommonMethod.makeNoticeShort(mActivity, "发送成功", CommonMethod.SUCCESS);
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        finish();
                        closeDialog();
                    }
                });
    }

    StringBuffer stringBuffer;

    @Override
    public void remove(int position) {
        if (!photos.get(position).imagePath.contains("/storage/")) {
            if (null == stringBuffer) {
                stringBuffer = new StringBuffer();
            }
            LUtils.e("删除了---------------------");
            stringBuffer.append(photos.get(position).imagePath + ",");
        } else {
            LUtils.e("没有删除-----------------");
        }
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }

    @Override
    public void imageSizeIsZero() {

    }

}
