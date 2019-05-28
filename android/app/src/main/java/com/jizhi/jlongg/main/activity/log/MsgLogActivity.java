package com.jizhi.jlongg.main.activity.log;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alipay.sdk.app.EnvUtils;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.adpter.MessageLogAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.bean.MessageDot;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.BuyVipDialog;
import com.jizhi.jlongg.main.dialog.LogAddModeHintDialog;
import com.jizhi.jlongg.main.dialog.WheelGridViewLogMode;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
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

import static com.jizhi.jlongg.main.util.Constance.REQUEST;


/**
 * CName:新日志列表页2.3.0
 * User: hcs
 * Date: 2017-07-20
 * Time: 10:08
 */


public class MsgLogActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener, BuyVipDialog.ButVipClickListenerClick {
    private MsgLogActivity mActivity;
    //聊天数据
    private List<LogGroupBean> msgList;
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
    private ExpandableListView lv_msg;
    //消息展示适配器
    private MessageLogAdapter messageOtherAdapter;
    //翻页日期数据
    private String s_date;
    //全部
    private TextView tv_all_log, tv_my_log;
    //模版数据
    private List<LogGroupBean> approvalcatlist;
    //筛选内容
    private LogGroupBean bean;
    //选中的是全部还是自己
    private int type;
    //本地存储的模版名字
    private String cat_name;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_log);
        EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE);
        getIntentData();
        initView();
        registerFinishActivity();
//        registerReceiver();
        s_date = "";
        type = 1;
        autoRefresh();
        getapprovalCatList(false);
        initRightImage();
    }

    /**
     * 初始化控件
     */
    private void initView() {
        mActivity = MsgLogActivity.this;
        setTextTitle(R.string.messsage_work_log);
        bean = new LogGroupBean();
        bean.setUid(UclientApplication.getUid(mActivity));
        bean.setName(gnInfo.getCur_name());
        img_close = findViewById(R.id.img_close);
        img_top = findViewById(R.id.img_top);
        mSwipeLayout = findViewById(R.id.swipe_layout);
        lin_message_defalut = findViewById(R.id.lin_message_def);
        tv_all_log = findViewById(R.id.tv_all_log);
        tv_my_log = findViewById(R.id.tv_my_log);
        lv_msg = findViewById(R.id.expanLv);
        mSwipeLayout.setOnRefreshListener(MsgLogActivity.this);
        new SetColor(mSwipeLayout);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        lv_msg.addFooterView(loadMoreView, null, false);
        lv_msg.setOnGroupClickListener(OnGroupClickListener);
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
        tv_all_log.setOnClickListener(this);
        tv_my_log.setOnClickListener(this);
        findViewById(R.id.tv_mode).setOnClickListener(this);
        findViewById(R.id.tv_send).setOnClickListener(this);
        findViewById(R.id.btn_filter_reset).setOnClickListener(this);
        findViewById(R.id.rea_filter_reset).setOnClickListener(this);
        if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
            cat_name = SPUtils.get(mActivity, Constance.TEAM_CAT_NAME, "", Constance.JLONGG).toString();
        } else {
            cat_name = SPUtils.get(mActivity, Constance.GROUP_CAT_NAME, "", Constance.JLONGG).toString();
        }

        if (!TextUtils.isEmpty(cat_name)) {
            ((TextView) findViewById(R.id.tv_send)).setText("发" + cat_name);
        }
    }

    public void initRightImage() {
        getImageView(R.id.rightImage).setImageResource(R.drawable.icon_filter);
        findViewById(R.id.rightImage).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MsgLogFilterActivity.actionStart(mActivity, gnInfo, bean, type);
            }
        });
        findViewById(R.id.title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HelpCenterUtil.actionStartHelpActivity(mActivity, (gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? 188 : 226));
            }
        });
        findViewById(R.id.tv_help).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HelpCenterUtil.actionStartHelpActivity(mActivity, (gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? 188 : 226));
            }
        });
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msgType) {
        Intent intent = new Intent(context, MsgLogActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, REQUEST);
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
        findViewById(R.id.relativeLayoutBottom).setVisibility(gnInfo.getIs_closed() == 1 ? View.GONE : View.VISIBLE);
        findViewById(R.id.img_close).setVisibility(gnInfo.getIs_closed() == 1 ? View.VISIBLE : View.GONE);
        Utils.setBackGround(findViewById(R.id.img_close), gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? getResources().getDrawable(R.drawable.team_closed_icon) : getResources().getDrawable(R.drawable.group_closed_icon));

    }


    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                isFilter = false;
                onRefresh();
            }
        });
    }

    //加载数据
    @Override
    public void onRefresh() {
        isFulsh = true;
        s_date = "";
        getLogList("");
    }

    /* 上班/加班时长WheelView */
    public WheelGridViewLogMode wheelGridViewLogMode;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_all_log:
                type = 1;
                initTextColor();
                tv_all_log.setTextColor(getResources().getColor(R.color.color_eb4e4e));
                findViewById(R.id.img_all_log).setVisibility(View.VISIBLE);
