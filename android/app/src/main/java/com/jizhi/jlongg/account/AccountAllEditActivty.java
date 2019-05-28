package com.jizhi.jlongg.account;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bigkoo.pickerview.TimePickerView;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.AccountSelectCompanyActivity;
import com.jizhi.jlongg.main.activity.AddSubProjectActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DiaLogRecordSuccess;
import com.jizhi.jlongg.main.dialog.WheelGridViewWorkTime;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StringUtil;
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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static com.jizhi.jlongg.main.util.Constance.ROLETYPE_FM;


/**
 * 功能:包工
 * 时间:2017/4/13 15.34
 * 作者:hcs
 */

public class AccountAllEditActivty extends BaseActivity implements View.OnClickListener, OnSquaredImageRemoveClick {
    private AccountAllEditActivty mActivity;
    /* 记账成功对话框 */
    private DiaLogRecordSuccess diaLogRecordSuccess;
    /* 记账成功id */
    public String record;
    /*与我相关项目数据 */
    public List<Project> projectList;
    /*选择与我相关项目的id*/
    public int pid;
    /* 与我相关项目的弹出框*/
    public WheelViewAboutMyProject addProject;
    /*记账数据*/
    private WorkDetail bean;
    /*记账id*/
    private int account_id;
    /*记账类型，角色*/
    private String account_type, role_type;
    //选择对象列表数据
    protected PersonBean personBean;
    /* 语音路径*/
    protected String voicePath;
    /* 语音长度*/
    protected int voiceLength;
    /* 图片数据*/
    protected List<ImageItem> imageItems;
    //    角色， 日期 ，所在项目，数量,开始时间，结束时间,
    private TextView tv_role, tv_date, tv_proname, tv_start_time, tv_end_time, tv_money, tv_subname, tv_company;
    //   备注，项目名字，单价
    private EditText ed_remark, ed_price, ed_count;
    //是否改变了数据
    private boolean isChangedata;
    AgencyGroupUser agencyGroupUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.account_edit_all_list);
        getIntentData();
        initView();
        hideSoftKeyboard();
        initOrUpDateAdapter();
        if (null != bean) {
            initData();
        } else {
            getDetailInfo();
        }
    }

    /**
     * 初始化控件
     */
    public void initView() {
        mActivity = AccountAllEditActivty.this;
        ((TextView) findViewById(R.id.title)).setText("修改包工记账");
        //初始信息
        tv_role = findViewById(R.id.tv_role);
        tv_proname = findViewById(R.id.tv_proname);
        ed_count = findViewById(R.id.ed_count);
        tv_money = findViewById(R.id.tv_money);
        ed_remark = findViewById(R.id.ed_remark);
        tv_subname = findViewById(R.id.tv_subname);
        tv_company = findViewById(R.id.tv_company);
        ed_price = findViewById(R.id.ed_price);
        tv_start_time = findViewById(R.id.tv_start_time);
        tv_end_time = findViewById(R.id.tv_end_time);
        findViewById(R.id.rea_project).setOnClickListener(this);
        findViewById(R.id.lin_company).setOnClickListener(this);
        findViewById(R.id.rea_start_time).setOnClickListener(this);
        findViewById(R.id.rea_end_time).setOnClickListener(this);
        findViewById(R.id.btn_del).setOnClickListener(this);
        findViewById(R.id.btn_save).setOnClickListener(this);
        findViewById(R.id.rea_sub_projrct).setOnClickListener(this);
        findViewById(R.id.rea_count_left).setOnClickListener(this);
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
            tv_proname.setTextColor(getResources().getColor(R.color.color_999999));
            findViewById(R.id.rea_project).setClickable(false);
            findViewById(R.id.img_right).setVisibility(View.GONE);
        }
        tv_role.setHint(role_type.equals(ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头");
        tv_date = (findViewById(R.id.tv_date));
        imageItems = new ArrayList<>();
        setEditTextDecimalNumberLength(ed_price, 7, 2);
        setEditTextDecimalNumberLength(ed_count, 7, 2);
        ed_price.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                caluAllMonny();
            }
        });
        ed_count.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                caluAllMonny();
            }
        });
    }

    /**
     * 根据角色设置承包分包信息
     */
    public void setContractorInfo() {
        if (role_type.equals(Constance.ROLETYPE_WORKER)) {
            ((TextView) findViewById(R.id.tv_role_title)).setText("班组长");
            findViewById(R.id.rea_contractor_type).setVisibility(View.GONE);
            findViewById(R.id.id_10px).setVisibility(View.GONE);
        } else {
            ((TextView) findViewById(R.id.tv_role_title)).setText(bean.getContractor_type() == 1 ? "承包对象" : "工人");
            ((RadioButton) findViewById(R.id.rb_account)).setText(bean.getContractor_type() == 1 ? "承包" : "分包");
            ((TextView) findViewById(R.id.tv_type_hint)).setText(bean.getContractor_type() == 1 ? getString(R.string.account_hint_contract) : getString(R.string.account_hint_subcontract));
            findViewById(R.id.rea_contractor_type).setVisibility(View.VISIBLE);
            findViewById(R.id.id_10px).setVisibility(View.VISIBLE);

        }

    }

    /**
     * 初始化数据
     */
    public void initData() {
        setContractorInfo();
        pid = bean.getPid();
        //角色
        if (role_type.equals("1") || bean.getContractor_type() == 1) {
            tv_role.setText(bean.getForeman_name());
        } else {
            tv_role.setText(bean.getWorker_name());
        }
        tv_role.setTextColor(getResources().getColor(R.color.color_666666));
        tv_date.setTextColor(getResources().getColor(R.color.color_666666));
        //日期
        tv_date.setText(bean.getDate());
        //所在项目
        tv_proname.setText(bean.getProname());
        setSubProject();
        //工钱
        tv_money.setText(bean.getAmounts());
//        ed_price.setSelection(bean.getUnitprice().length());
        if (!TextUtils.isEmpty(bean.getP_s_time()) || !TextUtils.isEmpty(bean.getP_e_time())) {
            tv_start_time.setText(TimesUtils.ChageStrToDate(bean.getP_s_time()));
            tv_end_time.setText(TimesUtils.ChageStrToDate(bean.getP_e_time()));
        }
        if (!TextUtils.isEmpty(bean.getNotes_txt()) && !bean.getNotes_txt().equals("无")) {
            ed_remark.setText(bean.getNotes_txt());
        } else {
            ed_remark.setText("");
        }
        if (null != imageItems) {
            imageItems.clear();
        }
        List<String> imagePaths = bean.getNotes_img();
        if (imagePaths != null && imagePaths.size() > 0) {
            int size = imagePaths.size();
            for (int i = 0; i < size; i++) {
                ImageItem item = new ImageItem();
                item.imagePath = imagePaths.get(i);
                item.isNetPicture = true;
                imageItems.add(item);
            }
        }
        adapter.notifyDataSetChanged();
    }


    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.wrap_grid);
            adapter = new SquaredImageAdapter(this, this, imageItems, 4);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    if (position == imageItems.size()) {
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
                        bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) imageItems);
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
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);

        }
        return mSelected;
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, WorkDetail workDetail, String account_type, int account_id, String role_type, boolean isRecoedWork) {
        LUtils.e("------11---------" + role_type);
        Intent intent = new Intent(context, AccountAllEditActivty.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, workDetail);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_INT, account_id);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_BOOLEAN, isRecoedWork);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, WorkDetail workDetail, String account_type, int account_id, String role_type, boolean isRecoedWork, AgencyGroupUser agencyGroupUser) {
        LUtils.e("------11---------" + role_type);
        Intent intent = new Intent(context, AccountAllEditActivty.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, workDetail);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_INT, account_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, isRecoedWork);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_CONSTANCE1, agencyGroupUser);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        //记账类型
        account_type = getIntent().getStringExtra(Constance.BEAN_STRING);
        //记账id
        account_id = getIntent().getIntExtra(Constance.BEAN_INT, 0);
        role_type = getIntent().getStringExtra(Constance.ROLE);
        bean = (WorkDetail) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        agencyGroupUser = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE1);
    }

    @Override
    public void onClick(View v) {
//        if (v.getId() != R.id.rea_role && TextUtils.isEmpty(tv_role.getText().toString())) {
//            CommonMethod.makeNoticeShort(mActivity, getString(R.string.please_select_record_object), CommonMethod.ERROR);
//            return;
//        }

        switch (v.getId()) {
            case R.id.rea_project:
                //与我相关的项目
                isChangedata = true;
//                recordProject();
                SelecteProjectActivity.actionStart(mActivity, pid == 0 ? null : pid + "");
                break;
            case R.id.lin_company:
                //数量
                isChangedata = true;
                hideSoftKeyboard();
                final List<WorkTime> companyList = DataUtil.getAccountCompanyList(mActivity, null == bean.getUnits() ? "" : bean.getUnits());
                WheelGridViewWorkTime selectCompanyDialog = new WheelGridViewWorkTime(mActivity, companyList, "选择单位", 0);
                selectCompanyDialog.setListener(new WheelGridViewWorkTime.WorkTimeListener() {
                    @Override
                    public void workTimeClick(String scrollContent, int postion, String workUtil) {
                        bean.setUnits(companyList.get(postion).getWorkName());
                        setSubProject();
                        LUtils.e("-------companyList.get(postion).getWorkName(----" + companyList.get(postion).getWorkName());
                    }
                });
                //显示窗口
                selectCompanyDialog.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
//                AccountSelectCompanyActivity.actionStart(mActivity, bean.getQuantities(), bean.getUnits());
                break;
            case R.id.btn_del:
                delsetmount();
                break;
            case R.id.rea_sub_projrct:
                AccountAllWorkBean aawb = new AccountAllWorkBean();
                aawb.setSub_pro_name(bean.getSub_proname());
                aawb.setSet_unitprice(bean.getUnitprice());
                aawb.setUnits(bean.getUnits());
                AddSubProjectActivity.actionStart(mActivity, aawb, 0);
                break;
            case R.id.rea_start_time:
                isChangedata = true;
                showTimePickView(AccountBean.P_S_TIME, TimesUtils.getClender(tv_start_time.getText().toString()));
                break;
            case R.id.rea_end_time:
                if (TextUtils.isEmpty(bean.getP_s_time())) {
                    CommonMethod.makeNoticeShort(mActivity, "请先选择开始时间", CommonMethod.ERROR);
                    return;
                }
                isChangedata = true;
                showTimePickView(AccountBean.P_E_TIME, TimesUtils.getClender(tv_end_time.getText().toString()));
                break;
            case R.id.btn_save:
                if (TextUtils.isEmpty(ed_price.getText().toString()) || ed_price.getText().toString().equals(".")) {
                    CommonMethod.makeNoticeShort(mActivity, "请填写单价", CommonMethod.ERROR);
                    return;
                }
                if (TextUtils.isEmpty(ed_count.getText().toString()) || ed_count.getText().toString().equals(".")) {
                    CommonMethod.makeNoticeShort(mActivity, "请填写数量", CommonMethod.ERROR);
                    return;
                }
                String m = tv_money.getText().toString();
                if (TextUtils.isEmpty(m) || m.equals("0.00")) {
                    LUtils.e(m + ",,cccccc,");
                    CommonMethod.makeNoticeShort(mActivity, "请输入正确的单价和数量", CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(bean.getP_s_time()) && TextUtils.isEmpty(bean.getP_e_time())) {
                    CommonMethod.makeNoticeShort(mActivity, "请选择项目结束时间", CommonMethod.ERROR);
                    return;
                } else if (!TextUtils.isEmpty(bean.getP_e_time()) && TextUtils.isEmpty(bean.getP_s_time())) {
                    CommonMethod.makeNoticeShort(mActivity, "请选择项目开始时间", CommonMethod.ERROR);
                    return;
                }
                try {
                    if (!tv_subname.getText().toString().equals(bean.getSub_proname())) {
                        isChangedata = true;
                    }
                    if (Double.parseDouble(ed_price.getText().toString()) != Double.parseDouble(bean.getUnitprice())) {
                        isChangedata = true;
                    }
                    if (null == bean.getNotes_txt()) {
                        bean.setNotes_txt("");
                    }
                    if (!bean.getNotes_txt().equals(ed_remark.getText().toString())) {
                        isChangedata = true;
                    }
                    String perPricesStr = ed_price.getText().toString().trim();
                    String countSumStr = ed_count.getText().toString().trim();
                    if (!perPricesStr.equals(bean.getUnitprice())) {
                        isChangedata = true;
                    }
                    if (!countSumStr.equals(bean.getQuantities())) {
                        isChangedata = true;
                    }
                } catch (Exception e) {
                    isChangedata = true;

                }

                if (!isChangedata && !getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                    mActivity.finish();
                    return;
                }
                FileUpData();
                break;
            case R.id.rea_count_left:
                Utils.showSoftInputFromWindow(mActivity, ed_count);
                break;
        }
    }


    /**
     * 设置项目信息
     *
     * @param pid
     * @param proname
     */
    public void setProInfo(int pid, String proname) {
        this.pid = pid;
        if (pid != 0) {
            tv_proname.setText(proname);
        } else {
            tv_proname.setText("");
        }

    }


    /**
     * 获取输入的内容转换为double类型
     *
     * @param m
     * @return
     */
    public Double getEditM(String m) {
        if (TextUtils.isEmpty(m) || m.equals(".")) {
            m = "0";
        } else if (m.endsWith(".")) {
            m = m + "0";
        }
        return Double.parseDouble(m);
    }


    public void recordProject() {
        if (projectList != null) {
            createProjectWheelView();
            return;
        }
        projectList = null;
        AccountHttpUtils.IRelatedProjects(mActivity, new AccountHttpUtils.AccountIRelatedListener() {
            @Override
            public void IRelatedProjectsSuccess(List<Project> list) {
                if (null != projectList) {
                    projectList.clear();
                }
                projectList = list;
                createProjectWheelView();
            }
        }, true);
    }

    /**
     * 所在项目
     */
    public void createProjectWheelView() {
        if (addProject == null) {
            addProject = new WheelViewAboutMyProject(mActivity, projectList, true);
            addProject.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    setProInfo(projectList.get(postion).getPid(), projectList.get(postion).getPro_name());
                }
            });
        } else {
            addProject.update();
        }
        //显示窗口
        addProject.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
    }


    RequestParams params;

    public void FileUpData() {
        createCustomDialog();
        //相同部分参数
        params = RequestParamsToken.getExpandRequestParams(mActivity);

        AccountInfoBean infoBean = new AccountInfoBean();
        /** 记账类型 1、点工  2、包工  3、总包记账 4.工钱结算*/
        infoBean.setAccounts_type(AccountUtil.CONSTRACTOR);
        /** 记账id*/
        infoBean.setRecord_id(bean.getRecord_id());
        /** 单价 */
        infoBean.setUnit_price(Utils.m2(Double.parseDouble(ed_price.getText().toString())));
        /** 数量 */
        infoBean.setQuantity(ed_count.getText().toString());
        /** 数量单位 */
        infoBean.setUnits(bean.getUnits());
        /** 分项名字 */
        infoBean.setSub_pro_name(tv_subname.getText().toString());
        /** 开工时间 */
        infoBean.setP_s_time(bean.getP_s_time());
        /** 完工时间 */
        infoBean.setP_e_time(bean.getP_e_time());
        /** 项目id */
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        /** 记账对象名称 */
        infoBean.setPro_name(tv_proname.getText().toString());
        /** 备注描述 */
        if (!TextUtils.isEmpty(ed_remark.getText().toString())) {
            infoBean.setText(ed_remark.getText().toString());
        }
        if (!TextUtils.isEmpty(getImage())) {
            infoBean.setImgs(getImage());//图片
        }
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        accountInfoBeanList.add(infoBean);
        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList).toString());
        if (null != agencyGroupUser) {
            if (!TextUtils.isEmpty(agencyGroupUser.getUid())) {
                params.addBodyParameter("agency_uid", agencyGroupUser.getUid());
            }
            if (!TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
                params.addBodyParameter("group_id", agencyGroupUser.getGroup_id());
            }

        }
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                ArrayList<String> tempPhoto = null;
                if (null != imageItems && imageItems.size() > 0) {
                    if (tempPhoto == null) {
                        tempPhoto = new ArrayList<>();
                    }
                    for (int i = 0; i < imageItems.size(); i++) {
                        ImageItem item = imageItems.get(i);
                        LUtils.e(item.isNetPicture + ",,,,," + item.imagePath);
                        if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                            tempPhoto.add(imageItems.get(i).imagePath);
                        }
                    }
                    LUtils.e("---------------" + new Gson().toJson(tempPhoto));
                    if (tempPhoto.size() > 0) {
                        RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, mActivity);
                    }
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
                    releaseAll();
                    break;
            }

        }
    };


    /**
     * 发布记账
     */
    public void releaseAll() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFYRELASE_NEW, params, new RequestCallBack<String>() {
            @Override
            public void onFailure(HttpException e, String s) {
                closeDialog();
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result.toString(), BaseNetBean.class);
                    if (base.getMsg().equals(Constance.SUCCES_S)) {
                        CommonMethod.makeNoticeShort(mActivity, getString(R.string.hint_changebill), CommonMethod.SUCCESS);
                        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                        setResult(Constance.ACCOUNT_UPDATE, getIntent());
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(mActivity, base.getErrno(), base.getMsg());
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

    /**
     * 删除
     */
    public void delsetmount() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", account_id + "");
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
                                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                                CommonMethod.makeNoticeShort(mActivity, "删除成功", CommonMethod.ERROR);
                                setResult(Constance.ACCOUNT_DELETE, getIntent());
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
     * 返回上级页面
     */

    public void finishAct() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString("typeMsg", "bill");
//        bundle.putString("record_id", record_id);
        intent.putExtras(bundle);
        setResult(Constance.DISPOSEATTEND_RESULTCODE, intent);
        finish();
    }

//    StringBuffer stringBuffer;

    @Override
    public void remove(int position) {
//        if (!imageItems.get(position).imagePath.contains("/storage/")) {
//            if (null == stringBuffer) {
//                stringBuffer = new StringBuffer();
//            }
//            LUtils.e("删除了---------------------");
//            stringBuffer.append(imageItems.get(position).imagePath + ";");
//        } else {
//            LUtils.e("没有删除-----------------");
//        }
        isChangedata = true;
        imageItems.remove(position);
        adapter.notifyDataSetChanged();
        LUtils.e("-----11A----" + new Gson().toJson(imageItems));
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            isChangedata = true;
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
                LUtils.e("---------------:" + tempList.get(i).imagePath + ",,," + tempList.get(i).isNetPicture);
                imageItems = tempList;
                adapter.updateGridView(imageItems);
            }
        } else if (requestCode == Constance.REQUESTCODE_ALLWORKCOMPANT && resultCode == Constance.RESULTCODE_ALLWORKCOMPANT) {//包工填写数量回调
            isChangedata = true;
            String values = data.getStringExtra(Constance.CONTEXT);
            String company = data.getStringExtra(Constance.COMPANY);
            if (!TextUtils.isEmpty(values) && !TextUtils.isEmpty(company)) {
                bean.setQuantities(values);
                bean.setUnits(company);
                //数量
                ed_count.setText(bean.getQuantities());
                tv_company.setText(bean.getUnits());
                caluAllMonny();

            }
        } else if (resultCode == Constance.RESULTWORKERS) {//添加项目回调
            isChangedata = true;
            clearProjectDialog();
        } else if (resultCode == Constance.EDITOR_PROJECT_SUCCESS) {//编辑项目回调
            isChangedata = true;
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            LUtils.e(project.getPro_name() + "-------------添加项目回调------------" + project.getPid() + ",,," + bean.getPid());
            //设置备注信息
            if (!TextUtils.isEmpty(project.getPro_name()) && bean.getPid() == project.getPid()) {
                bean.setPid(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()));
                bean.setProname(project.getPro_name());
                setProInfo(project.getPid(), project.getPro_name());
            }
            clearProjectDialog();
        } else if (resultCode == Constance.SELECTE_PROJECT) {//修改了项目
            isChangedata = true;
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            LUtils.e("---11-------BBBBBB----------:" + new Gson().toJson(project));
            if (null == project) {
                setProInfo(0, "");
                return;
            }

            setProInfo(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()), project.getPro_name());

        } else if (requestCode == Constance.REQUESTCODE_ADD_SUB_PRONAME && resultCode == Constance.RESULTCODE_ADD_SUB_PRONAME) {//包工填写分项名称回调
            isChangedata = true;

            AccountAllWorkBean accountAllWorkBean = (AccountAllWorkBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            bean.setSub_proname(accountAllWorkBean.getSub_pro_name());
            bean.setUnitprice(accountAllWorkBean.getSet_unitprice());
            bean.setUnits(accountAllWorkBean.getUnits());
            setSubProject();

        }
        if (requestCode == Constance.REQUEST) {//确认记工
            getDetailInfo();

        }
    }

    /**
     * 设置分项名字
     */
    public void setSubProject() {
        //分项名称
        tv_subname.setText(bean.getSub_proname());
        //单价
        ed_price.setText(bean.getUnitprice());
        //数量
        ed_count.setText(bean.getQuantities());
        tv_company.setText(bean.getUnits());
    }

    public void clearProjectDialog() {
        if (null != addProject) {
            addProject.dismiss();
        }
        projectList = null;
        addProject = null;
        recordProject();
    }

    /**
     * 计算包工总价
     *
     * @return
     */
    private void caluAllMonny() {
        if (bean == null) {
            return;
        }
        String perPricesStr = ed_price.getText().toString().trim();
        String countSumStr = ed_count.getText().toString().trim();
        if (TextUtils.isEmpty(perPricesStr) || TextUtils.isEmpty(countSumStr)) {
            tv_money.setText("");
            return;
        }
        if (perPricesStr.endsWith(".") || countSumStr.endsWith(".")) {
            tv_money.setText("");
            return;
        }

        LUtils.e(perPricesStr + "-------perPricesStr-------" + countSumStr);
        String price = Utils.m2(Float.parseFloat(perPricesStr) * Float.parseFloat(countSumStr));
        tv_money.setText(price);
        bean.setAmounts(price);

    }

