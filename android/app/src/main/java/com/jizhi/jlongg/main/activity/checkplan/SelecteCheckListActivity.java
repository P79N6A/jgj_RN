package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.CheckList;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ResizeAnimation;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:选择检查项
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class SelecteCheckListActivity extends BaseActivity {
    /**
     * 添加完成按钮
     */
    private Button addCompleteBtn;
    /**
     * 修改检查项页面的列表数据
     */
    private ArrayList<CheckList> returnList;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId     项目组id
     * @param selectedIds 已选中的检查内容ids ’,’隔开
     */
    public static void actionStart(Activity context, String groupId, String selectedIds, ArrayList<CheckList> list) {
        Intent intent = new Intent(context, SelecteCheckListActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.SELECTED_IDS, selectedIds);
        intent.putExtra(Constance.BEAN_ARRAY, list);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 设置添加完成按钮不可点击
     */
    private void setAddBtnUnClick() {
        addCompleteBtn.setClickable(false);
        Utils.setBackGround(addCompleteBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    /**
     * 添加添加完成按钮可点击
     */
    private void setAddbtnClick() {
        addCompleteBtn.setClickable(true);
        Utils.setBackGround(addCompleteBtn, getResources().getDrawable(R.drawable.draw_eb4e4e_5radius));
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selecte_check_list);
        initView();
        loadData();
    }

    private void initView() {
        returnList = (ArrayList<CheckList>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY);
        setTextTitle(R.string.selecte_check_list);
        addCompleteBtn = getButton(R.id.red_btn);
        addCompleteBtn.setText(R.string.selecte_complete);
        addCompleteBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_ARRAY, returnList);
                setResult(Constance.SELECTED_CALLBACK, intent);
                finish();
            }
        });
        setAddBtnUnClick();
    }

    /**
     * 加载检查内容列表数据
     */
    private void loadData() {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String selectedContentIds = intent.getStringExtra(Constance.SELECTED_IDS);
        CheckListHttpUtils.getCheckList(this, groupId, WebSocketConstance.TEAM, selectedContentIds, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                List<CheckList> list = (List<CheckList>) checkPlan;
                if (list != null && list.size() > 0) {
                    ListView listView = (ListView) findViewById(R.id.listView);
                    listView.setAdapter(new AddCheckContentAdapter(SelecteCheckListActivity.this, list));
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }


    /**
     * CName:添加检查内容适配器
     * User: xuj
     * Date: 2017年11月17日10:16:38
     * Time: 10:01:41
     */
    public class AddCheckContentAdapter extends BaseAdapter {
        /**
         * 上下文
         */
        private Activity activity;
        /**
         * 列表数据
         */
        private List<CheckList> list;
        /**
         * 是否修改了检查项
         */
        private boolean isUpdate;


        public AddCheckContentAdapter(Activity context, List<CheckList> list) {
            this.list = list;
            this.activity = context;
        }

        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public CheckList getItem(int position) {
            return list.get(position);
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(final int position, View convertView, ViewGroup arg2) {
            ViewHolder holder = null;
            if (convertView == null) {
                convertView = LayoutInflater.from(activity).inflate(R.layout.item_selecte_check_content, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, final ViewHolder holder) {
            final CheckList bean = getItem(position);
            holder.checkContent.setText(bean.getPro_name());
            holder.divierLine.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
            holder.selectedIcon.setImageResource(bean.getIs_selected() == 1 ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
            View.OnClickListener onClickListener = new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    switch (view.getId()) {
                        case R.id.selectedIcon:
                            bean.setIs_selected(bean.getIs_selected() == 1 ? 0 : 1);
                            holder.selectedIcon.setImageResource(bean.getIs_selected() == 1 ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                            if (!isUpdate) {
                                isUpdate = true;
                                setAddbtnClick();
                            }
                            synchronized (SelecteCheckContentActivity.class) {
                                if (returnList == null) {
                                    returnList = new ArrayList<>();
                                }
                                if (bean.getIs_selected() == 1) { //选中状态
                                    returnList.add(bean);
                                } else { //取消选中状态
                                    int size = returnList.size();
                                    for (int i = 0; i < size; i++) {
                                        if (returnList.get(i).getPro_id() == bean.getPro_id()) {
                                            returnList.remove(i);
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
                        case R.id.itemLayout: //列表点击事件
                            String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
                            SeeCheckListActivity.actionStart(SelecteCheckListActivity.this, groupId, bean.getPro_id(), true);
                            break;
                    }
                }
            };
            holder.selectedIcon.setOnClickListener(onClickListener);
            convertView.setOnClickListener(onClickListener);
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
                checkContent = (TextView) convertView.findViewById(R.id.checkContent);
                divierLine = convertView.findViewById(R.id.divierLine);
                checkContent.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));
            }

            /**
             * 删除检查内容图标
             */
            ImageView selectedIcon;
            /**
             * 检查内容名称
             */
            TextView checkContent;
            /**
             * 分割线
             */
            View divierLine;
        }
    }


}
