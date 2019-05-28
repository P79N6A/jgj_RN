package com.jizhi.jlongg.account;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.dialog.NewAccountFlowGuideDialog;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.ArrayList;
import java.util.List;


/**
 * 功能:记账父Activity
 * 3.4.4新记单笔首页
 * 时间:2019/01/02 10:55
 * 作者:hcs
 */

public class NewAccountActivity extends BaseActivity {
    private ViewPager mViewPager;
    /* Fragment 集合 */
    private List<AccountFragment> mFragments;
    //点工，包工，借支
    private RadioButton btn_hour, btn_all_account, btn_all_work, btn_borrow, btn_wages_settlement;
    //ViewPager下标
    protected int currentIndex;
    protected boolean isMsgAccount;
    protected String roleType, proName;
    protected int msgPid;
    private AgencyGroupUser agency_group_user;
    //是否隐藏点工
    private boolean isGoneHour;
    //创建者uid
    protected String create_group_uid;

    public AgencyGroupUser getAgency_group_user() {
        return agency_group_user;
    }

    public String getCreate_group_uid() {
        return create_group_uid;
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, boolean isGoneHour) {
        Intent intent = new Intent(context, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
        intent.putExtra(Constance.BEAN_BOOLEAN, isGoneHour);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param date    日期
     */
    public static void actionStart(Activity context, String date, boolean isGoneHour) {
        Intent intent = new Intent(context, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
        intent.putExtra(Constance.BEAN_BOOLEAN, isGoneHour);
        intent.putExtra(Constance.DATE, date);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param date    日期
     */
    public static void actionStart(Activity context, String date) {
        Intent intent = new Intent(context, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
        intent.putExtra(Constance.DATE, date);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 启动当前Activity
     * 未结工资跳转 ，tab指向结算
     *
     * @param context
     */
    public static void actionStart(Activity context, int page, PersonBean personBean, String balance_amount, boolean isGoneHour) {
        Intent intent = new Intent(context, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(context.getApplicationContext()));
        intent.putExtra(Constance.BEAN_INT, page);
        intent.putExtra(Constance.BEAN_CONSTANCE, personBean);
        intent.putExtra(Constance.BEAN_BOOLEAN, isGoneHour);
        intent.putExtra(Constance.BEAN_STRING, balance_amount);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account);
        getIntentData();
        initFragment();
        initView();
        initData();


    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    /**
     * 加载记工流水动画
     */
    private void loadAccountFlowGuide() {
        final LinearLayout main = findViewById(R.id.main);
        String key = "show_flow_guide_account" + AppUtils.getVersionName(getApplicationContext());
        // 是否显示记工流水动画
        boolean isShow = (boolean) SPUtils.get(getApplicationContext(), key, false, Constance.JLONGG);
        if (!isShow) {
            main.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListe.tner可能会被多次触发，因此在得到了高度之后，要
                    if (main.getHeight() == 0) {
                        return;
                    }
                    NewAccountFlowGuideDialog dialog = new NewAccountFlowGuideDialog(NewAccountActivity.this);
                    dialog.show();
                    if (Build.VERSION.SDK_INT < 16) {
                        main.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        main.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            SPUtils.put(getApplicationContext(), key, true, Constance.JLONGG); // 存放Token信息
        }
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        //是否是点工
        isGoneHour = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        isMsgAccount = getIntent().getBooleanExtra(Constance.ISMSGBILL, false);
        roleType = getIntent().getStringExtra(Constance.enum_parameter.ROLETYPE.toString());

    }

    /**
     * 初始化fragment
     */
    public void initFragment() {
        mFragments = new ArrayList<>();
        if (!isGoneHour) {
            //点工，包工记工天,包工记账，
            mFragments.add(new HourWorkFragment());
            mFragments.add(new AllWorkFragment());
            mFragments.add(new AllAccountFragments());
            findViewById(R.id.btn_hour).setVisibility(View.VISIBLE);
            findViewById(R.id.btn_all_account).setVisibility(View.VISIBLE);
            findViewById(R.id.btn_all_work).setVisibility(View.VISIBLE);
            findViewById(R.id.btn_borrow).setVisibility(View.GONE);
            findViewById(R.id.btn_wages_settlement).setVisibility(View.GONE);
            ((RadioButton) findViewById(R.id.btn_hour)).setChecked(true);
        } else {
            //借支结算
            mFragments.add(new BorrowWorkFragment());
            mFragments.add(new WagesSettlementFragment());
            findViewById(R.id.btn_hour).setVisibility(View.GONE);
            findViewById(R.id.btn_all_account).setVisibility(View.GONE);
            findViewById(R.id.btn_all_work).setVisibility(View.GONE);
            findViewById(R.id.btn_borrow).setVisibility(View.VISIBLE);
            findViewById(R.id.btn_wages_settlement).setVisibility(View.VISIBLE);
            ((RadioButton) findViewById(R.id.btn_borrow)).setChecked(true);

        }

    }

    /**
     * 初始化数据数据
     */
    public void initData() {
        //设置默认选中tab
        boolean isWorker = roleType.equals(Constance.ROLETYPE_WORKER) ? true : false;
        String accountType = (String) SPUtils.get(NewAccountActivity.this, "account_type", AccountUtil.HOUR_WORKER, isWorker ? Constance.ACCOUNT_WORKER_HISTORT : Constance.ACCOUNT_FORMAN_HISTORT);
        if (!isGoneHour) {
            if (accountType.equals(AccountUtil.HOUR_WORKER)) {
                //点工
                btn_hour.setChecked(true);
                currentIndex = 0;
            } else if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK)) {
                //包工记工天
                btn_all_work.setChecked(true);
                currentIndex = 1;
            } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
                //包工记账
                btn_all_account.setChecked(true);
                currentIndex = 2;
            }
            mViewPager.setCurrentItem(currentIndex);
        } else {
            currentIndex = getIntent().getIntExtra(Constance.BEAN_INT, 0);
            if (currentIndex != 0) {
                btn_wages_settlement.setChecked(true);
            }
        }
        mViewPager.setCurrentItem(currentIndex);
        if (isMsgAccount) {
            //班组内记账
            proName = getIntent().getStringExtra(Constance.PRONAME);
            //带班长信息
            agency_group_user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser");
            create_group_uid = getIntent().getStringExtra("create_group_uid");
            LUtils.e("-------aaaaaaaaa--22--create_group_uid---------" + create_group_uid);
            if (null != agency_group_user && !TextUtils.isEmpty(getIntent().getStringExtra(Constance.GROUP_ID))) {
                agency_group_user.setGroup_id(getIntent().getStringExtra(Constance.GROUP_ID));
            }
            String pid = getIntent().getStringExtra(Constance.PID);
            msgPid = TextUtils.isEmpty(pid) ? 0 : Integer.parseInt(pid);
        }
        if (!isGoneHour) {
            loadAccountFlowGuide();
        }
        //是否完善姓名
        if (!IsSupplementary.isFillRealNameCallBackListener(NewAccountActivity.this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                //完善姓名成功
                Utils.sendBroadCastToUpdateInfo(NewAccountActivity.this);
            }
        })) ;
    }

    /**
     * 初始化view
     */
    public void initView() {
        mViewPager = findViewById(R.id.viewPager);
        mViewPager.setOffscreenPageLimit(3);
        mViewPager.setAdapter(new AccountViewPageAdapter(getSupportFragmentManager(), mFragments));
        mViewPager.setCurrentItem(currentIndex);
        btn_hour = findViewById(R.id.btn_hour);
        btn_all_account = findViewById(R.id.btn_all_account);
        btn_all_work = findViewById(R.id.btn_all_work);
        btn_borrow = findViewById(R.id.btn_borrow);
        btn_wages_settlement = findViewById(R.id.btn_wages_settlement);
        RadioGroup radioGroup = findViewById(R.id.radioGroup);
        mViewPager.addOnPageChangeListener(onPageChangeListener);
        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.btn_hour:
                        cancelFlashAnim();
                        currentIndex = 0;
                        break;
                    case R.id.btn_all_work:
                        cancelFlashAnim();
                        currentIndex = 1;
                        break;
                    case R.id.btn_all_account:
                        cancelFlashAnim();
                        currentIndex = 2;
                        break;
                    case R.id.btn_borrow:
                        cancelFlashAnim();
                        currentIndex = 0;
                        break;
                    case R.id.btn_wages_settlement:
                        cancelFlashAnim();
                        currentIndex = 1;
                        break;

                }
                mViewPager.setCurrentItem(currentIndex);
            }
        });
    }

    /**
     * 4.0.2
     * 取消各页面的闪动动画
     */
    private void cancelFlashAnim() {
        AccountFragment fragment = mFragments.get(currentIndex);
        if (fragment instanceof HourWorkFragment) {
            ((HourWorkFragment) fragment).FlashingCancel();
        } else if (fragment instanceof AllWorkFragment) {
            ((AllWorkFragment) fragment).FlashingCancel();
        } else if (fragment instanceof AllAccountFragments) {
            ((AllAccountFragments) fragment).FlashingCancel();
        } else if (fragment instanceof BorrowWorkFragment) {
            ((BorrowWorkFragment) fragment).FlashingCancel();
        } else if (fragment instanceof WagesSettlementFragment) {
            ((WagesSettlementFragment) fragment).FlashingCancel();
        }
    }

    /**
     * viewpager底部滚动监听
     */
    ViewPager.OnPageChangeListener onPageChangeListener = new ViewPager.OnPageChangeListener() {
        @Override
        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

        }

        @Override
        public void onPageSelected(int position) {
            currentIndex = position;
            switch (position) {
                case 0:
                    if (!isGoneHour) {
                        btn_hour.setChecked(true);
                    } else {
                        btn_borrow.setChecked(true);
                    }
                    break;
                case 1:
                    if (!isGoneHour) {
                        btn_all_work.setChecked(true);
                    } else {
                        btn_wages_settlement.setChecked(true);
                    }
                    break;
                case 2:
                    btn_all_account.setChecked(true);
                    break;
            }
        }

        @Override
        public void onPageScrollStateChanged(int state) {

        }
    };

    /**
     * 初始化结算信息
     */
    public void initSettlement() {
        PersonBean personBean = (PersonBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (null != personBean && personBean.getUid() != 0) {
            //设置工人信息
            AccountFragment fragment = mFragments.get(currentIndex);
            WagesSettlementFragment wageragment = (WagesSettlementFragment) fragment;
            wageragment.setPersonName(personBean.getName());
            wageragment.uid = personBean.getUid();
            wageragment.personBean = personBean;
            wageragment.getUnPaySalaryList(personBean.getUid() + "", true);
            if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                wageragment.LastRecordInfo();
            }
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SUCCESS) {//选择工人回调
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment == null || !fragment.isAdded()) {
                return;
            }
            int choose_member_type = data.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, 0);
            if (choose_member_type == MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON) {
                ArrayList<PersonBean> selecteList = (ArrayList<PersonBean>) data.getSerializableExtra(Constance.BEAN_ARRAY);
                if (null != selecteList && selecteList.size() > 0 && fragment instanceof BorrowWorkFragment) { //借支
                    BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
                    StringBuffer sb = new StringBuffer();
                    if (selecteList.size() == 0) {
                        (borrowFragment).successAccountClick();

                    } else if (selecteList.size() == 1) {
                        sb.append(selecteList.get(0).getName());
                        borrowFragment.setPersonName(sb.toString());

                    } else if (selecteList.size() == 2) {
                        sb.append(selecteList.get(0).getName() + "、" + selecteList.get(1).getName() + "");
                        borrowFragment.setPersonName(sb.toString());
                    } else if (selecteList.size() > 2) {
                        sb.append(selecteList.get(0).getName() + "、" + selecteList.get(1).getName() + "等" + selecteList.size() + "人");
                        borrowFragment.setPersonName(sb.toString());
                    }
                    borrowFragment.selecteLis = selecteList;
                }
                return;
            }
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            String deleteUid = data.getStringExtra(Constance.DELETE_UID);
            LUtils.e("---------personBean-----33-----" + deleteUid);
            if (!TextUtils.isEmpty(deleteUid)) {
                for (AccountFragment f : mFragments) {
                    if (f == null || !f.isAdded()) {
                        continue;
                    }
                    if (f instanceof HourWorkFragment) {
                        ((HourWorkFragment) f).checkPerson(deleteUid);
                    } else if (f instanceof AllAccountFragments) {
                        ((AllAccountFragments) f).checkPerson(deleteUid);
                    } else if (f instanceof AllWorkFragment) {
                        ((AllWorkFragment) f).checkPerson(deleteUid);
                    } else if (f instanceof BorrowWorkFragment) {
//                        ((BorrowWorkFragment) f).successAccountClick();
                    } else if (f instanceof WagesSettlementFragment) {
//                        ((WagesSettlementFragment) f).successAccountClick();
                    }
                }
            }

            if (null == personBean || personBean.getUid() == 0) {
                return;
            } else {
                //设置工人信息
                if (fragment instanceof HourWorkFragment) {//点工
                    //点工需要根据uid去线上查询模版
                    ((HourWorkFragment) fragment).getWorkTPlByUid(personBean, false);
                } else if (fragment instanceof AllAccountFragments) { //包工记账

                    ((AllAccountFragments) fragment).setPersonInfo(personBean);
                } else if (fragment instanceof AllWorkFragment) { //包工记工天
                    //包工记工天需要根据uid去线上查询模版
                    ((AllWorkFragment) fragment).getWorkTPlByUid(personBean, false);
                } else if (fragment instanceof BorrowWorkFragment) { //借支
                    BorrowWorkFragment borrowFragment = (BorrowWorkFragment) fragment;
                    borrowFragment.setPersonName(personBean.getName());
                    borrowFragment.uid = personBean.getUid();
                    borrowFragment.personBean = personBean;
                    if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                        borrowFragment.LastRecordInfo();
                    }
                } else if (fragment instanceof WagesSettlementFragment) {
                    WagesSettlementFragment wageragment = (WagesSettlementFragment) fragment;
                    wageragment.setPersonName(personBean.getName());
                    wageragment.uid = personBean.getUid();
                    wageragment.personBean = personBean;
                    wageragment.getUnPaySalaryList(personBean.getUid() + "", true);
                    if (personBean.getUid() != -1 && !getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                        wageragment.LastRecordInfo();
                    }
                }
            }


        } else if (resultCode == Constance.REMARK_SUCCESS) { //备注返回
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment == null || !fragment.isAdded()) {
                return;
            }
            String remark = data.getStringExtra(RemarksActivity.REMARK_DESC);
            //设置备注信息
            List<ImageItem> imageItems = (List<ImageItem>) data.getSerializableExtra(RemarksActivity.PHOTO_DATA);
            if (fragment instanceof HourWorkFragment) { //点工
                ((HourWorkFragment) fragment).setRemarkDesc(remark, imageItems);
            } else if (fragment instanceof AllAccountFragments) { //包工记账
                int startWorkTime = data.getIntExtra(RemarksActivity.STRAT_TIME, 0);
                int endWorkTime = data.getIntExtra(RemarksActivity.END_TIME, 0);
                ((AllAccountFragments) fragment).setRemarkDesc(imageItems, startWorkTime, endWorkTime, remark);
            } else if (fragment instanceof AllWorkFragment) { //包工记工天
                ((AllWorkFragment) fragment).setRemarkDesc(imageItems, remark);
            } else if (fragment instanceof BorrowWorkFragment) { //借支
                ((BorrowWorkFragment) fragment).setRemarkDesc(remark, imageItems);
            } else if (fragment instanceof WagesSettlementFragment) { //结算
                ((WagesSettlementFragment) fragment).setRemarkDesc(remark, imageItems);
            }
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment instanceof HourWorkFragment) { //点工
                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
                hourFragment.successAccountClick();
            }
        } else if (requestCode == Constance.REQUESTCODE_ADD_SUB_PRONAME && resultCode == Constance.RESULTCODE_ADD_SUB_PRONAME) {//包工填写分项名称回调
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment == null || !fragment.isAdded()) {
                return;
            }
            if (fragment instanceof AllAccountFragments) { //包工

                AccountAllWorkBean accountAllWorkBean = (AccountAllWorkBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                int position = data.getIntExtra(Constance.BEAN_INT, -1);
                if (null != accountAllWorkBean && position != -1) {
                    AllAccountFragments allAccountFragments = (AllAccountFragments) fragment;
                    allAccountFragments.setSubProName(accountAllWorkBean, position);
                }
            }
        } else if (requestCode == Constance.REQUEST) {//确认记工
            AccountFragment fragment = mFragments.get(currentIndex);
            //点工，包工记工天不需要操作
            if (fragment instanceof AllAccountFragments) { //包工记账
            } else if (fragment instanceof BorrowWorkFragment) { //借支
            } else if (fragment instanceof WagesSettlementFragment) { //结算
                LUtils.e("---------确认记工---11-------");

                WagesSettlementFragment wageFragment = (WagesSettlementFragment) fragment;
                wageFragment.getUnPaySalaryList("", false);
            }
            if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
                //创建成功班组回调需要回首页去聊天界面
                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, data);
                finish();
            }

        } else if (resultCode == Constance.SELECTE_PROJECT) {
            if (null == data) {
                AccountFragment fragment = mFragments.get(currentIndex);
                if (fragment instanceof HourWorkFragment) { //点工
                    ((HourWorkFragment) fragment).cleraProInfo();
                } else if (fragment instanceof AllAccountFragments) { //包工记账
                } else if (fragment instanceof AllWorkFragment) { //包工记工天
                    ((AllWorkFragment) fragment).cleraProInfo();
                } else if (fragment instanceof BorrowWorkFragment) { //借支
                    ((BorrowWorkFragment) fragment).cleraProInfo();
                } else if (fragment instanceof WagesSettlementFragment) { //结算
                    ((WagesSettlementFragment) fragment).cleraProInfo();
                }
                return;
            }
            //项目名字回调
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment instanceof HourWorkFragment) { //点工
                ((HourWorkFragment) fragment).setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
            } else if (fragment instanceof AllAccountFragments) { //包工记账
                ((AllAccountFragments) fragment).setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
            } else if (fragment instanceof AllWorkFragment) { //包工记工天
                ((AllWorkFragment) fragment).setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
            } else if (fragment instanceof BorrowWorkFragment) { //借支
                ((BorrowWorkFragment) fragment).setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
            } else if (fragment instanceof WagesSettlementFragment) { //结算
                ((WagesSettlementFragment) fragment).setProInfo(null == project ? 0 : Integer.parseInt(project.getPro_id()), null == project ? "" : project.getPro_name());
            }
        }
        if (resultCode == Constance.SALARYMODESETTING_RESULTCODE) {//设置薪资模板
            AccountFragment fragment = mFragments.get(currentIndex);
            if (fragment instanceof HourWorkFragment) { //点工

                HourWorkFragment hourFragment = (HourWorkFragment) fragment;
                Salary tplMode = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                hourFragment.setMode(tplMode);
            } else if (fragment instanceof AllWorkFragment) { //包工记工天
                AllWorkFragment allFragment = (AllWorkFragment) fragment;
                Salary tplMode = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                allFragment.setMode(tplMode);
            }
        }

    }

    @Override
    public void onBackPressed() {
        accountAct();
        super.onBackPressed();
    }

    public void onFinish(View view) {
        accountAct();
        finish();
    }

    public void accountAct() {
        //防止下标越界
        if (null == mFragments || currentIndex > mFragments.size() - 1) {
            return;
        }
        AccountFragment fragment = mFragments.get(currentIndex);
        if (fragment instanceof HourWorkFragment) { //点工
            HourWorkFragment hourFragment = (HourWorkFragment) mFragments.get(currentIndex);
            if (!TextUtils.isEmpty(hourFragment.record)) {
                hourFragment.finishAct(hourFragment.record);
            }
        } else if (fragment instanceof WagesSettlementFragment) { //结算
            WagesSettlementFragment wagesSettlementFragment = (WagesSettlementFragment) mFragments.get(currentIndex);
            if (wagesSettlementFragment.isFulsh) {
                wagesSettlementFragment.finishAct();
            }
        }
    }
}