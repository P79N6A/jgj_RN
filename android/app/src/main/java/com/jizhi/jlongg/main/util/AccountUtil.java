package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.AccountSwitchConfirm;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 记工记账 工具
 */
public class AccountUtil {

    /**
     * 以工为单位
     */
    public static final String WORK_SHOW_TYPE = "0";

    /**
     * 以小时为单位
     */
    public static final int WORK_OF_HOUR = 1;
    /**
     * 以工为单位
     */
    public static final int WORK_AS_UNIT = 2;
    /**
     * 上班按工天，加班按小时”“按工天
     */
    public static final int MANHOUR_AS_UNIT_OVERTIME_AS_HOUR = 3;


    /**
     * 获取默认记账单位
     */
    public static int getDefaultAccountUnit(Context context) {
        return (int) (SPUtils.get(context, "account_unit", MANHOUR_AS_UNIT_OVERTIME_AS_HOUR, Constance.JLONGG));
    }

    /**
     * 设置记账单位
     *
     * @param context
     * @param accountUnit
     */
    public static void setDefaultAccountUnit(Context context, int accountUnit) {
        CommonMethod.makeNoticeLong(context.getApplicationContext(), "切换成功！", CommonMethod.SUCCESS);
        SPUtils.put(context, "account_unit", accountUnit, Constance.JLONGG);
    }

    /**
     * 点工
     */
    public static final String HOUR_WORKER = "1";
    /**
     * 包工记账
     */
    public static final String CONSTRACTOR = "2";
    /**
     * 借支
     */
    public static final String BORROWING = "3";
    /**
     * 结算
     */
    public static final String SALARY_BALANCE = "4";
    /**
     * 包工记工天
     */
    public static final String CONSTRACTOR_CHECK = "5";


    //整型
    /**
     * 点工
     */
    public static final int HOUR_WORKER_INT = 1;
    /**
     * 包工记账
     */
    public static final int CONSTRACTOR_INT = 2;
    /**
     * 借支
     */
    public static final int BORROWING_INT = 3;
    /**
     * 结算
     */
    public static final int SALARY_BALANCE_INT = 4;
    /**
     * 包工记工天
     */
    public static final int CONSTRACTOR_CHECK_INT = 5;


    /**
     * 获取对账开关的状态
     */
    public static void getRecordConfirmStatus(Context context, CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.RECORD_CONFIRM_OFF_STATUS;
        CommonHttpRequest.commonRequest(context, httpUrl, AccountSwitchConfirm.class, CommonHttpRequest.OBJECT,
                RequestParamsToken.getExpandRequestParams(context.getApplicationContext()), true, callBack);
    }


