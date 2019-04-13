import {Alert} from 'react-native';
import sha1 from 'sha1';

// Fetch封装
export default class fetchFun {

    /**
     * AJAX请求
     * @param url                       url地址，可以通过 options.url 传值，当同时存在时 url 优先
     * @param options                   Ajax的请求参数 {}
     *        options.url               Ajax请求的Url地址,跟 url 同时存在时 url 优先
     *        options.data              Ajax发送到服务器的数据
     *        options.type              Ajax发送到服务器的方式
     *        options.loading           是否显示默认的加载动画，默认 true
     *        options.success           成功回调方法
     *        options.error             失败回调方法
     *        options.complete          完成后调用
     *        options.notErr            不提示错误 默认假
     *
     *        GLOBAL                    全局变量，只有在 app.js 文件中需要传
     *
     * requestTask.abort() // 取消请求任务
     * @Author: Andy
     * @constructor
     */

    // 把对象转成URL的连接符
    static urlEncode(param, key, encode) {
        if (param == null) return '';
        let paramStr = '', t = typeof (param);
        if (t == 'string' || t == 'number' || t == 'boolean') {
            paramStr += key + '=' + ((encode == null || encode) ? encodeURIComponent(param) : param);
        } else {
            for (let i in param) {
                let k = key == null ? i : key + (param instanceof Array ? '[' + i + ']' : '.' + i);
                if (paramStr) paramStr += '&';
                paramStr += this.urlEncode(param[i], k, encode);
            }
        }
        return paramStr;
    };

    static load(url, options) {
        let _this = this
        if (typeof url === 'object') {
            options = url;
            url = false;
        }
        if(!options.completeUrl){//是否是完整URL
            options.data.os= GLOBAL.os
            options.data.token= GLOBAL.userinfo.token
            options.data.ver= GLOBAL.ver
            options.data.client_type= GLOBAL.client_type//平台类型 person 个人端 manage 管理端
            options.data.timestamp= parseInt((Date.parse(new Date()) + GLOBAL.timeDifference) / 1000)
            options.data.sign= sha1(GLOBAL.userinfo.token + options.data.timestamp);
        }
        
        options = options || {}

        if (url) {
            options.url = url;
        } else {
            url = options.url;
        }

        if (!options.data) {
            options.data = {}
        }
        //设置拼接完整的URL
        if(!options.completeUrl){//是否是完整URL
            url = GLOBAL.apiUrl + url;
        }

        options = Object.assign({
            type: 'POST'
        }, options);

        // 设置参数：new一个对象formData存储参数
        let formData;
        if (options.type == 'GET') {//请求方式
            url += '?' + this.urlEncode(options.data);
        } else {
            formData = new FormData();
            for (let i in options.data) {
                formData.append(i, options.data[i]);
            }
        }
        console.log('formData参数---',formData)
        // 设置请求函数
        return fetch(url,
            {
                method: options.type,
                headers: options.type == 'POST' ? {
                    'Content-Type': 'multipart/form-data'
                } : {},
                body: options.type == 'POST' ? formData : ""
            })
            .then((response) => response.json())
            .then((res) => {
                // console.log('接口走通---',res)
                options.success && options.success(res)
            })
            .catch((error) => {
                console.log(error)
                if (!options.notErr) {
                    Alert.alert(
                        '网络连接失败，请重试',
                        null,
                        [
                            { text: '取消', style: 'cancel' },
                            { text: '重试', onPress: () => _this.load(options) },
                        ]
                    )
                }
                // options.error && options.error({ code: -1, msg: '网络连接失败，请重试' })
            })
    }

}
