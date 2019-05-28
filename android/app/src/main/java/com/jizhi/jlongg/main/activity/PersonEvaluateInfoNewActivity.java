package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.EvaluateBillInfo;
import com.jizhi.jlongg.main.bean.EvaluateInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 班组长、工人评价详情
 *
 * @author Xuj
 * @time 2018年3月13日14:42:30
 * @Version 1.0
 */
public class PersonEvaluateInfoNewActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 头像
     */
    private RoundeImageHashCodeTextLayout headImageView;
    /**
     * 班组长,工人名称、记账人名称、电话号码
     */
    private TextView userNameText, recordNameText;
    /**
     * 上班时长、加班时长、借支笔数、结算笔数
     */
    private TextView manhourText, overTimeText, borrowCountText, balanceCountText;
    /**
     * 点工金额，包工(承包金额) 包工(分包金额)，借支金额，结算金额，未结金额
     */
    private TextView littleWorkAmountText, contractorWorkOneAmountText, contractorWorkTwoAmountText, borrowTotalText, balanceTotalText, unBalanceTotalText;

    /**
     * 不能评价时的提示信息
     */
    private String can_not_msg;
    /**
     * 备注图片
     */
    private ArrayList<String> notesImages;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param uid        用户id
     * @param headImage  头像
     * @param userName   用户名称
     * @param telphone   电话号码
     * @param isActivity 是否已注册 1表示注册
     */
    public static void actionStart(Activity context, String uid, String headImage, String userName, String telphone, int isActivity) {
        Intent intent = new Intent(context, PersonEvaluateInfoNewActivity.class);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.HEAD_IMAGE, headImage);
        intent.putExtra(Constance.IS_ACTIVE, isActivity);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initView();
        getEvaluateInfo();
    }


    private void initView() {
        View headView = getLayoutInflater().inflate(R.layout.evaluate_head_new, null); // 加载对话框

        contractorWorkOneAmountText = (TextView) headView.findViewById(R.id.contractorWorkOneAmountText);
        contractorWorkTwoAmountText = (TextView) headView.findViewById(R.id.contractorWorkTwoAmountText);

        TextView contractorWorkOneText = (TextView) headView.findViewById(R.id.contractorWorkOneText);
        TextView contractorWorkTwoText = (TextView) headView.findViewById(R.id.contractorWorkTwoText);

        View invisibleText = headView.findViewById(R.id.invisible_text);

        if (UclientApplication.isForemanRoler(getApplicationContext())) {
            setTextTitle(R.string.worker_info);
            contractorWorkTwoText.setVisibility(View.VISIBLE);
            contractorWorkTwoAmountText.setVisibility(View.VISIBLE);

            contractorWorkOneText.setVisibility(View.VISIBLE);
            contractorWorkOneAmountText.setVisibility(View.VISIBLE);
            invisibleText.setVisibility(View.INVISIBLE);

            contractorWorkTwoAmountText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
            contractorWorkOneAmountText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.borrow_color));

        } else {
            setTextTitle(R.string.foreman_info);

            contractorWorkTwoText.setVisibility(View.GONE);
            contractorWorkTwoAmountText.setVisibility(View.GONE);

            contractorWorkOneText.setVisibility(View.VISIBLE);
            contractorWorkOneAmountText.setVisibility(View.VISIBLE);
            invisibleText.setVisibility(View.GONE);

            contractorWorkOneAmountText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
        }

        TextView itemTitleName = (TextView) headView.findViewById(R.id.itemTitleName);

        ListView listView = (ListView) findViewById(R.id.listView);
        headImageView = (RoundeImageHashCodeTextLayout) headView.findViewById(R.id.headImageView);
        userNameText = (TextView) headView.findViewById(R.id.userNameText);
        recordNameText = (TextView) headView.findViewById(R.id.recordNameText);
        TextView telText = (TextView) headView.findViewById(R.id.telText);

        manhourText = (TextView) headView.findViewById(R.id.manhourText);
        overTimeText = (TextView) headView.findViewById(R.id.overTimeText);
        borrowCountText = (TextView) headView.findViewById(R.id.borrowCountText);
        balanceCountText = (TextView) headView.findViewById(R.id.balanceCountText);
        littleWorkAmountText = (TextView) headView.findViewById(R.id.littleWorkAmountText);


        borrowTotalText = (TextView) headView.findViewById(R.id.borrowTotalText);
        balanceTotalText = (TextView) headView.findViewById(R.id.balanceTotalText);
        unBalanceTotalText = (TextView) headView.findViewById(R.id.unBalanceTotalText);

        listView.addHeaderView(headView, null, false);
        listView.setAdapter(null);

        itemTitleName.setText(getString(R.string.name));


        String telphone = getIntent().getStringExtra(Constance.TELEPHONE);
        if (TextUtils.isEmpty(telphone)) {
            telText.setVisibility(View.GONE);
        } else {
            telText.setVisibility(View.VISIBLE);
            telText.setText(telphone); //设置电话号码
        }

        headImageView.setView(getIntent().getStringExtra(Constance.HEAD_IMAGE), getIntent().getStringExtra(Constance.USERNAME), 0); //设置头像
        userNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置名称
        recordNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置记账对象名称

        headView.findViewById(R.id.searchEvaluateBtn).setOnClickListener(this);
        headView.findViewById(R.id.goEvaluateBtn).setOnClickListener(this);
        headImageView.setOnClickListener(this);


        //如果当前的对象是自己 则隐藏修改姓名按钮
        headView.findViewById(R.id.editorNameText).setVisibility(UclientApplication.getUid().equals(getIntent().getStringExtra(Constance.UID)) ? View.GONE : View.VISIBLE);
    }

    /**
     * 获取评价信息
     */
    private void getEvaluateInfo() {
        String httpUrl = NetWorkRequest.EVALUATE_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));
        CommonHttpRequest.commonRequest(this, httpUrl, EvaluateInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                EvaluateInfo evaluateInfo = (EvaluateInfo) object;
                if (evaluateInfo == null) {
                    finish();
                    return;
                }
                EvaluateBillInfo billInfo = evaluateInfo.getBill_info(); //记账信息
                if (billInfo != null) {
                    findViewById(R.id.billInfoItem).setVisibility(View.VISIBLE);
                    findViewById(R.id.billInfoLayout).setVisibility(View.VISIBLE);
                    findViewById(R.id.billInfoTitleLayout).setVisibility(View.VISIBLE);
                    if (billInfo.getWork_type() != null) { //点工
                        manhourText.setText(AccountUtil.getAccountShowTypeString(getApplicationContext(), true, true, true, billInfo.getWork_type().getManhour(), billInfo.getWork_type().getWorking_hours()));
                        overTimeText.setText(AccountUtil.getAccountShowTypeString(getApplicationContext(), true, true, false, billInfo.getWork_type().getOvertime(), billInfo.getWork_type().getOvertime_hours()));
                        littleWorkAmountText.setText(billInfo.getWork_type().getAmounts()); //设置点工金额
                    }
                    if (billInfo.getContract_type_one() != null) { //包工(承包金额)
                        contractorWorkOneAmountText.setText(billInfo.getContract_type_one().getAmounts()); //设置包工(承包)金额
                    }
                    if (UclientApplication.isForemanRoler(getApplicationContext()) && billInfo.getContract_type_two() != null) { //包工(分包金额)
                        contractorWorkTwoAmountText.setText(billInfo.getContract_type_two().getAmounts()); //设置包工(分包)金额
                    }
                    if (billInfo.getExpend_type() != null) { //借支
                        borrowCountText.setText(String.format(getString(R.string.borrow_params), (int) billInfo.getExpend_type().getTotal()));
                        borrowTotalText.setText(billInfo.getExpend_type().getAmounts()); //设置借支金额
                    }
                    if (billInfo.getBalance_type() != null) { //结算
                        balanceCountText.setText(String.format(getString(R.string.balance_params), (int) billInfo.getBalance_type().getTotal()));
                        balanceTotalText.setText(billInfo.getBalance_type().getAmounts());//设置结算金额
                    }
                    if (billInfo.getUnbalance_type() != null) {//未结
                        unBalanceTotalText.setText(billInfo.getUnbalance_type().getAmounts());
                    }
                } else {
                    findViewById(R.id.billInfoTitleLayout).setVisibility(View.GONE);
                    findViewById(R.id.billInfoItem).setVisibility(View.GONE);
                    findViewById(R.id.billInfoLayout).setVisibility(View.GONE);
                }
                //显示评价信息
                findViewById(R.id.evaluateInfoLayout).setVisibility(View.VISIBLE);
                //去评价按钮
                Button goEvaluateBtn = getButton(R.id.goEvaluateBtn);
                //评价数量
                int number = evaluateInfo.getEvaluate_num();
                goEvaluateBtn.setText(number > 0 ? "我也去评价" : "我去评价");
                goEvaluateBtn.setVisibility(View.VISIBLE);
                String roler = UclientApplication.isForemanRoler(getApplicationContext()) ? "工人" : "班组长";
                if (number > 0) {
                    String completeString = "该" + roler + "已收到 " + number + " 条评价";
                    Pattern p = Pattern.compile(number + "");
                    SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
                    Matcher telMatch = p.matcher(completeString);
                    while (telMatch.find()) {
                        ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#eb4e4e"));
                        builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
                        builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                        builder.setSpan(new AbsoluteSizeSpan(DensityUtils.sp2px(getApplicationContext(), 20)), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                    }
                    findViewById(R.id.searchEvaluateBtn).setVisibility(View.VISIBLE);
                    getImageView(R.id.infoImage).setImageResource(R.drawable.evaluate_have_data);
                    getTextView(R.id.infoText).setText(builder);
                } else {
                    findViewById(R.id.searchEvaluateBtn).setVisibility(View.GONE);
                    getImageView(R.id.infoImage).setImageResource(R.drawable.evaluate_no_data);
                    getTextView(R.id.infoText).setText("暂时还没人对该" + roler + "评价过");
                }
                //备注信息
                String remarkValue = evaluateInfo.getNotes_txt();
                ArrayList<String> remarkImages = evaluateInfo.getNotes_img();
                View remarkLayout = findViewById(R.id.remark_layout);
                TextView remarkText = findViewById(R.id.remark_text);
                NineGridMsgImageView remarkGridView = findViewById(R.id.remark_gridview);
                if (!TextUtils.isEmpty(remarkValue) && (remarkImages != null && !remarkImages.isEmpty())) { //备注文本和备注图片都不为空
                    remarkText.setText(remarkValue);
                    remarkLayout.setVisibility(View.VISIBLE);
                    remarkText.setVisibility(View.VISIBLE);
                    remarkGridView.setVisibility(View.VISIBLE);
                    remarkGridView.setAdapter(new NineGridImageViewAdapter<String>() {
                        @Override
                        public void onDisplayImage(Context context, ImageView imageView, String s) {
                            if (!s.contains("/storage/")) {
                                new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                            } else {
                                new GlideUtils().glideImage(context, "file://" + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                            }
                        }

                        @Override
                        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
                            //imagesize是作为loading时的图片size
                            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
                            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
                        }
                    });
                    remarkGridView.setImagesDataXj(remarkImages);
                } else if (!TextUtils.isEmpty(remarkValue)) { //备注文本不为空
                    remarkLayout.setVisibility(View.VISIBLE);
                    remarkText.setVisibility(View.VISIBLE);
                    remarkGridView.setVisibility(View.GONE);
                    remarkText.setText(remarkValue);
                } else if (remarkImages != null && !remarkImages.isEmpty()) { //备注图片不为空
                    remarkLayout.setVisibility(View.VISIBLE);
                    remarkText.setVisibility(View.GONE);
                    remarkGridView.setVisibility(View.VISIBLE);
                    remarkGridView.setAdapter(new NineGridImageViewAdapter<String>() {
                        @Override
                        public void onDisplayImage(Context context, ImageView imageView, String s) {
                            if (!s.contains("/storage/")) {
                                new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                            } else {
                                new GlideUtils().glideImage(context, "file://" + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                            }
                        }

                        @Override
                        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
                            //imagesize是作为loading时的图片size
                            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
                            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
                        }
                    });
                    remarkGridView.setImagesDataXj(remarkImages);
                } else { //两个都为空
                    remarkLayout.setVisibility(View.GONE);
                }
                notesImages = remarkImages;
                can_not_msg = evaluateInfo.getCan_not_msg();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 选择记账对象后，根据记账对象查询模版
     */
    public void getUserSalary() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        final String uid = getIntent().getStringExtra(Constance.UID);
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        String httpUrl = NetWorkRequest.GET_ALL_TPL_BY_UID;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final PersonBean accountPerson = (PersonBean) object;
                if (accountPerson != null) {
                    accountPerson.setName(accountPerson.getReal_name());
                    SingleBatchAccountActivity.actionStart(PersonEvaluateInfoNewActivity.this, accountPerson, null, null,
                            null, null, (int) SPUtils.get(getApplicationContext(), "singlebatch_select_type", AccountUtil.HOUR_WORKER_INT, Constance.JLONGG));
                    SingleBatchAccountActivity.setFrom();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.headImageView: //点击头像跳转到查看资料详情
                /**
                 ①、如该工人已经在平台注册，点击他的头像，跳转到“他的资料”界面
                 ②、如该工人还未在平台注册但添加的时候，有电话号码，点击他的头像，气泡提示“该用户还未注册，赶紧邀请他下载[吉工家]一起使用吧！
                 ③、如该工人在添加的时候，没有输入电话号码，点击他的头像，点击无反应
                 */
                Intent intent = getIntent();
                if (TextUtils.isEmpty(intent.getStringExtra(Constance.TELEPHONE))) { //没有电话号码不能点击
                    return;
                }
                if (intent.getIntExtra(Constance.IS_ACTIVE, 1) == 0) { //未注册的用户
                    CommonMethod.makeNoticeLong(getApplicationContext(), "该用户还未注册，赶紧邀请他下载[吉工家]一起使用吧！", CommonMethod.ERROR);
                    return;
                }
                ChatUserInfoActivity.actionStart(this, getIntent().getStringExtra(Constance.UID));
                break;
            case R.id.editorNameText: //编辑姓名
                AddWorkerActivity.actionStart(this, true, getIntent().getStringExtra(Constance.USERNAME), getIntent().getStringExtra(Constance.TELEPHONE),
                        getIntent().getStringExtra(Constance.UID), getTextView(R.id.remark_text).getText().toString(), notesImages, true);
                break;
            case R.id.searchEvaluateBtn: //查看评价按钮
                EvaluationDetailActivity.actionStart(this, getIntent().getStringExtra(Constance.UID), null);
                break;
            case R.id.goEvaluateBtn: //去评价
                if (!TextUtils.isEmpty(can_not_msg)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), can_not_msg, CommonMethod.ERROR);
                    return;
                }
                goEvaluateActivity();
                break;
            case R.id.billInfoLayout: //记账信息
                String uid = getIntent().getStringExtra(Constance.UID);
                StatisticalWorkSecondActivity.actionStart(PersonEvaluateInfoNewActivity.this,
                        null, null, null, null,
                        uid, getIntent().getStringExtra(Constance.USERNAME), null,
                        UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ?
                                StatisticalWorkSecondActivity.TYPE_FROM_WORKER : StatisticalWorkSecondActivity.TYPE_FROM_FOREMAN, uid,
                        "person", false, false, null, false, true);
                break;
            case R.id.multipart_set_account: //批量修改记工
                getUserSalary();
                break;
        }
    }

    private void goEvaluateActivity() {
        Intent intent = getIntent();
        String uid = intent.getStringExtra(Constance.UID);
        String headImage = intent.getStringExtra(Constance.HEAD_IMAGE);
        String userName = intent.getStringExtra(Constance.USERNAME);
        GoEvaluateActivity.actionStart(this, uid, headImage, userName);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.EVALUATE_SUCCESS) { //评价成功后的回调
            getEvaluateInfo();
            //评论成功后，界面直接跳转到评价详情界面，然后点返回，回到工人信息界面；
            EvaluationDetailActivity.actionStart(this, getIntent().getStringExtra(Constance.UID), null);
            setResult(Constance.REFRESH); //设置上个页面刷新标识
        } else if (resultCode == Constance.MANUAL_ADD_OR_EDITOR_PERSON) {
            String userName = data.getStringExtra(Constance.USERNAME);
            if (!TextUtils.isEmpty(userName)) {
                getIntent().putExtra(Constance.USERNAME, userName);
                headImageView.setView(getIntent().getStringExtra(Constance.HEAD_IMAGE), userName, 0); //设置头像
                userNameText.setText(userName); //设置名称
                recordNameText.setText(userName); //设置记账对象名称
                setResult(Constance.REFRESH);
            }
            getEvaluateInfo();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊聊天
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //修改批量记工成功后的回调
            getEvaluateInfo();
        }
    }
}