import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image,ScrollView  } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
export default class selecttype extends Component{
    constructor(props){
        super(props)
        this.state={}
    }
    //点击事件
    clickli(code,name){
        if(this.props.addressType == '找工作'){
            GLOBAL.zgzType.zgzTypeName = name
            GLOBAL.zgzType.zgzTypeNum = code
            this.setState({})
            this.props.offType()
        }else if(this.props.addressType == '找工人工种'){
            GLOBAL.zgrType.zgrTypeName = name
            GLOBAL.zgrType.zgrTypeNum = code
            this.setState({})
            this.props.offType()
        }else if(this.props.addressType == '发布招工工种'){
            GLOBAL.fbzgType.fbzgTypeName = name
            GLOBAL.fbzgType.fbzgTypeNum = code
            this.setState({})
            this.props.offType()
        }else if(this.props.addressType == '发布招工工程类别'){
            GLOBAL.fbzgProject.fbzgProjectName = name
            GLOBAL.fbzgProject.fbzgProjectNum = code
            this.setState({})
            this.props.offType()
        }
        // if(GLOBAL.zgzType.zgzTypeName.indexOf(name)>-1){//删除该选项
        //     let index = GLOBAL.zgzType.zgzTypeName.indexOf(name);//找到该元素下标
        //     GLOBAL.zgzType.zgzTypeName.splice(index, 1);
        //     this.setState({})
        // }else{//增加该选项
        //     GLOBAL.zgzType.zgzTypeName.push(name)
        //     this.setState({})
        // }
    }
    render(){
        return(
            <View style={styles.containermain}>
                <ScrollView style={{width:'100%',}}>
                {
                    GLOBAL.typeArr.map((item,key)=>{
                        return(
                            <TouchableOpacity  key={key} onPress={()=>this.clickli(item.code,item.name)} style={{height:46,
                                backgroundColor:'white',
                                borderBottomWidth:.6,
                                borderBottomColor:'#999',
                                paddingLeft:16,
                                paddingRight:16,
                                flexDirection:'row',
                                alignItems:'center',
                                justifyContent:"space-between"}}>
                                {
                                    this.props.addressType == '找工作'?(
                                        <Text style={{fontSize:15,color:GLOBAL.zgzType.zgzTypeName == item.name?"#eb4e4e":'#666'}}>{item.name}</Text>
                                        ):(
                                            this.props.addressType == '找工人工种'?(
                                                <Text style={{fontSize:15,color:GLOBAL.zgrType.zgrTypeName == item.name?"#eb4e4e":'#666'}}>{item.name}</Text>
                                        ):this.props.addressType == '发布招工工种'?(
                                            <Text style={{fontSize:15,color:GLOBAL.fbzgType.fbzgTypeName == item.name?"#eb4e4e":'#666'}}>{item.name}</Text>
                                        ):this.props.addressType == '发布招工工程类别'?(
                                            <Text style={{fontSize:15,color:GLOBAL.fbzgProject.fbzgProjectName == item.name?"#eb4e4e":'#666'}}>{item.name}</Text>
                                        ):false
                                    )
                                }
                                
                                {
                                    this.props.addressType == '找工作'?(
                                        GLOBAL.zgzType.zgzTypeName == item.name?(
                                                <View style={{flexDirection:'row',alignItems:'center'}}>
                                                    <Icon style={{marginRight:3}} name="sure" size={15} color="#eb4e4e" />
                                                    <Text style={{color:'#999',fontSize:12}}>已选择</Text>
                                                </View>
                                        ):false
                                    ):(
                                        this.props.addressType == '找工人工种'?(
                                            GLOBAL.zgrType.zgrTypeName == item.name?(
                                                <View style={{flexDirection:'row',alignItems:'center'}}>
                                                    <Icon style={{marginRight:3}} name="sure" size={15} color="#eb4e4e" />
                                                    <Text style={{color:'#999',fontSize:12}}>已选择</Text>
                                                </View>
                                            ):false
                                        ):this.props.addressType == '发布招工工种'?(
                                            GLOBAL.fbzgType.fbzgTypeName == item.name?(
                                                <View style={{flexDirection:'row',alignItems:'center'}}>
                                                    <Icon style={{marginRight:3}} name="sure" size={15} color="#eb4e4e" />
                                                    <Text style={{color:'#999',fontSize:12}}>已选择</Text>
                                                </View>
                                            ):false
                                        ):this.props.addressType == '发布招工工程类别'?(
                                            GLOBAL.fbzgProject.fbzgProjectName == item.name?(
                                                <View style={{flexDirection:'row',alignItems:'center'}}>
                                                    <Icon style={{marginRight:3}} name="sure" size={15} color="#eb4e4e" />
                                                    <Text style={{color:'#999',fontSize:12}}>已选择</Text>
                                                </View>
                                            ):false
                                        ):false
                                    )
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