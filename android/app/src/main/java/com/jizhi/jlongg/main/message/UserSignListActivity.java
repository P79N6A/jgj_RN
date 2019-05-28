package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.SignUserAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.SignListBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.container.DefaultFooter;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:签到列表页面
 * User: hcs
 * Date: 2017-04-18
 * Time: 11:34
 */

public class UserSignListActivity extends BaseActivity {
    private UserSignListActivity mActivity;
    private GroupDiscussionInfo gnInfo;
    private SpringView springView;
    private View layout_default;
    private ListView listView;
    private int pg = 0;
    private boolean isFulsh;
    private SignUserAdapter signListAdapter;
    private List<SignListBean> signListBean;
    private UserInfo userInfo;

    //rea_sign
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_user_list);
        getIntentData();
        initView();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        userInfo = (UserInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE1);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, UserInfo userInfo) {
        Intent intent = new Intent(context, UserSignListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_CONSTANCE1, userInfo);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = UserSignListActivity.this;
        if(null==userInfo ||TextUtils.isEmpty(userInfo.getReal_name()) ||TextUtils.isEmpty(userInfo.getUid())){
            SetTitleName.setTitle(findViewById(R.id.title), userInfo.getReal_name() + "签到列表");
        }else{
            SetTitleName.setTitle(findViewById(R.id.title), userInfo.getUid().equals(UclientApplication.getUid()) ?"我的签到列表":userInfo.getReal_name() + "的签到列表");
        }
        ((TextView) findViewById(R.id.tv_top)).setText("暂无数据");
        layout_default = findViewById(R.id.layout_default);
        listView = findViewById(R.id.listView);
        springView = findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setHeader(new DefaultHeader(this));
        springView.setFooter(new DefaultFooter(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                isFulsh = true;
                pg = 1;
                getSignList();
            }

            @Override
            public void onLoadmore() {
                isFulsh = false;
                pg += 1;
                getSignList();
            }
        });
    }

    /**
     * 签到列表
     */
    public void getSignList() {
        final RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("uid", userInfo.getUid());
        params.addBodyParameter("pg", String.valueOf(pg));
        params.addBodyParameter("pagesize", "10");
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SIGN_RECORD_LIST, SignListBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    List<SignListBean> signBean = (List<SignListBean>) object;
                    setVaues(signBean);
                } catch (Exception e) {
                    pg -= 1;
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    springView.onFinishFreshAndLoad();
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                pg -= 1;
                printNetLog(msg, mActivity);
                springView.onFinishFreshAndLoad();
            }
        });
    }


    public void setVaues(List<SignListBean> list) {
        if (null == signListBean) {
            signListBean = new ArrayList<>();
        }
        if (isFulsh) {
            signListBean = list;
            signListAdapter = new SignUserAdapter(mActivity, signListBean, gnInfo);
            listView.setAdapter(signListAdapter);
            listView.setSelection(0);
        } else {
            int seletionPositon = list.size() > 0 ? (list.size() + 1) : list.size();
            signListBean.addAll(list);
            signListAdapter.notifyDataSetChanged();
            listView.setSelection(seletionPositon);
            if (list.size() == 0) {
                pg -= 1;
            }
        }
        LUtils.e(listView.getHeaderViewsCount() + "----------------" + signListBean.size());
        if (listView.getHeaderViewsCount() == 1 && signListBean.size() == 0) {
            layout_default.setVisibility(View.VISIBLE);
        } else {
            layout_default.setVisibility(View.GONE);
        }
    }


}
