package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.activity.RectificationInstructionsActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.ReplyMsgQualityAndSafeActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.QualityAndsafeBean;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
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
 * CName:质量，安全列表页
 * User: hcs
 * Date: 2017-06-01
 * Time: 11:08
 */


public class MsgQualityAndSafeActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener {
    private MsgQualityAndSafeActivity mActivity;
    //聊天数据
    private List<MessageEntity> msgList;
    // 下拉刷新
    private SwipeRefreshLayout mSwipeLayout;
    // 已经关闭版主显示的图片
    private ImageView img_close;
    //滚动到顶部图标
    private ImageView img_top;
    //默认布局
    private LinearLayout lin_message_defalut;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //消息类型
    private String msgType;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 加载更多 */
    private View loadMoreView;
    private ListView lv_msg;
    //消息展示适配器
    private MsgQualityAndAdapter messageOtherAdapter;
    //翻页日期数据
    //筛选条件 全部，待整改,待复查，我提交的,待我复查,待我整改
    private TextView tv_top_all, tv_top2, tv_top3, tv_top4, tv_top5, tv_top6;
    private int pg = 0;
    private int status;
    private String uid;
    //筛选的bean
    private QuqlityAndSafeBean bean;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_qualityandsafe);
        initView();
        registerFinishActivity();
        getIntentData();
        setDefaultContent();
        autoRefresh();
        registerReceiver();
    }

    /**
     * 初始化控件
     */
    private void initView() {
        mActivity = MsgQualityAndSafeActivity.this;
        img_close = (ImageView) findViewById(R.id.img_close);
        img_top = (ImageView) findViewById(R.id.img_top);
        getImageView(R.id.rightImage).setImageResource(R.drawable.icon_quality_msg); //设置添加按钮
        findViewById(R.id.rea_filter).setVisibility(View.VISIBLE);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        lin_message_defalut = (LinearLayout) findViewById(R.id.lin_message_def);
        lv_msg = (ListView) findViewById(R.id.listView);
        tv_top_all = (TextView) findViewById(R.id.tv_top_all);
        tv_top2 = (TextView) findViewById(R.id.tv_top2);
        tv_top3 = (TextView) findViewById(R.id.tv_top3);
        tv_top4 = (TextView) findViewById(R.id.tv_top4);
        tv_top5 = (TextView) findViewById(R.id.tv_top5);
        tv_top6 = (TextView) findViewById(R.id.tv_top6);
        tv_top_all.setOnClickListener(this);
        tv_top2.setOnClickListener(this);
        tv_top3.setOnClickListener(this);
        tv_top4.setOnClickListener(this);
        tv_top5.setOnClickListener(this);
        tv_top6.setOnClickListener(this);
        findViewById(R.id.btn_filter_reset).setOnClickListener(this);
        mSwipeLayout.setOnRefreshListener(MsgQualityAndSafeActivity.this);
        new SetColor(mSwipeLayout);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        lv_msg.addFooterView(loadMoreView, null, false);
        img_top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lv_msg.setSelection(0);
            }
        });
        msgList = new ArrayList<>();
        lv_msg.setOnScrollListener(this);
        lv_msg.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if (motionEvent.getAction() == MotionEvent.ACTION_DOWN) {
                    hideSoftKeyboard();
                }
                return false;
            }
        });
        findViewById(R.id.rb_filter).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                status = 0;
                uid = "";
                bean = null;
                MsgQualityAndSafeFilterActivity.actionStart(mActivity, gnInfo,0,bean);
            }
        });
        getImageView(R.id.rightImage).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getImageView(R.id.rightImage).setImageResource(R.drawable.icon_quality_msg); //设置添加按钮
                ReplyMsgQualityAndSafeActivity.actionStart(mActivity, gnInfo, msgType);
            }
        });
        findViewById(R.id.tv_filter_reset).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MsgQualityAndSafeFilterActivity.actionStart(mActivity, gnInfo,0,bean);
            }
        });
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msgType) {
        Intent intent = new Intent(context, MsgQualityAndSafeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
        if (TextUtils.isEmpty(msgType)) {
            CommonMethod.makeNoticeLong(mActivity, "消息类型错误", CommonMethod.SUCCESS);
            finish();
            return;
        }
        if (gnInfo.getIs_closed() == 1) {
            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
            if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.team_closed_icon));
            } else {
                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.group_closed_icon));
            }
        }

    }

    /**
     * 设置缺省页
     */
    private void setDefaultContent() {
        TextView tv_default = ((TextView) findViewById(R.id.tv_default));
        TextView tv_toact = (TextView) findViewById(R.id.tv_toact);
        if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
            setTextTitle(R.string.safe_question);
            tv_toact.setText("发安全问题");
        } else if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
            setTextTitle(R.string.quality_question);
            tv_toact.setText("发质量问题");
        }
        //发布通知等按钮事件
        findViewById(R.id.lin_send).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //该组是否已经关闭
                if (MessageUtils.isCloseGroupAndTeam(gnInfo, mActivity)) {
                    return;
                }
                switch (msgType) {
                    case MessageType.MSG_SAFE_STRING:
                        onClickSafe();
                        break;
                    case MessageType.MSG_QUALITY_STRING:
                        onClickQuality();
                        break;
                }
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
//        getMsgList(msgType, (null == msgList || msgList.size() == 0) ? "" : msgList.get(0).getS_date());
        isFulsh = true;
        isHaveMoreData = true;
        pg = 1;
        getMsgList(pg);
    }

    /**
     * 重服务器获取消息记录
     */
    protected void getMsgList(final int page) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (null != bean) {
            DataUtil.getFilterParams(params, bean);
        }

        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("msg_type", getIntent().getStringExtra(Constance.MSG_TYPE));
        params.addBodyParameter("pg", page + "");
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
                                        findViewById(R.id.rea_filter).setVisibility(View.GONE);
                                        ((TextView) findViewById(R.id.tv_filter_reset)).setText(Html.fromHtml("<font color='#333333'>共筛选出</font><font color='#d7252c'>" + beans.getValues().getList_counts() + "</font><font color='#333333'>条记录</font>"));
                                    } else {
                                        //还原初始布局
                                        findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                                        findViewById(R.id.rea_filter).setVisibility(View.VISIBLE);
                                    }
