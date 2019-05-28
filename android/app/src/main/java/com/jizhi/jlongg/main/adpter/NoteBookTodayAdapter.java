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
 * 功能记事本列表适配器,某日
 * 时间:2018年4月19日 18:15:44
 * 作者:xuj
 */
public class NoteBookTodayAdapter extends BaseAdapter {

    /* 图片数据源 */
    private List<NoteBook> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private Context context;
    private ImportantClick importantClick;

    public NoteBookTodayAdapter(Context context, List<NoteBook> list, ImportantClick importantClick) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.importantClick = importantClick;
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


    public View getView(final int position, View convertView, final ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_notebook_today_list, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final NoteBook noteBook = list.get(position);
        holder.rb_important.setChecked(noteBook.getIs_import() == 1 ? true : false);
        holder.img_impor.setVisibility(View.GONE);
        holder.rb_important.setText(noteBook.getIs_import() == 1 ? "重要" : "标记为重要");
        holder.rea_important.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                importantClick.itemClickImpor(position, noteBook.getIs_import() == 1 ? false : true);
            }
        });
        //设置内容
        if (!TextUtils.isEmpty(noteBook.getContent())) {
            holder.tv_content.setText(noteBook.getContent());
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
            tv_content = view.findViewById(R.id.tv_content);
            ngl_images = view.findViewById(R.id.ngl_images);
            img_impor = view.findViewById(R.id.img_impor);
            rb_important = view.findViewById(R.id.rb_important);
            rea_important = view.findViewById(R.id.rea_important);
        }

        private TextView tv_content;
        private RelativeLayout rea_important;
        private HorizotalImageLayout ngl_images;
        private ImageView img_impor;
        private RadioButton rb_important;
    }

    public interface ImportantClick {
        void itemClickImpor(int positon, boolean isChcked);
    }
}
