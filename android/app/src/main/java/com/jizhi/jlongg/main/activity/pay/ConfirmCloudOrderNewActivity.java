package com.jizhi.jlongg.main.activity.pay;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Order;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.bean.ProductPriceInfo;
import com.jizhi.jlongg.main.dialog.pay.DialogWarningDialog;
import com.jizhi.jlongg.main.dialog.pay.ServiceTimePopWindow;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MoneyUtils;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 功能:确认云盘订单
 * 时间:2017年7月18日14:33:41
 * 作者:xuj
 */
public class ConfirmCloudOrderNewActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 项目组列表信息
     */
    private List<ProductInfo> groupInfoList;
    /**
     * 产品总价、产品优惠价格
     */
    private double total;
    /**
     * 产品服务的时长 默认为90天 ,原时间
     */
    private int serviceTime, oldSericeTime;
    /**
     * 产品信息
     */
    private ProductInfo productInfo;
    /**
     * 云盘空间能选的最小数
     */
    private long minCloudMemory, maxCloudMemory = 1000;
    /**
     * 项目名称
     */
    private TextView groupNameText;
    /**
     * 服务时长
     */
    private TextView serviceTimeText;
    /**
     * 云盘空间大小
     */
    private TextView cloudMemoryText;
    /**
     * 有效期
     */
    private TextView validityText;
    /**
     * 订单总价
     */
    private TextView totalPriceText;
    /**
     * 底部支付按钮
     */
    private TextView payBtn;
    /**
     * 支付方式
     * 0 代表支付宝
     * 1 代表微信
     */
    private int payWay = ProductUtil.WX_PAY;
    /**
     * 支付宝,微信选中图标
     */
    private ImageView aliPayIcon, wxIcon;
    /**
     * 服务时长
     */
    private List<Integer> serverTimeList;
    /**
     * 云盘删除、添加空间图标,
     */
    private ImageView cloudMemoryRemoveIcon, cloudMemoryAddIcon;
    /**
     * 项目组id
     */
    private String groupId;

    /**
     * 服务时长结果,有效期结果,云盘空间结果
     */
    private TextView serverTimeResult, validateResult, cloudResult;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupId) {
        Intent intent = new Intent(context, ConfirmCloudOrderNewActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.cloud_confirm_order_new);
        initView();
        initData();
        registerWXCallBack();
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_SUCCESS);
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
            if (action.equals(Constance.ACTION_MESSAGE_WXPAY_SUCCESS)) { //微信支付成功
                OrderSuccessActivity.actionStart(ConfirmCloudOrderNewActivity.this);
            }
        }
    }


