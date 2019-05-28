package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Looper;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.URLSpan;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BillsEntity;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.bean.LoginInfos;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.bean.Recommend;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.fragment.CalendarMainFragment;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.service.WebSocketHeartRateService;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TreeSet;

public class DataUtil {

    /**
     * 跳转到LoginActivtiy
     */
    public static void showErrOrMsg(final Context context, String errno, final String errmsg) {
        if (TextUtils.isEmpty(errmsg)) {
            return;
        }
        if (TextUtils.isEmpty(errno)) {
            CommonMethod.makeNoticeLong(context, errmsg, CommonMethod.ERROR);
            return;
        }
        boolean isMainThraad = Thread.currentThread() == Looper.getMainLooper().getThread();
        if (errno.equals("10051")) { //当前账户的手机号码已被锁定
            if (isMainThraad) {
                DialogOnlyTitle dialogTips = new DialogOnlyTitle(context, null, -1, "手机号码异常");
                dialogTips.setDissmissBtnNameAndColor("我知道了", Color.parseColor("#eb4e4e"));
                dialogTips.hideConfirmBtnName();
                dialogTips.show();
            }
            return;
        } else if (errno.equals("800106")) {
            Utils.checkVersion((Activity) context, new Utils.UpdateAppListener() {
                @Override
                public void isUpdate(boolean update) {
                }
            }, null);
            return;
        } else {
            if (isMainThraad) {
                CommonMethod.makeNoticeLong(context, errmsg, CommonMethod.ERROR);
            }
        }
        //遇到这些表示错误编码表示登陆失效
        if (errno.equals("10006") || errno.equals("10007") || errno.equals("10020") || errno.equals("10032") || errno.equals("10035")) {
            removeUserLoginInfo(context);
            Intent intent = new Intent(context, LoginActivity.class);
            intent.putExtra(Constance.BEAN_BOOLEAN, true);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }


    /**
     * 退出登录 移除用户登录相关信息
     */
    public static void removeUserLoginInfo(Context context) {
        SPUtils.remove(context, Constance.enum_parameter.TOKEN.toString(), Constance.JLONGG); //移除token
        SPUtils.remove(context, Constance.enum_parameter.IS_INFO.toString().toString(), Constance.JLONGG); //移除是否登录
        SPUtils.remove(context, Constance.UID, Constance.JLONGG); //移除角色id
        SPUtils.remove(context, Constance.USERNAME.toString(), Constance.JLONGG);
        SPUtils.remove(context, Constance.NICKNAME.toString(), Constance.JLONGG);
        SPUtils.remove(context, Constance.IS_HAS_REALNAME.toString(), Constance.JLONGG);
        SPUtils.remove(context, Constance.TELEPHONE.toString(), Constance.JLONGG);
        SPUtils.remove(context, Constance.HEAD_IMAGE.toString(), Constance.JLONGG);
        SPUtils.clear(context, Constance.ACCOUNT_WORKER_HISTORT);
        SPUtils.clear(context, Constance.ACCOUNT_FORMAN_HISTORT);
        SPUtils.clear(context, Constance.WOKRBILL);
        SPUtils.remove(context, Constance.OLDTIME, Constance.JLONGG);
        SPUtils.remove(context, "notes_status", Constance.JLONGG);
        CalendarMainFragment.prestrainData = null; //清空预加载数据
        UpdateLoginver(context);
        SocketManager.getInstance(context.getApplicationContext()).clearWebSocket();
        context.stopService(new Intent(context, WebSocketHeartRateService.class)); //停止发送WebSocket心跳


    }

    /**
     * 设置登录用户信息
     *
     * @param context
     * @param bean
     */
    public static void putUserLoginInfo(Context context, LoginStatu bean) {
        String token = "A " + bean.getToken();
        SPUtils.put(context, Constance.enum_parameter.TOKEN.toString(), token, Constance.JLONGG); // 存放Token信息
        SPUtils.put(context, Constance.enum_parameter.ROLETYPE.toString(), bean.getRole() + "", Constance.JLONGG); //设置角色
        SPUtils.put(context, Constance.enum_parameter.IS_INFO.toString(), bean.getIs_info(), Constance.JLONGG); // 是否有当前角色
        SPUtils.put(context, Constance.UID, bean.getUid(), Constance.JLONGG); //用户id
        SPUtils.put(context, Constance.USERNAME, bean.getReal_name(), Constance.JLONGG); //真实名称
        SPUtils.put(context, Constance.NICKNAME, bean.getUser_name(), Constance.JLONGG); //昵称
        SPUtils.put(context, Constance.IS_HAS_REALNAME, bean.getHas_realname(), Constance.JLONGG); //是否有名称  0表示没有 1表示有
        SPUtils.put(context, Constance.TELEPHONE, bean.getTelephone(), Constance.JLONGG);
        SPUtils.put(context, Constance.HEAD_IMAGE, bean.getHead_pic(), Constance.JLONGG);
        //清空草稿信息
//        MessageUtils.clearLocalInfo();
        //发送channelId 绑定个推
        DataUtil.bindChannelId(context, SPUtils.get(context, "channelid", "", Constance.JLONGG).toString());
        //修改登录版本
        UpdateLoginver(context);
    }

    /**
     * 存放Token
     *
     * @param
     */
    public static void putCat_info(Activity activity, String class_type) {
//        SPUtils.put(activity, Constance.CAT_ID, "", Constance.JLONGG);
//        SPUtils.put(activity, Constance.CAT_NAME, "", Constance.JLONGG);

        if (class_type.equals(WebSocketConstance.TEAM)) {
            SPUtils.put(activity, Constance.TEAM_CAT_ID, "", Constance.JLONGG);
            SPUtils.put(activity, Constance.TEAM_CAT_NAME, "", Constance.JLONGG);
        } else {
            SPUtils.put(activity, Constance.GROUP_CAT_ID, "", Constance.JLONGG);
            SPUtils.put(activity, Constance.GROUP_CAT_NAME, "", Constance.JLONGG);
        }
    }


    /**
     * 存放Token
     *
     * @param
     */
    public static void putName(Context activity, String realName) {
        SPUtils.put(activity, Constance.USERNAME, realName, Constance.JLONGG);
        SPUtils.put(activity, Constance.NICKNAME, realName, Constance.JLONGG);
        SPUtils.put(activity, Constance.IS_HAS_REALNAME, 1, Constance.JLONGG);
        UpdateLoginver(activity);
    }

    /**
     * 登出
     *
     * @param
     */
    public static void UpdateLoginver(Context activity) {
        int loginVer = (int) SPUtils.get(activity, Constance.LOGINVER, 0, Constance.JLONGG);
        loginVer += 1;
//        LUtils.e(activity + ",,,UpdateLoginver,,读取,,,,,,,," + loginVer);
        SPUtils.put(activity, Constance.LOGINVER, loginVer, Constance.JLONGG);
    }

    /**
     * 获取登陆信息
     *
     * @param activity
     */
    public static String getLoginInfo(Context activity,String currentTabIndex) {
        String str = "";
        if (UclientApplication.isLogin(activity)) {
            String stoken = (String) SPUtils.get(activity, "TOKEN", "", Constance.JLONGG);
            LoginInfo loginInfo = new LoginInfo();
            loginInfo.setOs("A");
            loginInfo.setToken(stoken.replace("A ", ""));
            loginInfo.setCurrentTabIndex(currentTabIndex);
            if (!TextUtils.isEmpty(stoken)) {
                int loginVer = (int) SPUtils.get(activity, Constance.LOGINVER, 0, Constance.JLONGG);
                loginInfo.setInfover((loginVer + 1) + "");
            }
            str = new Gson().toJson(loginInfo);
        } else {
            str = new Gson().toJson(new LoginInfos());
        }
        LUtils.e(str + ",,," + activity);
        return str;
    }

    public static String getinfover(Context activity) {
        int loginVer = (int) SPUtils.get(activity, Constance.LOGINVER, 0, Constance.JLONGG);
        return loginVer + "";
    }

    public static String getBillSignData(Map<String, String> params) {
//  params 为要参与签名的参数键值对 .
        StringBuffer content = new StringBuffer();
        //   按照 key 做排序
        List<String> keys = new ArrayList<String>(params.keySet());
        Collections.sort(keys);
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = params.get(key);
            if ("sign".equals(key) || "sign_type".equals(key) || "serialVersionUID".equals(key) || TextUtils.isEmpty(value)) {
                continue;
            }
            if (value.equals("0.0") || value.equals("0.00")) {
                value = "0";
            }
            content.append(TextUtils.isEmpty(content.toString()) ? key + "=" + value : "&" + key + "=" + value);
        }
        LUtils.e("----------getBillSignData------" + content.toString());
        content.append("OaxhSsnvFnRCUql53jVDUVVp26pQkYea");
        return content.toString();
    }