//    /**
//     * 计算总价
//     *
//     * @param position
//     * @return
//     */
//    private void caluMonny {
//        double sub_count = StringUtil.strToFloat(ed_price.getText().toString());
//        double sub_price = StringUtil.strToFloat(ed_count.getText().toString().trim());
//        if (sub_count == 0 || sub_price == 0) {
//            tv_money.setText("");
//
//            return;
//        }
////        if (sub_count.endsWith(".") || sub_price.endsWith(".")) {
////            list.get(position).setPrice("");
////
////            return;
////        }
//        bean.setAmounts(Utils.m2(sub_count * sub_price));
//        tv_money.setText(Utils.m2(sub_count * sub_price));
//
//    }

    /**
     * 查询记账信息详情
     */

    private void getDetailInfo() {
//        super.setString_for_dialog(getString(R.string.searching));
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("record_id", account_id + "");
        params.addBodyParameter("accounts_type", account_type + "");

        LUtils.e("--------------22----:" + account_id);
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            params.addBodyParameter("role", role_type);
            params.addBodyParameter("is_confirm", "1");
        }
        if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id());
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.WORKDETAIL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<WorkDetail> status = CommonJson.fromJson(responseInfo.result, WorkDetail.class);
                    if (status.getMsg().equals(Constance.SUCCES_S)) {
                        if (status.getResult() != null) {
                            bean = status.getResult();
                            initData();

                        }
                    } else {
                        DataUtil.showErrOrMsg(mActivity, status.getErrno(), status.getErrmsg());
                        finish();
                    }
                    closeDialog();
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

    /**
     * 显示时间view
     *
     * @param type 时间多选开始或者结束下标 1：开始 2：结束
     */
    public void showTimePickView(final String type, final Calendar selectedDate) {
        Calendar startDate = Calendar.getInstance();
        startDate.set(2014, 0, 23);
        Calendar endDate = Calendar.getInstance();
        endDate.set(2020, 11, 28);
        TimePickerView pvTime = new TimePickerView.Builder(this, new TimePickerView.OnTimeSelectListener() {
            @Override
            public void onTimeSelect(Date date, View v) {
                //选中事件回调
                int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
                int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
                int dayOfMonth = Integer.parseInt(new SimpleDateFormat("dd").format(date));
                String time = year + "" + (month < 10 ? "0" + month : month) + "" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth);
                if (type.equals(AccountBean.P_E_TIME)) {
                    long starttime = TimesUtils.strToLongYYYYMMDDs(bean.getP_s_time());
                    long endtime = TimesUtils.strToLongYYYYMMDDs(time);

                    if (starttime > endtime && starttime != 0) {
                        CommonMethod.makeNoticeShort(mActivity, "项目开始时间不能大于结束时间", CommonMethod.ERROR);
                        return;
                    }
                } else if (type.equals(AccountBean.P_S_TIME)) {
                    long starttime = TimesUtils.strToLongYYYYMMDDs(time);
                    long endtime = TimesUtils.strToLongYYYYMMDDs(bean.getP_e_time());
                    if (starttime > endtime && endtime != 0) {
                        CommonMethod.makeNoticeShort(mActivity, "项目开始时间不能大于结束时间", CommonMethod.ERROR);
                        return;
                    }
                }

                //显示时间
                String timeFont = year + "-" + (month < 10 ? "0" + month : month) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "");
                if (type.equals(AccountBean.P_S_TIME)) {
                    bean.setP_s_time(time);
                    tv_start_time.setText(timeFont);
                } else if (type.equals(AccountBean.P_E_TIME)) {
                    bean.setP_e_time(time);
                    tv_end_time.setText(timeFont);
                }
            }
        })
                //年月日时分秒 的显示与否，不设置则默认全部显示
                .setType(new boolean[]{true, true, true, false, false, false})
                .setCancelText("取消")
                .setSubmitText("确定")
                .setTitleText("请选择时间")
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
                .setDividerColor(getResources().getColor(R.color.app_color))
                .setDate(selectedDate)
                .setRangDate(startDate, endDate)
                .setBackgroundId(0x66000000) //设置外部遮罩颜色
                .setDecorView(null)
                .build();

        pvTime.show();
    }

    public String getImage() {
        if (null == imageItems || imageItems.size() == 0) {
            return "";
        }
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < imageItems.size(); i++) {
            if (!imageItems.get(i).imagePath.contains("/storage/")) {
                stringBuffer.append(imageItems.get(i).imagePath + ";");
            }
        }
        return stringBuffer.toString();
    }
}
