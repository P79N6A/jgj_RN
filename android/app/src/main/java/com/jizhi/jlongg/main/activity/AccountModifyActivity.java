package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountDetailActivity;
import com.jizhi.jlongg.main.adpter.AccountModifyAdapter;
import com.jizhi.jlongg.main.bean.AccountModifyBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.container.DefaultFooter;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:记工变更
 * User: hcs
 * Date: 2018-8-3
 * Time: 14:44
 */
public class AccountModifyActivity extends BaseActivity implements AccountModifyAdapter.ItemClickInterFace, View.OnClickListener {
    private AccountModifyActivity mActivity;
    private RecyclerView listView;
    private AccountModifyAdapter accountModifyAdapter;
    private List<AccountModifyBean> accountModifyBeanList;
    private int pg = 0;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    //项目id
    private String group_id;

    private GroupDiscussionInfo info;
    private SpringView springView;
    private View layout_default;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account_modify);
        getIntentData();
        initRightImageLog();
        initView();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        info = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        group_id = info.getGroup_id();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, AccountModifyActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    public void initRightImageLog() {
       /* ImageView imageView = (ImageView) findViewById(R.id.rightImage);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
        params.width = ViewGroup.LayoutParams.WRAP_CONTENT;
        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        imageView.setLayoutParams(params);
        imageView.setImageResource(R.drawable.red_dots);*/
        findViewById(R.id.right_title).setOnClickListener(this);
    }

    public List<SingleSelected> getFileterValue() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber("1"));
        list.add(new SingleSelected("取消", false, false, "4", Color.parseColor("#999999"), 18));
        return list;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getFileterValue(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "1": //切换记工显示方式
                                AccountShowTypeActivity.actionStart(mActivity);
                                break;
                            case "2": //取消
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
        }
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = AccountModifyActivity.this;
        setTextTitleAndRight(R.string.account_change, R.string.more);
        layout_default = findViewById(R.id.layout_default);
        ((TextView) findViewById(R.id.tv_top)).setText("暂无记工变更记录\n班组长和代班长新记的账、修改的账、删除的账\n可以在记工变更页面查看详情");
        ((TextView) findViewById(R.id.tv_top)).setTextSize(14);
        listView =  findViewById(R.id.listView);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);
        listView.setLayoutManager(linearLayoutManager);
        listView =  findViewById(R.id.listView);
        springView =  findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setHeader(new DefaultHeader(this));
        springView.setFooter(new DefaultFooter(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                isFulsh = true;
                isHaveMoreData = true;
                pg = 1;
                getWorkRecordList();
            }

            @Override
            public void onLoadmore() {
                isFulsh = false;
                pg += 1;
                getWorkRecordList();
            }
        });
    }

    /**
     * 获取记功流水首页数据
     */
    public void getWorkRecordList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pagesize", "20");
        params.addBodyParameter("pg", String.valueOf(pg));
        params.addBodyParameter("group_id", group_id);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WORK_RECORD_CHANGE_LIST, params,
                    new RequestCallBack<String>() {
                        @SuppressWarnings("deprecation")
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                springView.onFinishFreshAndLoad();
                                CommonNewListJson baseJson = CommonNewListJson.fromJson(responseInfo.result, AccountModifyBean.class);
                                String msg = baseJson.getMsg();
                                if (!TextUtils.isEmpty(msg) && msg.equals(Constance.SUCCES_S)) {
                                    setVaues(setDataType(baseJson.getResult()));
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, baseJson.getCode() + "", baseJson.getMsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                springView.onFinishFreshAndLoad();
                            }
                        }

                        @Override
                        public void onFailure(HttpException error, String msg) {
                            printNetLog(msg, mActivity);
                            springView.onFinishFreshAndLoad();
                        }
                    });
    }

    public void setVaues(List<AccountModifyBean> accountWorkRember) {
        if (null == accountModifyBeanList) {
            accountModifyBeanList = new ArrayList<>();
        }
        if (isFulsh) {
            accountModifyBeanList = accountWorkRember;
            accountModifyAdapter = new AccountModifyAdapter(mActivity, accountModifyBeanList, this);
            listView.setAdapter(accountModifyAdapter);
            listView.scrollToPosition(accountModifyAdapter.getItemCount() - 1);
        } else {
            isHaveMoreData = accountWorkRember.size() >= 1 ? true : false;
            int seletionPositon = accountWorkRember.size() > 0 ? (accountModifyBeanList.size() + 1) : accountModifyBeanList.size();
            accountModifyBeanList.addAll(accountWorkRember);
            accountModifyAdapter.notifyDataSetChanged();
            listView.scrollToPosition(seletionPositon);
            if (accountWorkRember.size() == 0) {
                pg -= 1;
            }
            LUtils.e("----------seletionPositon-------------" + seletionPositon);
        }
        if (accountModifyBeanList.size() > 0) {
            layout_default.setVisibility(View.GONE);
        } else {
            layout_default.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 装换记账类型用于设置适配器布局
     *
     * @param accountModifyBeanList
     * @return
     */
    public List<AccountModifyBean> setDataType(List<AccountModifyBean> accountModifyBeanList) {
        //item显示类型  1增加 2.点工，包工记工天 3.借支结算包工记账
        //record_type记账变更类型:1新增2修改3删除
        for (int i = 0; i < accountModifyBeanList.size(); i++) {
            if (accountModifyBeanList.get(i).getRecord_type() == 1) {
                //增加所有记账布局一样
                accountModifyBeanList.get(i).setType(1);
            } else {
                if (String.valueOf(accountModifyBeanList.get(i).getRecord_info().getAccounts_type()).equals(AccountUtil.HOUR_WORKER) || String.valueOf(accountModifyBeanList.get(i).getRecord_info().getAccounts_type()).equals(AccountUtil.CONSTRACTOR_CHECK)) {
                    //点工，包工记账 详情修改所有布局一样
                    accountModifyBeanList.get(i).setType(2);
                } else {
                    //借支计算详情修改所有布局一样
                    accountModifyBeanList.get(i).setType(3);
                }
            }

        }
        return accountModifyBeanList;
    }

    @Override
    public void itemClick(int positon) {
        //记账变更类型:1新增2修改3删除
        if (accountModifyBeanList.get(positon).getRecord_type() == 2) {
            //修改
            AgencyGroupUser agency_group_user = info.getAgency_group_user();
            agency_group_user.setGroup_id(group_id);
            AccountDetailActivity.actionStart(mActivity, accountModifyBeanList.get(positon).getRecord_info().getAccounts_type() + "", Integer.parseInt(accountModifyBeanList.get(positon).getRecord_id()), "2", agency_group_user);
        }
    }

    @Override
    public void toRememberActivity(int group_postion, int child_positon) {
        if (accountModifyBeanList.get(group_postion).getRecord_type() == 1) {
            AgencyGroupUser agency_group_user = info.getAgency_group_user();
            agency_group_user.setGroup_id(group_id);
            String[] d = accountModifyBeanList.get(group_postion).getAdd_info().get(child_positon).getDate().split("-");
            RememberWorkerInfosActivity.actionStart(mActivity, agency_group_user, d[0], d[1], d[2], info.getPro_id() + "", info.getPro_name(), true);
        }
    }


    @Override
    public void toUserInfo(int positon) {
        ChatUserInfoActivity.actionStart(mActivity, accountModifyBeanList.get(positon).getUser_info().getUid());

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.ACCOUNT_UPDATE || resultCode == Constance.DISPOSEATTEND_RESULTCODE) {
            springView.callFreshDelay();
            return;

        }
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE) {
            LUtils.e("-------------刷新显示方法--------");
            //刷新显示方式
            if (null != accountModifyAdapter) {
                accountModifyAdapter.notifyDataSetChanged();
            }
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }


}