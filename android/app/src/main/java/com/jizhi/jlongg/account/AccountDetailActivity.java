package com.jizhi.jlongg.account;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.AccountDetailAdapter;
import com.jizhi.jlongg.main.adpter.CheckHistoryImageAdapter;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.AccountData;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapGridview;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;
import java.util.Set;


/**
 * 功能:记账详情
 * 时间:2017/9/25 10:27
 * 作者:hcs
 */

public class AccountDetailActivity extends BaseActivity {
    private AccountDetailActivity mActivity;
    //记账类型，角色
    private String account_type, role_type;
    //记账id
    private int account_id;
    //列表数据
    protected List<AccountBean> itemData;
    //记账适配器
    private AccountDetailAdapter accountDetailAdapter;
    private ListView listView;
    //记账数据
    private WorkDetail workDetail;
    //底部food
    private View bottomView;
    private boolean isPush;
    private boolean isExitCountOrPrice;
    //底部food
    private View headerView;
    private int screenHeight;
    private AgencyGroupUser agencyGroupUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getIntentData();
        setContentView(R.layout.activity_account_detail);
        initView();
        initData();
        getDetailInfo();
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {

        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            //推送跳转进来的
//            LUtils.e("------------------bundle--not-null----------" + new Gson().toJson(bun));
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("account_id")) {
                    account_id = Integer.parseInt(bun.getString(key));
                    isPush = true;
                } else if (!TextUtils.isEmpty(key) && key.equals("role_type")) {
                    role_type = bun.getString(key);
                    isPush = true;
                } else if (!TextUtils.isEmpty(key) && key.equals("account_type")) {
                    account_type = bun.getString(key);
                    isPush = true;
                }
            }
        }
        if (!isPush) {//页面跳转进来的
            //记账类型
            account_type = getIntent().getStringExtra(Constance.BEAN_STRING);
            //记账id
            account_id = getIntent().getIntExtra(Constance.BEAN_INT, 0);
            role_type = getIntent().getStringExtra(Constance.ROLE);
        }
        agencyGroupUser = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     * @param account_type 记账类型
     * @param acountId     记账id
     * @param roleType     角色信息
     * @param canEditor    true表示能编辑和删除记账信息
     */
    public static void actionStart(Activity context, String account_type, int acountId, String roleType, boolean canEditor) {
        Intent intent = new Intent(context, AccountDetailActivity.class);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_INT, acountId);
        intent.putExtra(Constance.ROLE, roleType);
        intent.putExtra(Constance.BEAN_BOOLEAN, canEditor);
        context.startActivityForResult(intent, Constance.CONST_REQUESTCODE);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, String account_type, int acount_id, String role_type, AgencyGroupUser agencyGroupUser) {
        Intent intent = new Intent(context, AccountDetailActivity.class);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_INT, acount_id);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_CONSTANCE, agencyGroupUser);
        context.startActivityForResult(intent, Constance.CONST_REQUESTCODE);
    }

    /**
     * initView
     */
    public void initView() {
        mActivity = AccountDetailActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "记账");
        //高度等于屏幕总长度-状态栏-标题栏-减去距离顶部，在将去距离底部
        screenHeight = DensityUtils.getScreenHeight(mActivity) - DensityUtils.getStatusHeight(mActivity) - DensityUtils.dp2px(mActivity, 50 + 30 + 15);

        headerView = getLayoutInflater().inflate(R.layout.layout_account_detail_head, null);
        TextView tv_work = headerView.findViewById(R.id.tv_work_type);
        listView = findViewById(R.id.listView);
        headerView.findViewById(R.id.rea_contractor_type).setVisibility(account_type.equals(AccountUtil.CONSTRACTOR) ? View.VISIBLE : View.GONE);

        if (account_type.equals(AccountUtil.HOUR_WORKER)) {  //点工
            tv_work.setText("点工工钱");
            SetTitleName.setTitle(findViewById(R.id.title), "点工");
            itemData = AccountData.getAccountDetailHour(true);
        } else if (account_type.equals(AccountUtil.CONSTRACTOR)) {  //包工记账
            tv_work.setText("包工工钱");
            SetTitleName.setTitle(findViewById(R.id.title), "包工记账");
            itemData = AccountData.getAccountDetailAll(true);
        } else if (account_type.equals(AccountUtil.BORROWING)) {  //借支
            tv_work.setText("借支金额");
            SetTitleName.setTitle(findViewById(R.id.title), "借支");
            itemData = AccountData.getAccountDetailBorrow();
        } else if (account_type.equals(AccountUtil.SALARY_BALANCE)) {//结算
            tv_work.setText("本次结算金额");
            SetTitleName.setTitle(findViewById(R.id.title), "结算");
            itemData = AccountData.getAccountDetailWages(role_type);
        } else if (account_type.equals(AccountUtil.CONSTRACTOR_CHECK)) {//包工计考勤
            headerView.findViewById(R.id.rea_amounts).setVisibility(View.GONE);
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.all_work_hour));
            itemData = AccountData.getAccountDetailHour(false);
        }
        findViewById(R.id.btn_change).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
                    role_type = Constance.ROLETYPE_FM;
                }
                if (account_type.equals(AccountUtil.SALARY_BALANCE)) {
                    //结算
                    AccountWagesEditActivty.actionStart(mActivity, workDetail, account_type, account_id, role_type, false, agencyGroupUser);
                } else if (account_type.equals(AccountUtil.CONSTRACTOR)) {
                    //包工
                    AccountAllEditActivty.actionStart(mActivity, workDetail, account_type, account_id, role_type, false, agencyGroupUser);
                } else {
                    //点工
                    AccountEditActivity.actionStart(mActivity, workDetail, account_type, account_id, role_type, false, agencyGroupUser);
                }
            }
        });
        findViewById(R.id.btn_del).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(mActivity, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        delsetmount();
                    }
                }, -1, getString(R.string.delete_account_tips));
                dialogOnlyTitle.setConfirmBtnName(getString(R.string.confirm_delete));
                dialogOnlyTitle.show();
            }
        });
        if (!getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, true)) {
            findViewById(R.id.lin_bottom).setVisibility(View.GONE);
        }
    }

    /**
     * initData
     */
    public void initData() {
        listView.addHeaderView(headerView);
        accountDetailAdapter = new AccountDetailAdapter(mActivity, itemData, account_type);
        listView.setAdapter(accountDetailAdapter);
    }

    /**
     * 查询记账信息详情
     */

    private void getDetailInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("record_id", account_id + "");
        params.addBodyParameter("accounts_type", account_type + "");
        if (agencyGroupUser != null) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id() + "");
        }
