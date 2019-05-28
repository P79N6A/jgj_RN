package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndSafeCheckAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckBean;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogDonateSeniorCloud;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
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

import java.util.ArrayList;
import java.util.List;


/**
 * CName:质量，安全检查页 2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 11:40
 */

public class QualityAndSafeCheckFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener, DialogDonateSeniorCloud.DonateSeniorCloudInterfaceClickListener {
    private QualityAndSafeCheckFragment mActivity;
    //筛选条件 全部，待整改,待复查，我提交的,待我复查,待我整改
    private TextView tv_top_alls, tv_top2s, tv_top3s, tv_top4s, tv_top5s;
    /* 加载更多 */
    private View loadMoreView;
    private ListView lv_msg;
    //消息展示适配器
    private MsgQualityAndSafeCheckAdapter messageOtherAdapter;
    // 下拉刷新
    private SwipeRefreshLayout mSwipeLayout;
    //滚动到顶部图标
    private ImageView img_top;
    //默认布局
    private LinearLayout lin_message_defalut;
    private int pg = 0;
    private int status;
    private String uid;
    //筛选的bean
    private QuqlityAndSafeBean bean;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    //聊天数据
    private List<QualityAndsafeCheckMsgBean> msgList;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //消息类型
    private String msgType;
    private View view;

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.activity_message_qualityandsafe_check_230, container, false);
        initView(view);
        getIntentData();
        return view;
    }

    @Override
    protected void onFragmentVisibleChange(boolean isVisible) {
        if (isVisible) {
//            //更新界面数据，如果数据还在下载中，就显示加载框
//            notifyDataSetChanged();
//            if (mRefreshState == STATE_REFRESHING) {
//                mRefreshListener.onRefreshing();
//            }
        } else {
//            //关闭加载框
            mSwipeLayout.setRefreshing(false);
            ;
        }
    }

    @Override
    protected void onFragmentFirstVisible() {
        if (gnInfo.getIs_senior() == 1) {
            view.findViewById(R.id.rea_default_button).setVisibility(View.GONE);
            view.findViewById(R.id.rea_filter_check).setVisibility(View.VISIBLE);
            view.findViewById(R.id.rea_top).setVisibility(View.VISIBLE);
            getActivity().findViewById(R.id.lin_send).setVisibility(View.VISIBLE);
            ((TextView) getActivity().findViewById(R.id.tv_toact)).setText(getString(R.string.release_check));
            autoRefresh();
        } else {
            initNotVipView(view);
        }
    }

    /**
     * 初始化view
     */
    public void initView(View view) {
        mActivity = QualityAndSafeCheckFragment.this;
        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.swipe_layout);
        lin_message_defalut = (LinearLayout) view.findViewById(R.id.lin_message_def);
        img_top = (ImageView) view.findViewById(R.id.img_top);
        lv_msg = (ListView) view.findViewById(R.id.listView);
        tv_top_alls = (TextView) view.findViewById(R.id.tv_top_alls);
        tv_top2s = (TextView) view.findViewById(R.id.tv_top2s);
        tv_top3s = (TextView) view.findViewById(R.id.tv_top3s);
        tv_top4s = (TextView) view.findViewById(R.id.tv_top4s);
        tv_top5s = (TextView) view.findViewById(R.id.tv_top5s);
        tv_top_alls.setOnClickListener(this);
        tv_top2s.setOnClickListener(this);
        tv_top3s.setOnClickListener(this);
        tv_top4s.setOnClickListener(this);
        tv_top5s.setOnClickListener(this);
        img_top.setOnClickListener(this);
        view.findViewById(R.id.btn_filter_reset).setOnClickListener(this);
        view.findViewById(R.id.rb_filter_check).setOnClickListener(this);
        view.findViewById(R.id.rea_filter_reset).setOnClickListener(this);
        view.findViewById(R.id.rea_filter_check).setVisibility(View.VISIBLE);
        mSwipeLayout.setOnRefreshListener(mActivity);
        new SetColor(mSwipeLayout);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        lv_msg.addFooterView(loadMoreView, null, false);
        msgList = new ArrayList<>();
        lv_msg.setOnScrollListener(this);

    }

    @Override
    public void donateSeniorCloudSuccess() {
        gnInfo.setIs_senior(1);
        initView(getView());
        onFragmentFirstVisible();
    }

    public void initNotVipView(View view) {
        view.findViewById(R.id.rea_top).setVisibility(View.GONE);
        getActivity().findViewById(R.id.rea_default_button).setVisibility(View.VISIBLE);
        TextView tv_help = (TextView) view.findViewById(R.id.tv_help);
        Button btn_buy = (Button) view.findViewById(R.id.btn_buy);
        RadioButton rb_state = (RadioButton) view.findViewById(R.id.rb_state);
        if (gnInfo.getIs_buyed() == 0) {
            rb_state.setVisibility(View.VISIBLE);
        } else {
            rb_state.setVisibility(View.GONE);
        }
        tv_help.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
                    //质量检查
                    X5WebViewActivity.actionStart(getActivity(), NetWorkRequest.HELPDETAIL + 99);
                } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
                    //安全检查
                    X5WebViewActivity.actionStart(getActivity(), NetWorkRequest.HELPDETAIL + 100);
                }

            }
        });

        rb_state.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new DialogDonateSeniorCloud(getActivity(), gnInfo.getGroup_id(), mActivity).show();

            }
        });
        btn_buy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO 此处跳转订单页面
