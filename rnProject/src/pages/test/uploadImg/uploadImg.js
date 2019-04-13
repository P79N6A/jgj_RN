import React,{Component} from 'react'
import {StyleSheet,Text,View} from 'react-native'

export default class Upload extends Component{
    constructor(props){
        super(props);
        this.state={};
    }
    render(){
        return(
            <View style={styles.container}>
                <Text>上传图片</Text>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container:{
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    }
})