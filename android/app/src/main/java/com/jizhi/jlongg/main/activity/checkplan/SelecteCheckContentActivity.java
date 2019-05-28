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

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:检查项里面选择检查内容
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class SelecteCheckContentActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 添加完成按钮
     */
    private Button addCompleteBtn;
    /**
     * 修改检查项页面的列表数据
     */
    private ArrayList<CheckContent> returnList;
    /**
     * 列表适配器
     */
    private AddCheckContentAdapter adapter;
    /**
     * 默认页
     */
    private View defaultLayout;
    /**
     * 新建按钮
     */
    private TextView newBtn;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId     项目组id
     * @param selectedIds 已选中的检查内容ids ’,’隔开
     * @param list        修改检查项页面的列表数据
     */
    public static void actionStart(Activity context, String groupId, String selectedIds, ArrayList<CheckContent> list) {
        Intent intent = new Intent(context, SelecteCheckContentActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.SELECTED_IDS, selectedIds);
        intent.putExtra(Constance.BEAN_ARRAY, list);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

//    /**
//     * 比对之前选中的状态是否发生了变化
//     */
//    private boolean checkContentSelecteStateIsChange() {
//        List<CheckContent> mTempList = adapter.getList();
//        if (mTempList != null && mTempList.size() > 0) {
//            String selectedContentIds = getIntent().getStringExtra(Constance.SELECTED_IDS);
//            StringBuilder selecteBuilds = new StringBuilder();
//            for (CheckContent checkContent : mTempList) {
//                if (checkContent.getIs_selected() == 1) {
//                    selecteBuilds.append(TextUtils.isEmpty(selecteBuilds.toString()) ? checkContent.getContent_id() : "," + checkContent.getContent_id());
//                }
//            }
//            if (TextUtils.isEmpty(selectedContentIds)) {
//                if (TextUtils.isEmpty(selecteBuilds.toString())) {
//                    return false;
//                } else {
//                    return true;
//                }
//            } else {
//                return !selecteBuilds.toString().equals(selectedContentIds);
//            }
//        }
//        return false;
//    }


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
        setContentView(R.layout.selecte_check_content);
        initView();
        loadData();
    }

    private void initView() {
        returnList = (ArrayList<CheckContent>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY);
        setTextTitleAndRight(R.string.selecte_check_content, R.string.create);
        newBtn = getTextView(R.id.right_title);
        defaultLayout = findViewById(R.id.defaultLayout);
        addCompleteBtn = getButton(R.id.red_btn);
        addCompleteBtn.setText(R.string.selecte_complete);
        addCompleteBtn.setOnClickListener(this);

        TextView createBtn = getTextView(R.id.createBtn);
        createBtn.setText(R.string.create_check_content);
        getTextView(R.id.defaultDesc).setText(R.string.no_check_content);

        createBtn.setOnClickListener(this);
        findViewById(R.id.viewHelp).setOnClickListener(this);
        setAddBtnUnClick();
    }

    /**
     * 加载检查内容列表数据
     */
    private void loadData() {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String selectedContentIds = intent.getStringExtra(Constance.SELECTED_IDS);
        CheckListHttpUtils.getCheckListContentList(this, groupId, WebSocketConstance.TEAM, selectedContentIds, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                ArrayList<CheckContent> list = (ArrayList<CheckContent>) checkPlan;
                adapter = new AddCheckContentAdapter(SelecteCheckContentActivity.this, list);
                ListView listView = (ListView) findViewById(R.id.listView);
                listView.setAdapter(adapter);
                if (list != null && list.size() > 0) {
                    defaultLayout.setVisibility(View.GONE);
                    newBtn.setVisibility(View.VISIBLE);
                } else {
                    defaultLayout.setVisibility(View.VISIBLE);
                    newBtn.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.red_btn: //添加完成按钮
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_ARRAY, returnList);
                setResult(Constance.SELECTED_CALLBACK, intent);
                finish();
                break;
            case R.id.createBtn://新建检查内容
            case R.id.right_title:
                NewOrUpdateCheckContentActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID), -1, NewOrUpdateCheckContentActivity.CREATE_CHECK);
                break;
            case R.id.viewHelp: //查看帮助
                HelpCenterUtil.actionStartHelpActivity(this, 182);
                break;
        }
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
        private List<CheckContent> list;
        /**
         * 是否修改了检查内容
         */
        private boolean isUpdate;


        public AddCheckContentAdapter(Activity context, ArrayList<CheckContent> list) {
            this.list = list;
            this.activity = context;
        }

        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public CheckContent getItem(int position) {
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
            final CheckContent bean = getItem(position);
            holder.checkContent.setText(bean.getContent_name());
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
                                        if (returnList.get(i).getContent_id() == bean.getContent_id()) {
                                            returnList.remove(i);
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
                        case R.id.itemLayout: //列表点击事件
                            SeeCheckPointActivity.actionStart(SelecteCheckContentActivity.this, bean.getDot_list(), bean.getContent_name());
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

        public List<CheckContent> getList() {
            return list;
        }

        public void setList(List<CheckContent> list) {
            this.list = list;
        }


        public void addList(CheckContent checkContent) {
            if (list == null) {
                list = new ArrayList<>();
            }
            list.add(0, checkContent);
            notifyDataSetChanged();
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT) { //新建了检查内容
            CheckContent checkContent = (CheckContent) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (checkContent != null) {
                checkContent.setIs_selected(1); //设置已选中的状态
                if (returnList == null) {
                    returnList = new ArrayList<>();
                }
                returnList.add(checkContent);
                adapter.addList(checkContent);
                setAddbtnClick();
                defaultLayout.setVisibility(View.GONE);
                newBtn.setVisibility(View.VISIBLE);
            }
        }
    }


}
