import React from 'react';
import {AppRegistry, StyleSheet, Text, View} from 'react-native';
import {NativeModules, NativeEventEmitter,DeviceEventEmitter} from 'react-native';

class HelloWorld extends React.Component {
    render(){
        return (
            <View style={styles.container}>
                <Text style={styles.firstText}>Hello world</Text>
                <Text style={styles.secondText}>Hello react-native</Text>
            </View>
        );
    }
    componentDidMount(): void {
        const bridge = new NativeEventEmitter(NativeModules.JGJNativeEventEmitter);
        bridge.addListener('refreshRN',()=>{
            alert('哈哈');
        });

    }
}
const styles = StyleSheet.create({
    container:{
        backgroundColor: 'red'
    },
    firstText: {
        color: 'yellow',
        fontSize: 20
    },
    secondText: {
        color: 'orange',
        fontSize: 30
    }
});

AppRegistry.registerComponent('HelloWorld', ()=>HelloWorld);