package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Repository;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:知识库 列表适配器
 * 时间:2017年3月27日10:22:28
 * 作者:xuj
 */
public class RepositoryDownLoadAdapter extends BaseAdapter {

    /* 知识库列表数据 */
    private List<Repository> list;
    /* xml 解析器 */
    private LayoutInflater inflater;
    /* 搜索内容 */
    private String searchingContent;
    /* 是否正在编辑资料库 */
    private boolean isEditor;


    public void updateList(List<Repository> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addList(List<Repository> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }


    public RepositoryDownLoadAdapter(Activity context, List<Repository> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
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


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        int type = getItemViewType(position);
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_repository_download, null, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, type, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, final int type, final View convertView) {
        final Repository repository = list.get(position);
        String fileName = repository.getFile_name();
        if (!TextUtils.isEmpty(searchingContent)) { //搜索内容不为空则模糊搜索并将搜索的文件标记成红色
            Pattern p = Pattern.compile(searchingContent);
            SpannableStringBuilder builder = new SpannableStringBuilder(fileName);
            Matcher nameMatch = p.matcher(fileName);
            while (nameMatch.find()) {
                ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            }
            holder.fileName.setText(builder);
        } else {
            holder.fileName.setText(repository.getFile_name());
        }
        if (isEditor) {
            holder.isSelected.setVisibility(View.VISIBLE);
            holder.isSelected.setImageResource(repository.isIs_selected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        } else {
            holder.isSelected.setVisibility(View.GONE);
        }
        holder.createTime.setText(repository.getCreate_time());
        holder.itemDiver.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            fileName = (TextView) convertView.findViewById(R.id.fileName);
            createTime = (TextView) convertView.findViewById(R.id.createTime);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            fileItem = (LinearLayout) convertView.findViewById(R.id.fileItem);
            isSelected = (ImageView) convertView.findViewById(R.id.isSelected);
        }


        /**
         * 文件名称
         */
        TextView fileName;
        /**
         * 文件创建时间
         */
        TextView createTime;
        /**
         * 底部线条
         */
        View itemDiver;
        /**
         * 文件布局
         */
        LinearLayout fileItem;
        /**
         * 文件是否被选中
         */
        ImageView isSelected;
    }

    public List<Repository> getList() {
        return list;
    }

    public void setList(List<Repository> list) {
        this.list = list;
    }


    public void setFilterValue(String searchingContent) {
        this.searchingContent = searchingContent;
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public void updateListView(List<Repository> repositories){
        this.list = repositories;
        notifyDataSetChanged();
    }

}
