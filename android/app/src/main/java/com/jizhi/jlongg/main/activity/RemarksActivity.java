package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.dialog.SystemDateDialog;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MediaManager;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;



/**
 * CName:
 * User: hcs
 * Date: 2016-04-21
 * Time: 16:55
 */
public class RemarksActivity extends BaseActivity implements OnSquaredImageRemoveClick {

    private RemarksActivity mActivity;
    /**
     * 拍照数据
     */
    public static final String PHOTO_DATA = "PHOTO_DATA";
    /**
     * 语音路径
     */
    public static final String VOICE_PATH = "VOICE_PATH";
    /**
     * 语音长度
     */
    public static final String VOICE_LENGTH = "VOICE_LENGTH";
    /**
     * 备注描述
     */
    public static final String REMARK_DESC = "REMARK_DESC";
    /**
     * 记账类型
     */
    public static final String ACCOUNT_TYPE = "ACCOUNT_TYPE";
    /**
     * 开工时间
     */
    public static final String STRAT_TIME = "START_TIME";
    /**
     * 完工时间
     */
    public static final String END_TIME = "END_TIME";

    /**
     * 图片数据
     */
    public List<ImageItem> photos;
    /***
     * 备注信息
     */
    @ViewInject(R.id.ed_remark)
    private EditText ed_remark;

    /**
     * 图片适配器
     */
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;

