import sha1 from 'sha1';
import {Alert, Platform, AsyncStorage,NativeModules} from 'react-native';
import {Toast, Loading} from '../component/toast';

// Fetch封装
export default class fetchFun {
    static loading(type) {
        if (type == "open") GLOBAL.ajaxIndex++;
        else GLOBAL.ajaxIndex--;
        if (type == "open" && GLOBAL.ajaxIndex == 1) {
            Loading.show();
        }
        if (GLOBAL.ajaxIndex == 0) {
            Loading.hidden();
        }
    }

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
        GLOBAL.newUrl=url;
        let _this = this
        if (typeof url === 'object') {
            options = url;
            url = false;
        }
        if(!options.completeUrl){//是否是完整URL

            // ======================
            // options.data.os= !options.data.os?GLOBAL.userinfo.os:options.data.os
            // options.data.token= !options.data.token?GLOBAL.userinfo.token:options.data.token
            // options.data.ver= !options.data.ver?GLOBAL.ver:options.data.ver
            // options.data.client_type= !options.data.client_type?GLOBAL.client_type:options.data.client_type//平台类型 person 个人端 manage 管理端
            // options.data.timestamp= !options.data.timeDifference?parseInt((Date.parse(new Date()) + GLOBAL.timeDifference) / 1000):options.data.timeDifference
            // options.data.sign= !options.data.sign?sha1('OaxhSsnvFnRCUql53jVDUVVp26pQkYea' + options.data.timestamp):options.data.sign;
            // ======================

            options.data.os= GLOBAL.userinfo.os
            options.data.token= GLOBAL.userinfo.token
            options.data.ver= GLOBAL.ver
            options.data.client_type= GLOBAL.client_type//平台类型 person 个人端 manage 管理端
            options.data.timestamp= parseInt((Date.parse(new Date()) + GLOBAL.timeDifference) / 1000)
			options.data.sign= sha1('OaxhSsnvFnRCUql53jVDUVVp26pQkYea' + options.data.timestamp);
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
            url = options.newApi? GLOBAL.newApiUrl+url:GLOBAL.apiUrl + url;
        }

        options = Object.assign({
            loading: true,  //是否显示默认的加载动画，默认 true
            type: 'POST'
        }, options);

        if (options.loading) {
            if(!options.noLoading){
                this.loading("open");
            }
        }

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
        // console.log('formData参数---',formData)
        // console.log(url)
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
                console.log('接口走通---',res)
                if (options.loading) {
                    if(!options.noLoading){
                        this.loading("hide");
                    }
                }
                if (options.completeUrl) {//外部
                    options.success && options.success(res);
                    return;
                }
				let code = (res.code || Number(res.code) === 0) ? res.code : (res.state != 1 ? res.errno : 0)
                code = Number(code);
                if(code == 10035){//失效
                    if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                        NativeModules.MyNativeModule.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind=='my') {//android个人端
                        NativeModules.JGJMineViewController.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind=='recruit') {//android个人端
                        NativeModules.JGJRecruitmentController.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind=='find') {//android个人端
                        NativeModules.JGJDiscoveryController.login();
                    }
                }else{
                    if (code !== 0) {//不是正确返回
                        let errmsg = res.errmsg;
                        if (!errmsg) errmsg = options.type == "POST" ? "数据提交失败" : "数据获取失败";
                        if (!options.notErr) {
                            Toast.show(errmsg);
                            if(code==1001){
                                GLOBAL.userInfo = {};
                                delete GLOBAL.userinfo.token;
                                // AsyncStorage.removeItem("userInfo");
                                // NavigationService.navigate("Login");
                            }
                        }
                        options.error && options.error({code: code, msg: errmsg, data: res.data});
                        return {code: code, msg: errmsg, data: res.data}
                    }
                }
                // const thisTime = Date.parse(new Date());//时间
                // GLOBAL.timeDifference = (res.serverTime * 1000 - thisTime);
				// AsyncStorage.setItem("timeDifference", JSON.stringify(GLOBAL.timeDifference));
				options.success && options.success(res.values||res.result);
				return res.values||res.result
            })
            .catch((error) => {
                console.log(error)
                if (options.loading) {
                    if(!options.noLoading){
                        this.loading("hide");
                    }
                }
				options.error && options.error({ code: -1, msg: '网络连接失败，请重试' +`${options.notErr}`})
				return error
            })
    }

}
