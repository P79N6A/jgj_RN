//package com.jizhi.jlongg.main.dialog;
//
//import android.app.Activity;
//import android.app.Dialog;
//import android.content.res.Resources;
//import android.view.View;
//import android.widget.ImageView;
//import android.widget.LinearLayout;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.hcs.uclient.utils.DensityUtils;
//import com.hcs.uclient.utils.SPUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.activity.welcome.TextActivity;
//
//import static com.jizhi.jlongg.R.id.rihgt_top_point;
//
///**
// * 功能: 记账包工 功能引导页
// * 作者：Xuj
// * 时间: 2016/3/11 15:47
// */
//public class GuidePopupWindow extends Dialog implements View.OnClickListener {
//
//
//    private Activity context;
//
//    /**
//     * 引导图1 位置
//     */
//    private int[] location1;
//
//    /**
//     * 引导图2 位置
//     */
//    private int[] location2;
//
//    /**
//     * 引导图3 位置
//     */
//    private int[] location3;
//
//    /**
//     * 引导图4 位置
//     */
//    private int[] location4;
//
//    /**
//     * 当前点击的橙色按钮下标
//     */
//    private int currentItem;
//
//    /**
//     * 需要调整位置的Layout
//     */
//    private RelativeLayout relativeLayout, recordAccountType;
//
//    private LinearLayout accountTypeLayout;
//
//    /**
//     * 参数
//     */
//    private RelativeLayout.LayoutParams params;
//
//    RelativeLayout.LayoutParams guide_params;
//
//    private ImageView guide1, bottomPoint, accountTypeIconPoint, accountTypeIconDesc;
//
//    private Resources res;
//    /* 键,值 */
//    private TextView text, value, accountText;
//
//    private int type;
//
//    private boolean isMoveTop = true;
//    /* 当前角色 */
//    private String roleType;
//
//
//    public GuidePopupWindow(Activity context, int[] location1, int[] location2, int type, String roleType) {
//        super(context, R.style.kdialog);
//        this.roleType = roleType;
//        this.context = context;
//        int statusHeight = DensityUtils.getStatusHeight(context);
//
//        this.location2 = location2;
//
//        location1[1] = location1[1] - statusHeight;
//        res = context.getResources();
//        this.type = type;
//        initPopup();
//    }
//
//
//    public GuidePopupWindow(Activity context, int[] location1, int[] location2, int[] location3, int[] location4, int type, String roleType) {
//        super(context, R.style.kdialog);
//        this.context = context;
//        this.roleType = roleType;
//        int statusHeight = DensityUtils.getStatusHeight(context);
//        this.location1 = location1;
//        this.location2 = location2;
//        this.location3 = location3;
//        this.location4 = location4;
//        location1[1] = location1[1] - statusHeight;
//        location2[1] = location2[1] - statusHeight;
//        location3[1] = location3[1] - statusHeight;
//        location4[1] = location4[1] - statusHeight;
//        this.type = type;
//        res = context.getResources();
//        initPopup();
//    }
//
//
//    private void initPopup() {
//        setContentView(R.layout.contractor_guide);
//        getWindow().setWindowAnimations(R.style.GuideAnimation);
//        findViewById(R.id.close_guide).setOnClickListener(this);
//        findViewById(R.id.orang_button).setOnClickListener(this);
//        guide1 = (ImageView) findViewById(R.id.guide1);
//        bottomPoint = (ImageView) findViewById(rihgt_top_point);
//        text = (TextView) findViewById(R.id.text);
//        accountText = (TextView) findViewById(R.id.accountText);
//        value = (TextView) findViewById(R.id.value);
//        accountTypeLayout = (LinearLayout) findViewById(R.id.accountTypeLayout);
//        recordAccountType = (RelativeLayout) findViewById(R.id.recordAccountType);
//        accountTypeIconPoint = (ImageView) findViewById(R.id.accountTypeIconPoint);
//        accountTypeIconDesc = (ImageView) findViewById(R.id.accountTypeIconDesc);
//        guide_params = (RelativeLayout.LayoutParams) guide1.getLayoutParams();
//        relativeLayout = (RelativeLayout) findViewById(R.id.relativeLayout);
//        relativeLayout.setVisibility(View.INVISIBLE);
//        params = (RelativeLayout.LayoutParams) relativeLayout.getLayoutParams();
//        switch (roleType) { //判断角色改变文字
//            case Constance.ROLETYPE_WORKER: //当前登录状态为工友时  则显示工头
//                text.setText(context.getString(R.string.forman_headman));
//                value.setText(context.getString(R.string.pleaseSelectFM));
//                guide1.setImageResource(R.drawable.guide_5);
//                break;
//            case Constance.ROLETYPE_FM: //当前登录状态为工头时  则显示工友
//                text.setText(context.getString(R.string.selectWorker));
//                value.setText(context.getString(R.string.pleaseSelectWorker));
//                guide1.setImageResource(R.drawable.guide_9);
//                break;
//        }
//        value.setTextColor(res.getColor(R.color.textcolor));
//        initTop();
//    }
//
//
//    /**
//     * 初始化包工引导页
//     */
//    private void initContractor() {
//        SPUtils.put(context, Constance.CONSTRACTOR_GUIDE, true, Constance.JLONGG);
//        switch (currentItem) {
//            case 2:
//                params.topMargin = location2[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_8);
//                text.setText(context.getString(R.string.subentry_name));
//                value.setText(context.getString(R.string.subentry_name_details));
//                break;
//            case 3:
//                params.topMargin = location3[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_6);
//                text.setText(context.getString(R.string.unit_price));
//                value.setText(context.getString(R.string.element));
//                break;
//            case 4:
//                params.topMargin = location4[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_7);
//                text.setText(context.getString(R.string.count));
//                value.setText(context.getString(R.string.input_number));
//                break;
//            case 5:
//                text.setVisibility(View.GONE);
//                value.setVisibility(View.GONE);
//                dismiss();
//                break;
//        }
//    }
//
//
//    private void initTop() {
//        currentItem += 1;
//        TextActivity textActivity = (TextActivity) context;
//        RelativeLayout.LayoutParams paramsText = (RelativeLayout.LayoutParams) recordAccountType.getLayoutParams();
//        LinearLayout.LayoutParams imageParams = (LinearLayout.LayoutParams) accountTypeIconPoint.getLayoutParams();
//        imageParams.topMargin = DensityUtils.dp2px(context, 10);
//        switch (currentItem) {
//            case 1: //点工
//                paramsText.leftMargin = textActivity.getLocationHour()[0] - DensityUtils.dp2px(context, 5);
//                paramsText.topMargin = textActivity.getLocationHour()[1] - DensityUtils.getStatusHeight(context) - DensityUtils.dp2px(context, 4);
//                imageParams.leftMargin = textActivity.getLocationHour()[0] + DensityUtils.dp2px(context, 40);
//                accountTypeIconDesc.setImageResource(R.drawable.hour_icon);
//                accountText.setText("点工");
//                break;
//            case 2: //包工
//                paramsText.leftMargin = textActivity.getLocationPricemodeAll()[0] - DensityUtils.dp2px(context, 5);
//                paramsText.topMargin = textActivity.getLocationPricemodeAll()[1] - DensityUtils.getStatusHeight(context) - DensityUtils.dp2px(context, 4);
//                imageParams.leftMargin = textActivity.getLocationPricemodeAll()[0] - DensityUtils.dp2px(context, 15);
//                accountTypeIconDesc.setImageResource(R.drawable.price_icon);
//                accountTypeIconPoint.setImageResource(R.drawable.guide_right_point_icon);
//                accountText.setText("包工");
//                break;
//            case 3://借支
//                paramsText.leftMargin = textActivity.getLocationBorrowing()[0] - DensityUtils.dp2px(context, 5);
//                paramsText.topMargin = textActivity.getLocationBorrowing()[1] - DensityUtils.getStatusHeight(context) - DensityUtils.dp2px(context, 4);
//                imageParams.leftMargin = textActivity.getLocationBorrowing()[0] - DensityUtils.dp2px(context, 15);
//                accountTypeIconDesc.setImageResource(R.drawable.borrow_icon);
//                accountTypeIconPoint.setImageResource(R.drawable.guide_right_point_icon);
//                isMoveTop = false;
//                currentItem = 0;
//                accountText.setText("借支");
//                break;
//        }
//        recordAccountType.setLayoutParams(paramsText);
//        accountTypeIconPoint.setLayoutParams(imageParams);
//        accountTypeIconDesc.setLayoutParams(imageParams);
//    }
//
//
//    /**
//     * 初始化点工引导页
//     */
//    private void initLiiterWork() {
//        SPUtils.put(context, Constance.HOUR_WORKER_GUIDE, true, Constance.JLONGG);
//        switch (currentItem) {
//            case 2:
//                params.topMargin = location2[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_2);
//                text.setText(context.getString(R.string.set_salarys));
//                value.setText(context.getString(R.string.salary_mode_setting));
//                break;
//            case 3:
//                params.topMargin = location3[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_3);
//                text.setText(context.getString(R.string.today_working)); //今天上班
//                value.setText(context.getString(R.string.eight_hour));  //8小时
//                value.setTextColor(res.getColor(R.color.app_color));
//                break;
//            case 4:
//                params.topMargin = location4[1];
//                relativeLayout.setLayoutParams(params);
//                guide1.setImageResource(R.drawable.guide_4);
//                text.setText(context.getString(R.string.today_working_overtime));
//                value.setText(context.getString(R.string.noworking_overtime));
//                value.setTextColor(res.getColor(R.color.app_color));
//                break;
//            case 5:
//                text.setVisibility(View.GONE);
//                value.setVisibility(View.GONE);
//                dismiss();
//                break;
//        }
//    }
//
//
//    /**
//     * 初始化借支引导页
//     */
//    private void initPen() {
//        SPUtils.put(context, Constance.BORROWING_GUIDE, true, Constance.JLONGG);
//        text.setVisibility(View.GONE);
//        value.setVisibility(View.GONE);
//        dismiss();
//    }
//
//    @Override
//    public void onClick(View v) {
//        switch (v.getId()) {
//            case R.id.close_guide: //关闭引导说明
//                dismiss();
//                break;
//            case R.id.orang_button:
//                if (isMoveTop) {
//                    initTop();
//                } else {
//                    currentItem += 1;
//                    if (currentItem == 1) {
//                        findViewById(R.id.guide_layout).setVisibility(View.VISIBLE);
//                        accountTypeLayout.setVisibility(View.GONE);
//                        recordAccountType.setVisibility(View.GONE);
//                        relativeLayout.setVisibility(View.VISIBLE);
//                        bottomPoint.setVisibility(View.VISIBLE);
//                        params.topMargin = location1[1];
//                        relativeLayout.setLayoutParams(params);
//                        guide1.setImageResource(roleType.equals(Constance.ROLETYPE_FM) ? R.drawable.guide_9 : R.drawable.guide_1);
//                        return;
//                    }
//                    switch (type) {
//                        case 1: //点工
//                            initLiiterWork();
//                            break;
//                        case 2: //包工
//                            initContractor();
//                            break;
//                        case 3: //借支
//                            initPen();
//                            break;
//                    }
//                }
//                break;
//        }
//    }
//
//
//}
