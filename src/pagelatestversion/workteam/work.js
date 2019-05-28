import React,{Component} from 'react'
import {
	TouchableOpacity,
	View,
	Text,
	Image
} from 'react-native'
// import { withNavigation } from 'react-navigation'
import Icon from "react-native-vector-icons/iconfont"
import ImageCom from '../../component/imagecom'


export default class Worker extends Component {
    constructor(props){
        super(props)
        this.state={

        }
    }
    render(){
        let {item} = this.props
        let navigation = this.props.navigation
        return(
            <>
		{item?
		<TouchableOpacity activeOpacity={.7}  onPress={() => navigation.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: '2',nameTo: 'grorbz' })}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5,
                }}>
                    <View style={{
                        width: '100%',
                        overflow: 'hidden'
                    }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{
                                // backgroundColor: 'rgb(114, 102, 202)', 
                                flexDirection: 'row', alignItems: 'center',
                                justifyContent: 'center',
                                borderRadius: 4.4, width: 49, height: 49, marginRight: 20,
                                overFlow: 'hidden'
                            }}>
                                <ImageCom
                                    style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                    fontSize='17.6'
                                    userPic={item.head_pic}
                                    userName={item.real_name}
                                />
                                {/* <Image
                                    source={{ uri:item.head_pic }}
                                    style={{width:49,height:49,borderRadius: 4.4}} /> */}
                            </View>
                            <View style={{ flex: 1 }}>
                                <View
                                    style={{
                                        flexDirection: 'row', alignItems: 'center',
                                        justifyContent: 'space-between', flexWrap: 'wrap'
                                    }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>

                                        {/* 实名 */}
                                        {
                                            item.verified !== '0' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.props.alertFun('user-sm')}>
                                                    <Image style={{ width: 52, height: 18, marginLeft: 8 }} source={require('../../assets/recruit/verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }

                                        {/* 认证 */}
                                        {
                                            item.group_verified == '1' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('user-rz-tj')}>
                                                    <Image style={{ width: 52, height: 18, marginLeft: 8 }} source={require('../../assets/recruit/group-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }

                                        {/* 突击队 */}
                                        {
                                            item.is_commando == '1' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('user-tj')}>
                                                    <Image style={{ width: 52, height: 18, marginLeft: 8 }} source={require('../../assets/recruit/commando-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                    </View>

                                    {/* 地点 */}
                                    {
                                        item.current_addr ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                                <Icon name="place" size={15} color="#BFBFBF" />
                                                <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5, }} >
                                                    {item.current_addr}
                                                </Text>
                                            </View>
                                        ) : (false)
                                    }

                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        {
                                            item.nationality ? (
                                                <Text style={{ color: '#666', fontSize: 13.2, marginRight: 10 }}>{item.nationality}族</Text>
                                            ) : (false)
                                        }
                                        {
                                            item.work_year && Number(item.work_year)!=0 ? (
                                                <View
                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', marginRight: 10 }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>工龄</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.work_year} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>年</Text>
                                                </View>
                                            ) : (false)
                                        }
                                        {
                                            item.scale&& Number(item.scale)!=0 ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>队伍</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.scale} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>人</Text>
                                                </View>
                                            ) : (false)
                                        }
                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            {
                                item.pro_type && item.pro_type.length > 0 ? (
                                    item.pro_type.map((item, index) => {
                                        return (
                                            <View key={index} style={{
                                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee', paddingLeft: 4.4, paddingRight: 4.4,
                                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                            }}>
                                                <Text style={{ color: '#666', fontSize: 13.2 }}>{item}</Text>
                                            </View>
                                        )
                                    })
                                ) : (false)
                            }

                            {
                                item.work_type && item.work_type.length > 0 ? (
                                    item.work_type.map((items, index) => {
                                        if (index !== item.work_type.length - 1) {
                                            return (
                                                <View key={index} style={{
                                                    marginTop: 4.4, marginRight: 1, paddingLeft: 4.4, paddingRight: 4.4,
                                                    paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                }}>
                                                    <Text style={{ color: '#000', fontSize: 13.2 }}>{items} |</Text>
                                                </View>
                                            )
                                        } else {
                                            return (
                                                <View key={index} style={{
                                                    marginTop: 4.4, marginRight: 6.6, paddingLeft: 4.4, paddingRight: 4.4,
                                                    paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                }}>
                                                    <Text style={{ color: '#000', fontSize: 13.2 }}>{items}</Text>
                                                </View>
                                            )
                                        }
                                    })
                                ) : (false)
                            }
                        </View>

                        {
                            item.introduce ? (
                                <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 6.6 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2 }} numberOfLines={1}>
                                        {item.introduce}
                                    </Text>
                                </View>
                            ) : (false)
                        }
                    </View>
                </View>
			</TouchableOpacity>:
			null
		}
		</>
        )
    }
}
// function Worker ({ item, navigation }){
	// console.log(item)
// 	return (
		
// 	)
// }

// export default withNavigation(Worker)