package com.jizhi.jlongg.account;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.NoMoneyLittleWorkActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.AccountWageDialog;
import com.jizhi.jlongg.main.dialog.DiaLogRecordSuccess;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
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

import static com.jizhi.jlongg.main.util.Constance.ROLETYPE_FM;


/**
 * 功能:结算
 * 时间:2017/4/13 15.34
 * 作者:hcs
 */

public class AccountWagesEditActivty extends BaseActivity implements View.OnClickListener, OnSquaredImageRemoveClick {
    private AccountWagesEditActivty mActivity;
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
    //工人名字，所在项目，备注信息,补奖扣合计
    private TextView tv_role, tv_date, tv_proname, tv_s_r_f;
    /*补奖惩*/
    private EditText ed_wage_subsidy, ed_wage_reward, ed_wage_fine;
    //本次实付收金额,抹零金额,备注信息
    private EditText ed_income_money, ed_wage_del, ed_remark;
    /* 是否展开补贴奖励罚款*/
    private boolean isExpand;
    //提示popwindow
    protected PopupWindow accountPopupView;
    private Double balance_amount, wage_all, wage_wage, income_all;//未结工资,补奖罚金额，本次结算金额,剩余未结金额
    private TextView tv_wage_supplus_unset, tv_wage_wage;//剩余未结工资,本次结算金额
    private ImageView img_hint_wage1, img_hint_wage2, img_hint_wage3;//提示内容
    //是否修改过数据
    private boolean isChangedata;
    AgencyGroupUser agencyGroupUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.account_edit_wages_list);
        getIntentData();
        initView();
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
        mActivity = AccountWagesEditActivty.this;
        isExpand = true;
        ((TextView) findViewById(R.id.title)).setText("修改结算");
        //初始信息
        ((TextView) findViewById(R.id.tv_role_title)).setText((role_type.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长"));
        ((TextView) findViewById(R.id.tv_income_money)).setText((role_type.equals(Constance.ROLETYPE_FM) ? "本次实付金额" : "本次实收金额"));
        tv_role = findViewById(R.id.tv_role);
        tv_proname = findViewById(R.id.tv_proname);
        tv_s_r_f = findViewById(R.id.tv_s_r_f);
        tv_wage_supplus_unset = findViewById(R.id.tv_wage_supplus_unset);
        tv_wage_wage = findViewById(R.id.tv_wage_wage);
        ed_income_money = findViewById(R.id.ed_income_money);
        ed_wage_del = findViewById(R.id.ed_wage_del);
        ed_remark = findViewById(R.id.ed_remark);
        tv_role.setHint(role_type.equals(ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头");
        tv_date = findViewById(R.id.tv_date);
        tv_role.setTextColor(getResources().getColor(R.color.color_666666));
        tv_date.setTextColor(getResources().getColor(R.color.color_666666));
        imageItems = new ArrayList<>();
        //设置未结工资模版
        findViewById(R.id.tv_salary).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NoMoneyLittleWorkActivity.actionStart(mActivity, UclientApplication.getUid(mActivity) + "");
            }
        });
//         findViewById(R.id.save).setOnClickListener(savaClickListener);
        img_hint_wage1 = findViewById(R.id.img_hint_wage1);
        img_hint_wage2 = findViewById(R.id.img_hint_wage2);
        img_hint_wage3 = findViewById(R.id.img_hint_wage3);
        findViewById(R.id.rea_date).setOnClickListener(this);
        findViewById(R.id.rea_s_r_f).setOnClickListener(this);
        findViewById(R.id.rea_project).setOnClickListener(this);
        findViewById(R.id.btn_save).setOnClickListener(this);
        findViewById(R.id.btn_del).setOnClickListener(this);
        img_hint_wage1.setOnClickListener(this);
        img_hint_wage2.setOnClickListener(this);
        img_hint_wage3.setOnClickListener(this);
        ed_wage_subsidy = findViewById(R.id.ed_wage_subsidy);
        ed_wage_reward = findViewById(R.id.ed_wage_reward);
        ed_wage_fine = findViewById(R.id.ed_wage_fine);
        setEditTextDecimalNumberLength(ed_wage_subsidy, 7, 2);
        setEditTextDecimalNumberLength(ed_wage_reward, 7, 2);
        setEditTextDecimalNumberLength(ed_wage_fine, 7, 2);
//        setEditTextDecimalNumberLength(ed_income_money, 7, 2);
//        setEditTextDecimalNumberLength(ed_wage_del, 6, 2);
        addTextChangedListener(ed_wage_subsidy);
        addTextChangedListener(ed_wage_reward);
        addTextChangedListener(ed_wage_fine);
        addTextChangedListener(ed_income_money);
        addTextChangedListener(ed_wage_del);
        ed_income_money.setFilters(new InputFilter[]{new DecimalInputFilter(7, 2, true)});
        ed_wage_del.setFilters(new InputFilter[]{new DecimalInputFilter(7, 2, true)});
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
            tv_proname.setTextColor(getResources().getColor(R.color.color_999999));
            findViewById(R.id.rea_project).setClickable(false);
            findViewById(R.id.img_right).setVisibility(View.GONE);
        }
    }

    /**
     * 初始化数据
     */
    public void initData() {
        pid = bean.getPid();
        if (role_type.equals("1")) {
            tv_role.setText(bean.getForeman_name());
        } else {
            tv_role.setText(bean.getWorker_name());
        }
        tv_date.setText(bean.getDate());
        balance_amount = bean.getBalance_amount();
        ((TextView) findViewById(R.id.tv_textview_wage)).setText(Utils.m2(balance_amount) + "");//未结工资数
        //未结工资与笔数
        if (bean.getUn_salary_tpl() > 0) {
            findViewById(R.id.lin_unset).setVisibility(View.VISIBLE);
//            findViewById(R.id.rea_wage_line).setVisibility(View.VISIBLE);
            ((TextView) findViewById(R.id.tv_count)).setText(Html.fromHtml("你还有<font color='#eb4e4e'>" + bean.getUn_salary_tpl() + "笔</font>点工的工资标准未设置金额"));
        } else {
            findViewById(R.id.lin_unset).setVisibility(View.GONE);
//            findViewById(R.id.rea_wage_line).setVisibility(View.GONE);
        }
        //补奖罚金额
        ed_wage_subsidy.setText(Utils.m2(bean.getSubsidy_amount()));
        ed_wage_reward.setText(Utils.m2(bean.getReward_amount()));
        ed_wage_fine.setText(Utils.m2(bean.getPenalty_amount()));
        // 本次实收金额
        ed_income_money.setText(Utils.m2(bean.getPay_amount()));
        // 抹零金额
        ed_wage_del.setText(Utils.m2(bean.getDeduct_amount()));
        //本次结算金额
        tv_wage_wage.setText(bean.getAmounts());
        //剩余未结工资
        tv_wage_supplus_unset.setText(Utils.m2(income_all));
        //所在项目
        tv_proname.setText(NameUtil.setRemark(bean.getProname(), 12));
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
        Intent intent = new Intent(context, AccountWagesEditActivty.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, workDetail);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_INT, account_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, isRecoedWork);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, WorkDetail workDetail, String account_type, int account_id, String role_type, boolean isRecoedWork, AgencyGroupUser agencyGroupUser) {
        LUtils.e("------11---------" + role_type);
        Intent intent = new Intent(context, AccountWagesEditActivty.class);
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
            case R.id.rea_s_r_f:
                //补贴奖励罚款
                if (isExpand) {
                    isExpand = false;
                    Utils.setBackGround(findViewById(R.id.img_s_r_f), ContextCompat.getDrawable(mActivity, R.drawable.account_arrow_up));
                    findViewById(R.id.lin_wages_other).setVisibility(View.VISIBLE);
                } else {
                    isExpand = true;
                    Utils.setBackGround(findViewById(R.id.img_s_r_f), ContextCompat.getDrawable(mActivity, R.drawable.account_arrow_down));
                    findViewById(R.id.lin_wages_other).setVisibility(View.GONE);
                }
                break;
            case R.id.rea_project:
                //与我相关的项目
                isChangedata = true;
//                recordProject();
                SelecteProjectActivity.actionStart(mActivity, pid == 0 ? null : pid + "");
                break;
            case R.id.btn_del:
                delsetmount();
                break;
            case R.id.btn_save:
                if (TextUtils.isEmpty(tv_role.getText().toString())) {
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.ple_select_ob), CommonMethod.ERROR);
                    return;
                }
                //补贴金额
                Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
                //奖励金额
                Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
                //罚款金额
                Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
                // 本次实付金额
                Double income_money = getEditM(ed_income_money.getText().toString().trim());
                if (wage_subsidy == 0 && wage_reward == 0 && wage_fine == 0 && income_money == 0) {
                    String str = ((TextView) findViewById(R.id.tv_income_money)).getText().toString().toString();
                    CommonMethod.makeNoticeLong(mActivity, "补贴、奖励、罚款金额和" + str + "不能同时为0", false);
                    return;
                }
