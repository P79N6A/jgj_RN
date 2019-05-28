package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.LinkedHashMap;

public class SerializableMap implements Serializable{
	private LinkedHashMap<String,ImageItem> map = new LinkedHashMap<String, ImageItem>();

	public LinkedHashMap<String, ImageItem> getMap() {
		return map;
	}

	public void setMap(LinkedHashMap<String, ImageItem> map) {
		this.map = map;
	}
}
