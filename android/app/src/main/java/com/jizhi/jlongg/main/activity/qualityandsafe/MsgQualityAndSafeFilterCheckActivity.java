package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjecPeopleActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjectLevelActivity;
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
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:筛选质量，安全计划页
 * User: hcs
 * Date: 2017-06-01
 * Time: 11:08
 */


public class MsgQualityAndSafeFilterCheckActivity extends BaseActivity {
    private MsgQualityAndSafeFilterCheckActivity mActivity;
    private ListView listView;
    private List<ChatManagerItem> list;
    private MsgQualityAndSafeFilterAdapter adapterList;
    //组信息
    private GroupDiscussionInfo gnInfo;
    public static final int FILTER_STATE = 0X01; //检查状态
    public static final int FILTER_DATE = 0X02; //检查计划添加日期
    public static final int FILTER_DATE_START = 0X03; //检查计划添加日期开始
    public static final int FILTER_DATE_END = 0X04;//检查计划添加日期结束
    public static final int FILTER_PEOPLE = 0X55;//检查执行人
    public static final int FILTER_SUBMIT_PEOPLE = 0X66;//检查计划提交人
    public static final String VALUE = "name";
    public static final String FILTERBEAN = "filterbean";
    public static final int FINISHFILTE = 0X012;
    //筛选bean
    private QuqlityAndSafeBean quqlityAndSafeBean;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_releasequaandsafe);
        initView();
        initData();
        getIntentData();
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(MsgQualityAndSafeFilterCheckActivity.FILTERBEAN, quqlityAndSafeBean);
                intent.putExtras(bundle);
                setResult(MsgQualityAndSafeFilterCheckActivity.FINISHFILTE, intent);
                finish();
            }
        });
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = MsgQualityAndSafeFilterCheckActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        SetTitleName.setTitle(findViewById(R.id.title), "筛选记录");
        SetTitleName.setTitle(findViewById(R.id.right_title), "确定");
        findViewById(R.id.lin_send).setVisibility(View.GONE);

    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, MsgQualityAndSafeFilterCheckActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 初始化数据
     */
    public void initData() {
        list = getList();
        adapterList = new MsgQualityAndSafeFilterAdapter(mActivity, list, null, true);
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
                        List<ProjectLevel> list = DataUtil.getFilteCheck();
                        ReleaseProjectLevelActivity.actionStarts(mActivity, MsgQualityAndSafeFilterCheckActivity.FILTER_STATE, stateBean, list, "选择检查状态");
                        break;
                    case FILTER_DATE_START:
                        //提交日期开始
                        setTimeSubmitStart();
                        break;
                    case FILTER_DATE_END:
                        //提交日期结束
                        setTimeSubmitEnd();
                        break;
                    case FILTER_PEOPLE:
                        //检查执行人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", MsgQualityAndSafeFilterCheckActivity.FILTER_PEOPLE, " 选择检查执行人");
                        break;
                    case FILTER_SUBMIT_PEOPLE:
                        //检查计划提交人
                        ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(submit_people_uid) ? submit_people_uid : "", MsgQualityAndSafeFilterCheckActivity.FILTER_SUBMIT_PEOPLE, "选择检查计划提交人");
                        break;

                }
            }
        });

    }

    //整改负责人以及uid，问题提交人以及uid
    private String peopleStr, people_uid, submitPeopleStr, submit_people_uid;
    //提交日期开始，结束
    private String time_start_submit, time_end_submit;
    //检查状态
    private ProjectLevel stateBean;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        LUtils.e(requestCode + "------onActivityResult---------" + resultCode);
        LUtils.e(Constance.REQUEST + "------onActivityResult---------" + MsgQualityAndSafeFilterCheckActivity.FILTER_STATE);
        if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterCheckActivity.FILTER_STATE) {
            ///问题状态
            stateBean = (ProjectLevel) data.getSerializableExtra(VALUE);
            LUtils.e("-------------qq-----" );
            if (null != stateBean) {
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_state(stateBean.getId());
                LUtils.e("-------------state-----" + new Gson().toJson(quqlityAndSafeBean));
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterCheckActivity.FILTER_PEOPLE) {
            //检查执行人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_people_uid(people_uid);
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterCheckActivity.FILTER_SUBMIT_PEOPLE) {
            //检查计划提交人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                submitPeopleStr = data.getStringExtra(VALUE);
                submit_people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                if (null == quqlityAndSafeBean) {
                    quqlityAndSafeBean = new QuqlityAndSafeBean();
                }
                quqlityAndSafeBean.setFilter_submit_people_uid(submit_people_uid);
                setList();
            }
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }

    public void setList() {
        list = getList();
        adapterList = new MsgQualityAndSafeFilterAdapter(mActivity, list, null, true);
        listView.setAdapter(adapterList);
    }

    private List<ChatManagerItem> getList() {

        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu = new ChatManagerItem("检查状态", true, false, FILTER_STATE);
        ChatManagerItem menu1 = new ChatManagerItem("检查计划添加日期", false, false, FILTER_DATE);
        ChatManagerItem menu2 = new ChatManagerItem("开始", true, false, FILTER_DATE_START);
        ChatManagerItem menu3 = new ChatManagerItem("结束", true, false, FILTER_DATE_END);
        ChatManagerItem menu4 = new ChatManagerItem("检查执行人", true, false, FILTER_PEOPLE);
        ChatManagerItem menu5 = new ChatManagerItem("检查计划提交人", true, false, FILTER_SUBMIT_PEOPLE);
        chatManagerList.add(menu);
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        menu1.setItemType(ChatManagerItem.TEXT_HINT);
        if (null != stateBean) {
            menu.setValue(!TextUtils.isEmpty(stateBean.getName()) ? stateBean.getName() : "");
        }
        menu2.setValue(!TextUtils.isEmpty(time_start_submit) ? time_start_submit : "");
        menu3.setValue(!TextUtils.isEmpty(time_end_submit) ? time_end_submit : "");
        menu3.setShowBackGround(true);
        menu4.setValue(!TextUtils.isEmpty(peopleStr) ? peopleStr : "");
        menu5.setValue(!TextUtils.isEmpty(submitPeopleStr) ? submitPeopleStr : "");
        return chatManagerList;
    }

    private RecordAccountDateNotWeekPopWindow popTimeStartSubmit, popTimeEndSubmit;

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
                    list.get(2).setValue(time_start_submit);
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
            CommonMethod.makeNoticeShort(mActivity, "请选择开始日期", CommonMethod.ERROR);
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
                        return;
                    }
                    list.get(3).setValue(time_end_submit);
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

}
