package com.jizhi.jlongg.main.adpter;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
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
 * 功能:项目云盘适配器
 * 时间:2017年7月17日10:18:16
 * 作者:xuj
 */
public class SecondLevelMenuFileAdatper extends BaseExpandableListAdapter {
    /**
     * 编辑回调
     */
    private CloudUtil.FileEditorListener editorListener;
    /**
     * 列表数据
     */
    private List<Cloud> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private BaseActivity activity;
    /**
     * 是否正在编辑
     */
    private boolean isEditor;
    /**
     * 是否显示文件详情
     */
    private boolean isShowFileDetail = true;
    /**
     * 过滤文本
     */
    private String filterValue;



    public SecondLevelMenuFileAdatper(BaseActivity activity, List<Cloud> list, CloudUtil.FileEditorListener editorListener) {
        super();
        this.list = list;
        this.editorListener = editorListener;
        this.activity = activity;
        inflater = LayoutInflater.from(activity);
    }

    public void updateList(List<Cloud> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    @Override
    public int getGroupType(int groupPosition) {
        String type = list.get(groupPosition).getType();
        if (TextUtils.isEmpty(type)) {
            return CloudUtil.FOLDER;
        }
        return type.equals(CloudUtil.FOLDER_TAG) ? CloudUtil.FOLDER : CloudUtil.FILE;
    }

    @Override
    public Object getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getGroupTypeCount() {
        return 2;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return 1;
    }


    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return null;
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        int type = getGroupType(groupPosition);
        GroupHolder holder;
        if (convertView == null) {
            if (type == CloudUtil.FOLDER) {
                convertView = inflater.inflate(R.layout.pro_cloud_folder_item, null); //文件夹布局
            } else if (type == CloudUtil.FILE) {
                convertView = inflater.inflate(R.layout.pro_cloud_file_item, null); //文件布局
            }
            holder = new GroupHolder(convertView, type);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        bindGroupData(holder, groupPosition, type, convertView);
        return convertView;
    }


    private void bindGroupData(GroupHolder holder, final int position, int type, View convertView) {
        final Cloud bean = list.get(position);
        holder.fileName.setText(TextUtils.isEmpty(filterValue) ? bean.getFile_name() : NameUtil.matchTextAndFillRed(bean.getFile_name(), filterValue));
        holder.time.setText(!TextUtils.isEmpty(bean.getUpdate_time()) ? bean.getUpdate_time() : bean.getDate()); //如果有修改时间就用修改时间 否则用创建时间
        holder.line.setVisibility(position == getGroupCount() - 1 ? View.GONE : View.VISIBLE);
        holder.selectedIcon.setVisibility(isEditor ? View.VISIBLE : View.GONE);
        holder.selectedIcon.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        holder.openStateIcon.setImageResource(bean.isShowFileDetail() ? R.drawable.point_open : R.drawable.point_close);
        holder.openFileLayout.setVisibility(isEditor || !isShowFileDetail ? View.GONE : View.VISIBLE);

        holder.openFileLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editorListener.showFileDetail(bean, position);
            }
        });
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
            holder.fileSize.setText(bean.getFile_size());
        }
        if (!TextUtils.isEmpty(bean.getOpeator_name())) { //操作人名称
            holder.opeatorName.setText(bean.getOpeator_name());
            holder.opeatorName.setVisibility(View.VISIBLE);
        } else {
            holder.opeatorName.setVisibility(View.GONE);
        }
    }

    @Override
    public View getChildView(final int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        ChildHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.pro_cloud_file_detail_item, null); //文件夹布局
            holder = new ChildHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ChildHolder) convertView.getTag();
        }
        final Cloud bean = list.get(groupPosition);
        if (bean.getType().equals(CloudUtil.FOLDER_TAG)) { //文件夹只能重命名
            holder.downLoadText.setVisibility(View.GONE);
            holder.shareText.setVisibility(View.GONE);
        } else {
            holder.downLoadText.setVisibility(View.VISIBLE);
            holder.shareText.setVisibility(View.VISIBLE);
        }
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (editorListener == null) {
                    return;
                }
                switch (v.getId()) {
                    case R.id.shareText: //分享
                        editorListener.shareFile(list.get(groupPosition));
                        break;
                    case R.id.downLoadText: //下载
                        editorListener.downLoadFile(list.get(groupPosition));
                        break;
                    case R.id.renameText: //重命名
                        editorListener.renameFile(bean);
                        break;
                }
            }
        };
        holder.downLoadText.setOnClickListener(onClickListener);
        holder.shareText.setOnClickListener(onClickListener);
        holder.renameText.setOnClickListener(onClickListener);
        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    class GroupHolder {
        /**
         * 文件名称
         */
        TextView fileName;
        /**
         * 文件大小
         */
        TextView fileSize;
        /**
         * 文件时间
         */
        TextView time;
        /**
         * 文件夹图标,文件打开标志,文件选中状态
         */
        ImageView fileIcon, openStateIcon, selectedIcon;
        /**
         * 底部线条
         */
        View line;
        /**
         * 打开文件详情
         */
        View openFileLayout;
        /**
         * 操作人姓名
         */
        TextView opeatorName;

        public GroupHolder(View convertView, int type) {
            fileName = (TextView) convertView.findViewById(R.id.fileName);
            time = (TextView) convertView.findViewById(R.id.time);
            openStateIcon = (ImageView) convertView.findViewById(R.id.openStateIcon);
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
            openFileLayout = convertView.findViewById(R.id.openFileLayout);
            line = convertView.findViewById(R.id.itemDiver);
            fileIcon = (ImageView) convertView.findViewById(R.id.fileIcon);
            fileSize = (TextView) convertView.findViewById(R.id.fileSize);
            opeatorName = (TextView) convertView.findViewById(R.id.opeatorName);
        }
    }

    class ChildHolder {
        /**
         * 分享
         */
        TextView shareText;
        /**
         * 下载
         */
        TextView downLoadText;
        /**
         * 重命名
         */
        TextView renameText;

        public ChildHolder(View convertView) {
            shareText = (TextView) convertView.findViewById(R.id.shareText);
            downLoadText = (TextView) convertView.findViewById(R.id.downLoadText);
            renameText = (TextView) convertView.findViewById(R.id.renameText);
        }

    }

    public List<Cloud> getList() {
        return list;
    }

    public void setList(List<Cloud> list) {
        this.list = list;
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }


    public boolean isShowFileDetail() {
        return isShowFileDetail;
    }

    public void setShowFileDetail(boolean showFileDetail) {
        isShowFileDetail = showFileDetail;
    }
}
