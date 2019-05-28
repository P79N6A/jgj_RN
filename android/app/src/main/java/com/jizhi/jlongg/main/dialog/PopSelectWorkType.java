package com.jizhi.jlongg.main.dialog;

import android.app.ActionBar;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoDB;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.adpter.ListViewOneRawMultiselectAdapter;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

/**
 * 功能:工种选择
 * 时间:2016-4-27 10:55
 * 作者:xuj
 */
public class PopSelectWorkType extends PopupWindow implements AdapterView.OnItemClickListener {

    private Context context;
    /**
     * listView
     */
    private ListView lv_workType;
    /**
     * 省市数据
     */
    private List<WorkType> workTypeList;
    /**
     * 适配器
     */
    private ListViewOneRawMultiselectAdapter adapter;
    /**
     * 回调接口
     */
    private WorkTypeItemClickListerer listener;
    /**
     * 最后一次选择的下标
     */
    private int lastSelected = -1;

    public PopSelectWorkType(Context context, WorkTypeItemClickListerer WorkTypeItemClickListerer, String workName, boolean isShowMyWork) {
        super(context);
        this.context = context;
        this.listener = WorkTypeItemClickListerer;
        initpopupwindow();
        initData(workName, isShowMyWork);
    }

    /**
     * 初始化 popupwindow
     */
    public View initpopupwindow() {
        View view = LayoutInflater.from(context).inflate(R.layout.type_of_work_listview, null);
        setContentView(view);
        setWidth(ActionBar.LayoutParams.MATCH_PARENT);
        setHeight(ActionBar.LayoutParams.MATCH_PARENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0x00);
        setBackgroundDrawable(dw);
        lv_workType = (ListView) view.findViewById(R.id.listView);
        return view;
    }

    /**
     * 初始化数据
     */
    private void initData(String workName, boolean isShowMyWork) {
        BaseInfoService baseInfoService = BaseInfoService.getInstance(context.getApplicationContext());
        workTypeList = baseInfoService.selectInfo(BaseInfoDB.jlg_work_type);
        if (isShowMyWork) {
            workTypeList.add(0, new WorkType("0", "我的工种"));
        }
        workTypeList.add(0, new WorkType("-1", "全部工种"));
        if (!TextUtils.isEmpty(workName)) {
            int size = workTypeList.size();
            for (int i = 0; i < size; i++) {
                WorkType type = workTypeList.get(i);
                if (type.getWorkName().equals(workName)) {
                    type.setIsSelected(true);
                    lastSelected = i;
                    break;
                }
            }
        }
        adapter = new ListViewOneRawMultiselectAdapter(context, workTypeList);
        lv_workType.setAdapter(adapter);
        lv_workType.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (position == lastSelected) {
            dismiss();
            return;
        }
        WorkType type = workTypeList.get(position);
        type.setIsSelected(!type.isSelected());
        if (listener != null) {
            StringBuffer sb = new StringBuffer();
            sb.append(workTypeList.get(position).getWorktype());
            listener.WorktypeItemClick(workTypeList.get(position).getWorkName(), sb.toString());
            if (lastSelected != -1) {
                workTypeList.get(lastSelected).setIsSelected(false);
            }
            adapter.notifyDataSetChanged();
            lastSelected = position;
            dismiss();
        }
    }

    public interface WorkTypeItemClickListerer {
        void WorktypeItemClick(String WorkName, String id);
    }
}