//                ConfirmVersionOrderNewActivity.actionStart(getActivity(), gnInfo.getGroup_id());
            }
        });

    }

    /**
     * 显示listView 底部加载对话框
     *
     * @return
     */
    public View loadMoreDataView() {
        View foot_view = getActivity().getLayoutInflater().inflate(R.layout.foot_loading_dialog, null); // 加载对话框
        foot_view.setVisibility(View.GONE);
        return foot_view;
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getActivity().getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
//        vip = gnInfo.getIs_senior();
        msgType = getActivity().getIntent().getStringExtra(Constance.MSG_TYPE);
        if (TextUtils.isEmpty(msgType)) {
            CommonMethod.makeNoticeLong(getActivity(), "消息类型错误", CommonMethod.SUCCESS);
            getActivity().finish();
            return;
        }

    }

    /**
     * 是否订购过会员
     */
    private void isBuyVip() {
        messageOtherAdapter = new MsgQualityAndSafeCheckAdapter(getActivity(), new ArrayList<QualityAndsafeCheckMsgBean>(), gnInfo);
        lv_msg.setAdapter(messageOtherAdapter);
        View headerView = getActivity().getLayoutInflater().inflate(R.layout.layout_default_button, null);
        lv_msg.addHeaderView(headerView);
        view.findViewById(R.id.rea_filters).setVisibility(View.GONE);
        view.findViewById(R.id.lin_message_def).setVisibility(View.GONE);
        getActivity().findViewById(R.id.lin_send).setVisibility(View.GONE);
    }

    @Override
    public void onClick(View v) {
        initTextColor();
        switch (v.getId()) {
            case R.id.tv_top_alls:
                status = 0;
                uid = "";
                bean = null;
                tv_top_alls.setTextColor(getResources().getColor(R.color.app_color));
                autoRefresh();
                break;
            case R.id.tv_top2s:
                status = 1;
                uid = "";
                bean = null;
                tv_top2s.setTextColor(getResources().getColor(R.color.app_color));
                autoRefresh();
                break;
            case R.id.tv_top3s:
                status = 3;
                uid = "";
                bean = null;
                tv_top3s.setTextColor(getResources().getColor(R.color.app_color));
                autoRefresh();
                break;
            case R.id.tv_top4s:
                status = 0;
                uid = UclientApplication.getUid(getActivity());
                tv_top4s.setTextColor(getResources().getColor(R.color.app_color));
                bean = null;
                autoRefresh();
                break;
            case R.id.tv_top5s:
                status = 1;
                bean = null;
                uid = UclientApplication.getUid(getActivity());
                tv_top5s.setTextColor(getResources().getColor(R.color.app_color));
                view.findViewById(R.id.view_red5s).setVisibility(View.GONE);//质量检查待我检查
                autoRefresh();
                break;
            case R.id.btn_filter_reset:
                view.findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                view.findViewById(R.id.rea_filter_check).setVisibility(View.GONE);
                onClick(tv_top_alls);
                break;
            case R.id.img_top:
                lv_msg.setSelection(0);
                break;
            case R.id.rb_filter_check:
                status = 0;
                uid = "";
                bean = null;
                MsgQualityAndSafeFilterCheckActivity.actionStart(getActivity(), gnInfo);
                break;
            case R.id.rea_filter_reset:
                status = 0;
                uid = "";
                bean = null;
                MsgQualityAndSafeFilterCheckActivity.actionStart(getActivity(), gnInfo);
                break;
        }

    }

    public void initTextColor() {
        tv_top_alls.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top2s.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top3s.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top4s.setTextColor(getResources().getColor(R.color.color_666666));
        tv_top5s.setTextColor(getResources().getColor(R.color.color_666666));
        bean = null;
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

    @Override
    public void onRefresh() {
        isFulsh = true;
        isHaveMoreData = true;
        pg = 1;
        getMsgList(pg);
    }

    public void onFilterRefresh(QuqlityAndSafeBean bean) {
//        isFulsh = true;
        messageOtherAdapter = null;
        this.bean = bean;
        autoRefresh();
    }

    /**
     * 重服务器获取消息记录
     */
    protected void getMsgList(final int page) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        if (null != bean) {
            DataUtil.getFilterCheckParams(params, bean);
        }
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("msg_type", getActivity().getIntent().getStringExtra(Constance.MSG_TYPE));
        params.addBodyParameter("pg", page + "");
        if (status != 0) {
            params.addBodyParameter("status", status + "");
        }
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_PUBINSPECLIST,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<QualityAndsafeCheckBean> beans = CommonJson.fromJson(responseInfo.result, QualityAndsafeCheckBean.class);

                                if (beans.getState() != 0) {
                                    if (null != bean) {
                                        //显示重置按钮
                                        view.findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                                        view.findViewById(R.id.rea_filter_check).setVisibility(View.GONE);
                                        ((TextView) view.findViewById(R.id.tv_filter_reset)).setText(Html.fromHtml("<font color='#333333'>共筛选出</font><font color='#d7252c'>" + beans.getValues().getAllnum() + "</font><font color='#333333'>条记录</font>"));
                                    } else {
                                        //还原初始布局
                                        view.findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                                        view.findViewById(R.id.rea_filter_check).setVisibility(View.VISIBLE);
                                    }

                                    addListMsg(beans.getValues().getList());
                                    setNumber(beans.getValues());
                                } else {
                                    DataUtil.showErrOrMsg(getActivity(), beans.getErrno(), beans.getErrmsg());
                                    getActivity().finish();
                                }
                            } catch (Exception e) {
                                pg -= 1;
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                                getActivity().finish();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            bean = null;
                            pg -= 1;
                            if (null != mSwipeLayout) {
                                mSwipeLayout.setRefreshing(false);
                            }
                        }
                    });


    }
