package com.jizhi.jlongg.main.activity.check;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjecPeopleActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjectLevelActivity;
import com.jizhi.jlongg.main.activity.SelectReleaseQualityAddressActivity;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
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
 * 功能: 发整改通知
 * 作者：胡常生
 * 时间: 2017年11月23日 14:30:12
 */
public class ReleaseRectificationNoticeActivity extends BaseActivity implements OnSquaredImageRemoveClick, AccountPhotoGridAdapter.PhotoDeleteListener, ChatManagerAdapter.SwithBtnListener, View.OnClickListener {
    private ReleaseRectificationNoticeActivity mActivity;
    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    //    /* 上传图片的最大数 */
//    private int MAXPHOTOCOUNT = 9;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //组信息
    private CheckPlanListBean checkPlanListBean;
    //项目名字,拍照后面的文字
    private TextView tv_pro_name, textPhoto;
    private ChatManagerAdapter adapterList;
    private ListView listView;
    private List<ChatManagerItem> list;
    private EditText ed_desc;
    //年月日
    protected int year, month, day;
    public static final int PROJECT_ADDRESS = 1; //隐患部位
    public static final int PROJECT_LEVEL = 2; //隐患级别
    public static final int PROJECT_BOOLEAN = 3; //整改
    public static final int PROJECT_PEOPLE = 4; //整改负责人
    public static final int PROJECT_TIME = 5;//消整改完成期限
    public static final int PROJECT_TYPE = 6;//整改类型
    public static final String VALUE = "name";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_releasequaandsafe);
        initView();
        getIntentData();
