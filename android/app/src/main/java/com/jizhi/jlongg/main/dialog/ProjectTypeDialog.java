package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ListViewOneRawMultiselectAdapter;
import com.jizhi.jlongg.main.bean.WorkType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;

import java.util.List;

/**
 * WheelDialog
 *
 * @author Xuj
 * @date 2015年8月5日 15:45:12
 */
public class ProjectTypeDialog extends Dialog implements OnItemClickListener {

    private Context context;
    /**
     * 工种适配器
     */
    private ListViewOneRawMultiselectAdapter adapter;
    /**
     * 确认回调
     */
    private ConfirmClickListener confirmClickListener;
    /**
     * 取消回调
     */
    private CancelClickListener cancelClickListener;
    /**
     * 工种数据
     */
    private List<WorkType> list;
    private int origin;
    /**
     * 最大工种选择数
     */
    private final int MAXNUMBER = 5;
    /**
     * 已选工种数
     */
    private int alreadSelectedNumber;


    public ProjectTypeDialog(Context context, ConfirmClickListener confirmClickListener, List<WorkType> list, CancelClickListener cancelClickListene, int origin) {
        super(context, R.style.wheelViewDialog);
        this.context = context;
        this.confirmClickListener = confirmClickListener;
        this.cancelClickListener = cancelClickListene;
        this.list = list;
        this.origin = origin;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DensityUtils.applyCompat(getWindow(), context);
        setContentView(R.layout.layout_project_type);
        ListView listView = (ListView) findViewById(R.id.listView);
        Button btn_cancel = (Button) findViewById(R.id.btn_cancel);
        Button btn_confirm = (Button) findViewById(R.id.btn_confirm);
        TextView title = (TextView) findViewById(R.id.tv_context);
        select_count = (TextView) findViewById(R.id.select_count);
        title.setText(context.getString(R.string.worktype_null));
        adapter = new ListViewOneRawMultiselectAdapter(context, list);
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).isSelected()) {
                alreadSelectedNumber += 1;
            }
        }
        if (origin == Constance.RIGISTR_ORIGIN_PROJECTTYPE) {
            select_count.setText(Html.fromHtml("<font>你最多可选择5个工种(还剩下</font><font color='#f75a23'>" + (MAXNUMBER - alreadSelectedNumber) + "</font><font>个)</font>"));
        } else if (origin == Constance.RIGISTR_ORIGIN_WORKERTYPE) {
            select_count.setText(Html.fromHtml("<font>你最多可选择5个工种(还剩下</font><font color='#f75a23'>" + (MAXNUMBER - alreadSelectedNumber) + "</font><font>个)</font>"));
        }
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(this);
        btn_cancel.setOnClickListener(cancelClick);
        btn_confirm.setOnClickListener(confirmClick);
    }

    public interface ConfirmClickListener {
        void getText();
    }

    public interface CancelClickListener {
        void dismiss();
    }

    android.view.View.OnClickListener cancelClick = new android.view.View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (cancelClickListener != null) {
                cancelClickListener.dismiss();
            }
            dismiss();
        }
    };
    android.view.View.OnClickListener confirmClick = new android.view.View.OnClickListener() {
        @Override
        public void onClick(View v) {
//            for (int i = 0; i < list.size(); i++) {
//                list.get(i).setIsSelected(false);
//            }
            confirmClickListener.getText();
            dismiss();
        }
    };
    private TextView select_count;

    @Override
    public void onItemClick(AdapterView<?> arg0, View view, int position, long arg3) {
        if (list.get(position).isSelected()) {
            list.get(position).setIsSelected(false);
            alreadSelectedNumber -= 1;
        } else {
            if (alreadSelectedNumber >= 5) {
                CommonMethod.makeNoticeShort(context, "最多只能选择五种工种", CommonMethod.ERROR);
                return;
            }
            alreadSelectedNumber += 1;
            list.get(position).setIsSelected(true);
        }
        if (origin == Constance.RIGISTR_ORIGIN_PROJECTTYPE) {
            select_count.setText(Html.fromHtml("<font>你最多可选择5个工种(还剩下</font><font color='#f75a23'>" + (MAXNUMBER - alreadSelectedNumber) + "</font><font>个)</font>"));
        } else if (origin == Constance.RIGISTR_ORIGIN_WORKERTYPE) {
            select_count.setText(Html.fromHtml("<font>你最多可选择5个工种(还剩下</font><font color='#f75a23'>" + (MAXNUMBER - alreadSelectedNumber) + "</font><font>个)</font>"));
        }
        adapter.notifyDataSetChanged();

    }

}