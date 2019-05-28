package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.MsgQualityAndSafeFilterAdapter;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:筛选质量，安全列表页
 * User: hcs
 * Date: 2017-06-01
 * Time: 11:08
 */


public class MsgQualityAndSafeFilterActivity extends BaseActivity {
    private MsgQualityAndSafeFilterActivity mActivity;
    private ListView listView;
    private List<ChatManagerItem> list;
    private MsgQualityAndSafeFilterAdapter adapterList;
    //组信息
    private GroupDiscussionInfo gnInfo;
    public static final int FILTER_STATE = 0X01; //问题状态
    public static final int FILTER_LEVEL = 0X02; //隐患级别
    public static final int FILTER_DATE = 0X03; //提交日期
    public static final int FILTER_DATE_START = 0X04; //提交日期开始
    public static final int FILTER_DATE_END = 0X05;//提交日期结束
    public static final int FILTER_TIME = 0X06; //整改期限
    public static final int FILTER_TIME_START = 0X07; //整改期限开始
    public static final int FILTER_TIME_END = 0X08;//整改期限结束
    public static final int FILTER_CHANGE = 0X09;//及时整改
    public static final int FILTER_PEOPLE = 0X010;//整改负责人
    public static final int FILTER_SUBMIT_PEOPLE = 0X011;//问题提交人
    public static final String VALUE = "name";
    public static final String FILTERBEAN = "filterbean";
    public static final int FINISHFILTE = 0X012;
    public static final int FINISHFILTE_RESET = 0X013;
    //筛选bean
    private QuqlityAndSafeBean quqlityAndSafeBean;
    private int filter_stus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_log_filter);
        initView();
        getIntentData();
        initData();

        findViewById(R.id.rea_bottom).setVisibility(View.VISIBLE);
        findViewById(R.id.btn_save).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(MsgQualityAndSafeFilterActivity.FILTERBEAN, quqlityAndSafeBean);
                intent.putExtras(bundle);
                setResult(MsgQualityAndSafeFilterActivity.FINISHFILTE, intent);
                finish();
            }
        });
        findViewById(R.id.btn_reset).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(MsgQualityAndSafeFilterActivity.FILTERBEAN, null);
                intent.putExtras(bundle);
                setResult(MsgQualityAndSafeFilterActivity.FINISHFILTE, intent);
                finish();
            }
        });

    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = MsgQualityAndSafeFilterActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        SetTitleName.setTitle(findViewById(R.id.title), "筛选记录");
        findViewById(R.id.lin_send).setVisibility(View.GONE);

    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        filter_stus = getIntent().getIntExtra(Constance.FILTER_STATE, 0);

        quqlityAndSafeBean = (QuqlityAndSafeBean) getIntent().getSerializableExtra(Constance.BEAN_STRING);
        if (null != quqlityAndSafeBean) {
            //问题状态
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_state_name())) {

                if (stateBean == null) {
                    stateBean = new ProjectLevel(quqlityAndSafeBean.getFilter_state_name(), quqlityAndSafeBean.getFilter_state());
                } else {
                    stateBean.setName(quqlityAndSafeBean.getFilter_state_name());
                    stateBean.setId(quqlityAndSafeBean.getFilter_state());
                }
                stateBean.setChecked(true);
            }
            //隐患级别
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_level_name())) {
                if (levelBean == null) {
                    levelBean = new ProjectLevel(quqlityAndSafeBean.getFilter_level_name(), quqlityAndSafeBean.getFilter_level());
                } else {
                    levelBean.setName(quqlityAndSafeBean.getFilter_level_name());
                    levelBean.setId(quqlityAndSafeBean.getFilter_level());
                }
                levelBean.setChecked(true);
            }
            //及时整改整改情况
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_change_name())) {
                if (changeBean == null) {
                    changeBean = new ProjectLevel(quqlityAndSafeBean.getFilter_change_name(), quqlityAndSafeBean.getFilter_change());
                } else {
                    changeBean.setName(quqlityAndSafeBean.getFilter_change_name());
                    changeBean.setId(quqlityAndSafeBean.getFilter_change());
                }
                changeBean.setChecked(true);
            }
            //提交日期开始
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_date_start())) {
                time_start_submit = quqlityAndSafeBean.getFilter_date_start();
            }
            //提交日期结束
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_date_end())) {
                time_end_submit = quqlityAndSafeBean.getFilter_date_end();
            }
            //整改日期开始
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_time_start())) {
                time_start_change = quqlityAndSafeBean.getFilter_time_start();
            }
            //整改日期结束
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_time_end())) {
                time_end_change = quqlityAndSafeBean.getFilter_time_end();
            }

            //整改负责人名字uid
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_people_name())) {
                peopleStr = quqlityAndSafeBean.getFilter_people_name();
                people_uid = quqlityAndSafeBean.getFilter_people_name();
            }
            //问题提交人名字uid
            if (!TextUtils.isEmpty(quqlityAndSafeBean.getFilter_submit_people_name())) {
                submitPeopleStr = quqlityAndSafeBean.getFilter_submit_people_name();
                submit_people_uid = quqlityAndSafeBean.getFilter_submit_people_uid();
            }
        } else {
            quqlityAndSafeBean = new QuqlityAndSafeBean();
        }
    }

    private List<ChatManagerItem> getList() {
        LUtils.e("---------Constance.FILTER_STATE-----" + filter_stus);

        // 1、质量-待整改页面、质量-待复查页面进入，去掉“问题状态”选项；
        // 2、质量-我提交的页面进入，去掉“问题提交人”选项；
        // 3、质量-待我整改页面、质量-待我复查页面进入，去掉“问题提交人”、“问题状态”选项；
        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu = new ChatManagerItem("问题状态", true, false, FILTER_STATE);
        ChatManagerItem menu1 = new ChatManagerItem("隐患级别", true, false, FILTER_LEVEL);
        ChatManagerItem menu2 = new ChatManagerItem("提交日期", false, false, FILTER_DATE);
        ChatManagerItem menu3 = new ChatManagerItem("开始", true, false, FILTER_DATE_START);
        ChatManagerItem menu4 = new ChatManagerItem("结束", true, false, FILTER_DATE_END);
        ChatManagerItem menu5 = new ChatManagerItem("整改期限", true, false, FILTER_TIME);
        ChatManagerItem menu6 = new ChatManagerItem("开始", true, false, FILTER_TIME_START);
        ChatManagerItem menu7 = new ChatManagerItem("结束", true, false, FILTER_TIME_END);
        ChatManagerItem menu8 = new ChatManagerItem("整改情况", true, false, FILTER_CHANGE);
        ChatManagerItem menu9 = new ChatManagerItem("整改负责人", true, false, FILTER_PEOPLE);
        ChatManagerItem menu10 = new ChatManagerItem("问题提交人", true, false, FILTER_SUBMIT_PEOPLE);
        if (filter_stus == 1 || filter_stus == 2 || filter_stus == 3 || filter_stus == 4 || filter_stus == 5) {
        } else {
            chatManagerList.add(menu);
        }
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        chatManagerList.add(menu6);
        chatManagerList.add(menu7);
        chatManagerList.add(menu8);
        chatManagerList.add(menu9);
        if (filter_stus == 4 || filter_stus == 5 || filter_stus == 6) {
        } else {
            chatManagerList.add(menu10);
        }
        menu2.setItemType(ChatManagerItem.TEXT_HINT);
        menu5.setItemType(ChatManagerItem.TEXT_HINT);
        if (null != stateBean) {
            menu.setValue(!TextUtils.isEmpty(stateBean.getName()) ? stateBean.getName() : "");
        }
        if (null != levelBean) {
            menu1.setValue(!TextUtils.isEmpty(levelBean.getName()) ? levelBean.getName() : "");
        }
        if (null != changeBean) {
            menu8.setValue(!TextUtils.isEmpty(changeBean.getName()) ? changeBean.getName() : "");
        }
        menu9.setValue(!TextUtils.isEmpty(peopleStr) ? peopleStr : "");
        menu10.setValue(!TextUtils.isEmpty(submitPeopleStr) ? submitPeopleStr : "");
        menu3.setValue(!TextUtils.isEmpty(time_start_submit) ? time_start_submit : "");
        menu4.setValue(!TextUtils.isEmpty(time_end_submit) ? time_end_submit : "");
        menu6.setValue(!TextUtils.isEmpty(time_start_change) ? time_start_change : "");
        menu7.setValue(!TextUtils.isEmpty(time_end_change) ? time_end_change : "");
        menu7.setShowBackGround(true);
        return chatManagerList;
    }
