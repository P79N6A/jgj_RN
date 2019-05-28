package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Html;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.UnAccountMembersAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.BatchAccount;
import com.jizhi.jlongg.main.bean.BatchAccountDetail;
import com.jizhi.jlongg.main.bean.BatchAccountOtherProInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.dialog.DialogUnSetAccountSalary;
import com.jizhi.jlongg.main.listener.CallBackConfirm;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.RecordAccountDatePopWindow;
import com.jizhi.jlongg.main.popwindow.WheelViewBatchAccountMultiPerson;
import com.jizhi.jlongg.main.popwindow.WheelViewBatchAccountSinglePerson;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CustomExpandableListView;
import com.jizhi.jongg.widget.NestRadioGroup;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.squareup.otto.Subscribe;

import org.joda.time.DateTime;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import noman.weekcalendar.WeekCalendar;
import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能:多人批量记账
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class MultiPersonBatchAccountNewActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 是否已选 所有的未记账对象
     */
    private boolean isSelecteAllUnAccountObj;
    /**
     * 未记账、已记账列表适配器
     */
    private MultiPersonAccountAdapter adapter;
    /**
     * listView
     */
    private CustomExpandableListView listView;
    /**
     * 日期滑动组件
     */
    private WeekCalendar weekCalendar;
    /**
     * 项目名称,项目id,提交批量记账的日期
     */
    private String proName, pid, submitDate;
    /**
     * 日期上面的日期选择框
     */
    private TextView dateText;
    /**
     * 当前时间
     */
    private CustomDate customDate;
    /**
     * 未设置薪资模板的成员 主要是做数据缓存使用一下 当设置了薪资模板后 直接取这个对象
     */
    private BatchAccountDetail clickAccountMember;
    /**
     * 成员今日是否已记账
     */
    private boolean isAccountedMember;
    /**
     * 当前工种
     * 1.点工
     * 5.包工记工天
     */
    public String currentWork = AccountUtil.CONSTRACTOR_CHECK;
    /**
     * 已填写的备注内容
     */
    private String remarkDesc;
    /**
     * 备注图片数据
     */
    private ArrayList<ImageItem> remarkImages;

    /**
     * @param context
     * @param pid            项目id
     * @param completeName   完整的项目名称 包含班组名称的
     * @param isFromGroup    是否来自班组  如果来自班组 则显示我要记单笔按钮
     * @param groupId        项目组id
     * @param memberHeadPic  项目组成员头像
     * @param proName        项目名称
     * @param createGroupUid 创建者uid
     */
    public static void actionStart(Activity context, String pid, String completeName, boolean isFromGroup, String groupId,
                                   List<String> memberHeadPic, String proName, AgencyGroupUser agencyGroupUser, String createGroupUid) {
        Intent intent = new Intent(context, MultiPersonBatchAccountNewActivity.class);
        intent.putExtra("param1", pid);
        intent.putExtra("param2", completeName);
        intent.putExtra("param3", isFromGroup);
        intent.putExtra("param4", groupId);
        intent.putExtra("param5", (Serializable) memberHeadPic);
        intent.putExtra("param6", proName);
        intent.putExtra("agencyGroupUser", agencyGroupUser);
        intent.putExtra("create_group_uid", createGroupUid);
        context.startActivityForResult(intent, REQUEST);
    }

    /**
     * @param context
     * @param pid           项目id
     * @param completeName  完整的项目名称 包含班组名称的
     * @param isFromGroup   是否来自班组  如果来自班组 则显示我要记单笔按钮
     * @param groupId       项目组id
     * @param memberHeadPic 项目组成员头像
     * @param proName       项目名称
     */
    public static void actionStart(Activity context, String pid, String completeName, boolean isFromGroup, String groupId, List<String> memberHeadPic, String proName, String createGroupUid) {
        Intent intent = new Intent(context, MultiPersonBatchAccountNewActivity.class);
        intent.putExtra("param1", pid);
        intent.putExtra("param2", completeName);
        intent.putExtra("param3", isFromGroup);
        intent.putExtra("param4", groupId);
        intent.putExtra("param5", (Serializable) memberHeadPic);
        intent.putExtra("param6", proName);
        intent.putExtra("create_group_uid", createGroupUid);
        context.startActivityForResult(intent, REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.multi_person_batch_account);
        init();
        getGroupMembersAccountState(false);
    }

    private void init() {
        Intent intent = getIntent();
        pid = intent.getStringExtra("param1");
        proName = intent.getStringExtra("param2");
        View headView = getLayoutInflater().inflate(R.layout.multi_person_batch_date_head, null); //批量记账 日期滑动选择框
        headView.findViewById(R.id.showDateText).setOnClickListener(this);
        TextView titleText = getTextView(R.id.title);
        TextView rightTitleText = getTextView(R.id.right_title);
        weekCalendar = (WeekCalendar) headView.findViewById(R.id.weekCalendar);
        dateText = (TextView) headView.findViewById(R.id.showDateText);
        customDate = new CustomDate();
        listView = (CustomExpandableListView) findViewById(R.id.expandableListView);
        titleText.setText(proName);
        rightTitleText.setText(R.string.record_single);
        getButton(R.id.red_btn).setText("记工时");
        setDateInfo(customDate.year, customDate.month, customDate.day);
        listView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                return true;
            }
        });
        listView.addHeaderView(headView, null, false);
        adapter = new MultiPersonAccountAdapter(getApplicationContext(), null);
        listView.setAdapter(adapter);
    }

    /**
     * 设置日历信息
     *
     * @param selectedYear  年
     * @param selectedMonth 月
     * @param selectedDay   日
     */
    private void setDateInfo(int selectedYear, int selectedMonth, int selectedDay) {
        String month = selectedMonth < 10 ? "0" + selectedMonth : selectedMonth + "";
        String day = selectedDay < 10 ? "0" + selectedDay : selectedDay + "";
        dateText.setText(selectedYear + "年" + selectedMonth + "月");
        submitDate = selectedYear + month + day; //设置选中的日期 方便查询数据
        customDate.year = selectedYear;
        customDate.month = selectedMonth;
        customDate.day = selectedDay;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //我要记单笔
                Intent intent = new Intent(getApplicationContext(), NewAccountActivity.class);
                intent.putExtra(Constance.ISMSGBILL, true);
                intent.putExtra(Constance.DATE, submitDate);
                Bundle bundle = new Bundle();
                bundle.putString(Constance.PRONAME, getIntent().getStringExtra("param6")); //项目名称
                bundle.putString(Constance.PID, pid); //项目id
                bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra("param4")); //项目组id
                bundle.putString(Constance.enum_parameter.ROLETYPE.toString(), Constance.ROLETYPE_FM); //当前为班组角色
                LUtils.e("-------aaaaaaaaa--11--create_group_uid---------" + getIntent().getSerializableExtra("create_group_uid"));
                bundle.putSerializable("agencyGroupUser", getIntent().getSerializableExtra("agencyGroupUser")); //代班信息
                bundle.putSerializable("create_group_uid", getIntent().getSerializableExtra("create_group_uid")); //代班信息
                intent.putExtras(bundle);
                startActivityForResult(intent, REQUEST);
                break;
            case R.id.red_btn: //批量保存记账