    /**
     * 时间判断
     *
     * @param agencyGroupUser
     * @param activity
     * @param intYear
     * @param intMonth
     * @param intDay
     */
    public static boolean TimeJudgment(Activity activity, AgencyGroupUser agencyGroupUser, int intYear, int intMonth, int intDay) {
        if (agencyGroupUser != null) {
            if (!TextUtils.isEmpty(agencyGroupUser.getStart_time()) && !TextUtils.isEmpty(agencyGroupUser.getEnd_time())) {
                //开始结束时间不为空
                int intStratTime = Integer.parseInt(agencyGroupUser.getStart_time().replace("-", ""));
                int intendTime = Integer.parseInt(agencyGroupUser.getEnd_time().replace("-", ""));
//                            LUtils.e(intStratTime + "-----------AAA-----------" + intendTime);
                if (intYear * 10000 + intMonth * 100 + intDay < intStratTime || intYear * 10000 + intMonth * 100 + intDay > intendTime) {
                    CommonMethod.makeNoticeShort(activity, "代班长只能在" + agencyGroupUser.getStart_time() + "~" + agencyGroupUser.getEnd_time() + "时间段内记账", CommonMethod.ERROR);
                    return true;
                }
            } else if (!TextUtils.isEmpty(agencyGroupUser.getStart_time()) && TextUtils.isEmpty(agencyGroupUser.getEnd_time())) {
                //开始时间不为空
                //开始结束时间不为空
                int intStratTime = Integer.parseInt(agencyGroupUser.getStart_time().replace("-", ""));
//                            LUtils.e(intStratTime + "----------BBB------------");
                if (intYear * 10000 + intMonth * 100 + intDay < intStratTime) {
                    CommonMethod.makeNoticeShort(activity, "代班长不能记录" + agencyGroupUser.getStart_time() + "以前的账", CommonMethod.ERROR);
                    return true;
                }
            } else if (TextUtils.isEmpty(agencyGroupUser.getStart_time()) && !TextUtils.isEmpty(agencyGroupUser.getEnd_time())) {
                //结束时间不为空
                //开始结束时间不为空
                int intendTime = Integer.parseInt(agencyGroupUser.getEnd_time().replace("-", ""));
//                            LUtils.e("-------------CCC---------" + intendTime);
                if (intYear * 10000 + intMonth * 100 + intDay > intendTime) {
                    CommonMethod.makeNoticeShort(activity, "代班长不能记录" + agencyGroupUser.getEnd_time() + "以后的账", CommonMethod.ERROR);
                    return true;
                }
            }
        } else {
            if (intYear * 10000 + intMonth * 100 + intDay < Constance.STARTTIME) {
                CommonMethod.makeNoticeShort(activity, "最早只能记录到2014年01月01日", CommonMethod.ERROR);
                return true;
            }
        }
        int currentTime = TimesUtils.getCurrentTimeYearMonthDay()[0] * 10000 + TimesUtils.getCurrentTimeYearMonthDay()[1] * 100 + TimesUtils.getCurrentTimeYearMonthDay()[2];
        if (intYear * 10000 + intMonth * 100 + intDay > currentTime) {
            CommonMethod.makeNoticeShort(activity, "不能记录今天之后的日期", CommonMethod.ERROR);
            return true;
        }
        return false;
    }

