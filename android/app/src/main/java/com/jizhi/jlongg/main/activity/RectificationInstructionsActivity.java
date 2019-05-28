package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
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
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能: 整改完成确认
 * 作者：胡常生
 * 时间: 2017年6月5日 16:10:12
 */
public class RectificationInstructionsActivity extends BaseActivity implements AccountPhotoGridAdapter.PhotoDeleteListener, OnSquaredImageRemoveClick {
    private RectificationInstructionsActivity mActivity;
    private EditText ed_desc;
    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    /* 上传图片的最大数 */
    private int MAXPHOTOCOUNT = 9;
    //1:待整改；2：待复查；3：已完结
    private String type;
    private RadioGroup radioGroup;
    //未通过，通过
    private RadioButton rb_pass, rb_fail;
    private GroupDiscussionInfo gnInfo;
    public static final int FINISH = 0X10;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_rectifation);
        initView();
//        registerReceiver();
        getIntentData();
        initOrUpDateAdapter();

    }

    /**
     * initView
     */
    public void initView() {
        mActivity = RectificationInstructionsActivity.this;
        ed_desc = (EditText) findViewById(R.id.ed_desc);
        SetTitleName.setTitle(findViewById(R.id.right_title), "确定");
        type = getIntent().getStringExtra("statu");
        if (type.equals("1")) {
            SetTitleName.setTitle(findViewById(R.id.title), "整改完成确认");
        } else if (type.equals("2")) {
            SetTitleName.setTitle(findViewById(R.id.title), "复查结果");
            ((TextView) findViewById(R.id.tv_hint)).setText("复查说明");
            findViewById(R.id.rea_layout).setVisibility(View.VISIBLE);
            ed_desc.setHint("请输入复查说明(选填)");
        }
        radioGroup = (RadioGroup) findViewById(R.id.radioGroup);
        rb_pass = (RadioButton) findViewById(R.id.rb_pass);
        rb_fail = (RadioButton) findViewById(R.id.rb_fail);
        //设置监听
        radioGroup.setOnCheckedChangeListener(new RadioGroupListener());
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                savaClick();

            }
        });
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String type, String msg_id, String msg_type, MessageEntity messageEntity) {
        Intent intent = new Intent(context, RectificationInstructionsActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra("statu", type);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.MSG_TYPE, msg_type);
        intent.putExtra(Constance.MSG, messageEntity);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.gridView);
            adapter = new SquaredImageAdapter(mActivity, mActivity, photos, 9);
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
        } else {
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void remove(int position) {
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }


    class RadioGroupListener implements RadioGroup.OnCheckedChangeListener {
        @Override
        public void onCheckedChanged(RadioGroup group, int checkedId) {
            if (checkedId == rb_pass.getId()) {
                //通过
                rb_pass.setTextColor(getResources().getColor(R.color.app_color));
                rb_fail.setTextColor(getResources().getColor(R.color.color_333333));
            } else if (checkedId == rb_fail.getId()) {
                //未通过
                rb_fail.setTextColor(getResources().getColor(R.color.app_color));
                rb_pass.setTextColor(getResources().getColor(R.color.color_333333));
            }
        }
    }

    @Override
    public void imageSizeIsZero() {
        initPictureDesc();
    }

    public void initPictureDesc() {
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
            photos = tempList;
            adapter.updateGridView(photos);
        }else if (requestCode == Constance.REQUESTCODE_MSGEDIT && resultCode == RESULT_OK) {
            String path = data.getStringExtra(Constance.BEAN_STRING);
            int position = data.getIntExtra(Constance.BEAN_INT, 0);
            //编辑了图片回调
            photos.get(position).imagePath = path;
            adapter.updateGridView(photos);
        }
    }

    public void savaClick() {
        createCustomDialog();
        LUtils.e("------------------------show");
        FileUpData();
    }

    RequestParams params;

    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                MessageEntity msg = (MessageEntity) getIntent().getSerializableExtra(Constance.MSG);
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                params.addBodyParameter("msg_id", msg.getMsg_id() + "");
                params.addBodyParameter("group_id", msg.getGroup_id());
                params.addBodyParameter("class_type", msg.getClass_type());
                params.addBodyParameter("reply_type", msg.getMsg_type());
                params.addBodyParameter("bill_id", msg.getBill_id());
                params.addBodyParameter("msg_type", msg.getMsg_type());
                String content = ed_desc.getText().toString().trim();
                if (!TextUtils.isEmpty(content)) {
                    params.addBodyParameter("reply_text", content);
                }
                int qualityType = 0;
                if (type.equals("1")) {
                    qualityType = 2;
                } else if (type.equals("2")) {
                    if (rb_pass.isChecked()) {
                        qualityType = 3;
                        params.addBodyParameter("is_rect", "0");
                    } else {
                        qualityType = 1;
                        params.addBodyParameter("is_rect", "1");
                    }

                }
                params.addBodyParameter("statu", qualityType + "");
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, selectedPhotoPath(), mActivity);
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
                    taskStatusChange();
                    break;
            }

        }
    };

    /**
     * 回复任务
     */
    protected void taskStatusChange() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.REPLYMESSAGE,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                                if (bean.getState() != 0) {
//                                    if (null != dialog) {
//                                        dialog.dismissDialog();
//                                    }
                                    mActivity.setResult(RectificationInstructionsActivity.FINISH, getIntent());
                                    finish();
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                    finish();
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
}
