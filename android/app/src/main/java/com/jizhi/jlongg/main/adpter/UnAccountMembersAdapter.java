package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.activity.MultiPersonBatchAccountNewActivity;
import com.jizhi.jlongg.main.bean.BatchAccountDetail;
import com.jizhi.jlongg.main.bean.BatchAccountOtherProInfo;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:未记账对象
 * 时间:2017年10月10日11:14:51
 * 作者:xuj
 */
public class UnAccountMembersAdapter extends PersonBaseAdapter {


    private MultiPersonBatchAccountNewActivity context;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 班组人员数据
     */
    private List<BatchAccountDetail> list;
    /**
     * 班组管理添加、删除人员回调
     */
    private AddMemberListener listener;
    /**
     * 显示头像
     */
    private static final int SHOW_HEAD = 0;
    /**
     * 添加人员、刪除人员
     */
    private static final int ADD_OR_REMOVE = 1;
    /**
     * 点击头像的回调
     */
    private ClickMemberListener clickMemberListener;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<BatchAccountDetail> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public UnAccountMembersAdapter(MultiPersonBatchAccountNewActivity context, List<BatchAccountDetail> list, AddMemberListener listener, ClickMemberListener clickMemberListener) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
        this.listener = listener;
        this.clickMemberListener = clickMemberListener;
    }


    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        if (list == null) {
            return ADD_OR_REMOVE;
        }
        if (position >= list.size()) {
            return ADD_OR_REMOVE;
        } else {
            return SHOW_HEAD;
        }
    }

    @Override
    public int getCount() {
        if (list == null) {
            return 0;
        }
        return list.size() + 2;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int type = getItemViewType(position);
        switch (type) {
            case ADD_OR_REMOVE:
                convertView = inflater.inflate(R.layout.item_team_manager_remove, parent, false);
                ImageView image = (ImageView) convertView.findViewById(R.id.remove_add_image);
                TextView state = (TextView) convertView.findViewById(R.id.state);
                image.setImageResource(position == list.size() ? R.drawable.icon_member_add : R.drawable.icon_member_delete);
                state.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
                state.setText(position == list.size() ? "添加" : "删除");
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (position == list.size()) { //添加
                            listener.add(MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                        } else { //删除
                            listener.remove(Constance.DELETE_MEMBER);
                        }
                    }
                });
                break;
            case SHOW_HEAD:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_unaccount_member, parent, false);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                bindData(holder, position, convertView);
                break;
        }
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position, final View convertView) {
        final BatchAccountDetail bean = list.get(position);
        setSelectedState(holder, bean);
        holder.userName.setText(NameUtil.setName(bean.getReal_name()));
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.roundImageHashText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (clickMemberListener == null) {
                    return;
                }
                if (bean.getMsg() != null && !TextUtils.isEmpty(bean.getMsg().getMsg_text())) {
                    CommonMethod.makeNoticeLong(context, bean.getMsg().getMsg_text(), CommonMethod.ERROR);
                    return;
                }
//                if (bean.getIs_double() == 1) {
//                    CommonMethod.makeNoticeLong(context, "他在已对你记了两笔工", CommonMethod.ERROR);
//                    return;
//                }
                if (bean.isSelected()) { //直接取消状态
                    bean.setSelected(!bean.isSelected());
                    hideSelecteAnim(holder, bean);
                    clickMemberListener.clickMember(bean, true);
                } else {
                    boolean isSetSalary = false; //是否已设置薪资标准
                    if (context.currentWork.equals(AccountUtil.HOUR_WORKER)) { //点工
                        isSetSalary = bean.getTpl() == null || bean.getTpl().getW_h_tpl() == 0 ? false : true;
                    } else if (context.currentWork.equals(AccountUtil.CONSTRACTOR_CHECK)) { //包工记工天模板
                        isSetSalary = bean.getUnit_quan_tpl() == null || bean.getUnit_quan_tpl().getW_h_tpl() == 0 ? false : true;
                    }
                    if (!isSetSalary) {
                        clickMemberListener.clickMember(bean, isSetSalary);
                        return;
                    }
                    bean.setSelected(!bean.isSelected());
                    showSelecteAnim(holder, bean);
                    clickMemberListener.clickMember(bean, isSetSalary);
                }
            }
        });
        holder.roundImageHashText.setOnLongClickListener(new View.OnLongClickListener() { //长按设置薪资模板
            @Override
            public boolean onLongClick(View v) {
                if (clickMemberListener != null) {
                    clickMemberListener.longClickMember(bean);
                }
                return false;
            }
        });
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            selecteIcon = (ImageView) view.findViewById(R.id.selecteIcon);
            selecteBackground = view.findViewById(R.id.selecteBackground);
            unSetSalaryFlag = view.findViewById(R.id.unSetSalaryFlag);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 用户姓名
         */
        private TextView userName;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
        /**
         * 选中的图片
         */
        private ImageView selecteIcon;
        /**
         * 选中的背景
         */
        private View selecteBackground;
        /**
         * 未设置薪资模板的标志
         */
        private View unSetSalaryFlag;
    }


    private void setSelectedState(ViewHolder holder, BatchAccountDetail bean) {
        if (bean.isSelected()) { //已选中
            if (bean.getMsg() == null) {
                bean.setMsg(new BatchAccountOtherProInfo());
            }
            String accountType = bean.getMsg().getAccounts_type();
            if (TextUtils.isEmpty(accountType)) { //设置记账类型
                bean.getMsg().setAccounts_type(context.currentWork);
            }
            holder.selecteIcon.setVisibility(View.VISIBLE);
            holder.selecteIcon.setImageResource(bean.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? R.drawable.select_hour_work_icon : R.drawable.select_contractor_icon);
            holder.roundImageHashText.setAlpha(0.1F);
            Utils.setBackGround(holder.selecteBackground, context.getResources().getDrawable(
                    bean.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? R.drawable.draw_sk_ff9933_2radius : R.drawable.draw_sk_22a0e8_2radius));
            holder.unSetSalaryFlag.setVisibility(View.GONE);
        } else {
            if (bean.getMsg() != null) {
                bean.getMsg().setAccounts_type(null);
            }
            if (context.currentWork.equals(AccountUtil.HOUR_WORKER)) { //点工薪资模板
                holder.unSetSalaryFlag.setVisibility(bean.getTpl() != null && bean.getTpl().getW_h_tpl() > 0 ? View.GONE : View.VISIBLE);
            } else if (context.currentWork.equals(AccountUtil.CONSTRACTOR_CHECK)) { //包工薪资模板
                holder.unSetSalaryFlag.setVisibility(bean.getUnit_quan_tpl() != null && bean.getUnit_quan_tpl().getW_h_tpl() > 0 ? View.GONE : View.VISIBLE);
            }
            holder.selecteIcon.setVisibility(View.GONE);
            holder.roundImageHashText.setAlpha(1.0f);
            Utils.setBackGround(holder.selecteBackground, context.getResources().getDrawable(R.drawable.sk_dbdbdb_2radius));
        }
    }

    private void showSelecteAnim(final ViewHolder holder, final BatchAccountDetail bean) {
        holder.selecteIcon.setVisibility(View.VISIBLE);
        Animation animation = AnimationUtils.loadAnimation(context, R.anim.show_scale_animation);
        holder.selecteIcon.startAnimation(animation);//开始动画
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {//动画结束
                setSelectedState(holder, bean);
            }
        });
    }

    private void hideSelecteAnim(final ViewHolder holder, final BatchAccountDetail bean) {
        Animation animation = AnimationUtils.loadAnimation(context, R.anim.hide_scale_animation);
        holder.selecteIcon.startAnimation(animation);//开始动画
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {//动画结束
                setSelectedState(holder, bean);
            }
        });
    }

    public List<BatchAccountDetail> getList() {
        return list;
    }


    public interface ClickMemberListener {
        /**
         * @param bean
         * @param isSetSalary true表示未设置工资清单
         */
        public void clickMember(BatchAccountDetail bean, boolean isSetSalary);

        /**
         * 长按点击头像
         *
         * @param bean
         */
        public void longClickMember(BatchAccountDetail bean);

    }

}
