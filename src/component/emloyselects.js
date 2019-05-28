import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image,ScrollView  } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
export default class selecttype extends Component{
    constructor(props){
        super(props)
        this.state={
        }
    }
    //点击事件
    clickli(code,name){
        GLOBAL.zgzEmploy.zgzEmployName = name
        GLOBAL.zgzEmploy.zgzEmployNum = code
        this.setState({})
        this.props.offEmploy()
    }
    render(){
        return(
            <View style={styles.containermain}>
                <ScrollView style={{width:'100%',}}>
                {
                    GLOBAL.zgzEmployArr.map((item,key)=>{
                        return(
                            <TouchableOpacity activeOpacity={.7}  key={key} onPress={()=>this.clickli(item.code,item.name)} style={{height:46,
                                backgroundColor:'white',
                                borderBottomWidth: .5,
                                borderBottomColor:'#dbdbdb',
                                paddingLeft:16,
                                paddingRight:16,
                                flexDirection:'row',
                                alignItems:'center',
                                justifyContent:"space-between"}}>

                                <Text style={{fontSize:15,color:GLOBAL.zgzType.zgzTypeName == item.name?"#eb4e4e":'#666'}}>{item.name}</Text>
                                
                                {
                                    GLOBAL.fbzgProject.fbzgProjectName == item.name?(
                                        <View style={{flexDirection:'row',alignItems:'center'}}>
                                            <Icon style={{marginRight:3}} name="sure" size={15} color="#eb4e4e" />
                                            <Text style={{color:'#666',fontSize:12}}>已选择</Text>
                                        </View>
                                    ):false
                                }
                                
                            </TouchableOpacity>
                        )
                    })
                }
                </ScrollView>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        width:'100%',
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },
})