//
//    /**
//     * 启动当前Acitivyt
//     *
//     * @param context
//     */
//    public static void actionStart(Activity context, GroupDiscussionInfo info, int filter_state) {
//        Intent intent = new Intent(context, MsgQualityAndSafeFilterActivity.class);
//        intent.putExtra(Constance.BEAN_CONSTANCE, info);
//        intent.putExtra(Constance.FILTER_STATE, filter_state);
//        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
//    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, int filter_state, QuqlityAndSafeBean filterBean) {
        Intent intent = new Intent(context, MsgQualityAndSafeFilterActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.FILTER_STATE, filter_state);
        intent.putExtra(Constance.BEAN_STRING, filterBean);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    /**
     * 初始化数据
     */
    public void initData() {
        list = getList();
        adapterList = new MsgQualityAndSafeFilterAdapter(mActivity, list, null, false);
        listView.setAdapter(adapterList);
        // listview item click event
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position -= listView.getHeaderViewsCount();
                ChatManagerItem item = (ChatManagerItem) adapterList.getItem(position);
                switch (item.getMenuType()) {
                    case FILTER_STATE:
                        //问题状态
                        List<ProjectLevel> list = DataUtil.getFilterState();
                        ReleaseProjectLevelActivity.actionStart(mActivity, MsgQualityAndSafeFilterActivity.FILTER_STATE, stateBean, list);
                        break;
                    case FILTER_LEVEL:
                        //隐患级别
                        list = DataUtil.getProjectLevel(true);
                        ReleaseProjectLevelActivity.actionStart(mActivity, MsgQualityAndSafeFilterActivity.FILTER_LEVEL, levelBean, list);
                        break;
                    case FILTER_DATE_START:
                        //提交日期开始
                        setTimeSubmitStart();
                        break;
                    case FILTER_DATE_END:
                        //提交日期结束
                        setTimeSubmitEnd();
                        break;
                    case FILTER_TIME_START:
                        //整改期限开始
                        setTimeChangeStart();
                        break;
                    case FILTER_TIME_END:
                        //整改期限结束
                        setTimeChangeEnd();
                        break;
                    case FILTER_CHANGE:
                        //及时整改
                        list = DataUtil.getFilterChange();
                        ReleaseProjectLevelActivity.actionStart(mActivity, MsgQualityAndSafeFilterActivity.FILTER_CHANGE, changeBean, list);
                        break;
                    case FILTER_PEOPLE:
                        //整改负责人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", MsgQualityAndSafeFilterActivity.FILTER_PEOPLE, "选择整改负责人");
                        break;
                    case FILTER_SUBMIT_PEOPLE:
                        //问题提交人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(submit_people_uid) ? submit_people_uid : "", MsgQualityAndSafeFilterActivity.FILTER_SUBMIT_PEOPLE, "选择问题提交人");
                        break;

                }
            }
        });

    }

    //，，整改负责人以及uid，问题提交人以及uid
    private String peopleStr, people_uid, submitPeopleStr, submit_people_uid;
    //提交日期开始，结束，整改日期开始，结束。
    private String time_start_submit, time_end_submit, time_start_change, time_end_change;
    //问题状态，隐患级别及时整改
    private ProjectLevel stateBean, levelBean, changeBean;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_STATE) {
            ///问题状态
            stateBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != stateBean) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_state(stateBean.getId());
                quqlityAndSafeBean.setFilter_state_name(stateBean.getName());
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_LEVEL) {
            //隐患级别
            levelBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != levelBean) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_level(levelBean.getId());
                quqlityAndSafeBean.setFilter_level_name(levelBean.getName());
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_CHANGE) {
            //及时整改
            changeBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            if (null != changeBean) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_change(changeBean.getId());
                quqlityAndSafeBean.setFilter_change_name(changeBean.getName());
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_PEOPLE) {
            //整改负责人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_people_uid(people_uid);
                quqlityAndSafeBean.setFilter_people_name(peopleStr);
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_SUBMIT_PEOPLE) {
            //问题提交
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                submitPeopleStr = data.getStringExtra(VALUE);
                submit_people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_submit_people_uid(submit_people_uid);
                quqlityAndSafeBean.setFilter_submit_people_name(submitPeopleStr);
                setList();
            }
        }
    }

    public void setList() {
        list = getList();
        adapterList = new MsgQualityAndSafeFilterAdapter(mActivity, list, null, false);
        listView.setAdapter(adapterList);
    }

    private RecordAccountDateNotWeekPopWindow popTimeStartSubmit, popTimeEndSubmit, popTimeStartChange, popTimeEndChange;

    public void setTimeSubmitStart() {
        if (null == popTimeStartSubmit) {
            popTimeStartSubmit = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                    String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                    time_start_submit = year + "-" + months + "-" + days;
                    list.get(getPosion(FILTER_DATE_START)).setValue(time_start_submit);
                    adapterList.updateList(list);
                    if (null == quqlityAndSafeBean) {
                        quqlityAndSafeBean = new QuqlityAndSafeBean();
                    }
                    quqlityAndSafeBean.setFilter_date_start(time_start_submit);
                }
            }, 0, 0, 0);
        } else {
            popTimeStartSubmit.update();
        }
        popTimeStartSubmit.showAtLocation(mActivity.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        popTimeStartSubmit.goneRecordDays();
    }

    public void setTimeSubmitEnd() {
        if (TextUtils.isEmpty(time_start_submit)) {
            CommonMethod.makeNoticeShort(mActivity, "请选择提交开始日期", CommonMethod.ERROR);
            return;
        }
        if (null == popTimeEndSubmit) {
            popTimeEndSubmit = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                    String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                    time_end_submit = year + "-" + months + "-" + days;
                    if (!TimesUtils.isBigTime(time_start_submit, time_end_submit)) {
                        CommonMethod.makeNoticeShort(mActivity, "结束时间必须大于开始时间", CommonMethod.ERROR);
                        time_end_submit = "";
                        return;
                    }
                    list.get(getPosion(FILTER_DATE_END)).setValue(time_end_submit);
                    adapterList.updateList(list);
                    if (null == quqlityAndSafeBean) {
                        quqlityAndSafeBean = new QuqlityAndSafeBean();
                    }
                    quqlityAndSafeBean.setFilter_date_end(time_end_submit);
                }
            }, 0, 0, 0);
        } else {
            popTimeEndSubmit.update();
        }
        popTimeEndSubmit.showAtLocation(mActivity.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        popTimeEndSubmit.goneRecordDays();
    }

    public void setTimeChangeStart() {
        if (null == popTimeStartChange) {
            popTimeStartChange = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                    String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                    time_start_change = year + "-" + months + "-" + days;
                    list.get(getPosion(FILTER_TIME_START)).setValue(time_start_change);
                    adapterList.updateList(list);
                    if (null == quqlityAndSafeBean) {
                        quqlityAndSafeBean = new QuqlityAndSafeBean();
                    }
                    quqlityAndSafeBean.setFilter_time_start(time_start_change);
                }
            }, 0, 0, 0);
        } else {
            popTimeStartChange.update();
        }
        popTimeStartChange.showAtLocation(mActivity.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        popTimeStartChange.goneRecordDays();
    }

    public void setTimeChangeEnd() {
        if (TextUtils.isEmpty(time_start_change)) {
            CommonMethod.makeNoticeShort(mActivity, "请选择整改开始日期", CommonMethod.ERROR);
            return;
        }
        if (null == popTimeEndChange) {
            popTimeEndChange = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                    String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                    time_end_change = year + "-" + months + "-" + days;
                    if (!TimesUtils.isBigTime(time_start_change, time_end_change)) {
                        CommonMethod.makeNoticeShort(mActivity, "结束时间必须大于开始时间", CommonMethod.ERROR);
                        time_end_change = "";
                        return;
                    }
                    list.get(getPosion(FILTER_TIME_END)).setValue(time_end_change);
                    adapterList.updateList(list);
                    if (null == quqlityAndSafeBean) {
                        quqlityAndSafeBean = new QuqlityAndSafeBean();
                    }
                    quqlityAndSafeBean.setFilter_time_end(time_end_change);
                }
            }, 0, 0, 0);
        } else {
            popTimeEndChange.update();
        }
        popTimeEndChange.showAtLocation(mActivity.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        popTimeEndChange.goneRecordDays();
    }

    protected int getPosion(int item_type) {
        for (int i = 0; i < list.size(); i++) {
            if (item_type == list.get(i).getMenuType()) {
                return i;
            }
        }
        return 0;

    }
}
