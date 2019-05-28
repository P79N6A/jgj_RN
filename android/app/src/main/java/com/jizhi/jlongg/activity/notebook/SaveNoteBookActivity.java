package com.jizhi.jlongg.activity.notebook;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.bigkoo.pickerview.TimePickerView;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.SrcollEditText;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能:记录记事本
 * 时间:2018/4/18 20.08
 * 作者:hcs
 */

public class SaveNoteBookActivity extends BaseActivity implements OnSquaredImageRemoveClick, View.OnClickListener {
    private SaveNoteBookActivity mActivity;
    //内容
    private SrcollEditText ed_content;
    //标题
    private RadioButton rb_title;
    //关闭
    private ImageView img_finish;
    //保存
    private TextView tv_save;
    //选中时间，开始时间，结束时间
    private Calendar selectedDate, startDate, endDate;
    //上传给服务器的时间格式和星期
    private String timeStr, weekStr;
    private NoteBook noteBook;
    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;
    /* 上传图片的最大数 */
    private int MAXPHOTOCOUNT = 9;

    private String noteBookType = "notebook";
    /* 图片数据 */
    private List<ImageItem> imageItems = new ArrayList<>();
    /* 是否标记为重要 */
    private boolean isImporant;
    /* 是否重要 */
    private TextView isImportantText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notebook_save);
        getIntentData();
        initView();
        initImage();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, NoteBook noteBook) {
        Intent intent = new Intent(context, SaveNoteBookActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, noteBook);
        context.startActivityForResult(intent, Constance.REQUEST);
        context.overridePendingTransition(R.anim.scan_login_open, R.anim.scan_login_close);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param noteBook
     * @param year     年
     * @param month    月 比如是2月份就传2月份
     * @param date     日
     */
    public static void actionStart(Activity context, NoteBook noteBook, int year, int month, int date) {
        Intent intent = new Intent(context, SaveNoteBookActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, noteBook);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.DATE, date);
        context.startActivityForResult(intent, Constance.REQUEST);
        context.overridePendingTransition(R.anim.scan_login_open, R.anim.scan_login_close);
    }

    public void getIntentData() {
        Intent intent = getIntent();
        noteBook = (NoteBook) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = SaveNoteBookActivity.this;
        ed_content = findViewById(R.id.ed_content);
        rb_title = findViewById(R.id.rb_title);
        img_finish = findViewById(R.id.img_finish);
        tv_save = findViewById(R.id.tv_save);
        isImportantText = findViewById(R.id.is_important_text);
        //初始化默认显示时间
        Intent intent = getIntent();
        int year = intent.getIntExtra(Constance.YEAR, 0);
        int month = intent.getIntExtra(Constance.MONTH, 0);
        int day = intent.getIntExtra(Constance.DATE, 0);
        Calendar calendar = Calendar.getInstance();
        //初始化时间选择器开始跟结束时间
        startDate = Calendar.getInstance();
        startDate.set(2014, 0, 23);
        endDate = Calendar.getInstance();
        endDate.set(calendar.get(Calendar.YEAR) + 2, calendar.get(Calendar.MONTH) , calendar.get(Calendar.DAY_OF_MONTH));
        if (year != 0 && month != 0 && day != 0) {
            calendar.set(Calendar.YEAR, year);
            calendar.set(Calendar.MONTH, month - 1);
            calendar.set(Calendar.DAY_OF_MONTH, day);
        } else {
            year = calendar.get(Calendar.YEAR);
            month = calendar.get(Calendar.MONTH) + 1;
            day = calendar.get(Calendar.DAY_OF_MONTH);
        }
        selectedDate = calendar;
        if (null == noteBook) { //新建记事本
            timeStr = year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day);
            weekStr = TimesUtils.parseDateToYearMonthDayWeek(selectedDate.get(Calendar.DAY_OF_WEEK));
            rb_title.setText(year + "年" + month + "月" + day + "日 " + weekStr);
            readLocalInfo();
        } else { //修改记事本
            if (!TextUtils.isEmpty(noteBook.getPublish_time())) {
                timeStr = getYYYYMMDDDateStr(noteBook.getPublish_time());
                if (!TextUtils.isEmpty(noteBook.getWeekday())) {
                    weekStr = noteBook.getWeekday();
                    rb_title.setText(getDateStr(noteBook.getPublish_time()) + " " + weekStr);
                } else {
                    rb_title.setText(getDateStr(noteBook.getPublish_time()));
                }
                ed_content.setText(noteBook.getContent());
                ed_content.setSelection(noteBook.getContent().length());
            }
            isImporant = noteBook.getIs_import() == 1;
        }

        rb_title.setOnClickListener(this);
        img_finish.setOnClickListener(this);
        tv_save.setOnClickListener(this);
        isImportantText.setOnClickListener(this);
        findViewById(R.id.add_pic_text).setOnClickListener(this);
        initImporant();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rb_title:
                hideSoftKeyboard();
                showTimePickView();
                break;
            case R.id.img_finish:
                hideSoftKeyboard();
                if (null == noteBook) {
                    saveAndClearLocalInfo(true);
                }
                mActivity.finish();
                break;
            case R.id.tv_save:
                String noteStr = ed_content.getText().toString().trim();
                if (TextUtils.isEmpty(noteStr) || noteStr.length() < 2) {
                    CommonMethod.makeNoticeShort(mActivity, "请至少输入2个字", CommonMethod.ERROR);
                    return;
                }
                FileUpData();
                break;
            case R.id.is_important_text: //是否重要的标识
                isImporant = !isImporant;
                initImporant();
                break;
            case R.id.add_pic_text://添加图片
                Acp.getInstance(mActivity).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                        , Manifest.permission.CAMERA)
                                .build(),
                        new AcpListener() {
                            @Override
                            public void onGranted() {
                                ArrayList<String> mSelected = selectedPhotoPath();
                                CameraPop.multiSelector(mActivity, mSelected, MAXPHOTOCOUNT);
                            }

                            @Override
                            public void onDenied(List<String> permissions) {
                                CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                            }
                        });
                break;
        }
    }


    private void initImporant() {
        isImportantText.setTextColor(ContextCompat.getColor(getApplicationContext(), isImporant ? R.color.color_ff6600 : R.color.color_333333));
        isImportantText.setText(isImporant ? "重要" : "标记为重要");
        Drawable mClearDrawable = getResources().getDrawable(isImporant ? R.drawable.publish_notes_imporant : R.drawable.publish_notes_no_imporant);
        mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
        isImportantText.setCompoundDrawables(mClearDrawable, null, null, null);
    }

    /**
     * 初始化图片路径
     */
    public void initImage() {
        if (null != noteBook && null != noteBook.getImages()) {
            for (String localpath : noteBook.getImages()) {
                ImageItem item = new ImageItem();
                item.imagePath = localpath;
                item.isNetPicture = true;
                imageItems.add(item);
                LUtils.e(localpath + ",,,,,图片路径,,,,,,,,");
            }
        }
        initOrUpDateAdapter();
    }

    /**
     * 初始化图片选择
     */

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.wrap_grid);
            adapter = new SquaredImageAdapter(this, this, imageItems, MAXPHOTOCOUNT);
            adapter.setShowAddIcon(false);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
