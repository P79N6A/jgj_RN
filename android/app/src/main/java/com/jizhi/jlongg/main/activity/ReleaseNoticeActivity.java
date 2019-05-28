package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.Selection;
import android.text.Spannable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.MembersNoTagAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
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
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * 功能:发工作通知
 * 时间:2018/8/27 10:12
 * 作者:hcs
 */
public class ReleaseNoticeActivity extends BaseActivity implements OnSquaredImageRemoveClick {
    private GroupDiscussionInfo gnInfo;
    /* 图片数据 */
    private List<ImageItem> imageItems;
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    /* 上传图片的最大数 */
    private int MAXPHOTOCOUNT = 9;
    /* 报告详情 */
    private EditText ed_desc;
    private ReleaseNoticeActivity mActivity;
    private List<PersonBean> personList;
    /* 执行人GridView适配器 */
    private MembersNoTagAdapter executeMemberAdapter;
    //是否选择全部成员
    private boolean isSelectedAll;
    //存储拍照的图片
    private List<String> cameraList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.safety_quality);
        ViewUtils.inject(this);
        getIntentData();
        initView();
        initExecureGridview();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, ReleaseNoticeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    private void initView() {
        mActivity = ReleaseNoticeActivity.this;
        personList = new ArrayList<>();
        cameraList = new ArrayList<>();
        imageItems = new ArrayList<>();
        ed_desc = findViewById(R.id.ed_desc);
        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        SetTitleName.setTitle(findViewById(R.id.title), "发通知");
        ed_desc.setHint("请在此处输入通知内容");
        ((TextView) findViewById(R.id.tv_proName)).setText((gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? "当前项目：" : "当前班组：") + gnInfo.getGroup_name());
        initOrUpDateAdapter();
        ed_desc.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (before != 1 && start < s.length() && String.valueOf(s.charAt(start)).equalsIgnoreCase("@") && count == 1) {
                    Intent intent = new Intent(mActivity, AtMemberListActivity.class);
                    intent.putExtra(Constance.GROUP_ID, gnInfo.getGroup_id());
                    intent.putExtra(Constance.CLASSTYPE, gnInfo.getClass_type());
                    intent.putExtra("mySelfGroup", UclientApplication.getUid(getApplicationContext()).equals(gnInfo.getCreater_uid()));
                    mActivity.startActivityForResult(intent, Constance.PERSON);
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Utils.isFastDoubleClick()) {
                    return;
                }
                savaClick();
            }
        });
        readLocalInfo();
    }

    /**
     * 选择接收人
     */
    public void initExecureGridview() {
        executeMemberAdapter = new MembersNoTagAdapter(this, null, new AddMemberListener() {
            @Override
            public void add(int state) { //添加执行人
                SelecteActorActivity.actionStart(mActivity, getExecutePersonUids(), getString(R.string.selecte_recive), gnInfo.getGroup_id(), gnInfo.getAll_pro_name(), gnInfo.getClass_type(), true);
            }

            @Override
            public void remove(int state) { //删除执行人
                isSelectedAll = false;
            }
        });
        GridView gridView =  findViewById(R.id.executeGridView);
        gridView.setAdapter(executeMemberAdapter);
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
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);

        }
        return mSelected;
    }


    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.wrap_grid);
            adapter = new SquaredImageAdapter(this, this, imageItems, MAXPHOTOCOUNT);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    if (position == imageItems.size()) {
                        Acp.getInstance(ReleaseNoticeActivity.this).request(new AcpOptions.Builder()
                                                .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                                            , Manifest.permission.CAMERA)
                                                .build(),
                                    new AcpListener() {
                                        @Override
                                        public void onGranted() {
                                            ArrayList<String> mSelected = selectedPhotoPath();
                                            CameraPop.multiSelector(ReleaseNoticeActivity.this, mSelected, MAXPHOTOCOUNT);
                                        }

                                        @Override
                                        public void onDenied(List<String> permissions) {
                                            CommonMethod.makeNoticeShort(getApplicationContext(), getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                        }
                                    });
                    } else {
                        PhotoZoomActivity.actionStart(mActivity, (ArrayList<ImageItem>) imageItems, position, true);
                    }
                }
            });
        } else {
            adapter.notifyDataSetChanged();
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


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            String waterPic = data.getStringExtra(MultiImageSelectorActivity.EXTRA_CAMERA_FINISH);
            //拍照之后返回
            if (!TextUtils.isEmpty(waterPic)) {
                cameraList.add(waterPic);
            }
            imageItems = Utils.getImages(mSelected, cameraList);
            adapter.updateGridView(imageItems);
        } else if (requestCode == Constance.PERSON & resultCode == Constance.PERSON) {
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_ARRAY);
            addAtInfo(personBean);
            //选择@成员回调
            if (!data.getBooleanExtra(Constance.ATALL, false)) {
                int index = ed_desc.getSelectionStart();
                Editable editable = ed_desc.getText();
                editable.insert(index, personBean.getName() + " ");
                cursorEnd(ed_desc);
            } else {
                int index = ed_desc.getSelectionStart();
                Editable editable = ed_desc.getText();
                editable.insert(index, "所有人 ");
                cursorEnd(ed_desc);
            }
        } else if (resultCode == Constance.SELECTED_ACTOR) { //选择执行者
            List<GroupMemberInfo> groupMemberInfos = (List<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            executeMemberAdapter.updateListView(groupMemberInfos);
            isSelectedAll = data.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            LUtils.e("----------------------------" + isSelectedAll);
        } else if (requestCode == Constance.REQUESTCODE_MSGEDIT && resultCode == RESULT_OK) {
            String path = data.getStringExtra(Constance.BEAN_STRING);
            int position = data.getIntExtra(Constance.BEAN_INT, 0);
            //编辑了图片回调
            imageItems.get(position).imagePath = path;
            adapter.updateGridView(imageItems);
        }
    }

    public void addAtInfo(PersonBean personBean) {
        if (null != personBean) {
            if (null == personList) {
                personList = new ArrayList<>();
            }
            personList.add(personBean);
        }

    }

    public void setEdText(PersonBean personBean) {
        if (null != personBean) {
            if (null == personList) {
                personList = new ArrayList<>();
            }
            if (personList.size() == 0) {
                personList.add(personBean);
            } else {
                personList.add(personBean);
            }
            LUtils.e(personList.size() + "<----personList--->" + new Gson().toJson(personList));

        }

    }

    /**
     * EditText 光标至于 最后一位
     */
    public void cursorEnd(EditText editext) {
        CharSequence text = editext.getText();
        if (text instanceof Spannable) {
            Spannable spanText = (Spannable) text;
            Selection.setSelection(spanText, text.length());
        }
    }

    @Override
    public void remove(int position) {
        imageItems.remove(position);
        adapter.notifyDataSetChanged();
    }

    DiaLogRedLongProgress dialog;

    public void savaClick() {
        String text = ed_desc.getText().toString().trim();
        if (TextUtils.isEmpty(text) && imageItems.size() == 0) {
            CommonMethod.makeNoticeShort(mActivity, "请输入内容", CommonMethod.ERROR);
            return;
        }
        if (TextUtils.isEmpty(getSelecteExecuteIds())) {
            CommonMethod.makeNoticeShort(mActivity, "请选择接收人", CommonMethod.ERROR);
            return;
        }
        if (null == dialog) {
            dialog = new DiaLogRedLongProgress(mActivity, getString(R.string.syning));
        }
        dialog.show();
        FileUpData();
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

    RequestParams params;

    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                if (imageItems != null && imageItems.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoadWater(params, imageItems, mActivity);
                }
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
                    putNotice();
                    break;
            }

        }
    };

    /**
     * 发布通知
     */
    public void putNotice() {
        params.addBodyParameter(MessageType.GROUP_ID, gnInfo.getGroup_id());
        params.addBodyParameter(MessageType.CLASS_TYPE, gnInfo.getClass_type());
        params.addBodyParameter(MessageType.MSG_TYPE, MessageType.MSG_NOTICE_STRING);
        params.addBodyParameter(MessageType.MSG_TEXT, ed_desc.getText().toString().trim());
        params.addBodyParameter("rec_uid", isSelectedAll ? "-1" : getSelecteExecuteIds());
        CommonHttpRequest.commonRequest(this, NetWorkRequest.PUB_NOTICE, MessageBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (null != dialog) {
                    dialog.dismissDialog();
                }

                saveAndClearLocalInfo(false);
                CommonMethod.makeNoticeLong(mActivity, "发布成功", CommonMethod.SUCCESS);
                //发送消息广播，用于本地展示
                NewMessageUtils.saveMessage((MessageBean) object,mActivity);
                mActivity.setResult(Constance.RESULTCODE_FINISH, getIntent());
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
    public void onBackPressed() {
        super.onBackPressed();
        hideSoftKeyboard();
        saveAndClearLocalInfo(true);
    }

    @Override
    public void onFinish(View view) {
        super.onFinish(view);
        saveAndClearLocalInfo(true);
        hideSoftKeyboard();
    }

    /**
     * 保存草稿信息
     */
    public void saveAndClearLocalInfo(boolean isSava) {
        String content = ed_desc.getText().toString().trim();
        if (TextUtils.isEmpty(content) && isSava) {
            return;
        }
        try {
            String msgType = MessageType.MSG_NOTICE_STRING;
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
            String msgType = MessageType.MSG_NOTICE_STRING;
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            LocalInfoBean logModeBean = new LocalInfoBean(0, class_type, msgType, group_id, "", LocalInfoBean.TYPE_SEND);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            ed_desc.setText(content);
        } catch (Exception e) {

        }

    }
}