import React, { Component, /*useState*/ } from 'react'
import { Platform, StyleSheet, Text, View, Button, TouchableOpacity, StatusBar } from 'react-native'
import ModalDropdown from 'react-native-modal-dropdown';

export default class Select extends Component {
	constructor(props) {
		super(props);
		this.state = {
			TabChoose: 'LianXi',
			sja: true,
			sjb: false,
			sjc: false,
			///////
			isshow: false,
			dropDown_box: false,   // 下拉菜单 显隐状态
			dropDown_box_Text: '全部' // 传值
		}
	}
	render() {
		return (
			<View style={styles.container}>
				{/* 选项卡 */}
				<View style={styles.TabControl}>
					<TouchableOpacity style={styles.TabControlItem} onPress={() => this.TabChooseToggleFun('LianXi')}>
						<Text style={{ color: this.state.TabChoose === 'LianXi' ? '#3399ff' : '#2c2c2c' }}>章节练习</Text>
						{this.showfuna()}
					</TouchableOpacity>
					<View style={styles.borders}></View>
					<TouchableOpacity style={styles.TabControlItem} onPress={() => this.TabChooseToggleFun('ZhenTi')}>
						<Text style={{ color: this.state.TabChoose === 'ZhenTi' ? '#3399ff' : '#2c2c2c' }}>历年真题</Text>
						{this.showfunb()}
					</TouchableOpacity>
					<View style={styles.borders}></View>
					<TouchableOpacity style={styles.TabControlItem} onPress={() => this.TabChooseToggleFun('CePing')}>
						<Text style={{ color: this.state.TabChoose === 'CePing' ? '#3399ff' : '#2c2c2c' }}>考试测评</Text>
						{this.showfunc()}
					</TouchableOpacity>
				</View>
				<View style={styles.bgsty}></View>
				{/* 选项卡面板 */}
				{this.TabChooseTogglePanelFunWrap()}
			</View>
		)
	}
	showfuna() {
		if (this.state.sja) {
			return (
				<View>
					<View style={styles.sj}><View style={styles.tabsj}></View></View>
					<View style={styles.tabbot}></View>
				</View>
			)
		}
	}
	showfunb() {
		if (this.state.sjb) {
			return (
				<View>
					<View style={styles.sj}><View style={styles.tabsj}></View></View>
					<View style={styles.tabbot}></View>
				</View>
			)
		}
	}
	showfunc() {
		if (this.state.sjc) {
			return (
				<View>
					<View style={styles.sj}><View style={styles.tabsj}></View></View>
					<View style={styles.tabbot}></View>
				</View>
			)
		}
	}
	TabChooseToggleFun(e) {
		if (e != this.state.TabChoose) {
			this.setState({
				TabChoose: e,
			})
		}
		if (e == 'LianXi') {
			this.setState({
				sja: true,
				sjb: false,
				sjc: false,
			})
		} else if (e == 'ZhenTi') {
			this.setState({
				sja: false,
				sjb: true,
				sjc: false,
			})
		} else if (e == 'CePing') {
			this.setState({
				sja: false,
				sjb: false,
				sjc: true,
			})
		}
	}
	// 选项卡面板
	TabChooseTogglePanelFunWrap() {
		if (this.state.TabChoose === 'LianXi') {
			return (
				<View>
					{/* 下拉列表 */}
					<Text style={styles.textsty}>下拉列表</Text>
					<ModalDropdown style={styles.selects}
						dropdownStyle={[styles.dropdown]}
						defaultValue='option 1' options={['option 1', 'option 2', 'option 3', 'option 4']} />
					{/* 下拉菜单 */}
					<Text style={styles.textsty}>下拉菜单</Text>
					<TouchableOpacity style={styles.touchsty} onPress={() => this.dropDown_box_Toggle()}>
						<Text>{this.state.dropDown_box_Text}</Text>
					</TouchableOpacity>
					{this.dropDown_box_Fun()}
				</View>
			)
		} else if (this.state.TabChoose === 'ZhenTi') {
			return (
				<Text>2222</Text>
			)
		} else if (this.state.TabChoose === 'CePing') {
			return (
				<Text>3333</Text>
			)
		}
	}
	// 下拉菜单 显隐状态
	dropDown_box_Toggle() {
		this.setState({
			dropDown_box: !this.state.dropDown_box,
		})
	}
	dropDown_box_Fun() {
		if (this.state.dropDown_box === true) {
			return (
				<View style={{ borderRadius: 4, borderWidth: 1, borderColor: '#ccc', width: 80 }}>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '全部', dropDown_box: false })}>
						<Text>全部</Text>
					</TouchableOpacity>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '临床医师', dropDown_box: false })}>
						<Text>临床医师</Text>
					</TouchableOpacity>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '乡村全科', dropDown_box: false })}>
						<Text>乡村全科</Text>
					</TouchableOpacity>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '口腔医师', dropDown_box: false })}>
						<Text>口腔医师</Text>
					</TouchableOpacity>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '中西医医师', dropDown_box: false })}>
						<Text>中西医医师</Text>
					</TouchableOpacity>
					<TouchableOpacity onPress={() => this.setState({ dropDown_box_Text: '中医医师', dropDown_box: false })}>
						<Text>中医医师</Text>
					</TouchableOpacity>
				</View>
			)
		}
	}
}

const styles = StyleSheet.create({
	borders: {
		backgroundColor: '#ccc',
		width: 1,
		height: '100%'
	},
	bgsty: {
		width: '100%',
		height: 7,
		backgroundColor: '#ccc',
	},
	container: {
		flex: 1,
		alignItems: 'center',
		backgroundColor: '#F5FCFF',
	},
	TabControl: {
		flexDirection: 'row',
		alignItems: 'center',
		height: 40,
		width: '100%',
		justifyContent:'space-between',
	},
	TabControlItem: {
		height: 40,
		alignItems: 'center',
		justifyContent: 'center',
		width:'33.33%',
		position:'relative',
	},
	sj: {
		flexDirection: 'row',
		justifyContent: 'center',
		position:'absolute',
		bottom:-8,
		left:-4
	},
	tabsj: {
		borderStyle: 'solid',
		borderWidth: 5,
		borderLeftColor: 'transparent',
		borderTopColor: 'transparent',
		borderRightColor: 'transparent',
		borderBottomColor: 'red',
		width: 0,
		height: 0,
	},
	tabbot: {
		width: 60,
		height: 3,
		backgroundColor: 'red',
		position:'absolute',
		bottom:-10,
		left:-29
	},
	textsty: {
		color: 'blue',
		fontSize: 20,
		fontWeight: '100',
		margin: 10
	},
	selects: {
		borderWidth: 1,
		borderColor: '#bbbbbb',
		width: 100,
		height: 30,
		flexDirection: 'row',
		alignItems: 'center',
		marginBottom: 100
	},
	dropdown: {
		width: 100,
	},
	touchsty: {
		borderRadius: 4, borderWidth: 1, borderColor: '#ccc',
		width: 80,
		height: 30,
		flexDirection: 'row',
		alignItems: 'center',
	},
	two:{
		width:'100%',
		flex:1,
	},
	time:{
		margin:10,
		flexDirection:'row',
		alignItems:'center',
		justifyContent:'space-between',
	},
	timetit:{
		fontSize:16,
	}
})


