package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.ObjectAnimator;

import java.util.List;

/**
 * 功能:编辑项目列表
 * 时间:2016-4-18 18:34
 * 作者:xuj
 */
public class EditorProjectAdapter extends BaseAdapter {

    private ListView listView;

    /**
     * 列表数据
     */
    private List<Project> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;

    /**
     * 是否正在编辑项目
     * true 编辑中  显示删除图片
     * false 非编辑状态 隐藏删除图片
     */
    private boolean isEditor;
    /**
     * 回调
     */
    private ProjectCallBack listener;

    /**
     * 点击下标
     */
    private int clickPosition;

    private Context context;


    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public EditorProjectAdapter(Context context, List<Project> list, boolean isEditor, ProjectCallBack listener, ListView listView) {
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.isEditor = isEditor;
        this.listener = listener;
        this.context = context;
        this.listView = listView;
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
        final ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_editor_project, null);
            holder.projectName = (TextView) convertView.findViewById(R.id.projectName);
            holder.update = (TextView) convertView.findViewById(R.id.update);
            holder.remove = (ImageView) convertView.findViewById(R.id.remove);
            holder.layout = (RelativeLayout) convertView.findViewById(R.id.layout);
            holder.view = convertView.findViewById(R.id.view);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final Project bean = list.get(position);
        holder.view.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        holder.update.setVisibility(bean.getPid() == 0 || isEditor ? View.GONE : View.VISIBLE); //其他项目不需要显示修改按钮
        holder.remove.setVisibility(bean.getPid() == 0 ? View.INVISIBLE : View.VISIBLE);
        if (isEditor) {
            if (!bean.isShowAnim()) {
                ObjectAnimator animator1 = ObjectAnimator.ofFloat(holder.layout, "translationX", -DensityUtils.dp2px(context, 15), DensityUtils.dp2px(context, 15));
                ObjectAnimator animator2 = ObjectAnimator.ofFloat(holder.remove, "alpha", 0.0F, 1.0F);
                animator1.setDuration(450);
                animator2.setDuration(450);
                animator1.addListener(new Animator.AnimatorListener() {
                    @Override
                    public void onAnimationStart(Animator animator) {

                    }

                    @Override
                    public void onAnimationEnd(Animator animator) {
                        bean.setShowAnim(true);
                    }

                    @Override
                    public void onAnimationCancel(Animator animator) {

                    }

                    @Override
                    public void onAnimationRepeat(Animator animator) {

                    }
                });
                animator1.start();
                animator2.start();
                holder.update.setVisibility(View.GONE);
            }
        } else {
            if (!bean.isShowAnim()) {
                ObjectAnimator animator1 = ObjectAnimator.ofFloat(holder.layout, "translationX", DensityUtils.dp2px(context, 15), -DensityUtils.dp2px(context, 15));
                ObjectAnimator animator2 = ObjectAnimator.ofFloat(holder.remove, "alpha", 1.0F, 0.0F);
                animator1.setDuration(450);
                animator2.setDuration(450);
                animator1.addListener(new Animator.AnimatorListener() {
                    @Override
                    public void onAnimationStart(Animator animator) {

                    }

                    @Override
                    public void onAnimationEnd(Animator animator) {
                        bean.setShowAnim(true);
                    }

                    @Override
                    public void onAnimationCancel(Animator animator) {

                    }

                    @Override
                    public void onAnimationRepeat(Animator animator) {

                    }
                });
                animator1.start();
                animator2.start();
                holder.update.setVisibility(View.VISIBLE);
            }
        }
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener == null) {
                    return;
                }
                clickPosition = position;
                switch (v.getId()) {
                    case R.id.update: //修改项目名称
                        listener.update(bean.getPro_name());
                        break;
                    case R.id.converview:
                        if (isEditor) {
                            listener.remove(position, bean.getPid());
                        }
                        break;
                }
            }
        };
        holder.projectName.setText(bean.getPro_name());
        holder.update.setOnClickListener(onClickListener);
        convertView.setOnClickListener(onClickListener);
        return convertView;
    }

    public List<Project> getList() {
        return list;
    }

    public int getClickPosition() {
        return clickPosition;
    }

    /**
     * 更新单个数据
     */
    public void updateSingleView() {
        //得到第一个可显示控件的位置，
        int visiblePosition = listView.getFirstVisiblePosition();
        //只有当要更新的view在可见的位置时才更新，不可见时，跳过不更新
        if (clickPosition - visiblePosition >= 0) {
            //得到要更新的item的view
            View view = listView.getChildAt(clickPosition - visiblePosition);
//            //从view中取得holder
//            ViewHolder holder = (ViewHolder) view.getTag();
//            holder.projectName.setText(projectName);
            getView(clickPosition, view, listView);
        }
    }


    class ViewHolder {
        /**
         * 项目标题
         */
        TextView projectName;
        /**
         * 修改项目名称
         */
        TextView update;
        /**
         * 删除项目图片
         */
        ImageView remove;
        /**
         * 布局
         */
        RelativeLayout layout;


        View view;
    }


    public interface ProjectCallBack {
        /**
         * 修改项目名称
         */
        public void update(String proName);

        /**
         * 删除项目
         *
         * @param position 下标
         * @param pid      项目id
         */
        public void remove(int position, int pid);

    }
}
