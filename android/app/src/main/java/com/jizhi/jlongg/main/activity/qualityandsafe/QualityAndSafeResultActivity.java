package com.jizhi.jlongg.main.activity.qualityandsafe;

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
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
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
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能: 未涉及,通过确认
 * 作者：胡常生
 * 时间: 2017年7月17日 16:56:12
 */
public class QualityAndSafeResultActivity extends BaseActivity implements AccountPhotoGridAdapter.PhotoDeleteListener, OnSquaredImageRemoveClick {
    private QualityAndSafeResultActivity mActivity;
    private EditText ed_desc;
    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    /* 上传图片的最大数 */
    private int MAXPHOTOCOUNT = 9;
    //1:未涉及；2：通过；
    private String type;
    private QualityAndsafeCheckMsgBean gnInfo;
    public static final int FINISH = 0X10;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_rectifation);
        initView();
        getIntentData();
        initOrUpDateAdapter();
//
    }

    /**
     * initView
     */
    public void initView() {
        mActivity = QualityAndSafeResultActivity.this;
        ed_desc = (EditText) findViewById(R.id.ed_desc);
        SetTitleName.setTitle(findViewById(R.id.right_title), "确定");
        type = getIntent().getStringExtra("statu");
        SetTitleName.setTitle(findViewById(R.id.title), "检查结果");
        ((TextView) findViewById(R.id.tv_hint)).setText("检查结果");
        ed_desc.setHint("检查说明(选填)");
        if (type.equals("1")) {
            ((TextView) findViewById(R.id.tv_hint1)).setText("[未涉及]");
            ((TextView) findViewById(R.id.tv_hint1)).setTextColor(getResources().getColor(R.color.color_333333));
        } else if (type.equals("2")) {
            ((TextView) findViewById(R.id.tv_hint1)).setText("[通过]");
            ((TextView) findViewById(R.id.tv_hint1)).setTextColor(getResources().getColor(R.color.color_83c76e));
        }
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
    public static void actionStart(Activity context, QualityAndsafeCheckMsgBean info, String type, int position) {
        Intent intent = new Intent(context, QualityAndSafeResultActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra("statu", type);
        intent.putExtra("position", position);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (QualityAndsafeCheckMsgBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
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
    public void remove(int position) {
        photos.remove(position);
        adapter.notifyDataSetChanged();
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


    public void savaClick() {
        createCustomDialog();
        FileUpData();
    }

    RequestParams params;

    public void FileUpData() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
//                progressNumber = 0;
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                params.addBodyParameter("uid", gnInfo.getUid()+"");
                params.addBodyParameter("principal_uid", gnInfo.getPrincipal_uid() + "");
                params.addBodyParameter("group_id", gnInfo.getGroup_id());
                params.addBodyParameter("class_type", gnInfo.getClass_type());
                params.addBodyParameter("msg_type", gnInfo.getMsg_type());
                params.addBodyParameter("insp_id", gnInfo.getInsp_id());
                params.addBodyParameter("pu_inpsid", gnInfo.getPu_inpsid());
                String content = ed_desc.getText().toString().trim();
                if (!TextUtils.isEmpty(content)) {
                    params.addBodyParameter("text", content);
                }
                if (type.equals("1")) {
                    params.addBodyParameter("status", "2");
                } else if (type.equals("2")) {
                    params.addBodyParameter("status", "3");

                }
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
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.RELAYINSPECTINFO,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                                if (bean.getState() != 0) {
                                    Intent intent = new Intent();
                                    intent.putExtra("position", getIntent().getIntExtra("position", -1));
                                    mActivity.setResult(Constance.RESULTCODE_FINISH, intent);
                                    finish();
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
//                                    Intent intent = new Intent();
//                                    intent.putExtra("insp_id", gnInfo.getInsp_id());
//                                    mActivity.setResult(Constance.RESULTCODE_FINISH, intent);
//                                    finish();
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
