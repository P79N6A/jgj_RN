package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.text.TextUtils;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import static com.jizhi.jlongg.main.util.LogoutUitl.closeDialog;

/**
 * Created by Administrator on 2017/5/13 0013.
 */

public class RecordUtils {
    /**
     * 获取差帐详情
     *
     * @param id
     */
    public static void getShowPoor(final Activity activity, String id, final CheckBillDialog.ShowPoorClickListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", id);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SHOW_POOR_TIP, params,
                new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<DiffBill> bean = CommonJson.fromJson(responseInfo.result, DiffBill.class);
                            if (bean.getState() == 0) {
                                DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                            } else {
                                listener.showPoorClick(bean.getValues());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) {
                        closeDialog();
                    }
                });
    }

    /**
     * 获取上班时长统计String
     *
     * @param totalManhour         上班总时长
     * @param isShowShangBanString true 显示上班文字
     * @return
     */
    public static String getNormalTotalWorkString(float totalManhour, boolean isShowShangBanString) {
        StringBuilder builder = new StringBuilder();
        if (isShowShangBanString) {
            builder.append("上班  ");
        }
        if (totalManhour == 0) { //如果上班总时长等于0 则记录的-.-
            builder.append("-.-");
            return builder.toString();
        }
        if ((totalManhour + "").contains(".0")) { //如果是小数位刚好是0 则取消小数位
            builder.append((int) totalManhour);
        } else {
            builder.append(totalManhour);
        }
        builder.append("个工");
        return builder.toString();
    }

    /**
     * 获取加班时长统计String
     *
     * @param totalOverTime      加班总时长
     * @param isShowJiabanString true 显示加班文字
     * @return
     */
    public static String getOverTimeTotalWorkString(float totalOverTime, boolean isShowJiabanString) {
        StringBuilder builder = new StringBuilder();
        if (isShowJiabanString) {
            builder.append("加班  ");
        }
        if (totalOverTime == 0) { //如果加班总时长等于0 则显示-.-
            builder.append("-.-");
            return builder.toString();
        }
        if ((totalOverTime + "").contains(".0")) { //如果是小数位刚好是0 则取消小数位
            builder.append((int) totalOverTime);
        } else {
            builder.append(totalOverTime);
        }
        builder.append("个工");
        return builder.toString();
    }


    /**
     * 按工天显示
     *
     * @param manhour              上班时长
     * @param isShowShangbanString 是否显示上班字符串
     * @param isStatistics         是否是记工统计
     * @return
     */
    public static String getNormalWorkUtil(String manhour, boolean isShowShangbanString, boolean isStatistics) {
        if (TextUtils.isEmpty(manhour)) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        if (isShowShangbanString) {
            builder.append("上班：");
        }
        if (!isStatistics && manhour.equals("0")) { //如果manhour等于0 则记录的是休息
            builder.append("休息");
            return builder.toString();
        }
        builder.append(manhour + "个工");
        return builder.toString();
    }

    /**
     * 按工天显示
     *
     * @param overTime             加班时长
     * @param isShowShangbanString 是否显示加班字符串
     * @param isStatistics         是否是记工统计
     * @return
     */
    public static String getOverTimeWorkUtil(String overTime, boolean isShowShangbanString, boolean isStatistics) {
        if (TextUtils.isEmpty(overTime)) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        if (isShowShangbanString) {
            builder.append("加班：");
        }
        if (!isStatistics && overTime.equals("0")) { //如果manhour等于0 则记录的是休息
            builder.append("无加班");
            return builder.toString();
        }
        builder.append(overTime + "个工");
        return builder.toString();
    }


    /**
     * 获取上班时长String
     *
     * @param manhour              上班时长
     * @param isShowShangbanString 是否显示上班字符串
     * @param showType             显示类型 1为按小时显示   2为按工显示
     * @param isStatistics         是否是记工统计
     * @return
     */
    public static String getNormalWorkString(float manhour, boolean isShowShangbanString, int showType, boolean isStatistics) {
        StringBuilder builder = new StringBuilder();
        if (isShowShangbanString) {
            builder.append("上班：");
        }
        if (!isStatistics && manhour == 0) { //如果manhour等于0 则记录的是休息
            builder.append("休息");
            return builder.toString();
        }
        builder.append(RecordUtils.cancelIntergerZeroFloat(manhour));
        builder.append(showType == AccountUtil.WORK_AS_UNIT ? "个工" : "小时");
        return builder.toString();
    }


    /**
     * 获取加班时长String
     *
     * @param overTime           加班时长
     * @param isShowJiabanString 是否显示加班字符串
     * @param showType           显示类型 1为按小时显示   2为按工显示
     * @param isStatistics       是否是记工统计
     * @return
     */
    public static String getOverTimeWorkString(float overTime, boolean isShowJiabanString, int showType, boolean isStatistics) {
        StringBuilder builder = new StringBuilder();
        if (isShowJiabanString) {
            builder.append("加班：");
        }
        if (!isStatistics && overTime == 0) { //如果manhour等于0 则记录的是休息
            builder.append("无加班");
            return builder.toString();
        }
        builder.append(RecordUtils.cancelIntergerZeroFloat(overTime));
        builder.append(showType == AccountUtil.WORK_AS_UNIT ? "个工" : "小时");
        return builder.toString();
    }


    /**
     * double取消 小数点
     *
     * @param f
     * @return
     */
    public static String cancelIntergerZeroFloat(double f) {
//        if ((f + "").contains(".0")) {
//            return ((int) f + "");
//        }
//        return f + "";
        String[] tempS = (String.valueOf(f)).split("\\.");
        return tempS.length > 1 ? (tempS[1].equals("0") || tempS[1].equals("00") ? tempS[0] : f + "") : f + "";
    }

    /**
     * float取消 小数点
     *
     * @param f
     * @return
     */
    public static String cancelIntergerZeroFloat(float f) {
        String[] tempS = (String.valueOf(f)).split("\\.");
        return tempS.length > 1 ? (tempS[1].equals("0") || tempS[1].equals("00") ? tempS[0] : f + "") : f + "";
    }

    /**
     * float取消 小数点
     *
     * @param f
     * @return
     */
    public static String cancelIntergerZeroFloat(String f) {
        if (TextUtils.isEmpty(f)) {
            return null;
        }
        String[] tempS = f.split("\\.");
        if (tempS[1].equals("0") || tempS[1].equals("00")) {
            return tempS[0];
        } else if (tempS[1].endsWith("0")) { //最后一位为0 tempS[1].substring(tempS[1].length() - 1, tempS[1].length()).equals("0")
            String value = f + "";
            return value.substring(0, value.length() - 1);
        } else {
            return f + "";
        }
//        return tempS.length > 1 ? (tempS[1].equals("0") || tempS[1].equals("00") ? tempS[0] : f + "") : f + "";
    }

    /**
     * float取消 小数点
     *
     * @param f
     * @return
     */
    public static boolean containsZero(float f) {
        String[] tempS = (String.valueOf(f)).split("\\.");
        return tempS.length > 1 ? (tempS[1].equals("0") || tempS[1].equals("00") ? true : false) : false;
//        if ((f + "").contains(".0")) {
//            return true;
//        }
//        return false;
    }


}