package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:开启对账详情
 * 时间:2019年2月15日9:58:47
 * 作者:xuj
 */
public class BalanceOfAccountAdapter extends PersonBaseAdapter {

    private BaseActivity context;
    /**
     * 班组人员列表数据
     */
    public List<GroupMemberInfo> list;
    /**
     * 回调函数
     */
    private BalanceOfAccountListener listener;
    /**
     * 过滤文本
     */
    private String filterValue;

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

    public BalanceOfAccountAdapter(BaseActivity context, List<GroupMemberInfo> list, BalanceOfAccountListener listener) {
        super();
        this.list = list;
        this.context = context;
        this.listener = listener;
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
            convertView = LayoutInflater.from(context).inflate(R.layout.item_balance_of_account, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }


    private void bindData(ViewHolder holder, int position, View convertView) {
        final GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getReal_name())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getReal_name());
                Matcher nameMatch = p.matcher(bean.getReal_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
            }
            if (!TextUtils.isEmpty(bean.getTelephone())) { //电话号码不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getTelephone());
                Matcher telMatch = p.matcher(bean.getTelephone());
                while (telMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.tel.setText(builder);
            }
        } else {
            setTelphoneAndRealName(bean.getReal_name(), bean.getTelephone(), holder.name, holder.tel);
        }
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(getSectionForPosition(position))) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        //1、[已注册已开启]状态：显示“我要对账”，点击跳转到我要对账界面；
        //如果和该记账对象没有需要确认的账，显示对账缺省页；
        //如果和该记账对象有需要确认的账，显示和该记账对象所有的需要对账的记录；
        //2、[已注册未开启]状态：后面显示“拨打电话联系开启”；
        //3、[未注册未开启]状态：后面显示“邀请注册吉工家”，点击分享到“QQ空间、QQ群、微信群、朋友圈”，分享到微信群/微信好友，以小程序方式分享出去；
        //4、添加记账对象时，未填写号码的对象，显示“该对象无电话号码”；

        if (TextUtils.isEmpty(bean.getConfirm_off_desc())) {
            holder.grayTips.setVisibility(View.GONE);
        } else {
            holder.grayTips.setVisibility(View.VISIBLE);
            holder.grayTips.setText(bean.getConfirm_off_desc());
        }
        if (bean.getIs_not_telph() == 1) { //没有电话号码
//            holder.grayTips.setText("该对象无电话号码");
            holder.balanceOfAccountBtn.setVisibility(View.GONE);
            holder.redTips.setVisibility(View.GONE);
        } else if (bean.getIs_active() == 1) { //已注册
            if (bean.getConfirm_off() == 0) { //已开启对账按钮
                holder.redTips.setVisibility(View.GONE);
                holder.balanceOfAccountBtn.setVisibility(View.VISIBLE);
                holder.balanceOfAccountBtn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (listener != null) {
                            listener.confirmAccount(bean.getUid());
                        }
                    }
                });
            } else { //未开启
                holder.balanceOfAccountBtn.setVisibility(View.GONE);
                holder.redTips.setVisibility(View.VISIBLE);
                holder.redTips.setText("拨打电话联系开启");
                holder.redTips.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) { //拨打电话
                        if (listener != null) {
                            listener.callPhone(bean.getTelephone());
                        }
                    }
                });
            }
        } else {
            holder.balanceOfAccountBtn.setVisibility(View.GONE);
            if (bean.getConfirm_off() == 1) {
                holder.redTips.setVisibility(View.VISIBLE);
                holder.redTips.setText("邀请注册吉工家");
                holder.redTips.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) { //邀请注册
                        if (listener != null) {
                            listener.inviteRegister();
                        }
                    }
                });
            }
        }
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            grayTips = (TextView) convertView.findViewById(R.id.gray_tips);
            redTips = (TextView) convertView.findViewById(R.id.red_tips);
            balanceOfAccountBtn = (TextView) convertView.findViewById(R.id.balance_of_account_btn);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
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
         * 黑色提示文字
         */
        TextView grayTips;
        /**
         * 红色提示文字
         */
        TextView redTips;
        /**
         * 我要对账按钮
         */
        TextView balanceOfAccountBtn;
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


    public interface BalanceOfAccountListener {
        public void callPhone(String telephone); //拨打电话

        public void inviteRegister(); //邀请注册

        public void confirmAccount(String uid);//跟他对账
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
