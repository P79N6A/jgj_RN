package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.bean.AddInfoBean;
import com.jizhi.jlongg.main.util.DecimalInputFilter;

import org.apache.poi.ss.formula.functions.T;

import java.util.HashMap;
import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AllAccountAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AccountAllWorkBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private AllAccountListener allAccountListener;
    private Context context;
    HashMap<Integer, String> countMap;//这个集合用来存储对应位置上Editext中的文本内容
    HashMap<Integer, String> priceMap;//这个集合用来存储对应位置上Editext中的文本内容


    public AllAccountAdapter(Context context, List<AccountAllWorkBean> list, AllAccountListener allAccountListener) {
        super();
        this.list = list;
        this.context = context;
        this.allAccountListener = allAccountListener;
        inflater = LayoutInflater.from(context);
        countMap = new HashMap<>();
        priceMap = new HashMap<>();
    }

    public void setList(List<AccountAllWorkBean> list) {
        this.list = list;

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
        AccountAllWorkBean bean = list.get(position);
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_all_account, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.ed_sub_price.setTag(position);
        holder.ed_count.setTag(position);

        setEditTextDecimalNumberLength(holder.ed_sub_price, 7, 2);
        setEditTextDecimalNumberLength(holder.ed_count, 6, 2);

        convertView.findViewById(R.id.rea_top).setVisibility(list.size() > 1 ? View.VISIBLE : View.GONE);
        convertView.findViewById(R.id.rea_top_10px).setVisibility(list.size() <= 1 ? View.VISIBLE : View.GONE);
        holder.tv_num.setText(list.size() <= 1 ? "#1" : "#" + (position + 1));
        holder.tv_sub_name_left.setText(list.size() <= 1 ? "分项名称" : "分项名称" + (position + 1));
        holder.ed_count.setText(TextUtils.isEmpty(countMap.get(position)) ? "" : countMap.get(position) + "");
        holder.ed_sub_price.setText(TextUtils.isEmpty(priceMap.get(position)) ? "" : priceMap.get(position) + "");
//        holder.tv_salary_price.setText(TextUtils.isEmpty(priceMap.get(position)) ? "" : priceMap.get(position) + "");
        holder.tv_delete_sub.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                allAccountListener.deleteSubProject(position);
            }
        });
        holder.rea_sub_name.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //删除分项
                allAccountListener.selectSubProject(position);
            }
        });
        holder.rea_sub_name.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //选择分项名称
                allAccountListener.selectSubProject(position);
            }
        });
        holder.lin_company.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //选择单位
                allAccountListener.selectCompany(position);
                LUtils.e(new Gson().toJson(countMap));
                LUtils.e(new Gson().toJson(priceMap));
            }
        });
        holder.tv_sub_name.setText(null != bean.getSub_pro_name() ? bean.getSub_pro_name() : "");
        holder.tv_company.setText(null != bean.getUnits() ? bean.getUnits() : "");
        setEditTextChange(holder.ed_sub_price, position, false);
        setEditTextChange(holder.ed_count, position, true);
        setFocusEdit(holder.ed_sub_price, position);
        setFocusEdit(holder.ed_count, position);
        return convertView;
    }

    int index = -1;


    class ViewHolder {
        public ViewHolder(View convertView) {
            tv_delete_sub = convertView.findViewById(R.id.tv_delete_sub);
            tv_sub_name = convertView.findViewById(R.id.tv_sub_name);
            ed_sub_price = convertView.findViewById(R.id.ed_sub_price);
            tv_sub_name_left = convertView.findViewById(R.id.tv_sub_name_left);
            ed_count = convertView.findViewById(R.id.ed_count);
            tv_salary_price = convertView.findViewById(R.id.tv_salary_price);
            tv_company = convertView.findViewById(R.id.tv_company);
            lin_company = convertView.findViewById(R.id.lin_company);
            rea_sub_name = convertView.findViewById(R.id.rea_sub_name);
            tv_num = convertView.findViewById(R.id.tv_num);
        }

        //删除分项名称
        TextView tv_delete_sub;
        //编号
        TextView tv_num;
        //分项名称,分项名称左边编号
        TextView tv_sub_name, tv_sub_name_left;
        //分项单价
        EditText ed_sub_price;
        //分项数量
        EditText ed_count;
        //分项工钱
        TextView tv_salary_price;
        //单位
        TextView tv_company;
        //单位布局
        LinearLayout lin_company;
        //分享名称布局
        RelativeLayout rea_sub_name;

    }

    public void setEditTextChange(final EditText editText, final int position, final boolean isCount) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (isCount) {
                    Integer tag = (Integer) editText.getTag();
                    countMap.put(tag, s.toString());//在这里根据position去保存文本内容
//                    allAccountListener.inputCount(countMap.get(position), position);
                } else {
                    Integer tag = (Integer) editText.getTag();
                    priceMap.put(tag, s.toString());//在这里根据position去保存文本内容
//                    allAccountListener.inputPrice(priceMap.get(position), position);
                }
            }
        });
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param length        小数点前面位数
     * @param decimal_place 小数点后面位数
     */
    public void setEditTextDecimalNumberLength(EditText editText, int length, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(length, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }

    }

    /**
     * 解决liview中edittext弹出键盘焦点失去问题
     *
     * @param editText
     * @param position
     */
    public void setFocusEdit(EditText editText, final int position) {
//        editText.setTag(position);
//        editText.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//                if (event.getAction() == MotionEvent.ACTION_UP) {
//                    // 在TOUCH的UP事件中，要保存当前的行下标，因为弹出软键盘后，整个画面会被重画
//                    // 在getView方法的最后，要根据index和当前的行下标手动为EditText设置焦点
//                    index = position;
//                }
//                return false;
//            }
//        });
//        editText.clearFocus();
//        // 如果当前的行下标和点击事件中保存的index一致，手动为EditText设置焦点。
//        if (index != -1 && index == position) {
//            editText.requestFocus();
//        }
//        // 焦点移到最后
//        editText.setSelection(editText.getText().length());

    }

    public interface AllAccountListener {
        //删除分项
        void deleteSubProject(int position);

        //选择分项名称
        void selectSubProject(int position);

        //选择单位
        void selectCompany(int position);

        //输入单价
        void inputCount(String text, int position);

        //输入数量
        void inputPrice(String text, int position);
    }
}
