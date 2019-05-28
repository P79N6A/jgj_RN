package com.jizhi.jlongg.main.activity.check;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.checkplan.NewOrUpdateCheckContentActivity;
import com.jizhi.jlongg.main.activity.checkplan.NewPlanActivity;
import com.jizhi.jlongg.main.adpter.MsgCheckListAdapter;
import com.jizhi.jlongg.main.bean.CheckListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SetTitleName;
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
 * CName:检查列表2.3.4
 * User: hcs
 * Date: 2017-11-21
 * Time: 16:21
 */

public class MsgCheckListActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener, View.OnClickListener {
    private MsgCheckListActivity mActivity;
    /*组信息*/
    private GroupDiscussionInfo gnInfo;
    /* 下拉刷新*/
    private SwipeRefreshLayout mSwipeLayout;
    /*聊天集合 */
    private List<CheckListBean> msgList;
    private ListView lv_msg;
    /*消息展示适配器 */
    private MsgCheckListAdapter msgCheckListAdapter;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 默认布局lin_message_defalut */
    private RelativeLayout layout_default, lin_message_defalut;
    /* 加载更多 */
    private View loadMoreView;
    //滚动到顶部图标
    private ImageView img_top;
    private int pg = 0;
    private int check_type;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_list);
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
    public static void actionStart(Activity context, GroupDiscussionInfo info, int check_type) {
        Intent intent = new Intent(context, MsgCheckListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_INT, check_type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
//        gnInfo.setGroup_id(60 + "");
        //check_type:0所有计划-->null  check_type:1已完成-->status=3 check_type:待我执行2-->my_oper=1 check_type:我创建的3-->my_oper=1;
        check_type = getIntent().getIntExtra(Constance.BEAN_INT, 0);
        if (check_type == 1) {
            SetTitleName.setTitle(findViewById(R.id.title), "已完成");
        } else if (check_type == 2) {
            SetTitleName.setTitle(findViewById(R.id.title), "待我执行");
        } else if (check_type == 3) {
            SetTitleName.setTitle(findViewById(R.id.title), "我创建的");
        } else {
            SetTitleName.setTitle(findViewById(R.id.title), "所有计划");
        }
//        if (gnInfo.getIs_closed() == 1) {
//            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
//            if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
//                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.team_closed_icon));
//            } else {
//                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.group_closed_icon));
//            }
//        }
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = MsgCheckListActivity.this;
        lv_msg =  findViewById(R.id.listView);
        getImageView(R.id.rightImage).setVisibility(View.GONE);
        lin_message_defalut =  findViewById(R.id.emptyview);
        layout_default = findViewById(R.id.layout_default);
        img_top =  findViewById(R.id.img_top);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        mSwipeLayout =  findViewById(R.id.swipe_layout);
        mSwipeLayout.setOnRefreshListener(this);
        lv_msg.setOnScrollListener(this);
        new SetColor(mSwipeLayout);
        lv_msg.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                CheckInspectioPlanActivity.actionStart(mActivity, gnInfo, "11");
            }
        });
        findViewById(R.id.viewHelp).setOnClickListener(this);
        View defaultText = findViewById(R.id.defaultText);
        img_top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lv_msg.setSelection(0);
            }
        });
        if (gnInfo.getIs_closed() == 0) {
            defaultText.setVisibility(View.VISIBLE);
            defaultText.setOnClickListener(this);
        } else {
            defaultText.setVisibility(View.GONE);
        }
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

    /**
     * 重服务器获取消息记录
     */
    protected void getMsgList(final int page) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("pg", page + "");
        params.addBodyParameter("pagesize", 20 + "");
        check_type = getIntent().getIntExtra(Constance.BEAN_INT, 0);
        if (check_type == 1) {
            //已完成
            params.addBodyParameter("status", "3");
        } else if (check_type == 2) {
            //待我执行
            params.addBodyParameter("my_oper", "1");
        } else if (check_type == 3) {
            //我创建的
            params.addBodyParameter("my_creater", "1");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECTPLANLIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
//                            try {
                        CommonListJson<CheckListBean> beans = CommonListJson.fromJson(responseInfo.result, CheckListBean.class);
                        if (beans.getState() != 0) {
                            addListMsg(beans.getValues());
                        } else {
                            DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                            finish();
                        }
//                            } catch (Exception e) {
//                                pg -= 1;
//                                e.printStackTrace();
//                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
//                                finish();
//                            }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
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
    public void addListMsg(List<CheckListBean> msgDataList) {
        if (null == msgList) {
            msgList = new ArrayList<>();
        }

        if (isFulsh) {
            mSwipeLayout.setRefreshing(false);
            if (msgDataList.size() == 0) {
                if (check_type != 3) {
                    lin_message_defalut.setVisibility(View.VISIBLE);
                    layout_default.setVisibility(View.GONE);
                } else {
                    lin_message_defalut.setVisibility(View.GONE);
                    layout_default.setVisibility(View.VISIBLE);
                }

                lv_msg.setVisibility(View.GONE);
                return;
            }
            lin_message_defalut.setVisibility(View.GONE);
            layout_default.setVisibility(View.GONE);
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
        if (null == msgCheckListAdapter) {
            msgCheckListAdapter = new MsgCheckListAdapter(mActivity, msgList, gnInfo);
            lv_msg.setAdapter(msgCheckListAdapter);
            lv_msg.setSelection(0);
        } else {
            msgCheckListAdapter.notifyDataSetChanged();
            if (isFulsh) {
                lv_msg.setSelection(0);
            } else {
                lv_msg.setSelection(msgList.size() > 0 ? msgList.size() - msgDataList.size() : msgDataList.size());
            }
        }
        mSwipeLayout.setRefreshing(false);

        if (null == msgList || msgList.size() == 0) {
            if (check_type != 3) {
                lin_message_defalut.setVisibility(View.VISIBLE);
                layout_default.setVisibility(View.GONE);
            } else {
                lin_message_defalut.setVisibility(View.GONE);
                layout_default.setVisibility(View.VISIBLE);
            }
            lv_msg.setVisibility(View.GONE);
        } else {
            lin_message_defalut.setVisibility(View.GONE);
            layout_default.setVisibility(View.GONE);
            lv_msg.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                LUtils.e("-------22222--------");
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            //筛选回调
            autoRefresh();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN) {
            //新建计划
            autoRefresh();
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.viewHelp: //查看帮助
                HelpCenterUtil.actionStartHelpActivity(mActivity, 141);
                break;
            case R.id.defaultText: //无数据时新建计划按钮
                if (gnInfo.getIs_closed() == 1) {
                    return;
                }
                NewPlanActivity.actionStart(mActivity, gnInfo.getGroup_id(), gnInfo.getGroup_name(), -1, NewOrUpdateCheckContentActivity.CREATE_CHECK);
                break;

        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