//                    if (position == imageItems.size()) {
//                        Acp.getInstance(mActivity).request(new AcpOptions.Builder()
//                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
//                                                , Manifest.permission.CAMERA)
//                                        .build(),
//                                new AcpListener() {
//                                    @Override
//                                    public void onGranted() {
//                                        ArrayList<String> mSelected = selectedPhotoPath();
//                                        CameraPop.multiSelector(mActivity, mSelected, MAXPHOTOCOUNT);
//                                    }
//
//                                    @Override
//                                    public void onDenied(List<String> permissions) {
//                                        CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
//                                    }
//                                });
//                    } else {
                    Bundle bundle = new Bundle();
                    bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) imageItems);
                    bundle.putInt(Constance.BEAN_INT, position);
                    Intent intent = new Intent(mActivity, PhotoZoomActivity.class);
                    intent.putExtras(bundle);
                    startActivity(intent);
//                    }
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
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);

        }
        return mSelected;
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
                for (int j = 0; j < imageItems.size(); j++) {
                    if (tempList.get(i).imagePath.equals(imageItems.get(j).imagePath) && !tempList.get(i).imagePath.contains("/storage/")) {
                        tempList.get(i).isNetPicture = true;
                    }
                }
                imageItems = tempList;
                adapter.updateGridView(imageItems);
            }
        }
    }

    public String getDateStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf2.format(date); //改变格式
            //获取默认选中的日期的年月日星期的值，并赋值
            Calendar calendar = Calendar.getInstance();//日历对象
            calendar.setTime(date);//设置当前日期
            int yearStr = calendar.get(Calendar.YEAR);//获取年份
            int month = calendar.get(Calendar.MONTH);//获取月份
            int day = calendar.get(Calendar.DATE);//获取日
            selectedDate.set(Calendar.YEAR, yearStr);
            selectedDate.set(Calendar.MONTH, month);
            selectedDate.set(Calendar.DAY_OF_MONTH, day);
            LUtils.e(yearStr + "," + yearStr + "," + month);

        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }

    public String getYYYYMMDDDateStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf1.format(date); //改变格式
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }

    /**
     * 显示时间view
     */
    public void showTimePickView() {
        TimePickerView pvTime = new TimePickerView.Builder(this, new TimePickerView.OnTimeSelectListener() {
            @Override
            public void onTimeSelect(Date date, View v) {
                //选中事件回调
                //解析选中时间的 年月日时分
                int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
                int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
                int dayOfMonth = Integer.parseInt(new SimpleDateFormat("dd").format(date));
//                if (AccountUtil.TimeJudgment(mActivity, null, year, month, dayOfMonth)) {
//                    return;
//                }
                selectedDate.set(Calendar.YEAR, year);
                selectedDate.set(Calendar.MONTH, month - 1);
                selectedDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                weekStr = TimesUtils.getwhichDayWeeks(year, month, dayOfMonth);
                rb_title.setText(year + "年" + month + "月" + dayOfMonth + "日 " + weekStr);
                timeStr = new SimpleDateFormat("yyyy-MM-dd").format(date);
                LUtils.e(timeStr + ",,,,,,,,,,,,");
            }
        })
                //年月日时分秒 的显示与否，不设置则默认全部显示
                .setType(new boolean[]{true, true, true, false, false, false})
                .setCancelText("取消")
                .setSubmitText("确定")
                .setTitleText("选择时间")
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
                .setDividerColor(getResources().getColor(R.color.color_dbdbdb))
                .setDate(selectedDate)
                .setRangDate(startDate, endDate)
                .setBackgroundId(0x66000000) //设置外部遮罩颜色
                .setDecorView(null)
                .build();

        pvTime.show();
    }

    RequestParams params;

    public void FileUpData() {
        createCustomDialog();
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                List<String> tempPhoto = null;
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
                    if (tempPhoto == null) {
                        tempPhoto = new ArrayList<>();
                    }
                    int size = imageItems.size();
                    for (int i = 0; i < size; i++) {
                        ImageItem item = imageItems.get(i);
                        if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                            tempPhoto.add(imageItems.get(i).imagePath);
                        }
                    }
                    if (tempPhoto.size() > 0) {
                        RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, mActivity);
                        Message message = Message.obtain();
                        message.obj = params;
                        message.what = 0X01;
                        mHandler.sendMessage(message);
                    } else {
                        Message message = Message.obtain();
                        message.obj = params;
                        message.what = 0X02;
                        mHandler.sendMessage(message);
                    }
                } else {
                    Message message = Message.obtain();
                    message.obj = params;
                    message.what = 0X02;
                    mHandler.sendMessage(message);
                }

            }
        });
        thread.start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    Upload();
                    break;
                case 0X02:
                    addNoteBook(true, null);
                    break;
            }

        }
    };

    /**
     * 上传图片
     */
    public void Upload() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD_NEW, params, new RequestCallBack() {
            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonNewListJson base = CommonNewListJson.fromJson(responseInfo.result.toString(), String.class);
                    if (base.getMsg().equals(Constance.SUCCES_S)) {
                        LUtils.e("--------------base.getResult()---------" + base.getResult());
                        addNoteBook(false, base.getResult());
                    } else {
                        closeDialog();
                        DataUtil.showErrOrMsg(mActivity, base.getCode() + "", base.getMsg());
                    }
                    if (null == noteBook) {
                        SPUtils.put(mActivity, noteBookType, "", Constance.JLONGG);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                closeDialog();
            }

        });
    }

    /**
     * 新增/跟新记事本单条记录
     */
    public void addNoteBook(boolean isShowDialog, List<String> list) {
        String httpUrl = NetWorkRequest.ADD_NOTEBOOK;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("content", ed_content.getText().toString().trim());
        params.addBodyParameter("publish_time", timeStr + " " + new SimpleDateFormat("HH:mm:ss").format(new Date()));
        params.addBodyParameter("weekday", weekStr);
        params.addBodyParameter("is_import", isImporant ? "1" : "0");
        StringBuffer buffer = new StringBuffer();
        if (null != list && list.size() > 0) {
            for (String path : list) {
                buffer.append(path + ",");
            }
        }
        if (imageItems != null && imageItems.size() > 0) {
            for (ImageItem imageItem : imageItems) {
                if (imageItem.isNetPicture) {
                    buffer.append(imageItem.imagePath + ",");
                }
            }
        }
        if (!TextUtils.isEmpty(buffer.toString()) && buffer.toString().length() > 4) {
            params.addBodyParameter("images", buffer.toString().substring(0, buffer.toString().length() - 1));
        }
        if (null != noteBook) {
            httpUrl = NetWorkRequest.PUR_NOTEBOOK;
            params.addBodyParameter("id", noteBook.getId());
        }
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, CommonHttpRequest.LIST, params, isShowDialog, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                closeDialog();
                if (null == noteBook) {
                    SPUtils.put(mActivity, noteBookType, "", Constance.JLONGG);
                }
                setResult(Constance.REQUEST);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
//        overridePendingTransition(R.anim.amin_top_bottom_out, R.anim.amin_top_bottom_out);
        hideSoftKeyboard();
        if (null == noteBook) {
            saveAndClearLocalInfo(true);
        }
    }

    /**
     * 保存草稿信息
     */
    public void saveAndClearLocalInfo(boolean isSava) {
        String content = ed_content.getText().toString().trim();
        if (TextUtils.isEmpty(content) && isSava) {
            return;
        }
        try {
            SPUtils.put(mActivity, noteBookType, content, Constance.JLONGG);
        } catch (Exception e) {

        }

    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(0, R.anim.scan_login_close);
    }

    /**
     * 读取草稿信息
     */
    public void readLocalInfo() {
        try {
            String content = (String) SPUtils.get(mActivity, noteBookType, "", Constance.JLONGG);
            if (!TextUtils.isEmpty(content)) {
                ed_content.setText(content);
                ed_content.setSelection(content.length());
            }
        } catch (Exception e) {
        }

    }

    @Override
    public void remove(int position) {
        imageItems.remove(position);
        adapter.notifyDataSetChanged();
    }


}
