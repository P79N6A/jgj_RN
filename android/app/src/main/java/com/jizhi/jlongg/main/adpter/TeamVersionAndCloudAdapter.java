package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.pay.ConfirmCloudOrderNewActivity;
import com.jizhi.jlongg.main.activity.pay.MyOrderListActivity;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.bean.ProductTips;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.List;

/**
 * 功能:项目设置底部黄金版、云盘服务信息
 * 时间:2017年8月16日15:29:24
 * 作者:xuj
 */
public class TeamVersionAndCloudAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<ProductTips> list;
    /**
     * 项目组id
     */
    private String groupId;
    /**
     * 是否已关闭
     */
    private boolean isClosed;
    private Activity context;


    public TeamVersionAndCloudAdapter(Activity context, List<ProductTips> list, boolean isMyselfGroup, String groupId, boolean isClosed) {
        this.list = list;
        if (isMyselfGroup) {
            this.list.add(addServerOrder());
        }
        this.groupId = groupId;
        this.context = context;
        this.isClosed = isClosed;
    }

    /**
     * 新增服务订单接口
     */
    private ProductTips addServerOrder() {
        ProductTips tips = new ProductTips();
        tips.setFirst_title_name("服务订单");
        tips.setServer_id(ProductInfo.SERVER_ORDER);
        tips.setClick(true);
        return tips;
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
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_expire_tips, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    public void bindData(final ViewHolder holder, final int position, View convertView) {
        final ProductTips bean = list.get(position);
        holder.titleText.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        holder.line.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        holder.clickIcon.setVisibility(isClosed ? View.GONE : bean.isClick() ? View.VISIBLE : View.GONE);
        holder.isExpire.setVisibility(View.GONE);
        String first_title_name = bean.getFirst_title_name();
        try {
            if (!TextUtils.isEmpty(first_title_name)) {
                if (first_title_name.contains("已过期")) {
                    SpannableStringBuilder builder = Utils.setSelectedFontChangeColor(first_title_name, "已过期", Color.parseColor("#eb4e4e"),false);
                    holder.firstMenu.setText(builder);
                    holder.secondMenu.setVisibility(View.GONE);
                } else if (first_title_name.contains("(")) {
                    holder.firstMenu.setText(first_title_name.substring(0, first_title_name.indexOf("(")));
                    holder.secondMenu.setText(first_title_name.substring(first_title_name.indexOf("("), first_title_name.length()));
                    holder.secondMenu.setVisibility(View.VISIBLE);
                } else if (first_title_name.contains("（")) {
                    holder.firstMenu.setText(first_title_name.substring(0, first_title_name.indexOf("（")));
                    holder.secondMenu.setText(first_title_name.substring(first_title_name.indexOf("（"), first_title_name.length()));
                    holder.secondMenu.setVisibility(View.VISIBLE);
                } else {
                    holder.firstMenu.setText(first_title_name);
                    holder.secondMenu.setVisibility(View.GONE);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        holder.value.setText(bean.getSecond_title_name());
        Utils.setBackGround(convertView, context.getResources().getDrawable(bean.isClick() ? R.drawable.draw_listview_selector_white_gray : R.color.white));
        convertView.setOnClickListener(new View.OnClickListener() {
                                           @Override
                                           public void onClick(View view) {
                                               if (isClosed) {
                                                   return;
                                               }
                                               if (bean.getServer_id() == ProductInfo.VERSION_ID) {
                                                   if (bean.getBuy_type() == 1) { //黄金服务版 并且人数小于500 那么可以继续购买人数
                                                   } else {
//                                                       ConfirmVersionOrderNewActivity.actionStart(context, groupId);
                                                   }
                                               } else if (bean.getServer_id() == ProductInfo.CLOUD_ID) {
                                                   ConfirmCloudOrderNewActivity.actionStart(context, groupId);
                                               } else if (bean.getServer_id() == ProductInfo.SERVER_ORDER) { //服务订单
                                                   MyOrderListActivity.actionStart(context, groupId, WebSocketConstance.TEAM, true);
                                               }
                                           }
                                       }
        );
    }


    public class ViewHolder {

        public ViewHolder(View convertView) {
            titleText = (TextView) convertView.findViewById(R.id.titleText);
            isExpire = (TextView) convertView.findViewById(R.id.isExpire);
            clickIcon = (ImageView) convertView.findViewById(R.id.clickIcon);
            firstMenu = (TextView) convertView.findViewById(R.id.firstMenu);
            secondMenu = (TextView) convertView.findViewById(R.id.secondMenu);
            value = (TextView) convertView.findViewById(R.id.value);
            line = convertView.findViewById(R.id.itemDiver);
        }

        /* 文本标题 */
        TextView titleText;
        /* 菜单名称 */
        TextView firstMenu;
        /* 第二个菜单名称 */
        TextView secondMenu;
        /* 是否过期 */
        TextView isExpire;
        /* 值 */
        TextView value;
        /* 能否点击的图标 */
        ImageView clickIcon;
        /* 线条和背景 */
        View line;
    }
}
