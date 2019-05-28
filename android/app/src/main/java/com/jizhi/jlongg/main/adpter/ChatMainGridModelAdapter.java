package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Build;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.AccountUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AccountModifyActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.GroupManagerActivity;
import com.jizhi.jlongg.main.activity.MemberManagerActivity;
import com.jizhi.jlongg.main.activity.MultiPersonBatchAccountNewActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.RepositoryGridViewActivity;
import com.jizhi.jlongg.main.activity.TeamManagerActivity;
import com.jizhi.jlongg.main.activity.TurnOutForWorkActivity;
import com.jizhi.jlongg.main.activity.WeatherTablelActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.checkplan.CheckPlanHomePageActivity;
import com.jizhi.jlongg.main.activity.log.MsgLogActivity;
import com.jizhi.jlongg.main.activity.procloud.ProCloudActivity;
import com.jizhi.jlongg.main.activity.qualityandsafe.QualityAndSafePageActivity;
import com.jizhi.jlongg.main.activity.task.TaskHomePageActivity;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.WorkCircleMessageMenu;
import com.jizhi.jlongg.main.dialog.DiaLogBottomRed;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.message.NoticeListActivity;
import com.jizhi.jlongg.main.message.SignListActivity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;

import org.litepal.LitePal;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;


/**
 * 首页班组，项目组 模块适配器
 *
 * @author Xuj
 * @time 2018年8月20日16:17:57
 * @Version 1.0
 */
public class ChatMainGridModelAdapter extends BaseAdapter {

    /**
     * 列表数据
     */
    private ArrayList<WorkCircleMessageMenu> list;
    /**
     * 项目组信息
     */
    private ChatMainInfo chatBaseInfo;
    /**
     * activity
     */
    private BaseActivity activity;


    public ChatMainGridModelAdapter(BaseActivity activity, ChatMainInfo chatBaseInfo, boolean isMyselfGroup) {
        super();
        this.activity = activity;
        this.chatBaseInfo = chatBaseInfo;
        initDataInfo(chatBaseInfo, isMyselfGroup);
    }


