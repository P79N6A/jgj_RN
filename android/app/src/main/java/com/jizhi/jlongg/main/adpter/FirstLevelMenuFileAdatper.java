package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能:云盘一级菜单适配器
 * 时间:2017年7月25日17:43:30
 * 作者:xuj
 */
public class FirstLevelMenuFileAdatper extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<Cloud> list;
    /**
     * xml数据解析器
     */
    private LayoutInflater inflater;
    /**
     * 是否在编辑数据
     */
    private boolean isEditor;
    /**
     * 过滤文本
     */
    private String filterValue;


    private BaseActivity activity;


    @Override
    public int getItemViewType(int position) {
        String type = list.get(position).getType();
        if (TextUtils.isEmpty(type)) {
            return CloudUtil.FOLDER;
        }
        return type.equals(CloudUtil.FOLDER_TAG) ? CloudUtil.FOLDER : CloudUtil.FILE;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    public FirstLevelMenuFileAdatper(BaseActivity activity, List<Cloud> list) {
        super();
        this.list = list;
        this.activity = activity;
        inflater = LayoutInflater.from(activity);
    }


    public void updateListView(List<Cloud> list) {
        this.list = list;
        notifyDataSetChanged();
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
        int type = getItemViewType(position);
        ViewHolder holder;
        if (convertView == null) {
            if (type == CloudUtil.FOLDER) {
                convertView = inflater.inflate(R.layout.pro_cloud_folder_item, null); //文件夹布局
            } else if (type == CloudUtil.FILE) {
                convertView = inflater.inflate(R.layout.pro_cloud_file_item, null); //文件布局
            }
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, type);
        return convertView;
    }


    private void bindData(final ViewHolder holder, int position, int type) {
        final Cloud bean = list.get(position);
        holder.fileName.setText(TextUtils.isEmpty(filterValue) ? bean.getFile_name() : NameUtil.matchTextAndFillRed(bean.getFile_name(), filterValue));
        holder.time.setText(!TextUtils.isEmpty(bean.getUpdate_time()) ? bean.getUpdate_time() : bean.getDate()); //如果有修改时间就用修改时间 否则用创建时间
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        holder.selectedIcon.setVisibility(isEditor ? View.VISIBLE : View.GONE);
        holder.selectedIcon.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        holder.openFileLayout.setVisibility(View.GONE);
        if (type == CloudUtil.FILE) {//文本标识
            switch (bean.getFile_broad_type()) {
                case CloudUtil.DOC_TAG: //word文档
                    holder.fileIcon.setImageResource(R.drawable.doc_icon_cloud);
                    break;
                case CloudUtil.XLS_TAG: //xls
                    holder.fileIcon.setImageResource(R.drawable.excel_icon);
                    break;
                case CloudUtil.PPT_TAG: //ppt
                    holder.fileIcon.setImageResource(R.drawable.cloud_ppt_icon);
                    break;
                case CloudUtil.PDF_TAG: //pdf
                    holder.fileIcon.setImageResource(R.drawable.pdf_icon);
                    break;
                case CloudUtil.VIDEO_TAG: //视频
                    holder.fileIcon.setImageResource(R.drawable.video_icon);
                    break;
                case CloudUtil.TXT_TAG: //文本txt
                    holder.fileIcon.setImageResource(R.drawable.txt_icon);
                    break;
                case CloudUtil.CAD_TAG: //CAD
                    holder.fileIcon.setImageResource(R.drawable.cad_icon);
                    break;
                case CloudUtil.ZIP_TAG: //压缩包
                    holder.fileIcon.setImageResource(R.drawable.zip_icon);
                    break;
                case CloudUtil.PIC_TAG:
                    if (holder.fileIcon.getTag() != null && holder.fileIcon.getTag().equals(bean.getThumbnail_file_path() + position)) { //防止图片被错误加载

                    } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
                        ImageLoader.getInstance().displayImage(bean.getThumbnail_file_path(), holder.fileIcon, UtilImageLoader.loadListItemCloudOptions(activity));
                        holder.fileIcon.setTag(bean.getThumbnail_file_path() + position);
                    }
                    break;
                default:
                    holder.fileIcon.setImageResource(0);
                    break;
            }
            if (!bean.getFile_broad_type().equals(CloudUtil.PIC_TAG)) {
                holder.fileIcon.setTag(bean.getThumbnail_file_path() + position);
            }
            holder.fileIcon.setScaleType(bean.getFile_broad_type().equals(CloudUtil.PIC_TAG) ? ImageView.ScaleType.CENTER_CROP : ImageView.ScaleType.FIT_CENTER);
        }
        if (!TextUtils.isEmpty(bean.getOpeator_name())) { //操作人名称
            holder.opeatorName.setText(bean.getOpeator_name());
            holder.opeatorName.setVisibility(View.VISIBLE);
        } else {
            holder.opeatorName.setVisibility(View.GONE);
        }
    }


    class ViewHolder {
        /**
         * 文件名称
         */
        TextView fileName;
        /**
         * 文件时间
         */
        TextView time;
        /**
         * 底部线条
         */
        View line;
        /**
         * 文件选中状态
         */
        ImageView selectedIcon;
        /**
         * 打开文件详情
         */
        View openFileLayout;
        /**
         * 文件图标
         */
        ImageView fileIcon;
        /**
         * 操作人姓名
         */
        TextView opeatorName;

        public ViewHolder(View convertView) {
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
            fileIcon = (ImageView) convertView.findViewById(R.id.fileIcon);
            fileName = (TextView) convertView.findViewById(R.id.fileName);
            time = (TextView) convertView.findViewById(R.id.time);
            line = convertView.findViewById(R.id.itemDiver);
            openFileLayout = convertView.findViewById(R.id.openFileLayout);
            opeatorName = (TextView) convertView.findViewById(R.id.opeatorName);
        }
    }


    public void updateList(List<Cloud> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public List<Cloud> getList() {
        return list;
    }

    public void setList(List<Cloud> list) {
        this.list = list;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
