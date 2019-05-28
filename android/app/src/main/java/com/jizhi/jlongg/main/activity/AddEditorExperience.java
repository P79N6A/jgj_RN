package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


/**
 * 编辑、添加项目经验
 * @author Xuj
 * @time 2016-11-28 17:47:42
 * @Version 1.0
 */
public class AddEditorExperience extends BaseActivity {

    private final int PROJECT_NAEM = 1; //项目名称
    private final int PROJECT_TIME = 2; //项目时间
    private final int AREA = 3; //项目区域
    private final int DESC = 4; //项目描述
    /**
     * 图片列表数据
     */
    private List<ImageItem> imageItems = new ArrayList<>();
    /**
     * 最多只能传9张图片
     */
    private int MAXPHOTOCOUNT = 9;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_experience);
        final List<ChatManagerItem> list = getData();
        ChatManagerAdapter adapter = new ChatManagerAdapter(this, list, null);
        ListView listView = (ListView) findViewById(R.id.listView);
        View photoView = getLayoutInflater().inflate(R.layout.gridview_no_head, null); // 加载对话框
        GridView gridView = (GridView) photoView.findViewById(R.id.gridView);
        gridView.setHorizontalSpacing(DensityUtils.dp2px(this, 1));
        gridView.setVerticalSpacing(DensityUtils.dp2px(this, 1));
        listView.addFooterView(photoView, null, false);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                ChatManagerItem item = list.get(position);
                switch (item.getMenuType()) {
                    case PROJECT_TIME: //项目名称
                        break;
                    case AREA: //项目区域
                        break;
                    case DESC: //项目描述
                        break;
                }
            }
        });


        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (position == imageItems.size()) { //选择相片
                    ArrayList<String> mSelected = selectedPhotoPath();
                    CameraPop.multiSelector(AddEditorExperience.this, mSelected, MAXPHOTOCOUNT - getNetPhotoCount());
                } else { //查看图片
                    Bundle bundle = new Bundle();
                    bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) imageItems);
                    bundle.putInt(Constance.BEAN_INT, position);
                    Intent intent = new Intent(AddEditorExperience.this, PhotoZoomActivity.class);
                    intent.putExtras(bundle);
                    startActivity(intent);
                }
            }
        });
    }

    /**
     * 本地图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {  //添加本地图片
                mSelected.add(item.imagePath);
            }
        }
        return mSelected;
    }

    /**
     * 获取网络图片个数
     */
    public int getNetPhotoCount() {
        int length = 0;
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            if (item.isNetPicture) {
                length += 1;
            }
        }
        return length;
    }


    private List<ChatManagerItem> getData() {
        List<ChatManagerItem> list = new ArrayList<>();
        ChatManagerItem item1 = new ChatManagerItem("项目名称", false, true, PROJECT_NAEM);
        ChatManagerItem item2 = new ChatManagerItem("项目时间", true, true, PROJECT_TIME);
        ChatManagerItem item3 = new ChatManagerItem("所在地区", true, true, AREA);
        ChatManagerItem item4 = new ChatManagerItem("经历描述", true, true, DESC);
        item1.setMenuHint("请输入项目名称");
        item1.setItemType(ChatManagerItem.EDITOR);
        item2.setMenuHint("请选择项目时间");
        item3.setMenuHint("请选择所在省市");
        item4.setMenuHint("主要描述在项目中的工作情况");
        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        return list;
    }


}