//    public  void setDot(QualityAndsafeCheckBean bean){
//        if (bean.getQuality_red() == 1) {
//            getActivity().findViewById(R.id.view_question_red_circle).setVisibility(View.VISIBLE);
//        } else {
//            getActivity().findViewById(R.id.view_question_red_circle).setVisibility(View.GONE);
//        }
//    }

    /**
     * 显示数据
     *
     * @param msgDataList
     */
    public void addListMsg(List<QualityAndsafeCheckMsgBean> msgDataList) {

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
            LUtils.e("-------000----------");
            messageOtherAdapter = new MsgQualityAndSafeCheckAdapter(getActivity(), msgList, gnInfo);
            lv_msg.setAdapter(messageOtherAdapter);
            lv_msg.setSelection(0);
        } else {
            messageOtherAdapter.notifyDataSetChanged();
            if (isFulsh) {
                LUtils.e("-------1111----------");
                lv_msg.setSelection(0);
            } else {
                LUtils.e("-------2222----------");
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

    public void setNumber(QualityAndsafeCheckBean bean) {

//        if (((MsgQualityAndSafeFragmentActivity) getActivity()).getCurrentIndex() == 0) {
//            //质量问题红点
//            if (bean.getQuality_red() == 1) {
//                getActivity().findViewById(R.id.view_question_red_circle).setVisibility(View.VISIBLE);
//            } else {
//                getActivity().findViewById(R.id.view_question_red_circle).setVisibility(View.GONE);
//            }
//        }

        //待检查
        if (bean.getCheck() != 0) {
            tv_top2s.setText("待检查(" + bean.getCheck() + ")");
        } else {
            tv_top2s.setText("待检查");
        }
        //待我检查
        if (bean.getCheck_me() != 0) {
            tv_top5s.setText("待我检查(" + bean.getCheck_me() + ")");
        } else {
            tv_top5s.setText("待我检查");
        }
        //待我检查红点
        if (bean.getCheck_me_red() == 1) {
            view.findViewById(R.id.view_red5s).setVisibility(View.VISIBLE);
        } else {
            view.findViewById(R.id.view_red5s).setVisibility(View.GONE);
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
}
