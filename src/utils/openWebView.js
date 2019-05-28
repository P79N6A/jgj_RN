// 跳转H5页面
import { NativeModules, Platform } from 'react-native'

export default function(url,query={}){
	// let params = new URLSearchParams('')
	// for(let k in query){
	// 	params.append(k, query[k])
	// }
	// params = params.toString()
	// if(params.length){
	// 	url += '?'+params
	// }
	let str=''
	for(let k in query){
		str+=`${k}=${query[k]}&`
	}
	if(str.length){
		url += '?'+str
	}
	console.log(url)
	if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {
		NativeModules.MyNativeModule.openWebView(url)
	}
	if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
		NativeModules.JGJRecruitmentController.openWebView(url)
	}
}