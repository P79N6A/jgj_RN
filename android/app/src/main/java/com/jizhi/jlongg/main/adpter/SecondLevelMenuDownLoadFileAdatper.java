package com.jizhi.jlongg.main.adpter;

import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能:项目云盘适配器
 * 时间:2017年7月17日10:18:16
 * 作者:xuj
 */
public class SecondLevelMenuDownLoadFileAdatper extends BaseExpandableListAdapter {
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


    public SecondLevelMenuDownLoadFileAdatper(BaseActivity activity, List<Cloud> list, CloudUtil.FileEditorListener editorListener) {
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
        int fileState = list.get(groupPosition).getFileState();
        return fileState == CloudUtil.FILE_COMPLETED_STATE ? CloudUtil.LOADED : CloudUtil.LOADING;
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
            if (type == CloudUtil.LOADING) {
                convertView = inflater.inflate(R.layout.pro_cloud_loading_item, null); //文件夹布局
            } else if (type == CloudUtil.FILE) {
                convertView = inflater.inflate(R.layout.pro_cloud_file_item, null); //文件布局
            }
            holder = new GroupHolder(convertView, type);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        bindGroupData(holder, groupPosition, type);
        return convertView;
    }


    private void bindGroupData(GroupHolder holder, final int position, int type) {
        final Cloud bean = list.get(position);
        holder.fileName.setText(bean.getFile_name());
        holder.line.setVisibility(position == getGroupCount() - 1 ? View.GONE : View.VISIBLE);
        final int fileFileTypeState = bean.getFileTypeState(); //文件类型 1为上传  2为下载
        if (type != CloudUtil.LOADED) { //未下载完毕的文件
            int progressColor = 0; //进度条颜色
            if (fileFileTypeState == CloudUtil.FILE_TYPE_DOWNLOAD_TAG) { //文件下载
                switch (bean.getFileState()) {
                    case CloudUtil.FILE_LOADING_STATE: //文件下载中
                        holder.downLoadingStateIcon.setImageResource(R.drawable.pause);
                        holder.downLoadingStateText.setText("暂停下载");
                        holder.downLoadState.setText("正在下载中");
                        progressColor = ContextCompat.getColor(activity, R.color.color_eb4e4e);
                        break;
                    case CloudUtil.FILE_NO_COMPLETE_STATE: //文件未下载
                        holder.downLoadingStateText.setText("继续下载");
                        holder.downLoadState.setText("暂停");
                        holder.downLoadingStateIcon.setImageResource(R.drawable.go_on_upload);
                        progressColor = ContextCompat.getColor(activity, R.color.color_9d9d9d);
                        break;
                }
            } else if (fileFileTypeState == CloudUtil.FILE_TYPE_UPLOAD_TAG) { //文件上传
                switch (bean.getFileState()) {
                    case CloudUtil.FILE_LOADING_STATE: //文件上传中
                        holder.downLoadingStateIcon.setImageResource(R.drawable.pause);
                        holder.downLoadingStateText.setText("暂停上传");
                        holder.downLoadState.setText("上传中");
                        progressColor = ContextCompat.getColor(activity, R.color.color_eb4e4e);
                        break;
                    case CloudUtil.FILE_NO_COMPLETE_STATE: //文件未上传
                        holder.downLoadingStateIcon.setImageResource(R.drawable.go_on_upload);
                        holder.downLoadingStateText.setText("继续上传");
                        holder.downLoadState.setText("暂停");
                        progressColor = ContextCompat.getColor(activity, R.color.color_9d9d9d);
                        break;
                }
            }
            holder.progressText.setText((Utils.getFileSizeString(bean.getFile_downloading_size()) + "/" + Utils.getFileSizeString(bean.getFileTotalSize())));
            int progressTotalWidth = DensityUtils.dp2px(activity, 200); //进度条的总长度
            float proressWeight = ((float) bean.getFile_downloading_size()) / bean.getFileTotalSize();
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.progress.getLayoutParams();
            params.width = (int) (progressTotalWidth * proressWeight); //设置文件进度条
            holder.progress.setLayoutParams(params);
            holder.progress.setBackgroundColor(progressColor);
            holder.downLoadLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (editorListener == null) {
                        return;
                    }
                    switch (bean.getFileState()) {
                        case CloudUtil.FILE_LOADING_STATE: //文件下载,上传中
                            editorListener.pauseFile(bean);
                            break;
                        case CloudUtil.FILE_NO_COMPLETE_STATE: //文件暂停中
                            editorListener.startFile(bean);
                            break;
                    }
                }
            });
        } else {
            holder.selectedIcon.setVisibility(View.GONE);
            holder.time.setText(!TextUtils.isEmpty(bean.getUpdate_time()) ? bean.getUpdate_time() : bean.getDate()); //如果有修改时间就用修改时间 否则用创建时间
            holder.fileSize.setText(Utils.getFileSizeString(bean.getFileTotalSize()));
            holder.openStateIcon.setVisibility(fileFileTypeState == CloudUtil.FILE_TYPE_UPLOAD_TAG ? View.INVISIBLE : View.VISIBLE); //上传完毕的按钮隐藏 点击显示2级菜单按钮
            holder.openStateIcon.setImageResource(bean.isShowFileDetail() ? R.drawable.point_open : R.drawable.point_close);
            holder.openFileLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (fileFileTypeState == CloudUtil.FILE_TYPE_DOWNLOAD_TAG) { //上传不能点击详情
                        editorListener.showFileDetail(bean, position);
                        return;
                    }
                }
            });
        }
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
            case CloudUtil.PIC_TAG: //图片
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
        holder.shareText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (editorListener == null) {
                    return;
                }
                editorListener.shareFile(list.get(groupPosition)); //文件分享
            }
        });
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
         * 文件暂停、开始下载状态 ,文件下载进度
         */
        TextView downLoadingStateText, progressText, downLoadState;
        /**
         * 文件暂停、开始下载布局
         */
        View downLoadLayout;
        /**
         * 文件暂停、开始下载图标
         */
        ImageView downLoadingStateIcon;
        /**
         * 下载进度
         */
        View progress;

        public GroupHolder(View convertView, int type) {
            fileName = (TextView) convertView.findViewById(R.id.fileName);
            fileIcon = (ImageView) convertView.findViewById(R.id.fileIcon);
            line = convertView.findViewById(R.id.itemDiver);
            progress = convertView.findViewById(R.id.progress);
            if (type == CloudUtil.LOADING) { //下载中
                downLoadState = (TextView) convertView.findViewById(R.id.downLoadState);
                downLoadingStateText = (TextView) convertView.findViewById(R.id.downLoadingStateText);
                downLoadingStateIcon = (ImageView) convertView.findViewById(R.id.downLoadingStateIcon);
                progressText = (TextView) convertView.findViewById(R.id.progressText);
                downLoadLayout = convertView.findViewById(R.id.downLoadLayout);
            } else {
                time = (TextView) convertView.findViewById(R.id.time);
                convertView.findViewById(R.id.opeatorName).setVisibility(View.GONE);//隐藏操作人姓名
                openStateIcon = (ImageView) convertView.findViewById(R.id.openStateIcon);
                openFileLayout = convertView.findViewById(R.id.openFileLayout);
                selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
                fileSize = (TextView) convertView.findViewById(R.id.fileSize);
            }
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

            downLoadText.setVisibility(View.GONE);
            renameText.setVisibility(View.GONE);
        }
    }

    public List<Cloud> getList() {
        return list;
    }

    public void setList(List<Cloud> list) {
        this.list = list;
    }

    public CloudUtil.FileEditorListener getEditorListener() {
        return editorListener;
    }

    public void setEditorListener(CloudUtil.FileEditorListener editorListener) {
        this.editorListener = editorListener;
    }


}