    private void initDataInfo(ChatMainInfo chatBaseInfo, boolean isMyselfGroup) {
        String classType = chatBaseInfo.getGroup_info().getClass_type();
        list = classType.equals(WebSocketConstance.TEAM) ? getTeamItemData() : getGroupItemData(isMyselfGroup, chatBaseInfo.getGroup_info().getAgency_group_user());
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = activity.getLayoutInflater().inflate(R.layout.new_work_circle_gridview, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(ViewHolder holder, int position, View convertView) {
        //GridView选项信息
        final WorkCircleMessageMenu bean = list.get(position);
        //项目组信息
        final ChatMainInfo chatBaseInfo = this.chatBaseInfo;
        holder.menuText.setText(bean.getMenuName());
        holder.menuIcon.setImageResource(bean.getImageResource());
        switch (bean.getMenuType()) {
            case WorkCircleMessageMenu.WEATHER_TABLE: //晴雨表
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_weath_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.EXAMINATION: //审批
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_approval_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.TASK: //任务
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_task_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.NOTICE: //通知
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_notice_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.QUALITY: //质量
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_quality_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.SAFETY: //安全
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_safe_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.SIGN: //签到
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_sign_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.WORK_BOOKS: //记工账本
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_billRecord_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.LOG: //工作日志
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_log_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.CHECK: //检查计划
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_inspect_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            case WorkCircleMessageMenu.MEETING: //会议
                holder.redCircle.setVisibility(chatBaseInfo.getUnread_meeting_count() == 0 ? View.GONE : View.VISIBLE);
                break;
            default:
                holder.redCircle.setVisibility(View.GONE);
                break;
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (bean.getMenuType() == WorkCircleMessageMenu.REPOSITY) { //只有知识库不需要验证是否已有用户名称
                    itemClickListener(bean, chatBaseInfo.getGroup_info());
                } else {
                    IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
                        @Override
                        public void onSuccess() {
                            itemClickListener(bean, chatBaseInfo.getGroup_info());
                        }
                    });
                }
            }
        });
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            menuText = (TextView) convertView.findViewById(R.id.menuText);
            menuIcon = (ImageView) convertView.findViewById(R.id.menuIcon);
            redCircle = convertView.findViewById(R.id.redCircle);
        }

        /**
         * 菜单文本
         */
        TextView menuText;
        /**
         * 菜单图片
         */
        ImageView menuIcon;
        /**
         * 小红点
         */
        View redCircle;
    }

    public List<WorkCircleMessageMenu> getList() {
        return list;
    }

    public void setList(ArrayList<WorkCircleMessageMenu> list) {
        this.list = list;
    }

    /**
     * 获取项目组GridView 数据
     *
     * @return
     */
    private ArrayList<WorkCircleMessageMenu> getTeamItemData() {
        ArrayList<WorkCircleMessageMenu> list = new ArrayList<>();

        WorkCircleMessageMenu bean1 = new WorkCircleMessageMenu("质量", R.drawable.icon_quality_of, WorkCircleMessageMenu.QUALITY);
        WorkCircleMessageMenu bean2 = new WorkCircleMessageMenu("安全", R.drawable.icon_security, WorkCircleMessageMenu.SAFETY);
        WorkCircleMessageMenu bean3 = new WorkCircleMessageMenu("检查", R.drawable.icon_check_list, WorkCircleMessageMenu.CHECK);
        WorkCircleMessageMenu bean4 = new WorkCircleMessageMenu("任务", R.drawable.icon_task, WorkCircleMessageMenu.TASK);
        WorkCircleMessageMenu bean5 = new WorkCircleMessageMenu("通知", R.drawable.work_icon_notice, WorkCircleMessageMenu.NOTICE);
        WorkCircleMessageMenu bean6 = new WorkCircleMessageMenu("考勤签到", R.drawable.icon_sign_in, WorkCircleMessageMenu.SIGN);
        WorkCircleMessageMenu bean7 = new WorkCircleMessageMenu("会议", R.drawable.icon_meeting, WorkCircleMessageMenu.MEETING);
        WorkCircleMessageMenu bean8 = new WorkCircleMessageMenu("审批", R.drawable.icon_examination, WorkCircleMessageMenu.EXAMINATION);
        WorkCircleMessageMenu bean9 = new WorkCircleMessageMenu("工作日志", R.drawable.work_icon_log, WorkCircleMessageMenu.LOG);
        WorkCircleMessageMenu bean10 = new WorkCircleMessageMenu("晴雨表", R.drawable.icon_weather, WorkCircleMessageMenu.WEATHER_TABLE);
        WorkCircleMessageMenu bean11 = new WorkCircleMessageMenu("资料库", R.drawable.icon_knowledge_base, WorkCircleMessageMenu.REPOSITY);
        WorkCircleMessageMenu bean12 = new WorkCircleMessageMenu("云盘", R.drawable.icon_pro_cloud, WorkCircleMessageMenu.PRO_CLOUD);
        WorkCircleMessageMenu bean13 = new WorkCircleMessageMenu("微官网", R.drawable.icon_app_website, WorkCircleMessageMenu.APP_WEBSITE);
        WorkCircleMessageMenu bean14 = new WorkCircleMessageMenu("设备管理", R.drawable.icon_device, WorkCircleMessageMenu.DEVICE);
        WorkCircleMessageMenu bean15 = new WorkCircleMessageMenu("记工报表", R.drawable.icon_report, WorkCircleMessageMenu.RECODER_TABLE);
        WorkCircleMessageMenu bean16 = new WorkCircleMessageMenu("成员管理", R.drawable.icon_member_manager, WorkCircleMessageMenu.MEMBER_MANAGER);
        WorkCircleMessageMenu bean17 = new WorkCircleMessageMenu("项目设置", R.drawable.icon_team_management, WorkCircleMessageMenu.TEAM_MANAGER);

        list.add(bean1);
        list.add(bean2);
        list.add(bean3);
        list.add(bean4);
        list.add(bean5);
        list.add(bean6);
        list.add(bean7);
        list.add(bean8);
        list.add(bean9);
        list.add(bean10);
        list.add(bean11);
        list.add(bean12);
        list.add(bean13);
        list.add(bean14);
        list.add(bean15);
        list.add(bean16);
        list.add(bean17);
        return list;
    }

    /**
     * 获取班组GridView
     *
     * @param isMySelfGroup 是否是我创建的班组
     * @return
     */
    private ArrayList<WorkCircleMessageMenu> getGroupItemData(boolean isMySelfGroup, AgencyGroupUser agencyGroupUser) {
        ArrayList<WorkCircleMessageMenu> list = new ArrayList<>();
        WorkCircleMessageMenu bean1 = new WorkCircleMessageMenu("记工", R.drawable.icon_account, isMySelfGroup ? WorkCircleMessageMenu.MULTI_RECORD_ACCOUNT : WorkCircleMessageMenu.SINGLE_RECORD_ACCOUNT);
        WorkCircleMessageMenu bean2 = new WorkCircleMessageMenu("借支/结算", R.drawable.icon_borrow_main, WorkCircleMessageMenu.ACCOUNT_BORROW);
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) { //班组里面已设置了代班长
            if (agencyGroupUser.getUid().equals(UclientApplication.getUid(activity))) { //当前登录人是代班长
                list.add(new WorkCircleMessageMenu("代班记工", R.drawable.icon_proxy_record, WorkCircleMessageMenu.PROXY_RECORD));
                list.add(new WorkCircleMessageMenu("代班流水", R.drawable.icon_proxy_flow, WorkCircleMessageMenu.PROXY_FLOW));
                list.add(new WorkCircleMessageMenu("代班对账", R.drawable.icon_proxy_check_account, WorkCircleMessageMenu.PROXY_CHECK_ACCOUNT));
                list.add(new WorkCircleMessageMenu("记工变更", R.drawable.icon_record_account_change, WorkCircleMessageMenu.RECORD_ACCOUNT_UPDATE));
                list.add(bean1);
                list.add(bean2);
            } else if (isMySelfGroup) {
                list.add(bean1);
                list.add(bean2);
                list.add(new WorkCircleMessageMenu("记工变更", R.drawable.icon_record_account_change, WorkCircleMessageMenu.RECORD_ACCOUNT_UPDATE));
            } else {
                list.add(bean1);
                list.add(bean2);
            }
        } else {
            list.add(bean1);
            list.add(bean2);
        }

        WorkCircleMessageMenu bean3 = new WorkCircleMessageMenu("出勤公示", R.drawable.icon_books, WorkCircleMessageMenu.WORK_BOOKS);
        WorkCircleMessageMenu bean4 = new WorkCircleMessageMenu("考勤签到", R.drawable.icon_sign_in, WorkCircleMessageMenu.SIGN);
        WorkCircleMessageMenu bean5 = new WorkCircleMessageMenu("通知", R.drawable.work_icon_notice, WorkCircleMessageMenu.NOTICE);
        WorkCircleMessageMenu bean6 = new WorkCircleMessageMenu("质量", R.drawable.icon_quality_of, WorkCircleMessageMenu.QUALITY);
        WorkCircleMessageMenu bean7 = new WorkCircleMessageMenu("安全", R.drawable.icon_security, WorkCircleMessageMenu.SAFETY);
        WorkCircleMessageMenu bean8 = new WorkCircleMessageMenu("工作日志", R.drawable.work_icon_log, WorkCircleMessageMenu.LOG);
        WorkCircleMessageMenu bean9 = new WorkCircleMessageMenu("成员管理", R.drawable.icon_member_manager, WorkCircleMessageMenu.MEMBER_MANAGER);
        WorkCircleMessageMenu bean10 = new WorkCircleMessageMenu("班组设置", R.drawable.icon_team_management, WorkCircleMessageMenu.GROUP_MANAGER);
        list.add(bean3);
        list.add(bean4);
        list.add(bean5);
        list.add(bean6);
        list.add(bean7);
        list.add(bean8);
        list.add(bean9);
        list.add(bean10);
        return list;
    }


    /**
     * 模块的点击事件
     *
     * @param bean
     * @param info
     */
    private void itemClickListener(final WorkCircleMessageMenu bean, GroupDiscussionInfo info) {
        String classType = info.getClass_type(); //项目组类型
        String groupId = info.getGroup_id(); //项目组id
        boolean isClosed = info.getIs_closed() == 1; //true表示已关闭
        boolean isMyselfGroup = UclientApplication.getUid().equals(info.getCreater_uid()); //是否是我创建的班组,如果创建者的id和登录者的uid相同 则认为是创建者
        switch (bean.getMenuType()) {
            case WorkCircleMessageMenu.SINGLE_RECORD_ACCOUNT: //添加记工(工人 相当于马上记一笔)
                if (isClosed) {
                    CommonMethod.makeNoticeLong(activity, "班组已关闭，不能执行此操作", CommonMethod.ERROR);
                    return;
                }
                if (isShowChangeRolerDialog(isMyselfGroup)) {
                    return;
                }
                AccountUtils.searchData(activity, info, false);
                break;
            case WorkCircleMessageMenu.MULTI_RECORD_ACCOUNT: //批量记工 (班组长)
                if (isClosed) {
                    CommonMethod.makeNoticeLong(activity, "班组已关闭，不能执行此操作", CommonMethod.ERROR);
                    return;
                }
                if (isShowChangeRolerDialog(isMyselfGroup)) {
                    return;
                }
                MultiPersonBatchAccountNewActivity.actionStart(activity, info.getPro_id(),
                        info.getGroup_name(), true, groupId, info.getMembers_head_pic(), info.getAll_pro_name(), info.getCreater_uid());
                break;
            case WorkCircleMessageMenu.WORK_BOOKS: //记工账本
                TurnOutForWorkActivity.actionStart(activity, info.getGroup_id(), isClosed, info.getPro_id());
                break;
            case WorkCircleMessageMenu.NOTICE: //通知
                NoticeListActivity.actionStart(activity, info);
                break;
            case WorkCircleMessageMenu.QUALITY: //质量
                QualityAndSafePageActivity.actionStart(activity, info, MessageType.MSG_QUALITY_STRING);
                break;
            case WorkCircleMessageMenu.SAFETY: //安全
                QualityAndSafePageActivity.actionStart(activity, info, MessageType.MSG_SAFE_STRING);
                break;
            case WorkCircleMessageMenu.SIGN: //签到
                SignListActivity.actionStart(activity, info);
                break;
            case WorkCircleMessageMenu.GROUP_MANAGER: //班组设置
                GroupManagerActivity.actionStart(activity, info, isClosed);
                break;
            case WorkCircleMessageMenu.TEAM_MANAGER: //项目设置
                TeamManagerActivity.actionStart(activity, info, isClosed);
                break;
            case WorkCircleMessageMenu.LOG: //工作日志
                MsgLogActivity.actionStart(activity, info, MessageType.MSG_LOG_STRING);
                break;
            case WorkCircleMessageMenu.RECODER_TABLE: //记工报表
                X5WebViewActivity.actionStart(activity, NetWorkRequest.STATISTICSCHARTS + "?is_demo=" + info.getIs_not_source() + "&talk_view=1&team_id=" + groupId);
                break;
            case WorkCircleMessageMenu.WEATHER_TABLE: //晴雨表
                WeatherTablelActivity.actionStart(activity, groupId, info.getAll_pro_name(), info.getIs_report() == 1 ? true : false, isMyselfGroup || info.getCan_at_all() == 1,
                        isClosed);
                break;
            case WorkCircleMessageMenu.EXAMINATION: //审批
                X5WebViewActivity.actionStart(activity, NetWorkRequest.APPLYFOR + groupId + "&close=" + info.getIs_closed());
                break;
            case WorkCircleMessageMenu.TASK: //任务
                TaskHomePageActivity.actionStart(activity, info.getAll_pro_name(), groupId, isClosed);
                break;
            case WorkCircleMessageMenu.PRO_CLOUD: //云盘
                ProCloudActivity.actionStart(activity, groupId, info.getCloud_disk(), info.getUsed_space(), info.getGroup_name(), CloudUtil.ROOT_DIR, isClosed);
                break;
            case WorkCircleMessageMenu.APP_WEBSITE: //微官网
                X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBSITE + groupId + "&class_type=" + classType + "&close=" + info.getIs_closed());
                break;
            case WorkCircleMessageMenu.DEVICE: //设备管理
                X5WebViewActivity.actionStart(activity, NetWorkRequest.EQUIPENT + groupId + "&class_type=" + classType + "&close=" + info.getIs_closed());
                break;
            case WorkCircleMessageMenu.REPOSITY: //资料库
                RepositoryGridViewActivity.actionStart(activity, classType);
                break;
            case WorkCircleMessageMenu.CHECK: //检查计划
                CheckPlanHomePageActivity.actionStart(activity, info);
                break;
            case WorkCircleMessageMenu.MEETING: //会议
                X5WebViewActivity.actionStart(activity, NetWorkRequest.CONFERENCE + groupId + "&close=" + info.getIs_closed() + "&group_name=" + info.getPro_name());
                break;
            case WorkCircleMessageMenu.PROXY_RECORD: //代班记工
                if (!validateProxyDate(info.getAgency_group_user())) {
                    return;
                }
                MultiPersonBatchAccountNewActivity.actionStart(activity, info.getPro_id(),
                        info.getGroup_name(), true, groupId, info.getMembers_head_pic(), info.getPro_name(), info.getAgency_group_user(), info.getCreater_uid());
                break;
            case WorkCircleMessageMenu.PROXY_FLOW: //代班流水
                if (!validateProxyDate(info.getAgency_group_user())) {
                    return;
                }
                int month = Calendar.getInstance().get(Calendar.MONTH) + 1;
                info.getAgency_group_user().setGroup_id(info.getGroup_id());
                RememberWorkerInfosActivity.actionStart(activity, Calendar.getInstance().get(Calendar.YEAR) + "", month < 10 ? "0" + month : String.valueOf(month), info.getAgency_group_user());
                break;
            case WorkCircleMessageMenu.PROXY_CHECK_ACCOUNT: //代班对账
                if (!validateProxyDate(info.getAgency_group_user())) {
                    return;
                }
                info.getAgency_group_user().setGroup_id(info.getGroup_id());
                RecordWorkConfirmActivity.actionStart(activity, null, null, null, info.getAgency_group_user(), null, groupId);
                break;
            case WorkCircleMessageMenu.RECORD_ACCOUNT_UPDATE: //记工变更
                if (!validateProxyDate(info.getAgency_group_user())) {
                    return;
                }
                AccountModifyActivity.actionStart(activity, info);
                break;
            case WorkCircleMessageMenu.MEMBER_MANAGER://成员管理
                MemberManagerActivity.actionStart(activity, groupId, classType, isClosed, info.can_at_all == 1, isMyselfGroup);
                break;
            case WorkCircleMessageMenu.ACCOUNT_BORROW: //借支结算
                if (isShowChangeRolerDialog(isMyselfGroup)) {
                    return;
                }
                AccountUtils.searchData(activity, info, true);
                break;
        }
        checkIsClearUnreadMessage(bean.getMenuType());
    }

    /**
     * 检查代理时间
     *
     * @param user 代班长信息
     * @return true 表示验证通过 能正常记账 false反之
     */
    private boolean validateProxyDate(AgencyGroupUser user) {
        if (user == null || TextUtils.isEmpty(user.getUid())) {
            return false;
        }
        if (user.getIs_start() == 0) { //还未到开始记账时间
            showUnStartDialog(user.getStart_time());
            return false;
        } else if (user.getIs_expire() == 1) { //记账时间已过期
            showExipreDialog();
            return false;
        }
        return true;
    }


    /**
     * 显示代班长已过期弹框
     */
    private void showExipreDialog() {
        new DiaLogBottomRed(activity, "我知道了", "代班时间已过期，请联系班组长为你延长代班时长").show();
    }

    /**
     * 显示代班长记录时间还未开始的弹框
     */
    private void showUnStartDialog(String startTime) {
        new DiaLogBottomRed(activity, "我知道了", "代班开始时间为" + startTime + ",到期后再开始代班记工").show();
    }

    /**
     * 如果是自己创建的班组并且当前角色为工人，那么需要弹框提示 切换角色才能进入记账
     * 如果不是自己创建的班组并且当前角色为工头，那么需要弹框提示 切换角色才能进入记账
     *
     * @param isMyselfGroup
     * @return
     */
    private boolean isShowChangeRolerDialog(boolean isMyselfGroup) {
        if (isMyselfGroup) {
            if (!UclientApplication.isForemanRoler(activity)) {
                DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(activity, null, null, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        CommonHttpRequest.changeRoler(activity, false, Constance.ROLETYPE_FM, null);
                    }
                });
                dialogLeftRightBtnConfirm.setRightBtnText(activity.getString(R.string.change_roler_foreman));
                dialogLeftRightBtnConfirm.setLeftBtnText(activity.getString(R.string.no_change_role));
                dialogLeftRightBtnConfirm.setHtmlContent(Utils.getHtmlColor666666("你当前是")
                        + Utils.getHtmlColor000000("&nbsp;【工人】&nbsp;") + Utils.getHtmlColor666666("<br/>如需对自己的班组批量记工，请切换成") + Utils.getHtmlColor000000("&nbsp;【班组长】&nbsp;")
                        + Utils.getHtmlColor666666("身份。"));
                dialogLeftRightBtnConfirm.show();
                return true;
            }
        } else {
            if (UclientApplication.isForemanRoler(activity)) {
                DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(activity, null, null, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        CommonHttpRequest.changeRoler(activity, false, Constance.ROLETYPE_WORKER, null);
                    }
                });
                dialogLeftRightBtnConfirm.setRightBtnText(activity.getString(R.string.change_roler_worker));
                dialogLeftRightBtnConfirm.setLeftBtnText(activity.getString(R.string.no_change_role));
                dialogLeftRightBtnConfirm.setHtmlContent(Utils.getHtmlColor666666("你当前是")
                        + Utils.getHtmlColor000000("&nbsp;【班组长】&nbsp;") + Utils.getHtmlColor666666("<br/>如需在加入的班组中记工，请切换成") + Utils.getHtmlColor000000("&nbsp;【工人】&nbsp;")
                        + Utils.getHtmlColor666666("身份。"));
                dialogLeftRightBtnConfirm.show();
                return true;
            }
        }
        return false;
    }

    /**
     * 检测模块是否需要清空未读消息
     *
     * @param menuType
     */
    private void checkIsClearUnreadMessage(int menuType) {
        ChatMainInfo chatMainInfo = this.chatBaseInfo;
        boolean isUpdateUnreadMessage = false; //true表示需要改变数据结构
        switch (menuType) {
            case WorkCircleMessageMenu.EXAMINATION: //审批
                if (chatMainInfo.getUnread_approval_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_approval_count(0);
                }
                break;
            case WorkCircleMessageMenu.TASK: //任务
                if (chatMainInfo.getUnread_task_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_task_count(0);
                }
                break;
            case WorkCircleMessageMenu.NOTICE: //通知
                if (chatMainInfo.getUnread_notice_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_notice_count(0);
                }
                break;
            case WorkCircleMessageMenu.QUALITY: //质量
                if (chatMainInfo.getUnread_quality_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_quality_count(0);
                }
                break;
            case WorkCircleMessageMenu.SAFETY: //安全
                if (chatMainInfo.getUnread_safe_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_safe_count(0);
                }
                break;
            case WorkCircleMessageMenu.WORK_BOOKS: //记工账本
                if (chatMainInfo.getUnread_billRecord_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_billRecord_count(0);
                }
                break;
            case WorkCircleMessageMenu.LOG: //工作日志
                if (chatMainInfo.getUnread_log_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_log_count(0);
                }
                break;
            case WorkCircleMessageMenu.CHECK: //检查计划
                if (chatMainInfo.getUnread_inspect_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_inspect_count(0);
                }
                break;
            case WorkCircleMessageMenu.MEETING: //会议
                if (chatMainInfo.getUnread_meeting_count() > 0) {
                    isUpdateUnreadMessage = true;
                    chatMainInfo.setUnread_meeting_count(0);
                }
                break;
        }
        if (isUpdateUnreadMessage) {
            ContentValues values = new ContentValues();
            values.put("unread_quality_count", chatMainInfo.getUnread_quality_count());
            values.put("unread_safe_count", chatMainInfo.getUnread_safe_count());
            values.put("unread_inspect_count", chatMainInfo.getUnread_inspect_count());
            values.put("unread_task_count", chatMainInfo.getUnread_task_count());
            values.put("unread_notice_count", chatMainInfo.getUnread_notice_count());
            values.put("unread_meeting_count", chatMainInfo.getUnread_meeting_count());
            values.put("unread_approval_count", chatMainInfo.getUnread_approval_count());
            values.put("unread_log_count", chatMainInfo.getUnread_log_count());
            values.put("unread_billRecord_count", chatMainInfo.getUnread_billRecord_count());
            LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ? and message_uid = ?", chatMainInfo.getGroup_info().getGroup_id(),
                    chatMainInfo.getGroup_info().getClass_type(), UclientApplication.getUid());
            chatMainInfo.save();
            notifyDataSetChanged();
            //刷新首页的数据
            LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN));
        }
    }
}
