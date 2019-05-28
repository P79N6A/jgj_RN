import React from 'react'
import { View } from 'react-native'

export default function Flex({ style, children }){
	return (
		<View
			style={{
				flexDirection:'row',
				alignItems:'center',
				...style
			}}
		>
			{children}
		</View>
	)
}