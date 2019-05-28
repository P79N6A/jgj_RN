package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountDetailActivity;
import com.jizhi.jlongg.main.adpter.RecordWorkConfirmThisTimeAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RecordWorkConfirmMonth;
import com.jizhi.jlongg.main.util.Constance;

import java.util.ArrayList;

/**
 * 功能:待确认记工记录-->本次已确认的
 * 时间:2017年9月28日11:24:51
 * 作者:xuj
 */
public class RecordWorkConfirmThisTimeActivity extends BaseActivity {


    /**
     * 启动当前Activity
     *
     * @param list    本次已确认的列表数据
     * @param context
     */
    public static void actionStart(Activity context, ArrayList<RecordWorkConfirmMonth> list) {
        Intent intent = new Intent(context, RecordWorkConfirmThisTimeActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, list);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_default);
        init();
    }

    private void init() {
        setTextTitle(R.string.confirm_count);
        getTextView(R.id.defaultDesc).setText("暂无本次已确认的记工记账\n上次确认的记工，请前往记工流水查看");
        ArrayList<RecordWorkConfirmMonth> list = (ArrayList<RecordWorkConfirmMonth>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY);
        bubbleSort01(list);
        setAdapter(list);
    }

    private void setAdapter(final ArrayList<RecordWorkConfirmMonth> list) {
        final RecordWorkConfirmThisTimeAdapter adapter = new RecordWorkConfirmThisTimeAdapter(RecordWorkConfirmThisTimeActivity.this, list);
        ListView listView = findViewById(R.id.listView);
        listView.setDivider(null);
        listView.setEmptyView(findViewById(R.id.defaultLayout));
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final String accountType = adapter.getItem(position).getAccounts_type();
                if (TextUtils.isEmpty(accountType)) { //记账类型为空
                    return;
                }
                AccountDetailActivity.actionStart(RecordWorkConfirmThisTimeActivity.this, accountType,
                        Integer.parseInt(adapter.getItem(position).getId()), UclientApplication.getRoler(getApplicationContext()), false);
            }
        });
    }

    /**
     * 冒泡法排序
     * 比较相邻的元素。如果第一个比第二个小，就交换他们两个。
     * 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最小的数。
     * 针对所有的元素重复以上的步骤，除了最后一个。
     * 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。
     *
     * @param list 需要排序的整型数组
     */
    public void bubbleSort01(ArrayList<RecordWorkConfirmMonth> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        RecordWorkConfirmMonth temp; // 记录临时中间值
        int size = list.size(); // 数组大小
        for (int i = 0; i < size - 1; i++) {
            for (int j = i + 1; j < size; j++) {
                if (list.get(i).getDate_strtotime() < list.get(j).getDate_strtotime()) { // 交换两数的位置
                    temp = list.get(i);
                    list.set(i, list.get(j));
                    list.set(j, temp);
                }
            }
        }
    }
}
