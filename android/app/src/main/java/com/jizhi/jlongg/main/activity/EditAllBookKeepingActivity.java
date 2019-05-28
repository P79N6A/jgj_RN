package com.jizhi.jlongg.main.activity;


import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.EditTextM2;
import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
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
import com.jizhi.jlongg.main.dialog.SystemDateDialog;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StringUtil;
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
import java.math.BigDecimal;
import java.util.List;

/**
 * 功能:编辑包工
 * 时间:2016/3/12 19:02
 * 作者:lilong
 */
public class EditAllBookKeepingActivity extends EditorAccountAbstractActivity implements AccountPhotoGridAdapter.PhotoDeleteListener, EditTextM2.CalcPriceListener, CheckBillDialog.MpoorinfoCLickListener, CheckBillDialog.ShowPoorClickListener {
    private EditAllBookKeepingActivity mActivity;
    /**
     * 工人、工头名称
     */
    @ViewInject(R.id.per_name)
    private TextView perName;
    /**
     * 提交时间
     */
    @ViewInject(R.id.submitTime)
    private TextView submitTime;
    /**
     * 计算过后的价格
     */
    @ViewInject(R.id.salary)
    private TextView salaryTextView;
    /**
     * 分项名称
     */
    @ViewInject(R.id.sub_pro_name)
    private TextView sub_pro_name;
    /**
     * 单价
     */
    @ViewInject(R.id.per_prices)
    private EditText per_prices;
    /**
     * 数量
     */
    @ViewInject(R.id.quantities)
    private TextView quantities;
    /**
     * 数量单位
     */
    @ViewInject(R.id.tv_yuan)
    private TextView tv_yuan;
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
//    /**
//     * 计算后的工资
//     */
//    private double per_salary;
    /**
     * 开工时间时间选择框
     */
    private SystemDateDialog startDialog;
    /**
     * 结束时间选择框
     */
    private SystemDateDialog endDialog;
    /**
     * 开工时间int
     */
    private int timeStartworkInt;
    /**
     * 结束时间int
     */
    private int timeEndworkInt;
    private boolean isPush;
    @ViewInject(R.id.voiceRemoveImage)
    private ImageView voiceRemoveImage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (roleType.equals(Constance.ROLETYPE_WORKER)) {
            setContentView(R.layout.edit_worer_pricemode_all);
        } else {
            setContentView(R.layout.edit_forman_pricemode_all);
        }
        ViewUtils.inject(this);
        workType = AccountUtil.CONSTRACTOR;
        initialize(roleType);
    }

    /**
     * 初始化数据
     */
    private void initialize(String roletype) {
        if (TextUtils.isEmpty(record_id) || record_id.equals("-1")) {
            CommonMethod.makeNoticeShort(mActivity, "核对工作信息不成功", CommonMethod.ERROR);
            finish();
            return;
        }
        initView();
        getTextView(R.id.title).setText(R.string.edit);
        mActivity = EditAllBookKeepingActivity.this;
        TextView text = (TextView) findViewById(R.id.roletype);
        switch (roletype) { //判断角色改变文字
            case Constance.ROLETYPE_WORKER: //当前登录状态为工友时  则显示工头
                text.setText(getString(R.string.forman_headman));
                break;
            case Constance.ROLETYPE_FM: //当前登录状态为工头时  则显示工友
                text.setText(getString(R.string.workers));
                break;
        }
        new EditTextM2(per_prices, 2, this);
        hideSoftKeyboard();
        getDetailedInfo();
    }

    public void initView() {
        Typeface fontFace = Typeface.createFromAsset(getAssets(), "IMPACT.TTF");
        // 字体文件必须是true type font的格式(ttf)；
        // 当使用外部字体却又发现字体没有变化的时候(以 Droid Sans代替)，通常是因为
        // 这个字体android没有支持,而非你的程序发生了错误
        salaryTextView.setTypeface(fontFace);
        (findViewById(R.id.rea_top)).setBackgroundResource(R.drawable.icon_account_edit_up);
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

    @Override
    public void CalcPrice() {
        caluMonny();
    }


    /**
     * 根据 数量和单价 计算总价
     */
    private void caluMonny() {
        String perPricesStr = per_prices.getText().toString();
        String countSumStr = quantities.getText().toString();
        if (perPricesStr.equals("") || countSumStr.equals("")) {
            salaryTextView.setText("0.00");
            return;
        }
        if (perPricesStr.endsWith(".") || countSumStr.endsWith(".")) {
            return;
        }
        double price = StringUtil.strToFloat(perPricesStr) * StringUtil.strToFloat(countSumStr);
        salaryTextView.setText(Utils.m2(price));
//        double transformatPrice = Utils.transformationNumber(StringUtil.strToFloat(perPricesStr) * StringUtil.strToFloat(countSumStr));
//        salaryTextView.setText(Utils.m2(transformatPrice) + Utils.transformationCompany(StringUtil.strToFloat(perPricesStr) * StringUtil.strToFloat(countSumStr)));
    }

    /**
     * 查询服务器获取当前id的记账详情
     */
    private void getDetailedInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("id", record_id);
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
                        CommonMethod.makeNoticeShort(mActivity, status.getErrmsg(), CommonMethod.ERROR);
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

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }

    //访问服务器后，设置界面
    private void setValue(OneBillDetail bean) {
        submitTime.setText(bean.getDate());
        perName.setText(bean.getName());
        perName.setTextColor(getResources().getColor(R.color.texthintcolor));
//        per_salary = bean.getSalary();
        uid = bean.getUid() + "";
        recordProject.setText(bean.getProname());
        sub_pro_name.setText(bean.getSub_proname());

        per_prices.setText(Utils.doubleTrans(bean.getUnitprice()) + "");
        quantities.setText(Utils.doubleTrans(bean.getQuantities()) + "");
//        LUtils.e("------------------" + bean.getSalary());
        BigDecimal bd = new BigDecimal(bean.getSalary());
        salaryTextView.setText(Utils.m2(Double.parseDouble(bd.toPlainString())));
        pid = bean.getPid();
        ed_remark.setText(bean.getNotes_txt());
        timeStartworkInt = Integer.valueOf(bean.getStart_time());
        timeEndworkInt = Integer.valueOf(bean.getEnd_time());
        timeStartwork.setText(TimesUtils.ChageStrToDate(bean.getStart_time()));
        timeEndwork.setText(TimesUtils.ChageStrToDate(bean.getEnd_time()));
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
        loadDefaultPhotoGridViewData();
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

        if (!TextUtils.isEmpty(bean.getUnits())) {
            tv_yuan.setVisibility(View.VISIBLE);
            tv_yuan.setText(bean.getUnits());
        } else {
            tv_yuan.setVisibility(View.GONE);
        }

        voiceLength = bean.getVoice_length();
        initVoice(bean.getNotes_voice());
        initPhoto();
    }

    public boolean submitCheck() {
        if (salaryTextView.getText().toString().equals("0.00")) {
            CommonMethod.makeNoticeShort(mActivity, "请设置单价和数量", CommonMethod.ERROR);
            return false;
        }
        if (per_prices.getText().toString().endsWith(".")) { //
            CommonMethod.makeNoticeShort(mActivity, "单价最后一位不能为小数点", CommonMethod.ERROR);
            return false;
        }
        if (quantities.getText().toString().endsWith(".")) { //数量最后一位不能为小数点
            CommonMethod.makeNoticeShort(mActivity, "数量最后一位不能为小数点", CommonMethod.ERROR);
            return false;
        }
        return true;
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


    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @OnClick(R.id.save)
    public void save(View view) {
        if (!submitCheck()) {
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

            @Override
            public void onFailure(HttpException e, String msg) {
                printNetLog(msg, mActivity);
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

    private RequestParams getParams() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        String data = submitTime.getText().toString().replace("年", "").replace("月", "").replace("日", "");
        String project_name = recordProject.getText().toString();
        params.addBodyParameter("id", record_id);
        params.addBodyParameter("accounts_type", AccountUtil.CONSTRACTOR);
        params.addBodyParameter("name", perName.getText().toString());
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("date", data.substring(0, 8));
        params.addBodyParameter("salary", Utils.m2(Double.parseDouble(per_prices.getText().toString()))); //单价
        params.addBodyParameter("quantity", Utils.m2(Double.parseDouble(quantities.getText().toString())));
        params.addBodyParameter("units", tv_yuan.getText().toString());
        params.addBodyParameter("p_s_time", timeStartworkInt + "");
        params.addBodyParameter("p_e_time", timeEndworkInt + "");
        params.addBodyParameter("pro_name", TextUtils.isEmpty(project_name) ? "" : project_name); //项目名称
        params.addBodyParameter("pid", pid == 0 ? "" : pid + "");
        params.addBodyParameter("sub_pro_name", sub_pro_name.getText().toString());
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
            //修改了语音
            if (TextUtils.isEmpty(voicePath)) {
                params.addBodyParameter("voice", "");// 上传的语音
                params.addBodyParameter("voice_length", "0");// 上传的语音
            } else {
                params.addBodyParameter("voice", new File(voicePath));// 上传的语音
                params.addBodyParameter("voice_length", voiceLength + "");// 上传的语音
            }
        }

        if (isGroupBill) {
//            params.addBodyParameter("my_role_type", roleType.equals(Constance.ROLETYPE_WORKER) ? Constance.ROLETYPE_FM : Constance.ROLETYPE_WORKER);
            params.addBodyParameter("my_role_type", roleType);
        } else {
            params.addBodyParameter("role", roleType);
        }
        return params;
    }

    public void initPhoto() {
        initPictureDesc();
        adapter = new AccountPhotoGridAdapter(mActivity, photos, this);
        GridView gridView = (GridView) findViewById(R.id.gridView);
        gridView.setAdapter(adapter);
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

    //完工时间
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

    //选择数量和填写单位
    @OnClick(R.id.quantities)
    private void quantities(View view) {
        Intent intent = new Intent(mActivity, AccountSelectCompanyActivity.class);
        intent.putExtra(Constance.CONTEXT, quantities.getText().toString().toString());
        intent.putExtra(Constance.COMPANY, tv_yuan.getText().toString().toString());
        startActivityForResult(intent, Constance.REQUESTCODE_ALLWORKCOMPANT);
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
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //选择单位输入数量回调
        if (requestCode == Constance.REQUESTCODE_ALLWORKCOMPANT && resultCode == Constance.RESULTCODE_ALLWORKCOMPANT) {//包工填写数量回调
            String values = data.getStringExtra(Constance.CONTEXT);
            String company = data.getStringExtra(Constance.COMPANY);
            quantities.setText(values);
            LUtils.e("company:" + company);
            if (!TextUtils.isEmpty(company)) {
                tv_yuan.setVisibility(View.VISIBLE);
                tv_yuan.setText(company);
            } else {
                tv_yuan.setVisibility(View.GONE);
            }


        }
    }
}