//                if (!checkUnAccountSelectMemberIsSetSalary()) {
//                    return;
//                }
                if (getUnAccountSelecteSize() > 0) {//未记账已选中的人员数量必须大于0才能提交数据
                    showBatchAccountModul();
                } else {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请点击工人头像选择要记工的工人", CommonMethod.ERROR);
                }
                break;
            case R.id.showDateText: //选择日期弹出框
                showDateDialog();
                break;
        }
    }


    /**
     * 选择日期弹出框
     */
    private void showDateDialog() {
        RecordAccountDatePopWindow datePickerPopWindow = new RecordAccountDatePopWindow(this, getString(R.string.choosetime), 2, new RecordAccountDatePopWindow.SelectedDateListener() {
            @Override
            public void selectedDays() { //选择多天

            }

            @Override
            public void selectedDate(String year, String month, String day, String week) { //选择某天
                int intYear = Integer.parseInt(year);
                int intMonth = Integer.parseInt(month);
                int intDay = Integer.parseInt(day);
                int currentTime = TimesUtils.getCurrentTimeYearMonthDay()[0] * 10000 + TimesUtils.getCurrentTimeYearMonthDay()[1] * 100 + TimesUtils.getCurrentTimeYearMonthDay()[2];
                if (!checkForemanIsProxyDate(intYear + "-" + intMonth + "-" + intDay)) {
                    jumpToLastDate();
                    return;
                }
                if (intYear * 10000 + intMonth * 100 + intDay < Constance.STARTTIME) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "只能选择2014年01月01日以后的日期", CommonMethod.ERROR);
                    return;
                } else if (intYear * 10000 + intMonth * 100 + intDay > currentTime) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "不能选择今天以后的日期", CommonMethod.ERROR);
                    return;
                } else {
                    setDateInfo(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day));
                }
                DateTime date = new DateTime(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day), 0, 0);
                weekCalendar.setSelectedDate(date); //跳转到对应的日期
                getGroupMembersAccountState(false);
            }
        }, customDate.year, customDate.month, customDate.day);
        datePickerPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(MultiPersonBatchAccountNewActivity.this, 0.5F);
    }


    /**
     * 批量记账列表适配器
     */
    class MultiPersonAccountAdapter extends BaseExpandableListAdapter {
        /**
         * 列表数据
         */
        private List<BatchAccount> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 未记账成员标志
         */
        private final int UN_ACCOUNT = 0;
        /**
         * 已记账成员标志
         */
        private final int ACCOUNTED = 1;

        /**
         * 批量记账正常时长,批量记账加班时长
         */
        public float batchNormalTime = 8f, batchOverTime = 0;


        public MultiPersonAccountAdapter(Context context, List<BatchAccount> list) {
            this.list = list;
            inflater = LayoutInflater.from(context);
        }

        public void updateList(List<BatchAccount> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public List<BatchAccount> getList() {
            return list;
        }

        public void setList(List<BatchAccount> list) {
            this.list = list;
        }

        @Override
        public int getGroupCount() {
            return list == null ? 0 : list.size();
        }


        @Override
        public int getChildrenCount(int groupPosition) {
            String accountType = getGroup(groupPosition).getType(); //记账类型
            if (TextUtils.isEmpty(accountType)) {
                return UN_ACCOUNT;
            }
            List<BatchAccountDetail> groupList = list.get(groupPosition).getList();
            if (accountType.equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的列表 长度只返回1 只需要记录未记账的人
                return 1;
            } else {
                return groupList != null && groupList.size() > 0 ? groupList.size() : 0;
            }
        }

        @Override
        public int getChildTypeCount() {
            return 2;
        }

        @Override
        public int getChildType(int groupPosition, int childPosition) {
            String accountType = getGroup(groupPosition).getType(); //记账类型
            if (TextUtils.isEmpty(accountType)) {
                return UN_ACCOUNT;
            }
            return accountType.equals(BatchAccount.UN_ACCOUNT_STRING) ? UN_ACCOUNT : ACCOUNTED;
        }


        @Override
        public BatchAccount getGroup(int groupPosition) {
            return list.get(groupPosition);
        }

        @Override
        public BatchAccountDetail getChild(int groupPosition, int childPosition) {
            return list.get(groupPosition).getList().get(childPosition);
        }

        @Override
        public long getGroupId(int groupPosition) {
            return groupPosition;
        }

        @Override
        public long getChildId(int groupPosition, int childPosition) {
            return childPosition;
        }

        @Override
        public boolean hasStableIds() {
            return false;
        }

        @Override
        public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
            final GroupHolder holder;
            int groupType = list.get(groupPosition).getType().equals(BatchAccount.UN_ACCOUNT_STRING) ? UN_ACCOUNT : ACCOUNTED;
            BatchAccount batchAccount = getGroup(groupPosition);
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_multi_person_batch_title, null);
                holder = new GroupHolder(convertView, groupType, batchAccount);
                convertView.setTag(holder);
            } else {
                holder = (GroupHolder) convertView.getTag();
            }
            if (groupType == UN_ACCOUNT) { //未记账的班组人数
                holder.workLayout.setVisibility(View.VISIBLE);
                holder.constratorText.setVisibility(currentWork == AccountUtil.HOUR_WORKER ? View.GONE : View.VISIBLE);
                holder.numberText.setText("未记工工人(" + list.get(groupPosition).getAccount_num() + "人)");
                holder.longClickHeadDescText.setVisibility(View.VISIBLE);
                if (batchAccount.getList() != null && batchAccount.getList().size() > 0) { //必须有未记账的成员时才会显示全选按钮
                    holder.selecteAllBtn.setVisibility(View.VISIBLE);
                    holder.selecteAllBtn.setText(isSelecteAllUnAccountObj ? "取消全选" : "全选");
                    holder.selecteAllBtn.setOnClickListener(new View.OnClickListener() { //全选按钮
                        @Override
                        public void onClick(View v) {
                            selecteAllOrCancelAll(!isSelecteAllUnAccountObj);
                        }
                    });
                } else { //没有未记账成员时需要隐藏全选按钮
                    holder.selecteAllBtn.setVisibility(View.GONE);
                }
            } else { //已记账的人数
                holder.workLayout.setVisibility(View.GONE);
                holder.numberText.setText("已记工工人(" + list.get(groupPosition).getAccount_num() + "人)");
                //当已记工工人列表无数据时，不显示该说明文字；有已记工工人数据时，才显示该说明文字
                if (list.get(groupPosition).getAccount_num() == 0) {
                    holder.longClickHeadDescText.setVisibility(View.GONE);
                } else {
                    holder.longClickHeadDescText.setVisibility(View.VISIBLE);
                    holder.longClickHeadDescText.setText("如需对工人记第2笔，请点击右上角“记单笔”为他记工");
                }
                holder.selecteAllBtn.setVisibility(View.GONE);
            }
            return convertView;
        }

        @Override
        public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
            int childType = getChildType(groupPosition, childPosition);
            final ChildHolder childHolder;
            if (convertView == null) {
                if (childType == UN_ACCOUNT) { //未记账的View
                    convertView = inflater.inflate(R.layout.item_multi_person_batch_unaccount, null);
                } else { //已记账的View
                    convertView = inflater.inflate(R.layout.item_multi_person_batch_accounted, null);
                }
                childHolder = new ChildHolder(convertView, childType);
                convertView.setTag(childHolder);
            } else {
                childHolder = (ChildHolder) convertView.getTag();
            }
            if (childType == UN_ACCOUNT) { //未记账的对象
                final List<BatchAccountDetail> unAccountMembers = getGroup(groupPosition).getList(); //获取未记账成员
                UnAccountMembersAdapter proMemberAdapter = new UnAccountMembersAdapter(MultiPersonBatchAccountNewActivity.this, unAccountMembers, new AddMemberListener() {
                    @Override
                    public void add(int addType) { //添加班组成员
                        List<GroupMemberInfo> groupMemberList = new ArrayList<>();
                        for (BatchAccount batchAccount : list) {
                            for (BatchAccountDetail member : batchAccount.getList()) { //获取成员列表
                                GroupMemberInfo groupMemberInfo = new GroupMemberInfo();
                                groupMemberInfo.setUid(member.getUid());
                                groupMemberInfo.setReal_name(member.getReal_name());
                                //这里分不清楚后台用的是哪一个电话号码了 干脆两个都设置上.....
                                groupMemberInfo.setTelephone(member.getTelephone());
                                groupMemberList.add(groupMemberInfo);
                            }
                        }
                        Intent intent = getIntent();
                        String groupId = intent.getStringExtra("param4"); //项目组id
                        List<String> membersHeadPic = (List<String>) intent.getSerializableExtra("param5");//项目组头像
                        AddMemberWayActivity.actionStart(MultiPersonBatchAccountNewActivity.this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER, groupId,
                                Constance.GROUP, membersHeadPic, proName, groupMemberList, true);
                    }

                    @Override
                    public void remove(int state) { //删除班组成员
                        ArrayList<GroupMemberInfo> groupMemberList = new ArrayList<>();
                        for (BatchAccount batchAccount : list) {
                            for (BatchAccountDetail member : batchAccount.getList()) { //获取成员列表
                                GroupMemberInfo groupMemberInfo = new GroupMemberInfo();
                                groupMemberInfo.setUid(member.getUid());
                                groupMemberInfo.setReal_name(member.getReal_name());
                                //这里分不清楚后台用的是哪一个电话号码了 干脆两个都设置上.....
                                groupMemberInfo.setTelephone(member.getTelephone());
                                groupMemberList.add(groupMemberInfo);
                            }
                        }
                        Intent intent = new Intent(MultiPersonBatchAccountNewActivity.this, DeleteMemberActivity.class);
                        intent.putExtra(Constance.BEAN_ARRAY, groupMemberList);
                        intent.putExtra(Constance.GROUP_ID, getIntent().getStringExtra("param4"));
                        intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER);
                        startActivityForResult(intent, Constance.REQUEST);
//                        new DiaLogBottomRed(MultiPersonBatchAccountNewActivity.this,
//                                "我知道了", "若想删除" + proName + "下的成员，请去“班组设置”中进行操作").show();
                    }
                }, new UnAccountMembersAdapter.ClickMemberListener() { //当点击头像时 触发的回调
                    @Override
                    public void clickMember(final BatchAccountDetail bean, boolean isSetSalary) {
                        if (!isSetSalary) { //如果未设置薪资模板 先弹出设置薪资模板的弹框
                            new DialogUnSetAccountSalary(MultiPersonBatchAccountNewActivity.this, bean.getReal_name(), currentWork, new CallBackConfirm() {
                                @Override
                                public void callBack() {
                                    setSalaryOrIntent(bean, false, true);
                                }
                            }).show();
                            return;
                        }
                        setSubmitBtnState();
                    }

                    @Override
                    public void longClickMember(final BatchAccountDetail bean) {
                        setSalaryOrIntent(bean, false, true);
                    }
                });
                childHolder.gridView.setAdapter(proMemberAdapter); //设置班组成员适配器
            } else { //已记账了的对象
                final BatchAccountDetail bean = getChild(groupPosition, childPosition);
                childHolder.titleLayout.setVisibility(childPosition == 0 ? View.VISIBLE : View.GONE);
                childHolder.realName.setText(bean.getReal_name());
                if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getMsg_text())) { //已经在其他项目中记录了一笔点工、则显示已记工的信息
                    childHolder.normalTime.setText(Html.fromHtml("<font color='#999999'>你已在</font><font color='#333333'> " +
                            bean.getMsg().getMsg_text() + " </font><font color='#999999'>对他记了一笔</font>"));
                    childHolder.overTime.setVisibility(View.GONE);
                    childHolder.clickIcon.setVisibility(View.INVISIBLE);
                } else { //正常的记账信息
                    childHolder.clickIcon.setVisibility(View.VISIBLE);
                    childHolder.overTime.setVisibility(View.VISIBLE);
                    childHolder.recordTypeIcon.setImageResource(bean.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER)
                            ? R.drawable.hour_worker_flag : R.drawable.constar_flag);
                    if (!TextUtils.isEmpty(bean.getTpl().getIs_diff())) { //有差帐
                        childHolder.normalTime.setText(bean.getTpl().getIs_diff());
                        childHolder.overTime.setText(bean.getTpl().getIs_diff());
                    } else {
                        Salary currentTpl = bean.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? bean.getTpl() : bean.getUnit_quan_tpl();
                        Double salaryWorkTime = currentTpl.getW_h_tpl(); //薪资模板上班时长
                        Double salaryOverTime;
                        if (currentTpl.getHour_type()==1){
                            salaryOverTime=currentTpl.getS_tpl()/currentTpl.getO_s_tpl();
                        }else {
                            salaryOverTime = currentTpl.getO_h_tpl(); //薪资模板加班时长
                        }
                        if (salaryWorkTime == 0d) {
                            salaryWorkTime = 1d;
                        }
                        if (salaryOverTime == 0d) {
                            salaryOverTime = 1d;
                        }
                        Double selectWorkTime = bean.getChoose_tpl().getChoose_w_h_tpl(); //选中的上班时长
                        Double selectOverTime = bean.getChoose_tpl().getChoose_o_h_tpl(); //选中的加班时长
                        if (selectWorkTime == 0d) {
                            childHolder.normalTime.setText("休息");
                        } else {
                            String result = Utils.m2(selectWorkTime / salaryWorkTime);
                            childHolder.normalTime.setText(Html.fromHtml("<font color='#000000'>" + RecordUtils.cancelIntergerZeroFloat(selectWorkTime) +
                                    "小时</font><font color='#999999'>(" + result + "个工)</font>"));
                        }
                        if (selectOverTime == 0d) {
                            childHolder.overTime.setText("无加班");
                        } else {
                            String result = Utils.m2(selectOverTime / salaryOverTime);
                            childHolder.overTime.setText(Html.fromHtml("<font color='#000000'>" + RecordUtils.cancelIntergerZeroFloat(selectOverTime) +
                                    "小时</font><font color='#999999'>(" + result + "个工)</font>"));
                        }
                    }
                }
                childHolder.itemLayout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getMsg_text())) { //已在其他项目记录过点工的人 则不能修改他已记录的点工信息
                            return;
                        }
                        showAlreadyAccountSalary(bean);
                    }
                });
                childHolder.itemLayout.setOnLongClickListener(new View.OnLongClickListener() {
                    @Override
                    public boolean onLongClick(View v) {
                        if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getMsg_text())) { //已在其他项目记录过点工的人 则不能修改他已记录的点工信息
                            return false;
                        }
                        clickAccountMember = bean;
                        return false;
                    }
                });
                childHolder.itemLayout.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                        if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getMsg_text())) { //已在其他项目记录过点工的人 则不能修改他已记录的点工信息
                            return;
                        }
                        menu.add(0, Menu.FIRST, 0, "删除");
                    }
                });
            }
            return convertView;
        }

        @Override
        public boolean isChildSelectable(int groupPosition, int childPosition) {
            return false;
        }

        class GroupHolder {
            /**
             * 已记账和未记账的人数
             */
            TextView numberText;
            /**
             * 长按头像删除头像描述的文本
             */
            TextView longClickHeadDescText;
            /**
             * 全选按钮
             */
            TextView selecteAllBtn;
            /**
             * 工种布局
             */
            View workLayout;
            /**
             * 包工提示文本
             */
            View constratorText;


            public GroupHolder(View convertView, int groupType, BatchAccount batchAccount) {
                numberText = (TextView) convertView.findViewById(R.id.numberText);
                selecteAllBtn = (TextView) convertView.findViewById(R.id.selecteAllBtn);
                longClickHeadDescText = (TextView) convertView.findViewById(R.id.longClickHeadDescText);
                workLayout = convertView.findViewById(R.id.workLayout);
                constratorText = convertView.findViewById(R.id.constratorText);
                if (groupType == UN_ACCOUNT && batchAccount != null) {
                    //批量记工类型 ,如果为空 则取服务器上次记账的状态
                    //（V3.5.3）记工类型：用户首次使用批量记工，记工类型默认选中包工记工天，之后记工类型默认到上一次记工选择的类型；
                    int multipartSelectType = (int) SPUtils.get(getApplicationContext(), "multipart_select_type", 0, Constance.JLONGG);
                    if (multipartSelectType == 0) { //还未获取到本地已存储的状态
                        if (batchAccount.getLast_accounts_type() == AccountUtil.HOUR_WORKER_INT) {
                            ((RadioButton) convertView.findViewById(R.id.hourWorkBtn)).setChecked(true); //设置点工按钮
                            currentWork = AccountUtil.HOUR_WORKER;
                        } else {
                            ((RadioButton) convertView.findViewById(R.id.constactorBtn)).setChecked(true); //设置包工按钮
                            currentWork = AccountUtil.CONSTRACTOR_CHECK;
                        }
                    } else {
                        if (multipartSelectType == AccountUtil.HOUR_WORKER_INT) {
                            ((RadioButton) convertView.findViewById(R.id.hourWorkBtn)).setChecked(true); //设置点工按钮
                            currentWork = AccountUtil.HOUR_WORKER;
                        } else {
                            ((RadioButton) convertView.findViewById(R.id.constactorBtn)).setChecked(true); //设置包工按钮
                            currentWork = AccountUtil.CONSTRACTOR_CHECK;
                        }
                    }
                    NestRadioGroup nestRadioGroup = (NestRadioGroup) convertView.findViewById(R.id.guide_rg);
                    nestRadioGroup.setOnCheckedChangeListener(new NestRadioGroup.OnCheckedChangeListener() {
                        @Override
                        public void onCheckedChanged(NestRadioGroup group, int checkedId) {
                            switch (checkedId) {
                                case R.id.hourWorkBtn: //点工
                                    currentWork = AccountUtil.HOUR_WORKER;
                                    adapter.notifyDataSetChanged();
                                    SPUtils.put(getApplicationContext(), "multipart_select_type", AccountUtil.HOUR_WORKER_INT, Constance.JLONGG);
                                    break;
                                case R.id.constactorBtn: //包工记工天
                                    currentWork = AccountUtil.CONSTRACTOR_CHECK;
                                    adapter.notifyDataSetChanged();
                                    SPUtils.put(getApplicationContext(), "multipart_select_type", AccountUtil.CONSTRACTOR_CHECK_INT, Constance.JLONGG);
                                    break;
                            }
                        }
                    });
                }
            }

        }

        class ChildHolder {

            /**
             * 未记账对象
             */
            GridView gridView;
            /**
             * 记账人名称
             */
            TextView realName;
            /**
             * 上班时常
             */
            TextView normalTime;
            /**
             * 加班时常
             */
            TextView overTime;
            /**
             * 已记账标题布局
             */
            View titleLayout;
            /**
             * 选项布局
             */
            View itemLayout;
            /**
             * 可点击的下标
             */
            ImageView clickIcon;
            /**
             * 记账类型图片
             */
            ImageView recordTypeIcon;

            public ChildHolder(View convertView, int childType) {
                if (childType == UN_ACCOUNT) {
                    gridView = (GridView) convertView.findViewById(R.id.gridView);
                } else {
                    recordTypeIcon = (ImageView) convertView.findViewById(R.id.recordTypeIcon);
                    clickIcon = (ImageView) convertView.findViewById(R.id.clickIcon);
                    realName = (TextView) convertView.findViewById(R.id.realName);
                    normalTime = (TextView) convertView.findViewById(R.id.normalTime);
                    overTime = (TextView) convertView.findViewById(R.id.overTime);
                    titleLayout = convertView.findViewById(R.id.titleLayout);
                    itemLayout = convertView.findViewById(R.id.itemLayout);
                }
            }
        }
    }

    /**
     * 删除已记账对象数据
     *
     * @param recordId
     */
    public void deleteItem(final String recordId, final WheelViewBatchAccountSinglePerson wheelViewBatchAccountSinglePerson) {
        DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(this, new DiaLogTitleListener() {
            @Override
            public void clickAccess(int position) {
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                params.addBodyParameter("id", recordId);
                String groupId = getIntent().getStringExtra("param4");
                if (!TextUtils.isEmpty(groupId)) { //代班长删除记账的时候在传
                    params.addBodyParameter("group_id", groupId); //项目组id
                }
                String httpUrl = NetWorkRequest.DELETE_JLWORKDAY;
                CommonHttpRequest.commonRequest(MultiPersonBatchAccountNewActivity.this, httpUrl, BaseNetBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        if (wheelViewBatchAccountSinglePerson != null && wheelViewBatchAccountSinglePerson.isShowing()) {
                            wheelViewBatchAccountSinglePerson.dismiss();
                        }
                        CommonMethod.makeNoticeLong(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                        getGroupMembersAccountState(false);
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
            }
        }, -1, getString(R.string.delete_account_tips));
        dialogOnlyTitle.setConfirmBtnName(getString(R.string.confirm_delete));
        dialogOnlyTitle.show();
    }


    /**
     * 设置提交按钮状态
     */
    private void setSubmitBtnState() {
        boolean mIsSelecteAllUnAccountObj = isSelecteAllUnAccountObj();
        if (mIsSelecteAllUnAccountObj != isSelecteAllUnAccountObj) {
            isSelecteAllUnAccountObj = mIsSelecteAllUnAccountObj;
            adapter.notifyDataSetChanged();
        }
    }

    /**
     * 批量记账弹框
     */
    private WheelViewBatchAccountMultiPerson batchAccountMultiPerson;

    /**
     * 显示批量记账弹出框
     * 点击批量设置区,当前页面弹出层,载入批量设置的两个值(正常上班和加班时长)
     * 正常上班可选值:休息 ~ 12小时,0.5小时为刻度
     * 休息 0.5小时 1小时 1.5小时 以此类推,直至12小时
     * 加班时长可选值:无加班 ~ 12小时,0.5小时为刻度
     * 无加班 0.5小时 1小时 1.5小时 以此类推,直至12小时
     * 批量设置,仅改变未记工工人的正常上班和加班时长
     */
    private void showBatchAccountModul() {
        if (batchAccountMultiPerson != null) {
            if (batchAccountMultiPerson.isShowing()) {
                batchAccountMultiPerson.dismiss();
            }
            batchAccountMultiPerson = null;
        }
        //批量记账模板选择弹出框
        String month = customDate.month >= 10 ? customDate.month + "" : "0" + customDate.month;
        String day = customDate.day >= 10 ? customDate.day + "" : "0" + customDate.day;
        String date = customDate.year + "-" + month + "-" + day;
        batchAccountMultiPerson = new WheelViewBatchAccountMultiPerson(this, getUnAccountSelecteSize(), date, remarkDesc, remarkImages, new WheelViewBatchAccountMultiPerson.SelecteMultiPersonModulListener() {
            @Override
            public void selectedMultiPersonTime(WorkTime normalTime, WorkTime overTime) { //选择时长回调
                List<BatchAccount> batchAccountList = adapter.getList(); //批量记账数据
                for (BatchAccount batchAccount : batchAccountList) {
                    for (BatchAccountDetail accountDetails : batchAccount.getList()) {
                        if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //只设置没有记账的对象、已经记账的则不用设置
                            Salary chooseTpl = accountDetails.getChoose_tpl();
                            chooseTpl.setChoose_w_h_tpl(normalTime.getWorkTimes());
                            chooseTpl.setChoose_o_h_tpl(overTime.getWorkTimes());
                        }
                    }
                }
                adapter.batchNormalTime = (float) normalTime.getWorkTimes();
                adapter.batchOverTime = (float) overTime.getWorkTimes();
                submitBatchAccount(true, false);
            }

            @Override
            public void setAccountedSalary(BatchAccountDetail bean) {
                setSalaryOrIntent(bean, true, true);
            }

            @Override
            public void setRemark() {
                Intent intent = new Intent(MultiPersonBatchAccountNewActivity.this, RemarksActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable(RemarksActivity.PHOTO_DATA, remarkImages); //图片信息
                bundle.putString(RemarksActivity.REMARK_DESC, remarkDesc); //备注信息
                intent.putExtras(bundle);
                startActivityForResult(intent, Constance.REQUEST);
            }
        });
        batchAccountMultiPerson.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(MultiPersonBatchAccountNewActivity.this, 0.5F);
    }

    /**
     * 显示已记账对象的薪资模板
     *
     * @param bean 记账对象信息
     */
    private void showAlreadyAccountSalary(final BatchAccountDetail bean) {
        BatchAccountOtherProInfo recordMsg = bean.getMsg();
        //记账类型不能为空
        if (recordMsg == null || TextUtils.isEmpty(recordMsg.getAccounts_type())) {
            return;
        }
        //记账类型 1表示点工 5表示包工记工天
        String accountType = recordMsg.getAccounts_type();
        if (accountType.equals(AccountUtil.HOUR_WORKER)) {
            if (bean.getTpl() == null || bean.getTpl().getW_h_tpl() == 0) {
                return;
            }
        } else if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK)) {
            if (bean.getUnit_quan_tpl() == null || bean.getUnit_quan_tpl().getW_h_tpl() == 0) {
                return;
            }
        }
        setSalaryOrIntent(bean, true, false);
        StringBuilder builder = new StringBuilder();
        builder.append(bean.getReal_name() + "  (");
        builder.append(bean.getTelephone() + ")");
        //点击记账对象弹出的薪资模板弹出框
        final WheelViewBatchAccountSinglePerson peopleSalaryPopWindow = new WheelViewBatchAccountSinglePerson(this, bean, builder.toString());
        peopleSalaryPopWindow.setListener(new WheelViewBatchAccountSinglePerson.SelecteSinglePersonModulListener() {
            @Override
            public void delete(BatchAccountDetail batchAccountDetail) { //点击删除按钮回调
                deleteItem(batchAccountDetail.getRecord_id(), peopleSalaryPopWindow);
            }

            @Override
            public void selectedSinglePersonTime(WorkTime normalTime, WorkTime overTime) { //确定按钮
                Salary chooseTpl = bean.getChoose_tpl();
                clickAccountMember.setUpdateSalary(true); //设置已修改薪资模板的标识
                chooseTpl.setChoose_w_h_tpl(normalTime.getWorkTimes()); //设置已选的上班时长
                chooseTpl.setChoose_o_h_tpl(overTime.getWorkTimes()); //设置已选的加班时长
                submitBatchAccount(false, true);
            }

            @Override
            public void setAccountedSalary(BatchAccountDetail bean) { //设置薪资模板按钮
                setSalaryOrIntent(bean, true, true);
            }
        });
        peopleSalaryPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(MultiPersonBatchAccountNewActivity.this, 0.5F);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SALARYMODESETTING_RESULTCODE) { //设置记账对象薪资模板回调
            if (clickAccountMember != null) {
                Salary settingSalary = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (isAccountedMember) { //已记账的成员由于只有Tpl所以只需要修改TPL,只有已记账的成员才弹出设置薪资模板 弹出框
                    if (clickAccountMember.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER)) {
                        clickAccountMember.setTpl(settingSalary);
                        LUtils.e("tpl:" + settingSalary);
                    } else if (clickAccountMember.getMsg().getAccounts_type().equals(AccountUtil.CONSTRACTOR_CHECK)) {
                        clickAccountMember.setUnit_quan_tpl(settingSalary);
                    }
                    showAlreadyAccountSalary(clickAccountMember);
                } else {
                    clickAccountMember.setSelected(true);
                    if (currentWork.equals(AccountUtil.HOUR_WORKER)) { //点工薪资模板
                        LUtils.e("tplXXX:" + settingSalary);
                        clickAccountMember.setTpl(settingSalary);
                    } else if (currentWork.equals(AccountUtil.CONSTRACTOR_CHECK)) { //包工薪资模板
                        clickAccountMember.setUnit_quan_tpl(settingSalary);
                    }
                    setSubmitBtnState();
                    adapter.notifyDataSetChanged();
                }
            }
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.DISPOSEATTEND_RESULTCODE) { //记单笔成功的回调
            getGroupMembersAccountState(false);
//            finish();
        } else if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER || resultCode == Constance.DELETE_GROUP_MEMBER) { //添加,删除班组成员回调
            getGroupMembersAccountState(true);
        } else if (resultCode == Constance.REMARK_SUCCESS) { //批量记账时，填写的备注信息
            remarkDesc = data.getStringExtra(RemarksActivity.REMARK_DESC);
            remarkImages = (ArrayList<ImageItem>) data.getSerializableExtra(RemarksActivity.PHOTO_DATA);
            if (batchAccountMultiPerson != null) {
                batchAccountMultiPerson.setRemarkDesc(remarkDesc, remarkImages);
            }
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //一人记多天
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        }
    }


    /**
     * 适配器列表数据是否为空
     *
     * @return
     */
    private boolean isEmptyAdpterData() {
        if (adapter == null || adapter.getGroupCount() == 0) {
            return true;
        }
        return false;
    }

    /**
     * 未记账成员是否已设置薪资模板
     *
     * @param batchAccountDetail 检查记账成员是否已设置薪资模板
     * @return
     */
    private boolean isSetSalary(BatchAccountDetail batchAccountDetail) {
        if (currentWork.equals(AccountUtil.HOUR_WORKER)) {
            if (batchAccountDetail.getTpl() != null) {
                return batchAccountDetail.getTpl().getO_h_tpl() == 0 ? false : true;
            }
        } else if (currentWork.equals(AccountUtil.CONSTRACTOR_CHECK)) {
            if (batchAccountDetail.getUnit_quan_tpl() != null) {
                return batchAccountDetail.getUnit_quan_tpl().getO_h_tpl() == 0 ? false : true;
            }
        }
        return false;
    }

    /**
     * 是否已选中了全部的未记账成员
     */
    private boolean isSelecteAllUnAccountObj() {
        if (isEmptyAdpterData()) {
            return false;
        }
        List<BatchAccount> list = adapter.getList();
        for (BatchAccount batchAccount : list) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的成员
                for (BatchAccountDetail unAccountObj : batchAccount.getList()) {
                    if (!unAccountObj.isSelected()) {
                        return false;
                    }
                }
                break;
            }
        }
        return true;
    }

    /**
     * 未记账成员可以添加,由于在添加成员成功后需要刷新数据,所以刷新之前需要获得上次已选中的成员的Uid,将已选中的对象根据uid匹配选中
     * 获取上次选中的成员Uid
     *
     * @return 用户ids  如:11,20,25 逗号隔开
     */
    private String getUnAccountSelecteMemberUids() {
        if (isEmptyAdpterData()) {
            return null;
        }
        List<BatchAccount> list = adapter.getList();
        StringBuilder lastSelecteMemberUids = new StringBuilder();
        for (BatchAccount batchAccount : list) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的成员
                for (BatchAccountDetail detail : batchAccount.getList()) {
                    if (detail.isSelected()) {
                        lastSelecteMemberUids.append(TextUtils.isEmpty(lastSelecteMemberUids.toString()) ? detail.getUid() : "," + detail.getUid());
                    }
                }
                break;
            }
        }
        return lastSelecteMemberUids.toString();
    }

    /**
     * 未记账成员可以添加,由于在添加成员成功后需要刷新数据,所以刷新之前需要获得上次已选中的成员的Uid,将已选中的对象根据uid匹配选中
     * 获取上次选中的成员Uid
     *
     * @return 用户ids  如:11,20,25 逗号隔开
     */
    private String getUnAccountMemberUids() {
        if (isEmptyAdpterData()) {
            return null;
        }
        List<BatchAccount> list = adapter.getList();
        StringBuilder lastSelecteMemberUids = new StringBuilder();
        for (BatchAccount batchAccount : list) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的成员
                for (BatchAccountDetail detail : batchAccount.getList()) {
                    lastSelecteMemberUids.append(TextUtils.isEmpty(lastSelecteMemberUids.toString()) ? detail.getUid() : "," + detail.getUid());
                }
                break;
            }
        }
        return lastSelecteMemberUids.toString();
    }

    /**
     * 设置上次成员已设置的薪资模板
     *
     * @param serverList
     */
    private void setLastSelecteMemberTpls(List<BatchAccount> serverList) {
        String uids = getUnAccountMemberUids();
        if (TextUtils.isEmpty(uids)) {
            return;
        }
        for (BatchAccount batchAccount : serverList) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //只比对未记账的成员,将他们已选的状态记录下来
                for (BatchAccountDetail serverUnAccountObj : batchAccount.getList()) {
                    if (uids.contains(serverUnAccountObj.getUid())) {
                        Salary[] salaries = accordUidFindSalary(serverUnAccountObj.getUid());
                        if (salaries != null && salaries.length == 2) {
                            serverUnAccountObj.setTpl(salaries[0]); //设置点工模板
                            serverUnAccountObj.setUnit_quan_tpl(salaries[1]); //设置薪资模板
                        }
                    }
                }
                break;
            }
        }
    }


    /**
     * 未记账成员可以添加,由于在添加成员成功后需要刷新数据,所以刷新之前需要获得上次已选中的成员的Uid,将已选中的对象根据uid匹配选中,并且将薪资模板也设置成上次记录的状态
     *
     * @param serverList
     */
    private void comparisonLastSelecteMember(List<BatchAccount> serverList) {
        String uids = getUnAccountSelecteMemberUids();
        if (TextUtils.isEmpty(uids)) {
            return;
        }
        for (BatchAccount batchAccount : serverList) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //只比对未记账的成员,将他们已选的状态记录下来
                for (BatchAccountDetail serverUnAccountObj : batchAccount.getList()) {
                    if (uids.contains(serverUnAccountObj.getUid())) {
                        serverUnAccountObj.setSelected(true);
                    }
                }
                break;
            }
        }
    }

    /**
     * 根据uid 找到薪资模板
     *
     * @param uid
     */
    private Salary[] accordUidFindSalary(String uid) {
        if (TextUtils.isEmpty(uid) || isEmptyAdpterData()) {
            return null;
        }
        List<BatchAccount> list = adapter.getList();
        for (BatchAccount batchAccount : list) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的成员
                for (BatchAccountDetail detail : batchAccount.getList()) {
                    if (detail.getUid().equals(uid)) {
                        Salary[] salarys = new Salary[2];
                        salarys[0] = detail.getTpl(); //获取点工模板
                        salarys[1] = detail.getUnit_quan_tpl();//获取包工记工天模块
                        return salarys;
                    }
                }
                break;
            }
        }
        return null;
    }


    /**
     * 全选或取消全选未记账的成员
     * 如果在未记账成员中如果有未设置薪资模板的对象需气泡提示：有工人未设置工资标准
     *
     * @param selecteAllOrCancelAll true:全选,false:取消全选
     */
    private void selecteAllOrCancelAll(boolean selecteAllOrCancelAll) {
        if (isEmptyAdpterData()) {
            return;
        }
        //全选时，如果在未记账成员中如果有未设置薪资模板的对象需气泡提示：有工人未设置工资标准
        if (selecteAllOrCancelAll && !checkUnAccountMemberIsSetSalary()) {
            CommonMethod.makeNoticeShort(getApplicationContext(), currentWork == AccountUtil.HOUR_WORKER ? "有工人未设置点工工资标准，请先给他设置"
                    : "有工人未设置包工记工天模板，请先给他设置", CommonMethod.ERROR);
            return;
        }
        List<BatchAccount> list = adapter.getList();
        for (BatchAccount batchAccount : list) {
            if (batchAccount.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账的成员
                for (BatchAccountDetail unAccountObj : batchAccount.getList()) {
                    if (selecteAllOrCancelAll) { //全选
                        unAccountObj.setSelected(unAccountObj.getIs_double() == 1 ? false : true); //如果已记了两笔点工考勤或者包工记工天 则不允许选中
                    } else {  //取消全选
                        unAccountObj.setSelected(false);
                    }
                }
                break;
            }
        }
        setSubmitBtnState();
    }

    /**
     * 获取未记账成员 已选中的数量
     *
     * @return
     */
    private int getUnAccountSelecteSize() {
        int count = 0;
        if (isEmptyAdpterData()) {
            return count;
        }
        for (BatchAccount bean : adapter.getList()) {
            if (bean.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) {
                for (BatchAccountDetail detail : bean.getList()) {
                    if (detail.isSelected()) {
                        count += 1;
                    }
                }
                break;
            }
        }
        return count;
    }

    /**
     * 未记账的成员是否都已经设置了薪资模板
     *
     * @return
     */
    public boolean checkUnAccountMemberIsSetSalary() {
        if (isEmptyAdpterData()) {
            return false;
        }
        for (BatchAccount bean : adapter.getList()) {
            if (bean.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) {
                for (final BatchAccountDetail unAccountObj : bean.getList()) {
                    if (!isSetSalary(unAccountObj)) {
                        return false;
                    }
                }
                break;
            }
        }
        return true;
    }

    /**
     * 获取批量记账提交的数据
     *
     * @param isSubmitUnAccountPerson 是否提交未记账成员数据 true需要提交，false不需要
     * @param isSubmitAccountPerson   是否提交已记账成员数据 true需要提交，false不需要
     * @return List<String>
     */
    private ArrayList<AccountInfoBean> getBatchAccountSubmitData(boolean isSubmitUnAccountPerson, boolean isSubmitAccountPerson) {
        ArrayList<AccountInfoBean> submitList = new ArrayList<>();
        for (BatchAccount bean : adapter.getList()) {
            for (BatchAccountDetail detail : bean.getList()) {
                if (detail.getMsg() != null && !TextUtils.isEmpty(detail.getMsg().getMsg_text())) { //已在其他项目中记录过点工了 则直接排除不提交此条数据
                    continue;
                }
                if (bean.getType().equals(BatchAccount.UN_ACCOUNT_STRING)) { //未记账对象
                    if (isSubmitUnAccountPerson && detail.isSelected()) {
                        submitList.add(getSubmitAccountPersonInfo(detail, false));
                    }
                } else { //已记账的对象
                    if (isSubmitAccountPerson && detail.isUpdateSalary()) {
                        submitList.add(getSubmitAccountPersonInfo(detail, true));
                    }
                }
            }
        }
        return submitList;
    }

    private AccountInfoBean getSubmitAccountPersonInfo(BatchAccountDetail bean, boolean isUpdateAccountMember) {
        boolean isHourWork = bean.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? true : false;
        Salary tpl = isHourWork ? bean.getTpl() : bean.getUnit_quan_tpl();
        AccountInfoBean accountInfoBean = new AccountInfoBean();
        accountInfoBean.setUid(bean.getUid());
        accountInfoBean.setAccounts_type(bean.getMsg().getAccounts_type());
        accountInfoBean.setDate(submitDate);
        accountInfoBean.setPro_name(proName);
        accountInfoBean.setSalary_tpl(tpl.getS_tpl() + "");
        accountInfoBean.setPid(pid);
        accountInfoBean.setName(bean.getReal_name());
        accountInfoBean.setWork_hour_tpl(tpl.getW_h_tpl() + "");
        accountInfoBean.setOvertime_hour_tpl(tpl.getO_h_tpl() + "");
        accountInfoBean.setWork_time(bean.getChoose_tpl().getChoose_w_h_tpl() + "");
        accountInfoBean.setOver_time(bean.getChoose_tpl().getChoose_o_h_tpl() + "");
        if (isHourWork) { //点工
            double wMoney = tpl.getS_tpl() / tpl.getW_h_tpl() * bean.getChoose_tpl().getChoose_w_h_tpl(); //正常上班计算薪资
            double oMoney = tpl.getS_tpl() / tpl.getO_h_tpl() * bean.getChoose_tpl().getChoose_o_h_tpl(); //加班时常计算薪资
            accountInfoBean.setSalary(Utils.m2(wMoney + oMoney)); //最终记账金额
            if (tpl != null) {
                accountInfoBean.setHour_type(tpl.getHour_type());
                switch (tpl.getHour_type()) {
                    case 0: //按工天算加班
                        break;
                    case 1: //按小时算加班
                        accountInfoBean.setOvertime_salary_tpl(TextUtils.isEmpty(tpl.getOvertime_salary_tpl())?tpl.getO_s_tpl() + "":tpl.getOvertime_salary_tpl());
                        break;
                }
            }
        } else { //包工记工天

        }
        if (isUpdateAccountMember) { //修改已记账对象的薪资模板时需要传递record_id
            accountInfoBean.setRecord_id(bean.getRecord_id());
        }
        return accountInfoBean;
    }


    /***
     * Do not use this method
     * this is for receiving date,
     * use "setOndateClick" instead.
     */
    @Subscribe
    public void onDateClick(Event.OnDateClickEvent event) {
        DateTime selectedDate = event.getDateTime();
        if (!checkForemanIsProxyDate(selectedDate.getYear() + "-" + selectedDate.getMonthOfYear() + "-" + selectedDate.getDayOfMonth())) {
            jumpToLastDate();
            return;
        }
        setDateInfo(selectedDate.getYear(), selectedDate.getMonthOfYear(), selectedDate.getDayOfMonth());
        getGroupMembersAccountState(false);
    }

    /**
     * 跳转到上次选中的日期
     */
    public void jumpToLastDate() {
        DateTime date = new DateTime(customDate.year, customDate.month, customDate.day, 0, 0);
        weekCalendar.setSelectedDate(date);
    }


    /**
     * 获取某天班组成员的记工情况
     *
     * @param isRecordSelecteMemberStatus 是否记录上次已选的未记账成员状态
     */
    public void getGroupMembersAccountState(final boolean isRecordSelecteMemberStatus) {
//        if (adapter != null && !isRecordSelecteMemberStatus) {
//            adapter.setList(null);
//            adapter.notifyDataSetChanged(); //为了保证数据的完整性 每次要先清空数据在请求
//        }
        String httpUrl = NetWorkRequest.WORKDAY_GROUP_MEMBERS_TPL;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pid", pid); //项目id
        params.addBodyParameter("date", submitDate); //当前日期
        String groupId = getIntent().getStringExtra("param4");
        AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser"); //代班长信息
        if (user != null && !TextUtils.isEmpty(user.getUid())) {
            params.addBodyParameter("agency_uid", user.getUid()); //代班长id
        }
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId); //项目组id
        }
        CommonHttpRequest.commonRequest(this, httpUrl, BatchAccount.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<BatchAccount> serverList = (ArrayList<BatchAccount>) object;
                setLastSelecteMemberTpls(serverList); //设置上次已设的薪资模板
                if (isRecordSelecteMemberStatus) { //如果是添加成员导致的数据加载 则需要比对一下上次已选中的成员对象
                    comparisonLastSelecteMember(serverList);
                }
                if (adapter == null) {
                    adapter = new MultiPersonAccountAdapter(getApplicationContext(), serverList);
                    listView.setAdapter(adapter);
                } else {
                    adapter.updateList(serverList);
                }
                expandAll();
                setSubmitBtnState();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
//                finish();
            }
        });
    }

    /**
     * 检查代班长记录时是否在记账时间范围内
     * 如果不是代班长记账则不用检查时间
     *
     * @param clickDate 选择的时间
     */
    private boolean checkForemanIsProxyDate(String clickDate) {
        AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser"); //如果代班长信息不为空需要验证一下时间是否开始时间和结束时间范围内
        if (user == null || TextUtils.isEmpty(user.getUid())) {
            return true;
        }
        String startTime = user.getStart_time(); //代班长记账开始时间
        String endTime = user.getEnd_time(); //代班长记账结束时间
        long clickDateTimeInMillis = DateUtil.getTimeInMillis(clickDate);
        if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) { //代班开始时间结束都不为空
            //如果点击的时间小于开始时间或者点击的时间大于结束时间则进入此判断
            if (clickDateTimeInMillis < DateUtil.getTimeInMillis(startTime) || clickDateTimeInMillis > DateUtil.getTimeInMillis(endTime)) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "代班长只能在" + startTime.replaceAll("-", ".") +
                        "~" + endTime.replaceAll("-", ".") + "时间段内记账", CommonMethod.ERROR);
                return false;
            }
        } else if (!TextUtils.isEmpty(startTime)) {
            if (clickDateTimeInMillis < DateUtil.getTimeInMillis(startTime)) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "代班长不能记录" + startTime.replaceAll("-", ".") + "以前的账", CommonMethod.ERROR);
                return false;
            }
        } else if (!TextUtils.isEmpty(endTime)) {
            if (clickDateTimeInMillis > DateUtil.getTimeInMillis(endTime)) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "代班长不能记录" + endTime.replaceAll("-", ".") + "以后的账", CommonMethod.ERROR);
                return false;
            }
        }
        return true;
    }

    /**
     * 由于用的是二级菜单  直接展开所有的选项
     */
    private void expandAll() {
        int size = adapter.getList().size();
        for (int i = 0; i < size; i++) {
            listView.expandGroup(i);
        }
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> getSelectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<>();
        int size = remarkImages.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = remarkImages.get(i);
            mSelected.add(item.imagePath);
        }
        return mSelected;
    }


    /**
     * 提交批量记账信息
     * 当只修改已记账成员的记账数据时候，在弹出框里面点击确定的时候不需要提交未记账成员的数据
     *
     * @param isSubmitUnAccountPerson 是否提交未记账成员数据 true需要提交，false不需要
     * @param isSubmitAccountPerson   是否提交已记账成员数据 true需要提交，false不需要
     */
    public void submitBatchAccount(boolean isSubmitUnAccountPerson, final boolean isSubmitAccountPerson) {
        final CustomProgress customProgress = new CustomProgress(MultiPersonBatchAccountNewActivity.this);
        customProgress.show(MultiPersonBatchAccountNewActivity.this, null, false);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        ArrayList<AccountInfoBean> paramsList = getBatchAccountSubmitData(isSubmitUnAccountPerson, isSubmitAccountPerson);
        params.addBodyParameter("info", new Gson().toJson(paramsList));
        String groupId = getIntent().getStringExtra("param4");
        AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser"); //代班长信息
        //由于这里可能会需要上传图片，图片压缩过程中 需要动画来屏蔽无效点击
        if (remarkImages != null && remarkImages.size() > 0) {
            RequestParamsToken.compressImageAndUpLoad(params, getSelectedPhotoPath(), MultiPersonBatchAccountNewActivity.this); //设置图片参数
        }
        if (user != null && !TextUtils.isEmpty(user.getUid())) {
            params.addBodyParameter("agency_uid", user.getUid()); //代班长id
        }
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId); //项目组id
        }
        if (!TextUtils.isEmpty(remarkDesc)) {
            params.addBodyParameter("text", remarkDesc); //文本备注
        }
        String httpUrl = NetWorkRequest.WORKDAY_RELEASE;
        CommonHttpRequest.commonRequest(this, httpUrl, BatchAccount.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                CommonMethod.makeNoticeLong(getApplicationContext(), getString(isSubmitAccountPerson ? R.string.hint_bill_date : R.string.hint_bill), CommonMethod.SUCCESS);
                //清空备注信息
                remarkDesc = null;
                remarkImages = null;
                if (null != customProgress && customProgress.isShowing()) {
                    customProgress.closeDialog();
                }
                getGroupMembersAccountState(false); //重新获取数据
                //setResult(Constance.SAVE_BATCH_ACCOUNT);
                //finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                if (null != customProgress && customProgress.isShowing()) {
                    customProgress.closeDialog();
                }
            }
        });
    }

    /**
     * 设置薪资模板对象
     *
     * @param bean                        薪资模板对象
     * @param isAccount                   是否记账
     * @param isIntentToSetSalaryActivity 如果没有设置模板薪资模板时直接跳转到设置薪资模板页面
     */
    private void setSalaryOrIntent(BatchAccountDetail bean, boolean isAccount, boolean isIntentToSetSalaryActivity) {
        clickAccountMember = bean;
        this.isAccountedMember = isAccount;
        if (isIntentToSetSalaryActivity) {
            String accountType;
            if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getAccounts_type())) {
                accountType = bean.getMsg().getAccounts_type();
            } else {
                accountType = currentWork;
            }
            Salary tpl = accountType.equals(AccountUtil.HOUR_WORKER) ? bean.getTpl() : bean.getUnit_quan_tpl();
            // xj AccountUtil.CONSTRACTOR_CHECK_INT  这需要判断是点工还是包工记工天
            SalaryModeSettingActivity.actionStart(this, tpl, bean.getUid(), bean.getReal_name(), UclientApplication.getRoler(getApplicationContext()),
                    getString(accountType.equals(AccountUtil.HOUR_WORKER) ? R.string.set_salary_mode_title : R.string.set_salary_mode_title_check), Integer.parseInt(accountType), true);
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        BusProvider.getInstance().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        BusProvider.getInstance().unregister(this);
    }

    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        if (clickAccountMember == null) {
            return super.onOptionsItemSelected(item);
        }
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //重新开启
                deleteItem(clickAccountMember.getRecord_id(), null);
                break;
        }
        return super.onOptionsItemSelected(item);
    }
}
