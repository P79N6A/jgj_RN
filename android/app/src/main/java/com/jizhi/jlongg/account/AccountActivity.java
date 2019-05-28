//package com.jizhi.jlongg.account;
//
//import android.app.Activity;
//import android.content.Intent;
//import android.os.Bundle;
//import android.support.annotation.IdRes;
//import android.support.v4.view.ViewPager;
//import android.text.TextUtils;
//import android.view.View;
//import android.view.animation.Animation;
//import android.view.animation.Transformation;
//import android.widget.ImageView;
//import android.widget.RadioButton;
//import android.widget.RadioGroup;
//import android.widget.TextView;
//
//import com.google.gson.Gson;
//import com.hcs.uclient.utils.DatePickerUtil;
//import com.hcs.uclient.utils.DensityUtils;
//import com.hcs.uclient.utils.LUtils;
//import com.hcs.uclient.utils.Utils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.activity.BaseActivity;
//import com.jizhi.jlongg.main.activity.RemarksActivity;
//import com.jizhi.jlongg.main.application.UclientApplication;
//import com.jizhi.jlongg.main.bean.AgencyGroupUser;
//import com.jizhi.jlongg.main.bean.ImageItem;
//import com.jizhi.jlongg.main.bean.PersonBean;
//import com.jizhi.jlongg.main.bean.Project;
//import com.jizhi.jlongg.main.bean.Salary;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.DataUtil;
//import com.jizhi.jlongg.main.util.IsSupplementary;
//import com.jizhi.jlongg.main.util.MessageUtil;
//
//import java.util.ArrayList;
//import java.util.List;
//
//import static com.jizhi.jlongg.main.util.Constance.BEAN_CONSTANCE;
//
//
///**
// * 功能:记账父Activity
// * 时间:2017/2/14 11:52
// * 作者:hcs
// */
//
//public class AccountActivity extends BaseActivity {
//    private ViewPager mViewPager;
//    /* Fragment 集合 */
//    private List<AccountFragment> mFragments;
//    //点工，包工，借支
//    private RadioButton btn_hour, btn_all_account,btn_all_work, btn_borrow, btn_wages_settlement;
//    //ViewPager下标
//    private int currentIndex;
//    protected boolean isMsgAccount;
//    protected String roleType, proName;
//    protected int msgPid;
//    private float screenWidth;
//    private AgencyGroupUser agency_group_user;
//
//    /**
//     * 启动当前Activity
//     *
//     * @param context
//     */
//    public static void actionStart(Activity context, int page, PersonBean personBean, String balance_amount) {
//        Intent intent = new Intent(context, AccountActivity.class);
//        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
//        intent.putExtra(Constance.BEAN_INT, page);
//        intent.putExtra(BEAN_CONSTANCE, personBean);
//        intent.putExtra(Constance.BEAN_STRING, balance_amount);
//        context.startActivityForResult(intent, Constance.REQUEST);
//    }
//
//    /**
//     * 启动当前Activity
//     *
//     * @param context
//     */
//    public static void actionStart(Activity context) {
//        Intent intent = new Intent(context, AccountActivity.class);
//        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
//        context.startActivityForResult(intent, Constance.REQUEST);
//    }
//
//    /**
//     * 启动当前Activity
//     *
//     * @param context
//     * @param date    日期
//     */
//    public static void actionStart(Activity context, String date) {
//        Intent intent = new Intent(context, AccountActivity.class);
//        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
//        intent.putExtra(Constance.DATE, date);
//        context.startActivityForResult(intent, Constance.REQUEST);
//    }
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_account);
//        initFragment();
//        initView();
//        mViewPager.addOnPageChangeListener(onPageChangeListener);
//        isMsgAccount = getIntent().getBooleanExtra(Constance.ISMSGBILL, false);
//        roleType = getIntent().getStringExtra(Constance.enum_parameter.ROLETYPE.toString());
//        if (isMsgAccount) {
//            //班组内记账
//            proName = getIntent().getStringExtra(Constance.PRONAME);
//            //带班长信息
//            agency_group_user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser");
//            if (null != agency_group_user && !TextUtils.isEmpty(getIntent().getStringExtra(Constance.GROUP_ID))) {
//                agency_group_user.setGroup_id(getIntent().getStringExtra(Constance.GROUP_ID));
//            }
//            String pid = getIntent().getStringExtra(Constance.PID);
//            msgPid = TextUtils.isEmpty(pid)?0:Integer.parseInt(pid);
//        }
//        //是否完善姓名
//        if (!IsSupplementary.isFillRealNameCallBackListener(AccountActivity.this, true, new IsSupplementary.CallSupplementNameSuccess() {
//            @Override
//            public void onSuccess() {
//                //完善姓名成功
//                DataUtil.UpdateLoginver(AccountActivity.this);
//                Intent intent = new Intent();
//                intent.setAction(Constance.ACTION_UPDATEUSERINFO);
//                broadcastManager.sendBroadcast(intent);
//            }
//        })) ;
//        if (currentIndex == 3) {
//            btn_wages_settlement.setChecked(true);
//            findViewById(R.id.img_arrow_top).setX(screenWidth - (screenWidth / 4));
//        }
//    }
//
//    public AgencyGroupUser getAgency_group_user() {
//        return agency_group_user;
//    }
//
//
//    /**
//     * 初始化fragment
//     */
//    public void initFragment() {
//        mFragments = new ArrayList<>();
//        HourWorkFragment hourWorkFragment = new HourWorkFragment();
//        AllWorkFragment allWorkFragment = new AllWorkFragment();
//        BorrowWorkFragment borrowWorkFragment = new BorrowWorkFragment();
//        WagesSettlementFragment wageFragment = new WagesSettlementFragment();
//        mFragments.add(hourWorkFragment);
//        mFragments.add(allWorkFragment);
//        mFragments.add(borrowWorkFragment);
//        mFragments.add(wageFragment);
//    }
//
//    /**
//     * 初始化view
//     */
//    public void initView() {
//        mViewPager = findViewById(R.id.viewPager);
//        mViewPager.setOffscreenPageLimit(3);
//        mViewPager.setAdapter(new AccountViewPageAdapter(getSupportFragmentManager(), mFragments));
//        currentIndex = getIntent().getIntExtra(Constance.BEAN_INT, 0);
//        mViewPager.setCurrentItem(currentIndex);
//        btn_hour = findViewById(R.id.btn_hour);
//        btn_all_account =  findViewById(R.id.btn_all_account);
//        btn_all_work =  findViewById(R.id.btn_all_work);
//        btn_borrow =  findViewById(R.id.btn_borrow);
//        btn_wages_settlement = findViewById(R.id.btn_wages_settlement);
//        RadioGroup radioGroup = findViewById(R.id.radioGroup);
//        screenWidth = DensityUtils.getScreenWidth(AccountActivity.this);
//        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
//            @Override
//            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
//                switch (checkedId) {
//                    case R.id.btn_hour:
//                        currentIndex = 0;
//                        mViewPager.setCurrentItem(0);
//                        break;
//                    case R.id.btn_all_account:
//                        currentIndex = 1;
//                        mViewPager.setCurrentItem(1);
//                        break;
//                    case R.id.btn_borrow:
//                        currentIndex = 2;
//                        mViewPager.setCurrentItem(2);
//                        break;
//                    case R.id.btn_wages_settlement:
//                        currentIndex = 3;
//                        mViewPager.setCurrentItem(3);
//                        break;
//
//                }
//                mViewPager.setCurrentItem(currentIndex);
//            }
//        });
//    }
//
//    /**
//     * 初始化结算信息
//     */
//    public void initSettlement() {
//        PersonBean personBean = (PersonBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
//        if (null != personBean && personBean.getUid() != 0) {
//            //设置工人信息
//            AccountFragment fragment = mFragments.get(currentIndex);
//            WagesSettlementFragment wageragment = (WagesSettlementFragment) fragment;
//            wageragment.setPersonName(personBean.getName());
//            wageragment.uid = personBean.getUid();
//            wageragment.personBean = personBean;
//            wageragment.getUnPaySalaryList(personBean.getUid() + "");
//            if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
//                wageragment.LastRecordInfo();
//            }
//        }
//    }
//
//    /**
//     * viewpager底部滚动监听
//     */
//    ViewPager.OnPageChangeListener onPageChangeListener = new ViewPager.OnPageChangeListener() {
//        @Override
//        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
//
//        }
//
//        @Override
//        public void onPageSelected(int position) {
//            final ImageView img_arrow_top =  findViewById(R.id.img_arrow_top);
//            switch (position) {
//                case 0:
//                    currentIndex = 0;
//                    btn_hour.setChecked(true);
//                    img_arrow_top.setX((screenWidth / 4 / 2) - img_arrow_top.getWidth());
//                    break;
//                case 1:
//                    currentIndex = 1;
//                    btn_all_account.setChecked(true);
//
//                    img_arrow_top.setX((screenWidth / 4 / 2) + screenWidth / 4 - img_arrow_top.getWidth());
//                    break;
//                case 2:
//                    currentIndex = 2;
//                    btn_borrow.setChecked(true);
//                    img_arrow_top.setX((screenWidth / 4 / 2) + (screenWidth / 4) * 2 - img_arrow_top.getWidth());
//                    break;
//                case 3:
//                    btn_wages_settlement.setChecked(true);
//                    currentIndex = 3;
//                    img_arrow_top.setX((screenWidth / 4 / 2) + (screenWidth / 4) * 3 - img_arrow_top.getWidth());
//                    break;
//
//
//            }
//        }
//
//        @Override
//        public void onPageScrollStateChanged(int state) {
//
//        }
//    };
//
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (resultCode == Constance.SUCCESS) {//选择工人回调
//            AccountFragment fragment = mFragments.get(currentIndex);
//            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
//            if (personBean == null) {  //true 表示删除了记账对象
//                HourWorkFragment hourWorkFragment = (HourWorkFragment) mFragments.get(0);
//                AllWorkFragment allWorkFragment = (AllWorkFragment) mFragments.get(1);
//                BorrowWorkFragment borrowWorkFragment = (BorrowWorkFragment) mFragments.get(2);
//                hourWorkFragment.successAccountClick();
//                allWorkFragment.successAccountClick();
//                borrowWorkFragment.successAccountClick();
//                hourWorkFragment.isChangeTime = false;
//                allWorkFragment.isChangeTime = false;
//            }
//            if (personBean != null) {
//                if (currentIndex == 0) {//点工
////                    //点工的上班/加班时长
//                    HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                    hourFragment.getWorkTPlByUid(personBean, false);
//                } else if (currentIndex == 1) { //包工
//                    //设置工人信息
//                    AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                    allFragment.getPersonMode(personBean);
//                } else if (currentIndex == 2) { //借支
//                    //设置工人信息
//                    BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                    borrowFragment.setPersonName(personBean.getName());
//                    borrowFragment.uid = personBean.getUid();
//                    borrowFragment.personBean = personBean;
//                    borrowFragment.getUnPaySalaryList(personBean.getUid() + "");
//                    if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
//                        borrowFragment.LastRecordInfo();
//                    }
//                } else if (currentIndex == 3) { //结算
//                    //设置工人信息
//                    WagesSettlementFragment wageragment = (WagesSettlementFragment) fragment;
//                    wageragment.setPersonName(personBean.getName());
//                    wageragment.uid = personBean.getUid();
//                    wageragment.personBean = personBean;
//                    wageragment.getUnPaySalaryList(personBean.getUid() + "");
//                    if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
//                        wageragment.LastRecordInfo();
//                    }
//                }
//            }
//        } else if (resultCode == Constance.REMARK_SUCCESS) { //备注返回
//            AccountFragment fragment = mFragments.get(currentIndex);
//            String remark = data.getStringExtra(RemarksActivity.REMARK_DESC);
//            List<ImageItem> imageItems = (List<ImageItem>) data.getSerializableExtra(RemarksActivity.PHOTO_DATA);
//            if (currentIndex == 0) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                //设置备注信息
//                hourFragment.setRemarkDesc(remark, imageItems);
//            } else if (currentIndex == 1) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                //设置备注信息
//                int startWorkTime = data.getIntExtra(RemarksActivity.STRAT_TIME, 0);
//                int endWorkTime = data.getIntExtra(RemarksActivity.END_TIME, 0);
//                allFragment.setRemarkDesc(imageItems, remark);
//            } else if (currentIndex == 2) { //借支
//                BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                //设置备注信息
//                borrowFragment.setRemarkDesc(remark, imageItems);
//            } else if (currentIndex == 3) { //结算
//                WagesSettlementFragment wageragment = (WagesSettlementFragment) fragment;
//                //设置备注信息
//                wageragment.setRemarkDesc(remark, imageItems);
//            }
//        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
//
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (fragment instanceof HourWorkFragment) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                hourFragment.successAccountClick();
//
//            }
//
//        } else if (resultCode == Constance.RESULTWORKERS) {//添加项目回调
//            Project project = (Project) data.getSerializableExtra(BEAN_CONSTANCE);
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (fragment == null || !fragment.isAdded()) {
//                return;
//            }
//            List<Project> list = fragment.projectList;
//            if (list == null) {
//                list = new ArrayList<>();
//            }
//            int size = list.size();
//            for (int i = 0; i < size; i++) { //判断项目列表中是否已有次项目 如果有 则删除 重新添加
//                if (list.get(i).getPid() == project.getPid()) {
//                    list.remove(i);
//                    break;
//                }
//            }
//            if (fragment.addProject != null) { //清空弹出的popWindow  下次读取的时候就会将新添加的项目  显示在WheelView中
//                fragment.addProject.dismiss();
//                fragment.addProject = null;
//            }
//            list.add(0, project);
//            if (fragment instanceof HourWorkFragment) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                //设置备注信息
//                if (!TextUtils.isEmpty(project.getPro_name())) {
//                    hourFragment.setProInfo(project.getPid(), project.getPro_name());
//                }
//                hourFragment.clearProjectDialog();
//            } else if (fragment instanceof AllWorkFragment) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                if (!TextUtils.isEmpty(project.getPro_name())) {
//                    allFragment.setProInfo(project.getPid(), project.getPro_name());
//                }
////                allFragment.clearProjectDialog();
//            } else if (fragment instanceof BorrowWorkFragment) { //借支
//                BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                if (!TextUtils.isEmpty(project.getPro_name())) {
//                    borrowFragment.setProInfo(project.getPid(), project.getPro_name());
//                }
//                borrowFragment.clearProjectDialog();
//            } else if (fragment instanceof WagesSettlementFragment) { //结算
//                WagesSettlementFragment wageFragment = (WagesSettlementFragment) fragment;
//                if (!TextUtils.isEmpty(project.getPro_name())) {
//                    wageFragment.setProInfo(project.getPid(), project.getPro_name());
//                }
//                wageFragment.clearProjectDialog();
//            }
//        } else if (resultCode == Constance.EDITOR_PROJECT_SUCCESS) {//编辑项目项目回调
//            Project project = (Project) data.getSerializableExtra(BEAN_CONSTANCE);
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (fragment == null || !fragment.isAdded()) {
//                return;
//            }
//            if (fragment instanceof HourWorkFragment) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                //设置备注信息
//                hourFragment.setProInfo(project.getPid(), project.getPro_name());
//                hourFragment.clearProjectDialog();
//            } else if (fragment instanceof AllWorkFragment) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                allFragment.setProInfo(project.getPid(), project.getPro_name());
////                allFragment.clearProjectDialog();
//            } else if (fragment instanceof BorrowWorkFragment) { //借支
//                BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                borrowFragment.setProInfo(project.getPid(), project.getPro_name());
//                borrowFragment.clearProjectDialog();
//            } else if (fragment instanceof WagesSettlementFragment) { //结算
//                WagesSettlementFragment wageFragment = (WagesSettlementFragment) fragment;
//                wageFragment.setProInfo(project.getPid(), project.getPro_name());
////                }
//            }
//        } else if (requestCode == Constance.REQUESTCODE_ALLWORKCOMPANT && resultCode == Constance.RESULTCODE_ALLWORKCOMPANT) {//包工填写数量回调
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (currentIndex == 1) { //包工
//                AllAccountFragment allWorkFragment = (AllAccountFragment) fragment;
//                String values = data.getStringExtra(Constance.CONTEXT);
//                String company = data.getStringExtra(Constance.COMPANY);
//                if (!TextUtils.isEmpty(values)) {
//                    if (values.endsWith(".")) {
//                        allWorkFragment.setCount(values.replace(".", ""), company);
//                    } else {
//                        allWorkFragment.setCount(Utils.m2(Double.parseDouble(values)), company);
//                    }
//                } else {
//                    allWorkFragment.setCount(values, company);
//                }
//            }
//        } else if (requestCode == Constance.REQUEST) {//确认记工
//            LUtils.e("-------------确认记工--");
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (currentIndex == 0) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//            } else if (currentIndex == 1) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
////                allFragment.getUnPaySalaryList("");
////            } else if (currentIndex == 2) { //借支
//                BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                borrowFragment.getUnPaySalaryList("");
//            } else if (currentIndex == 3) { //结算
//                WagesSettlementFragment wageFragment = (WagesSettlementFragment) fragment;
//                wageFragment.getUnPaySalaryList("");
//            }
//            if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
//                //创建成功班组回调需要回首页去聊天界面
//                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, data);
//                finish();
//            }
//
//        } else if (resultCode == Constance.SELECTE_PROJECT) {//确认记工
//            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (currentIndex == 0) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                hourFragment.setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
//            } else if (currentIndex == 1) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                allFragment.setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
//            } else if (currentIndex == 2) { //借支
//                BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
//                borrowFragment.setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
//            } else if (currentIndex == 3) { //结算
//                WagesSettlementFragment wageFragment = (WagesSettlementFragment) fragment;
//                wageFragment.setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
//            }
//        }
//        if (resultCode == Constance.SALARYMODESETTING_RESULTCODE) {//设置薪资模板
//            AccountFragment fragment = mFragments.get(currentIndex);
//            if (currentIndex == 0) { //点工
//                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
//                Salary tplMode = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                hourFragment.setMode(tplMode);
//            } else if (currentIndex == 1) { //包工
//                AllWorkFragment allFragment = (AllWorkFragment) fragment;
//                Salary tplMode = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                allFragment.setMode(tplMode);
//            }
//        }
//
//    }
//
//    @Override
//    public void onBackPressed() {
//        accountAct();
//        super.onBackPressed();
//    }
//
//    public void onFinish(View view) {
//        accountAct();
//        finish();
//    }
//
//    public void accountAct() {
//
//        if (currentIndex == 0) { //点工
//            HourWorkFragment hourFragment = (HourWorkFragment) mFragments.get(0);
//            if (!TextUtils.isEmpty(hourFragment.record)) {
//                hourFragment.finishAct(hourFragment.record);
//            }
//            //设置备注信息
//        } else if (currentIndex == 3) { //借支
//            WagesSettlementFragment wagesSettlementFragment = (WagesSettlementFragment) mFragments.get(3);
//            if (wagesSettlementFragment.isFulsh) {
//                wagesSettlementFragment.finishAct();
//            }
//
////        } else if (currentIndex == 1) { //包工
////            AllWorkFragment allFragment = (AllWorkFragment) mFragments.get(1);
////        } else if (currentIndex == 2) { //借支
////            BorrowWorkFragment borrowFragment = (BorrowWorkFragment) mFragments.get(2);
////        }
//        }
//    }
//}