
import { NativeModules, Platform } from 'react-native'
// 显示/隐藏底部
// state : [show,hide]
function footerController(state='show'){
	if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {
		NativeModules.MyNativeModule.footerController(JSON.stringify({ state }))
	}else if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
		NativeModules.JGJRecruitmentController.footerController({ state })
	}
}

export {
	footerController
}