    /**
     * 获取差帐信息
     *
     * @param activity
     * @param id       账目id
     * @param listener 调用接口成功的回调
     */
    public static void getPoorInfo(final BaseActivity activity, String id, String group_id, final GetPoorInfoListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", id);
        if (!TextUtils.isEmpty(group_id)) {
            params.addBodyParameter("group_id", group_id);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SHOW_POOR_TIP, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<DiffBill> bean = CommonJson.fromJson(responseInfo.result, DiffBill.class);
                    if (bean.getState() != 0) {
                        if (listener != null) {
                            listener.loadSuccess(bean.getValues());
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
     * 复制记账
     *
     * @param activity
     * @param diffBill    差帐信息
     * @param accountType 账目类型
     * @param listener    复制成功的回调
     */
    public static void copyAccount(final BaseActivity activity, DiffBill diffBill, String accountType, final CopyAccountListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", diffBill.getId() + "");
        params.addBodyParameter("main_set_amount", (diffBill.getSecond_set_amount()) + "");
        if (accountType.equals(AccountUtil.HOUR_WORKER)) {
            // 1:点工
            params.addBodyParameter("main_manhour", (diffBill.getSecond_manhour()) + "");
            params.addBodyParameter("main_overtime", (diffBill.getSecond_overtime()) + "");
        } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
            //2:包工
            params.addBodyParameter("main_manhour", (diffBill.getSecond_set_unitprice()) + "");
            params.addBodyParameter("main_overtime", (diffBill.getSecond_set_quantities()) + "");
        } else {
            params.addBodyParameter("main_manhour", "0");
            params.addBodyParameter("main_overtime", "0");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MPOORINFO, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<BaseNetBean> bean = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (bean.getState() != 0) {
                        if (listener != null) {
                            listener.copySuccess();
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
     * 复制记账
     */
    public interface CopyAccountListener {
        public void copySuccess();
    }

    /**
     * 获取差帐信息
     */
    public interface GetPoorInfoListener {
        public void loadSuccess(DiffBill bean);
    }


    /**
     * 获取记工显示方式
     *
     * @param context
     * @param isShowFirstTips 是否显示加班 或者上班两个提示语 比如上班:xx个工
     * @param isStatistics    是否是记工统计如果为true的话 当数据等于0的时候不会显示成休息或无加班
     * @param isManhour       true 表示上班、false表示加班
     * @param workingAsHour
     * @param workingAsUnit
     * @return
     */
    public static String getAccountShowTypeString(Context context, boolean isShowFirstTips, boolean isStatistics, boolean isManhour, float workingAsHour, String workingAsUnit) {
        int current_work_show_flag = AccountUtil.getDefaultAccountUnit(context.getApplicationContext());
        switch (current_work_show_flag) {
            case WORK_OF_HOUR: //记工信息以 xx小时单位
                if (isManhour) {
                    return RecordUtils.getNormalWorkString(workingAsHour, isShowFirstTips, current_work_show_flag, isStatistics);
                } else {
                    return RecordUtils.getOverTimeWorkString(workingAsHour, isShowFirstTips, current_work_show_flag, isStatistics);
                }
            case WORK_AS_UNIT: //记工信息以 xx工为单位
                if (isManhour) {
                    return RecordUtils.getNormalWorkUtil(workingAsUnit, isShowFirstTips, isStatistics);
                } else {
                    return RecordUtils.getOverTimeWorkUtil(workingAsUnit, isShowFirstTips, isStatistics);
                }
            case MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //记工信息以 上班时长以xx工为单位，加班时长以xx 小时为单位
                if (isManhour) {
                    return RecordUtils.getNormalWorkUtil(workingAsUnit, isShowFirstTips, isStatistics);
                } else {
                    return RecordUtils.getOverTimeWorkString(workingAsHour, isShowFirstTips, current_work_show_flag, isStatistics);
                }
        }
        return "";
    }

    /**
     * 获取记账文字类型
     *
     * @param accountType
     * @return
     */
    public static String getAccountText(String accountType) {
        if (accountType.equals(AccountUtil.HOUR_WORKER)) {
            return "点工";
        } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
            return "包工记账";
        } else if (accountType.equals(AccountUtil.BORROWING)) {
            return "借支";
        } else if (accountType.equals(AccountUtil.SALARY_BALANCE)) {
            return " 结算";
        } else if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK)) {
            return "包工记工天";
        }
        return "";
    }


    public static String getCurrentAccountType(Context context) {
        final int selectePosition = AccountUtil.getDefaultAccountUnit(context);
        switch (selectePosition) {
            case WORK_OF_HOUR: //以小时为单位
                return "上班，加班按小时";
            case WORK_AS_UNIT: //以工为单位
                return "上班，加班按工天";
            case MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //上班按工天，加班按小时”“按工天
                return "上班按工天，加班按小时";
        }
        return "上班按工天，加班按小时";
    }

    /**
     * 获取备注显示文字
     *
     * @param remark
     * @param imageItems
     * @param context
     * @return
     */
    public static String getAccountRemark(String remark, List<ImageItem> imageItems, Context context) {
        if (!TextUtils.isEmpty(remark) && null != imageItems && imageItems.size() > 0) {
            //文字图片都显示
            return NameUtil.setRemark(remark, 10) + "" + context.getString(R.string.remark_pic);
        } else if (TextUtils.isEmpty(remark) && null != imageItems && imageItems.size() > 0) {
            //只显示图片
            return context.getString(R.string.remark_pic);
        } else if (!TextUtils.isEmpty(remark) && (null == imageItems || imageItems.size() == 0)) {
            //只显示文字
            return NameUtil.setRemark(remark, 10);
        } else {
            return "";
        }
    }
}
