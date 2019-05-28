package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RepositoryDetailActivity;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.RepositoryUtil;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:知识库 列表适配器
 * 时间:2017年3月27日10:22:28
 * 作者:xuj
 */
public class RepositoryAdapter extends BaseAdapter {

    private BaseActivity activity;
    /* 知识库列表数据 */
    private List<Repository> list;
    /* xml 解析器 */
    private LayoutInflater inflater;
    /* 当前Android屏幕宽度 */
    private int screenWidth;
    /* 搜索内容 */
    private String searchingContent;
    /* 是否是收藏页面 */
    private boolean isCollectionActivity;
    /* 点击下标 */
    private int clickPosition;
    /* 长按点击下标 */
    private int longClickPostion;
    /* 是否显示长按弹出框 */
    private boolean isShowLongClickDialog = true;


    public void setCollectionActivity(boolean collectionActivity) {
        isCollectionActivity = collectionActivity;
    }

    public void updateList(List<Repository> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addList(List<Repository> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        String fileType = list.get(position).getFile_type();
        return fileType.equals(RepositoryUtil.DIR) ? RepositoryUtil.DIR_INDEX : RepositoryUtil.FILE_INDEX;
    }


    public RepositoryAdapter(BaseActivity activity, List<Repository> list) {
        super();
        this.screenWidth = DensityUtils.getScreenWidth(activity);
        this.list = list;
        this.activity = activity;
        inflater = LayoutInflater.from(activity);
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
            if (type == RepositoryUtil.DIR_INDEX) { //文件夹展示的内容
                convertView = inflater.inflate(R.layout.item_repository, null, false);
            } else if (type == RepositoryUtil.FILE_INDEX) {
                convertView = inflater.inflate(R.layout.item_repository_detail, null, false);
            }
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
        if (type == RepositoryUtil.FILE_INDEX) { //文件标识
            holder.progress.setTag(repository.getFile_name() + position);
            holder.fileItem.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.progress.getLayoutParams();
                    params.height = holder.progress.getTag().equals(repository.getFile_name() + position) ? holder.fileItem.getHeight() : 0;
                    if (repository.isDownloadFile()) { //文件已下载完毕
                        params.width = screenWidth;
                        holder.fileSize.setVisibility(View.GONE);
                    } else { //文件未下载、或者文件正在下载中
                        holder.fileSize.setVisibility(View.VISIBLE);
                        if (repository.is_downloading() && holder.progress.getTag().equals(repository.getFile_name() + position)) { //知识库文件正在下载
                            params.width = (int) (screenWidth * repository.getDownloadPercentage()); //设置已下载的进度
                            holder.fileSize.setText(repository.getFileDownLoadDesc());
                        } else { //文件未下载
                            params.width = 0;
                            holder.fileSize.setText(repository.getFile_size());
                        }
                    }
                    holder.progress.setLayoutParams(params);
                    if (Build.VERSION.SDK_INT < 16) {
                        holder.fileItem.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        holder.fileItem.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            if (!isCollectionActivity) {
                holder.isCollection.setVisibility(repository.getIs_collection() == 1 ? View.VISIBLE : View.GONE);
            } else {
                holder.isCollection.setVisibility(View.GONE);
            }
        }
        if (!TextUtils.isEmpty(searchingContent)) { //搜索内容不为空则模糊搜索并将搜索的文件标记成红色
            Pattern p = Pattern.compile(searchingContent);
            SpannableStringBuilder builder = new SpannableStringBuilder(type == RepositoryUtil.FILE_INDEX ? repository.getFile_name() + "." + repository.getFile_type() : repository.getFile_name());
            Matcher nameMatch = p.matcher(repository.getFile_name());
            while (nameMatch.find()) {
                ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            }
            holder.fileName.setText(builder);
        } else {
            holder.fileName.setText(type == RepositoryUtil.FILE_INDEX ? repository.getFile_name() + "." + repository.getFile_type() : repository.getFile_name());
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String fileType = repository.getFile_type();
                if (!fileType.equals(RepositoryUtil.DIR)) { //如果是文件则下载文件
                    if (repository.is_downloading()) { //如果当前文件正在下载 则不能点击
                        return;
                    }
                    clickPosition = position;
                    if (repository.isDownloadFile()) { //如果文件已经下载了则直接打开当前文件
                        RepositoryUtil.openDownloadFile(activity, RepositoryUtil.FILE_DOWNLOADED_FLODER +
                                repository.getFile_name() + repository.getId() + "." + repository.getFile_type(), repository.getFile_name() + "." + repository.getFile_type(), repository);
                        return;
                    }
                    RepositoryUtil.download(activity, repository);
                } else { //如果是文件夹则跳转到下一个页面
                    RepositoryDetailActivity.actionStart(activity, repository.getFile_name(), repository.getId());
                }
            }
        });
        if (isShowLongClickDialog) {
            convertView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    longClickPostion = position;
                    return false;
                }
            });
            convertView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                    if (!repository.getFile_type().equals(RepositoryUtil.DIR)) { //如果是文件夹则不能长按点击
                        //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                        menu.add(0, Menu.FIRST, 0, repository.getIs_collection() == 0 ? "收藏" : "取消收藏");
                    }
                }
            });
        }
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            isCollection = (TextView) convertView.findViewById(R.id.isCollection);
            fileName = (TextView) convertView.findViewById(R.id.fileName);
            fileSize = (TextView) convertView.findViewById(R.id.fileSize);
            progress = convertView.findViewById(R.id.progress);
            line = convertView.findViewById(R.id.itemDiver);
            fileItem = (LinearLayout) convertView.findViewById(R.id.fileItem);
        }


        /**
         * 文件下载的进度
         */
        View progress;
        /**
         * 文件名称
         */
        TextView fileName;
        /**
         * 文件大小
         */
        TextView fileSize;
        /**
         * 文件是否收藏
         */
        TextView isCollection;
        /**
         * 底部线条
         */
        View line;
        /**
         * 文件布局
         */
        LinearLayout fileItem;
    }

    public List<Repository> getList() {
        return list;
    }

    public void setList(List<Repository> list) {
        this.list = list;
    }

    public String getSearchingContent() {
        return searchingContent;
    }

    public void setFilterValue(String searchingContent) {
        this.searchingContent = searchingContent;
    }

    public int getClickPosition() {
        return clickPosition;
    }

    public void setClickPosition(int clickPosition) {
        this.clickPosition = clickPosition;
    }

    public int getLongClickPostion() {
        return longClickPostion;
    }

    public void setLongClickPostion(int longClickPostion) {
        this.longClickPostion = longClickPostion;
    }

    public boolean isShowLongClickDialog() {
        return isShowLongClickDialog;
    }

    public void setShowLongClickDialog(boolean showLongClickDialog) {
        isShowLongClickDialog = showLongClickDialog;
    }
}