    public static Map<String, String> sigBillnMap(BillsEntity entity) {
        Map<String, String> par = new HashMap<>();
        Class c = entity.getClass();
        Field[] publicFields = c.getFields();
        int length = publicFields.length;
        for (int i = 0; i < length; i++) {
            Field f = publicFields[i];
            try {
                Object val = f.get(entity);// 得到此属性的值
                String type = f.getType().toString();// 得到此属性的类型
                if (null != val && !TextUtils.isEmpty(val.toString())
                        && !type.equals("boolean")
                        && !type.equals("interface java.util.List")) {
                    //!type.equals("class com.comrporate.common.GroupDiscussionInfo")
                    par.put(f.getName(), val.toString());
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        Field[] privateFirleds = c.getDeclaredFields();
        length = privateFirleds.length;
        for (int i = 0; i < length; i++) {
            Field f = privateFirleds[i];
            f.setAccessible(true); // 设置些属性是可以访问的
            try {
                Object val = f.get(entity);// 得到此属性的值
                String type = f.getType().toString();// 得到此属性的类型
                if (null != val && !TextUtils.isEmpty(val.toString()) && !type.equals("boolean") && !type.equals("interface java.util.List")) {
                    par.put(f.getName(), val.toString());
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return par;
    }

    /**
     * 上班时间
     *
     * @param sum      最小时间
     * @param modeTime 选中时间
     * @return
     */
    public static List<WorkTime> getWorkTime(int sum, double modeTime) {
        List<WorkTime> normalWorkingDurationList = new ArrayList<>();
        WorkTime cityInfoMode = null;
        for (int i = sum; i <= 24; i++) {
            cityInfoMode = new WorkTime();
            if (i == 0) {
                cityInfoMode.setWorkName("休息");
                cityInfoMode.setWorkTimes(0);
            } else {
                cityInfoMode.setWorkName(i + "小时");
                cityInfoMode.setWorkTimes(i);
            }
            if (modeTime == cityInfoMode.getWorkTimes()) {
                cityInfoMode.setUnit("(1个工)");
            } else if ((modeTime / 2) == cityInfoMode.getWorkTimes()) {
                cityInfoMode.setUnit("(半个工)");
            } else {
                cityInfoMode.setUnit("");
            }
            normalWorkingDurationList.add(cityInfoMode);
            if (i != 24) {
                cityInfoMode = new WorkTime();
                cityInfoMode.setWorkName((i + 0.5) + "小时");
                cityInfoMode.setWorkTimes((i + 0.5));
                LUtils.e((modeTime / 2) + ",,,,,,,,,,,,,,,,," + cityInfoMode.getWorkTimes());
                if (modeTime == cityInfoMode.getWorkTimes()) {
                    cityInfoMode.setUnit("(1个工)");
                } else if ((modeTime / 2) == cityInfoMode.getWorkTimes()) {
                    cityInfoMode.setUnit("(半个工)");
                } else {
                    cityInfoMode.setUnit("");
                }

                normalWorkingDurationList.add(cityInfoMode);
            }
        }
        return normalWorkingDurationList;
    }

    /**
     * 加班时间
     *
     * @param sum      最小时间
     * @param modeTime 选中时间
     * @return
     */
    public static List<WorkTime> getOverTime(int sum, double modeTime) {
        List<WorkTime> normalWorkingDurationList = new ArrayList<>();
        WorkTime cityInfoMode = null;
        for (int i = sum; i <= 24; i++) {
            cityInfoMode = new WorkTime();
            if (i == 0) {
                cityInfoMode.setWorkName("无加班");
                cityInfoMode.setWorkTimes(0);
            } else {
                cityInfoMode.setWorkName(i + "小时");
                cityInfoMode.setWorkTimes(i);
            }
            if (modeTime == cityInfoMode.getWorkTimes()) {
                cityInfoMode.setUnit("(1个工)");
            } else if ((modeTime / 2) == cityInfoMode.getWorkTimes()) {
                cityInfoMode.setUnit("(半个工)");
            } else {
                cityInfoMode.setUnit("");
            }
            normalWorkingDurationList.add(cityInfoMode);
            if (i != 24) {
                cityInfoMode = new WorkTime();
                cityInfoMode.setWorkName((i + 0.5) + "小时");
                cityInfoMode.setWorkTimes((i + 0.5));
                if (modeTime == cityInfoMode.getWorkTimes()) {
                    cityInfoMode.setUnit("(1个工)");
                } else if ((modeTime / 2) == cityInfoMode.getWorkTimes()) {
                    cityInfoMode.setUnit("(半个工)");
                } else {
                    cityInfoMode.setUnit("");
                }
                normalWorkingDurationList.add(cityInfoMode);
            }
        }
        return normalWorkingDurationList;
    }

    /**
     * 得到薪资模板上班时长
     */
    public static List<WorkTime> getSalaryWorkingDuration(int sum) {
        List<WorkTime> normalWorkingDurationList = new ArrayList<>();
        WorkTime cityInfoMode = null;
        for (int i = sum; i <= 24; i++) {
            cityInfoMode = new WorkTime();
            cityInfoMode.setWorkName(i + "小时");
            cityInfoMode.setWorkTimes(i);
            cityInfoMode.setUnit("");
            normalWorkingDurationList.add(cityInfoMode);
            if (i != 24) {
                cityInfoMode = new WorkTime();
                cityInfoMode.setWorkName((i + 0.5) + "小时");
                cityInfoMode.setWorkTimes((i + 0.5));
                cityInfoMode.setUnit("");
                normalWorkingDurationList.add(cityInfoMode);
            }
        }
        return normalWorkingDurationList;
    }

    /**
     * 得到薪资模板加班班时长
     */
    public static List<WorkTime> getSalaryOverTimegDuration(int sum) {
        List<WorkTime> normalWorkingDurationList = new ArrayList<>();
        WorkTime cityInfoMode = null;
        for (int i = sum; i <= 24; i++) {
            cityInfoMode = new WorkTime();
            cityInfoMode.setWorkName(i + "小时");
            cityInfoMode.setWorkTimes(i);
            cityInfoMode.setUnit("");
            normalWorkingDurationList.add(cityInfoMode);
            if (i != 24) {
                cityInfoMode = new WorkTime();
                cityInfoMode.setWorkName((i + 0.5) + "小时");
                cityInfoMode.setWorkTimes((i + 0.5));
                cityInfoMode.setUnit("");
                normalWorkingDurationList.add(cityInfoMode);
            }
        }
        return normalWorkingDurationList;
    }

    /**
     * 获取加班时常 数据
     *
     * @param maxOvertime 加班时常最大数
     * @return
     */
    public static List<WorkTime> getOverTimeListNewVersion(int maxOvertime) {
        List<WorkTime> timelist = new ArrayList<>();
        WorkTime wujiaban = new WorkTime("无加班");
        wujiaban.setRest(true);
        timelist.add(wujiaban);
        maxOvertime = maxOvertime << 1; //因为有半个工所有乘以*2
        for (int i = 0; i < maxOvertime; i++) {
            WorkTime wt = new WorkTime((float) ((i / 2.0) + 0.5));
            if ((i + 1) == (maxOvertime >> 1)) { //0.5个工
                wt.setHalfWork(true);
            } else if (i == maxOvertime - 1) { //1个工
                wt.setOneWork(true);
            }
            timelist.add(wt);
        }
        return timelist;
    }

    /**
     * 获取正常上班时常
     *
     * @param maxWorktime 上班时常的最大数
     * @return
     */
    public static List<WorkTime> getNormalTimeListNewVersion(int maxWorktime) {
        List<WorkTime> timelist = new ArrayList<>();
        WorkTime normalWork = new WorkTime("休息");
        normalWork.setRest(true);
        timelist.add(normalWork);
        maxWorktime = maxWorktime << 1; //因为有半个工所有乘以*2
        for (int i = 0; i < maxWorktime; i++) {
            WorkTime wt = new WorkTime((float) ((i / 2.0) + 0.5));
            if ((i + 1) == (maxWorktime >> 1)) { //0.5个工
                wt.setHalfWork(true);
            } else if (i + 1 == maxWorktime) { //1个工
                wt.setOneWork(true);
            }
            timelist.add(wt);
        }
        return timelist;
    }


    /**
     * 获取正常上班时常
     *
     * @param maxWorktime
     * @param selected
     * @return
     */
    public static List<WorkTime> getNormalTimeList(int maxWorktime, double selected) {
        int id = 0;
        List<WorkTime> timelist = new ArrayList<>();
        WorkTime wt = new WorkTime();
        //添加1个工
        wt.setWorkTimes(0.5f);
        wt.setWorkName("小时");
        id = id + 1;
        wt.setWorkId(id);
        timelist.add(wt);

        for (int i = 1; i <= maxWorktime; i++) {
            //添加1个工
            wt = new WorkTime();
            wt.setWorkTimes(i);
            wt.setWorkName("小时");
            id = id + 1;
            wt.setWorkId(id);
            if (selected == i) {
                wt.setOneWork(true);
            }
            timelist.add(wt);
            if (i != maxWorktime) {
                //添加0.5个工
                wt = new WorkTime();
                wt.setWorkTimes(i + 0.5f);
                wt.setWorkName("小时");
                id = id + 1;
                wt.setWorkId(id);
                timelist.add(wt);
            }
        }
        wt = new WorkTime();
        wt.setWorkName("休息");
        wt.setWorkId(0);
        wt.setWorkTimes(0);
        if (selected == 0) {
            wt.setOneWork(true);
        }
        timelist.add(wt);
        return timelist;
    }

    /**
     * 获取加班时常
     *
     * @param maxWorktime
     * @param selected
     * @return
     */
    public static List<WorkTime> getOverTimeList(int maxWorktime, int selected) {
        int id = 0;
        List<WorkTime> timelist = new ArrayList<>();
        WorkTime wt = new WorkTime();
        //添加1个工
        wt.setWorkTimes(0.5f);
        wt.setWorkName("小时");
//        if (selected == 0) {
//            wt.setOneWork(true);
//        }
        id = id + 1;
        wt.setWorkId(id);
        timelist.add(wt);

        for (int i = 1; i <= maxWorktime; i++) {
            //添加1个工
            wt = new WorkTime();
            wt.setWorkTimes(i);
            wt.setWorkName("小时");
            id = id + 1;
            wt.setWorkId(id);
            if (selected == i) {
                wt.setOneWork(true);
            }
            timelist.add(wt);

            if (i != maxWorktime) {
                //添加0.5个工
                wt = new WorkTime();
                wt.setWorkTimes(i + 0.5f);
                wt.setWorkName("小时");
                id = id + 1;
                wt.setWorkId(id);
                timelist.add(wt);
            }
        }
        wt = new WorkTime();
        wt.setWorkName("无加班");
        wt.setWorkId(0);
        wt.setWorkTimes(0);
        timelist.add(wt);
        return timelist;
    }

    /**
     * 获取正常上班时常
     *
     * @return
     */
    public static List<WorkTime> getAccountCompanyList(Context context, String company) {
        String[] accountCompanyList = context.getResources().getStringArray(R.array.accountCompanyList);
        int id = -1;
        List<WorkTime> timelist = new ArrayList<>();
        for (int i = 0; i < accountCompanyList.length; i++) {
            id = id + 1;
            WorkTime wt = new WorkTime();
            wt.setWorkName(accountCompanyList[i]);
            wt.setWorkId(id);
            if (company.equals(accountCompanyList[i])) {
                wt.setOneWork(true);
            }
            timelist.add(wt);
        }
        return timelist;
    }

    /**
     * 推荐列表数据
     *
     * @return
     */
    public static List<Recommend> getRecommend(Context c) {
        List<Recommend> listRecommend = new ArrayList<>();
        Resources re = c.getResources();
        Recommend recommend = null;
        for (int i = 0; i < 7; i++) {
            switch (i) {
                case 0:
//                    String token = (String) SPUtils.get(c, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG);
//                    token = token.replace("A", "").trim();
//                    Map<String, String> par = new HashMap<>();
//                    par.put("userToken", token);
//                    par.put("para1758", "");
//                    String sign = DataUtil.getSignData(par);
//                    sign = MD5.getMD5(sign).toUpperCase();
//                    String url = NetworkRequest.GAMEURL + token + "&sign=" + sign;
                    recommend = new Recommend(re.getString(R.string.play_game), re.getString(R.string.play_game_info), R.drawable.icon_game, "http://www.doudou.in/");
                    break;
                case 1:
//                    recommend = new Recommend(re.getString(R.string.look_new), re.getString(R.string.look_new_info), R.drawable.icon_news, NetWorkRequest.NEWS);
                    break;
                case 2:
                    recommend = new Recommend(re.getString(R.string.send_msg), re.getString(R.string.send_msg_info), R.drawable.icon_msg, NetWorkRequest.FRIENDWORK + UclientApplication.getCityCode(c));
                    break;
                case 3:
                    recommend = new Recommend(re.getString(R.string.look_video), re.getString(R.string.look_video_info), R.drawable.icon_video, NetWorkRequest.VIDEO);
                    break;
                case 4:
                    recommend = new Recommend(re.getString(R.string.look_book), re.getString(R.string.look_book_info), R.drawable.icon_book, NetWorkRequest.BOOK);
                    break;
                case 5:
//                    recommend = new Recommend(re.getString(R.string.look_girl), re.getString(R.string.look_girl_info), R.drawable.icon_girl, NetWorkRequest.GIRL);
                    break;
                case 6:
                    recommend = new Recommend(re.getString(R.string.look_duanzi), re.getString(R.string.look_duanzi_info), R.drawable.icon_duanzi, NetWorkRequest.DUANZI);
                    break;
            }
            listRecommend.add(recommend);
        }
        List<Recommend> showList = new ArrayList<Recommend>();
//        showList.add(listRecommend.get(1));
//        showList.add(listRecommend.get(2));
//        showList.add(listRecommend.get(3));
        Set<Integer> hs = null;
        String date = SPUtils.get(c, "recommed", "", Constance.JLONGG).toString(); //今日推荐时间
        Calendar calendar = Calendar.getInstance();
        StringBuilder sb = new StringBuilder();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        sb.append(year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day));
        if (TextUtils.isEmpty(date) || !date.equals(sb.toString())) { //如果推荐时间不为空 或者  推荐时间和当前时间不相等
            hs = randomSet();
            SPUtils.put(c, "recommed", sb.toString(), Constance.JLONGG);
        } else {
            String values = SPUtils.get(c, "recommed_value", "", Constance.JLONGG).toString(); //今日推荐值
            String[] value = values.split(",");
            hs = new TreeSet<Integer>();
            for (String v : value) {
                hs.add(Integer.parseInt(v));
            }
        }
        StringBuilder setIndex = new StringBuilder(); //保存Set集合保存下标
        int i = 0;
        for (Integer key : hs) {
            if (i == 2) {
                setIndex.append(key);
            } else {
                setIndex.append(key + ",");
            }
            showList.add(listRecommend.get(key));
            i += 1;
        }
        SPUtils.put(c, "recommed_value", setIndex.toString(), Constance.JLONGG);
        return showList;

    }

    /**
     * 随机指定范围内N个不重复的数
     * 利用HashSet的特征，只能存放不同的值
     */
    public static Set<Integer> randomSet() {
        Random r = new Random();
        Set<Integer> hs = new HashSet<Integer>();
        while (hs.size() < 3) {
            hs.add(r.nextInt(7));
        }
        return hs;
    }

    public static String getSignData(Map<String, String> params) {
//  params 为要参与签名的参数键值对 .
        StringBuffer content = new StringBuffer();
        //   按照 key 做排序
        List<String> keys = new ArrayList<String>(params.keySet());
        Collections.sort(keys);
        for (int i = 0; i < keys.size(); i++) {
            String key = (String) keys.get(i);
            if ("sign".equals(key) || "sign_type".equals(key)) {
                continue;
            }
            String value = (String) params.get(key);
            if (value != null) {
//                Log.e("------------11", "");
                content.append((i == 0 ? "" : "&") + key + "=" + value);
            } else {
                content.append((i == 0 ? "" : "&") + key + "=");
//                Log.e("------------22", "");
            }
        }
        content.append("467c583750036bb38ac21bb36eea07de");
        return content.toString();
    }

    public static String getJgjSignData(Map<String, String> params) {
//  params 为要参与签名的参数键值对 .
        StringBuffer content = new StringBuffer();
        //   按照 key 做排序
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = params.get(key);
            if ("sign".equals(key) || "sign_type".equals(key) || "serialVersionUID".equals(key) || TextUtils.isEmpty(value)) {
                continue;
            }
            if (value.equals("0.0") || value.equals("0.00")) {
                value = "0";
            }
            content.append(TextUtils.isEmpty(content.toString()) ? key + "=" + value : "&" + key + "=" + value);
        }
//        LUtils.e("未加密前:" + content.toString());
        content.append("OaxhSsnvFnRCUql53jVDUVVp26pQkYea");
        return content.toString();
    }

    /**
     * 发送channelId 绑定个推
     *
     * @param context
     * @param channel_id
     */
    public static void bindChannelId(Context context, String channel_id) {
        if (TextUtils.isEmpty(channel_id)) {
            return;
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("channel_id", channel_id);// 项目id
        params.addBodyParameter("os", "A");// 项目id
        params.addBodyParameter("service_type", "umeng");// 服务类型
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.POST_CHANNCELID,
                params, new RequestCallBack<String>() {

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                    }

                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                    }
                });
    }

    /**
     * 发质量隐患级别
     *
     * @param isZero
     * @return
     */
    public static List<ProjectLevel> getProjectType(boolean isZero) {
        List<ProjectLevel> list = new ArrayList<>();
        if (isZero) {
            ProjectLevel level0 = new ProjectLevel("不限", 0);
            list.add(level0);
        }
        ProjectLevel level1 = new ProjectLevel("质量", 1);
        ProjectLevel level2 = new ProjectLevel("安全", 2);
        ProjectLevel level3 = new ProjectLevel("任务", 3);
        level1.setChecked(true);
        level2.setChecked(false);
        list.add(level1);
        list.add(level2);
        list.add(level3);
        return list;

    }

    /**
     * 发质量隐患级别
     *
     * @param isZero
     * @return
     */
    public static List<ProjectLevel> getProjectLevel(boolean isZero) {
        List<ProjectLevel> list = new ArrayList<>();
        if (isZero) {
            ProjectLevel level0 = new ProjectLevel("不限", 0);
            list.add(level0);
        }
        ProjectLevel level1 = new ProjectLevel("一般", 1);
        ProjectLevel level2 = new ProjectLevel("较大", 2);
        ProjectLevel level3 = new ProjectLevel("重大", 3);
        ProjectLevel level4 = new ProjectLevel("特大", 4);
        level1.setChecked(true);
        level2.setChecked(false);
        list.add(level1);
        list.add(level2);
        list.add(level3);
        list.add(level4);
        return list;

    }

    /**
     * 发质量问题状态
     *
     * @return
     */
    public static List<ProjectLevel> getFilterState() {
        List<ProjectLevel> list = new ArrayList<>();
        ProjectLevel level0 = new ProjectLevel("不限", 0);
        ProjectLevel level1 = new ProjectLevel("待整改", 1);
        ProjectLevel level2 = new ProjectLevel("待复查", 2);
        ProjectLevel level3 = new ProjectLevel("已完结", 3);
        level2.setChecked(true);
        list.add(level0);
        list.add(level1);
        list.add(level2);
        list.add(level3);
        return list;

    }

    /**
     * 及时整改
     *
     * @return
     */
    public static List<ProjectLevel> getFilterChange() {
        List<ProjectLevel> list = new ArrayList<>();
        ProjectLevel level0 = new ProjectLevel("不限", 0);
        ProjectLevel level1 = new ProjectLevel("[红灯] 逾期未完成整改", 1);
        ProjectLevel level2 = new ProjectLevel("[黄灯] 临近整改期限", 2);
        ProjectLevel level3 = new ProjectLevel("[绿灯] 整改时间充足", 3);
        ProjectLevel level4 = new ProjectLevel("[黄灯] 逾期完成整改", 4);
        ProjectLevel level5 = new ProjectLevel("[绿灯] 按时完成整改", 5);
        list.add(level0);
        list.add(level1);
        list.add(level2);
        list.add(level3);
        list.add(level4);
        list.add(level5);
        return list;
    }

    /**
     * 发质量问题状态
     *
     * @return
     */
    public static List<ProjectLevel> getFilteCheck() {
        List<ProjectLevel> list = new ArrayList<>();
        ProjectLevel level0 = new ProjectLevel("不限", 0);
        ProjectLevel level1 = new ProjectLevel("待检查", 1);
        ProjectLevel level3 = new ProjectLevel("已完结", 3);
        level1.setChecked(true);
        list.add(level0);
        list.add(level1);
        list.add(level3);
        return list;

    }

    /**
     * 及时整改
     *
     * @return
     */
    public static void getFilterParams(RequestParams params, QuqlityAndSafeBean bean) {
        if (null != bean) {
            params.addBodyParameter("is_special", "1");
        }
        //问题状态
        if (0 != bean.getFilter_state()) {
            params.addBodyParameter("status", bean.getFilter_state() + "");
        }
        //隐患级别
        if (0 != bean.getFilter_level()) {
            params.addBodyParameter("severity", bean.getFilter_level() + "");
        }
        //提交日期开始
        if (!TextUtils.isEmpty(bean.getFilter_date_start())) {
            params.addBodyParameter("send_stime", bean.getFilter_date_start().replace("-", ""));
        }
        //提交日期结束
        if (!TextUtils.isEmpty(bean.getFilter_date_end())) {
            params.addBodyParameter("send_etime", bean.getFilter_date_end().replace("-", ""));
        }
        //整改日期开始
        if (!TextUtils.isEmpty(bean.getFilter_time_start())) {
            params.addBodyParameter("modify_stime", bean.getFilter_time_start().replace("-", ""));
        }
        //整改日期结束
        if (!TextUtils.isEmpty(bean.getFilter_time_end())) {
            params.addBodyParameter("modify_etime", bean.getFilter_time_end().replace("-", ""));
        }
        //是否及时整改
        if (0 != bean.getFilter_change()) {
//            params.addBodyParameter("in_time", bean.getFilter_change() + "");
            params.addBodyParameter("question_status", bean.getFilter_change() + "");
        }
        //整改负责人
        if (!TextUtils.isEmpty(bean.getFilter_people_uid())) {
            params.addBodyParameter("principal_uid", bean.getFilter_people_uid() + "");
        }
        //问题提交人
        if (!TextUtils.isEmpty(bean.getFilter_submit_people_uid())) {
            params.addBodyParameter("send_uid", bean.getFilter_submit_people_uid() + "");
        }
//        return params;
    }

    /**
     * 质量检查筛选
     *
     * @return
     */
    public static void getFilterCheckParams(RequestParams params, QuqlityAndSafeBean bean) {
        if (null != bean) {
            params.addBodyParameter("is_special", "1");
        }
        //问题状态
        if (0 != bean.getFilter_state()) {
            params.addBodyParameter("status", bean.getFilter_state() + "");
        }
        //日期开始
        if (!TextUtils.isEmpty(bean.getFilter_date_start())) {
            params.addBodyParameter("send_stime", bean.getFilter_date_start().replace("-", ""));
        }
        //日期结束
        if (!TextUtils.isEmpty(bean.getFilter_date_end())) {
            params.addBodyParameter("send_etime", bean.getFilter_date_end().replace("-", ""));
        }
        //执行者uid，默认当前用户
        if (!TextUtils.isEmpty(bean.getFilter_people_uid())) {
            params.addBodyParameter("principal_uid", bean.getFilter_people_uid() + "");
        }
        //发布者uid，默认是当前用户
        if (!TextUtils.isEmpty(bean.getFilter_submit_people_uid())) {
            params.addBodyParameter("uid", bean.getFilter_submit_people_uid() + "");
        }
//        return params;
    }

    /**
     * 日志筛选
     *
     * @return
     */
    public static void getFilterLogParams(RequestParams params, LogGroupBean bean) {
//        if (null != bean) {
//            params.addBodyParameter("is_special", "1");
//        }
        //日期开始
        if (!TextUtils.isEmpty(bean.getSend_stime())) {
            params.addBodyParameter("send_stime", bean.getSend_stime().replace("-", ""));
        }
        //日期结束
        if (!TextUtils.isEmpty(bean.getSend_etime())) {
            params.addBodyParameter("send_etime", bean.getSend_etime().replace("-", ""));
        }
        //日志模版id
        if (!TextUtils.isEmpty(bean.getCat_id())) {
            params.addBodyParameter("cat_id", bean.getCat_id());
        }
        //发布者uid，默认是当前用户
        if (!TextUtils.isEmpty(bean.getUid())) {
            params.addBodyParameter("uid", bean.getUid());
        }
//        params.addBodyParameter("uid", bean.getUid());
//        return params;
    }

    /**
     * 设置textview超链接点击时间
     *
     * @param textView
     * @param context
     */
    public static void setHtmlClick(TextView textView, Context context) {
        CharSequence text = textView.getText();
        if (text instanceof Spannable) {
            int end = text.length();
            Spannable sp = (Spannable) text;
            URLSpan urls[] = sp.getSpans(0, end, URLSpan.class);
            SpannableStringBuilder style = new SpannableStringBuilder(text);
            style.clearSpans();
            for (URLSpan urlSpan : urls) {
                MyURLSpan myURLSpan = new MyURLSpan(context, urlSpan.getURL());
                style.setSpan(myURLSpan, sp.getSpanStart(urlSpan),
                        sp.getSpanEnd(urlSpan),
                        Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            }
            textView.setText(style);
        }
    }
}
