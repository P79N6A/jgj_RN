package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DateUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.activity.notebook.NoteBookDetailActivity;
import com.jizhi.jlongg.activity.notebook.NoteBookTodayListActivity;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 功能记事本列表适配器
 * 时间:2018年4月19日 18:15:44
 * 作者:xuj
 */
public class NoteBookAdapter extends BaseAdapter {

    /* 图片数据源 */
    private List<NoteBook> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private Context context;
    private String filterValue;

    public NoteBookAdapter(Context context, List<NoteBook> list) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    public NoteBookAdapter(Context context, List<NoteBook> list, String filterValue) {
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
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_notebook_list, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final NoteBook noteBook = list.get(position);
        //设置日期
        if (!TextUtils.isEmpty(noteBook.getPublish_time())) {
            if (!TextUtils.isEmpty(noteBook.getWeekday())) {
                holder.tv_date.setText(DateUtils.getDateYearMonthDayStr(noteBook.getPublish_time()) + " " + noteBook.getWeekday() + " " + getHourStr(noteBook.getPublish_time()));
            } else {
                holder.tv_date.setText(DateUtils.getDateYearMonthDayStr(noteBook.getPublish_time()) + " " + getHourStr(noteBook.getPublish_time()));
            }

        }
        holder.img_impor.setVisibility(noteBook.getIs_import() == 1 ? View.VISIBLE : View.GONE);
        if (position != 0) {
            if (noteBook.getPublish_time().equals(list.get(position - 1).getPublish_time())) {
                holder.rea_top.setVisibility(View.GONE);
                holder.rea_line.setVisibility(View.VISIBLE);
            } else {
                holder.rea_top.setVisibility(View.VISIBLE);
                holder.rea_line.setVisibility(View.GONE);
            }
        } else {
            holder.rea_top.setVisibility(View.VISIBLE);
            holder.rea_line.setVisibility(View.GONE);
        }
        //设置内容
        if (!TextUtils.isEmpty(noteBook.getContent())) {
            holder.tv_content.setText(TextUtils.isEmpty(filterValue) ? noteBook.getContent() : NameUtil.matchTextAndFillRed(noteBook.getContent(), filterValue));
        }
        if (noteBook.getImages().size() == 0) {
            holder.ngl_images.setVisibility(View.GONE);
        } else {
            holder.ngl_images.setVisibility(View.VISIBLE);
            holder.ngl_images.createImages(noteBook.getImages(), DensityUtils.dp2px(context, 40));
        }
        holder.tv_content.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NoteBookDetailActivity.actionStart((Activity) context, list.get(position));
            }
        });
        holder.ngl_images.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NoteBookDetailActivity.actionStart((Activity) context, list.get(position));
            }
        });
//        if (position == list.size() - 1 && list.size() > 0) {
//            convertView.findViewById(R.id.view_bg_bottom).setVisibility(View.VISIBLE);
//        } else {
//            convertView.findViewById(R.id.view_bg_bottom).setVisibility(View.GONE);
//
//        }
        return convertView;
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
            tv_date = view.findViewById(R.id.tv_date);
            tv_content = view.findViewById(R.id.tv_content);
            rea_top = view.findViewById(R.id.rea_top);
            rea_line = view.findViewById(R.id.rea_line);
            ngl_images = view.findViewById(R.id.ngl_images);
            img_impor = view.findViewById(R.id.img_impor);

        }

        private TextView tv_date;
        private TextView tv_content;
        private RelativeLayout rea_line;
        private RelativeLayout rea_top;
        private HorizotalImageLayout ngl_images;
        private ImageView img_impor;
    }
}
