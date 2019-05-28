package com.jizhi.jlongg.main.activity.pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Order;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.MoneyUtils;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 功能:我的订单
 * 时间:2017年7月18日14:33:41
 * 作者:xuj
 */
public class MyOrderListActivity extends BaseActivity {
    /**
     * 订单适配器
     */
    private MyOrderListAdapter adapter;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, MyOrderListActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId       项目组id
     * @param classType     项目组类型
     * @param isFromMyOrder true表示来自服务订单
     */
    public static void actionStart(Activity context, String groupId, String classType, boolean isFromMyOrder) {
        Intent intent = new Intent(context, MyOrderListActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.IS_FROM_SERVER_ORDER, isFromMyOrder);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_order_list);
        initView();
        getOrderList();
    }

    private void initView() {
        setTextTitle(getIntent().getBooleanExtra(Constance.IS_FROM_SERVER_ORDER, false) ? R.string.server_order : R.string.my_order);
        getTextView(R.id.defaultDesc).setText("暂无记录");
    }

    private void setAdapter(List<Order> list) {
        if (adapter == null) {
            adapter = new MyOrderListAdapter(MyOrderListActivity.this, list);
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setDivider(getResources().getDrawable(R.color.color_f1f1f1));
            listView.setDividerHeight(DensityUtils.dp2px(this, 7));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    Order order = adapter.getList().get(position);
                    int type = order.getOrder_type();
                    switch (type) {
                        case 1: //购买黄金版本
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 2: //续费黄金
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 3: //购买云盘
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 4: //续费云盘
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                    }
                }
            });
        } else {
            adapter.updateList(list);
        }
    }

    /**
     * 获取订单列表
     */
    public void getOrderList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId);
        }
        if (!TextUtils.isEmpty(classType)) {
            params.addBodyParameter("class_type", classType);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ORDER_LIST, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Order> base = CommonJson.fromJson(responseInfo.result, Order.class);
                    if (base.getState() != 0) {
                        setAdapter(base.getValues().getList());
                    } else {
                        DataUtil.showErrOrMsg(MyOrderListActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }


    /**
     * 订单适配器
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月13日15:05:48
     */
    @SuppressLint("DefaultLocale")
    public class MyOrderListAdapter extends BaseAdapter {

        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<Order> list;

        public MyOrderListAdapter(Context mContext, List<Order> list) {
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
                convertView = inflater.inflate(R.layout.my_order_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            final Order order = list.get(position);
            holder.orderNumber.setText("订单编号: " + order.getOrder_sn());
            holder.address.setText(getIntent().getBooleanExtra(Constance.IS_FROM_SERVER_ORDER, false) ? order.getReal_name() : order.getPro_name());
            holder.productName.setText(order.getProduce_info().getServer_name());
            holder.productIcon.setImageResource(order.getProduce_info().getServer_id() == ProductInfo.VERSION_ID ? R.drawable.gold_version : R.drawable.cloud_pro);
            holder.priceText.setText(MoneyUtils.setMoney(getApplicationContext(), "¥ " + Utils.m2(order.getProduce_info().getPrice())));
            holder.unitText.setText(order.getProduce_info().getUnits());
            holder.productTotal.setText(MoneyUtils.setMoney(getApplicationContext(), "¥ " + Utils.m2(order.getAmount())));
            holder.payBtn.setVisibility(order.getOrder_status() == 1 ? View.VISIBLE : View.GONE);
            holder.payBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int type = order.getOrder_type();
                    switch (type) {
                        case 1: //购买黄金版本
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 2: //续费黄金
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 3: //购买云盘
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                        case 4: //续费云盘
                            OrderDeatilActivity.actionStart(MyOrderListActivity.this, order);
                            break;
                    }
                }
            });
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                orderNumber = (TextView) convertView.findViewById(R.id.orderNumber);
                address = (TextView) convertView.findViewById(R.id.address);
                productIcon = (ImageView) convertView.findViewById(R.id.productIcon);
                productName = (TextView) convertView.findViewById(R.id.productName);
                priceText = (TextView) convertView.findViewById(R.id.priceText);
                unitText = (TextView) convertView.findViewById(R.id.unitText);
                productTotal = (TextView) convertView.findViewById(R.id.productTotal);
                payBtn = convertView.findViewById(R.id.payBtn);
            }


            /**
             * 订单编号
             */
            TextView orderNumber;
            /**
             * 地址
             */
            TextView address;
            /**
             * 产品图片
             */
            ImageView productIcon;
            /**
             * 产品名称
             */
            TextView productName;
            /**
             * 产品金额
             */
            TextView priceText;
            /**
             * 产品购买人数
             */
            TextView unitText;
            /**
             * 产品总价
             */
            TextView productTotal;
            /**
             * 产品是否已支付
             */
            View payBtn;
        }

        public void updateList(List<Order> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public void addList(List<Order> list) {
            this.list.addAll(list);
            notifyDataSetChanged();
        }

        public List<Order> getList() {
            return list;
        }

        public void setList(List<Order> list) {
            this.list = list;
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
