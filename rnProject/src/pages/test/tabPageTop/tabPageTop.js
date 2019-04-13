
import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image } from 'react-native';
import { createMaterialTopTabNavigator } from 'react-navigation'

import JumpaTaba from '../jumpaTaba/jumpaTaba'
import JumpaTabb from '../jumpaTabb/jumpaTabb'

//底部Tab注册
export default Tab = createMaterialTopTabNavigator({
    JumpaTaba: {
        screen: JumpaTaba,
        navigationOptions: {
            title: '已收藏',
        }
    },
    JumpaTabb: {
        screen: JumpaTabb,
        navigationOptions: {
            title: '未收藏',
        }
    }
}, {
        //顶部标签页导航样式
        tabBarOptions: {
            activeTintColor: 'red',//选中状态下文字颜色
            inactiveTintColor: 'black',//非控制状态下文字颜色
            tabStyle: {//定义tab bar中tab的样式
                backgroundColor: "",
                height: 50,
                borderWidth: .5,
                borderColor: 'gray'
            },
            indicatorStyle: {//指示器的样式
                backgroundColor: 'red',
            },
            iconStyle: {//定义icon的样式
            },
            style: {//定义tab bar的样式
                backgroundColor: '#F5F5F5'
            }
        }
    })