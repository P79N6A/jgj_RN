package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.activity.RectificationInstructionsActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.QualityAndsafeBean;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:质量，安全列表2.3.4
 * User: hcs
 * Date: 2017-11-17
 * Time: 16:10
 */

public class QualityAndSafeListActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener {
    private QualityAndSafeListActivity mActivity;
    /*组信息*/
    private GroupDiscussionInfo gnInfo;
    private String msg_type;
    /* 下拉刷新*/
    private SwipeRefreshLayout mSwipeLayout;
    /*筛选的bean */
    private QuqlityAndSafeBean bean;
    /*聊天集合 */
    private List<MessageEntity> msgList;
    private ListView lv_msg;
    /*消息展示适配器 */
    private MsgQualityAndAdapter messageOtherAdapter;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 默认布局 */
    private RelativeLayout lin_message_defalut;
    /* 我发布的默认布局 */
    private LinearLayout defaultLayout;
    /* 加载更多 */
    private View loadMoreView;
    //滚动到顶部图标
    private ImageView img_top;
    /* 筛选状态 1，待整改2，待复查3，已完成4，待我整改5，待我复查6，我提交的*/
    private int filter_state;
    private int pg = 0;
    private int status;
    private String uid;
    /*标题*/
    private String title;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quality_and_safe_list);
        registerFinishActivity();
        getIntentData();
        initView();
        autoRefresh();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msgType, int state, int filter_state, String uid, String title) {
        Intent intent = new Intent(context, QualityAndSafeListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        intent.putExtra(Constance.STATE, state);
        intent.putExtra(Constance.FILTER_STATE, filter_state);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.TITLE, title);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = QualityAndSafeListActivity.this;
        lv_msg = (ListView) findViewById(R.id.listView);
        lin_message_defalut = (RelativeLayout) findViewById(R.id.emptyview);
        defaultLayout = (LinearLayout) findViewById(R.id.defaultLayout);
        img_top = (ImageView) findViewById(R.id.img_top);
        img_top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lv_msg.setSelection(0);
            }
        });
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        mSwipeLayout.setOnRefreshListener(this);
        lv_msg.setOnScrollListener(this);
        new SetColor(mSwipeLayout);
        initRightImage();
        getImageView(R.id.rightImage).setVisibility(View.VISIBLE);
        findViewById(R.id.tv_help).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (msg_type) {
                    case MessageType.MSG_SAFE_STRING:
                        if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                            HelpCenterUtil.actionStartHelpActivity(mActivity, 181);
                        } else {
                            HelpCenterUtil.actionStartHelpActivity(mActivity, 197);
                        }

                        break;
                    case MessageType.MSG_QUALITY_STRING:
                        if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                            HelpCenterUtil.actionStartHelpActivity(mActivity, 180);
                        } else {
                            HelpCenterUtil.actionStartHelpActivity(mActivity, 196);
                        }

                        break;
                }
            }
        });
        findViewById(R.id.tv_send).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (gnInfo.getIs_closed() == 1) {
                    return;
                }
                switch (msg_type) {
                    case MessageType.MSG_SAFE_STRING:
                        ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_SAFE_STRING, null);
                        break;
                    case MessageType.MSG_QUALITY_STRING:
                        ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_QUALITY_STRING, null);
                        break;
                }
            }
        });
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        msg_type = getIntent().getStringExtra(Constance.MSG_TYPE);
        status = getIntent().getIntExtra(Constance.STATE, 0);
        uid = getIntent().getStringExtra(Constance.UID);
        title = getIntent().getStringExtra(Constance.TITLE);
        if (msg_type.equals(MessageType.MSG_QUALITY_STRING)) {
            ((TextView) findViewById(R.id.tv_hint)).setText("暂无提交的质量问题");
        } else if (msg_type.equals(MessageType.MSG_SAFE_STRING)) {
            ((TextView) findViewById(R.id.tv_hint)).setText("暂无提交的安全问题");
        }

        SetTitleName.setTitle(findViewById(R.id.title), title);
