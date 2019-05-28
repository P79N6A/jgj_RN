import React from 'react'
import { View } from 'react-native'

export default function ({ style, children }){
	return (
		<View
			style={{
				width:'100%',
				position:'absolute',
				bottom:0,
				padding:10,
				backgroundColor:'#fafafa',
				borderTopWidth:1,
				borderColor:'#dbdbdb',
				...style
			}}
		>
			{children}
		</View>
	)
}