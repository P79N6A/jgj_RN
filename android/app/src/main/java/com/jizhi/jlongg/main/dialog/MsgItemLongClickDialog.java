package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.MsgLongClickListener;
import com.jizhi.jlongg.main.activity.BaseActivity;

import java.util.List;


/**
 * 功能:关闭同步项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class MsgItemLongClickDialog extends Dialog implements View.OnClickListener {


    private ListView lv_listView;
    private List<String> list;
    //    private BaseActivity context;
    private boolean isMsgSuccess;

    public MsgItemLongClickDialog(BaseActivity content, MsgLongClickListener msgLongClickListener, List<String> list, int pos) {
        super(content, R.style.Custom_Progress);
        createLayout(content, msgLongClickListener, list, pos);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final BaseActivity content, final MsgLongClickListener msgLongClickListener,final List<String> list, final int pos) {
        setContentView(R.layout.dialog_msg_longclick_item);
        lv_listView = (ListView) findViewById(R.id.lv_listView);
        LongClickAdapter longClickAdapter = new LongClickAdapter(content, list);
        lv_listView.setAdapter(longClickAdapter);
        lv_listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                dismiss();
                LUtils.e(list.get(position).toString());
                msgLongClickListener.MsgItemLongClickLisstener(list.get(position).toString(), pos);
            }
        });
    }


    @Override
    public void onClick(View v) {
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public class LongClickAdapter extends BaseAdapter {
        private Context context;
        private LayoutInflater inflater;
        private List<String> list;

        public LongClickAdapter(Context context, List<String> list) {
            this.context = context;
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
                holder.tv_text = (TextView) convertView.findViewById(R.id.tv_text);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            holder.tv_text.setText(list.get(position).toString());
            return convertView;
        }

        class ViewHolder {

            TextView tv_text;
        }


    }
}