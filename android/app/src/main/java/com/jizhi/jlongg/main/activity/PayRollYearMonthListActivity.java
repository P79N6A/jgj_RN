package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PayRollItemAdapter;
import com.jizhi.jlongg.main.bean.PayRollItem;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CustomListView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能: 工资清单 人物 年月列表详情
 * 作者：Xuj
 * 时间: 2016-7-19 11:10
 */
public class PayRollYearMonthListActivity extends BaseActivity {

//    /**
//     * 是否在加载动画
//     */
//    private boolean isLoadingAnim;
//    /**
//     * 数据列表
//     */
//    private CustomListView listView;
//    /**
//     * 滑动布局
//     */
//    private LinearLayout scrollLayout;
    /**
     * 未滑动时显示的布局
     */
    private View unScrollView;
    /**
     * 适配器
     */
    private PayRollItemAdapter adapter;


    /**
     * 查询网络请求 填充数据
     */
    private void fillData(PayRollList bean) {
        fillBaseData(bean);
        final List<PayRollList> adapterList = new ArrayList<>();
        List<PayRollItem> payList = bean.getList();
        if (payList != null && payList.size() > 0) {
            for (PayRollItem p : payList) {
                List<PayRollList> mPayList = p.getList();
                for (PayRollList mBean : mPayList) {
                    mBean.setYear(p.getYear());
                    adapterList.add(mBean);
                }
            }
            adapter.update(adapterList);
        }
    }


    /**
     * @param context
     * @param targetId  项目id
     * @param classType person：按个人（默认）;project:按项目
     */
    public static void actionStart(Activity context, String targetId, String classType, String targetTitle) {
        Intent intent = new Intent(context, PayRollYearMonthListActivity.class);
        intent.putExtra("param1", targetId);
        intent.putExtra("param2", classType);
        intent.putExtra("param3", targetTitle);
        context.startActivityForResult(intent, REQUEST);
    }


    private void fillBaseData(PayRollList bean) {


        TextView scrollTotalManhourTxt = (TextView) findViewById(R.id.scollTotalManhour); //上班总工时
        TextView scrollTotalOvertimeTxt = (TextView) findViewById(R.id.scollTotalOvertime); //加班总工时

        TextView unScrollTotalManhourTxt = (TextView) unScrollView.findViewById(R.id.unScollTotalManhour); //上班总工时
        TextView unScrollTotalOvertimeTxt = (TextView) unScrollView.findViewById(R.id.unScrollTotalOvertime); //加班总工时


        TextView scrollTotalIncomeTxt = (TextView) findViewById(R.id.scrollTotalIncome);//应收总和
        TextView scrollTotalExpendTxt = (TextView) findViewById(R.id.scrollTotalExpend);//借支总和
        TextView scrollTotalBalance = (TextView) findViewById(R.id.scrollTotalBalance);//结算总和
        TextView scrollTotalTxt = (TextView) findViewById(R.id.scrollTotal);//余额

        TextView unScrollTotalIncomeTxt = (TextView) unScrollView.findViewById(R.id.unScrollTotalIncome);//应收总和
        TextView unScrollTotalExpendTxt = (TextView) unScrollView.findViewById(R.id.unScrollTotalExpend);//借支总和
        TextView unScrollTotalBalance = (TextView) unScrollView.findViewById(R.id.unScrollTotalBalance);//结算总和
        TextView unScrollTotalTxt = (TextView) unScrollView.findViewById(R.id.unScrollTotal);//余额

        View unScrollNumNormalWork = unScrollView.findViewById(R.id.unScollSumNormalWork); //上班合计
        View unScrollNumOvertimeWork = unScrollView.findViewById(R.id.unScollSumOvertimeWork); //加班合计


        float manhour = bean.getTotal_manhour();
        float overtime = bean.getTotal_overtime();
        String income = bean.getNew_total().getPre_unit() + bean.getNew_total_income().getTotal() + bean.getNew_total_income().getUnit();
        String expand = bean.getNew_total().getPre_unit() + bean.getNew_total_expend().getTotal() + bean.getNew_total_expend().getUnit();
        String balance = bean.getNew_total().getPre_unit() + bean.getNew_total_balance().getTotal() + bean.getNew_total_balance().getUnit();
        String total = bean.getNew_total().getPre_unit() + bean.getNew_total().getTotal() + bean.getNew_total().getUnit();


        scrollTotalManhourTxt.setText(Html.fromHtml("<font color='#333333'>上班合计</font><font color='#d7252c'>&nbsp;&nbsp;" + RecordUtils.cancelIntergerZeroFloat(manhour) + "</font><font color='#999999'>个工</font>"));
        scrollTotalOvertimeTxt.setText(Html.fromHtml("<font color='#333333'>加班合计</font><font color='#36a971'>&nbsp;&nbsp;" + RecordUtils.cancelIntergerZeroFloat(overtime) + "</font><font color='#999999'>个工</font>"));
        unScrollTotalManhourTxt.setText(Html.fromHtml("<font color='#d7252c'>" + RecordUtils.cancelIntergerZeroFloat(manhour) + "</font><font color='#999999'>&nbsp;个工</font>"));
        unScrollTotalOvertimeTxt.setText(Html.fromHtml("<font color='#36a971'>" + RecordUtils.cancelIntergerZeroFloat(overtime) + "</font><font color='#999999'>&nbsp;个工</font>"));


        scrollTotalIncomeTxt.setText(income);
        scrollTotalExpendTxt.setText(expand);
        scrollTotalBalance.setText(balance);
        scrollTotalTxt.setText(total);

        unScrollTotalIncomeTxt.setText(income);
        unScrollTotalExpendTxt.setText(expand);
        unScrollTotalBalance.setText(balance);
        unScrollTotalTxt.setText(total);


        if (bean.getTotal() > 0) { //设置余额
            scrollTotalTxt.setTextColor(ContextCompat.getColor(this, R.color.app_color));
            unScrollTotalTxt.setTextColor(ContextCompat.getColor(this, R.color.app_color));
        } else {
            unScrollTotalTxt.setTextColor(ContextCompat.getColor(this, R.color.green));
            scrollTotalTxt.setTextColor(ContextCompat.getColor(this, R.color.green));
        }
        calculateWork(unScrollNumNormalWork, unScrollNumOvertimeWork, bean.getTotal_manhour(), bean.getTotal_overtime());
    }


