package com.jizhi.jlongg.main.activity;

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
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.QualityAndSafeAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.custom.MyEditText;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton.FileUtils;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static com.jizhi.jlongg.main.bean.ChatManagerItem.PROJECT_CHANGE;


/**
 * 功能: 发质量，安全
 * 作者：胡常生
 * 时间: 2017年5月26日 16:10:12
 */
public class ReleaseQualityAndSafeActivity extends BaseActivity implements OnSquaredImageRemoveClick, AccountPhotoGridAdapter.PhotoDeleteListener, QualityAndSafeAdapter.SwithBtnListener, View.OnClickListener, View.OnTouchListener {
    private ReleaseQualityAndSafeActivity mActivity;
    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    //    /* 上传图片的最大数 */
//    private int MAXPHOTOCOUNT = 9;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //项目名字,拍照后面的文字
    private TextView tv_pro_name, textPhoto;
    private QualityAndSafeAdapter adapterList;
    private ListView listView;
    private List<ChatManagerItem> list;
    private MyEditText ed_desc;
    //年月日
    protected int year, month, day;
    //是否需要真该
    private boolean isSwtich;
    public static final int PROJECT_ADDRESS = 1; //隐患部位
    public static final int PROJECT_LEVEL = 2; //隐患级别
    public static final int PROJECT_BOOLEAN = 3; //整改
    public static final int PROJECT_PEOPLE = 4; //整改负责人
    public static final int PROJECT_TIME = 5;//消整改完成期限
    public static final String VALUE = "name";
    private String msg_step;//整改措施
    //存储拍照的图片
    private List<String> cameraList;

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
    private ProjectLevel levelBean;

