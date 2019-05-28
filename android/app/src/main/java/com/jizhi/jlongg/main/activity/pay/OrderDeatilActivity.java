package com.jizhi.jlongg.main.activity.pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.Order;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MoneyUtils;
import com.jizhi.jlongg.main.util.ProductUtil;

import java.util.ArrayList;
import java.util.List;


/**
 * 订单详情
 *
 * @author Xuj
 * @time 2017年7月13日14:47:52
 * @Version 1.0
 */
public class OrderDeatilActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 支付方式
     * 0 代表支付宝
     * 1 代表微信
     */
    private int payWay = ProductUtil.WX_PAY;
    /**
     * 支付宝,微信选中图标
     */
    private ImageView aliPayIcon, wxIcon;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, Order orderInfo) {
        Intent intent = new Intent(context, OrderDeatilActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, orderInfo);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.order_detail);
        initView();
        registerWXCallBack();
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_SUCCESS);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(Constance.ACTION_MESSAGE_WXPAY_SUCCESS)) { //微信支付成功
                OrderSuccessActivity.actionStart(OrderDeatilActivity.this);
            }
        }
    }

    private void initView() {
        Intent intent = getIntent();
        Order order = (Order) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (order == null) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "获取订单信息出错", CommonMethod.ERROR);
            finish();
            return;
        }

        setTextTitle(R.string.order_detail);
        aliPayIcon = getImageView(R.id.aliPayIcon);
        wxIcon = getImageView(R.id.wxPayIcon);

        findViewById(R.id.payLayout).setVisibility(order.getOrder_status() == ProductUtil.UN_PAID ? View.VISIBLE : View.GONE);//如果订单已支付则隐藏支付布局
        findViewById(R.id.payRemaingTime).setVisibility(order.getOrder_status() == ProductUtil.UN_PAID ? View.VISIBLE : View.GONE); //如果订单已支付则底部金额布局
        findViewById(R.id.payBtn).setVisibility(order.getOrder_status() == ProductUtil.UN_PAID ? View.VISIBLE : View.INVISIBLE);

        final ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(new OrderDetailAdapter(this, getList(order)));

        getImageView(R.id.productIcon).setImageResource(order.getProduce_info().getServer_id() == ProductInfo.VERSION_ID ? R.drawable.gold_version : R.drawable.cloud_pro); //设置订单的图标
        getTextView(R.id.versionText).setText(order.getProduce_info().getServer_name());
        getTextView(R.id.price).setText(MoneyUtils.setMoney(this, "¥ " + Utils.m2(order.getProduce_info().getPrice())));
        getTextView(R.id.unitText).setText(MoneyUtils.setMoney(this, order.getProduce_info().getUnits()));

        float discountAmout = order.getDiscount_amount();
        TextView discountAmoutText = getTextView(R.id.discountAmoutText);
        if (discountAmout <= 0) {
            discountAmoutText.setVisibility(View.GONE);
        } else {
            discountAmoutText.setText("已优惠金额: ¥" + Utils.m2(discountAmout));
            discountAmoutText.setVisibility(View.VISIBLE);
        }
        getTextView(R.id.totalAmountText).setText(MoneyUtils.setMoney(getApplicationContext(), "¥ " + Utils.m2(order.getAmount()))); //设置订单的总价

//        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    Thread.sleep(1500); //休眠5秒钟后隐藏
//                    listView.setSelection(0);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            }
//        });
    }


    private List<ChatManagerItem> getList(Order order) {

        List<ChatManagerItem> chatManagerList = new ArrayList<>();

        ChatManagerItem menu = new ChatManagerItem("服务项目", order.getPro_name());
        ChatManagerItem menu1 = new ChatManagerItem("服务时长", order.getService_time());

        ChatManagerItem menu3 = new ChatManagerItem("云盘空间", order.getCloud_space() + "G");
        ChatManagerItem menu4 = new ChatManagerItem("支付方式", order.getPay_type() == ProductUtil.WX_PAY ? "微信支付" : "支付宝支付");
        ChatManagerItem menu5 = new ChatManagerItem("订购时间", order.getCreate_time());
        ChatManagerItem menu6 = new ChatManagerItem("订单编号", order.getOrder_sn());
        ChatManagerItem menu7 = new ChatManagerItem("订购用户", order.getReal_name() + "(" + order.getTelephone() + ")");
        chatManagerList.add(menu);
        chatManagerList.add(menu1);
        if (order.getServer_counts() != 0) {
            ChatManagerItem menu2 = new ChatManagerItem("服务人数", order.getServer_counts() + "人");
            chatManagerList.add(menu2);
        }

        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        chatManagerList.add(menu7);
        chatManagerList.add(menu6);
        return chatManagerList;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.payBtn: //立即支付
                Order order = (Order) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
                ProductUtil.commitOrder(this, order, payWay);
                break;
            case R.id.wxPayLayout: //微信支付
                if (payWay == ProductUtil.WX_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_normal);
                wxIcon.setImageResource(R.drawable.checkbox_pressed);
                payWay = ProductUtil.WX_PAY;
                break;
            case R.id.aliPayLayout: //支付宝支付
                if (payWay == ProductUtil.ALI_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_pressed);
                wxIcon.setImageResource(R.drawable.checkbox_normal);
                payWay = ProductUtil.ALI_PAY;
                break;
        }
    }

    /**
     * 订单详情
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月13日15:05:30
     */
    @SuppressLint("DefaultLocale")
    public class OrderDetailAdapter extends BaseAdapter {
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<ChatManagerItem> list;

        public OrderDetailAdapter(Context mContext, List<ChatManagerItem> list) {
            this.list = list;
            inflater = LayoutInflater.from(mContext);
        }


        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public Object getItem(int position) {
            return list.get(position);
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(final int position, View convertView, ViewGroup arg2) {
            final ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.order_detail_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            final ChatManagerItem bean = list.get(position);
            holder.name.setText(bean.getMenu());
            holder.value.setText(bean.getValue());
            holder.copyText.setVisibility(position == getCount() - 1 ? View.VISIBLE : View.GONE);
            holder.copyText.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    //得到剪贴板管理器
                    ClipboardManager cmb = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                    cmb.setText(bean.getValue());
                    CommonMethod.makeNoticeLong(getApplicationContext(), "复制成功", CommonMethod.SUCCESS);
                }
            });
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                name = (TextView) convertView.findViewById(R.id.name);
                value = (TextView) convertView.findViewById(R.id.value);
                copyText = (TextView) convertView.findViewById(R.id.copyText);
            }

            /**
             * 名称
             */
            TextView name;
            /**
             * 值
             */
            TextView value;
            /**
             * 复制文本
             */
            TextView copyText;
        }

        public void updateList(List<ChatManagerItem> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public void addList(List<ChatManagerItem> list) {
            this.list.addAll(list);
            notifyDataSetChanged();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }
}