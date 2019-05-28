package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AccountUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.MultiPersonBatchAccountNewActivity;
import com.jizhi.jlongg.main.adpter.MessageBillAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBillData;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * CName: 聊天界面记工
 * User: hcs
 * Date: 2017-04-19
 * Time: 16:50
 */
public class MessageBillActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener {
    /* 聊天的内容 */
    private List<MessageEntity> msgList;
    /* listView */
    private ExpandableListView expandableListView;
    /* 列表适配器 */
    private MessageBillAdapter messageBillAdapter;
    /* 分页编码 */
    private int page;
    /* 下拉刷新控件 */
    private SwipeRefreshLayout mSwipeLayout;
    private ImageView img_close;
    //组信息
    private GroupDiscussionInfo gnInfo;
    private MessageBillActivity activity;

    /* 加载更多 */
    private View loadMoreView;

    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    private boolean isFulsh;

    private LinearLayout layout_default;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_message_bill);
        getIntentData();
        initView();
        initClickListener();
        autoRefresh();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, MessageBillActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
//        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    public void initView() {
        activity = MessageBillActivity.this;
        setTextTitle(R.string.bill_book);
        expandableListView = (ExpandableListView) findViewById(R.id.expandableListView);
        img_close = (ImageView) findViewById(R.id.img_close);
        layout_default = (LinearLayout) findViewById(R.id.lin_message_def);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        loadMoreView = loadMoreDataView();// listView 底部加载对话框
        loadMoreView.setVisibility(View.GONE);
        mSwipeLayout.setOnRefreshListener(this); // 设置下拉刷新回调
        new SetColor(mSwipeLayout); // 设置下拉刷新滚动颜色
        expandableListView.addFooterView(loadMoreView, null, false);
        expandableListView.setOnGroupClickListener(OnGroupClickListener);
        expandableListView.setOnScrollListener(this);
        if (gnInfo.getIs_closed() == 1) {
            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
            Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.group_closed_icon));
        }
        findViewById(R.id.title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HelpCenterUtil.actionStartHelpActivity(MessageBillActivity.this, 199);
            }
        });
    }

    /**
     * 获取传递过来的数据
     */

    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    public void initClickListener() {
        //马上记一笔
        findViewById(R.id.lin_send).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //该组是否已经关闭
                if (MessageUtils.isCloseGroupAndTeam(gnInfo, activity)) {
                    return;
                }
                if (UclientApplication.getUid(getApplicationContext()).equals(gnInfo.getCreater_uid())) {
                    //创建者
                    MultiPersonBatchAccountNewActivity.actionStart(activity, gnInfo.getPro_id(), gnInfo.getAll_pro_name(), true, gnInfo.getGroup_id(),
                            gnInfo.getMembers_head_pic(), gnInfo.getAll_pro_name(), gnInfo.getCreater_uid());
                } else {
//                    //成员
                    LUtils.e("--------" + new Gson().toJson(gnInfo));
                    AccountUtils.searchData(activity, gnInfo, false);
                }
            }
        });
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        if (null == mSwipeLayout) {
            return;
        }
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
//                mHasLoadedOnce = true;
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }

    @Override
    public void onRefresh() {
        page = 1;
        isFulsh = true;
        getBillData();
    }

    /**
     * 查询我的项目
     */
    public void getBillData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        String group_id = gnInfo.getGroup_id();
        params.addBodyParameter("group_id", group_id);
        params.addBodyParameter(Constance.PAGE, String.valueOf(page));
        params.addBodyParameter("pgsize", Constance.PAGE_SIZE + "");
//        params.addBodyParameter("pgsize", "5");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GROUPWORKDAYLIST, params,
                new RequestCallBack<String>(false) {
                    @Override
                    public void onFailure(HttpException arg0, String msg) {
                        if (page == 1) {
                            mSwipeLayout.setRefreshing(false);
                        } else {
                            loadMoreView.setVisibility(View.GONE);
                            page -= 1;
                        }
                    }

                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        boolean isFail = false;
                        try {
                            CommonListJson<MessageBillData> bean = CommonListJson.fromJson(responseInfo.result, MessageBillData.class);
                            List<MessageBillData> billdata = bean.getValues();
                            if (billdata != null && billdata.size() > 0) {
                                initServiceData(billdata);
                                isHaveMoreData = billdata.size() >= Constance.PAGE_SIZE ? true : false;
                                layout_default.setVisibility(View.VISIBLE);
                            } else {
                                isHaveMoreData = false;
                                if (page == 1) {
                                    layout_default.setVisibility(View.VISIBLE);
                                } else {
                                    layout_default.setVisibility(View.GONE);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, getString(R.string.service_err), CommonMethod.ERROR);
                            isFail = true;
                        } finally {
                            int count = expandableListView.getFooterViewsCount();
                            if (isHaveMoreData) {
                                if (count == 0) {
                                    expandableListView.addFooterView(loadMoreView, null, false);
                                }
                            } else {
                                if (count > 0) {
                                    expandableListView.removeFooterView(loadMoreView);
                                }
                            }
                            if (page == 1) {
                                mSwipeLayout.setRefreshing(false);
                            } else {
                                if (isFail) {
                                    page -= 1;
                                }
                                loadMoreView.setVisibility(View.GONE);
                            }
                        }

                        if (null != messageBillAdapter && messageBillAdapter.getGroupCount() > 0) {
                            layout_default.setVisibility(View.GONE);
                        } else {
                            layout_default.setVisibility(View.VISIBLE);
                        }
                    }
                }
        );
    }

    /**
     * 初始化 服务器返回数据
     * xx
     *
     * @param billdata 列表数据
     * @return
     */
    private void initServiceData(List<MessageBillData> billdata) {
        if (messageBillAdapter == null) {
            messageBillAdapter = new MessageBillAdapter(activity, billdata);
            expandableListView.setAdapter(messageBillAdapter);
        } else {
            if (page == 1) {
                messageBillAdapter.update(billdata);
            } else {
                messageBillAdapter.addList(billdata);
            }
        }
        int size = messageBillAdapter.getMessageBillData().size();
        for (int i = 0; i < size; i++) {
            expandableListView.expandGroup(i);
        }


    }

    ExpandableListView.OnGroupClickListener OnGroupClickListener = new ExpandableListView.OnGroupClickListener() {
        @Override
        public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
            return true;
        }
    };
    /*  监听listView 最后一条消息 */
    private int lastItem;

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (lastItem == messageBillAdapter.getSize() && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                loadMoreView.setVisibility(View.VISIBLE);
                isFulsh = false;
                page += 1;
                getBillData();
            }
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        lastItem = firstVisibleItem + visibleItemCount - 1;
//        if (firstVisibleItem >= 2) {
//            if (findViewById(R.id.img_top).getVisibility() != View.VISIBLE)
//                findViewById(R.id.img_top).setVisibility(View.VISIBLE);
//        } else {
//            if (findViewById(R.id.img_top).getVisibility() != View.GONE)
//                findViewById(R.id.img_top).setVisibility(View.GONE);
//        }
    }

}