//        params.addBodyParameter("role", role_type);
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.WORKDETAIL, params, new RequestCallBackExpand<String>() {
//            @Override
//            public void onSuccess(ResponseInfo<String> responseInfo) {
//                try {
//                    CommonJson<WorkDetail> status = CommonJson.fromJson(responseInfo.result, WorkDetail.class);
//
//                    if (status.getMsg().equals(Constance.SUCCES_S)) {
//                        if (status.getResult() != null && !TextUtils.isEmpty(status.getResult().getDate())) {
//                            workDetail = status.getResult();
//                            setData(workDetail);
//                        } else {
//                            CommonMethod.makeNoticeShort(mActivity, "该记账已经被删除", CommonMethod.ERROR);
//                            mActivity.finish();
//                        }
//                    } else {
//                        DataUtil.showErrOrMsg(mActivity, status.getCode(), status.getMsg());
//                        finish();
//                    }
//                } catch (Exception e) {
//                    finish();
//                } finally {
//                    closeDialog();
//                }
//            }
//
//            @Override
//            public void onFailure(HttpException exception, String errormsg) {
//                super.onFailure(exception, errormsg);
//                finish();
//            }
//        });

        CommonHttpRequest.commonRequest(mActivity, NetWorkRequest.WORKDETAIL, WorkDetail.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                workDetail = (WorkDetail) object;
                if (null == workDetail) {
                    return;
                }
                setData(workDetail);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                CommonMethod.makeNoticeShort(mActivity, errormsg, CommonMethod.ERROR);
                mActivity.finish();
            }
        });
    }

    /**
     * 设置每一行的显示value
     *
     * @param bean
     */
    public void setData(final WorkDetail bean) {
        if (!account_type.equals(AccountUtil.CONSTRACTOR_CHECK)) {
            //记账金额
            if (account_type.equals(AccountUtil.BORROWING) || account_type.equals(AccountUtil.SALARY_BALANCE)) {
                ((TextView) headerView.findViewById(R.id.tv_work_price)).setText(bean.getAmounts() + "");
                ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextSize(30);
                ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextColor(ContextCompat.getColor(mActivity, R.color.green_83c56c));
            } else {
                if (account_type.equals(AccountUtil.CONSTRACTOR)) {
                    ((TextView) headerView.findViewById(R.id.tv_work_price)).setText(bean.getAmounts() + "");
                    ((TextView) headerView.findViewById(R.id.tv_contractor_type)).setText(bean.getContractor_type() == 1 ? "记工类型：承包" : "记工类型：分包");
                    ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextColor(ContextCompat.getColor(mActivity, bean.getContractor_type() == 1 && role_type.equals(Constance.ROLETYPE_FM) ? R.color.green : R.color.color_eb4e4e));


                } else {
                    if (bean.getSet_tpl() == null || bean.getSet_tpl().getS_tpl() == 0) {
                        ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextSize(15);
                        ((TextView) headerView.findViewById(R.id.tv_work_price)).setText("未设置工资标准");
                        ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextColor(ContextCompat.getColor(mActivity, R.color.color_999999));
                    } else {
                        ((TextView) headerView.findViewById(R.id.tv_work_price)).setText(bean.getAmounts() + "");
                        ((TextView) headerView.findViewById(R.id.tv_work_price)).setTextColor(ContextCompat.getColor(mActivity, R.color.color_eb4e4e));
                    }
                }

            }
        }
        //时间，班组长，工人
        ((TextView) headerView.findViewById(R.id.tv_work_date)).setText(bean.getDate());
        ((TextView) headerView.findViewById(R.id.tv_fm)).setText("班组长：" + bean.getForeman_name());
        ((TextView) headerView.findViewById(R.id.tv_work)).setText("工人：" + bean.getWorker_name());
        if (account_type.equals(AccountUtil.CONSTRACTOR)) {
            ((TextView) headerView.findViewById(R.id.tv_fm)).setText(bean.getContractor_type() == 1 && role_type.equals(Constance.ROLETYPE_FM) ? "承包对象：" + bean.getForeman_name() : "班组长：" + bean.getForeman_name());
        }

        if ((account_type.equals(AccountUtil.CONSTRACTOR)) && (TextUtils.isEmpty(workDetail.getP_s_time()) || TextUtils.isEmpty(workDetail.getP_e_time()))) {
            itemData.clear();
            itemData = AccountData.getAccountDetailAll(false);
            accountDetailAdapter.updateList(itemData);
        }
        for (int i = 0; i < itemData.size(); i++) {
            if (itemData.get(i).getItem_type().equals(AccountBean.SELECTED_PROJECT)) {//所在项目-相同部分
                itemData.get(i).setRight_value(bean.getProname());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WORK_TIME)) {//上班时间-点工
                if (bean.getManhour() == 0) {
                    itemData.get(i).setCompany("休息");
                } else {
                    itemData.get(i).setCompany("小时");
                    if (null != bean.getSet_tpl()) {
                        if (bean.getManhour() == bean.getSet_tpl().getW_h_tpl()) {
                            itemData.get(i).setOneWork(1);
                        } else if (bean.getManhour() == (bean.getSet_tpl().getW_h_tpl() / 2)) {
                            itemData.get(i).setOneWork(2);
                        } else {
                            itemData.get(i).setOneWork(0);
                        }
                    }
                }
                itemData.get(i).setRight_value(Utils.deleteZero(bean.getManhour() + ""));
                itemData.get(i).setWorking_hours(bean.getWorking_hours());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.OVER_TIME)) {//加班时间-点工
                if (bean.getOvertime() == 0) {
                    itemData.get(i).setCompany("无加班");
                } else {
                    itemData.get(i).setCompany("小时");
                    if (null != bean.getSet_tpl()) {
                        if (bean.getOvertime() == bean.getSet_tpl().getO_h_tpl()) {
                            itemData.get(i).setOneWork(1);
                        } else if (bean.getOvertime() == (bean.getSet_tpl().getO_h_tpl() / 2)) {
                            itemData.get(i).setOneWork(2);
                        } else {
                            itemData.get(i).setOneWork(0);
                        }
                    }
                }
                itemData.get(i).setRight_value(Utils.deleteZero(bean.getOvertime() + ""));
                itemData.get(i).setWorking_hours(bean.getOvertime_hours());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SALARY)) {//模版-点工
                //4.0.2显示工资模板方式
                int hour_type = bean.getSet_tpl().getHour_type();
                Salary tplMode = bean.getSet_tpl();
                String salary = "";
                if (hour_type == 1) {//按小时
                    if (tplMode.getW_h_tpl() != 0) {
                        salary = "上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tplMode.getS_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
                    }

                    if (tplMode.getO_s_tpl() != 0) {
                        salary = salary + "\n" + (Utils.m2(tplMode.getO_s_tpl()) + "元/小时(加班)");
                    }
                } else {//按工天
                    if (tplMode.getW_h_tpl() != 0) {
                        salary = "上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tplMode.getO_h_tpl() != 0) {
                        salary = salary + "\n加班" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tplMode.getS_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
                    }
                    if (tplMode.getS_tpl() != 0 && tplMode.getO_h_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tplMode.getS_tpl() / tplMode.getO_h_tpl()) + "元/小时(加班)";
                    }
                }
                itemData.get(i).setRight_value(salary);
