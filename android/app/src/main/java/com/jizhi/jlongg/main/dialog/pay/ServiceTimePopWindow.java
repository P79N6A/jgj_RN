package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.dialog.PopupWindowExpand;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.ProductUtil;

import java.util.List;

/**
 * 支付订单-->服务时长
 *
 * @author Xuj
 * @date 2017年8月10日11:38:48
 */
public class ServiceTimePopWindow extends PopupWindowExpand implements View.OnClickListener {
    /**
     * 列表数据
     */
    private List<Integer> list;
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * item选中回调
     */
    private SelecteServiceTimeListener listener;
    /**
     * 服务时长适配器
     */
    private ServiceTimeAdapter serviceTimeAdapter;
    /**
     * popwindow
     */
    private View popView;

    public ServiceTimePopWindow(Activity activity, List<Integer> list, SelecteServiceTimeListener listener) {
        super(activity);
        this.activity = activity;
        this.list = list;
        this.listener = listener;
        setPopView();
        initView();
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.layout_wheelview_gridview_log_mode, null);
        setContentView(popView);
        setPopParameter();
    }


    private void initView() {
        GridView gridView = (GridView) popView.findViewById(R.id.gv_wy);
        TextView content = (TextView) popView.findViewById(R.id.tv_context);
        TextView closeBtn = (TextView) popView.findViewById(R.id.btn_cancel);
        popView.findViewById(R.id.btn_confirm).setVisibility(View.GONE);
        closeBtn.setText("关闭");
        content.setText("请选择服务时长");
        serviceTimeAdapter = new ServiceTimeAdapter(activity, list);
        gridView.setAdapter(serviceTimeAdapter);
        gridView.setNumColumns(2);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                dismiss();
                if (listener != null) {
                    listener.getSelecteItem(list.get(position), ProductUtil.getServerTimeString(list.get(position)));
                }
            }
        });
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
    }


    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(activity, 1.0F);
    }


    @Override
    public void onClick(View v) {
        dismiss();
    }

    public interface SelecteServiceTimeListener {

        public void getSelecteItem(Integer integer, String desc);
    }

    /**
     * 订单适配器
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月13日15:05:48
     */
    @SuppressLint("DefaultLocale")
    public class ServiceTimeAdapter extends BaseAdapter {

        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<Integer> list;

        public ServiceTimeAdapter(Context mContext, List<Integer> list) {
            this.list = list;
            inflater = LayoutInflater.from(mContext);
        }


        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public Object getItem(int position) {
            return list.get(position);
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(final int position, View convertView, ViewGroup arg2) {
            final ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.service_time_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            holder.serviceTimeText.setText(ProductUtil.getServerTimeString(list.get(position)));
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                serviceTimeText = (TextView) convertView.findViewById(R.id.serviceTimeText);
            }

            /**
             * 服务时长
             */
            TextView serviceTimeText;
        }
    }
}