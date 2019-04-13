import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';

export default class counter extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    render() {
        return (
            <View style={styles.containermain}>
                <View style={styles.main}>
                    <Text>数量：</Text>
                </View>
                <View style={styles.main}>
                    <TouchableOpacity style={styles.btn} onPress={() => { this.reduce() }}>
                        <Text style={styles.text}>-</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.btn} onPress={()=>{this.plus()}}>
                        <Text style={styles.text}>+</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    // 减
    reduce() {
       
    }
    // 加
    plus(){
        
    }
}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
        justifyContent: 'center',
    },
    main: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'center',
    },
    btn: {
        width: 50,
        height: 30,
        backgroundColor: '#1296db',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: 10,
        marginLeft: 10,
        marginRight: 10,
        borderRadius: 4
    },
    text: {
        color: 'white'
    }
})