//                String w_h_tpl = "上班 " + Utils.deleteZero(bean.getSet_tpl().getW_h_tpl() + "小时算1个工");
//                String o_h_tpl = "加班 " + Utils.deleteZero(bean.getSet_tpl().getO_h_tpl() + "小时算1个工");
//                if (null == bean.getSet_tpl() || bean.getSet_tpl().getS_tpl() == 0) {
//                    itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl);
//                } else {
//                    String s_tpl = "1个工 " + "工资 " + Utils.m2(bean.getSet_tpl().getS_tpl()) + "";
//                    itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl + "\n" + s_tpl);
//                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.UNIT_PRICE)) {//单价-包工
                itemData.get(i).setRight_value(bean.getUnitprice());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.COUNT)) {//数量-包工
                itemData.get(i).setRight_value(bean.getQuantities() + "" + bean.getUnits());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SUBENTRY_NAME)) {//分项名称-包工
                itemData.get(i).setRight_value(bean.getSub_proname() + "");
            } else if (itemData.get(i).getItem_type().equals(AccountBean.P_S_TIME)) {//开工时间-包工
                itemData.get(i).setRight_value(TimesUtils.ChageStrToDate(bean.getP_s_time()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.P_E_TIME)) {//完工时间-包工
                itemData.get(i).setRight_value(TimesUtils.ChageStrToDate(bean.getP_e_time()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WAGE_INCOME_MONEY)) {//本次实收金额-包工
                itemData.get(i).setRight_value(Utils.m2(bean.getPay_amount()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WAGE_SUBSIDY)) {//补贴金额-包工
                itemData.get(i).setRight_value(Utils.m2(bean.getSubsidy_amount()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WAGE_REWARD)) {//奖励金额-包工
                itemData.get(i).setRight_value(Utils.m2(bean.getReward_amount()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WAGE_FINE)) {//罚款金额-包工
                itemData.get(i).setRight_value(Utils.m2(bean.getPenalty_amount()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WAGE_DEL)) {//抹零金额-包工
                itemData.get(i).setRight_value(Utils.m2(bean.getDeduct_amount()));
            }
        }
        //没有添加过底部信息就添加底部信息
        if (null == bottomView) {
            //设置底部内容
            bottomView = getLayoutInflater().inflate(R.layout.layout_account_detail_bottom, null); // 添加底部信息
            listView.addFooterView(bottomView, null, false);
        }

        //设置备注信息
        if (!TextUtils.isEmpty(bean.getNotes_txt())) {
            ((TextView) bottomView.findViewById(R.id.tv_remark)).setText(bean.getNotes_txt());
        } else {
            ((TextView) bottomView.findViewById(R.id.tv_remark)).setText("无");
        }
        if (!TextUtils.isEmpty(bean.getP_s_time()) || !TextUtils.isEmpty(bean.getP_e_time())) {
            ((TextView) bottomView.findViewById(R.id.tv_start_time)).setText(TimesUtils.ChageStrToDate(bean.getP_s_time()));
            ((TextView) bottomView.findViewById(R.id.tv_end_time)).setText(TimesUtils.ChageStrToDate(bean.getP_e_time()));
            findViewById(R.id.lin_time).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.lin_time).setVisibility(View.GONE);
        }
        //设置图片信息
        if (null != bean.getNotes_img()) {
            CheckHistoryImageAdapter squaredImageAdapter = new CheckHistoryImageAdapter(mActivity, bean.getNotes_img());
            WrapGridview ngl_images = (WrapGridview) bottomView.findViewById(R.id.ngl_images);
            ngl_images.setAdapter(squaredImageAdapter);
            ngl_images.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    ImageView image = (ImageView) view.findViewById(R.id.image);
                    MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(image.getMeasuredWidth(), image.getMeasuredHeight());
                    MessageImagePagerActivity.startImagePagerActivity(mActivity, bean.getNotes_img(), position, imageSize);
                }
            });
        } else {
        }
        if (null != bean.getRecorder_info()) {
            bottomView.findViewById(R.id.rea_recorder_info).setVisibility(View.VISIBLE);
            //记录人，记录时间信息
            if (!TextUtils.isEmpty(bean.getRecorder_info().getReal_name())) {
                ((TextView) bottomView.findViewById(R.id.rec_realname)).setText(Html.fromHtml("<font color='#666666'>记录人：</font>" + bean.getRecorder_info().getReal_name()));
            }
            if (!TextUtils.isEmpty(bean.getRecorder_info().getRecord_time())) {
                ((TextView) bottomView.findViewById(R.id.tv_time)).setText(Html.fromHtml("<font color='#666666'>记录时间：</font>" + bean.getRecorder_info().getRecord_time()));
            }
        } else {
            bottomView.findViewById(R.id.rea_recorder_info).setVisibility(View.GONE);
        }
        accountDetailAdapter.notifyDataSetChanged();
        Utils.setAccountListViewHeight(listView, screenHeight);

    }

    /**
     * 删除
     */
    public void delsetmount() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", account_id + "");
        if (agencyGroupUser != null) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id() + "");
        }
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
                                CommonMethod.makeNoticeShort(mActivity, "删除成功！", CommonMethod.SUCCESS);
                                setResult(Constance.ACCOUNT_UPDATE, getIntent());
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.ACCOUNT_DELETE) {
            //删除成功
            setResult(Constance.ACCOUNT_UPDATE, getIntent());
            mActivity.finish();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.ACCOUNT_UPDATE) {
            LUtils.e("-----2222------------");
            //修改成功
            setResult(Constance.ACCOUNT_UPDATE, getIntent());
            getDetailInfo();
        }
    }

    @Override
    public void onFinish(View view) {
        super.onFinish(view);
    }
}
