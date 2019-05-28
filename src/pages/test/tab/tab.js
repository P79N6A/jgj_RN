import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image } from 'react-native';
import { StackNavigator, createStackNavigator, createBottomTabNavigator, createAppContainer } from 'react-navigation'

import Index from '../index/index'
import My from '../my/my'

//底部Tab注册
export default Tab = createBottomTabNavigator({
  Index: {
    screen: Index,
    navigationOptions: {
      // tabBarVisible: false, // 隐藏底部导航栏
      title: '首页',
      header: 'home',
      // 自定义图片
      tabBarIcon: ({ focused, tinColor }) => {
        return (
          <Image
            style={{ width: 20, height: 20 }}
            source={focused ? require('../../../assets/test/sy.png') : require('../../../assets/test/sy(1).png')} />
        )
      }
    }
  },
  My: {
    screen: My,
    navigationOptions: {
      title: '我的',
      header: 'My',
      tabBarIcon: ({ focused, tinColor }) => {
        return (
          <Image
            style={{ width: 20, height: 20 }}
            source={focused ? require('../../../assets/test/wd.png') : require('../../../assets/test/wd(1).png')} />
        )
      }
    }
  }
},//导航栏样式
  {
    tabBarPosition: 'bottom',//设置tabbar的位置，iOS默认在底部，安卓默认在顶部。（属性值：'top'，'bottom'）
    tabBarOptions: {
      activeTintColor: '#1296db',//label和icon的前景色 活跃状态下
      inactiveTintColor: '#979797',//label和icon的前景色 不活跃状态下
      style: { backgroundColor: '#ffffff' },//导航栏背景色
      labelStyle: {
        fontSize: 12, // 文字大小
      },
    }
  }
)