//        registerReceiver();
        hideSoftKeyboard();
        initOrUpDateAdapter();
        listView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                    hideSoftKeyboard();
                }
                return false;
            }
        });
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

    private String addrStr, peopleStr, timeStr, people_uid, addr_id;
    private ProjectLevel levelBean, typeBean;

    private void initView() {
        mActivity = ReleaseRectificationNoticeActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "整改通知");
        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        listView = (ListView) findViewById(R.id.listView);
        View headView = getLayoutInflater().inflate(R.layout.layout_rectification_notice_head, null); // 添加头信息
        findViewById(R.id.right_title).setOnClickListener(this);
        listView.addHeaderView(headView, null, false);
        tv_pro_name = (TextView) headView.findViewById(R.id.tv_pro_name);
        textPhoto = (TextView) headView.findViewById(R.id.textPhoto);
        ed_desc = (EditText) headView.findViewById(R.id.ed_desc);
        levelBean = DataUtil.getProjectLevel(false).get(0);
        typeBean = DataUtil.getProjectType(false).get(0);
        list = getList();
        adapterList = new ChatManagerAdapter(mActivity, list, mActivity);
        listView.setAdapter(adapterList);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position -= listView.getHeaderViewsCount();
                ChatManagerItem item = list.get(position);
                switch (item.getMenuType()) {
                    case PROJECT_ADDRESS: //隐患部位
                        SelectReleaseQualityAddressActivity.actionStart(mActivity, gnInfo);
                        break;
                    case PROJECT_LEVEL://隐患级别
                        ReleaseProjectLevelActivity.actionStart(mActivity, ReleaseRectificationNoticeActivity.PROJECT_LEVEL, levelBean, DataUtil.getProjectLevel(false));
                        break;
                    case PROJECT_PEOPLE://整改负责人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", ReleaseRectificationNoticeActivity.PROJECT_PEOPLE, "选择整改负责人");
                        break;
                    case PROJECT_TIME://整改完成期限
                        setTime();
                        break;
                    case PROJECT_TYPE://整改类型
                        ReleaseProjectLevelActivity.actionStart(mActivity, ReleaseRectificationNoticeActivity.PROJECT_TYPE, typeBean, DataUtil.getProjectType(false));
                        break;
                }
            }
        });

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
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseRectificationNoticeActivity.PROJECT_ADDRESS) {
            //隐患部位
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                addrStr = data.getStringExtra(VALUE);
                addr_id = data.getIntExtra(SelectReleaseQualityAddressActivity.ADDRID, 0) + "";
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseRectificationNoticeActivity.PROJECT_LEVEL) {
            //隐患级别
            levelBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != levelBean) {
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseRectificationNoticeActivity.PROJECT_PEOPLE) {
            //整改负责人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseRectificationNoticeActivity.PROJECT_TYPE) {
            //整改类型
            typeBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != typeBean) {
                setList();
            }
        }else if (requestCode == Constance.REQUESTCODE_MSGEDIT && resultCode == RESULT_OK) {
            String path = data.getStringExtra(Constance.BEAN_STRING);
            int position = data.getIntExtra(Constance.BEAN_INT, 0);
            //编辑了图片回调
            photos.get(position).imagePath = path;
            adapter.updateGridView(photos);
        }
    }

    public void setList() {
        list = getList();
        adapterList = new ChatManagerAdapter(mActivity, list, mActivity);
        listView.setAdapter(adapterList);
    }

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    int intYear = Integer.parseInt(year);
                    int intMonth = Integer.parseInt(month);
                    int intDay = Integer.parseInt(day);
                    int currentTime = TimesUtils.getCurrentTimeYearMonthDay()[0] * 10000 + TimesUtils.getCurrentTimeYearMonthDay()[1] * 100 + TimesUtils.getCurrentTimeYearMonthDay()[2];
                    if (intYear * 10000 + intMonth * 100 + intDay < currentTime) {
                        CommonMethod.makeNoticeShort(mActivity, "不能记录今天之前的内容", CommonMethod.ERROR);
                        return;
                    } else {
                        String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                        String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                        timeStr = year + "-" + months + "-" + days;
                        for (int i = 0; i < list.size(); i++) {
                            if (list.get(i).getMenuType() == PROJECT_TIME) {
                                list.get(i).setValue(timeStr);
                                adapterList.updateList(list);
                            }
                        }
                    }
                }
            }, year, month, day);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(mActivity.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        datePickerPopWindow.goneRecordDays();
    }

    @Override
    public void toggle(int menuType, boolean toggle) {
        list = getList();
        adapterList = new ChatManagerAdapter(mActivity, list, mActivity);
        listView.setAdapter(adapterList);
    }


    private List<ChatManagerItem> getList() {
        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu = new ChatManagerItem("隐患部位", true, false, PROJECT_ADDRESS);
        ChatManagerItem menu1 = new ChatManagerItem("隐患级别", true, false, PROJECT_LEVEL);
        chatManagerList.add(menu);
        chatManagerList.add(menu1);
        if (null != levelBean) {
            menu1.setValue(!TextUtils.isEmpty(levelBean.getName()) ? levelBean.getName() : "");
        }
        menu.setValue(!TextUtils.isEmpty(addrStr) ? addrStr : "");
        ChatManagerItem menu3 = new ChatManagerItem("整改负责人", true, false, PROJECT_PEOPLE);
        ChatManagerItem menu5 = new ChatManagerItem("整改类型", true, false, PROJECT_TYPE);
        if (null != typeBean) {
            menu5.setValue(!TextUtils.isEmpty(typeBean.getName()) ? typeBean.getName() : "");
        }
        ChatManagerItem menu4 = new ChatManagerItem("整改完成期限", true, false, PROJECT_TIME);
        chatManagerList.add(menu3);
        chatManagerList.add(menu5);
        chatManagerList.add(menu4);
        menu3.setValue(!TextUtils.isEmpty(peopleStr) ? peopleStr : "");
        menu4.setValue(!TextUtils.isEmpty(timeStr) ? timeStr : "");
        return chatManagerList;
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context           上下文
     * @param checkPlanListBean 实体类检查信息
     * @param gnInfo            实体类组信息
     * @param group_positon     父级下标
     * @param child_positon     子级下标
     */
    public static void actionStart(Activity context, CheckPlanListBean checkPlanListBean, GroupDiscussionInfo gnInfo, int group_positon, int child_positon, String text) {
        Intent intent = new Intent(context, ReleaseRectificationNoticeActivity.class);
        intent.putExtra("checkplanlistbean", checkPlanListBean);
        intent.putExtra(Constance.BEAN_CONSTANCE, gnInfo);
        intent.putExtra("text", text);
        intent.putExtra("group_positon", group_positon);
        intent.putExtra("child_positon", child_positon);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        checkPlanListBean = (CheckPlanListBean) getIntent().getSerializableExtra("checkplanlistbean");
        tv_pro_name.setText(gnInfo.getAll_pro_name());
        SetTitleName.setTitle(findViewById(R.id.title), "整改通知");
        if (!TextUtils.isEmpty(getIntent().getStringExtra("text"))) {
            ed_desc.setText(getIntent().getStringExtra("text"));
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
                        PhotoZoomActivity.actionStart(mActivity, (ArrayList<ImageItem>) photos, position, true);
                    }
                }
            });
            gridView.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                        hideSoftKeyboard();
                    }
                    return false;
                }
            });
        } else {
            adapter.notifyDataSetChanged();
        }

    }

    @Override
    public void remove(int position) {
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }

    @Override
    public void imageSizeIsZero() {
        initPictureDesc();
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
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                savaClick();
                break;
        }
    }

    DiaLogRedLongProgress dialog;

    public void savaClick() {
        String text_desc = ed_desc.getText().toString().trim();
        if ((photos == null || photos.size() == 0) && TextUtils.isEmpty(text_desc)) {
            CommonMethod.makeNoticeShort(mActivity, "问题描述和图片至少需要填一项", CommonMethod.ERROR);
            return;
        }
        if (TextUtils.isEmpty(people_uid)) {
            CommonMethod.makeNoticeShort(mActivity, "请选择整改负责人", CommonMethod.ERROR);
            return;
        }

        if (null == dialog) {
            dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.syning));
        }
        dialog.show();
        FileUpData();
    }


    RequestParams params;

    public void FileUpData() {
        String text_desc = ed_desc.getText().toString().trim();
        params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("pro_id", checkPlanListBean.getPro_id() + "");//检查项id
        params.addBodyParameter("plan_id", checkPlanListBean.getPlan_id() + "");//检查计划id
        params.addBodyParameter("content_id", checkPlanListBean.getContent_id());//检查内容id
        params.addBodyParameter("dot_id", checkPlanListBean.getDot_id());//检查点id
        if (typeBean.getId() == 1) {
            params.addBodyParameter("msg_type", MessageType.MSG_QUALITY_STRING);//类型 quality
        } else if (typeBean.getId() == 2) {
            params.addBodyParameter("msg_type", MessageType.MSG_SAFE_STRING);//类型safe
        } else if (typeBean.getId() == 3) {
            params.addBodyParameter("msg_type",MessageType.MSG_TASK_STRING);//类型task
        }
        if (typeBean.getId() != 3) {
            //任务：生成一个类型为[非常紧急]的任务，发布人填写的隐患部位及严重程度以文字的形成出现在描述的最后面；
            if (!TextUtils.isEmpty(addrStr)) {
                params.addBodyParameter("location_text", addrStr);//隐患文字
            }
            if (!TextUtils.isEmpty(levelBean.getName())) {
                params.addBodyParameter("severity", levelBean.getId() + "");//隐患程度
            }
            if (!TextUtils.isEmpty(text_desc)) {
                params.addBodyParameter("text", text_desc);//内容
            }
        } else {
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(text_desc);
            if (!TextUtils.isEmpty(addrStr)) {
                //隐患文字
                stringBuffer.append("\n" + "隐患部位:" + addrStr);
            }
            if (!TextUtils.isEmpty(levelBean.getName())) {
                //隐患文字
                stringBuffer.append("\n" + "隐患级别:" + levelBean.getName());
            }
            params.addBodyParameter("text", stringBuffer.toString());//内容
        }

        if (!TextUtils.isEmpty(people_uid)) {
            params.addBodyParameter("principal_uid", people_uid);//整改人
        }
        if (!TextUtils.isEmpty(timeStr)) {
            params.addBodyParameter("finish_time", timeStr);//完成时间
        }


        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, selectedPhotoPath(), mActivity);
                }
                LUtils.e("---------------" + new Gson().toJson(params));
                Message message = Message.obtain();
                message.obj = params;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        });
        thread.start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    sendeFormInspect();
                    break;
            }

        }
    };

    /**
     * 发布质量安全或者任务
     */
    public void sendeFormInspect() {

        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.REFORMINSPECT, params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                                if (bean.getState() != 0) {
                                    CommonMethod.makeNoticeShort(mActivity, "发布成功", CommonMethod.SUCCESS);
                                    Intent intent = new Intent();
                                    intent.putExtra("group_positon", getIntent().getIntExtra("group_positon", -1));
                                    intent.putExtra("child_positon", getIntent().getIntExtra("child_positon", -1));
                                    mActivity.setResult(Constance.RESULTCODE_FINISH, intent);
                                    finish();
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                                if (null != dialog) {
                                    dialog.dismissDialog();
                                }
                            } finally {
                                if (null != dialog) {
                                    dialog.dismissDialog();
                                }
                            }
                        }

                        @Override
                        public void onFailure(HttpException e, String s) {
                            closeDialog();
                        }
                    }
        );
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        hideSoftKeyboard();
    }

    @Override
    public void onFinish(View view) {
        super.onFinish(view);
        hideSoftKeyboard();
    }

}
