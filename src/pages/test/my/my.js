import React, { Component, /*useState*/ } from 'react'
import { Platform, StyleSheet, Text, View, Button, TouchableOpacity, StatusBar } from 'react-native'
import { StackNavigator } from 'react-navigation'

export default class Index extends Component {
	static navigationOptions = {
		title: 'My',gesturesEnabled: false,
	}
	componentDidMount() {
		this._navListener = this.props.navigation.addListener('didFocus', () => {
			StatusBar.setBarStyle('dark-content');
			StatusBar.setBackgroundColor('#ecf0f1');
		});
	}
	componentWillUnmount() {
		this._navListener.remove();
	}
	render() {
		const { navigate } = this.props.navigation
		return (
			<View style={styles.container}>
				<Text style={styles.welcome}>我的信息</Text>
				{/* <Count /> */}
				{/* 自定义按钮 */}
				<View style={styles.viewBtn}>
					<TouchableOpacity style={styles.btn} onPress={() => navigate('Index')}>
						<Text style={{ color: '#1296db' }}>TouchableOpacity to HOME</Text>
					</TouchableOpacity>
				</View>
				<View style={styles.viewBtn}>
					<TouchableOpacity style={styles.btn} onPress={() => navigate('TabPageTop')}>
						<Text style={{ color: '#1296db' }}>跳转到标签页</Text>
					</TouchableOpacity>
				</View>
				{/* 全局变量计数器 */}
				<View style={styles.viewBtn}>
					<TouchableOpacity style={styles.btn} onPress={() => navigate('Counter')}>
						<Text style={{ color: '#1296db' }}>计数器</Text>
					</TouchableOpacity>
				</View>
			</View>
		)
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
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
	},
	btn: {
		backgroundColor: '#ecf0f1',
		width: 200,
		height: 40,
		borderRadius: 3,
		alignItems: 'center',
		justifyContent: 'center',
	}
})
// function Count() {
//   const [count, setCount] = useState(0);

//   return (
//     <View>
//     	<Text>You clicked {count} times</Text>
//     	<Button onClick={() => setCount(count + 1)}>
// 			Click me
//     	</Button>
//     </View>
//   );
// }

