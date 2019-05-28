package com.jizhi.jlongg.main.activity.welcome;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoDB;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.IsSupplement;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.Report;
import com.jizhi.jlongg.main.bean.WorkType;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.FamiliarityAndEndineerDialog;
import com.jizhi.jlongg.main.dialog.ProjectTypeDialog;
import com.jizhi.jlongg.main.dialog.ProjectTypeDialog.ConfirmClickListener;
import com.jizhi.jlongg.main.dialog.WheelViewSelectProvinceCityArea;
import com.jizhi.jlongg.main.listener.SelectProvinceCityAreaListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.File;
import java.io.IOException;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 完善资料
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-1-11 下午6:30:42
 */
public class RegisterPerfectDataActivity extends BaseActivity implements OnClickListener, SelectProvinceCityAreaListener {

    /**
     * 真实姓名
     */
    @ViewInject(R.id.realName_layout)
    private RelativeLayout realName_layout;
    /**
     * 性别
     */
    @ViewInject(R.id.sex_layout)
    private RelativeLayout sex_layout;

    /**
     * 年龄
     */
    @ViewInject(R.id.age_layout)
    private RelativeLayout age_layout;

    /**
     * 家乡
     */
    @ViewInject(R.id.hometown_layout)
    private RelativeLayout hometown_layout;

    /**
     * 工作类型
     */
    @ViewInject(R.id.work_type_layout)
    private RelativeLayout work_type_layout;

    /**
     * 规模
     */
    @ViewInject(R.id.work_scale_layout)
    private RelativeLayout work_scale_layout;

    /**
     * 工龄
     */
    @ViewInject(R.id.work_year_layout)
    private RelativeLayout work_year_layout;

    /**
     * 工作地址
     */
    @ViewInject(R.id.work_address_layout)
    private RelativeLayout work_address_layout;

    /**
     * 头像布局
     */
    @ViewInject(R.id.head_layout)
    private LinearLayout head_layout;


    private RegisterPerfectDataActivity mActivity;
    /**
     * 姓名
     */
    @ViewInject(R.id.ed_name)
    private EditText ed_name;
    /**
     * 性别
     */
    @ViewInject(R.id.sex_rg)
    private RadioGroup sex_rg;
    /**
     * 家乡
     */
    @ViewInject(R.id.ed_age)
    private EditText ed_age;
    /**
     * 家乡
     */
    @ViewInject(R.id.tv_myhome)
    private TextView tv_myhome;
    /**
     * 工种
     */
    @ViewInject(R.id.tv_work_type)
    private TextView tv_work_type;
    /**
     * 工人规模
     */
    @ViewInject(R.id.ed_pc)
    private EditText ed_pc;
    /**
     * 工龄
     */
    @ViewInject(R.id.ed_workyear)
    private EditText ed_workyear;
    /**
     * 头像
     */
    @ViewInject(R.id.img_photos)
    private ImageView img_photo;
    /**
     * 期望工作地
     */
    @ViewInject(R.id.tv_workaddr)
    private TextView tv_workaddr;
    /**
     * 家乡和期望工作地编码
     */
    private String homeCode, workAddrCode;
    /**
     * 项目类型 工种类型
     */
    private List<WorkType> workTypeLists;
    /**
     * 提交工种id
     */
    private String workTypeId;
    /**
     * 头像路径
     */
    private String headPath;
    /**
     * 当前注册角色
     */
    private String role;
    /**
     * 选择期望工作地弹框
     */
    private WheelViewSelectProvinceCityArea expectedWorkPopWindow;
    /**
     * 选择家乡弹框
     */
    private WheelViewSelectProvinceCityArea homePopWindow;
    /**
     * 选择工种弹框
     */
    private ProjectTypeDialog workDialog;
    /**
     * 工程类别
     */
    @ViewInject(R.id.engineeringText)
    private TextView engineeringText;
    /**
     * 熟练度
     */
    @ViewInject(R.id.familiarityText)
    private TextView familiarityText;
    /**
     * 工程类别布局
     */
    @ViewInject(R.id.engineeringLayout)
    private View engineeringLayout;
    /**
     * 熟练度布局
     */
    @ViewInject(R.id.familiarityLayout)
    private View familiarityLayout;