//                //补奖罚金额
//                ed_wage_subsidy.setText(Utils.m2(bean.getSubsidy_amount()));
//                ed_wage_reward.setText(Utils.m2(bean.getReward_amount()));
//                ed_wage_fine.setText(Utils.m2(bean.getPenalty_amount()));
//                // 本次实收金额
//                ed_income_money.setText(Utils.m2(bean.getPay_amount()));
//                // 抹零金额
//                ed_wage_del.setText(Utils.m2(bean.getDeduct_amount()));

                try {
                    //补贴金额
                    if (!wage_subsidy.equals(bean.getSubsidy_amount())) {
                        isChangedata = true;
                        LUtils.e(wage_subsidy + ",-------------11-------------," + bean.getSubsidy_amount());
                    }
                    //奖励金额
                    if (!wage_reward.equals(bean.getReward_amount())) {
                        isChangedata = true;
                        LUtils.e(wage_reward + ",-------------22-------------," + bean.getReward_amount());
                    }
                    //罚款金额
                    if (!wage_fine.equals(bean.getPenalty_amount())) {
                        isChangedata = true;
                        LUtils.e(wage_fine + ",-------------33-------------," + bean.getPenalty_amount());
                    }
                    // 本次实付金额
                    if (!income_money.equals(bean.getPay_amount())) {
                        isChangedata = true;
                        LUtils.e(income_money + ",-------------44-------------," + bean.getPay_amount());
                    }
                    // 本次实付金额
                    Double deduct_amount = getEditM(ed_wage_del.getText().toString().trim());
                    //抹零金额
                    if (!deduct_amount.equals(bean.getDeduct_amount())) {
                        isChangedata = true;
                    }
                    String txt = bean.getNotes_txt();
                    if (TextUtils.isEmpty(txt)) {
                        txt = "";
                    }
                    if (!txt.equals(ed_remark.getText().toString())) {
                        isChangedata = true;
                    }
                    if (!isChangedata && !getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                        LUtils.e("不需要提交数据。。。。。。。。。。。。。。。。。。");
                        mActivity.finish();
                        return;
                    }
                } catch (Exception e) {

                }
                Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
                WorkDetail workDetail = new WorkDetail();
                //本次实收金额
                workDetail.setPay_amount(income_money);
                //补贴金额
                workDetail.setSubsidy_amount(wage_subsidy);
                //奖励金额
                workDetail.setReward_amount(wage_reward);
                //罚款金额
                workDetail.setPenalty_amount(wage_fine);
                //抹零金额
                workDetail.setDeduct_amount(wage_del);
                //本次结算金额
                workDetail.setAmounts(Utils.m2(wage_wage));
                //剩余未结金额
                workDetail.setUnbalance_amount(income_all);
                //未结工资
                workDetail.setBalance_amount(balance_amount);

                new AccountWageDialog(mActivity, role_type, Utils.m2(wage_wage), Utils.m2(income_all), new AccountWageDialog.AccountSuccessListenerClick() {
                    @Override
                    public void successAccountClick() {
                        FileUpData();
                    }
                }).show();

