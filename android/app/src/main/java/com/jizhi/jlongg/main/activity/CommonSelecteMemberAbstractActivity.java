package com.jizhi.jlongg.main.activity;

import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;

import java.util.ArrayList;
import java.util.List;

public abstract class CommonSelecteMemberAbstractActivity extends BaseActivity {


    /**
     * 成员列表数据
     */
    public List<GroupMemberInfo> memberInfoList;
    /**
     * 列表适配器
     */
//    public CommonSelecteMemberBaseAdapter adapter;
    public CommonPersonListAdapter adapter;
    /**
     * 搜索框输入的文字
     */
    public String matchString;


    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString 搜索的文本
     */
    public void filterData(final String mMatchString) {
        synchronized (CommonSelecteMemberAbstractActivity.class) {
            if (adapter == null || memberInfoList == null || memberInfoList.size() == 0) {
                return;
            }
            matchString = mMatchString;
            new Thread(new Runnable() {
                @Override
                public void run() {
                    final ArrayList<GroupMemberInfo> filterDataList = (ArrayList<GroupMemberInfo>) SearchMatchingUtil.match(GroupMemberInfo.class,
                            memberInfoList, matchString);
                    if (mMatchString.equals(matchString)) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                adapter.setFilterValue(mMatchString);
                                adapter.updateListView(filterDataList);
                            }
                        });
                    }
                }
            }).start();
        }
    }


}
