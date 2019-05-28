/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:00:02 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-19 10:11:47
 * Module:认证服务
 */


import React, { Component } from 'react'
import {
	StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, TouchableNativeFeedback,
	NativeModules, DeviceEventEmitter
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'

import Attest from './recruit_authen/index'

export default class authen extends Component {
	constructor(props) {
		super(props)
		this.state = {
			isYes: true,
			isalert: false,//弹框
			detail: {},
			initLoad: false
		}
		this.getDetail = this.getDetail.bind(this)
	}
	// 顶部导航
	static navigationOptions = ({ navigation, screenProps }) => ({
		header: null, gesturesEnabled: false,
	});
	// 点击是否勾选按钮
	clickGx() {
		this.setState({
			isYes: !this.state.isYes
		})
	}
	// 点击认证按钮
	clickRz() {
		if (!this.state.isYes) {
			this.setState({
				isalert: !this.state.isalert
			})
			//弹窗自动关闭
			setTimeout(() => {
				this.setState({
					isalert: false
				})
			}, 2000)
		} else {
			this.props.navigation.navigate('Recruit_authenpay', { role: this.props.navigation.state.params.type })
		}
	}
	// 弹窗关闭开关
	alertfun() {
		this.setState({
			isalert: !this.state.isalert
		})
	}

	getDetail() {
		console.log(this.props.navigation.state)
		fetchFun.load({
			newApi: true,
			url: 'auth-info/get-detail',
			data: {
				auth_type: this.props.navigation.state.params.type //GLOBAL.userinfo.role
			},
			success: (res) => {
				console.log('res', res)
				this.setState({
					detail: res,
					initLoad: true
				})
			}
		})
	}
	updateDetail(res) {
		this.setState({
			detail: res
		})
	}

	componentDidMount() {
		// 底部导航控制
		this.bottomTab()

		this.getDetail()
		this.subscription = DeviceEventEmitter.addListener('updateAuthen', this.getDetail)
	}
	componentWillUnmount() {
		if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
			this.subscription.remove()
		}
    }
	// 底部导航控制
	bottomTab() {
		if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
		}
		if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
		}
	}

	renderDefault(type) {
		let power = type == 1 ? [
			{ icon: 'match', title: '自动优先匹配工作', txt: '更多老板联系你' }
			, { icon: 'show', title: '平台为你做广告宣传', txt: '增加你的知名度' }
			, { icon: 'refresh', title: '名片可以无限刷新', txt: '让你的排名更靠前' }
			, { icon: 'logo', title: '你的身份特殊标识', txt: '让老板更信任你' }
			, { icon: 'service', title: '专属客服为你服务', txt: '招聘顾问随时咨询' }
		] :
			[
				{ icon: 'match', title: '优先匹配项目', txt: '获得更多找项目机会' }
				, { icon: 'show', title: '推荐为优质班组长', txt: '获得更多展示机会' }
				, { icon: 'refresh', title: '名片无限刷新', txt: '提升被查看次数' }
				, { icon: 'logo', title: '平台认证标识', txt: '专属身份特别展示' }
				, { icon: 'service', title: '专属客服', txt: '招聘顾问为你服务' }
			];

		return (
			power.map((item, idx) => {
				return (
					<View key={idx} style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 10, justifyContent: 'center' }}>
						<Text style={styles.num}>{++idx}</Text>
						<Text style={styles.tit}>{item.title}</Text>
						<Text style={styles.font}>{item.txt}</Text>
					</View>
				)
			})
		)
	}

	render() {
		let { detail, initLoad } = this.state,
			type = this.props.navigation.state.params.type

		return (
			<>
				<View style={{
					height: 48, backgroundColor: '#FAFAFA', position: 'relative',
					flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
					borderBottomWidth: 1, borderBottomColor: '#ebebeb'
				}}>
					<TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
						onPress={() => { DeviceEventEmitter.emit("EventType", param), this.props.navigation.goBack(), this.props.navigation.state.params.callback() }}>
						<Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
						<Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
					</TouchableOpacity>
					<View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
						<Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>{type == 2 ? '班组长' : '工人'}认证服务</Text>
					</View>
					<TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
					</TouchableOpacity>
				</View>
				{initLoad && detail.id ?
					<Attest type={type} detail={detail} updateDetail={this.updateDetail} /> :
					//
					initLoad ?
						<View style={styles.containermain}>
							<ScrollView style={{ width: '100%', flex: 1, }}>
								<View style={{ flexDirection: "row", justifyContent: 'center' }}>
									<Image style={{ width: 360, height: 87, marginLeft: 20, marginRight: 20, marginTop: 8, marginBottom: 50 }}
										source={require('../../assets/recruit/at-top-slogan.png')}></Image>
								</View>
								{this.renderDefault(type)}
								<View style={{ flexDirection: "row", justifyContent: 'center', height: 150, position: 'relative' }}>
									<ImageBackground style={{ width: 378, height: 200, position: 'absolute', top: -50 }}
										source={require('../../assets/recruit/at-power-bg.3cdb07.png')}></ImageBackground>
								</View>
								<View style={{ width: '100%', height: 93, borderTopWidth: .5, borderTopColor: '#999', borderBottomWidth: .5, borderBottomColor: '#999', paddingTop: 22, paddingBottom: 22, flexDirection: 'row' }}>
									<View style={{
										width: '50%', borderRightWidth: .5, borderRightColor: '#999', flexDirection: 'row',
										justifyContent: 'center', alignItems: 'center'
									}}>
										<View>
											<Text style={{ fontSize: 14, color: '#666' }}>咨询热线</Text>
											<View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5 }}>
												<Icon style={{ marginRight: 7 }} name="tel" size={16} color="#CCCCCC" />
												<Text style={{ fontSize: 17, color: 'rgb(73, 144, 226)' }}>400-862-3818</Text>
											</View>
										</View>
									</View>
									<View style={{
										width: '50%', flexDirection: 'row',
										justifyContent: 'center', alignItems: 'center'
									}}>
										<View>
											<Text style={{ fontSize: 14, color: '#666' }}>认证服务客服专线</Text>
											<View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5 }}>
												<Icon style={{ marginRight: 7 }} name="tel" size={16} color="#CCCCCC" />
												<Text style={{ fontSize: 17, color: 'rgb(73, 144, 226)' }}>1858293097</Text>
											</View>
										</View>
									</View>
								</View>
								{/* 购买认证 */}
								<TouchableOpacity activeOpacity={.7} onPress={() => this.clickRz()} style={{ height: 42, marginTop: 10, marginBottom: 4, marginLeft: 10, marginRight: 10, backgroundColor: "#eb4e4e", borderRadius: 4, flexDirection: 'row', justifyContent: 'center', alignItems: 'center', }}>
									<Text style={{ color: 'white', fontSize: 18 }}>购买认证</Text>
								</TouchableOpacity>
								<TouchableOpacity activeOpacity={.7} onPress={() => this.clickGx()} style={{ marginrrTop: 6, marginBottom: 16, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
									{
										this.state.isYes ? (
											<Icon style={{ marginRight: 6 }} name="success" size={19} color="#eb4e4e" />
										) : (
												<Icon style={{ marginRight: 6 }} name="success" size={19} color="#999999" />
											)
									}
									<Text style={{ color: '#f18215', fontSize: 14 }}>我已同意《吉工家{type == 1 ? '工人' : '班组长'}认证服务条款》</Text>
								</TouchableOpacity>
							</ScrollView>
							{/* 弹框 */}
							{
								this.state.isalert ? (
									<TouchableOpacity activeOpacity={.7} 
										style={{
											width: 215, height: 145,
											backgroundColor: 'rgba(0,0,0,.7)',
											borderRadius: 4,
											position: 'absolute',
											top: '50%',
											paddingLeft: 20,
											paddingRight: 10,
											marginTop: -74
										}} onPress={() => this.alertfun()}>
										<View style={{ flexDirection: 'row', justifyContent: 'center', marginTop: 27, marginBottom: 22 }}>
											<Icon name="exclamation" size={35} color="#fff" />
										</View>
										<View style={{}}>
											<Text style={{ color: '#fff', fontSize: 16 }}>不同意吉工家工人认证服务条款，无法购买认证！</Text>
										</View>
									</TouchableOpacity>
								) : (<View></View>)
							}
						</View> :
						null
					// 
				}
			</>
		)
	}

}

const styles = StyleSheet.create({
	containermain: {
		flex: 1,
		backgroundColor: 'white',
		alignItems: 'center',
	},
	num: {
		color: 'rgb(243, 121, 71)',
		fontSize: 26,
		lineHeight: 30,
		fontWeight: '400',
		marginRight: 15,
	},
	tit: {
		marginRight: 12,
		fontWeight: '400',
		color: '#3d4145',
		fontSize: 16,
	},
	font: {
		color: '#3d4145',
		lineHeight: 30,
		fontSize: 12,
	},
})