//                new AccountWageDialog(mActivity, role_type, Utils.m2(wage_wage), Utils.m2(income_all), new AccountWageDialog.AccountSuccessListenerClick() {
//                    @Override
//                    public void successAccountClick() {
//                        FileUpData();
//                    }
//                }).show();
                break;
            case R.id.img_hint_wage1:
                // popwin弹窗 1.未结工资
                showAccountPopWin(mActivity, img_hint_wage1, 1, role_type);
                break;
            case R.id.img_hint_wage2:
                //popwin弹窗  2.本次结算金额
                showAccountPopWin(mActivity, img_hint_wage2, 2, role_type);
                break;
            case R.id.img_hint_wage3:
                // popwin弹窗  3.剩余未结金额
                showAccountPopWin(mActivity, img_hint_wage3, 3, role_type);
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
            tv_proname.setText(NameUtil.setRemark(proname, 12));
        } else {
            tv_proname.setText("");
        }

    }

    /**
     * edittext输入监听
     *
     * @param editText
     */
    public void addTextChangedListener(final EditText editText) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
//                //这部分是处理如果输入框内小数点后有俩位，那么舍弃最后一位赋值，光标移动到最后
//                if (s.toString().contains(".")) {
//                    if (s.length() - 1 - s.toString().indexOf(".") > 1) {
//
//                        editText.setText(s.toString().subSequence(0,
//                                    s.toString().indexOf(".") + 2));
//
//                        editText.setSelection(s.toString().trim().length() - 1
//                        );
//                    }
//                }
                //这部分是处理如果用户输入以.开头，在前面加上0
                if (s.toString().trim().substring(0).equals(".")) {

                    editText.setText("0" + s);
                    editText.setSelection(2);
                }
                //这里处理用户 多次输入.的处理 比如输入 1..6的形式，是不可以的
                if (s.toString().startsWith("0")
                        && s.toString().trim().length() > 1) {
                    if (!s.toString().substring(1, 2).equals(".")) {
                        editText.setText(s.subSequence(0, 1));
                        editText.setSelection(1);
                        return;
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                //光标移动到最后
                if (s.length() > 0 && s.toString().trim().equals("0.00")) {
                    editText.setSelection(s.toString().trim().length());
                }
                //补贴金额
                Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
                //奖励金额
                Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
                //罚款金额
                Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
                // 本次实付金额
                Double income_money = getEditM(ed_income_money.getText().toString().trim());
                //抹零金额
                Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
//                补奖罚合计金额：
//                合计金额 = 补贴金额 + 奖励金额 - 罚款金额
                wage_all = wage_subsidy + wage_reward - wage_fine;
                //本次结算金额 = 本次实付金额（本次实收金额） + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额
                wage_wage = income_money + wage_del + wage_fine - wage_subsidy - wage_reward;
                //剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额,tv_wage_supplus_unset
                income_all = balance_amount + wage_subsidy + wage_reward - wage_fine - income_money - wage_del;
                switch (editText.getId()) {
                    case R.id.ed_wage_subsidy:
                        //补贴金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_wage_reward:
                        //奖励金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_wage_fine:
                        //罚款金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_income_money: //本次实付金额
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        //改变值后重新计算剩余未结金额和本次结算金额
                        break;
                    case R.id.ed_wage_del: //抹零金额
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;

                }
            }
        });
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
        if (m.contains("-")) {
            if (TextUtils.isEmpty(m.replace("-", ""))) {
                return 0.0;
            } else {
                double da = -Double.parseDouble(m.replace("-", ""));
                return -Double.parseDouble(m.replace("-", ""));
            }


        }
        return Double.parseDouble(m);
    }

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;


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


    private RequestParams getParams() {
//        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");

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
        }
        if (tempPhoto != null && tempPhoto.size() > 0) {
            RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, mActivity);
        }
        return params;
    }

    RequestParams params;

    public void FileUpData() {
        createCustomDialog();
        //相同部分参数
        params = RequestParamsToken.getExpandRequestParams(mActivity);
        AccountInfoBean infoBean = new AccountInfoBean();
        /** 记账类型 1、点工  2、包工  3、总包记账 4.工钱结算*/
        infoBean.setAccounts_type(AccountUtil.SALARY_BALANCE);
        /**记账id*/
        infoBean.setRecord_id(account_id + "");//记账id
        /** 本次支付金额 */
        infoBean.setSalary(ed_income_money.getText().toString());
        /** 未结工资 */
        infoBean.setBalance_amount(balance_amount + "");
        /** 补贴工资 */
        infoBean.setSubsidy_amount(ed_wage_subsidy.getText().toString());
        /** 奖金工资 */
        infoBean.setReward_amount(ed_wage_reward.getText().toString());
        /** 惩罚工资 */
        infoBean.setPenalty_amount(ed_wage_fine.getText().toString());
        /** 抹零工资 */
        infoBean.setDeduct_amount(ed_wage_del.getText().toString());
        /** 项目名称 */
        infoBean.setPro_name(tv_proname.getText().toString());
        /** 项目id */
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        /** 备注描述 */
        if (!TextUtils.isEmpty(ed_remark.getText().toString())) {
            infoBean.setText(ed_remark.getText().toString());
        }

        /** 记账id */
        infoBean.setRecord_id(bean.getRecord_id() + "");
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
                    releaseWage();
                    break;
            }

        }
    };

    /**
     * 发布记账
     */
    public void releaseWage() {
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
//

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
     * 选择人之后设置显示内容
     */
    public void setRoleWage() {
        //设置补奖罚以及抹零金额为空
        ed_wage_subsidy.setText("");
        ed_wage_reward.setText("");
        ed_wage_fine.setText("");
        ed_wage_del.setText("");
        //本次实付金额默认值
        ed_income_money.setText(Utils.m2(balance_amount));
        //重新计算金额
        getPrice();
        //剩余未结金额默认值
        tv_wage_supplus_unset.setText(Utils.m2(balance_amount));
        //本次结算金额
        tv_wage_wage.setText(Utils.m2(wage_wage));
        //剩余未结工资
        tv_wage_supplus_unset.setText(Utils.m2(income_all));
    }

    /**
     * 重新计算下列金额
     * 补奖罚合计金额
     * 本次结算金额
     * 剩余未结金额
     */
    public void getPrice() {
        //补贴金额
        Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
        //奖励金额
        Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
        //罚款金额
        Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
        // 本次实付金额
        Double income_money = getEditM(ed_income_money.getText().toString().trim());
        //抹零金额
        Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
//       补奖罚合计金额 = 补贴金额 + 奖励金额 - 罚款金额
        wage_all = wage_subsidy + wage_reward - wage_fine;
        //本次结算金额 = 本次实付金额（本次实收金额） + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额
        wage_wage = income_money + wage_del + wage_fine - wage_subsidy - wage_reward;
        //剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额,
        income_all = balance_amount + wage_subsidy + wage_reward - wage_fine - income_money - wage_del;
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

    StringBuffer stringBuffer;

    @Override
    public void remove(int position) {
        isChangedata = true;
        if (!imageItems.get(position).imagePath.contains("/storage/")) {
            if (null == stringBuffer) {
                stringBuffer = new StringBuffer();
            }
            LUtils.e("删除了---------------------");
            stringBuffer.append(imageItems.get(position).imagePath + ";");
        } else {
            LUtils.e("没有删除-----------------");
        }
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
        } else if (resultCode == Constance.RESULTWORKERS) {//添加项目回调
            isChangedata = true;
            clearProjectDialog();
        } else if (resultCode == Constance.EDITOR_PROJECT_SUCCESS) {//编辑项目回调
            isChangedata = true;
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            LUtils.e(project.getPro_name() + "-------------添加项目回调------------" + project.getPid() + ",,," + bean.getPid());
            //设置备注信息
            if (!TextUtils.isEmpty(project.getPro_name()) && bean.getPid() == project.getPid()) {
                bean.setPid(project.getPid());
                bean.setProname(project.getPro_name());
                setProInfo(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()), project.getPro_name());
            }
            clearProjectDialog();
        } else if (resultCode == Constance.SELECTE_PROJECT) {//修改了项目
            LUtils.e("----------BBBBBB----------:");
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (null == project) {
                setProInfo(0, "");
                return;
            }
            setProInfo(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()), project.getPro_name());
        }
        if (requestCode == Constance.REQUEST) {//确认记工
            getDetailInfo();

        }
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
     * 查询记账信息详情
     */

    private void getDetailInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("record_id", account_id + "");
        params.addBodyParameter("accounts_type", account_type + "");
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
     * 显示记账提示popwindow
     *
     * @param activity
     * @param view
     * @param type     类型 1.未结工资 2.本次结算金额 3.剩余未结金额
     */
    public void showAccountPopWin(Activity activity, View view, int type, String roleType) {
        if (null != accountPopupView) {
            accountPopupView.dismiss();
        }
        View popView = activity.getLayoutInflater().inflate(R.layout.layout_pop_wage, null);
        RelativeLayout rea_pop_layout = (RelativeLayout) popView.findViewById(R.id.rea_pop_layout);
        rea_pop_layout.setAlpha(0.9f);
        accountPopupView = new PopupWindow(popView, RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        // 设置动画
//         window.setAnimationStyle(R.style.popup_window_anim);
        //  设置背景颜色
        accountPopupView.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#00000000")));
        // 设置可以获取焦点
        accountPopupView.setFocusable(true);
        //  设置可以触摸弹出框以外的区域
        accountPopupView.setOutsideTouchable(true);
        // 更新popupwindow的状态
        accountPopupView.update();


        //  以下拉的方式显示，并且可以设置显示的位置
//        accountPopupView.showAsDropDown(view, 0, 20);

        TextView tv_pop_content = (TextView) popView.findViewById(R.id.tv_pop_content);
        popView.findViewById(R.id.tv_pop_dismiss).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != accountPopupView) {
                    accountPopupView.dismiss();
                }
            }
        });
        switch (type) {
            case 1:
                tv_pop_content.setText("未结工资 = 点工工资 + 包工工资 - 借支金额 - 已结金额");
                break;
            case 2:
                if (roleType.equals(Constance.ROLETYPE_FM)) {
                    tv_pop_content.setText("本次结算金额 = 本次实付金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额");
                } else {
                    tv_pop_content.setText("本次结算金额 = 本次实收金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额");
                }

                break;
            case 3:
                if (roleType.equals(Constance.ROLETYPE_FM)) {
                    tv_pop_content.setText("剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实付金额 - 抹零金额");
                } else {
                    tv_pop_content.setText("剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额");
                }
                break;
        }

        //在控件上方显示
        int[] location = new int[2];
        view.getLocationOnScreen(location);
        //获取自身的长宽高
        popView.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        int popupHeight = popView.getMeasuredHeight();
        int popupWidth = popView.getMeasuredWidth();
        accountPopupView.showAtLocation(view, Gravity.NO_GRAVITY, (location[0] - DensityUtils.dp2px(activity, 27)), location[1] - popupHeight);

        LUtils.e(location[0] + ",,," + location[1] + "---------" + popupWidth + "--------" + DensityUtils.dp2px(activity, 31));
        LUtils.e(((location[0]) + popupWidth / 2) + ",,," + (location[1] - popupHeight));
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
