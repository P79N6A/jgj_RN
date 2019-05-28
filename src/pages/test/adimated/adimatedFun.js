import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Image, Animated, Easing } from 'react-native';


export default class counter extends Component {
    toValue = 0
    constructor(props) {
        super(props)
        this.state = {
            moveValue: new Animated.Value(0)
        }
    }
    render() {
        let { moveValue } = this.state

        let toValue = moveValue.interpolate({
            inputRange: [0, 1],
            outputRange: ['10%', '60%']
        })
        return (
            <View>
                <TouchableOpacity onPress={this.pressView}>
                    <Animated.View                 // 使用专门的可动画化的View组件
                        style={{
                            width: 100, height: 50,
                            backgroundColor: 'red',
                            left: toValue,
                        }}
                    >
                        <Text style={{ color: '#fff' }}> Tap Me Move </Text>
                    </Animated.View>
                </TouchableOpacity>
            </View>
        )
    }
    pressView = () => {
        this.toValue = this.toValue === 0 ? 1 : 0
        Animated.timing(
            this.state.moveValue,  // 初始化从0开始
            {
                toValue: this.toValue, // 目标值
                duration: 300,         // 时间间隔
                easing: Easing.bounce // 缓动函数
            }
        ).start()
    }
}