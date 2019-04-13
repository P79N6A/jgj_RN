import React, {Component, /*useState*/} from 'react'
import {Platform, StyleSheet, Text, View, Button,TouchableOpacity,StatusBar} from 'react-native'

export default class JumpaTaba extends Component {
	render() {
		const {navigate} = this.props.navigation
		return (
			<View style={styles.container}>
				<Text>已收藏内容</Text>
			</View>
		)
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: 'center',
		backgroundColor: '#F5FCFF',
	},
})


