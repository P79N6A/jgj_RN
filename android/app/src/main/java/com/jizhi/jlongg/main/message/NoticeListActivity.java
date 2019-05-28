package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ReleaseNoticeActivity;
import com.jizhi.jlongg.main.adpter.NoticeListAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.NoticeListBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
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
 * Date: 2018-08-18
 * Time: 11:34
 */

public class NoticeListActivity extends BaseActivity implements View.OnClickListener, AbsListView.OnScrollListener {
    private NoticeListActivity mActivity;
    private GroupDiscussionInfo gnInfo;
    private SpringView springView;
    private View layout_default;
    private ListView listView;
    private int pg = 0;
    private boolean isFulsh;
    private NoticeListAdapter listAdapter;
    private List<NoticeListBean> listBean;

    //rea_sign
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_list);
        registerFinishActivity();
        getIntentData();
        initView();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        findViewById(R.id.lin_send).setVisibility(gnInfo.getIs_closed() == 1 ? View.GONE : View.VISIBLE);
        findViewById(R.id.img_close).setVisibility(gnInfo.getIs_closed() == 1 ? View.VISIBLE : View.GONE);
        Utils.setBackGround(findViewById(R.id.img_close), gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? getResources().getDrawable(R.drawable.team_closed_icon) : getResources().getDrawable(R.drawable.group_closed_icon));
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, NoticeListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = NoticeListActivity.this;
        setTextTitle(R.string.work_notice_title);
        layout_default = findViewById(R.id.layout_default);
        ((TextView) findViewById(R.id.tv_top)).setText("暂无记录哦~");
        listView = findViewById(R.id.listView);
        listView.setOnScrollListener(this);
        findViewById(R.id.lin_send).setOnClickListener(this);
        findViewById(R.id.title).setOnClickListener(this);
        findViewById(R.id.img_top).setOnClickListener(this);
        ((TextView) findViewById(R.id.tv_toact)).setText("发通知");
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
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                ActivityNoticeDetailActivity.actionStart(mActivity, gnInfo, Integer.parseInt(listBean.get(i).getMsg_id()));
            }
        });
    }

    /**
     * 通知列为表
     */
    public void getSignList() {
        final RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("pg", String.valueOf(pg));
        params.addBodyParameter("pagesize", String.valueOf(Constance.PAGE_SIZE));
        CommonHttpRequest.commonRequest(this, NetWorkRequest.NOTICE_LIST, NoticeListBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    setVaues((List<NoticeListBean>) object);
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


    public void setVaues(List<NoticeListBean> list) {
        if (null == listBean) {
            listBean = new ArrayList<>();
        }
        if (isFulsh) {
            listBean = list;
            listAdapter = new NoticeListAdapter(mActivity, listBean, gnInfo);
            listView.setAdapter(listAdapter);
            listView.setSelection(0);
        } else {
            int seletionPositon = list.size() > 0 ? (list.size() + 1) : list.size();
            listBean.addAll(list);
            listAdapter.notifyDataSetChanged();
            listView.setSelection(seletionPositon);
            if (list.size() == 0) {
                pg -= 1;
            }
        }
        if (listBean.size() == 0) {
            layout_default.setVisibility(View.VISIBLE);
        } else {
            layout_default.setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.lin_send:
                ReleaseNoticeActivity.actionStart(mActivity, gnInfo);
                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(mActivity, gnInfo.getClass_type().equals(Constance.GROUP) ? 195 : 184);
                break;
            case R.id.img_top:
                listView.setSelection(0);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            springView.callFreshDelay();
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {

    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        if (firstVisibleItem >= 2) {
            if (findViewById(R.id.img_top).getVisibility() != View.VISIBLE)
                findViewById(R.id.img_top).setVisibility(View.VISIBLE);
        } else {
            if (findViewById(R.id.img_top).getVisibility() != View.GONE)
                findViewById(R.id.img_top).setVisibility(View.GONE);
        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
