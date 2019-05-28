package com.jizhi.jlongg.main.activity;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.TypeEvaluator;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Point;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.RecordWorkConfirmAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountSwitchConfirm;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.RecordWorkConfirmMonth;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ResizeAnimation;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageListView;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;

/**
 * 功能:待确认记工记录
 * 时间:2017年9月28日11:24:51
 * 作者:xuj
 */
public class RecordWorkConfirmActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {
    /**
     * 待确认记工 适配器
     */
    private RecordWorkConfirmAdapter adapter;
    /**
     * 是否正在执行动画
     */
    private boolean isLoadAnimation;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 1、增加“本次确认的”的记工记账数据的展示；
     * 2、我要对账界面有待确认记账记录，且不论今天之内有没有确认的记工数据，“本次确认的”入口都固定显示在右上角；
     * 3、我要对账界面无数据显示缺省状态时，不显示“本次确认的”；
     * 4、关闭“我要对账”时，不显示“本次确认的”；
     */
    private ArrayList<RecordWorkConfirmMonth> thisTimeConfirmList;
    /**
     * 本次我要确认的文本
     */
    private TextView thisTimeConfirmText;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param date          根据日期范围来显示指定数据 (可以不传 默认查询所有时间内的数据)
     * @param uid           根据指定用户id来显示指定数据 (可以不传，默认查询所有需要对账的对象)
     * @param accounts_type 根据记账工种来显示指定数据  1.点工 2.包工 3.借支 4.结算 5.包工记工天 (可以不传，默认查询所有记账方式)
     */
    public static void actionStart(Activity context, String date, String uid, String accounts_type) {
        Intent intent = new Intent(context, RecordWorkConfirmActivity.class);
        intent.putExtra(Constance.DATE, date);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.ACCOUNT_TYPE, accounts_type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     * @param date            根据日期范围来显示指定数据 (可以不传 默认查询所有时间内的数据)
     * @param uid             根据指定用户id来显示指定数据 (可以不传，默认查询所有需要对账的对象)
     * @param accounts_type   根据记账工种来显示指定数据  1.点工 2.包工 3.借支 4.结算 5.包工记工天 (可以不传，默认查询所有记账方式)
     * @param agencyGroupUser 代班长信息，当代班长点进当前页面时 需要传代班长信息
     * @param pid             项目id(主要是查看记工未确认笔数使用到这个参数如果不使用可以传0)
     * @param groupId         项目组id
     */
    public static void actionStart(Activity context, String date, String uid, String accounts_type, AgencyGroupUser agencyGroupUser, String pid, String groupId) {
        Intent intent = new Intent(context, RecordWorkConfirmActivity.class);
        intent.putExtra(Constance.DATE, date);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.ACCOUNT_TYPE, accounts_type);
        intent.putExtra(Constance.BEAN_CONSTANCE, agencyGroupUser);
        intent.putExtra(Constance.PID, pid);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    public void initConfirmAccount() {
        TextView text1 = (TextView) findViewById(R.id.confirm_account_text1);
        TextView text2 = (TextView) findViewById(R.id.confirm_account_text2);
        TextView text3 = (TextView) findViewById(R.id.confirm_account_text3);
        StringBuilder builder = new StringBuilder();
        builder.append(getHtmlLabel(false, "关闭"));
        builder.append(getHtmlLabel(true, "&nbsp;[我要对账]&nbsp;"));
        builder.append(getHtmlLabel(false, "，所有的记工记账只有自己可见，同时对方也不能查看你对他的记工记账;"));
        text1.setText(Html.fromHtml(builder.toString()));
        builder.delete(0, builder.toString().length());


        builder.append(getHtmlLabel(false, "记账双方开启"));
        builder.append(getHtmlLabel(true, "&nbsp;[我要对账]&nbsp;"));
        builder.append(getHtmlLabel(false, "，可及时查看工人/班组长对我记工记账的详细工天数;"));
        text2.setText(Html.fromHtml(builder.toString()));
        builder.delete(0, builder.toString().length());

        builder.append(getHtmlLabel(false, "如要开启"));
        builder.append(getHtmlLabel(true, "&nbsp;[我要对账]&nbsp;"));
        builder.append(getHtmlLabel(false, "，请点击"));
        builder.append(getHtmlLabel(true, "&nbsp;我的记工账本 > 记工设置 > 我要对账，"));
        builder.append(getHtmlLabel(false, "开启"));
        builder.append(getHtmlLabel(true, "&nbsp;[我要对账]"));
        text3.setText(Html.fromHtml(builder.toString()));
    }

    /**
     * 获取html标签
     *
     * @param isDarkColor
     */
    private String getHtmlLabel(boolean isDarkColor, String text) {
        if (isDarkColor) {
            return "<font color='#000000'>" + text + "</font>";
        } else {
            return "<font color='#666666'>" + text + "</font>";
        }
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RecordWorkConfirmActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.record_confirm);
        initView();
        getRecordConfirmStatus();
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                pageListView.setPageNum(1);
                mSwipeLayout.setRefreshing(true);
                getConfirmWorkInfo();
            }
        });
    }

    /**
     * 获取对账开关的状态
     */
    private void getRecordConfirmStatus() {
        AccountUtil.getRecordConfirmStatus(this, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                AccountSwitchConfirm accountSwitchConfirm = (AccountSwitchConfirm) object;
                int status = accountSwitchConfirm.getStatus();//1表示关闭 ；0:表示开启
                View view = findViewById(R.id.un_open_the_confirm_account_layout);
                if (status == 1) {
                    thisTimeConfirmText.setVisibility(View.GONE);
                    view.setVisibility(View.VISIBLE);
                    initConfirmAccount();
                } else {
                    view.setVisibility(View.GONE);
                    autoRefresh();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    private void initView() {
        setTextTitleAndRight(R.string.work_confirm, R.string.confirm_count);
        thisTimeConfirmText = findViewById(R.id.right_title);
        thisTimeConfirmText.setText("本次确认的");
        thisTimeConfirmText.setVisibility(View.GONE);
        getTextView(R.id.defaultDesc).setText("暂无需要你对账的记工\n对账完成的记工可去记工流水查看详情");
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                hideTips();
            }
        }, 3000);
        thisTimeConfirmText.setOnClickListener(this);
        findViewById(R.id.title).setOnClickListener(this);
        findViewById(R.id.rightImage).setVisibility(View.GONE);
        RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) thisTimeConfirmText.getLayoutParams();
        lp.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        thisTimeConfirmText.setLayoutParams(lp);
    }

    /**
     * 隐藏选中的动画
     */
    private void hideTips() {
        final TextView canNoOpenTips = (TextView) findViewById(R.id.clickConfirmText);
        ResizeAnimation animation = new ResizeAnimation(canNoOpenTips);
        animation.setDuration(500);
        animation.setParams(canNoOpenTips.getHeight(), 0);
        canNoOpenTips.startAnimation(animation);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                canNoOpenTips.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    private void toWorkConfirmList(RecordWorkConfirmMonth recordWorkConfirmMonth) {
        if (thisTimeConfirmList == null) {
            thisTimeConfirmList = new ArrayList<>();
        }
        thisTimeConfirmList.add(recordWorkConfirmMonth);
    }

    private void setAdapter(final ArrayList<RecordWorkConfirmMonth> list) {
        bubbleSort01(list);
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (pageNum == 1) {
            thisTimeConfirmText.setVisibility(list == null || list.isEmpty() ? View.GONE : View.VISIBLE);
        }
        if (adapter == null) {
            adapter = new RecordWorkConfirmAdapter(RecordWorkConfirmActivity.this, list, new RecordWorkConfirmAdapter.RecordWorkConfirmCallBackListener() {
                @Override
                public void search(String accountType, String accountId, int position, View itemView, View searchView) {
                    searchAccount(accountType, accountId, position, itemView, searchView);
                }

                @Override
                public void confirm(String accountId, int position, View itemView, View confirmBtn) {
                    confirmWork(accountId, position, itemView, confirmBtn);
//                    startAnimationSet(itemView, confirmBtn, position);
                }
            });
            adapter.setPageNumber(pageNum);
            pageListView.setEmptyView(findViewById(R.id.defaultLayout));
            pageListView.setAdapter(adapter);
        } else {
            adapter.setPageNumber(pageNum);
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addMoreList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
        if (list != null && list.size() < RepositoryUtil.DEFAULT_PAGE_SIZE) {
            adapter.setNoDate(true);
        }
    }

    /**
     * 获取确认记账信息
     */
    public void getConfirmWorkInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        Intent intent = getIntent();
        String date = intent.getStringExtra(Constance.DATE);
        String uid = intent.getStringExtra(Constance.UID);
        String pid = intent.getStringExtra(Constance.PID);
        String accountsType = intent.getStringExtra(Constance.ACCOUNT_TYPE);
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        AgencyGroupUser agencyGroupUser = (AgencyGroupUser) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (!TextUtils.isEmpty(date)) {
            params.addBodyParameter("date", date); //如果有日期 根据日期范围来显示指定数据
        }
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid); //根据指定用户 根据uid来显示指定数据
        }
        if (!TextUtils.isEmpty(accountsType)) {
            params.addBodyParameter("accounts_type", accountsType); //根据记账某个工种 来显示数据  1.点工 2.包工 3.借支 4.结算 5.包工记工天
        }
        if (!TextUtils.isEmpty(pid)) {
            params.addBodyParameter("pid", pid);
            params.addBodyParameter("role", UclientApplication.getRoler(getApplicationContext()));
        }
        if (TextUtils.isEmpty(groupId)) {
            if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
                params.addBodyParameter("group_id", agencyGroupUser.getGroup_id()); //代理人操作时，需要传班组id
            }
        } else {
            params.addBodyParameter("group_id", groupId); //代理人操作时，需要传班组id
        }
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        String httpUrl = NetWorkRequest.CONFIRM_WORK;
        CommonHttpRequest.commonRequest(this, httpUrl, RecordWorkConfirmMonth.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<RecordWorkConfirmMonth> list = (ArrayList<RecordWorkConfirmMonth>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 确认记账
     *
     * @param accountId 记账id
     * @param position  子类下标
     */
    public void confirmWork(String accountId, final int position, final View itemView, final View confirmBtn) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", accountId);
        AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (user != null && !TextUtils.isEmpty(user.getUid())) {
            params.addBodyParameter("group_id", user.getGroup_id()); //代理人操作时，需要传班组id
        }
        String httpUrl = NetWorkRequest.CONFIRM_ACCOUNT;
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                if (null != itemView) {
                    startAnimationSet(itemView, confirmBtn, position);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    /**
     * 查询记账详情
     *
     * @param accountType
     * @param accountId
     */
    public void searchAccount(final String accountType, final String accountId, final int position, final View itemView, final View searchView) {
        final AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        final String currentRole = user != null ? "2" : UclientApplication.getRoler(getApplicationContext());//当前角色
        String groupId = user != null ? user.getGroup_id() : "";
        AccountUtil.getPoorInfo(RecordWorkConfirmActivity.this, accountId, groupId, new AccountUtil.GetPoorInfoListener() {
            @Override
            public void loadSuccess(DiffBill bean) { //差帐信息
                CheckBillDialog showPoorDialog = new CheckBillDialog(RecordWorkConfirmActivity.this, accountType, bean, Integer.parseInt(accountId), currentRole,
                        user, new CheckBillDialog.MpoorinfoCLickListener() { //差帐dialog
                    @Override
                    public void mpporClick(DiffBill bean, String type, View agreeBtn) { //点击复制记账按钮
                        confirmWork(accountId, position, itemView, searchView);
                    }
                }, true);
                showPoorDialog.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(RecordWorkConfirmActivity.this, 0.5F);
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title://本次已确认的
                RecordWorkConfirmThisTimeActivity.actionStart(this, thisTimeConfirmList);
                break;
            case R.id.open_confirm_account_btn://开启我要对账按钮
                RecordAccountSettingActivity.actionStart(this);
                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(this, 242);
                break;
        }
    }

    public Animation getHorizontalScrollAnimation(final View view) {
        Animation animation = new Animation() { //开启横向滚动的动画
            @Override
            protected void applyTransformation(float interpolatedTime, Transformation t) {
                view.setTranslationX(view.getWidth() * interpolatedTime);
                view.setAlpha(1 - interpolatedTime);
            }
        };
        //设置动画持续时间
        animation.setDuration(400);
        return animation;
    }

    public Animation getRemoveItemAnimation(final View view) {
        final int viewHeight = view.getMeasuredHeight();
        Animation animation = new Animation() {
            @Override
            protected void applyTransformation(float interpolatedTime, Transformation t) {
                ViewGroup.LayoutParams params = view.getLayoutParams();
                if (interpolatedTime >= 1) {
                    params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                    view.setTranslationX(0);
                    view.setAlpha(1.0f);
                } else {
                    params.height = viewHeight - (int) (viewHeight * interpolatedTime);
                }
                view.setLayoutParams(params);
            }
        };
        //设置动画持续时间
        animation.setDuration(500);
        return animation;
    }


    public void startAnimationSet(final View itemView, final View confirmBtn, final int position) {
        if (isLoadAnimation) { //如果正在加载动画则不管
            return;
        }
        isLoadAnimation = true;
        //创建动画，参数表示他的子动画是否共用一个插值器
        Animation animation1 = getHorizontalScrollAnimation(itemView);
        animation1.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                Animation animation2 = getRemoveItemAnimation(itemView);
                animation2.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {

                    }

                    @Override
                    public void onAnimationEnd(Animation animation) {
                        adapter.getList().remove(position); //移除记账某天详情
                        adapter.notifyDataSetChanged();
                        isLoadAnimation = false;
                        //如果数据小于5条我们自动刷新一下数据
                        if (adapter.getCount() < 5 && pageListView.isMoreData()) {
                            autoRefresh();
                        }
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });
                itemView.startAnimation(animation2);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        playAnimation(confirmBtn, thisTimeConfirmText, position);
        itemView.startAnimation(animation1);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            adapter.notifyDataSetChanged();
        }
        if (resultCode == Constance.REFRESH_CONFIRM_ACCOUNT_STATUS) { //刷新对账开关状态按钮
            getRecordConfirmStatus();
        } else if (resultCode == Constance.ACCOUNT_UPDATE || resultCode == Constance.DISPOSEATTEND_RESULTCODE) { //已修改了记账
            getConfirmWorkInfo();
        }
    }


    @Override
    public void finish() {
        setResult(Constance.REFRESH);
        super.finish();
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getConfirmWorkInfo();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getConfirmWorkInfo();
    }


    /**
     * 冒泡法排序
     * 比较相邻的元素。如果第一个比第二个小，就交换他们两个。
     * 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最小的数。
     * 针对所有的元素重复以上的步骤，除了最后一个。
     * 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。
     *
     * @param list 需要排序的整型数组
     */
    public void bubbleSort01(ArrayList<RecordWorkConfirmMonth> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        RecordWorkConfirmMonth temp; // 记录临时中间值
        int size = list.size(); // 数组大小
        for (int i = 0; i < size - 1; i++) {
            for (int j = i + 1; j < size; j++) {
                if (list.get(i).getCreate_time() < list.get(j).getCreate_time()) { // 交换两数的位置
                    temp = list.get(i);
                    list.set(i, list.get(j));
                    list.set(j, temp);
                }
            }
        }
    }


    /**
     * 开启抛物线的动画
     *
     * @param startView
     * @param endView
     */
    public void playAnimation(View startView, View endView, final int position) {

        int[] location = new int[2];
        startView.getLocationOnScreen(location);

        final View moveView = new View(this);
        Utils.setBackGround(moveView, getResources().getDrawable(R.drawable.draw_oval_eb4e4e));
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(DensityUtil.dp2px(10), DensityUtil.dp2px(10));
        moveView.setLayoutParams(params);

        ViewGroup rootView = (ViewGroup) this.getWindow().getDecorView();
        rootView.addView(moveView);

        int[] des = new int[2];
        endView.getLocationInWindow(des);

        /*动画开始位置，也就是物品的位置;动画结束的位置，也就是购物车的位置 */
        Point startPosition = new Point(location[0], location[1]);
        Point endPosition = new Point(des[0] + endView.getWidth() / 2, des[1] + endView.getHeight() / 2);

        int pointX = (startPosition.x + endPosition.x) / 2 - DensityUtil.dp2px(35);
        int pointY = startPosition.y - DensityUtil.dp2px(68);
        Point controllPoint = new Point(pointX, pointY);

        /*
         * 属性动画，依靠TypeEvaluator来实现动画效果，其中位移，缩放，渐变，旋转都是可以直接使用
         * 这里是自定义了TypeEvaluator， 我们通过point记录运动的轨迹，然后，物品随着轨迹运动，
         * 一旦轨迹发生变化，就会调用addUpdateListener这个方法，我们不断的获取新的位置，是物品移动
         * */
        ValueAnimator valueAnimator = ValueAnimator.ofObject(new BizierEvaluator2(controllPoint), startPosition, endPosition);
        valueAnimator.setInterpolator(new AccelerateDecelerateInterpolator());
        valueAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                Point point = (Point) valueAnimator.getAnimatedValue();
                moveView.setX(point.x);
                moveView.setY(point.y);

            }
        });
        valueAnimator.setDuration(500);
        valueAnimator.start();
        /**
         * 动画结束，移除掉小圆圈
         */
        valueAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                ViewGroup rootView = (ViewGroup) RecordWorkConfirmActivity.this.getWindow().getDecorView();
                rootView.removeView(moveView);
                toWorkConfirmList(adapter.getItem(position));
                if (thisTimeConfirmList != null && !thisTimeConfirmList.isEmpty()) {
                    thisTimeConfirmText.setText("本次确认的(" + thisTimeConfirmList.size() + ")");
                }
            }
        });
    }


    /**
     * 贝塞尔曲线（二阶抛物线）
     * controllPoint 是中间的转折点
     * startValue 是起始的位置
     * endValue 是结束的位置
     */
    public class BizierEvaluator2 implements TypeEvaluator<Point> {

        private Point controllPoint;

        public BizierEvaluator2(Point controllPoint) {
            this.controllPoint = controllPoint;
        }

        @Override
        public Point evaluate(float t, Point startValue, Point endValue) {
            int x = (int) ((1 - t) * (1 - t) * startValue.x + 2 * t * (1 - t) * controllPoint.x + t * t * endValue.x);
            int y = (int) ((1 - t) * (1 - t) * startValue.y + 2 * t * (1 - t) * controllPoint.y + t * t * endValue.y);
            return new Point(x, y);
        }
    }
}