//                bean = null;
                isFilter = false;
                onRefresh();
                break;
            case R.id.tv_my_log:
                type = 2;
                initTextColor();
                tv_my_log.setTextColor(getResources().getColor(R.color.color_eb4e4e));
                findViewById(R.id.img_my_log).setVisibility(View.VISIBLE);
//                submitUid = UclientApplication.getUid(mActivity);
//                bean = null;
                isFilter = false;
                onRefresh();
                break;
            case R.id.rea_filter_reset:
                MsgLogFilterActivity.actionStart(mActivity, gnInfo, bean, type);
                break;
            case R.id.tv_mode:
                if (approvalcatlist == null) {
                    getapprovalCatList(true);
                    return;
                }
                showModeWindow();
                break;
            case R.id.tv_send:
                if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                    String cat_id = SPUtils.get(mActivity, Constance.TEAM_CAT_ID, "", Constance.JLONGG).toString();
                    String cat_name = SPUtils.get(mActivity, Constance.TEAM_CAT_NAME, "通用日志", Constance.JLONGG).toString();
                    ReleaseCustomLogActivity.actionStart(mActivity, gnInfo, cat_id, cat_name);
                } else {
                    String cat_id = SPUtils.get(mActivity, Constance.GROUP_CAT_ID, "", Constance.JLONGG).toString();
                    String cat_name = SPUtils.get(mActivity, Constance.GROUP_CAT_NAME, "通用日志", Constance.JLONGG).toString();
                    ReleaseCustomLogActivity.actionStart(mActivity, gnInfo, cat_id, cat_name);
                }


                break;
            case R.id.btn_filter_reset:
                isHaveMoreData = true;
                findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                findViewById(R.id.rea_filter).setVisibility(View.GONE);
                bean = new LogGroupBean();
                bean.setName(gnInfo.getCur_name());
                bean.setUid(UclientApplication.getUid(mActivity));
                isFilter = false;
                onClick(tv_all_log);
                break;

        }
    }

    public void initTextColor() {
        tv_all_log.setTextColor(getResources().getColor(R.color.color_666666));
        tv_my_log.setTextColor(getResources().getColor(R.color.color_666666));
        findViewById(R.id.img_all_log).setVisibility(View.INVISIBLE);
        findViewById(R.id.img_my_log).setVisibility(View.INVISIBLE);
//        bean = null;
    }

    public void showModeWindow() {
        if (wheelGridViewLogMode == null) {
            wheelGridViewLogMode = new WheelGridViewLogMode(mActivity, approvalcatlist, "选择模板");
            wheelGridViewLogMode.setListener(new WheelGridViewLogMode.WorkTimeListener() {
                @Override
                public void workTimeClick(String scrollContent, int postion, String workUtil) {
                    if (approvalcatlist.get(postion).getCat_id().equals("-1")) {
//                        if (gnInfo.getIs_senior() == 1) {
                        showAddLogModeDialog();
//                        } else {
//                            showAddVipDialog();
//                        }
                    } else {

                        ReleaseCustomLogActivity.actionStart(mActivity, gnInfo, approvalcatlist.get(postion).getCat_id(), approvalcatlist.get(postion).getCat_name());

                        if (!TextUtils.isEmpty(approvalcatlist.get(postion).getCat_name())) {
                            if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                                SPUtils.put(mActivity, Constance.TEAM_CAT_ID, approvalcatlist.get(postion).getCat_id(), Constance.JLONGG);
                                SPUtils.put(mActivity, Constance.TEAM_CAT_NAME, approvalcatlist.get(postion).getCat_name(), Constance.JLONGG);
                            } else {
                                SPUtils.put(mActivity, Constance.GROUP_CAT_ID, approvalcatlist.get(postion).getCat_id(), Constance.JLONGG);
                                SPUtils.put(mActivity, Constance.GROUP_CAT_NAME, approvalcatlist.get(postion).getCat_name(), Constance.JLONGG);
                            }

                            ((TextView) findViewById(R.id.tv_send)).setText("发" + approvalcatlist.get(postion).getCat_name());
                        }
                    }
                }
            });
        }
        wheelGridViewLogMode.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
    }

    /* 没有更多dialog */
    private LogAddModeHintDialog logAddModeHintDialog;

    /*提示添加模版对话框 */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showAddLogModeDialog() {
        logAddModeHintDialog = null;
        if (logAddModeHintDialog == null) {
            logAddModeHintDialog = new LogAddModeHintDialog(mActivity);
        }
        logAddModeHintDialog.show();
    }

    /* 提示购买vip对话框 */
    private BuyVipDialog buyVipDialog;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showAddVipDialog() {
        buyVipDialog = null;
        if (buyVipDialog == null) {
            buyVipDialog = new BuyVipDialog(mActivity, this, "如需添加更多日志模版，请订购黄金服务版");
        }
        buyVipDialog.show();
    }

    @Override
    public void buyVipClick() {
//        ConfirmVersionOrderActivity.actionStart(mActivity, gnInfo.getGroup_id());
    }

    /**
     * 重服务器获取消息记录
     */
    protected void getLogList(String s_dates) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        if (isFilter) {
            DataUtil.getFilterLogParams(params, bean);
        }
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("s_date", s_dates);
        if (type == 2 && !isFilter) {
            params.addBodyParameter("uid", bean.getUid());
        }
