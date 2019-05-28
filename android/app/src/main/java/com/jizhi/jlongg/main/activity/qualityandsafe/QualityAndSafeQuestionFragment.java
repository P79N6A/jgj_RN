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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.QualityAndsafeBean;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
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
 * CName:质量，安全列表页 2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 11:40
 */

public class QualityAndSafeQuestionFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener {
    private QualityAndSafeQuestionFragment mActivity;
    //筛选条件 全部，待整改,待复查，我提交的,待我复查,待我整改
    private TextView tv_top_all, tv_top2, tv_top3, tv_top4, tv_top5, tv_top6;
    /* 加载更多 */
    private View loadMoreView;
    private ListView lv_msg;
    //消息展示适配器
    private MsgQualityAndAdapter messageOtherAdapter;
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
    private List<MessageEntity> msgList;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //消息类型
    private String msgType;
    private View view;

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.activity_message_qualityandsafe_question_230, container, false);
        initView();
        getIntentData();
        return view;
    }

    @Override
    protected void onFragmentVisibleChange(boolean isVisible) {
        if (isVisible) {
//            //更新界面数据，如果数据还在下载中，就显示加载框
        } else {
//            //关闭加载框
            mSwipeLayout.setRefreshing(false);
        }
    }

    @Override
    protected void onFragmentFirstVisible() {
        autoRefresh();
    }

    public void initView() {
        mActivity = QualityAndSafeQuestionFragment.this;
        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.swipe_layout);
        lin_message_defalut = (LinearLayout) view.findViewById(R.id.lin_message_def);
        img_top = (ImageView) view.findViewById(R.id.img_top);
        lv_msg = (ListView) view.findViewById(R.id.listView);
        tv_top_all = (TextView) view.findViewById(R.id.tv_top_all);
        tv_top2 = (TextView) view.findViewById(R.id.tv_top2);
        tv_top3 = (TextView) view.findViewById(R.id.tv_top3);
        tv_top4 = (TextView) view.findViewById(R.id.tv_top4);
        tv_top5 = (TextView) view.findViewById(R.id.tv_top5);
        tv_top6 = (TextView) view.findViewById(R.id.tv_top6);
        tv_top_all.setOnClickListener(this);
        tv_top2.setOnClickListener(this);
        tv_top3.setOnClickListener(this);
        tv_top4.setOnClickListener(this);
        tv_top5.setOnClickListener(this);
        tv_top6.setOnClickListener(this);
        img_top.setOnClickListener(this);
        view.findViewById(R.id.btn_filter_reset).setOnClickListener(this);
        view.findViewById(R.id.rb_filter).setOnClickListener(this);
        view.findViewById(R.id.rea_filter_reset).setOnClickListener(this);
        mSwipeLayout.setOnRefreshListener(mActivity);
        new SetColor(mSwipeLayout);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        lv_msg.addFooterView(loadMoreView, null, false);
        msgList = new ArrayList<>();
        lv_msg.setOnScrollListener(this);
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
        msgType = getActivity().getIntent().getStringExtra(Constance.MSG_TYPE);
        if (TextUtils.isEmpty(msgType)) {
            CommonMethod.makeNoticeLong(getActivity(), "消息类型错误", CommonMethod.SUCCESS);
            getActivity().finish();
            return;
        }

    }

    @Override
    public void onClick(View v) {
        initTextColor();
        switch (v.getId()) {
            case R.id.tv_top_all:
                status = 0;
                uid = "";
                bean = null;
                tv_top_all.setTextColor(getResources().getColor(R.color.app_color));
//                onRefresh();
                autoRefresh();
                break;
            case R.id.tv_top2:
                status = 1;
                uid = "";
                bean = null;
                tv_top2.setTextColor(getResources().getColor(R.color.app_color));
                autoRefresh();
                break;
            case R.id.tv_top3:
                status = 2;
                uid = "";
                bean = null;
                tv_top3.setTextColor(getResources().getColor(R.color.app_color));
                autoRefresh();
                break;
            case R.id.tv_top4:
                status = 0;
                uid = UclientApplication.getUid(getActivity());
                tv_top4.setTextColor(getResources().getColor(R.color.app_color));
                bean = null;
                autoRefresh();
                break;
            case R.id.tv_top5:
                status = 2;
                bean = null;
                uid = UclientApplication.getUid(getActivity());
                tv_top5.setTextColor(getResources().getColor(R.color.app_color));
                view.findViewById(R.id.view_red5).setVisibility(View.GONE);//质量问题待我整改
                autoRefresh();
                break;
            case R.id.tv_top6:
                status = 1;
                bean = null;
                uid = UclientApplication.getUid(getActivity());
                tv_top6.setTextColor(getResources().getColor(R.color.app_color));
                view.findViewById(R.id.view_red6).setVisibility(View.GONE);//质量问题待我复查
                autoRefresh();
                break;
            case R.id.btn_filter_reset:
                view.findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                view.findViewById(R.id.rea_filter).setVisibility(View.GONE);
                onClick(tv_top_all);
                break;
            case R.id.img_top:
                lv_msg.setSelection(0);
                break;
            case R.id.rb_filter:
            case R.id.rea_filter_reset:
                status = 0;
                uid = "";
                bean = null;
                MsgQualityAndSafeFilterActivity.actionStart(getActivity(), gnInfo,0,
                            null);
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
        this.bean = bean;
        messageOtherAdapter=null;
        autoRefresh();
    }

    /**
     * 重服务器获取消息记录
     */
    protected void getMsgList(final int page) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        if (null != bean) {
            DataUtil.getFilterParams(params, bean);
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
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_QUALITYANDSAFELIST,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<QualityAndsafeBean> beans = CommonJson.fromJson(responseInfo.result, QualityAndsafeBean.class);

                                if (beans.getState() != 0) {
                                    if (null != bean) {
                                        //显示重置按钮
                                        view.findViewById(R.id.rea_filter_reset).setVisibility(View.VISIBLE);
                                        view.findViewById(R.id.rea_filter).setVisibility(View.GONE);
                                        if(page==1 ){
                                            ((TextView) view.findViewById(R.id.tv_filter_reset)).setText(Html.fromHtml("<font color='#333333'>共筛选出</font><font color='#d7252c'>" + beans.getValues().getList_counts() + "</font><font color='#333333'>条记录</font>"));
                                        }
                                    } else {
                                        //还原初始布局
                                        view.findViewById(R.id.rea_filter_reset).setVisibility(View.GONE);
                                        view.findViewById(R.id.rea_filter).setVisibility(View.VISIBLE);
                                    }
                                    if (beans.getValues().getInspect_red() == 1) {
                                        getActivity().findViewById(R.id.view_check_red_circle).setVisibility(View.VISIBLE);
                                    } else {
                                        getActivity().findViewById(R.id.view_check_red_circle).setVisibility(View.GONE);
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
                            if (null != mSwipeLayout) {
                                mSwipeLayout.setRefreshing(false);
                            }
                            bean = null;
                            pg -= 1;
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
            messageOtherAdapter = new MsgQualityAndAdapter(getActivity(), msgList, gnInfo);
            lv_msg.setAdapter(messageOtherAdapter);
            lv_msg.setSelection(0);
            LUtils.e("-------000----------");
        } else {
            messageOtherAdapter.notifyDataSetChanged();
            if (isFulsh) {
                LUtils.e("-------111----------");
                lv_msg.setSelection(0);
            } else {
                LUtils.e("-------222----------");
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

    public void setNumber(QualityAndsafeBean bean) {
        if (((MsgQualityAndSafeFragmentActivity) getActivity()).getCurrentIndex() == 1) {
            //检查红点红点
            if (bean.getInspect_red() == 1) {
                getActivity().findViewById(R.id.view_check_red_circle).setVisibility(View.VISIBLE);
            } else {
                getActivity().findViewById(R.id.view_check_red_circle).setVisibility(View.GONE);
            }
        }

        //筛选条件 全部，待整改,待复查，我提交的,待我复查,待我整改
        //待整改
        if (!TextUtils.isEmpty(bean.getIs_statu_rect()) && !bean.getIs_statu_rect().equals("0")) {
            tv_top2.setText("待整改(" + bean.getIs_statu_rect() + ")");
        } else {
            tv_top2.setText("待整改");
        }
        //待复查
        if (!TextUtils.isEmpty(bean.getIs_statu_check()) && !bean.getIs_statu_check().equals("0")) {
            tv_top3.setText("待复查(" + bean.getIs_statu_check() + ")");
        } else {
            tv_top3.setText("待复查");
        }
        //待我复查
        if (!TextUtils.isEmpty(bean.getCheck_me()) && !bean.getCheck_me().equals("0")) {
            tv_top5.setText("待我复查(" + bean.getCheck_me() + ")");
            LUtils.e("---------待我复查11-------:" + bean.getCheck_me());
        } else {
            tv_top5.setText("待我复查");
            LUtils.e("---------待我复查22-------:" + bean.getCheck_me());
        }
        //待我整改
        if (!TextUtils.isEmpty(bean.getRect_me()) && !bean.getRect_me().equals("0")) {
            LUtils.e("---------待我整改11-------:" + bean.getRect_me());
            tv_top6.setText("待我整改(" + bean.getRect_me() + ")");
        } else {
            LUtils.e("---------待我整改22-------:" + bean.getRect_me());
            tv_top6.setText("待我整改");
        }

        //待我整改红点
        if (bean.getRect_me_red() == 1) {
            view.findViewById(R.id.view_red6).setVisibility(View.VISIBLE);
        } else {
            view.findViewById(R.id.view_red6).setVisibility(View.GONE);
        }
        //待我复查红点
        if (bean.getCheck_me_red() == 1) {
            view.findViewById(R.id.view_red5).setVisibility(View.VISIBLE);
        } else {
            view.findViewById(R.id.view_red5).setVisibility(View.GONE);
        }
        //铃铛红点标识，1：显示红点
        if (bean.getIs_new_message() == 1) {
            ((ImageView) getActivity().findViewById(R.id.right_image_filter)).setImageResource(R.drawable.icon_quality_msg_red);
        } else {
            ((ImageView) getActivity().findViewById(R.id.right_image_filter)).setImageResource(R.drawable.icon_quality_msg);
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

//    @Override
//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        LUtils.e("------------11111-------");
//        super.onActivityResult(requestCode, resultCode, data);
//        if (requestCode == Constance.REQUESTCODE_START && (resultCode == Constance.RESULTCODE_FINISH || resultCode == RectificationInstructionsActivity.FINISH)) {
//            autoRefresh();
//        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE) {
//            bean = (QuqlityAndSafeBean) data.getSerializableExtra(MsgQualityAndSafeFilterActivity.FILTERBEAN);
//            if (bean != null) {
//                isHaveMoreData = true;
//                autoRefresh();
//            }
//            getActivity().finish();
//        }
//    }


}
