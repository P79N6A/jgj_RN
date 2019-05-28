package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ItemClickBean;

import java.util.List;

/**
 * 消息长按点击时间
 */
public class NewMessageItemDialog extends Dialog {


    private ListView lv_listView;
    public static final int COPY = 1;
    public static final int SEND = 2;
    public static final int DELETE = 3;
    public static final int RECALL = 4;
    public static final int FORWARD = 5;
//    private List<ItemClickBean> list;

    public NewMessageItemDialog(BaseActivity content, ItemClickInterface itemClickInterface, List<ItemClickBean> list, int pos) {
        super(content, R.style.Custom_Progress);
        createLayout(content, itemClickInterface, list, pos);
        commendAttribute(true);
    }

    public void createLayout(final BaseActivity content, final ItemClickInterface itemClickInterface, final List<ItemClickBean> list, final int pos) {
        setContentView(R.layout.dialog_msg_longclick_item);
        lv_listView = findViewById(R.id.lv_listView);
        LongClickAdapter longClickAdapter = new LongClickAdapter(content, list);
        lv_listView.setAdapter(longClickAdapter);
        lv_listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                dismiss();
                switch (list.get(position).getId()) {
                    case COPY:
                        itemClickInterface.copy(pos);
                        break;
                    case SEND:
                        itemClickInterface.send(pos);
                        break;
                    case DELETE:
                        itemClickInterface.delete(pos);
                        break;
                    case RECALL:
                        itemClickInterface.recall(pos);
                        break;
                    case FORWARD:
                        itemClickInterface.forward(pos);
                        break;
                }
            }
        });
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public class LongClickAdapter extends BaseAdapter {
        private LayoutInflater inflater;
        private List<ItemClickBean> list;

        public LongClickAdapter(Context context, List<ItemClickBean> list) {
            inflater = LayoutInflater.from(context);
            this.list = list;
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                holder = new ViewHolder();
                convertView = inflater.inflate(R.layout.item_dialog_textview, null);
                holder.tv_text = convertView.findViewById(R.id.tv_text);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            holder.tv_text.setText(list.get(position).getContext());
            return convertView;
        }

        class ViewHolder {
            TextView tv_text;
        }
    }

    public interface ItemClickInterface {
        void copy(int position);

        void send(int position);

        void delete(int position);

        void recall(int position);

        void forward(int position);
    }
}