//        if (!TextUtils.isEmpty(submitUid)) {
//            params.addBodyParameter("uid", submitUid);
//        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_LOG_LIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
//                            try {
                        CommonJson<MessageDot> dot = CommonJson.fromJson(responseInfo.result, MessageDot.class);
                        if (dot.getState() != 0) {
                            if (isFilter) {
                                //显示重置按钮
                                findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                                findViewById(R.id.rea_filter).setVisibility(View.GONE);
                                int count = 0;
                                if (null != dot.getValues().getList()) {
                                    for (int i = 0; i < dot.getValues().getList().size(); i++) {
                                        count += dot.getValues().getList().get(i).getDay_num();
                                    }
                                }
                                ((TextView) findViewById(R.id.tv_filter_reset)).setText(Html.fromHtml("<font color='#333333'>共筛选出</font><font color='#d7252c'>" + count + "</font><font color='#333333'>条记录</font>"));
                            } else {
                                //还原初始布局
                                findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                                findViewById(R.id.rea_filter).setVisibility(View.VISIBLE);
                            }
                            s_date = dot.getValues().getS_date();
                            addListMsg(dot.getValues().getList());

                        } else {
                            DataUtil.showErrOrMsg(mActivity, dot.getErrno(), dot.getErrmsg());
                        }
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
//                                mActivity.finish();
//                            }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        if (null != mSwipeLayout) {
                            mSwipeLayout.setRefreshing(false);
                        }
                    }
                });


    }

    /**
     * 重服务器获取消息记录
     */
    protected void getMyLogList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("s_date", "");
        params.addBodyParameter("uid", UclientApplication.getUid(mActivity));
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_LOG_LIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<MessageDot> dot = CommonJson.fromJson(responseInfo.result, MessageDot.class);
                            if (dot.getState() != 0) {
                                String num = dot.getValues().getAllnum();
                                if (!TextUtils.isEmpty(num) && !num.equals("0")) {
                                    tv_my_log.setText("我的日志");
                                }
                            } else {
                                DataUtil.showErrOrMsg(mActivity, dot.getErrno(), dot.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            mActivity.finish();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        if (null != mSwipeLayout) {
                            mSwipeLayout.setRefreshing(false);
                        }
                    }
                });


    }

    /**
     * 显示数据
     *
     * @param msgDataList
     */
    public void addListMsg(List<LogGroupBean> msgDataList) {
        if (null == msgDataList) {
            msgDataList = new ArrayList<>();
        }
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
            messageOtherAdapter = new MessageLogAdapter(mActivity, msgList, gnInfo);
            lv_msg.setAdapter(messageOtherAdapter);
            lv_msg.setSelectedGroup(0);
        } else {
            messageOtherAdapter.notifyDataSetChanged();
            if (isFulsh) {
                lv_msg.setSelectedGroup(0);
            } else {
                lv_msg.setSelectedGroup(msgList.size() > 0 ? msgDataList.size() - 1 : msgDataList.size());
            }
        }
        for (int i = 0; i < msgList.size(); i++) {
            lv_msg.expandGroup(i);
        }
        mSwipeLayout.setRefreshing(false);

        if (null == msgList || msgList.size() == 0) {
            lin_message_defalut.setVisibility(View.VISIBLE);
            lv_msg.setVisibility(View.GONE);
            LUtils.e("-------------------------:111");
        } else {
            lin_message_defalut.setVisibility(View.GONE);
            lv_msg.setVisibility(View.VISIBLE);
            LUtils.e("-------------------------:222");
        }

    }

    ExpandableListView.OnGroupClickListener OnGroupClickListener = new ExpandableListView.OnGroupClickListener() {
        @Override
        public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
            return true;
        }
    };

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据

                isFulsh = false;
                loadMoreView.setVisibility(View.VISIBLE);
                getLogList(s_date);
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
     * 获取日志模版信息
     */
    protected void getapprovalCatList(final boolean isShowMode) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("os", "A");
        params.addBodyParameter("ver", AppUtils.getVersionName(mActivity));
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("type", gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? "log" : "grouplog");

        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_APPOVALCSTLIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<LogGroupBean> bean = CommonListJson.fromJson(responseInfo.result, LogGroupBean.class);
                            if (bean.getState() != 0) {
                                approvalcatlist = bean.getValues();
                                if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                                    LogGroupBean logGroupBean = new LogGroupBean();
                                    logGroupBean.setCat_id("-1");
                                    logGroupBean.setCat_name("");
                                    approvalcatlist.add(logGroupBean);
                                }
                                if (isShowMode) {
                                    showModeWindow();
                                }
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                    }
                });


    }

    private boolean isFilter;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            onClick(findViewById(R.id.btn_filter_reset));
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.RESULTCODE_FINISH) {
            isFilter = false;
            onRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE) {
            bean = (LogGroupBean) data.getSerializableExtra(MsgQualityAndSafeFilterActivity.FILTERBEAN);
            if (bean != null) {
                gnInfo.setCur_name(bean.getName());
//                gnInfo.setInviter_uid();
//                lv_msg.removeFooterView(loadMoreView);
                isHaveMoreData = false;
                isFilter = true;
            } else {
                isFilter = false;
            }
            onRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE_RESET) {
            bean = new LogGroupBean();
            bean.setName(gnInfo.getCur_name());
            bean.setUid(UclientApplication.getUid(mActivity));
            isFilter = false;
            onRefresh();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.SELECTED_ACTOR) {
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
