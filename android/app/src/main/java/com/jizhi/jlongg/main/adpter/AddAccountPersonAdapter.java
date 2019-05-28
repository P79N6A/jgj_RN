package com.jizhi.jlongg.main.adpter;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 作者    你的名字
 * 时间    2019-2-20 上午 11:53
 * 文件    yzg_android_s
 * 描述
 */
public class AddAccountPersonAdapter extends PersonBaseAdapter {

    /**
     * 工人、班组长列表数据
     */
    private List<PersonBean> list;
    /**
     * 上下文
     */
    private BaseActivity context;
    /**
     * 搜索的过滤文本
     */
    private String filterValue;
    /**
     * 是否是多选
     */
    private boolean isMultipartSet;
    /**
     * groupId
     */
    private String groupId;
    /**
     * 是否是删除状态
     */
    private boolean isDel;
    /**
     * 回调函数
     */
    private AddAccountListener listener;
    /**
     * 记账类型
     */
    private int accountTyps;
    /**
     * 包工记账类型  1表示承包  2表示分包
     */
    private int constractorType;


    public AddAccountPersonAdapter(BaseActivity context, ArrayList<PersonBean> list, AddAccountListener listener, int accountTyps, int constractorType) {
        super();
        this.list = list;
        this.context = context;
        this.listener = listener;
        this.accountTyps = accountTyps;
        this.constractorType = constractorType;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<PersonBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public PersonBean getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.add_worker_or_foreman_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }

    private void bindData(ViewHolder holder, final int position) {
        final PersonBean personBean = getItem(position);
        holder.roundImageHashText.setView(personBean.getHead_pic(), personBean.getName(), position);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(personBean.getName())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(personBean.getName());
                Matcher nameMatch = p.matcher(personBean.getName());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.userName.setText(builder);
            }
            if (!TextUtils.isEmpty(personBean.getTelph())) { //电话号码不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(personBean.getTelph());
                Matcher telMatch = p.matcher(personBean.getTelph());
                while (telMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.tel.setText(builder);
            }
        } else {
            setTelphoneAndRealName(personBean.getName(), personBean.getTelph(), holder.userName, holder.tel);
        }
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(personBean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        if (isMultipartSet) { //多选
            holder.seletedImage.setVisibility(View.VISIBLE);
            holder.firstTips.setVisibility(View.GONE);
            holder.btnDelete.setVisibility(View.GONE);
            holder.selectedText.setVisibility(View.GONE);
            holder.seletedImage.setImageResource(personBean.isChecked() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        } else { //单选
            holder.seletedImage.setVisibility(View.GONE);
            if (!TextUtils.isEmpty(groupId)) {
//                holder.firstTips.setVisibility(View.GONE);
                holder.firstTips.setText(TextUtils.isEmpty(groupId) ? "常选人员" : "班组成员");
            } else {
                holder.firstTips.setText(accountTyps == AccountUtil.CONSTRACTOR_INT && constractorType == 1 ? "常选承包对象" : "常选人员");
            }
            holder.firstTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
            if (isDel) {
                holder.btnDelete.setVisibility(View.VISIBLE);
                holder.selectedText.setVisibility(View.GONE);
                holder.btnDelete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        new DialogLeftRightBtnConfirm(context, null, String.format(context.getString(R.string.delperson), personBean.getName()), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                            @Override
                            public void clickLeftBtnCallBack() {

                            }

                            @Override
                            public void clickRightBtnCallBack() {
                                if (listener != null) {
                                    listener.delete(personBean, position);
                                }
                            }
                        }).show();
                    }
                });
            } else {
                holder.btnDelete.setVisibility(View.GONE);
                holder.selectedText.setVisibility(personBean.isChecked() ? View.VISIBLE : View.GONE);
            }
        }
    }


    class ViewHolder {
        /**
         * 首字母背景色
         */
        View background;
        /**
         * 拼音首字母
         */
        TextView catalog;
        /**
         * 人物名称
         */
        TextView userName;
        /**
         * 电话号码
         */
        TextView tel;
        /**
         * 已选中文字
         */
        TextView selectedText;
        /**
         * 删除按钮
         */
        TextView btnDelete;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
        /**
         * 常选班组长、工人
         */
        TextView firstTips;
        /**
         * 多选按钮
         */
        ImageView seletedImage;


        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            userName = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            selectedText = (TextView) convertView.findViewById(R.id.selectedText);
            btnDelete = (TextView) convertView.findViewById(R.id.btnDelete);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
            firstTips = (TextView) convertView.findViewById(R.id.firstTips);
            seletedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
//                firstTips.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER) ? "常选班组长" : "常选工人");
        }
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


    public List<PersonBean> getList() {
        return list;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }

    public interface AddAccountListener {
        public void delete(PersonBean personBean, int position);
    }

    public void setMultipartSet(boolean multipartSet) {
        isMultipartSet = multipartSet;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public boolean isDel() {
        return isDel;
    }

    public void setDel(boolean del) {
        isDel = del;
    }
}
