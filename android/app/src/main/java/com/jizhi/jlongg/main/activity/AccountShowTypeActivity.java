package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkBaseInfo;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;

import java.util.ArrayList;

/**
 * 功能:记账显示类型
 * 可选的有 按工天、按工时、上班按工天、加班按小时
 * 时间:2018年6月7日11:31:19
 * 作者:xuj
 */
public class AccountShowTypeActivity extends BaseActivity {


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AccountShowTypeActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        setTextTitle(R.string.account_show_type);
        //获取当前选择的记账类型
        //以小时为单位 ==1
        //以工为单位 ==2
        //上班按工天，加班按小时”“按工天 ==3
        final int selectePosition = AccountUtil.getDefaultAccountUnit(getApplicationContext());
        final ArrayList<WorkBaseInfo> list = getData();
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(new BaseAdapter() {
            @Override
            public int getCount() {
                return list == null || list.size() == 0 ? 0 : list.size();
            }

            @Override
            public WorkBaseInfo getItem(int position) {
                return list.get(position);
            }

            @Override
            public long getItemId(int position) {
                return position;
            }

            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                final ViewHolder holder;
                if (convertView == null) {
                    convertView = getLayoutInflater().inflate(R.layout.account_show_way_item, null);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                holder.firstTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
                holder.selecetdIcon.setVisibility(selectePosition == getItem(position).getAccount_unit_show_type() ? View.VISIBLE : View.GONE);
                holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
                holder.accountType.setText(getItem(position).getAccount_unit_show_string());
                return convertView;
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (list.get(position).getAccount_unit_show_type() == selectePosition) {
                    finish();
                    return;
                }
                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                AccountUtil.setDefaultAccountUnit(getApplicationContext(), list.get(position).getAccount_unit_show_type());
                setResult(Constance.CHANGE_ACCOUNT_SHOW_TYPE);
                finish();
            }
        });
    }


    private ArrayList<WorkBaseInfo> getData() {
        WorkBaseInfo workBaseInfo1 = new WorkBaseInfo();
        workBaseInfo1.setAccount_unit_show_string("上班按工天、加班按小时");
        workBaseInfo1.setAccount_unit_show_type(AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR);

        WorkBaseInfo workBaseInfo2 = new WorkBaseInfo();
        workBaseInfo2.setAccount_unit_show_string("上班、加班按工天");
        workBaseInfo2.setAccount_unit_show_type(AccountUtil.WORK_AS_UNIT);

        WorkBaseInfo workBaseInfo3 = new WorkBaseInfo();
        workBaseInfo3.setAccount_unit_show_string("上班、加班按小时");
        workBaseInfo3.setAccount_unit_show_type(AccountUtil.WORK_OF_HOUR);

        ArrayList<WorkBaseInfo> list = new ArrayList<>();

        list.add(workBaseInfo1);
        list.add(workBaseInfo2);
        list.add(workBaseInfo3);
        return list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            itemDiver = convertView.findViewById(R.id.itemDiver);
            accountType = (TextView) convertView.findViewById(R.id.accountType);
            selecetdIcon = (ImageView) convertView.findViewById(R.id.selecetdIcon);
            firstTips = convertView.findViewById(R.id.firstTips);
        }

        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 注销原因
         */
        TextView accountType;
        /**
         * 选择状态
         */
        ImageView selecetdIcon;
        /**
         * 首条提示语
         */
        View firstTips;
    }

}
