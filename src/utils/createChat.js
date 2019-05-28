import {NativeModules, Alert,Platform} from 'react-native'
import {Toast} from '../component/toast'
import fetchFun from '../fetch/fetch'

/**
 * 判断及发起聊聊
 * @param props                     带有redux的 react 组建的this.props
 * @param options                   参数 {}
 *        options.data              完善资料
 *                      uid            int    将要聊天对方的uid
 *                      telephone    int    手机号码，uid不存在时需传
 *                      is_find_job    int    1,是否是找工作聊天
 *        options.chatData          传递到APP的其它数据
 * 		  fn 回调函数
 * @Author: Andy
 * @constructor
 */
export default function (options,fn) {
    console.log('聊聊',options);
    // if (!isAppAct(props)) return false;
    // if ((GLOBAL.appVerNum < 212 && GLOBAL.plat == "person") || (GLOBAL.appVerNum < 112 && GLOBAL.plat == "manage")) {
    //     props.SynData({
    //         isShow: true,
    //         text: <div className="modal-text tc-333333">
    //             升级到最新版本,即可操作!
    //         </div>
    //         ,
    //         mold: "confirm",
    //         custom: {
    //             notCancel: true,
    //             clickTitle: "我知道了"
    //         },
    //     }, "SYN_REMINDER");
    //     return false;
	// }
	/*
    if (!isUserInfo(props, {realName: true})) {
        return false;
	}
	*/

    //创建聊聊
    function appCreateChat(data) {
		let obj = {
			"class_type": "singleChat",
			"group_id": data.uid,
			"group_name": data.real_name,
			"is_chat": options.data.is_find_job ? 1 : data.is_chat
		}
		console.log('createChat data',Object.assign(obj,options.chatData))
		if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.MyNativeModule.createChat(JSON.stringify(Object.assign(obj,options.chatData)))
		}
		if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
			NativeModules.JGJRecruitmentController.createChat(JSON.stringify(Object.assign(obj,options.chatData)))
		}
		/*
        if (GLOBAL.appVer) {
            GLOBAL.jsBridge((bridge) => {
                bridge.callHandler('createChat', $.extend(true, {
                    "class_type": "singleChat",
                    "group_id": data.uid,
                    "group_name": data.real_name,
					"is_chat": options.data.is_find_job ? 1 : data.is_chat
                }, options.chatData),(data)=>{
					fn(data)
				});
            })
		}
		*/
        // console.log($.extend(true, {
        //     "class_type": "singleChat",
        //     "group_id": data.uid,
        //     "group_name": data.real_name,
        //     "is_chat": options.data.is_find_job ? 1 : data.is_chat
        // }, options.chatData));
    }

    //删除自已的黑名单
    function removeBlacklist(data) {
		fetchFun.load({
            url: 'v2/dynamic/removeBlackList',
            data: {
                uid: data.uid
            },
            success: (res) => {
                chatCall()
            }
        })
    }

    //判断是否可以聊天
    function chatCall() {
		// #20341【招聘】从招工详情页，和从工人/班组里面找到自己的账号，自己和自己是可以聊天的，而且也可以拨打电话，目前提示的是"不能和自己聊天"
		/*
		if (options.data.uid && options.data.uid == GLOBAL.userinfo.uid) {
			Toast.show('不能和自己聊天')
            // props.SynData({
            //     isShow: true,
            //     text: "不能和自己聊天",
            //     type: "fail"
            // }, "SYN_REMINDER");
            return;
		}
		*/
		fetchFun.load({
            url: 'v2/dynamic/canChat',
            data: options.data,
            success: (data) => {
                if (data.statu_code == 0) {
					/*
					if (data.uid == GLOBAL.userinfo.uid) {
						Toast.show('不能和自己聊天')
						return;
					}
					*/
					data.is_chat = 1;
					appCreateChat(data);
					return;
				}
				else {
					if (data.statu_code == 1) {
						Alert.alert(
							'你是否要将TA移除黑名单，并开始聊天',
							null,
							[
								{ text: '否', style: 'cancel' },
								{ text: '是', onPress: () => removeBlacklist(data) },
							]
						)
						// props.SynData({
						// 	isShow: true,
						// 	text: "你是否要将TA移除黑名单，并开始聊天",
						// 	mold: "confirm",
						// 	custom: {
						// 		clickTitle: "是",
						// 		cancelTitle: "否"
						// 	},
						// 	callback: () => {
						// 		removeBlacklist(data);
						// 	}
						// }, "SYN_REMINDER");
						return;
					}
					/*
					if (data.statu_code == 3 || data.uid == GLOBAL.userinfo.uid) {
						Toast.show('不能和自己聊天')
						return;
					}
					*/
					if (data.statu_code == 2) {
						Toast.show(`对方暂时不想和你聊天${options.data.is_find_job == 1 ? '，请尝试电话联系' : ''}`)
						return;
					}
				}
				data.is_chat = 0;
				appCreateChat(data);
            }
        })
    }

    return chatCall();
}