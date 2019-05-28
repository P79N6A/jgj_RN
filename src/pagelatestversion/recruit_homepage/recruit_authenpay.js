/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:07:30 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-29 16:08:05
 * Module:工人认证服务支付选择
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform,
     Image, ScrollView, ImageBackground,
	 NativeModules,
	 DeviceEventEmitter
     } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
// import sha1 from 'sha1';
import { Toast } from '../../component/toast'
import fetchFun from '../../fetch/fetch'

export default class pay extends Component {
    constructor(props) {
        super(props)
        this.state = {
			pay: 'wx',
			price:''
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
	})
	componentDidMount(){
		fetchFun.load({
            url: 'auth-info/get-price'
            , newApi: true
            , RefreshType: 1
            , data: {auth_type: this.props.navigation.state.params.role}
            , success: res => {
                this.setState({
                    price: res.price
                    , paying: false
                })
            }
        })
		this.role = this.props.navigation.state.params.role
	}
    // 选择微信
    wxfun() {
        this.setState({
            pay: 'wx'
        })
    }
    // 选择支付宝
    zfbfun() {
        this.setState({
            pay: 'zfb'
        })
    }
    render() {
		let { price } = this.state
        return (
            <View style={styles.main}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
							{`${this.role == 3 ? '支付费用' : (this.role == 2 ? '班组长认证服务' : '工人认证服务')}`}
						</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>认证审核费用说明</Text>
                </View>
                <View style={{ padding: 15, backgroundColor: '#fff', }}>
                    <View style={{ color: '#999', fontSize: 12, }}>
                        <Text style={{ flexDirection: 'row', alignItems: 'center', lineHeight: 30 }}>认证审核费用
                        <Text style={{ marginLeft: 7, marginRight: 7, color: '#000', fontSize: 30, }}> {price} </Text>
                            元一次，可享受一年的认证特权，平台会在5个工作日内进行审核
                        </Text>
                    </View>
                    {/* 框 */}
                    <View style={{ borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, marginTop: 16, backgroundColor: '#fafafa', padding: 10 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                            <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text><Text style={{ color: '#eb4e4e', fontSize: 12, }}>认证服务购买后不可退回</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                            <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text><Text style={{ color: '#eb4e4e', fontSize: 12, }}>认证服务到期后特权失效</Text>
                        </View>
                    </View>
                </View>
                {/* 支付方式 */}
                <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付方式</Text>
                </View>
                {/* 选择支付方式 */}
                <View style={{ backgroundColor: "#fff", padding: 15 }}>
                    <View style={{ backgroundColor: '#f1f1f1', borderRadius: 4, paddingLeft: 10, paddingRight: 10 }}>
                        {/* 微信 */}
                        <TouchableOpacity activeOpacity={.7}  onPress={() => this.wxfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Icon style={{marginRight: 21}} name="wechat" size={32} color="#4EB52E" />
                                <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>微信支付</Text>
                            </View>
                            {
                                this.state.pay == 'wx' ? (
                                    <Icon name="success" size={19} color="#eb4e4e" />
                                ) : (
                                        <Image style={{ width: 19, height: 19 }} source={require('../../assets/recruit/yuan.png')}></Image>
                                    )
                            }
                        </TouchableOpacity>
                        {/* 虚线 */}
                        <View style={{ height: 1, borderRadius: 0.5, borderColor: 'rgb(219, 219, 219)', borderTopWidth: 1, borderStyle: 'dashed' }}></View>
                        {/* 支付宝 */}
                        <TouchableOpacity activeOpacity={.7}  onPress={() => this.zfbfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57, borderBottomStyle: 'dashed', }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Icon style={{marginRight: 21}} name="alipay" size={32} color="#00A9F1" />
                                <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付宝支付</Text>
                            </View>
                            {
                                this.state.pay == 'zfb' ? (
                                    <Icon name="success" size={19} color="#eb4e4e" />
                                ) : (
                                        <Image style={{ width: 19, height: 19 }} 
                                        source={require('../../assets/recruit/yuan.png')}></Image>
                                    )
                            }
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 支付按钮栏 */}
                <View style={{
                    backgroundColor: '#fff', height: 64, padding: 10, position: "absolute", bottom: 0, width: '100%', flexDirection: 'row', justifyContent: 'space-between',
                    alignItems: 'center'
                }}>
                    <View style={{ flexDirection: 'row', alignItems: "center" }}>
                        <Text style={{ color: '#3d4145', fontSize: 15 }}>订单金额：</Text>
                        <Text style={{ color: '#eb4e4e', fontSize: 16 }}>￥{price}</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} 
                    onPress={()=>this.appPay()}
                    style={{ width: 160, height: 42, backgroundColor: '#eb4e4e', flexDirection: "row", justifyContent: 'center', alignItems: 'center', borderRadius: 4 }}>
                        <Text style={{ color: '#fff', fontSize: 18 }}>立即支付</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    // 工人认证-立即支付
    appPay(){
        let payType = this.state.pay == 'wx'?1:2//支付方式(1：微信，2：支付宝)

		let record_id,
			manage = false,
			role = this.role
		/*
        if(this.state.pay == 'wx'){//微信
            record_id={
                // appid:"wx0d7055be43182b5e",
                // partnerid:"1487808312",
                // prepayid:"wx0516293006955939bbc739452402798626",
                // timestamp:"1557044970",
                // noncestr:"Vno4H7O69KN1xcic",
                // package:"Sign=WXPay",
                // sign:"56C0D7381BD29ABF3DA277648DD62AB3",
                // package_name:"Sign=WXPay"

                appid:"wx0d7055be43182b5e",//应用ID-微信开放平台审核通过的应用APPID
                partnerid:"1487808312",//商户号-微信支付分配的商户号
                prepayid:"wx0516293006955939bbc739452402798626",//预支付交易会话ID-微信返回的支付交易会话ID
                timestamp:parseInt((Date.parse(new Date()) + GLOBAL.timeDifference) / 1000),//时间戳
                noncestr:"Vno4H7O69KN1xcic",//随机字符串-不长于32位
                package:"Sign=WXPay",//扩展字段-暂填写固定值Sign=WXPay
                sign:sha1('OaxhSsnvFnRCUql53jVDUVVp26pQkYea' + parseInt((Date.parse(new Date()) + GLOBAL.timeDifference) / 1000)),//签名
                package_name:"Sign=WXPay"
            }
            console.log(record_id)
        }else{//支付宝
            record_id=`app_id=2017080708079970&method=alipay.trade.app.pay&format=JSON&charset=utf-8&sign_type=RSA2&version=1.0&notify_url=http%3A%2F%2Fnapi.test.jgjapp.com%2Fpay%2Fali-notify&timestamp=2019-05-07+10%3A46%3A09&sign=U1m9EbWDyFM%2Blyxu6HhW%2Fm2LYLTm2jO8K9vkRqL6ene%2F0zUybt5%2FqJ2lO72Oj%2BtK48k9ZhqmD6RgdGx4tHiARwAxL9YrGEsbhFHTnkrXx%2BRl1oYdkB698yxI7HjfSUOZdf9QTOPwrN0JXcgCenzvqI%2BD11oI2oOxOUOuAxLCBsQJFSVC9EEJbbOHp4sWtl7owKqhdbxNSJ62EJmSzoaE0Y7Wr2yUZlSFCaiBtRgLb%2F015xtZmOedifb2MTzzwuZp2MWEcSGSKy7vOtNLA9WvcWIWQ5f1VlbZOQwlCTTqedob0XD%2FHovzn4N8qShMmyyNuNgVMSbnJAgHUZLLAsA6RA%3D%3D&biz_content=%7B%22out_trade_no%22%3A%22201905339303454%22%2C%22total_amount%22%3A0.01%2C%22subject%22%3A%22%5Cu5de5%5Cu4eba%5Cu6216%5Cu73ed%5Cu7ec4%5Cu8ba4%5Cu8bc1%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D`
		}
		*/
		let callback = (err) => {
            if (err) {
                this.setState({
                    paying: false
                });

                return null;
            }

			Toast.show('支付成功')
            setTimeout(() => {
				DeviceEventEmitter.emit('updateAuthen', '')
                this.props.navigation.goBack()
            }, 500);
        }

		let returnBack = (err, res) => {
            if ( callback instanceof Function ) {
                if ( err ) {
                    callback('支付失败');
                    return null;
                }

                if ( res.state === 1 )
                    callback(null, res);
                else
                    callback('支付失败');
            }
        };
		// 请求支付接口
		fetchFun.load({
			url: manage ? 'v2/Pay/payAuthData' : role == 3 ? 'auth-info/commando-pay' : 'auth-info/pay-commit'
			, newApi: !manage
			, data: {
				auth_type: role,
				pay_type: payType// this.state.payCode
			},
			success: res => {
				let notice = {
					record_id: res.record_id
					, pay_type: payType//this.state.payCode
				};

				console.log(res);
				// 调用原生支付
				// GLOBAL.jsBridge(bridge => {
				// 	bridge.callHandler('appPay', notice, call => {
				// 		returnBack(null, JSON.parse(call))
				// 	});
				// });
				// let payobj = {
				// 	record_id:this.state.pay == 'wx'?(JSON.stringify(record_id)):record_id,
				// 	pay_type:payType,//支付方式
				// }
				// console.log(payobj)
				if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
					NativeModules.MyNativeModule.appPay(JSON.stringify(notice), (result) => {
						console.log(result)
						returnBack(null, JSON.parse(result))
					});//调用原生方法
				}
                if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
                    NativeModules.JGJRecruitmentController.appPay(JSON.stringify(notice), (result) => {
                        returnBack(null, JSON.parse(result))
                    });//调用原生方法
                }
			}
			, error: err => {
				Toast.show('支付失败')
				returnBack(err)
			}
		})
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb'
    }
})