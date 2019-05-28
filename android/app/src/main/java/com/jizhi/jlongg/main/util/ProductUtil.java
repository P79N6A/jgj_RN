package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.text.Html;
import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;
import com.facebook.react.bridge.Callback;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.pay.OrderSuccessActivity;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Order;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.bean.ProductPriceInfo;
import com.jizhi.jlongg.main.bean.WxCallBack;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.pay.DialogFreeVersionGtFiveMember;
import com.jizhi.jlongg.main.dialog.pay.DialogMemoryGtTwoGbMember;
import com.jizhi.jlongg.main.dialog.pay.DialogMoreThanFreeCount;
import com.jizhi.jlongg.main.dialog.pay.DialogNotEnoughCloudSpace;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.List;

import util.PayResult;

/**
 * Created by Administrator on 2017/7/20 0020.
 */

public class ProductUtil {

    /**
     * 支付宝支付编号
     */
    public static final int ALI_PAY = 2;
    /**
     * 微信支付编号
     */
    public static final int WX_PAY = 1;

    //订单状态(1:未支付；2支付完成)
    /**
     * 未支付
     */
    public static final int UN_PAID = 1;
    /**
     * 已支付
     */
    public static final int PAID = 2;
    /**
     * 支付成功-->回首页
     */
    public static final int PAID_GO_HOME = 0X55;
    /**
     * 支付成功-->查看订单
     */
    public static final int PAID_GO_TO_ORDERLIST = 0X56;
    /**
     * 已支付保证金
     */
    public static final int PAID_BAILCACH = 0X57;