//                                    bean = null;

                                    addListMsg(beans.getValues().getList());
                                    setNumber(beans.getValues());
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

    public void setNumber(QualityAndsafeBean bean) {
        //筛选条件 全部，待整改,待复查，我提交的,待我复查,待我整改
//       private TextView tv_top_all, tv_top2, tv_top3, tv_top4, tv_top5, tv_top6;
        if (!TextUtils.isEmpty(bean.getIs_statu_rect()) && !bean.getIs_statu_rect().equals("0")) {
            tv_top2.setText("待整改(" + bean.getIs_statu_rect() + ")");
        }
        if (!TextUtils.isEmpty(bean.getIs_statu_check()) && !bean.getIs_statu_check().equals("0")) {
            tv_top3.setText("待复查(" + bean.getIs_statu_check() + ")");
        }
        if (!TextUtils.isEmpty(bean.getCheck_me()) && !bean.getCheck_me().equals("0")) {
            tv_top5.setText("待我复查(" + bean.getCheck_me() + ")");
        }
        if (!TextUtils.isEmpty(bean.getRect_me()) && !bean.getRect_me().equals("0")) {
            tv_top6.setText("待我整改(" + bean.getRect_me() + ")");
        }
        if (bean.getIs_new_message() == 1) {
            //显示红点
            getImageView(R.id.rightImage).setImageResource(R.drawable.icon_quality_msg_red); //设置添加按钮
        } else {
            getImageView(R.id.rightImage).setImageResource(R.drawable.icon_quality_msg); //设置添加按钮
        }
    }

    //    private TextView tv_top_all, tv_top2, tv_top3, tv_top4, tv_top5, tv_top6;
    @Override
    public void onClick(View v) {
        initTextColor();
        switch (v.getId()) {
            case R.id.tv_top_all:
                status = 0;
                uid = "";
                bean = null;
                tv_top_all.setTextColor(getResources().getColor(R.color.app_color));
                onRefresh();
                break;
            case R.id.tv_top2:
                status = 1;
                uid = "";
                bean = null;
                tv_top2.setTextColor(getResources().getColor(R.color.app_color));
                onRefresh();
                break;
            case R.id.tv_top3:
                status = 2;
                uid = "";
                bean = null;
                tv_top3.setTextColor(getResources().getColor(R.color.app_color));
                onRefresh();
                break;
            case R.id.tv_top4:
                uid = UclientApplication.getUid(mActivity);
                tv_top4.setTextColor(getResources().getColor(R.color.app_color));
                bean = null;
                onRefresh();
                break;
            case R.id.tv_top5:
                status = 2;
                bean = null;
                uid = UclientApplication.getUid(mActivity);
                tv_top5.setTextColor(getResources().getColor(R.color.app_color));
                onRefresh();
                break;
            case R.id.tv_top6:
                status = 1;
                bean = null;
                uid = UclientApplication.getUid(mActivity);
                tv_top6.setTextColor(getResources().getColor(R.color.app_color));
                onRefresh();
                break;
            case R.id.btn_filter_reset:
                findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                findViewById(R.id.rea_filter).setVisibility(View.GONE);
                onClick(tv_top_all);
                break;
        }

    }

    public void initTextColor() {
        tv_top_all.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top2.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top3.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top4.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top5.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top6.setTextColor(getResources().getColor(R.color.color_666666));
        bean = null;
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
                lin_message_defalut.setVisibility(View.VISIBLE);
                lv_msg.setVisibility(View.GONE);
                return;
            }
            lin_message_defalut.setVisibility(View.GONE);
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
            lin_message_defalut.setVisibility(View.VISIBLE);
            lv_msg.setVisibility(View.GONE);
        } else {
            lin_message_defalut.setVisibility(View.GONE);
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

    /**
     * 安全隐患
     */
    public void onClickSafe() {
        ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_SAFE_STRING,null);
    }

    /**
     * 质量进度
     */
    public void onClickQuality() {
        ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_QUALITY_STRING,null);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
