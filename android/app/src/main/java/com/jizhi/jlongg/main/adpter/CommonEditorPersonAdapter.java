package com.jizhi.jlongg.main.adpter;

import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.annotation.TargetApi;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.DeleteUserListener;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能:编辑用户
 * 时间:2016-6-1 10:39
 * 作者:xuj
 */
public class CommonEditorPersonAdapter extends PersonBaseAdapter {
    /* 班组人员列表数据 */
    private List<GroupMemberInfo> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private BaseActivity context;
    /* 是否正在编辑黑名单 */
    private boolean isEditor;
    /* 删除用户 */
    private DeleteUserListener listener;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<GroupMemberInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public CommonEditorPersonAdapter(BaseActivity context, List<GroupMemberInfo> list, DeleteUserListener listener) {
        this.list = list;
        this.context = context;
        this.listener = listener;
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
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_editor_person, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position, View convertView) {
        GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        setTelphoneAndRealName(bean.getReal_name(), bean.getTelephone(), holder.name, holder.tel);
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalogLayout.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalogLayout.setVisibility(View.GONE);
        }
        if (position == list.size() - 1) { //设置人员总数
            holder.personCount.setText(String.format(context.getString(R.string.black_person_count), list.size()));
            holder.personCount.setVisibility(View.VISIBLE);
        } else {
            holder.personCount.setVisibility(View.GONE);
        }
        setAnim(bean, holder.item, holder.removeImage, holder.catalog);
        holder.removeLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.remove(position);
                }
            }
        });
    }


    private void setAnim(final GroupMemberInfo bean, LinearLayout item, ImageView removeImage, TextView catalog) {
        if (isEditor) {
            if (!bean.isShowAnim()) {
                ObjectAnimator animator1 = ObjectAnimator.ofFloat(item, "translationX", -DensityUtils.dp2px(context, 25), 0);
                ObjectAnimator animator2 = ObjectAnimator.ofFloat(removeImage, "alpha", 0.0F, 1.0F);
                ObjectAnimator animator3 = ObjectAnimator.ofFloat(catalog, "translationX", 0, DensityUtils.dp2px(context, 25));
                animator1.setDuration(450);
                animator2.setDuration(450);
                animator3.setDuration(450);
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
                animator3.start();
            }
        } else {
            if (!bean.isShowAnim()) {
                ObjectAnimator animator1 = ObjectAnimator.ofFloat(item, "translationX", 0, -DensityUtils.dp2px(context, 25));
                ObjectAnimator animator2 = ObjectAnimator.ofFloat(removeImage, "alpha", 1.0F, 0.0F);
                ObjectAnimator animator3 = ObjectAnimator.ofFloat(catalog, "translationX", DensityUtils.dp2px(context, 25), 0);
                animator1.setDuration(450);
                animator2.setDuration(450);
                animator3.setDuration(450);
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
                animator3.start();
            }
        }
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            removeImage = (ImageView) convertView.findViewById(R.id.removeImage);
            personCount = (TextView) convertView.findViewById(R.id.personCount);
            item = (LinearLayout) convertView.findViewById(R.id.item);
            removeLayout = (LinearLayout) convertView.findViewById(R.id.removeLayout);
            catalogLayout = (LinearLayout) convertView.findViewById(R.id.catalogLayout);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /**
         * 首字母背景色
         */
        View background;
        /**
         * 名称
         */
        TextView name;
        /**
         * 电话号码
         */
        TextView tel;
        /**
         * 首字母
         */
        TextView catalog;
        /**
         * 删除按钮
         */
        ImageView removeImage;
        /**
         * 人员数量
         */
        TextView personCount;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;

        LinearLayout item;

        LinearLayout removeLayout;

        LinearLayout catalogLayout;
    }


    /**
     * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
     */
    @SuppressWarnings("unused")
    public int getPositionForSection(int section) {
        for (int i = 0; i < getCount(); i++) {
            String sortStr = list.get(i).getSortLetters();
            if (null != sortStr) {
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }

    /**
     * 根据ListView的当前位置获取分类的首字母的Char ascii值
     */
    public int getSectionForPosition(int position) {
        if (null == list.get(position).getSortLetters()) {
            return 1;
        }
        return list.get(position).getSortLetters().charAt(0);
    }

    /**
     * 局部刷新
     *
     * @param view
     * @param itemIndex
     */
    public void updateSingleView(View view, int itemIndex) {
        if (view == null) {
            return;
        }
        //从view中取得holder
        ViewHolder holder = (ViewHolder) view.getTag();
        bindData(holder, itemIndex, view);
    }


    public List<GroupMemberInfo> getList() {
        return list;
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }
}