    /**
     * 提交订单
     */
    public static void commitOrder(final BaseActivity activity, Order order, final int payWay) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", order.getGroup_id()); //组id
        params.addBodyParameter("class_type", order.getClass_type()); //组类型
        params.addBodyParameter("server_id", order.getProduce_info().getServer_id() + ""); //服务id
//        params.addBodyParameter("price", order.getProduce_info().getPrice() + ""); //产品现价
        params.addBodyParameter("time", order.getService_time() + ""); //服务时长
        params.addBodyParameter("donate_space", order.getDonate_space() + ""); //赠送空间
        params.addBodyParameter("server_cloud", order.getCloud_space() + ""); //购买云盘服务，云盘大小
        params.addBodyParameter("pay_type", payWay + ""); //支付类型，默认是微信支付，值为1；支付宝支付，值2
//        params.addBodyParameter("discount_amount", order.getDiscount_amount() + ""); //优惠金额
        params.addBodyParameter("server_person", order.getServer_counts() + ""); //	购买黄金服务时，服务人数
//        params.addBodyParameter("total_amount", order.getTotal_amount() + ""); //总价
        if (!TextUtils.isEmpty(order.getDetail())) {
            params.addBodyParameter("detail", order.getDetail()); //订单说明
        }
        if (!TextUtils.isEmpty(order.getOrder_id())) {
            params.addBodyParameter("order_id", order.getOrder_id()); //订单id号
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PAY_ORDER, params, activity.new RequestCallBackExpand() {
            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonJson<ProductInfo> bean = CommonJson.fromJson(responseInfo.result.toString(), ProductInfo.class);
                    if (bean.getState() != 0) {
                        if (bean.getValues().getRecord_id().equals("1")) { //当record_id等于1的时候说明订单不需要支付 直接跳转到 支付成功的页面
                            OrderSuccessActivity.actionStart(activity); // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                            return;
                        }
                        if (payWay == WX_PAY) { //微信支付
                            wxPayCallBack(bean.getValues().getRecord_id(), activity);
                        } else if (payWay == ALI_PAY) { //支付宝支付
                            aliPayCallBack(bean.getValues().getRecord_id(), activity);
                        }
                    } else {
                        DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 获取服务时长
     *
     * @param serviceTime
     * @return
     */
    public static String getServerTimeString(int serviceTime) {
        final int dayOfHalfYear = 180; // 半年的天数
        switch (serviceTime) {
            case dayOfHalfYear / 2:
                return "3个月";
            case dayOfHalfYear:
                return "0.5年(半年)";
            case dayOfHalfYear * 2:
                return "1年";
            case dayOfHalfYear * 3:
                return "1.5年";
            case dayOfHalfYear * 4:
                return "2年";
            case dayOfHalfYear * 5:
                return "2.5年";
            case dayOfHalfYear * 6:
                return "3年";
            case dayOfHalfYear * 7:
                return "3.5年";
            case dayOfHalfYear * 8:
                return "4年";
            case dayOfHalfYear * 9:
                return "4.5年";
            case dayOfHalfYear * 10:
                return "5年";
            default:
                return serviceTime + "天(当前剩余天数)";
        }
    }

    /**
     * 支付宝回调
     *
     * @param orderInfo
     * @param activity
     */
    public static void aliPayCallBack(final String orderInfo, final Activity activity) {
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                final PayResult payResult = new PayResult(new PayTask(activity).payV2(Html.fromHtml(orderInfo).toString(), true));
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        /**
                         对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                         */
                        // 判断resultStatus 为9000则代表支付成功
                        if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                            OrderSuccessActivity.actionStart(activity); // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                        } else {
                            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                        }
                    }
                });
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    public static void wxPayCallBack(final String orderInfo, Activity activity) {
        if (TextUtils.isEmpty(orderInfo)) {
            CommonMethod.makeNoticeShort(activity, "获取订单信息失败", CommonMethod.ERROR);
            return;
        }
        try {
            Gson gson = new Gson();
            WxCallBack wxCallBack = gson.fromJson(orderInfo, WxCallBack.class);
            IWXAPI api = WXAPIFactory.createWXAPI(activity, wxCallBack.getAppid());
            api.registerApp(wxCallBack.getAppid());
            PayReq req = new PayReq();
            req.appId = wxCallBack.getAppid();// 微信开放平台审核通过的应用APPID
            req.partnerId = wxCallBack.getPartnerid();// 微信支付分配的商户号
            req.prepayId = wxCallBack.getPrepayid();// 预支付订单号，app服务器调用“统一下单”接口获取
            req.nonceStr = wxCallBack.getNoncestr();// 随机字符串，不长于32位，服务器小哥会给咱生成
            req.timeStamp = wxCallBack.getTimestamp();// 时间戳，app服务器小哥给出
            req.packageValue = wxCallBack.getPackage_name();// 固定值Sign=WXPay，可以直接写死，服务器返回的也是这个固定值
            req.sign = wxCallBack.getSign();// 签名，服务器小哥给出，他会根据：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3指导得到这个
//			req.extData = "app data"; // optional
            // 在支付之前，如果应用没有注册到微信，应该先调用IWXMsg.registerApp将应用注册到微信
            api.sendReq(req);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(activity, e.getMessage(), CommonMethod.ERROR);
        }
    }


    /**
     * 支付成功 失败回调
     */
    public interface PayStatusListener {
        public void onSuccess();

        public void onFauile();
    }

