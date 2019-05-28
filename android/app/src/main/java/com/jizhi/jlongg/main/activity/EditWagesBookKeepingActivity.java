package com.jizhi.jlongg.main.activity;


import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.OneBillDetail;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.main.activity.welcome.WelcomeActivity;
import com.jizhi.jongg.widget.VoiceImage;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.io.File;
import java.util.List;

/**
 * 功能:编辑结算
 * 时间:2016-3-15 16:55
 * 作者: lilong
 */
public class EditWagesBookKeepingActivity extends EditorAccountAbstractActivity implements AccountPhotoGridAdapter.PhotoDeleteListener, CheckBillDialog.MpoorinfoCLickListener, CheckBillDialog.ShowPoorClickListener {
    /**
     * 记账姓名
     */
    @ViewInject(R.id.per_name)
    private TextView perName;
    /**
     * 薪资
     */
    @ViewInject(R.id.salary)
    private TextView salary;
    /**
     * 提交时间
     */
    @ViewInject(R.id.submitTime)
    private TextView submitTime;
    /**
     * 主页面activity
     */
    private EditWagesBookKeepingActivity mActivity;
    /**
     * 薪资填写
     */
    @ViewInject(R.id.ed_salary)
    public EditText ed_salary;
    private boolean isPush;
    @ViewInject(R.id.voiceRemoveImage)
    private ImageView voiceRemoveImage;
    private String price;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_borrowing_pricemoder);
        ViewUtils.inject(this);
        workType = AccountUtil.SALARY_BALANCE;
        initialize();
    }


    /**
     * 初始化数据
     */
    private void initialize() {
        if (TextUtils.isEmpty(record_id) || record_id.equals("-1")) {
            CommonMethod.makeNoticeShort(mActivity, "核对工作信息不成功", CommonMethod.ERROR);
            finish();
            return;
        }
        initView();
        mActivity = EditWagesBookKeepingActivity.this;
        TextView text = (TextView) findViewById(R.id.roletype);
        switch (roleType) { //判断角色改变文字
            case Constance.ROLETYPE_FM: //当前登录状态为工头时  则显示工头
                text.setText(getString(R.string.workers));
                break;
            case Constance.ROLETYPE_WORKER: //当前登录状态为工友时  则显示工友
                text.setText(getString(R.string.foreman));
                break;
        }
        getTextView(R.id.title).setText(R.string.edit);
        ((TextView) findViewById(R.id.tv)).setText(getString(R.string.wages_settlement));
        perName.setTextColor(getResources().getColor(R.color.texthintcolor));
        ed_salary.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String temp = s.toString();
                if (temp.startsWith(".") || temp.startsWith("0")) {
                    CommonMethod.makeNoticeShort(mActivity, "首位不能出现小数点或0!", CommonMethod.ERROR);
                    ed_salary.setText(null);
                    return;
                }
//                int index = temp.indexOf(".");
//                if (index > 0) {
//                    boolean access = true;
//                    if (index != temp.lastIndexOf(".")) { //不能出现2位小数点
//                        access = false;
//                    }
//                    if ((temp.length() - 1) - index > 2) { //保留小数点两位
//                        CommonMethod.makeNoticeShort(mActivity, "只能输入2位小数!", CommonMethod.ERROR);
//                        access = false;
//                    }
//                    if (!access) {
//                        ed_salary.setText(temp.substring(0, temp.length() - 1));
//                        return;
//                    }
//                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                if (ed_salary.getText().toString().equals("")) {
                    salary.setText("0.00");
                } else {
                    salary.setText(ed_salary.getText().toString());
                }
            }
        });
        setEditTextDecimalNumberLength(ed_salary, 2);
        getDetailInfo();
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param decimal_place
     */
    public void setEditTextDecimalNumberLength(EditText editText, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(6, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }


    }

    public void initView() {
        Typeface fontFace = Typeface.createFromAsset(getAssets(), "IMPACT.TTF");
        // 字体文件必须是true type font的格式(ttf)；
        // 当使用外部字体却又发现字体没有变化的时候(以 Droid Sans代替)，通常是因为
        // 这个字体android没有支持,而非你的程序发生了错误
        salary.setTypeface(fontFace);
        (findViewById(R.id.rea_top)).setBackgroundResource(R.drawable.icon_account_edit_borrow_up);
        textPhoto = (TextView) findViewById(R.id.textPhoto);
        ed_remark = (EditText) findViewById(R.id.ed_remark);
        recordProject = (TextView) findViewById(R.id.recordProject);
        voiceButton = (VoiceImage) findViewById(R.id.voiceButton); //语音按钮
        voiceLayout = (RelativeLayout) findViewById(R.id.voiceLayout); //语音布局
        voiceRedItemImage = (ImageView) findViewById(R.id.voiceRedItemImage); //语音红条
        voiceTime = (TextView) findViewById(R.id.voiceTime); //语音时长
        voiceAnimationImage = (ImageView) findViewById(R.id.voiceAnimationImage); //语音动画图片
        voiceText = (TextView) findViewById(R.id.voiceText); //语音文字
        voiceRemoveImage.setOnClickListener(this);
    }

    //访问服务器得到：某一条记账信息详情
    private void getDetailInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("id", record_id + "");
        if (isGroupBill) {
            params.addBodyParameter("my_role_type", roleType);
        } else {
            params.addBodyParameter("role", roleType);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GETONEBILLDETAIL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<OneBillDetail> status = CommonJson.fromJson(responseInfo.result, OneBillDetail.class);
                    if (status.getState() != 0) {
                        if (status.getValues() != null) {
                            setValue(status.getValues());
                        }
                    } else {
                        CommonMethod.makeNoticeShort(EditWagesBookKeepingActivity.this, status.getErrmsg(), CommonMethod.ERROR);
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(EditWagesBookKeepingActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }

            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }


    //访问服务器后，设置界面
    private void setValue(OneBillDetail bean) {
        uid = bean.getUid() + "";
        perName.setText(bean.getName());
        ed_salary.setText(Utils.m2(bean.getSalary()) + "");
        pid = bean.getPid();
        recordProject.setText(bean.getProname());
        submitTime.setText(bean.getDate());
        ed_remark.setText(bean.getNotes_txt());
        loadDefaultPhotoGridViewData();
        //差帐图标
        //差帐图标
        if (bean.getModify_marking() == 2) { //等待自己确认
            ((ImageView) findViewById(R.id.desc_image)).setImageResource(R.drawable.yellow_waring_account);
            (findViewById(R.id.desc_image)).setVisibility(View.VISIBLE);
        } else if (bean.getModify_marking() == 3) { //等待对方修改
            ((ImageView) findViewById(R.id.desc_image)).setImageResource(R.drawable.blue_waring_account);
            (findViewById(R.id.desc_image)).setVisibility(View.VISIBLE);
        } else {
            (findViewById(R.id.desc_image)).setVisibility(View.GONE);
        }
        if (bean.getModify_marking() == 2 || (bean.getModify_marking() == 3)) {
            if (isPush) {
                RecordUtils.getShowPoor(mActivity, record_id, mActivity);
            }
        }
        String[] imagePaths = bean.getNotes_img();
        if (imagePaths != null && imagePaths.length > 0) {
            int size = imagePaths.length;
            for (int i = size - 1; i >= 0; i--) {
                ImageItem item = new ImageItem();
                item.imagePath = imagePaths[i];
                item.isNetPicture = true;
                photos.add(item);
            }
        }
        voiceLength = bean.getVoice_length();
        initVoice(bean.getNotes_voice());
        initPhoto();
        LUtils.e("--------------------" + bean.getSalary() + "");
        salary.setText(Utils.m2(bean.getSalary()) + "");
    }


    private RequestParams getParams() {
        String data = submitTime.getText().toString().replace("年", "").replace("月", "").replace("日", "");
        String project_name = recordProject.getText().toString();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("id", record_id + "");
        params.addBodyParameter("accounts_type", AccountUtil.SALARY_BALANCE);
        params.addBodyParameter("name", perName.getText().toString());
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("date", data.substring(0, 8));
        params.addBodyParameter("salary", ed_salary.getText().toString());
        params.addBodyParameter("pro_name", TextUtils.isEmpty(project_name) ? "" : project_name); //项目名称
        params.addBodyParameter("pid", pid == 0 ? "" : pid + "");
        params.addBodyParameter("text", ed_remark.getText().toString());
        List<String> remove_picture_path = adapter.getDeleteNetImage();
        if (remove_picture_path != null && remove_picture_path.size() > 0) {
            StringBuffer sb = new StringBuffer();
            for (int j = 0; j < remove_picture_path.size(); j++) {
                if (j == 0) {
                    sb.append(remove_picture_path.get(j));
                } else {
                    sb.append(";" + remove_picture_path.get(j));
                }
            }
            params.addBodyParameter("delimg", sb.toString());//需要删除的网络图片路径
        }
        //如果没有修改语音
        if (!isChangedVoice) {
            params.addBodyParameter("voice_length", voiceLength + "");
        } else {

            if (TextUtils.isEmpty(voicePath)) {//是否修改了语音
                params.addBodyParameter("voice", "");
                params.addBodyParameter("voice_length", 0 + "");
            } else {
                params.addBodyParameter("voice", new File(voicePath));
                params.addBodyParameter("voice_length", voiceLength + "");
            }
        }
        if (isGroupBill) {
            params.addBodyParameter("my_role_type", roleType);
        } else {
            params.addBodyParameter("role", roleType);
        }
        return params;
    }


    /**
     * 选择与我有关的项目
     */
    @OnClick(R.id.re_record_project)
    public void recordProject(View view) {
        if (projectList != null) {
            createProjectWheelView();
            return;
        }
        AccountHttpUtils.IRelatedProjects(mActivity, new AccountHttpUtils.AccountIRelatedListener() {
            @Override
            public void IRelatedProjectsSuccess(List<Project> list) {
                projectList = list;
                createProjectWheelView();
            }
        }, false);
    }

    /**
     * 所在项目
     */
    public void createProjectWheelView() {
        if (addProject == null) {
            addProject = new WheelViewAboutMyProject(editorAccountAbstractActivity, projectList, false);
            addProject.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    String proname = projectList.get(postion).getPro_name();
                    if (!TextUtils.isEmpty(proname)) {
                        pid = projectList.get(postion).getPid();
                        recordProject.setText(proname);
                    }
                }
            });
        } else {
            addProject.update();
        }
        //显示窗口
        addProject.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }


    /**
     * 保存记账信息
     */
    public void modificationBookKingWorkerHourPriceMode() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFYRELASE, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        CommonMethod.makeNoticeShort(mActivity, getString(R.string.hint_changebill), CommonMethod.SUCCESS);
                        Intent intent = new Intent();
                        intent.putExtra(Constance.PID, pid);
                        intent.putExtra(Constance.BEAN_STRING, recordProject.getText().toString());
                        setResult(Constance.DISPOSEATTEND_RESULTCODE, intent);
                        FUtils.deleteFile(new File(Constance.VOICEPATH));
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(mActivity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

    @OnClick(R.id.save)
    public void save(View view) {
        if (salary.getText().toString().equals("0.00")) {
            CommonMethod.makeNoticeShort(mActivity, "请输入借支金额", CommonMethod.ERROR);
            return;
        }
        FileUpData();
    }

    @OnClick(R.id.delete)
    public void delete(View view) {
        CommonMethod.makeNoticeShort(mActivity, "删除", CommonMethod.ERROR);
        delsetmount();
        return;
    }

    /**
     * 删除
     */
    public void delsetmount() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", record_id);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELSETSMOUNT, params,
                    new RequestCallBackExpand<String>() {
                        @SuppressWarnings("deprecation")
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<CityInfoMode> bean = CommonListJson.fromJson(responseInfo.result, CityInfoMode.class);
                                if (bean.getState() == 0) {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                } else {
                                    if (bean.getValues().size() > 0 && bean.getValues().get(0).getSource() == 1) {
                                        //平台用户
                                        CommonMethod.makeNoticeShort(mActivity, "记账删除成功\n" +
                                                    "和他工账有差异,请及时核对", CommonMethod.ERROR);
                                    } else {
                                        CommonMethod.makeNoticeShort(mActivity, "删除成功", CommonMethod.ERROR);
                                    }

                                    setResult(Constance.DISPOSEATTEND_RESULTCODE, getIntent());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                            }
                            closeDialog();
                        }
                    });
    }

    //修改记账
    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 1:
                    modificationBookKingWorkerHourPriceMode();
                    break;
            }
            super.handleMessage(msg);
        }
    };

    //1发布记账 2保存在计
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


    public void initPhoto() {
        initPictureDesc();
        adapter = new AccountPhotoGridAdapter(mActivity, photos, this);
        GridView gridView = (GridView) findViewById(R.id.gridView);
        gridView.setAdapter(adapter);
    }


    @Override
    public void imageSizeIsZero() {
        initPictureDesc();
    }


    @Override
    public void onFinish(View view) {
        isPush();
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        isPush();
        super.onBackPressed();
    }


    public void isPush() {
        //&& UclientApplication.getInstance().getActivities().size() == 1
        if (isPush) {
            startActivity(new Intent(getApplicationContext(), WelcomeActivity.class));
        }
    }

    @Override
    public void mpporClick(DiffBill bean, String type,View agreeBtn) {
        mpporClicks(bean, type);
    }

    @Override
    public void showPoorClick(DiffBill diffBill) {
        this.diffBill = diffBill;
        if (diaglog == null) {
            diaglog = new CheckBillDialog(mActivity, workType, diffBill, mActivity);
        } else {
            diaglog.setValue(AccountUtil.HOUR_WORKER, diffBill);
        }
        diaglog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

}
