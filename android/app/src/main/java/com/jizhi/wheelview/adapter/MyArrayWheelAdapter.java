/*
 *  Copyright 2011 Yuri Kanivets
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.jizhi.wheelview.adapter;

import java.util.List;

import android.content.Context;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CityInfoMode;

/**
 * The simple Array wheel adapter
 *
 * @param <T>
 *            the element type
 */
public class MyArrayWheelAdapter extends AbstractWheelTextAdapter {

	private List<CityInfoMode> list;

	public MyArrayWheelAdapter(Context context, List<CityInfoMode> list,int currentItem, int maxsize, int minsize) {
		super(context, R.layout.item_birth_year,NO_RESOURCE, currentItem,maxsize, minsize);
		this.list = list;
		setItemTextResource(R.id.tempValue);
	}

	@Override
	public CharSequence getItemText(int index) {
		if (index >= 0 && index < list.size()) {
			String item = list.get(index).getCity_name();
			if (item instanceof CharSequence) {
				return item;
			}
			return item.toString();
		}
		return null;
	}

	@Override
	public int getItemsCount() {
		return list.size();
	}
}