    /**
     * 计算工时百分比
     */
    public void calculateWork(View sumNormalWork, View sumOvertimeWork, float sumNoraml, float sumOver) {
        if (sumOver == 0 && sumNoraml == 0) {
            sumNormalWork.setVisibility(View.GONE);
            sumOvertimeWork.setVisibility(View.GONE);
            return;
        }
        LinearLayout.LayoutParams sumNormalWorkParams = (LinearLayout.LayoutParams) sumNormalWork.getLayoutParams();
        LinearLayout.LayoutParams sumOvertimeWorkParams = (LinearLayout.LayoutParams) sumOvertimeWork.getLayoutParams();
        float bigNumber = sumOver > sumNoraml ? sumOver : sumNoraml;
        float smallNumber = sumOver > sumNoraml ? sumNoraml : sumOver;
        int height = DensityUtils.dp2px(this, 50);
        float calculateHeight = height / bigNumber * smallNumber;
        if (sumNoraml > sumOver) { //正常工时大于加班工时
            sumNormalWorkParams.height = height;
            sumOvertimeWorkParams.height = (int) (calculateHeight);
            sumNormalWork.setVisibility(View.VISIBLE);
            sumOvertimeWork.setVisibility(sumOver == 0 ? View.GONE : View.VISIBLE);
        } else {
            sumOvertimeWorkParams.height = height;
            sumNormalWorkParams.height = (int) (calculateHeight);
            sumOvertimeWork.setVisibility(View.VISIBLE);
            sumNormalWork.setVisibility(sumNoraml == 0 ? View.GONE : View.VISIBLE);
        }
        sumNormalWork.setLayoutParams(sumNormalWorkParams);
        sumOvertimeWork.setLayoutParams(sumOvertimeWorkParams);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payroll_year_month_list);
        initHeadView();
        initView();
        getData();
    }