    /**
     * 获取产品信息
     */
    public static void getProductInfo(final BaseActivity activity, final GetProductListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_ORDER_INFO, params, activity.new RequestCallBackExpand() {
            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonJson<ProductPriceInfo> base = CommonJson.fromJson(responseInfo.result.toString(), ProductPriceInfo.class);
                    if (base.getState() != 0) {
                        ProductPriceInfo productInfo = null;
                        ProductPriceInfo cloudInfo = null;
                        if (base.getValues().getList() == null || base.getValues().getList().size() == 0) {
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            activity.closeDialog();
                            activity.finish();
                            return;
                        }
                        for (ProductPriceInfo bean : base.getValues().getList()) {
                            if (bean.getServer_id() == ProductInfo.VERSION_ID) {
                                productInfo = bean;
                            } else if (bean.getServer_id() == ProductInfo.CLOUD_ID) {
                                cloudInfo = bean;
                            }
                        }
                        if (productInfo == null && cloudInfo == null) {
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            activity.closeDialog();
                            activity.finish();
                            return;
                        }
                        getProjectInfo(activity, productInfo, cloudInfo, listener);
                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                        activity.finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                    activity.closeDialog();
                    activity.finish();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                activity.finish();
            }
        });
    }

    /**
     * 获取项目信息
     *
     * @param productPriceInfo
     */
    public static void getProjectInfo(final BaseActivity activity, final ProductPriceInfo productPriceInfo, final ProductPriceInfo cloudPriceInfo, final GetProductListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_TEAM_LIST, params, activity.new RequestCallBackExpand() {
            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                activity.closeDialog();
                try {
                    CommonListJson<ProductInfo> base = CommonListJson.fromJson(responseInfo.result.toString(), ProductInfo.class);
                    if (base.getState() != 0) {
                        List<ProductInfo> list = base.getValues();
                        for (ProductInfo bean : list) {
                            if (bean.getUsed_space() != 0) { //云盘使用空间转换为GB 为单位
                                bean.setUsed_space(bean.getUsed_space() / 1024 / 1024 / 1024);
                            }
                        }
                        if (listener != null) {
                            listener.onSuccess(base.getValues(), productPriceInfo, cloudPriceInfo);
                        }
                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                        activity.finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                    activity.finish();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                activity.finish();
            }
        });
    }


    /**
     * 云盘空间是否够用 总空间-已用空间 <= 0G
     *
     * @param activity   activity
     * @param useSpace   云盘已用空间
     * @param totalSpace 云盘总空间大小
     * @param teamId     项目组id
     */
    public static boolean IscloudSpaceEnough(final BaseActivity activity, double useSpace, double totalSpace, final String teamId) {
        if (totalSpace - useSpace <= 0) {
            DialogNotEnoughCloudSpace dialogNotEnoughCloudSpace = new DialogNotEnoughCloudSpace(activity, new DiaLogTitleListener() {
                @Override
                public void clickAccess(int position) { //立即扩容
//                    ConfirmVersionOrderNewActivity.actionStart(activity, teamId);
                }
            });
            dialogNotEnoughCloudSpace.show();
            return false;
        }
        return true;
    }


    /**
     * 验证免费版的人数是否已超过了5人
     *
     * @param activity
     * @param teamId      项目组id
     * @param isDegrade   是否有权限降级操作 1表示有 0表示没有
     * @param teamName    项目名称
     * @param memberNum   成员数量
     * @param tipUpdate   如果是从群聊升级上来的人则可能会最大人数超过5人 需要判断是否能使用免费版 1为超过了5个人  0为未超过5个人
     * @param isAddPerson 是否是添加成员
     * @return
     */
    public static boolean checkFreeVersionIsMoreFiveMember(final BaseActivity activity, final String teamId,
                                                           boolean isDegrade, String teamName, final int memberNum,
                                                           int tipUpdate, boolean isAddPerson) {
//        if (tipUpdate == 1) { //如果是从群聊升级上来的人则可能会最大人数超过5人 如果超过了需要将人数下降为5个人 1为超过了5个人  0为未超过5个人
//            DialogGtFiveMemberFreeDialog expireDialog = new DialogGtFiveMemberFreeDialog(activity, new ExpireListener() {
//                @Override
//                public void nowRenew() { //立即续期
//                    ConfirmVersionOrderNewActivity.actionStart(activity, teamId);
//                }
//
//                @Override
//                public void degradeFreeVersion() { //使用免费版
//                    //验证人数是否已超过5人
//                    checkFreeVersionCondition(memberNum, activity);
//                }
//            }, isDegrade, teamName, isAddPerson);
//            expireDialog.show();
//            return true;
//        }
        return false;
    }


    /**
     * 检查黄金版和云盘弹出框过期提示框
     *
     * @param isSeniorExpire 项目是否过期  1表示过期 0表示未过期
     * @param teamId         项目组id
     * @param isDegrade      是否有权限降级操作
     * @param teamName       项目名称
     * @param memberNum      成员数量
     * @param buyerPerson    已购买的数量
     * @param isAddPerson    是否是添加成员
     * @param listener       降级回调
     */
    public static boolean checkCloudAndVersionIsExpire(final BaseActivity activity, int isSeniorExpire, final String teamId,
                                                       boolean isDegrade, String teamName, final int memberNum, int buyerPerson,
                                                       boolean isAddPerson, final DegradeGroupListener listener) {
//        if (isSeniorExpire == 1) { //黄金服务版和云盘已过期 弹出已过期的项目提示
//            DialogExpire expireDialog = new DialogExpire(activity, new ExpireListener() {
//                @Override
//                public void nowRenew() { //立即续期
//                    ConfirmVersionOrderNewActivity.actionStart(activity, teamId);
//                }
//
//                @Override
//                public void degradeFreeVersion() { //降级使用免费版
//                    if (checkFreeVersionCondition(memberNum, activity)) {
//                        degradeGroupHadnle(activity, ProductInfo.VERSION_ID, teamId, listener);
//                    }
//                }
//            }, isDegrade, teamName, isAddPerson);
//            expireDialog.show();
//            return true;
//        }
//        if (isAddPerson) { //如果是添加成员还
//            if (memberNum >= buyerPerson) { //如果项目组成员数量大于购买的数量 则需要弹出 继续购买的框
//                DialogMaxNumberOf dialog = new DialogMaxNumberOf(activity, new DiaLogTitleListener() {
//                    @Override
//                    public void clickAccess(int position) {
//                        ConfirmVersionOrderNewActivity.actionStart(activity, teamId);
//                    }
//                });
//                dialog.show();
//                return true;
//            }
//        }
        return false;
    }


    /**
     * 检查免费版是否已经超过5人
     *
     * @param memberNum 成员数量
     * @param activity
     * @return
     */
    public static boolean checkFreeVersionCondition(int memberNum, BaseActivity activity) {
//        if (memberNum > 5) {//如果成员数量大于5则不准降级
//            DialogFreeVersionGtFiveMember dialogFreeVersionGtFiveMember = new DialogFreeVersionGtFiveMember(activity);
//            dialogFreeVersionGtFiveMember.show();
//            return false;
//        }
        return true;
    }


    /**
     * 检查免费版人数是否超过5人，云盘空间是否超过了2G
     *
     * @param useSpace  云盘已用空间 GB为单位
     * @param memberNum 成员数量
     * @param activity
     * @return
     */
    private static boolean checkFreeVersionAndCloudSpaceCondition(final double useSpace, int memberNum, BaseActivity activity) {
        if (useSpace >= 2 && memberNum > 5) { //云盘空间使用空间大于2个G和项目人数大于5人 则不准降级  需要用户手动去减少到相应条件
            DialogMoreThanFreeCount dialogMoreThanFreeCount = new DialogMoreThanFreeCount(activity);
            dialogMoreThanFreeCount.show();
            return false;
        } else if (useSpace >= 2) { ///云盘空间使用空间大于2个G则不准降级
            DialogMemoryGtTwoGbMember dialogMemoryGtTwoGbMember = new DialogMemoryGtTwoGbMember(activity);
            dialogMemoryGtTwoGbMember.show();
            return false;
        } else if (memberNum > 5) {//如果成员数量大于5则不准降级
            DialogFreeVersionGtFiveMember dialogFreeVersionGtFiveMember = new DialogFreeVersionGtFiveMember(activity);
            dialogFreeVersionGtFiveMember.show();
            return false;
        }
        return true;
    }


    /**
     * 验证添加人员权限
     *
     * @param activity
     * @param isSenior           1是高级版
     * @param memberNum          成员数量
     * @param selectePersonCount 选中的人数
     * @param buyerPerson        已购买的人数
     * @param groupId            项目组id
     * @return
     */
    public static boolean checkAddPersonPermission(final BaseActivity activity, int isSenior, int memberNum, int selectePersonCount, int buyerPerson, final String groupId) {
//        if (isSenior == ProductInfo.VERSION_ADVANCED) { //当前为高级版
//            if (memberNum + selectePersonCount > 500) {
//                CommonMethod.makeNoticeShort(activity, "项目成员人数不能超过500人", CommonMethod.ERROR);
//                return true;
//            }
//            if (memberNum + selectePersonCount > buyerPerson) { //如果项目组成员数量大于购买的数量 则需要弹出 继续购买的框
//                DialogMaxNumberOf dialog = new DialogMaxNumberOf(activity, new DiaLogTitleListener() {
//                    @Override
//                    public void clickAccess(int position) {
//                        ConfirmVersionOrderNewActivity.actionStart(activity, groupId);
//                    }
//                });
//                dialog.show();
//                return true;
//            }
//        } else { //普通版
//            if (memberNum + selectePersonCount > 5) { //如果项目组成员数量大于购买的数量 则需要弹出 继续购买的框
//                DialogMaxNumberOf dialog = new DialogMaxNumberOf(activity, new DiaLogTitleListener() {
//                    @Override
//                    public void clickAccess(int position) {
//                        ConfirmVersionOrderNewActivity.actionStart(activity, groupId);
//                    }
//                });
//                dialog.show();
//                return true;
//            }
//        }
        return false;
    }


    /**
     * 处理项目降级
     *
     * @param isHandle 1：高级版，2：云盘
     */
    public static void degradeGroupHadnle(final BaseActivity activity, final int isHandle, String groupId, final DegradeGroupListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("is_handle", isHandle + "");
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        params.addBodyParameter("group_id", groupId);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEGRADE_GROUP_HANDLE,
                params, activity.new RequestCallBackExpand() {
                    @Override
                    public void onSuccess(ResponseInfo responseInfo) {
                        activity.closeDialog();
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result.toString(), BaseNetBean.class);
                            if (base.getState() != 0) {
                                CommonMethod.makeNoticeShort(activity, "操作成功", CommonMethod.SUCCESS);
                                listener.onSuccess();
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                    }
                });
    }

    /**
     * 支付宝回调网页
     *
     * @param orderInfo
     * @param activity
     */
    public static void aliPayCallBack(final String orderInfo, final Activity activity, final CallBackFunction function) {
        LUtils.e("-----------------" + orderInfo);
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                final PayResult payResult = new PayResult(new PayTask(activity).payV2(Html.fromHtml(orderInfo).toString(), true));
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        LUtils.e("-----------------" + orderInfo);
                        /**
                         对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                         */
                        // 判断resultStatus 为9000则代表支付成功
                        PayBean payBean = new PayBean();
                        if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                            // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                            LUtils.e("succes:" + new Gson().toJson(payResult));
                            payBean.setState(1);
                        } else {
                            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                            LUtils.e("error:" + new Gson().toJson(payResult));
                            payBean.setState(0);
                        }
                        payBean.setPay_type(2);
                        function.onCallBack(new Gson().toJson(payBean));
                    }
                });
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }
    /**
     * 支付宝回调网页
     *
     * @param orderInfo
     * @param activity
     */
    public static void aliPayCallBack(final String orderInfo, final Activity activity, final Callback callback) {
        LUtils.e("-----------------" + orderInfo);
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                final PayResult payResult = new PayResult(new PayTask(activity).payV2(Html.fromHtml(orderInfo).toString(), true));
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        LUtils.e("------pay-1----------" + orderInfo);
                        /**
                         对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                         */
                        // 判断resultStatus 为9000则代表支付成功
                        PayBean payBean = new PayBean();
                        if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                            // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                            LUtils.e("succes:" + new Gson().toJson(payResult));
                            payBean.setState(1);
                        } else {
                            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                            LUtils.e("error:" + new Gson().toJson(payResult));
                            payBean.setState(0);
                        }
                        payBean.setPay_type(2);
                        LUtils.e("------pay---2--------" + orderInfo);
                        callback.invoke(new Gson().toJson(payBean));
                    }
                });
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }
    /**
     * 获取产品的信息
     */
    public interface GetProductListener {
        public void onSuccess(List<ProductInfo> list, ProductPriceInfo productPriceInfo, ProductPriceInfo cloudPriceInfo);
    }

    /**
     * 降级产品回调
     */
    public interface DegradeGroupListener {
        public void onSuccess();
    }

    public interface ExpireListener {
        public void nowRenew(); //立即续期

        public void degradeFreeVersion(); //降级使用免费版

    }

}
