package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.activity.notebook.NoteBookDetailActivity;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.util.NameUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 功能记事本列表适配器
 * 时间:2018年4月19日 18:15:44
 * 作者:xuj
 */
public class NoteBookDetailAdapter extends BaseAdapter {

    /* 图片数据源 */
    private List<NoteBook> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private Context context;
    private String filterValue;

    public NoteBookDetailAdapter(Context context, List<NoteBook> list, String filterValue) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.filterValue = filterValue;
    }

    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public Object getItem(int arg0) {
        return list.get(arg0);
    }

    public long getItemId(int arg0) {
        return arg0;
    }


    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_notebook_list, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        NoteBook noteBook = list.get(position);
        //设置日期
        if (!TextUtils.isEmpty(noteBook.getPublish_time())) {
            if (!TextUtils.isEmpty(noteBook.getWeekday())) {
                holder.tv_date.setText(getDateYearMonthDayStr(noteBook.getPublish_time()) + " " + noteBook.getWeekday() + " " + getHourStr(noteBook.getPublish_time()));
            } else {
                holder.tv_date.setText(getDateYearMonthDayStr(noteBook.getPublish_time()) + " " + getHourStr(noteBook.getPublish_time()));
            }

        }
        //设置内容
        if (!TextUtils.isEmpty(noteBook.getContent())) {
            holder.tv_content.setText(TextUtils.isEmpty(filterValue) ? noteBook.getContent() : NameUtil.matchTextAndFillRed(noteBook.getContent(), filterValue));
        }
        LUtils.e("-------AAAAAAAA---------------");
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LUtils.e("-------AAAAAAAA---------------" + position);
                NoteBookDetailActivity.actionStart((Activity) context, list.get(position));
            }
        });
        return convertView;
    }

    public String getDateYearMonthDayStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf2.format(date); //改变格式
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }

    public String getHourStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf2.format(date); //改变格式
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            tv_date = (TextView) view.findViewById(R.id.tv_date);
            tv_content = (TextView) view.findViewById(R.id.tv_content);
        }

        private TextView tv_date;
        private TextView tv_content;
    }
}
