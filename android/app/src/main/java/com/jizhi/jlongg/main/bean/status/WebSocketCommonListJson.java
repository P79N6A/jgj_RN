package com.jizhi.jlongg.main.bean.status;

import com.google.gson.Gson;
import com.jizhi.jlongg.main.bean.WebSocketRequest;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;

/**
 * 集合的基类
 *
 * @param <T>
 * @author Xuj
 * @time 2016-2-2 10:30:33
 * @Version 1.0
 */
public class WebSocketCommonListJson<T> extends WebSocketRequest {

    /**
     * 数据
     */
    private List<T> values;

    public List<T> getValues() {
        return values;
    }


    public void setValues(List<T> values) {
        this.values = values;
    }

    public static WebSocketCommonListJson fromJson(String json, Class clazz) {
        Gson gson = new Gson();
        Type objectType = type(WebSocketCommonListJson.class, clazz);
        return gson.fromJson(json, objectType);
    }

    public String toJson(Class<T> clazz) {
        Gson gson = new Gson();
        Type objectType = type(WebSocketCommonListJson.class, clazz);
        return gson.toJson(this, objectType);
    }

    static ParameterizedType type(final Class raw, final Type... args) {
        return new ParameterizedType() {
            public Type getRawType() {
                return raw;
            }

            public Type[] getActualTypeArguments() {
                return args;
            }

            public Type getOwnerType() {
                return null;
            }
        };
    }

    @Override
    public String toString() {
        return "WebSocketCommonListJson{" +
                "values=" + values +
                '}';
    }
}
