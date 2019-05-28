package com.jizhi.jlongg.main.activity.log;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjecPeopleActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndSafeFilterAdapter;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:筛选质量，安全计划页
 * User: hcs
 * Date: 2017-06-01
 * Time: 11:08
 */


public class MsgLogFilterActivity extends BaseActivity {
    private MsgLogFilterActivity mActivity;
    private ListView listView;
    private List<ChatManagerItem> list;
    private MsgQualityAndSafeFilterAdapter adapterList;
    //组信息
    private GroupDiscussionInfo gnInfo;
    public static final int FILTER_STATE = 0X01; //检查状态
    public static final int FILTER_DATE = 0X02; //检查计划添加日期
    public static final int FILTER_DATE_START = 0X03; //检查计划添加日期开始
    public static final int FILTER_DATE_END = 0X04;//检查计划添加日期结束
    public static final int FILTER_PEOPLE = 0X55;//提交人
    public static final String VALUE = "name";
    public static final String FILTERBEAN = "filterbean";
    public static final int FINISHFILTE = 0X012;
    public static final int FINISHFILTE_RESET = 0X013;
    //筛选bean
    private LogGroupBean logGroupBeanFilter;
    //模版数据
    private List<LogGroupBean> approvalcatlist;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_log_filter);
        initView();
        getIntentData();
        getapprovalCatList();
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = MsgLogFilterActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        SetTitleName.setTitle(findViewById(R.id.title), "筛选记录");

        findViewById(R.id.btn_save).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == logGroupBeanFilter) {
                    logGroupBeanFilter = new LogGroupBean();
                }
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(MsgLogFilterActivity.FILTERBEAN, logGroupBeanFilter);
                intent.putExtras(bundle);
                setResult(MsgLogFilterActivity.FINISHFILTE, intent);
                finish();
            }
        });
        findViewById(R.id.btn_reset).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(MsgLogFilterActivity.FILTERBEAN, new LogGroupBean());
                intent.putExtras(bundle);
                setResult(MsgLogFilterActivity.FINISHFILTE_RESET, intent);
                finish();
            }
        });

    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        logGroupBeanFilter = (LogGroupBean) getIntent().getSerializableExtra(Constance.BEAN_STRING);
        stateBean = new LogGroupBean();
        if (null != logGroupBeanFilter) {
            //初始化日志类型，开始时间，结束时间
            stateBean.setCat_name(logGroupBeanFilter.getCat_name());
            stateBean.setCat_id(logGroupBeanFilter.getCat_id());
            time_start_submit = (null == logGroupBeanFilter.getSend_stime()) ? "" : logGroupBeanFilter.getSend_stime();
            time_end_submit = (null == logGroupBeanFilter.getSend_etime()) ? "" : logGroupBeanFilter.getSend_etime();
            if (!TextUtils.isEmpty(logGroupBeanFilter.getName())) {
                peopleStr = logGroupBeanFilter.getName();
                people_uid = logGroupBeanFilter.getUid();
            }
        }
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, LogGroupBean logGroupBeanFilter,int type) {
        Intent intent = new Intent(context, MsgLogFilterActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_STRING, logGroupBeanFilter);
        intent.putExtra(Constance.BEAN_INT, type);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取日志模版信息
     */
    protected void getapprovalCatList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("os", "A");
        params.addBodyParameter("ver", AppUtils.getVersionName(mActivity));
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("type", gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? "log" : "grouplog");
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_APPOVALCSTLIST,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<LogGroupBean> bean = CommonListJson.fromJson(responseInfo.result, LogGroupBean.class);
                                if (bean.getState() != 0) {
                                    approvalcatlist = bean.getValues();
                                    initData();
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                closeDialog();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            closeDialog();
                        }
                    });


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
                        FilterLogTypeActivity.actionStart(mActivity, stateBean, approvalcatlist);
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
                        if (getIntent().getIntExtra(Constance.BEAN_INT, 1) != 2) {
                            //提交人
                            ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", MsgLogFilterActivity.FILTER_PEOPLE, " 选择提交人");
                        }
                        break;

                }
            }
        });

    }

    //整改负责人以及uid，问题提交人以及uid
    private String peopleStr, people_uid;
    //    submitPeopleStr, submit_people_uid;
    //提交日期开始，结束
    private String time_start_submit, time_end_submit;
    //检查状态
    private LogGroupBean stateBean;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constance.REQUEST && resultCode == MsgLogFilterActivity.FILTER_STATE) {
            ///问题状态
            stateBean = (LogGroupBean) data.getSerializableExtra(VALUE);
            if (null != stateBean) {
                if (null == logGroupBeanFilter) {
                    logGroupBeanFilter = new LogGroupBean();
                }
                logGroupBeanFilter.setCat_id(stateBean.getCat_id());
                logGroupBeanFilter.setCat_name(stateBean.getCat_name());
                setList();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == MsgLogFilterActivity.FILTER_PEOPLE) {
            //检查执行人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                if (null == logGroupBeanFilter) {
                    logGroupBeanFilter = new LogGroupBean();
                }
                logGroupBeanFilter.setUid(people_uid);
                logGroupBeanFilter.setName(peopleStr);
                setList();
            }
        }
    }

    public void setList() {
        list = getList();
        adapterList = new MsgQualityAndSafeFilterAdapter(mActivity, list, null, true);
        listView.setAdapter(adapterList);
    }

    private List<ChatManagerItem> getList() {

        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu = new ChatManagerItem("日志类型", true, false, FILTER_STATE);
        ChatManagerItem menu1 = new ChatManagerItem("日期", false, false, FILTER_DATE);
        ChatManagerItem menu2 = new ChatManagerItem("开始日期", true, false, FILTER_DATE_START);
        ChatManagerItem menu3 = new ChatManagerItem("结束日期", true, false, FILTER_DATE_END);

        chatManagerList.add(menu);
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
//        if (getIntent().getIntExtra(Constance.BEAN_INT, 1) != 2) {
        ChatManagerItem menu4 = new ChatManagerItem("提交人", true, false, FILTER_PEOPLE);
        chatManagerList.add(menu4);
        menu4.setValue(!TextUtils.isEmpty(peopleStr) ? peopleStr : "");
//        }
        menu1.setItemType(ChatManagerItem.TEXT_HINT);
        if (null != logGroupBeanFilter) {
            menu.setValue(!TextUtils.isEmpty(logGroupBeanFilter.getCat_name()) ? logGroupBeanFilter.getCat_name() : "");
        }
        menu2.setValue(!TextUtils.isEmpty(time_start_submit) ? time_start_submit : "");
        menu3.setValue(!TextUtils.isEmpty(time_end_submit) ? time_end_submit : "");
        menu3.setShowBackGround(true);

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
                    if (!TextUtils.isEmpty(time_end_submit) && !TimesUtils.isBigTime(time_start_submit, time_end_submit)) {
                        CommonMethod.makeNoticeShort(mActivity, "开始时间不能大于结束时间", CommonMethod.ERROR);
                        time_start_submit = "";
                        return;
                    }
                    list.get(2).setValue(time_start_submit);
                    adapterList.updateList(list);
                    if (null == logGroupBeanFilter) {
                        logGroupBeanFilter = new LogGroupBean();
                    }
                    logGroupBeanFilter.setSend_stime(time_start_submit);
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
                        time_end_submit = "";
                        return;
                    }
                    list.get(3).setValue(time_end_submit);
                    adapterList.updateList(list);
                    if (null == logGroupBeanFilter) {
                        logGroupBeanFilter = new LogGroupBean();
                    }
                    logGroupBeanFilter.setSend_etime(time_end_submit);
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
