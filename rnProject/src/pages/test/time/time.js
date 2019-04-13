import React, { Component, /*useState*/ } from 'react'
import { StyleSheet, Text, View, AppRegistry, DatePickerAndroid, TouchableHighlight } from 'react-native'

export default class Time extends Component {
    constructor(props){
        super(props);
        this.state={
          presetDate: new Date(2019, 3, 4),
          allDate: new Date(2019, 3, 4),
          simpleText: '选择日期,默认今天',
          presetText: '选择日期,指定2019/3/4',
          minText: '选择日期,不能比今日再早',
          maxText: '选择日期,不能比今日再晚',
        };
      }
      //进行创建时间日期选择器
  async showPicker(stateKey, options) {
    try {
      var newState = {};
      const {action, year, month, day} = await DatePickerAndroid.open(options);      
      if (action === DatePickerAndroid.dismissedAction) {
        newState[stateKey + 'Text'] = 'dismissed';
      } else {
        var date = new Date(year, month, day);
        newState[stateKey + 'Text'] = date.toLocaleDateString();
        newState[stateKey + 'Date'] = date;
      }
      this.setState(newState);
    } catch ({code, message}) {
      console.warn(`Error in example '${stateKey}': `, message);
    }
  }
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    日期选择器组件实例
                </Text>
                <TouchableHighlight
                    style={styles.button}
                    underlayColor="#a5a5a5"
                    onPress={this.showPicker.bind(this, 'simple', { date: this.state.simpleDate })}>
                    <Text style={styles.buttonText}>点击弹出基本日期选择器</Text>
                </TouchableHighlight>
                <CustomButton text={this.state.presetText}
                    onPress={this.showPicker.bind(this, 'preset', { date: this.state.presetDate })} />
                <CustomButton text={this.state.minText}
                    onPress={this.showPicker.bind(this, 'min', { date: this.state.minDate, minDate: new Date() })} />
                <CustomButton text={this.state.maxText}
                    onPress={this.showPicker.bind(this, 'max', { date: this.state.maxDate, maxDate: new Date() })} />
            </View>
        )
    }
}
//简单封装一个日期组件
class CustomButton extends React.Component {
    render() {
      return (
        <TouchableHighlight
          style={styles.button}
          underlayColor="#a5a5a5"
          onPress={this.props.onPress}>
          <Text style={styles.buttonText}>{this.props.text}</Text>
        </TouchableHighlight>
      );
    }
  }

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
      },
      button: {
        margin:5,
        backgroundColor: 'white',
        padding: 15,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#cdcdcd',
      }
})