    /**
     * 熟练度、工程类别弹出框
     */
    private FamiliarityAndEndineerDialog familiarityAndEngineeringDialog;

    /**
     * 熟练度、工程类别数据
     */
    private List<Report> familiarityList, engineeringList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_prefectdata);
        ViewUtils.inject(this);
        initView();
        initData();
    }


    private void initView() {
        setTextTitleAndRight(R.string.complete_information, R.string.jump);
        mActivity = RegisterPerfectDataActivity.this;
        role = UclientApplication.getRoler(this);
        if (role.equals(Constance.ROLETYPE_WORKER)) { //如果注册的对象是工人则隐藏工人规模
            findViewById(R.id.work_scale_layout).setVisibility(View.GONE);
        } else {
            familiarityLayout.setVisibility(View.GONE); //如果是工头则需要隐藏熟练度
        }
        ed_name.setFocusable(true);
        ed_name.setFocusableInTouchMode(true);
        ed_name.requestFocus();
    }

    /**
     * 初始化数据
     */
    private void initData() {
        BaseInfoService baseInfoService = BaseInfoService.getInstance(getApplicationContext());
        // 在本地数据库读取 项目类型,工作类型
        workTypeLists = baseInfoService.selectInfo(BaseInfoDB.jlg_work_type);
        baseInfoService.closeDB();
        getUserInfo();
        boolean isFirstReg = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false); //是否是第一次完善资料信息
        findViewById(R.id.returnText).setVisibility(isFirstReg ? View.GONE : View.VISIBLE); //如果是第一次完善资料信息则隐藏返回按钮
    }


    /**
     * 隐藏已经补充过的资料
     */
    private void hideAlreadySupplementLayout(IsSupplement issuppermen) {
        if (issuppermen.getRealname() == 0) {
            findViewById(R.id.realName_layout).setVisibility(View.GONE);
        }
        if (issuppermen.getGender() == 0) {
            findViewById(R.id.sex_layout).setVisibility(View.GONE);
        }
        if (issuppermen.getAge() == 0) {
            findViewById(R.id.age_layout).setVisibility(View.GONE);
        }
        if (issuppermen.getHometown() == 0) {
            findViewById(R.id.hometown_layout).setVisibility(View.GONE);
        }
        if (role.equals(Constance.ROLETYPE_WORKER)) {
            if (issuppermen.getW_worktype() == 0) {
                findViewById(R.id.work_type_layout).setVisibility(View.GONE);
            }
        } else {
            if (issuppermen.getF_worktype() == 0) {
                findViewById(R.id.work_type_layout).setVisibility(View.GONE);
            }
            if (issuppermen.getPerson_count() == 0) {
                findViewById(R.id.work_scale_layout).setVisibility(View.GONE);
            }
        }
        if (issuppermen.getWorkyear() == 0) {
            findViewById(R.id.work_year_layout).setVisibility(View.GONE);
        }
        if (issuppermen.getExpectaddr() == 0) {
            findViewById(R.id.work_address_layout).setVisibility(View.GONE);
        }
        if (issuppermen.getHead_pic() == 0) {
            findViewById(R.id.head_layout).setVisibility(View.GONE);
        }
        ScrollView scrollView = (ScrollView) findViewById(R.id.scrollView);
        scrollView.scrollTo(0, 0);
    }


    /**
     * 获取工程类别、熟练度
     *
     * @param classType 1:工种 2：项目类型3：熟练度
     */
    public void getFamiAndEnineer(final String classType) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_id", classType);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CLASSLIST,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<Report> bean = CommonListJson.fromJson(responseInfo.result, Report.class);
                            if (bean.getState() != 0 && bean.getValues() != null && bean.getValues().size() > 0) {
                                if (familiarityAndEngineeringDialog == null) {
                                    familiarityAndEngineeringDialog = new FamiliarityAndEndineerDialog(RegisterPerfectDataActivity.this, new FamiliarityAndEndineerDialog.SelectedListener() {
                                        @Override
                                        public void selectedCallBack(String selectedValue, String classType) {
                                            if (classType.equals("2")) { //工程类别
                                                engineeringText.setText(selectedValue);
                                            } else if (classType.equals("3")) { //熟练度
                                                familiarityText.setText(selectedValue);
                                            }
                                        }
                                    });
                                }
                                if (classType.equals("2")) { //工程类别
                                    engineeringList = bean.getValues();
                                    familiarityAndEngineeringDialog.setClassType("2");
                                    familiarityAndEngineeringDialog.setList(engineeringList);
                                    familiarityAndEngineeringDialog.setMaxSelectedSize(3);
                                    familiarityAndEngineeringDialog.show();
                                    familiarityAndEngineeringDialog.updateData();
                                } else if (classType.equals("3")) { //熟练度
                                    familiarityList = bean.getValues();
                                    familiarityAndEngineeringDialog.setClassType("3");
                                    familiarityAndEngineeringDialog.setList(familiarityList);
                                    familiarityAndEngineeringDialog.setMaxSelectedSize(1);
                                    familiarityAndEngineeringDialog.show();
                                    familiarityAndEngineeringDialog.updateData();
                                }
                            } else {
                                CommonMethod.makeNoticeShort(mActivity, bean.getErrmsg(), CommonMethod.ERROR);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }

    /**
     * 获取当前用户已经填写了 哪些信息
     */
    public void getUserInfo() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GETBASEINFO,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<IsSupplement> bean = CommonJson.fromJson(responseInfo.result, IsSupplement.class);
                            if (bean.getState() != 0 && bean.getValues() != null) {
                                hideAlreadySupplementLayout(bean.getValues());
                                return;
                            } else {
                                CommonMethod.makeNoticeShort(mActivity, bean.getErrmsg(), CommonMethod.ERROR);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                        finish();
                    }
                });
    }


    @Override
    public void onFinish(View view) {
        returnCall();
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        returnCall();
        super.onBackPressed();
    }

    private boolean returnCall() {
        recycledBitmap();
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) { //如果是第一次注册用户则跳到主页面
            Intent intent = new Intent(this, AppMainActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
            return true;
        }
        return false;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.hometown_layout:// 家乡
                hideSoftKeyboard();
                if (homePopWindow == null) {
                    homePopWindow = new WheelViewSelectProvinceCityArea(this, this, getString(R.string.home_null), Constance.HOME);
                } else {
                    homePopWindow.update();
                }
                //显示窗口
                homePopWindow.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.work_type_layout:// 工种类型
                hideSoftKeyboard();
                if (workDialog == null) {
                    workDialog = new ProjectTypeDialog(mActivity, confirmClickListener, workTypeLists, null, Constance.RIGISTR_ORIGIN_PROJECTTYPE);
                    workDialog.setCanceledOnTouchOutside(true);
                    workDialog.setCancelable(true);
                }
                workDialog.show();
                break;
            case R.id.work_address_layout:// 期望工作地
                hideSoftKeyboard();
                if (expectedWorkPopWindow == null) {
                    expectedWorkPopWindow = new WheelViewSelectProvinceCityArea(this, this, getString(R.string.expecttowork1), Constance.EXPECTEDWORK);
                } else {
                    expectedWorkPopWindow.update();
                }
                //显示窗口
                expectedWorkPopWindow.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.rea_head:// 选择头像
                CameraPop.singleSelector(this, null);
                break;
            case R.id.btn_save://保存资料
                if (validate()) {
                    upData();
                }
                break;
            case R.id.right_title:
                onFinish(null);
                break;
            case R.id.engineeringLayout: //工程类别
                if (engineeringList != null && engineeringList.size() > 0) {
                    familiarityAndEngineeringDialog.setClassType("2");
                    familiarityAndEngineeringDialog.setList(engineeringList);
                    familiarityAndEngineeringDialog.setMaxSelectedSize(3);
                    familiarityAndEngineeringDialog.show();
                    familiarityAndEngineeringDialog.updateData();
                } else {
                    getFamiAndEnineer("2");
                }
                break;
            case R.id.familiarityLayout: //熟练度
                if (familiarityList != null && familiarityList.size() > 0) {
                    familiarityAndEngineeringDialog.setClassType("3");
                    familiarityAndEngineeringDialog.setList(familiarityList);
                    familiarityAndEngineeringDialog.setMaxSelectedSize(1);
                    familiarityAndEngineeringDialog.show();
                    familiarityAndEngineeringDialog.updateData();
                } else {
                    getFamiAndEnineer("3");
                }
                break;
        }
    }


    public RequestParams paramUpData() {
        int flag = View.VISIBLE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("role_type", role);
        //如果没有补充过资料
        if (realName_layout.getVisibility() == flag) { //真实姓名
            params.addBodyParameter("realname", ed_name.getText().toString().trim());
        }
        if (sex_layout.getVisibility() == flag) { //性别
            params.addBodyParameter("gender", sex() + "");
        }
        if (age_layout.getVisibility() == flag) { //年龄
            params.addBodyParameter("age", ed_age.getText().toString());
        }
        if (hometown_layout.getVisibility() == flag && !TextUtils.isEmpty(homeCode)) { //家乡code
            params.addBodyParameter("hometown", homeCode);
        }
        if (work_type_layout.getVisibility() == flag) { //工种Id
            params.addBodyParameter(role.equals(Constance.ROLETYPE_WORKER) ? "w_worktype" : "f_worktype", workTypeId);
        }
        if (work_scale_layout.getVisibility() == flag) { //工人规模
            params.addBodyParameter("person_count", ed_pc.getText().toString());
        }
        if (work_year_layout.getVisibility() == flag) { //工龄
            params.addBodyParameter("workyear", ed_workyear.getText().toString());
        }
        if (work_address_layout.getVisibility() == flag && !TextUtils.isEmpty(workAddrCode)) { //期望工作地编码
            params.addBodyParameter("expectaddr", workAddrCode);
        }
        if (head_layout.getVisibility() == flag && !TextUtils.isEmpty(headPath)) { //头像
            params.addBodyParameter("head_pic", new File(headPath));
        }
        params.addBodyParameter("w_protype", getEnineerData()); //工程规模
        if (UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER)) { //如果是工友还需要填写熟练度
            params.addBodyParameter("work_level", getFamilyData()); //熟练度
        }
        return params;
    }

    /**
     * 获取工程类别
     *
     * @return
     */
    private String getEnineerData() {
        StringBuilder builder = new StringBuilder();
        int i = 0;
        for (Report report : engineeringList) {
            if (report.isSeleted()) {
                builder.append(i == 0 ? report.getCode() : "," + report.getCode());
                i += 1;
            }
        }
        return builder.toString();
    }

    /**
     * 获取熟练度
     *
     * @return
     */
    private String getFamilyData() {
        StringBuilder builder = new StringBuilder();
        int i = 0;
        for (Report report : familiarityList) {
            if (report.isSeleted()) {
                builder.append(i == 0 ? report.getCode() : "," + report.getCode());
                i += 1;
            }
        }
        return builder.toString();
    }


    /**
     * 验证资料信息
     */
    private boolean validate() {
        /** 是否通过验证 */
        boolean isSuccess = false;
        int flag = View.VISIBLE;
        if (realName_layout.getVisibility() == flag && !validateRealName()) {
            return isSuccess;
        }
        if (age_layout.getVisibility() == flag && !validateAge()) {
            return isSuccess;
        }
        if (work_type_layout.getVisibility() == flag && !validateWorkType()) {
            return isSuccess;
        }
        if (engineeringLayout.getVisibility() == flag && !validateEngineering()) {
            return isSuccess;
        }
        if (familiarityLayout.getVisibility() == flag && !validatefamiliarity()) {
            return isSuccess;
        }
        if (work_year_layout.getVisibility() == flag && !validateWorkYear()) {
            return isSuccess;
        }
        if (work_scale_layout.getVisibility() == flag && !validateScaleMode()) {
            return isSuccess;
        }
        isSuccess = true;
        return isSuccess;
    }

    /**
     * 验证工程类别
     */
    private boolean validateEngineering() {
        if (engineeringList == null || engineeringList.size() == 0) {
            CommonMethod.makeNoticeShort(this, "请选择工程类别", CommonMethod.ERROR);
            return false;
        }
        int count = 0;
        for (Report report : engineeringList) {
            if (report.isSeleted()) {
                count += 1;
            }
        }
        if (count == 0) {
            CommonMethod.makeNoticeShort(this, "请选择工程类别", CommonMethod.ERROR);
            return false;
        }
        return true;
    }

    /**
     * 验证熟练度
     */
    private boolean validatefamiliarity() {
        if (familiarityList == null || familiarityList.size() == 0) {
            CommonMethod.makeNoticeShort(this, "请选择熟练度", CommonMethod.ERROR);
            return false;
        }
        int count = 0;
        for (Report report : familiarityList) {
            if (report.isSeleted()) {
                count += 1;
            }
        }
        if (count == 0) {
            CommonMethod.makeNoticeShort(this, "请选择熟练度", CommonMethod.ERROR);
            return false;
        }
        return true;
    }


    /**
     * 验证年龄
     */
    private boolean validateAge() {
        String ages = ed_age.getText().toString();
        if (TextUtils.isEmpty(ages)) {
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.age_null), CommonMethod.ERROR);
            return false;
        }
        int age = Integer.parseInt(ages);
        if (age < 16 || age > 60) {
            CommonMethod.makeNoticeShort(this, getString(R.string.ageRange), CommonMethod.ERROR);
            return false;
        }
        return true;
    }

    /**
     * 验证姓名
     */
    private boolean validateRealName() {
        String name = ed_name.getText().toString().trim();
        if (TextUtils.isEmpty(name)) {
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.name_null), CommonMethod.ERROR);
            return false;
        }
        if (name.length() < 2 || name.length() > 15) {
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.name_length_error), CommonMethod.ERROR);
            return false;
        }
        return true;
    }

    /**
     * 验证工种类型
     */
    private boolean validateWorkType() {
        String worktype = tv_work_type.getText().toString().trim();
        if (TextUtils.isEmpty(worktype)) { //工种类型
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.worktype_null), CommonMethod.ERROR);
            return false;
        }
        return true;
    }

    /**
     * 验证工人规模
     */
    private boolean validateScaleMode() {
        String workpeoplecount = ed_pc.getText().toString().trim();
        if (TextUtils.isEmpty(workpeoplecount) && workpeoplecount.length() < 1 || workpeoplecount.length() > 5) {
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.workpeopcount), CommonMethod.ERROR);
            return false;
        }
        return true;
    }


    /**
     * 验证工龄
     */
    private boolean validateWorkYear() {
        String workyear = ed_workyear.getText().toString();
        if (TextUtils.isEmpty(workyear)) {
            CommonMethod.makeNoticeShort(mActivity, getString(R.string.workyearhint), CommonMethod.ERROR);
            return false;
        }
        int year = Integer.parseInt(workyear);
        if (year < 0 || year > 50) {
            CommonMethod.makeNoticeShort(this, getString(R.string.workyearRange), CommonMethod.ERROR);
            return false;
        }
        return true;
    }

    /**
     * 补充资料
     */
    public void upData() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MDUSERINFOS, paramUpData(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> bean = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (bean.getState() != 0) {
                        SPUtils.put(mActivity, Constance.enum_parameter.IS_INFO.toString(), Constance.IS_INFO_YES, Constance.JLONGG);
                        SPUtils.put(getApplicationContext(), Constance.IS_HAS_REALNAME, 1, Constance.JLONGG);
                        if (!TextUtils.isEmpty(ed_name.getText().toString())) {
                            SPUtils.put(getApplicationContext(), Constance.USERNAME, ed_name.getText().toString(), Constance.JLONGG);
                        }
                        if (!returnCall()) {
                            setResult(Constance.LOGIN_SUCCESS);
                        }
                        finish();
                    } else {
                        CommonMethod.makeNoticeShort(RegisterPerfectDataActivity.this, bean.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });

    }


    /**
     * 判断性别选择
     */
    private int sex() {
        int sexCount = 1;
        if (sex_rg.getCheckedRadioButtonId() == R.id.sex_rb_nan) {
            sexCount = 1;
        } else if (sex_rg.getCheckedRadioButtonId() == R.id.sex_rb_nv) {
            sexCount = 2;
        }
        return sexCount;
    }


    /**
     * 工种，项目类型点击事件结束
     */
    private ConfirmClickListener confirmClickListener = new ConfirmClickListener() {
        @Override
        public void getText() {
            StringBuffer bufferWorkName = new StringBuffer();
            StringBuffer bufferWorkID = new StringBuffer();
            for (int i = 0; i < workTypeLists.size(); i++) {
                if (workTypeLists.get(i).isSelected()) {
                    bufferWorkID.append(workTypeLists.get(i).getWorktype() + ",");
                    bufferWorkName.append(workTypeLists.get(i).getWorkName() + ",");
                }
            }
            if (bufferWorkName.length() == 0) {
                tv_work_type.setText("");
                workTypeId = null;
            } else {
                String str = bufferWorkName.substring(0, bufferWorkName.length() - 1);
                workTypeId = bufferWorkID.substring(0, bufferWorkID.length() - 1);
                tv_work_type.setText(str);
            }
        }
    };


    @Override
    protected void onDestroy() {
        super.onDestroy();
        File destDir = new File(UtilFile.JGJIMAGEPATH);// 文件目录
        if (destDir.exists()) {// 判断目录是否存在，不存在创建
            UtilFile.RecursionDeleteFile(destDir);
        }
    }

    public void recycledBitmap() {
        if (headBitmap != null && !headBitmap.isRecycled()) {
            headBitmap.isRecycled();
            headBitmap = null;
            System.gc();
        }
    }


    private Bitmap headBitmap;

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE) { //选择照片回调
            if (resultCode == RESULT_OK) {
                List<String> strings = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
                doCropPhoto(strings.get(0));
            }
        } else if (requestCode == CameraPop.IMAGE_CROP && resultCode == RESULT_OK) { //裁剪相册回调
            try {
                recycledBitmap();
                Object[] object = UtilFile.saveBitmapToFile(headPath);
                String str = (String) object[0];
                headBitmap = (Bitmap) object[1];
                if (headBitmap != null) {
                    headPath = str;
                    img_photo.setImageBitmap(headBitmap);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 裁剪相片
     */
    public void doCropPhoto(String path) {
        File directorFile = new File(UtilFile.JGJIMAGEPATH + File.separator + "Head");
        if (!directorFile.exists()) {
            directorFile.mkdirs();
        }
        String cropPath = directorFile.getAbsolutePath() + File.separator + "tempHead" + path.substring(path.lastIndexOf(".")); //裁剪图片新生成的图片路径
        File cropFile = new File(cropPath);
        if (cropFile.exists()) {
            cropFile.delete();
        }
        try {
            headPath = cropPath;
            // 启动gallery去剪辑这个照片
            Intent intent = UtilFile.getCropImageIntent(new File(path), new File(cropPath));
            startActivityForResult(intent, CameraPop.IMAGE_CROP);
        } catch (Exception e) {
            Toast.makeText(mActivity, "获取照片错误", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void selectedCityResult(String type, String cityCode, String cityName) {
        switch (type) {
            case Constance.HOME: //家乡
                tv_myhome.setText(cityName);
                homeCode = cityCode;
                break;
            case Constance.EXPECTEDWORK: //期望工作地
                tv_workaddr.setText(cityName);
                workAddrCode = cityCode;
                break;
        }
    }
}
