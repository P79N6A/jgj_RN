import React, { Component } from 'react'
import { Platform, StyleSheet, Text, View, Button, TouchableOpacity, StatusBar, ScrollView } from 'react-native'

export default class Index extends Component {
	static navigationOptions = {
		title: 'Home',
	}
	componentDidMount() {
		// 顶部通知栏样式
		this._navListener = this.props.navigation.addListener('didFocus', () => {
			StatusBar.setBarStyle('light-content');
			StatusBar.setBackgroundColor('#1296db');
		});
	}
	componentWillUnmount() {
		this._navListener.remove();
	}
	render() {
		const { navigate } = this.props.navigation
		return (
			<View style={styles.container}>
				<ScrollView 
				contentContainerStyle={{ paddingTop: 100, paddingBottom: 100, width: '100%' }}
				onScrollEndDrag ={()=>this.onScrollEndDrag ()}
				>
					<Text style={styles.welcome}>首页信息</Text>
					{/* 自定义按钮 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('My')}>
							<Text style={{ color: 'white' }}>TouchableOpacity to MY</Text>
						</TouchableOpacity>
					</View>
					{/* 选项卡 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('Options')}>
							<Text style={{ color: 'white' }}>选项卡</Text>
						</TouchableOpacity>
					</View>
					{/* 时间 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('Time')}>
							<Text style={{ color: 'white' }}>时间选择器</Text>
						</TouchableOpacity>
					</View>
					{/* 上传图片 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('Upload')}>
							<Text style={{ color: 'white' }}>上传图片</Text>
						</TouchableOpacity>
					</View>
					{/* 下拉刷新PullList */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('PullList')}>
							<Text style={{ color: 'white' }}>下拉刷新PullList</Text>
						</TouchableOpacity>
					</View>
					{/* 下拉刷新flatlist */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('Flatlist')}>
							<Text style={{ color: 'white' }}>下拉刷新flatlist</Text>
						</TouchableOpacity>
					</View>
					{/* 测试 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn} onPress={() => navigate('Inputbg')}>
							<Text style={{ color: 'white' }}>输入框背景图</Text>
						</TouchableOpacity>
					</View>
					{/* 按钮事件 */}
					<View style={styles.viewBtn}>
						<TouchableOpacity style={styles.btn}
							onPressIn={() => this.onPressIn()}
							onPressOut={() => this.onPressOut()}
							onLongPress={() => this.onLongPress()}
							onPress={() => this.onPress()}>
							<Text style={{ color: 'white' }}>点击按钮</Text>
						</TouchableOpacity>
					</View>
				</ScrollView>
			</View>
		)
	}
	onScrollEndDrag (){
		alert('onScrollEndDrag ')
	}
	onPressIn() {
		alert('onPressIn')
	}
	onPressOut() {
		alert('onPressOut')
	}
	onLongPress() {
		alert('onLongPress')
	}
	onPress() {
		alert('onPress')
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: '#F5FCFF',
	},
	welcome: {
		fontSize: 20,
		textAlign: 'center',
		margin: 10,
	},
	viewBtn: {
		alignItems: 'center',
		justifyContent: 'center',
		height: 50,
		marginBottom: 20
	},
	btn: {
		backgroundColor: '#1296db',
		width: 200,
		height: 40,
		borderRadius: 3,
		alignItems: 'center',
		justifyContent: 'center',
	},
})