import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    ScrollView
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class musuit extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    render() {
        return(
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
            {/* 导航条 */}
            <View style={{
                height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                borderBottomWidth: 1, borderBottomColor: '#ebebeb'
            }}>
                <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                    onPress={() => this.props.navigation.goBack()}>
                    <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                    <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                </TouchableOpacity>
                <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                    <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}></Text>
                </View>
                <TouchableOpacity activeOpacity={.7}
                    style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                </TouchableOpacity>
            </View>

            <ScrollView>
                    <View style={styles.main}>
                        <View style={{ flexDirection: 'row', justifyContent: 'flex-start', width: '100%', alignItems: 'center', marginTop: 20, marginBottom: 20 }}>
                            <Icon style={{ marginLeft: 3 }} name="question-circle" size={19} color="#999" />
                            <Text style={{ fontWeight: '400', color: '#000', fontSize: 20, marginLeft: 3 }}>招工防骗指南</Text>
                        </View>
                        <View style={{ width: '100%', backgroundColor: '#fafafa', color: '#666', borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, padding: 10 }}>
                            <Text style={styles.tits}>吉工家平台大多数人是诚信工友，真是的在招工和找活，但找活时防范之心不可无！吉工家为大家贴心送上招工防骗指南：</Text>
                            
                            <Text style={styles.tith}>1.如何防范工地诈骗？</Text>
                            <Text style={styles.fonts}>吉工家提醒各位招工的老板，防范工地诈骗，记住以下方法：</Text>
                            <Text style={styles.fonts}>①对于陌生应聘者应仔细询问、核对清楚应聘人员姓名、年龄、民族、籍贯等信息，看对方是不是够专业或是要求对方发一些以前的施工照片，像不像工人。可以用吉工家APP的聊聊，保留沟通记录。</Text>
                            <Text style={styles.fonts}>②必要时，对口头约定免责条款要进行微信视频聊天录像后，再让应聘者来应聘。</Text>
                            <Text style={styles.fonts}>③进入工地前核对好人员身份，多看几张他们的身份证，约定好要几个人，要哪些地区的不要哪些地区的说清楚，然后录下来作为证据。一旦遇到敲诈，要保留好各种证据，及时报警。</Text>
                            <Text style={styles.fonts}>④招工时如遇以任何理由让你先打钱，皆为诈骗！请立即拨打客服电话举报！你还可以去【发现-曝光台】看看工友们曾遇到的被骗案例，提高警惕。</Text>
                            <Text style={styles.fonts}>如遇任何问题，请致电吉工家客服热线：4008623818-曝光台】看看工友们曾遇到的被骗案例，提高警惕。</Text>

                            <Text style={styles.tith}>2.工地诈骗常见类型有哪些？</Text>
                            <Text style={styles.fonts}>目前网上曝光的主要有以下三种诈骗伎俩：</Text>
                            <Text style={styles.fonts}>案例1、以没有路费为由叫招工方打钱买车票，结果招工方打钱后，了无音讯！</Text>
                            <Text style={styles.fonts}>案例2、诈骗方通过微信发送已经买好的车票照片给招工方，获取信任后，又以其他工人没钱买车票，需要打钱，这时候招工方很容易上当，经吉工家调查发现，发送的车票图片均为手机软件制作而成，并不是真正的车票。切记一切以先打钱的皆为诈骗！</Text>
                            <Text style={styles.fonts}>案例3、通过电话联系，约定好了招工人数，结果第二天过来几倍甚至数十倍的人，诈骗犯以往返路费以及误工费为由，借机实施诈骗行为，如果不给钱，就威胁，堵门，阻碍施工。</Text>

                            <Text style={styles.tith}>3.如果遇到骗子，我该怎么办？</Text>
                            <Text style={styles.fonts}>如果遇到要钱买车票的，如以上案例一二，请记住一点：一切以先打钱的皆为诈骗！不要打钱！</Text>
                            <Text style={styles.fonts}>如果遇上案例三的棘手情况，建议做好以下几点：</Text>
                            <Text style={styles.fonts}>①马上报警保障人身安全，并保留好之前的招工微信聊天记录。</Text>
                            <Text style={styles.fonts}>②跑路，他们不敢弄坏你的工地，屋里的东西。这些都是违法行为，随便找个理由在外面不接电话，他们耗不起，耗不过夜。</Text>
                            <Text style={styles.fonts}>③死活不给钱，他们不敢打你，就说没钱，我也是打工的，跟警察说自己难处没钱。</Text>
                            <Text style={styles.fonts}>④跟警察一起到警察局接受调查，骗子都害怕，然后调查之前他们已经成功诈骗的工地（如果之前有报警，会在警察局留下他们的身份信息），这时警察会对他们进行隔离审查，稍微问下就露马脚。</Text>
                            <Text style={styles.fonts}>⑤骗子根本不会干活，你可以留他们干活，管吃，但干活的时候拍视频录像，保留证据给警察看。不要害怕，他们不敢打人，一打人报警他们都得玩完。</Text>

                            <Text style={styles.tits}>切记一定不能给钱，如果招工之前保留好了微信视频，微信聊天记录，或是通话录音，这时候给警察看相信警察同志会认真对待，就不会认为是普通的劳务纠纷了！   </Text>

                            <Text style={styles.tithal}>案例：</Text>

                            <Image style={{width:'96%'}} source={require('../../assets/recruit/alfont.jpeg')}></Image>

                            <Text style={styles.tithal}>招工找活遇到问题，请致电咨询吉工家客服热线：4008623818</Text>
                        </View>
                    </View>
                </ScrollView>
        </View>
        )
    }
}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        backgroundColor: 'white',
        alignItems: 'center',
    },
    main: {
        paddingLeft: 10,
        paddingRight: 10,
        marginBottom: 10
    },
    tit: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: '400',
        marginTop: 18,
        marginBottom: 18,
    },
    tith: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginTop: 60,
        marginBottom: 18,
    },
    tithal:{
        color: "#666",
        lineHeight:27,
        fontSize: 17,
        marginTop: 60,
        marginBottom: 18,
    },
    tits: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginTop:20,
        marginBottom: 18,
        lineHeight:27,
    },
    fonts: {
        color: "#666",
        marginBottom: 18,
        fontSize: 17,
        lineHeight: 27,
    },
    fontst: {
        color: "#666",
        marginBottom: 18,
        marginTop: 36,
        fontSize: 17,
        lineHeight: 27,
    },
    wornphone: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginTop: 36,
    },
    phone: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginBottom: 18,
    },
})