//            pg = 1;
//            getMsgList(pg);
            onRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == RectificationInstructionsActivity.FINISH) {
            onRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE) {
            bean = (QuqlityAndSafeBean) data.getSerializableExtra(MsgQualityAndSafeFilterActivity.FILTERBEAN);
            if (bean != null) {
                isHaveMoreData = true;
                onRefresh();
            } else {
            }
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            GroupDiscussionInfo info = (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, info);
            intent.putExtras(bundle);
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();
        }
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.RECIVEMESSAGE);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.RECIVEMESSAGE)) {
                //接收到群组消息回执
                MessageEntity bean = (MessageEntity) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                LUtils.e(gnInfo.getGroup_id() + "，，，，" + gnInfo.getClass_type() + "-----------------bean---------" + new Gson().toJson(bean));
                if (null == bean.getGroup_id() || bean.getGroup_id().equals("0")) {
                    return;
                }
                //是否是本组收到的消息
                if (!bean.getGroup_id().equals(gnInfo.getGroup_id()) || !bean.getClass_type().equals(gnInfo.getClass_type())) {
                    return;
                }
                if (bean.getMsg_type().equals("reply_quality") || bean.getMsg_type().equals("reply_safe")) {
                    getImageView(R.id.rightImage).setImageResource(R.drawable.icon_quality_msg_red);
                }
            }
        }
    }
}
