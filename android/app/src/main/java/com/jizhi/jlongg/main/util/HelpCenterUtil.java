package com.jizhi.jlongg.main.util;

import android.app.Activity;

import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * CName:帮助中心工具类
 * User: hcs
 * Date: 2017-11-30
 * Time: 11:37
 */


public class HelpCenterUtil {

    /**
     * 打开帮助中心webView
     *
     * @param context 上下文
     * @param id      用户案例 -2
     *                创建计划 141
     *                质量 180
     *                安全 181
     *                检查 182
     *                任务 183
     *                项目组通知 184
     *                签到 185
     *                日志 188
     *                晴雨表 189
     *                项目组资料库 190
     *                云盘 191
     *                通知 195
     *                班组质量 196
     *                安全 197
     *                班组资料库 198
     *                出勤公式 199
     *                记工帮助 208
     *                日志 226
     *                代班长 228
     *                删除项目说明 239
     *                我要对账 242
     */
    public static void actionStartHelpActivity(Activity context, int id) {
        X5WebViewActivity.actionStart(context, NetWorkRequest.HELPDETAIL + id);
    }
}
