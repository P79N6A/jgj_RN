package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.JImageUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.io.File;
import java.util.ArrayList;
import java.util.List;


/**
 * 功能:关闭同步项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class SavaPicDialog extends Dialog implements View.OnClickListener {


    private ListView lv_listView;
    private List<String> list;
    private Bitmap bitmap;
    private Context content;

    public SavaPicDialog(Context content, Bitmap bitmap) {
        super(content, R.style.Custom_Progress);
        this.bitmap = bitmap;
        this.content = content;
        list = new ArrayList<>();
        list.add("保存到本地");
        list.add("取消");
        createLayout(content);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Context content) {
        setContentView(R.layout.dialog_msg_longclick_item);
        lv_listView = (ListView) findViewById(R.id.lv_listView);
        LongClickAdapter longClickAdapter = new LongClickAdapter(content, list);
        lv_listView.setAdapter(longClickAdapter);
        lv_listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                dismiss();
                LUtils.e(list.get(position).toString());
                if (position == 0) {
                    SavePic(bitmap);
                }

            }
        });
    }

    public boolean SavePic(Bitmap bitmap) {
        try {
            ContentResolver cr = content.getContentResolver();
            String url = JImageUtils.insertImage(cr, bitmap, "jgj_" + JImageUtils.getCurrentTimeLong(), "a photo from app", "吉工家");
            //对某些不更新相册的应用程序强制刷新
            Intent intent2 = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            Uri uri = Uri.fromFile(new File("/sdcard/image.jpg"));//固定写法
            intent2.setData(uri);
            content.sendBroadcast(intent2);
            if (!TextUtils.isEmpty(url)) {
                CommonMethod.makeNoticeShort(content, "保存成功", CommonMethod.SUCCESS);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

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