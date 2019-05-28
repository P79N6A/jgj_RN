package com.jizhi.jlongg.main.activity.task;

import android.Manifest;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.TextView;
import android.widget.TimePicker;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SelecteActorActivity;
import com.jizhi.jlongg.main.activity.SelectePriniActivity;
import com.jizhi.jlongg.main.activity.SingleSelectedActivity;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.TaskDetail;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton.FileUtils;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static anet.channel.util.Utils.context;


/**
 * CName:发布任务
 * User: xuj
 * Date: 2017年6月7日
 * Time: 10:08:35
 */
public class PubliskTaskActivity extends BaseActivity implements View.OnClickListener, AdapterView.OnItemClickListener {

    /**
     * 图片适配器
     */
    private SquaredImageAdapter adapter;
    /**
     * 图片最大上传数
     */
    private final int MAXPHOTOCOUNT = 9;
    /**
     * 图片数据
     */
    private List<ImageItem> imageItems = new ArrayList<>();
    /**
     * 紧急状态数据
     */
    private List<SingleSelected> emergencyList;
    /**
     * 负责人、参与者适配器
     */
    private MemberRecyclerViewAdapter principalAdapter, actorAdapter;
    /**
     * 任务内容
     */
    private EditText taskContentEdit;
    /**
     * 完成时间、紧急程度
     */
    private TextView completeTimeText, emergencyText;
    /**
     * 提交时需要转换的年、月、日、时、分
     */
    private int year, month, day, hour, minute;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = context.getIntent();
        intent.setClass(context, PubliskTaskActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.publish_task);
        initView();
        initHorizontalWeight();
        initWorkReportImageAdapter();
    }


    private void initView() {
        setTextTitleAndRight(R.string.publish_task, R.string.publish);
        taskContentEdit = (EditText) findViewById(R.id.taskContentEdit);
        completeTimeText = (TextView) findViewById(R.id.completeTimeText);
        emergencyText = (TextView) findViewById(R.id.emergencyText);
        TextView groupName = getTextView(R.id.groupName);
        groupName.setText("当前项目:" + getIntent().getStringExtra(Constance.GROUP_NAME));
    }

    /**
     * 初始化图片数据
     */
    public void initWorkReportImageAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.taskGridView);
            adapter = new SquaredImageAdapter(this, new OnSquaredImageRemoveClick() {
                @Override
                public void remove(int position) { //图片删除按钮回调
                    imageItems.remove(position);
                    adapter.notifyDataSetChanged();
                }
            }, imageItems, MAXPHOTOCOUNT);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(this);
        } else {
            adapter.notifyDataSetChanged();
        }
    }

    /**
     * 初始化责任人组件
     */
    private void initPrincipalWeight() {
        RecyclerView principalListView = (RecyclerView) findViewById(R.id.principalListView); //负责人
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        DefaultItemAnimator animator = new DefaultItemAnimator();
        principalListView.setLayoutManager(linearLayoutManager);
        principalListView.setItemAnimator(animator);

        principalAdapter = new MemberRecyclerViewAdapter(this);
        principalAdapter.setShowUserName(true);
        principalAdapter.setAddPerson(true);
        principalAdapter.setAddPrini(true);
        principalListView.setAdapter(principalAdapter);
        principalAdapter.setOnItemClickLitener(new MemberRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                SelectePriniActivity.actionStart(PubliskTaskActivity.this, getprincipalUid());
            }
        });
    }

    /**
     * 初始化参与者组件
     */
    private void initactorWeight() {
        RecyclerView actorListView = (RecyclerView) findViewById(R.id.actorListView); //参与者
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        DefaultItemAnimator animator = new DefaultItemAnimator();

        actorListView.setLayoutManager(linearLayoutManager);
        actorListView.setItemAnimator(animator); // 设置item动画

        actorAdapter = new MemberRecyclerViewAdapter(this);
        actorAdapter.setShowUserName(true);
        actorAdapter.setAddPerson(true);
        actorListView.setAdapter(actorAdapter);

        actorAdapter.setOnItemClickLitener(new MemberRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                List<GroupMemberInfo> list = actorAdapter.getSelectList();
                if (list == null || list.size() == 0 || list.size() == position) {
                    SelecteActorActivity.actionStart(PubliskTaskActivity.this, getActorUids(), getString(R.string.selected_actor), true);
                    return;
                }
                actorAdapter.removeDataByPosition(position);
                actorAdapter.notifyDataSetChanged();
            }
        });
    }


    /**
     * 初始化负责人、参与者组件信息
     */
    public void initHorizontalWeight() {
        initPrincipalWeight();
        initactorWeight();
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> getSelectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);
        }
        return mSelected;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //发布任务
                if (TextUtils.isEmpty(taskContentEdit.getText().toString().trim()) && imageItems.size() == 0) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "任务内容、图片至少填写一项", CommonMethod.ERROR);
                    return;
                }
                String principaUids = getprincipalUid();
                if (TextUtils.isEmpty(principaUids)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请选择任务负责人", CommonMethod.ERROR);
                    return;
                }
                int taskLevel = getTaskLevel();
                String actorsUids = getActorUids();
                long taskFinishTime = getCompeleteTime();
                publishTask(principaUids, actorsUids, taskLevel, taskFinishTime);
                break;
            case R.id.completeTimeLayout: //完成时间
                final Calendar calendar = Calendar.getInstance();
                new CustomDatePickerDialog(this, new DatePickerDialog.OnDateSetListener() { //弹出日历选择框
                    @Override
                    public void onDateSet(DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
                        new CustomTimePicker(PubliskTaskActivity.this, new TimePickerDialog.OnTimeSetListener() { //小时选择器
                            @Override
                            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                                String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                                String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                                final String yearMonthDay = year + "-" + month + "-" + day;
                                PubliskTaskActivity.this.year = year;
                                PubliskTaskActivity.this.month = monthOfYear;
                                PubliskTaskActivity.this.day = dayOfMonth;
                                PubliskTaskActivity.this.hour = hourOfDay;
                                PubliskTaskActivity.this.minute = minute;
                                completeTimeText.setText(yearMonthDay + " " + (hourOfDay < 10 ? "0" + hourOfDay : hourOfDay) + ":" + (minute < 10 ? "0" + minute : minute));
                            }
                        }, calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), true).show();
                    }
                }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH)).show();
                break;
            case R.id.emergencyLayout: //紧急程度
                if (emergencyList == null) {
                    emergencyList = new ArrayList<>();
                    SingleSelected bean1 = new SingleSelected("一般", TaskDetail.COMMONLY + "");
                    SingleSelected bean2 = new SingleSelected("紧急", TaskDetail.URGENT + "");
                    SingleSelected bean3 = new SingleSelected("非常紧急", TaskDetail.VERY_URGENT + "");
                    bean1.setSelected(true);
                    emergencyList.add(bean1);
                    emergencyList.add(bean2);
                    emergencyList.add(bean3);
                }
                SingleSelectedActivity.actionStart(this, emergencyList, "紧急程度");
                break;
        }
    }

    /**
     * 获取执行时间
     *
     * @return
     */
    private long getCompeleteTime() {
        if (year == 0) {
            return 0;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.MONTH, month);
        calendar.set(Calendar.DAY_OF_MONTH, day);
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, minute);
        return calendar.getTimeInMillis() / 1000;
    }


    /**
     * 获取任务级别
     *
     * @return
     */
    private int getTaskLevel() {
        if (emergencyList != null && emergencyList.size() > 0) {
            for (SingleSelected bean : emergencyList) {
                if (bean.isSelected()) {
                    return Integer.parseInt(bean.getSelecteNumber());
                }
            }
        }
        return TaskDetail.COMMONLY;
    }


    /**
     * 获取负责人id
     *
     * @return
     */
    private String getprincipalUid() {
        if (principalAdapter != null && principalAdapter.getSelectList() != null && principalAdapter.getSelectList().size() > 0) {
            for (GroupMemberInfo groupMemberInfo : principalAdapter.getSelectList()) {
                return groupMemberInfo.getUid();
            }
        }
        return "";
    }


    /**
     * 获取参与者id
     *
     * @return
     */
    private String getActorUids() {
        if (actorAdapter != null && actorAdapter.getSelectList() != null && actorAdapter.getSelectList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            int i = 0;
            for (GroupMemberInfo groupMemberInfo : actorAdapter.getSelectList()) {
                builder.append(i == 0 ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
                i += 1;
            }
            return builder.toString();
        }
        return "";
    }

    /**
     * 发布任务
     *
     * @param principalUids 负责人id
     * @param actorUids     参与者id
     * @param taskLevel     任务级别
     * @param taskLevel     任务完成时间
     */
    private void publishTask(final String principalUids, final String actorUids, final int taskLevel, final long taskFinishTime) {
        final CustomProgress customProgress = new CustomProgress(this);
        customProgress.show(this, null, false);
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final RequestParams params = RequestParamsToken.getExpandRequestParams(PubliskTaskActivity.this);
                if (imageItems != null && imageItems.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoadWater(params, imageItems, PubliskTaskActivity.this);
                }
                params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
                params.addBodyParameter("class_type", WebSocketConstance.TEAM);
                params.addBodyParameter("task_content", taskContentEdit.getText().toString().trim()); //任务内容
                params.addBodyParameter("principal_uid", principalUids); //任务负责人uid
                params.addBodyParameter("priticipant_uids", actorUids); //任务参与者uids,格式:11,22,33
                params.addBodyParameter("task_finish_time", taskFinishTime + ""); //任务完成时间
                params.addBodyParameter("task_level", taskLevel + ""); //任务级别(1:一般；2：紧急；3：非常紧急)
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        HttpUtils http = SingsHttpUtils.getHttp();
                        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PUBLISH_TASK, params, new RequestCallBack<String>() {
                                    @Override
                                    public void onSuccess(ResponseInfo<String> responseInfo) {
                                        try {
                                            CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                                            if (base.getState() != 0) {
                                                CommonMethod.makeNoticeShort(getApplicationContext(), "发布成功", CommonMethod.SUCCESS);
                                                setResult(Constance.PUBLICSH_SUCCESS);
                                                finish();
                                            } else {
                                                DataUtil.showErrOrMsg(PubliskTaskActivity.this, base.getErrno(), base.getErrmsg());
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                            CommonMethod.makeNoticeShort(getApplicationContext(), getApplicationContext().getString(R.string.service_err), CommonMethod.ERROR);
                                        } finally {
                                            closeDialog();
                                        }
                                    }

                                    @Override
                                    public void onFailure(HttpException e, String msg) {
                                        printNetLog(msg, PubliskTaskActivity.this);
                                        closeDialog();
                                    }
                                }
                        );
                    }
                });
            }
        });
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (position == imageItems.size()) { //进入图片选择器
            //6.0需要获取读取本地内存卡权限
            Acp.getInstance(getApplicationContext()).request(new AcpOptions.Builder()
                            .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA).build(),
                    new AcpListener() {
                        @Override
                        public void onGranted() {
                            ArrayList<String> mSelected = getSelectedPhotoPath();
                            CameraPop.multiSelector(PubliskTaskActivity.this, mSelected, MAXPHOTOCOUNT);
                        }

                        @Override
                        public void onDenied(List<String> permissions) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), context.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                        }
                    });
        } else { //查看图片
//            Bundle bundle = new Bundle();
//            bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) imageItems);
//            bundle.putInt(Constance.BEAN_INT, position);
//            Intent intent = new Intent(PubliskTaskActivity.this, PhotoZoomActivity.class);
//            intent.putExtras(bundle);
//            startActivity(intent);
            PhotoZoomActivity.actionStart(PubliskTaskActivity.this, (ArrayList<ImageItem>) imageItems, position, false);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        File destDir = new File(UtilFile.JGJIMAGEPATH);// 文件目录
        if (destDir.exists()) {// 判断目录是否存在，不存在创建
            UtilFile.RecursionDeleteFile(destDir);
        }
        File editFile = FileUtils.getAppDir(PubliskTaskActivity.this);
        if (editFile.exists()) {// 删除文件
            UtilFile.RecursionDeleteFile(editFile);
        }
        hideSoftKeyboard();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            String waterPic = data.getStringExtra(MultiImageSelectorActivity.EXTRA_CAMERA_FINISH);
            imageItems = Utils.getImages(mSelected, null);
            adapter.updateGridView(imageItems);
        } else if (resultCode == Constance.SUCCESS) { //选择紧急状态
            emergencyText.setText(data.getStringExtra("selectedValue"));
            emergencyList = (List<SingleSelected>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
        } else if (resultCode == Constance.SELECTED_ACTOR) { //选择参与者
            List<GroupMemberInfo> groupMemberInfos = (List<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            actorAdapter.setSelectList(groupMemberInfos);
        } else if (resultCode == Constance.SELECTED_PRINCIPAL) { //选择责任人
            if (data != null) {
                if (principalAdapter.getSelectList() != null && principalAdapter.getSelectList().size() > 0) {
                    principalAdapter.removeDataByPosition(0);
                }
                principalAdapter.setAddPerson(false);
                principalAdapter.addData((GroupMemberInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE));
            } else {
                principalAdapter.setAddPerson(true);
                principalAdapter.setSelectList(null);
            }
            principalAdapter.notifyDataSetChanged();
        }
    }


    /**
     * Created by mindto on 2016/3/10.
     * 定义一个类，继承DialogFragment并实现DatePickerDialog.OnDateSetListener
     */
    public class CustomDatePickerDialog extends DatePickerDialog {

        public CustomDatePickerDialog(Context context, OnDateSetListener callBack, int year, int monthOfYear, int dayOfMonth) {
            super(context, callBack, year, monthOfYear, dayOfMonth);
        }

        /**
         * 大家只需写一个子类继承DatePickerDialog，然后在里面重写父类的onStop()方法
         */
        @Override
        protected void onStop() { //DatePickerDialog中onDateSet执行两次的问题
//            super.onStop();
        }

    }

    /**
     * Created by mindto on 2016/3/10.
     * 定义一个类，继承DialogFragment并实现TimePickerDialog.OnTimeSetListener实现监听
     */
    public class CustomTimePicker extends TimePickerDialog {
        public CustomTimePicker(Context context, OnTimeSetListener listener, int hourOfDay, int minute, boolean is24HourView) {
            super(context, listener, hourOfDay, minute, is24HourView);
        }

        /**
         * 大家只需写一个子类继承DatePickerDialog，然后在里面重写父类的onStop()方法
         */
        @Override
        protected void onStop() { //DatePickerDialog中onDateSet执行两次的问题
//            super.onStop();
        }

    }
}