    /**
     * 开工时间选择框
     */
    private SystemDateDialog startDialog;
    /**
     * 完工时间选择框
     */
    private SystemDateDialog endDialog;
    /**
     * 开工时间值
     */
    private int timeStartworkInt;
    /**
     * 结束时间值
     */
    private int timeEndworkInt;
    /**
     * 开工时间
     */
    @ViewInject(R.id.tv_time_startwork)
    public TextView timeStartwork;
    /**
     * 完工时间
     */
    @ViewInject(R.id.tv_time_endwork)
    public TextView timeEndwork;
    /**
     * 开工时间结束时间布局
     */
    @ViewInject(R.id.start_end_time_layout)
    public LinearLayout start_end_time_layout;
    //1包工记账显示开始日期结算日期
    private int workType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_remark);
        ViewUtils.inject(this);
        initView();
        Acp.getInstance(getApplicationContext()).request(new AcpOptions.Builder()
                        .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE)
                        .build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                    }
                });


    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param remark     备注
     * @param imageItems 图片
     */
    public static void actionStart(Activity context, String remark, List<ImageItem> imageItems) {
        Intent intent = new Intent(context, RemarksActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString(RemarksActivity.REMARK_DESC, remark);
        bundle.putSerializable(RemarksActivity.PHOTO_DATA, (Serializable) imageItems);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUEST_ACCOUNT);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param remark        备注
     * @param imageItems    图片
     * @param startWorkTime 开工时间（包工记账）
     * @param endWorkTime   完工时间（包工记账）
     * @param account_type  1：包工记账需要显示考公时间完工时间
     */
    public static void actionStart(Activity context, String remark, List<ImageItem> imageItems, int startWorkTime, int endWorkTime, int account_type) {
        Intent intent = new Intent(context, RemarksActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString(RemarksActivity.REMARK_DESC, remark);
        bundle.putSerializable(RemarksActivity.PHOTO_DATA, (Serializable) imageItems);
        bundle.putInt(RemarksActivity.STRAT_TIME, startWorkTime);
        bundle.putInt(RemarksActivity.END_TIME, endWorkTime);
        bundle.putInt(RemarksActivity.ACCOUNT_TYPE, account_type);
        intent.putExtras(bundle);

        LUtils.e(remark+",,,," +startWorkTime+",," +endWorkTime);
        context.startActivityForResult(intent, Constance.REQUEST_ACCOUNT);
    }

    public void initView() {
        setTextTitle(R.string.remark_title);
        mActivity = RemarksActivity.this;
        findViewById(R.id.rea_voice).setVisibility(View.GONE);
        ((TextView) findViewById(R.id.tv_other)).setText(Html.fromHtml("备注" + "<font color='#999999'>(该备注信息仅自己可见)</font>"));
        Intent intent = getIntent();
        photos = new ArrayList<>();
        List<ImageItem> tempList = (List<ImageItem>) intent.getSerializableExtra(PHOTO_DATA);
        if (tempList != null && tempList.size() > 0) {
            photos.addAll(tempList);
        }
        initOrUpDateAdapter();
        ed_remark.setText(intent.getStringExtra(REMARK_DESC));//获取备注信息
        workType = intent.getIntExtra(ACCOUNT_TYPE, 0);
        if (workType == 1) {
            timeStartworkInt = intent.getIntExtra(STRAT_TIME, 0); //开始日期
            timeEndworkInt = intent.getIntExtra(END_TIME, 0); //结束时间
            timeStartwork.setText(TimesUtils.ChageStrToDate(timeStartworkInt + ""));
            timeEndwork.setText(TimesUtils.ChageStrToDate(timeEndworkInt + ""));
            start_end_time_layout.setVisibility(View.VISIBLE);
        } else {
            start_end_time_layout.setVisibility(View.GONE);
        }
    }


    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = findViewById(R.id.wrap_grid);
            adapter = new SquaredImageAdapter(this, this, photos, 4);
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
                                        CameraPop.multiSelector(mActivity, mSelected, 4);
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

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = photos.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = photos.get(i);
            mSelected.add(item.imagePath);

        }
        return mSelected;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        MediaManager.release();
    }


    public void onFinish(View view) {
        putReturnParameter();
        finish();
    }


    public void putReturnParameter() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable(PHOTO_DATA, (Serializable) photos);
        bundle.putString(REMARK_DESC, ed_remark.getText().toString().trim());

        if (workType == 1) {
            bundle.putInt(STRAT_TIME, timeStartworkInt);
            bundle.putInt(END_TIME, timeEndworkInt);
        }

        hideSoftKeyboard();
        intent.putExtras(bundle);
        setResult(Constance.REMARK_SUCCESS, intent);
    }

    @Override
    public void onBackPressed() {
        putReturnParameter();
        super.onBackPressed();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
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

            for (int i = 0; i < tempList.size(); i++) {
                tempList.get(i).isNetPicture = false;
                for (int j = 0; j < photos.size(); j++) {
                    if (tempList.get(i).imagePath.equals(photos.get(j).imagePath) && !tempList.get(i).imagePath.contains("/storage/")) {
                        tempList.get(i).isNetPicture = true;
                    }
                }
                photos = tempList;
                adapter.updateGridView(photos);
            }
        }
    }

    //开工时间
    @OnClick(R.id.re_time_startwork)
    private void re_time_startwork(View view) {
        if (startDialog != null) {
            startDialog.setIsClickCancel(false);
            startDialog.getDialog().show();
            return;
        }
        startDialog = new SystemDateDialog();
        startDialog.showDialog(mActivity, "开工时间", timeStartwork, new SystemDateDialog.SystemDateCallBack() {
            @Override
            public void getTimestamp(int time) {
                timeStartworkInt = time;
            }

            @Override
            public boolean getDate(int year, int month, int dayOfMonth) {
                if (timeEndworkInt != 0 && year * 10000 + (month + 1) * 100 + dayOfMonth > timeEndworkInt) {
                    CommonMethod.makeNoticeShort(mActivity, "所选时间必须在在完工时间之前", CommonMethod.ERROR);
                    return false;
                }
                return true;
            }
        });
    }

    //结束时间
    @OnClick(R.id.re_time_endwork)
    private void re_time_endwork(View view) {
        if (timeStartworkInt == 0) {
            CommonMethod.makeNoticeShort(mActivity, "请选择开工时间", CommonMethod.ERROR);
            return;
        }
        if (endDialog != null) {
            endDialog.setIsClickCancel(false);
            endDialog.getDialog().show();
            return;
        }
        endDialog = new SystemDateDialog();
        endDialog.showDialog(mActivity, "完工时间", timeEndwork, new SystemDateDialog.SystemDateCallBack() {
            @Override
            public void getTimestamp(int time) {
                timeEndworkInt = time;
            }

            @Override
            public boolean getDate(int year, int month, int dayOfMonth) {

                if (year * 10000 + (month + 1) * 100 + dayOfMonth < timeStartworkInt) {
                    CommonMethod.makeNoticeShort(mActivity, "完工时间必须大于开工时间", CommonMethod.ERROR);
                    return false;
                }
                return true;
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
            stringBuffer.append(photos.get(position).imagePath + ";");
        } else {
        }
        photos.remove(position);
        adapter.notifyDataSetChanged();
    }
}
