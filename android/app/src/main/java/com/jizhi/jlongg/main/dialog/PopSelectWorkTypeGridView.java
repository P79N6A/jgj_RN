package com.jizhi.jlongg.main.dialog;

import android.app.ActionBar;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoDB;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.adpter.FindProjectWorkTypeAdapter;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

/**
 * 选择工种window
 *
 * @author huchangsheng
 * @date 2016年4月18日 15:45:12
 */
public class PopSelectWorkTypeGridView extends PopupWindow {

    /** context */
    private Context context;
    //dao
    private BaseInfoService baseInfoService;
    /** 回调接口 */
    private WorkTypeItemGVClickListerer WorkTypeItemClickListerer;

    public PopSelectWorkTypeGridView(Context context, BaseInfoService baseInfoService, WorkTypeItemGVClickListerer WorkTypeItemClickListerer) {
        super(context);
        this.context = context;
        this.baseInfoService = baseInfoService;
        this.WorkTypeItemClickListerer = WorkTypeItemClickListerer;
        init();
    }

    private void init() {
        View view = LayoutInflater.from(context).inflate(R.layout.layout_findproject_worktype_pop, null);
        setContentView(view);
        GridView gv_workType = (GridView) view.findViewById(R.id.gv_wy);
        TextView tv_cacel = (TextView) view.findViewById(R.id.tv_cacel);
        tv_cacel.setVisibility(View.VISIBLE);
        setWidth(ActionBar.LayoutParams.MATCH_PARENT);
        setHeight(ActionBar.LayoutParams.WRAP_CONTENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0xfafafa);
        setBackgroundDrawable(dw);
        setAnimationStyle(R.style.popwin_anim_style);
        if (null == baseInfoService) {
            baseInfoService = BaseInfoService.getInstance(context.getApplicationContext());
        }
        final List<WorkType> workTypeList = baseInfoService.selectInfo(BaseInfoDB.jlg_work_type);
        FindProjectWorkTypeAdapter FindProjectWorkTypeAdapter = new FindProjectWorkTypeAdapter(context, workTypeList);
        gv_workType.setAdapter(FindProjectWorkTypeAdapter);
        gv_workType.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                WorkTypeItemClickListerer.WorktypeGvItemClick(workTypeList.get(position).getWorkName(), workTypeList.get(position).getWorktype());
                dismiss();
            }
        });
        tv_cacel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        view.findViewById(R.id.rea).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }

    public interface WorkTypeItemGVClickListerer {
        void WorktypeGvItemClick(String WorkName, String id);
    }
}
