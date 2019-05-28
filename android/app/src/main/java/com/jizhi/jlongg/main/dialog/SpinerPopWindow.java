package com.jizhi.jlongg.main.dialog;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ProjectSpinerAdapter;
import com.jizhi.jlongg.main.bean.Project;

import java.util.List;

public class SpinerPopWindow extends PopupWindow implements AdapterView.OnItemClickListener {

    private Context context;
    /**
     * adapter
     */
    private ProjectSpinerAdapter adapter;
    /**
     * 选择项目项目
     */
    private SelectReturnListener listener;
    /**
     * 列表数据
     */
    private List<Project> list;

    private int selectedPosition = -1;


    public SpinerPopWindow(Context context, List<Project> list, SelectReturnListener listener, String projectName) {
        super(context);
        this.context = context;
        this.list = list;
        this.listener = listener;
        init(projectName);
    }


    private void init(String projectName) {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            Project pro = list.get(i);
            if (pro.getPro_name().equals(projectName)) {
                list.get(i).setIsSelected(true);
                selectedPosition = i;
                break;
            }
        }
        View view = LayoutInflater.from(context).inflate(R.layout.spiner_window_layout, null);
        setContentView(view);
        setWidth(LayoutParams.WRAP_CONTENT);
        setHeight(LayoutParams.WRAP_CONTENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0x00);
        setBackgroundDrawable(dw);
        ListView mListView = (ListView) view.findViewById(R.id.listview);
        mListView.setOnItemClickListener(this);
        if (adapter == null) {
            adapter = new ProjectSpinerAdapter(context, list);
            mListView.setAdapter(adapter);
        }
    }


    public void setList(List<Project> list, String projectName) {
        this.list = list;
        selectedPosition = -1;
        if (adapter != null) {
            int size = list.size();
            for (int i = 0; i < size; i++) {
                Project pro = list.get(i);
                if (pro.getPro_name().equals(projectName)) {
                    list.get(i).setIsSelected(true);
                    selectedPosition = i;
                    break;
                }
            }
            adapter.setList(list);
            adapter.notifyDataSetChanged();
        }
    }


    @Override
    public void onItemClick(AdapterView<?> arg0, View view, int pos, long arg3) {
        if (listener != null) {
            if (selectedPosition != -1) {
                if (selectedPosition == pos) {
                    dismiss();
                    return;
                }
                list.get(selectedPosition).setIsSelected(false);
            }
            list.get(pos).setIsSelected(true);
            adapter.notifyDataSetChanged();
            listener.onItemClickReturn(pos);
            selectedPosition = pos;
        }
        dismiss();
    }


    public interface SelectReturnListener {
        public void onItemClickReturn(int pos);
    }

    ;


}