    private void initView() {
        mActivity = ReleaseQualityAndSafeActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "记录问题");
        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        listView = findViewById(R.id.listView);
        cameraList = new ArrayList<>();
        View headView = getLayoutInflater().inflate(R.layout.layout_message_reaquality_head, null); // 添加头信息
        findViewById(R.id.right_title).setOnClickListener(this);
        listView.addHeaderView(headView, null, false);
        tv_pro_name = headView.findViewById(R.id.tv_pro_name);
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        tv_pro_name.setText(gnInfo.getGroup_name());
        ((TextView) headView.findViewById(R.id.tv_pro_type)).setText(gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? "当前项目：" : "当前班组：");
        textPhoto = headView.findViewById(R.id.textPhoto);
        ed_desc = headView.findViewById(R.id.ed_desc);
        levelBean = DataUtil.getProjectLevel(false).get(0);
        isSwtich = true;
        list = getList(isSwtich);
        adapterList = new QualityAndSafeAdapter(mActivity, list, mActivity);
        listView.setAdapter(adapterList);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position -= listView.getHeaderViewsCount();
                ChatManagerItem item = list.get(position);
                Intent intent = null;
                switch (item.getMenuType()) {
                    case PROJECT_ADDRESS: //隐患部位
                        SelectReleaseQualityAddressActivity.actionStart(mActivity, gnInfo);
                        break;
                    case PROJECT_LEVEL://隐患级别
                        ReleaseProjectLevelActivity.actionStart(mActivity, ReleaseQualityAndSafeActivity.PROJECT_LEVEL, levelBean, DataUtil.getProjectLevel(false));
                        break;
                    case PROJECT_PEOPLE://整改负责人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", ReleaseQualityAndSafeActivity.PROJECT_PEOPLE, "选择整改负责人");
                        break;
                    case PROJECT_TIME://整改完成期限
                        setTime();
                        break;
                }
            }
        });

        ed_desc.setOnTouchListener(this);

    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (v.getId()) {
            case R.id.ed_desc:
                v.getParent().requestDisallowInterceptTouchEvent(true);
                switch (event.getAction()) {
                    case MotionEvent.ACTION_UP:
                        v.getParent().requestDisallowInterceptTouchEvent(false);
                        break;
                }
        }
        return false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            String waterPic = data.getStringExtra(MultiImageSelectorActivity.EXTRA_CAMERA_FINISH);
            //拍照之后返回
            if (!TextUtils.isEmpty(waterPic)) {
                cameraList.add(waterPic);
            }
            photos = Utils.getImages(mSelected, cameraList);
            adapter.updateGridView(photos);
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseQualityAndSafeActivity.PROJECT_ADDRESS) {
            //隐患部位
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                addrStr = data.getStringExtra(VALUE);
                addr_id = data.getIntExtra(SelectReleaseQualityAddressActivity.ADDRID, 0) + "";
                list.get(getPosion(list, PROJECT_ADDRESS)).setValue(addrStr);
                adapterList.updateList(list);
//                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseQualityAndSafeActivity.PROJECT_LEVEL) {
            //隐患级别
            levelBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != levelBean) {
//                setList();
                list.get(getPosion(list, PROJECT_LEVEL)).setValue(levelBean.getName());
                adapterList.updateList(list);
            }
        } else if (requestCode == Constance.REQUEST && resultCode == ReleaseQualityAndSafeActivity.PROJECT_PEOPLE) {
            //整改负责人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                list.get(getPosion(list, PROJECT_PEOPLE)).setValue(peopleStr);
                adapterList.updateList(list);
//                setList();
            }
        } else if (requestCode == Constance.REQUESTCODE_MSGEDIT && resultCode == RESULT_OK) {
            String path = data.getStringExtra(Constance.BEAN_STRING);
            int position = data.getIntExtra(Constance.BEAN_INT, 0);
            //编辑了图片回调
            photos.get(position).imagePath = path;
            adapter.updateGridView(photos);
        }
    }

    public void setList() {
        list = getList(isSwtich);
        adapterList = new QualityAndSafeAdapter(mActivity, list, mActivity);
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
//                        list.get(4).setValue(timeStr);
                        list.get(getPosion(list, PROJECT_TIME)).setValue(timeStr);
                        adapterList.updateList(list);
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
        if (isSwtich) {
            isSwtich = false;
        } else {
            isSwtich = true;
        }
        list = getList(isSwtich);
        adapterList = new QualityAndSafeAdapter(mActivity, list, mActivity);
        listView.setAdapter(adapterList);
    }

    @Override
    public void setProChange(String str) {
        msg_step = str;
        list.get(getPosion(list, PROJECT_CHANGE)).setValue(msg_step);
    }

    protected int getPosion(List<ChatManagerItem> itemData, int item_type) {
        for (int i = 0; i < itemData.size(); i++) {
            if (item_type == itemData.get(i).getMenuType()) {
                return i;
            }
        }
        return 0;

    }

    private List<ChatManagerItem> getList(boolean isSwtich) {
        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu = new ChatManagerItem("隐患部位", true, false, PROJECT_ADDRESS);
        ChatManagerItem menu1 = new ChatManagerItem("隐患级别", true, true, PROJECT_LEVEL);
        ChatManagerItem menu2 = new ChatManagerItem("需要整改", true, false, PROJECT_BOOLEAN);
        chatManagerList.add(menu);
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        if (null != levelBean) {
            menu1.setValue(!TextUtils.isEmpty(levelBean.getName()) ? levelBean.getName() : "");
        }
        menu.setValue(!TextUtils.isEmpty(addrStr) ? addrStr : "");
        menu2.setItemType(ChatManagerItem.SWITCH_BTN);
        menu2.setSwitchState(isSwtich);
        if (isSwtich) {
            ChatManagerItem menu3 = new ChatManagerItem("整改负责人", true, false, PROJECT_PEOPLE);
            ChatManagerItem menu4 = new ChatManagerItem("整改完成期限", true, false, PROJECT_TIME);
            ChatManagerItem menu5 = new ChatManagerItem("整改措施", true, false, PROJECT_CHANGE);

            menu5.setItemType(PROJECT_CHANGE);
            if (!TextUtils.isEmpty(msg_step)) {
                menu5.setValue(msg_step);
            }
            chatManagerList.add(menu3);
            chatManagerList.add(menu4);
            chatManagerList.add(menu5);
            menu3.setValue(!TextUtils.isEmpty(peopleStr) ? peopleStr : "");
            menu4.setValue(!TextUtils.isEmpty(timeStr) ? timeStr : "");
        }
        return chatManagerList;
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msg_type, String edit) {
        Intent intent = new Intent(context, ReleaseQualityAndSafeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msg_type);
        intent.putExtra("edit", edit);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStarts(Activity context, GroupDiscussionInfo info, String msg_type, String edit, int position) {
        Intent intent = new Intent(context, ReleaseQualityAndSafeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msg_type);
        intent.putExtra("edit", edit);
        intent.putExtra("position", position);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        String msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
        if (!TextUtils.isEmpty(msgType) && msgType.equals(MessageType.MSG_SAFE_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), "发安全问题");
        } else if (!TextUtils.isEmpty(msgType) && msgType.equals(MessageType.MSG_QUALITY_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), "发质量问题");
        }
        if (!TextUtils.isEmpty(getIntent().getStringExtra("edit"))) {
            ed_desc.setText(getIntent().getStringExtra("edit"));
        } else {
            readLocalInfo();
        }

    }

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = findViewById(R.id.gridView);
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
        cameraList.remove(photos.get(position).imagePath);
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

    DiaLogRedLongProgress dialog;

    public void savaClick() {
        String text = ed_desc.getText().toString().trim();
        if ((photos == null || photos.size() == 0) && TextUtils.isEmpty(text)) {
            CommonMethod.makeNoticeShort(mActivity, "问题描述和图片至少需要填一项", CommonMethod.ERROR);
            return;
        }
        if (isSwtich && TextUtils.isEmpty(people_uid)) {
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
        params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter(MessageType.MSG_TYPE, getIntent().getStringExtra(Constance.MSG_TYPE));//safe 安全,quality 质量
        params.addBodyParameter(MessageType.CLASS_TYPE, gnInfo.getClass_type());//类别，group为班组，team为讨论组
        params.addBodyParameter(MessageType.GROUP_ID, gnInfo.getGroup_id());//备注
        //备注
        if (!TextUtils.isEmpty(ed_desc.getText().toString().trim())) {
            params.addBodyParameter(MessageType.MSG_TEXT, ed_desc.getText().toString().trim());//内容
        }
        //隐患级别
        if (null != levelBean && !TextUtils.isEmpty(levelBean.getName())) {
            params.addBodyParameter("severity", levelBean.getId() + ""); //隐患级别
        }
        //位置
        if (!TextUtils.isEmpty(addrStr)) {
            params.addBodyParameter("location", addrStr);//位置
            if (!TextUtils.isEmpty(addrStr) && !addr_id.equals("0")) {
                params.addBodyParameter("location_id", addr_id + "");//如果取原来的位置，
            }
        }
        //整改措施
        if (!TextUtils.isEmpty(timeStr)) {
            params.addBodyParameter("finish_time", timeStr.replace("-", ""));//整改措施
        }
        //是否需要整改以及整改负责人
        if (isSwtich) {
            params.addBodyParameter("is_rectification", "1");//是否整改（1：整改；0：不需要）
            params.addBodyParameter("principal_uid", people_uid);//负责人（与字段is_rectification连用））
            params.addBodyParameter("statu", "1");//1:待整改；2：待复查；3：已完结
            //整改措施
            if (!TextUtils.isEmpty(msg_step)) {
                params.addBodyParameter("msg_step", msg_step);//完成时间
            }
        } else {
            params.addBodyParameter("statu", "3");//1:待整改；2：待复查；3：已完结
            params.addBodyParameter("is_rectification", "0");//是否整改（1：整改；0：不需要）
        }

        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                if (photos != null && photos.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoadWater(params, photos, ReleaseQualityAndSafeActivity.this);
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
                    pubQualitySafe();
                    break;
            }

        }
    };

    /**
     * 质量安全发送接口
     */
    public void pubQualitySafe() {
        CommonHttpRequest.commonRequest(this, NetWorkRequest.PUB_QUALITY_OR_SAFE, MessageBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (null != dialog) {
                    dialog.dismissDialog();
                }
                CommonMethod.makeNoticeLong(mActivity, "发布成功", CommonMethod.SUCCESS);
                saveAndClearLocalInfo(false);
                //发送消息广播，用于本地展示
                NewMessageUtils.saveMessage((MessageBean) object, mActivity);
                Intent intent1 = new Intent();
                if (getIntent().getIntExtra("position", -1) != -1) {
                    intent1.putExtra("position", getIntent().getIntExtra("position", -1));
                }
                mActivity.setResult(Constance.RESULTCODE_FINISH, intent1);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                if (null != dialog) {
                    dialog.dismissDialog();
                }

            }
        });

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                if (Utils.isFastDoubleClick3000()) {
                    return;
                }
                savaClick();
                break;
        }
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        hideSoftKeyboard();
        if (TextUtils.isEmpty(getIntent().getStringExtra("edit"))) {
            saveAndClearLocalInfo(true);
        }


    }

    @Override
    public void onFinish(View view) {
        super.onFinish(view);
        if (TextUtils.isEmpty(getIntent().getStringExtra("edit"))) {
            saveAndClearLocalInfo(true);
        } else {
        }
        hideSoftKeyboard();
    }


    /**
     * 保存草稿信息
     */
    public void saveAndClearLocalInfo(boolean isSava) {
        String content = ed_desc.getText().toString().trim();

//        if (TextUtils.isEmpty(content) && isSava) {
//            return;
//        }
        try {
            String msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            LocalInfoBean logModeBean = new LocalInfoBean(0, class_type, msgType, group_id, content, LocalInfoBean.TYPE_SEND);
            MessageUtils.saveAndClearLocalInfo(logModeBean, isSava);
        } catch (Exception e) {

        }

    }

    /**
     * 读取草稿信息
     */
    public void readLocalInfo() {
        try {
            String msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            LocalInfoBean logModeBean = new LocalInfoBean(0, class_type, msgType, group_id, "", LocalInfoBean.TYPE_SEND);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            ed_desc.setText(content);
        } catch (Exception e) {

        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        File destDir = new File(UtilFile.JGJIMAGEPATH);// 文件目录
        if (destDir.exists()) {// 判断目录是否存在，不存在创建
            UtilFile.RecursionDeleteFile(destDir);
        }
        File editFile = FileUtils.getAppDir(mActivity);
        if (editFile.exists()) {// 删除文件
            UtilFile.RecursionDeleteFile(editFile);
        }
        hideSoftKeyboard();
    }
}