//    /**
//     * 设置红色文本提示
//     *
//     * @param service_lave_days 服务剩余天数
//     * @param buyerPerson       购买人数
//     */
//    private void setRedTips(int service_lave_days, int buyerPerson) {
//        if (productInfo.getIs_senior() == 1) { //1:高级版 0：普通版
//            int reNewDays = serviceTime - service_lave_days;//续期天数
//            if (reNewDays > 0) {
//                renewalLayout.setVisibility(View.VISIBLE);
//                renewalText.setText("黄金服务版的服务人数(" + buyerPerson + "人)和赠送空间(" + (buyerPerson * 2) + "G)将同时续期" + reNewDays + "天");
//            } else {
//                renewalLayout.setVisibility(View.GONE);
//            }
//        }
//    }


    /**
     * 初始化数据
     */
    private void initData() {
        groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        ProductUtil.getProductInfo(this, new ProductUtil.GetProductListener() {
            @Override
            public void onSuccess(List<ProductInfo> list, ProductPriceInfo productPriceInfo, ProductPriceInfo cloudPriceInfo) {
                groupInfoList = list;
                getTextView(R.id.cloudEveryDayMoney).setText(Utils.m2(cloudPriceInfo.getTotal_amount()) + "元"); //设置云盘单价
                getTextView(R.id.cloudUnits).setText("(" + cloudPriceInfo.getUnits() + ")"); //设置云盘单价
                for (ProductInfo bean : list) {
                    if (TextUtils.isEmpty(groupId)) { //从服务商店进来需要默认一个项目 如果一个项目都没有的话 则会在后面重新创建一个
                        if (bean.getIs_default() == 1) {
                            setBaseInfo(bean);
                            break;
                        }
                    } else {
                        if (groupId.equals(bean.getGroup_id())) {
                            setBaseInfo(bean);
                            break;
                        }
                    }
                }
                if (productInfo == null) {
                    productInfo = new ProductInfo();
                    serviceTime = 90;
                }
                productInfo.setProductPriceInfo(productPriceInfo);
                productInfo.setCloudPriceInfo(cloudPriceInfo);
                initBaseData();
            }
        });

        cloudMemoryText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                String value = charSequence.toString();
                if (TextUtils.isEmpty(value)) {
                    cloudMemoryText.setText(minCloudMemory + "");
                    return;
                }
                int number = Integer.parseInt(charSequence.toString());
                if (number > maxCloudMemory) { //不能超过1000个G
                    cloudMemoryText.setText(maxCloudMemory + "");
                    return;
                }
                cloudMemoryRemoveIcon.setImageResource(number <= minCloudMemory ? R.drawable.product_delete_unable : R.drawable.product_delete_enable); //如果云盘空间小于最小数则删除按钮置灰
                cloudMemoryAddIcon.setImageResource(number >= maxCloudMemory ? R.drawable.product_add_unable : R.drawable.product_add_enable); //如果云盘空间大于1000则添加按钮置灰
                calcutelateCloudResult();
                calculateOrderTotal(); //每次递增都需要重新计算价格
                setPayBtnState(); //设置设置按钮状态
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }


    private void initView() {
        setTextTitle(R.string.confirm_order);


        aliPayIcon = getImageView(R.id.aliPayIcon);
        wxIcon = getImageView(R.id.wxPayIcon);
        serverTimeResult = getTextView(R.id.serverTimeResult);
        validateResult = getTextView(R.id.validateResult);
        cloudResult = getTextView(R.id.cloudResult);


        cloudMemoryAddIcon = getImageView(R.id.cloudMemoryAdd);
        cloudMemoryRemoveIcon = getImageView(R.id.cloudMemoryRemove);
        payBtn = getTextView(R.id.payBtn);
        totalPriceText = getTextView(R.id.totalPrice);
        groupNameText = getTextView(R.id.groupNameText);
        validityText = getTextView(R.id.validityText);
        serviceTimeText = getTextView(R.id.serviceTimeText);
        cloudMemoryText = getTextView(R.id.cloudMemoryText);

        findViewById(R.id.renewalIcon).setOnClickListener(this);
    }


    /**
     * 设置按钮状态
     * 如果服务人数、服务时长、云盘空间均未改变，则【立即支付】或【确认订单】按钮显示为禁用状态
     */
    private void setPayBtnState() {
        long cloudSpace = productInfo.getCloud_space();//云盘购买的空间
        int serviceLaveDays = productInfo.getCloud_lave_days(); //服务剩余天数
        int cloudSpaceText = Integer.parseInt(cloudMemoryText.getText().toString());//当前所选购买空间

        if (cloudSpaceText == cloudSpace && serviceTime == serviceLaveDays) {
            payBtn.setClickable(false);
            Utils.setBackGround(payBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
        } else {
            payBtn.setClickable(true);
            Utils.setBackGround(payBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
        }
    }


    private void initBaseData() {
        setValidate();
        initServerTime();
        initCloudMemory();
//        setRedTips(productInfo.getService_lave_days(), productInfo.getBuyer_person());
    }


    /**
     * 设置有效期
     */
    private void setValidate() {
        serviceTimeText.setText(ProductUtil.getServerTimeString(serviceTime));
        Date date = new Date(productInfo.getCloudPriceInfo().getTimestamp() * 1000 + ((long) serviceTime * 60 * 60 * 24 * 1000));
        String validateDate = new SimpleDateFormat("yyyy-MM-dd").format(date);
        validityText.setText("有效期至: " + validateDate); //设置产品购买的有效期
        validateResult.setText(Html.fromHtml("<font color='#999999'>有效期至：</font><font color='#666666'> " + validateDate + "</font>"));

        int serviceTimeResult = serviceTime - oldSericeTime; //计算上次购买时间的差值
        serverTimeResult.setText(Html.fromHtml("<font color='#999999'>服务时长</font><font color='#666666'> " + (serviceTimeResult >= 0 ? " + "
                : " - ") + Math.abs(serviceTimeResult) + "天" + "</font>"));
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.serverProject: //服务项目
                GetProjectInfoActivity.actionStart(this, groupInfoList, groupId);
                break;
            case R.id.serviceTimeLayout: //服务时长
                ServiceTimePopWindow popWindow = new ServiceTimePopWindow(this, serverTimeList, new ServiceTimePopWindow.SelecteServiceTimeListener() {
                    @Override
                    public void getSelecteItem(Integer days, String dayDesc) {
                        serviceTime = days;
                        setValidate();
                        setPayBtnState(); //设置按钮状态
                        calculateOrderTotal();
//                        setRedTips(productInfo.getService_lave_days(), productInfo.getBuyer_person());
                    }
                });
                //显示窗口
                popWindow.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.cloudMemoryAdd://递增云盘
                cloudMemoryText.setText(Integer.parseInt(cloudMemoryText.getText().toString()) + 10 + "");
                break;
            case R.id.cloudMemoryRemove: //递减云盘
                final String cloudMemoryCount = cloudMemoryText.getText().toString();
                if (Integer.parseInt(cloudMemoryCount) <= minCloudMemory) { //不能低于云盘的最低值
                    cloudMemoryRemoveIcon.setImageResource(R.drawable.product_delete_unable);
                    return;
                }
                int result = Integer.parseInt(cloudMemoryCount) - 10;
                cloudMemoryText.setText(result < 0 ? "0" : result + "");
                break;
            case R.id.wxPayLayout: //选择微信支付
                if (payWay == ProductUtil.WX_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_normal);
                wxIcon.setImageResource(R.drawable.checkbox_pressed);
                payWay = ProductUtil.WX_PAY;
                break;
            case R.id.aliPayLayout: //选择支付宝支付
                if (payWay == ProductUtil.ALI_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_pressed);
                wxIcon.setImageResource(R.drawable.checkbox_normal);
                payWay = ProductUtil.ALI_PAY;
                break;
            case R.id.payBtn: //支付按钮
                if (TextUtils.isEmpty(groupNameText.getText().toString())) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请选择服务项目", CommonMethod.ERROR);
                    return;
                }
                if (!checkWarning()) {
                    return;
                }
                commitOrder();
                break;
            case R.id.renewalIcon: //项目续期
                //如果项目人数<=5人，则弹窗提示：
                //若无需续期黄金服务版，则需降级到基础免费版
                //你确定要降级到基础免费版吗？
                //取消 确定
                //点击【确定】，执行黄金服务版降级操作，并刷新本页面。
                //如果项目人数 > 5 人，则弹窗提示（与操作黄金版降级时的提示弹窗一致）：
                //免费版的使用人数不能超过5人，如需使用免费版，请进入[项目设置] 模块中将成员人数降到≤5 人。
//                final ProductInfo productInfo = this.productInfo;
//                if (productInfo.getIs_senior_expire() == 1 && productInfo.getIs_degrade() == 1) {
//                    int memberNum = Integer.parseInt(productInfo.getMembers_num());
//                    if (memberNum <= 5) {
//                        DialogTips dialogTips = new DialogTips(this, new DiaLogTitleListener() {
//                            @Override
//                            public void clickAccess(int position) {
//                                ProductUtil.degradeGroupHadnle(ConfirmCloudOrderNewActivity.this, ProductInfo.VERSION_ID, groupId, new ProductUtil.DegradeGroupListener() {
//                                    @Override
//                                    public void onSuccess() { //降级成功的表示
//                                        productInfo.setIs_senior_expire(0); //设置项目未过期的表示
//                                        productInfo.setIs_senior(0);//降级成功后设置普通版的标识
//                                        renewalLayout.setVisibility(View.GONE);
//                                    }
//                                });
//                            }
//                        }, "若无需续期黄金服务版，则需降级到基础免费版", -1);
//                        dialogTips.show();
//                    } else {
//                        ProductUtil.checkFreeVersionCondition(memberNum, this);
//                    }
//                }
                break;
        }
    }


    /**
     * 除管理员和创建者以外的用户不能在已购买服务的基础上进行减配操作，即普通用户不能将服务人数减至小于已订购人数，不能将云盘服务空间减小至小于已订购空间大小。
     * 管理员和创建者进行减配操作后，（即提交订单时如果 服务人数少于已订购人数 或者云盘服务空间小于已订购空间大小），则点击【立即支付】按钮后显示警示弹窗：
     * “在本平台所订购的服务均不支持退款，请谨慎进行该操作”
     * 【我再想想】 【继续支付】
     */
    public boolean checkWarning() {
        long cloudSpace = productInfo.getCloud_space();//已购买的云盘空间大小
        int cloudCount = Integer.parseInt(cloudMemoryText.getText().toString()); //购买的云盘空间大小
        if (cloudSpace != 0 && cloudCount < cloudSpace) {
            DialogWarningDialog dialogWarningDialog = new DialogWarningDialog(this, new DiaLogTitleListener() {
                @Override
                public void clickAccess(int position) {
                    commitOrder();
                }
            }, total <= 0 ? true : false);
            dialogWarningDialog.show();
            return false;
        }
        return true;
    }


    /**
     * 提交订单
     */
    public void commitOrder() {
        Order order = new Order();
        order.setGroup_id(groupId);
        order.setClass_type(WebSocketConstance.TEAM);
        order.setProduce_info(productInfo.getCloudPriceInfo()); //产品信息
        order.setService_time(serviceTime + ""); //服务时长
        if (!TextUtils.isEmpty(productInfo.getDonate_space())) {
            order.setDonate_space(Integer.parseInt(productInfo.getDonate_space())); //云盘赠送空间
        }
        order.setCloud_space(Integer.parseInt(cloudMemoryText.getText().toString())); //云盘购买空间
        order.setServer_counts(productInfo.getBuyer_person()); //服务人数
        ProductUtil.commitOrder(this, order, payWay);
    }


    /**
     * 初始化服务时长
     * SRD：代表云盘服务剩余天数，已过期未降级时 SRD = 0；免费云盘时 SRD = 0
     * 如果（ SRD > 0）：
     * 选项：SRD + 0.5年~5年中大于SRD的选项
     * 默认选项：SRD
     * % 如果（ SRD = 0）：
     * 选项：0.5年~5年共10个选项
     * 默认选项：0.5年
     */
    private void initServerTime() {
        int year = 360; //一年为360天
        int maxYear = 5; //能购买的最大时长为5年
        if (serverTimeList == null) {
            serverTimeList = new ArrayList<>();
        } else {
            serverTimeList.clear();
        }
        int cloud_lave_days = productInfo.getCloud_lave_days(); //云盘服务剩余天数
        if (cloud_lave_days != 0) {
            serverTimeList.add(cloud_lave_days);
        }
        if (cloud_lave_days < 90) { //如果剩余天数小于90天 则添加3个月的选项
            serverTimeList.add(90);
        }
        if (cloud_lave_days < year / 2) {//如果剩余天数小于180天(既半年) 则添加半年选项
            serverTimeList.add(year / 2);
        }
        if (cloud_lave_days > year * maxYear) { //如果已购买的时长 已经超出了5年则不能在继续购买了
            return;
        }
        for (int i = 1; i <= maxYear; i++) {
            if (cloud_lave_days > year * i) {
                continue;
            }
            serverTimeList.add(year * i);
        }
    }

    /**
     * US：代表项目已用云盘空间
     * BS：代表已购云盘空间
     * % 最小值：
     * 如果 US - 服务人数 * 2 < 0，则 最小值 = 0
     * 如果 US - 服务人数 * 2 >= 0 ，则最小值 = （US - 服务人数 * 2）向上取能被10整除的值
     * 如果 云盘空间 = 最小值，则减号按钮为禁用状态
     * % 最大值 = 默认值 + 1000G
     * 如果 云盘空间 = 最大值，则加号按钮为禁用状态
     * % 默认值：
     * 如果 BS < 最小值，则 默认值 = 最小值
     * 如果 BS > 最小值，则 默认值 = BS
     */
    private void initCloudMemory() {
        long memoryResult = (long) (productInfo.getUsed_space() - Integer.parseInt(productInfo.getMembers_num()) * 2);
        LUtils.e("memoryResult:" + memoryResult);
        if (memoryResult <= 0) {
            minCloudMemory = 0;
        } else if (memoryResult > 0) {
            if (memoryResult % 10 == 0) { // 不用向上取整
                minCloudMemory = memoryResult;
            } else {
                minCloudMemory = (int) Math.ceil(memoryResult / 10d) * 10;
            }
        }
        if (productInfo.getCloud_space() <= minCloudMemory) {
            cloudMemoryText.setText(minCloudMemory + "");
        } else if (productInfo.getCloud_space() > minCloudMemory) {
            cloudMemoryText.setText(productInfo.getCloud_space() + "");
        }
        int number = Integer.parseInt(cloudMemoryText.getText().toString());
        cloudMemoryRemoveIcon.setImageResource(number <= minCloudMemory ? R.drawable.product_delete_unable : R.drawable.product_delete_enable);
        LUtils.e("云盘最小值:" + minCloudMemory);
        LUtils.e("云盘默认值:" + cloudMemoryText.getText().toString());
    }

    /**
     * 计算订单的总金额
     * SRD: 代表云盘服务剩余天数，已过期未降级时 SRD = 0；免费云盘时 SRD = 0
     * BP:  代表项目已购人数
     * BS:  代表已购云盘空间
     * HRD: 代表黄金服务剩余天数，已过期未降级时 HRD = 0；免费版时 HRD = 0
     * % 实际订单金额 = （服务人数 * 服务时长天数 - BP * HRD） * 黄金版现价/90 + （云盘空间 * 云盘服务时长天数 - BS * SRD） * 云盘空间现价/10/90
     * 如果 实际订单金额 < 0，则 订单金额 = 0 （即不退款）
     * 如果 实际订单金额 >= 0，则 订单金额 = 实际订单金额
     * % 订单金额=0时，点击立即支付，弹出确认面板：
     * 该订单无需支付，你确定要提交该订单吗？
     * 【取消】【 确定】
     * 确认后直接跳转到支付成功页面
     * % 已优惠金额：
     * 如果 实际订单金额 < 0，则 不显示已优惠金额；
     * 如果 实际订单金额 >= 0，则 计算订单原价金额：
     * 订单原价金额 = （服务人数 * 服务时长天数 - BP * HRD） * 黄金版原价/90 + （云盘空间 * 服务时长天数 - BS * SRD） * 云盘空间原价/10/90
     * 已优惠金额 = 订单原价金额 - 订单金额
     * 如果 已优惠金额 <= 0，则 不显示已优惠金额
     * 如果 已优惠金额 > 0，则 显示已优惠金额
     */
    private void calculateOrderTotal() {
        float cloudEveryDayPrice = productInfo.getCloudPriceInfo().getPrice() / 10 / productInfo.getCloudPriceInfo().getService_time(); //云盘现价
//        float goldVersionEveryDayPrice = productInfo.getProductPriceInfo().getPrice() / productInfo.getProductPriceInfo().getService_time(); //黄金服务版现价
        int cloudCount = Integer.parseInt(cloudMemoryText.getText().toString()); //本次准备购买的云盘空间

//        float goldVersionDayTotal = 0f; //黄金服务版续期总天数
//        if (productInfo.getBuyer_person() > 0) {
//            int buyPerson = productInfo.getBuyer_person(); //已购买的人数
//            goldVersionDayTotal = (buyPerson * serviceTime - buyPerson * productInfo.getService_lave_days()) * goldVersionEveryDayPrice;//公式一 （已购买的人数 * 服务时长天数 - BP * HRD）* 黄金版原价/90
//        }
        //云盘续期总天数
        float cloudDayTotal = (cloudCount * serviceTime - productInfo.getCloud_space() * productInfo.getCloud_lave_days()) * cloudEveryDayPrice; //（云盘空间 * 服务时长天数 - BS * SRD） * 云盘空间原价/10/90
//        this.total = goldVersionDayTotal + cloudDayTotal; //产品总价(现价)
        this.total = cloudDayTotal; //产品总价(现价)

        if (total <= 0) { //如果 实际订单金额 < 0，则 不显示已优惠金额
            totalPriceText.setText(MoneyUtils.setMoney(getApplicationContext(), "¥ 0.00"));
            payBtn.setText("确认订单");
        } else {
            payBtn.setText("立即支付");
            totalPriceText.setText(MoneyUtils.setMoney(getApplicationContext(), "¥ " + Utils.m2(total))); //订单价格
        }
    }

    private void calcutelateCloudResult() {
        long serviceCloudResult = Integer.parseInt(cloudMemoryText.getText().toString()) - productInfo.getCloud_space(); //计算云盘差值
        cloudResult.setText(Html.fromHtml("<font color='#999999'>云盘空间</font><font color='#666666'>" + (serviceCloudResult >= 0 ? " + " : " - ") + Math.abs(serviceCloudResult) + "G</font>"));
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        LUtils.e("resultCode:" + resultCode + "                       onActivityResult ");
        if (resultCode == Constance.GET_PROJECT_INFO) { //选择服务项目回调
            ProductInfo info = (ProductInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            info.setProductPriceInfo(productInfo.getProductPriceInfo());
            info.setCloudPriceInfo(productInfo.getCloudPriceInfo());
            setBaseInfo(info);
            initBaseData();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }


    private void setBaseInfo(ProductInfo info) {
        productInfo = info;
        groupNameText.setText(info.getGroup_name()); //项目组名称
        groupId = info.getGroup_id();
        serviceTime = info.getCloud_lave_days() != 0 ? info.getCloud_lave_days() : 90;
        oldSericeTime = info.getCloud_lave_days();
        //如果当前版本是已过期的黄金服务版，并且有降级权限的操作 则显示已勾选的复选框 和 “黄金服务版的服务人数（6人）和赠送空间（12G）将同时续期33天”。
//        getImageView(R.id.renewalIcon).setVisibility(productInfo.getIs_senior_expire() == 1 && productInfo.getIs_degrade() == 1 ? View.VISIBLE : View.GONE);
    }


}
