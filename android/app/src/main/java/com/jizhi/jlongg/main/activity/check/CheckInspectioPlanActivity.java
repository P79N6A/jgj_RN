package com.jizhi.jlongg.main.activity.check;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.CheckInspLanAdapter;
import com.jizhi.jlongg.main.adpter.InspecrPlanMemberAdapter;
import com.jizhi.jlongg.main.bean.CheckListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogCheckMore;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
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
 * CName:检查计划2.3.4
 * User: hcs
 * Date: 2017-11-22
 * Time: 11:21
 */

public class CheckInspectioPlanActivity extends BaseActivity {
    private CheckInspectioPlanActivity mActivity;
    /*组信息*/
    private GroupDiscussionInfo gnInfo;
    /*检查id*/
    private String plan_id;
    /*更多弹窗*/
    private DialogCheckMore dialogCheckMore;
    /*listview*/
    private ListView listview;
    /*listview头部信息*/
    private View headerView;
    /*adapter*/
    private CheckInspLanAdapter checkInspLanAdapter;
    private List<CheckListBean> msgList;
    private int is_operate;////可以操作权限
    /*是否刷新数据*/
    private boolean isFlushData;
    private SpringView springView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_insplan_check);
        registerFinishActivity();
        getIntentData();
        initView();

    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String plan_id) {
        Intent intent = new Intent(context, CheckInspectioPlanActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.INSPLAN_ID, plan_id);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        plan_id = getIntent().getStringExtra(Constance.INSPLAN_ID);
        if (null != gnInfo && gnInfo.getIs_closed() == 1) {
            findViewById(R.id.right_title).setVisibility(View.GONE);
        }
    }

    /**
     * 初始化view
     */
    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), "检查计划");
        ((TextView) findViewById(R.id.right_title)).setText("更多");

        mActivity = CheckInspectioPlanActivity.this;
        listview = findViewById(R.id.listview);
        headerView = getLayoutInflater().inflate(R.layout.layout_head_inspection_plan, null);
        msgList = new ArrayList<>();
        listview.addHeaderView(headerView);
        checkInspLanAdapter = new CheckInspLanAdapter(mActivity, msgList, gnInfo, plan_id);
        listview.setAdapter(checkInspLanAdapter);

        headerView.setVisibility(View.GONE);
        springView = findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setEnableFooter(false);
        springView.setHeader(new DefaultHeader(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                getInsplanList();
            }

            @Override
            public void onLoadmore() {
            }
        });
    }


    /**
     * 设置顶部内容
     */
    private void setHeadData(CheckListBean checkListBean) {
        headerView.setVisibility(View.VISIBLE);
        is_operate = checkListBean.getIs_operate();
        if (is_operate == 1) {
            initRightImageLog();
        } else {
            findViewById(R.id.right_title).setVisibility(View.GONE);
        }

        RadioButton rb_content = (RadioButton) headerView.findViewById(R.id.rb_content);
        TextView tv_level = (TextView) headerView.findViewById(R.id.tv_level);
        TextView tv_time = (TextView) headerView.findViewById(R.id.tv_time);
        TextView tv_state = (TextView) headerView.findViewById(R.id.tv_state);
        rb_content.setText(checkListBean.getPlan_name());
        tv_level.setText("通过率" + checkListBean.getPass_percent() + "%");
        tv_time.setText(checkListBean.getExecute_time());
        if (checkListBean.getExecute_percent().equals("0")) {
            tv_state.setText("未开始");
            Utils.setBackGround(tv_state, getResources().getDrawable(R.drawable.bg_999999_3radius));
        } else if (checkListBean.getExecute_percent().equals("100")) {
            tv_state.setText("已完成");
            Utils.setBackGround(tv_state, getResources().getDrawable(R.drawable.bg_83c76e_3radius));
        } else {
            tv_state.setText("进行中" + checkListBean.getExecute_percent() + "%");
            Utils.setBackGround(tv_state, getResources().getDrawable(R.drawable.draw_bg_f9a00f_3radius));
        }
        //设置列表适配器
        checkInspLanAdapter = new CheckInspLanAdapter(mActivity, checkListBean.getPro_list(), gnInfo, checkListBean.getPlan_id());
        listview.setAdapter(checkInspLanAdapter);

        //设置执行人适配器
        GridView gridView = (GridView) headerView.findViewById(R.id.gridView);
        gridView.setAdapter(new InspecrPlanMemberAdapter(this, checkListBean.getMember_list()));
    }

    public void initRightImageLog() {
//        ImageView imageView = (ImageView) findViewById(R.id.rightImage);
//        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
//        params.width = ViewGroup.LayoutParams.WRAP_CONTENT;
//        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
//        imageView.setLayoutParams(params);
//        imageView.setImageResource(R.drawable.red_dots);
        findViewById(R.id.right_title).setVisibility(View.VISIBLE);
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideSoftKeyboard();
                if (dialogCheckMore == null) {
                    dialogCheckMore = new DialogCheckMore(mActivity, gnInfo, "是否删除该检查计划？", is_operate, plan_id);
                }
                //这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                dialogCheckMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
            }
        });
    }


    /**
     * 获取检查计划详情
     */
    protected void getInsplanList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        // 检查计划id
        params.addBodyParameter("plan_id", plan_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECTPLAN_INFO,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CheckListBean> bean = CommonJson.fromJson(responseInfo.result, CheckListBean.class);
                            if (bean.getState() != 0) {
                                setHeadData(bean.getValues());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            springView.onFinishFreshAndLoad();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        springView.onFinishFreshAndLoad();
                        finish();
                    }
                });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && (resultCode == Constance.RESULTCODE_FINISH || resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN)) {
            //刷新数据
            getInsplanList();
            isFlushData = true;
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN) {
            //刷新数据
            getInsplanList();
            isFlushData = true;
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }

    @Override
    public void onFinish(View view) {
        if (isFlushData) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        if (isFlushData) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