//        if (gnInfo.getIs_closed() == 1) {
//            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
//            if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
//                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.team_closed_icon));
//            } else {
//                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.group_closed_icon));
//            }
//        }
        findViewById(R.id.tv_send).setVisibility(gnInfo.getIs_closed() == 1 ? View.GONE : View.VISIBLE);
    }

    public void initRightImage() {
        getImageView(R.id.rightImage).setImageResource(R.drawable.icon_filter);
        getImageView(R.id.rightImage).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MsgQualityAndSafeFilterActivity.actionStart(mActivity, gnInfo, getIntent().getIntExtra(Constance.FILTER_STATE, 0), filterBean);
            }
        });
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                isFulsh = true;
                onRefresh();
            }
        });
    }

    //加载数据
    @Override
    public void onRefresh() {
        isFulsh = true;
        isHaveMoreData = true;
        pg = 1;
        getMsgList(pg);
    }

    //加载筛选之后的数据
    public void onFilterRefresh(QuqlityAndSafeBean bean) {
        this.bean = bean;
        messageOtherAdapter = null;
        autoRefresh();
    }

    /**
     * 重服务器获取消息记录
     */
    protected void getMsgList(final int page) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (null != bean) {
            DataUtil.getFilterParams(params, bean);
            if (title.equals("我提交的")) {
                params.addBodyParameter("is_my_offer", "1");
            }
        }
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("msg_type", getIntent().getStringExtra(Constance.MSG_TYPE));
        params.addBodyParameter("pg", page + "");
        params.addBodyParameter("pagesize", "20");
        if (status != 0) {
            params.addBodyParameter("status", status + "");
        }
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_QUALITYANDSAFELIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<QualityAndsafeBean> beans = CommonJson.fromJson(responseInfo.result, QualityAndsafeBean.class);

                            if (beans.getState() != 0) {
                                if (null != bean) {
                                    //显示重置按钮
                                    findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                                    ((TextView) findViewById(R.id.tv_filter_reset)).setText(Html.fromHtml("<font color='#333333'>共筛选出</font><font color='#d7252c'>" + beans.getValues().getList_counts() + "</font><font color='#333333'>条记录</font>"));
                                } else {
                                    //还原初始布局
                                    findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                                }
                                addListMsg(beans.getValues().getList());
                            } else {
                                DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            pg -= 1;
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        bean = null;
                        pg -= 1;
                        finish();
                    }
                });
    }

    /**
     * 显示数据
     *
     * @param msgDataList
     */
    public void addListMsg(List<MessageEntity> msgDataList) {
        if (null == msgList) {
            msgList = new ArrayList<>();
        }

        if (isFulsh) {
            mSwipeLayout.setRefreshing(false);
            if (msgDataList.size() == 0) {
                if (title.equals(getString(R.string.notice_top4))) {
                    defaultLayout.setVisibility(View.VISIBLE);
                    lin_message_defalut.setVisibility(View.GONE);
                } else {
                    defaultLayout.setVisibility(View.GONE);
                    lin_message_defalut.setVisibility(View.VISIBLE);
                }
                lv_msg.setVisibility(View.GONE);
                return;
            }
            lin_message_defalut.setVisibility(View.GONE);
            defaultLayout.setVisibility(View.GONE);
            lv_msg.setVisibility(View.VISIBLE);
            msgList.clear();
        } else {
            //Constance.PAGE_SIZE
            //是否有更多数据
            isHaveMoreData = msgDataList.size() >= 1 ? true : false;
            int count = lv_msg.getFooterViewsCount();
            if (isHaveMoreData) {
                if (count == 0) {
                    lv_msg.addFooterView(loadMoreView, null, false);
                }
            } else {
                if (count > 0) {
                    lv_msg.removeFooterView(loadMoreView);
                }
            }
            loadMoreView.setVisibility(View.GONE);
        }
        msgList.addAll(msgDataList);
        if (null == messageOtherAdapter) {

            LUtils.e("-----------------" + msgDataList.size());
            messageOtherAdapter = new MsgQualityAndAdapter(mActivity, msgList, gnInfo);
            lv_msg.setAdapter(messageOtherAdapter);
            lv_msg.setSelection(0);
        } else {
            messageOtherAdapter.notifyDataSetChanged();
            if (isFulsh) {
                lv_msg.setSelection(0);
            } else {
                lv_msg.setSelection(msgList.size() > 0 ? msgList.size() - msgDataList.size() : msgDataList.size());
            }
        }
        mSwipeLayout.setRefreshing(false);

        if (null == msgList || msgList.size() == 0) {
            if (title.equals(getString(R.string.notice_top4))) {
                defaultLayout.setVisibility(View.VISIBLE);
                lin_message_defalut.setVisibility(View.GONE);
            } else {
                defaultLayout.setVisibility(View.GONE);
                lin_message_defalut.setVisibility(View.VISIBLE);
            }
            lv_msg.setVisibility(View.GONE);
        } else {
            lin_message_defalut.setVisibility(View.GONE);
            defaultLayout.setVisibility(View.GONE);
            lv_msg.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                isFulsh = false;
                loadMoreView.setVisibility(View.VISIBLE);
                pg += 1;
                getMsgList(pg);

            }
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        if (firstVisibleItem >= 2) {
            if (img_top.getVisibility() != View.VISIBLE)
                img_top.setVisibility(View.VISIBLE);
        } else {
            if (img_top.getVisibility() != View.GONE)
                img_top.setVisibility(View.GONE);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_filter_reset:
                findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                bean = null;
                filterBean = null;
                autoRefresh();
                break;
        }
    }

    private QuqlityAndSafeBean filterBean;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE) {
            //筛选回调
            filterBean = (QuqlityAndSafeBean) data.getSerializableExtra(MsgQualityAndSafeFilterActivity.FILTERBEAN);
            if (filterBean != null) {
                onFilterRefresh(filterBean);

            } else {
                onFilterRefresh(null);
            }
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            //发布成功回调
            onRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == RectificationInstructionsActivity.FINISH) {
            //整改复查完成回调
            onRefresh();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            Intent intent = new Intent();
            intent.putExtra(Constance.BEAN_CONSTANCE, data.getSerializableExtra(Constance.BEAN_CONSTANCE));
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();
        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