//    /**
//     * 下拉动画
//     */
//    private void showScrollView() {
//        isLoadingAnim = true;
//        AnimatorSet animSet = new AnimatorSet();
//        ObjectAnimator animator1 = ObjectAnimator.ofFloat(scrollLayout, "translationY", -scrollLayout.getHeight(), 0);
//        ObjectAnimator animator2 = ObjectAnimator.ofFloat(scrollLayout, "alpha", 0.0f, 1.0F);
//        animSet.playTogether(animator1);
//        animSet.playTogether(animator2);
//        animSet.setDuration(300);
//        animSet.start();
//        animSet.addListener(new Animator.AnimatorListener() {
//            @Override
//            public void onAnimationStart(Animator animator) {
//
//            }
//
//            @Override
//            public void onAnimationEnd(Animator animator) {
//                isLoadingAnim = false;
//            }
//
//            @Override
//            public void onAnimationCancel(Animator animator) {
//
//            }
//
//            @Override
//            public void onAnimationRepeat(Animator animator) {
//
//            }
//        });
//    }
//
//    /**
//     * 上拉动画
//     */
//    private void hideScrollView() {
//        isLoadingAnim = true;
//        AnimatorSet animSet = new AnimatorSet();
//        ObjectAnimator animator1 = ObjectAnimator.ofFloat(scrollLayout, "translationY", 0, -scrollLayout.getHeight());
//        ObjectAnimator animator2 = ObjectAnimator.ofFloat(scrollLayout, "alpha", 1.0f, 0.0F);
//        animSet.playTogether(animator1);
//        animSet.playTogether(animator2);
//        animSet.setDuration(300);
//        animSet.start();
//        animSet.addListener(new Animator.AnimatorListener() {
//            @Override
//            public void onAnimationStart(Animator animator) {
//
//            }
//
//            @Override
//            public void onAnimationEnd(Animator animator) {
//                isLoadingAnim = false;
//            }
//
//            @Override
//            public void onAnimationCancel(Animator animator) {
//
//            }
//
//            @Override
//            public void onAnimationRepeat(Animator animator) {
//
//            }
//        });
//    }

    private void initView() {
        String classType = getIntent().getStringExtra("param2");
        String targetTitle = getIntent().getStringExtra("param3");
        TextView title = getTextView(R.id.title);
        title.setText(classType.equals("person") ? targetTitle + "工资清单" : targetTitle);
//        scrollLayout = (LinearLayout) findViewById(R.id.scrollLayout);
//        listView.setScrollListener(new CustomListView.CustomScrollListener() {
//            @Override
//            public void onScroll(int scrollY) {
//                int height = scrollLayout.getHeight();
//                if (height == 0 || isLoadingAnim) {
//                    return;
//                }
//                int unScrollViewHegith = unScrollView.getHeight(); //顶部未滑动布局
//                if (scrollY >= unScrollViewHegith && scrollLayout.getTranslationY() == -scrollLayout.getHeight()) { //显示布局
//                    showScrollView();
//                } else if (scrollY < unScrollViewHegith && scrollLayout.getTranslationY() == 0) { //隐藏布局
//                    hideScrollView();
//                }
//            }
//        });


//        scrollLayout.getViewTreeObserver().addOnGlobalLayoutListener(
//                new ViewTreeObserver.OnGlobalLayoutListener() {
//                    @Override
//                    public void onGlobalLayout() {
//                        scrollLayout.setTranslationY(-scrollLayout.getHeight());
//                        if (Build.VERSION.SDK_INT < 16) {
//                            scrollLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
//                        } else {
//                            scrollLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
//                        }
//                    }
//                });
    }


    private void initHeadView() {
        final CustomListView listView = (CustomListView) findViewById(R.id.listView);
        unScrollView = getLayoutInflater().inflate(R.layout.pay_default, null);
        listView.addHeaderView(unScrollView, null, false);
        adapter = new PayRollItemAdapter(this, null);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                int count = listView.getHeaderViewsCount();
                position = position - count;
                if (position == -1) {
                    return;
                }
                PayRollList bean = adapter.getList().get(position);
                String date = bean.getYear() + "-" + bean.getMonth();
                Intent intent = getIntent();
                PayrollDetailActivity.actionStart(PayRollYearMonthListActivity.this,
                        intent.getStringExtra("param1"), intent.getStringExtra("param2"), intent.getStringExtra("param3"), date);
            }
        });
    }


    /**
     * 查询工资清单 列表数据
     */
    public void getData() {
        String URL = NetWorkRequest.PERANDPROALLBILL;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<PayRollList> base = CommonJson.fromJson(responseInfo.result, PayRollList.class);
                    if (base.getState() != 0) {
                        PayRollList bean = base.getValues();
                        if (bean != null) {
                            fillData(bean);
                        }
                    } else {
                        DataUtil.showErrOrMsg(PayRollYearMonthListActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(PayRollYearMonthListActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

    /**
     * 列表参数
     *
     * @return
     */
    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        Intent intent = getIntent();
        params.addBodyParameter("target_id", intent.getStringExtra("param1")); //目標id
        params.addBodyParameter("class_type", intent.getStringExtra("param2")); //类型 	person：按个人（默认）;project:按项目
        return params;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST) {
            getData();
        }
    }

}
