GLOBAL={
    scrollheightDefault:0,//homepage列表滚动高度
    
    suitType:1,//搜索合适的人-1工人，2班组
    jogShowDid:false,//招工找活页面还未加载过
    // have_job:0,//当前剩余电话数

    baiduKey:'vaVH6Ls3Tisndi940ma2keNeGSm0UvH4',//百度ak认证


    infoverHome:'0',//刷新版本号
    infoverFind:'0',//刷新版本号
    infoverMy:'0',//刷新版本号
    // 页面地址
    // 我的名片

    // 发现
    pageAddress:'help/hpDetail?id=232',//关注
    co_workers_circle:'dynamic',//工友圈
    lighthouse:'exposure',//曝光台
    points_for_gifts:'integral/inMine',//积分兑好礼
    information:'news',//资讯

    // 我的
    personal_information:'my/list',//个人基本信息
    real_name_authentication:'my/idcard',//实名认证
    mycard:'my/resume',//我的找活名片
    the_day_to_sign:'my/signin',//每日一签
    my_collection:'my/collection',//我的收藏
    my_post:'dynamic/user',//我的帖子
    feedback:'my/feedback',//意见反馈

    // 分享内容
    shareInfo:{},
    miniJobAppId:'gh_dc82dfffc292',

    
    // beta环境
    // apiUrl:'http://api.beta.jgjapp.com/',//url拼接
	// newApiUrl: 'http://napi.beta.jgjapp.com/',
    // server:'http://nm.beta.jgjapp.com/',
    // shareHttp:'http://beta.cdn.jgjapp.com',

    
    // test环境
	// apiUrl:'http://api.test.jgjapp.com/',//url拼接
	// newApiUrl: 'http://napi.test.jgjapp.com/',
    // server:'http://nm.test.jgjapp.com/',
    // shareHttp:'http://test.cdn.jgjapp.com',

    // 正式环境
    apiUrl:'https://api.jgjapp.com/',//url拼接
    newApiUrl: 'https://napi.jgjapp.com/',
    server:'http://nm.jgjapp.com/',
    shareHttp:'https://cdn.jgjapp.com',
    
    
	// cdnUrl: this.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4"),
    // imgUrl: this.cdnUrl + "media/images/",

    ver: '4.0.2',//版本号
    client_type: 'person',//平台类型 person 个人端 manage 管理端
    timeDifference: '',//与服务器时间差
    ajaxIndex: 0,
    // 用户信息(登录返回)
    userinfo: {
        gender:'',
        group_user_name:'',//组内用户名称
        group_verified: '',//班组认证
        head_pic: '',//头像
        is_commando:'',
        is_info: 0,//是否具有基本信息
        os: '',//平台
        partner_level:'',////当前等级  1初级合伙人，2高级合伙人，3金牌合伙人
        partner_status:'',//0:没有申请合伙人，1,合伙人申请被拒绝，2，没有实名认证，3，待缴纳保证金，4正常合伙人，5合伙人被停用，6其他
        real_name: '',//登陆成功后对应的用户姓名
        resume_perfectness:100,//名片完善度
        role: '1',//当前角色
        serverTime:'',
        signature:'',
        token: '',//接口唯一标识
        uid: '',//登陆成功后对应的uid
        verified: '',//角色是否已通过实名-3Y,0N
        verified_arr:{
            foreman:'',//工头角色认证情况
            worker:'',//工人角色认证情况
        },

        age:'',
        birth:'',
        hometown:'',
        icno:'',//身份证号
        nationality:'',
        nickname:'',
        reply_cnt: '',//收到的未读回复数
        sys_message_cnt: '',//系统消息数量
        telph: "",//注册的电话号码
        user_name:'',
        userlevel: '',//用户等级
        wkmatecount:'',
        work_staus: '',//工作状态0：没工作1：工作中2：已经开工也在找工作


        worker_info:{},//工人信息
        foreman_info:{},//班组长信息
        introduce:"",//自我介绍
        signature:'',//个性签名

        // 认证情况
        // worker:'',//工人认证(空为未购买认证)
        // foreman:'',//班组长认证(空为未购买认证)
        // commando:'',//突击队认证(空为未购买认证,'-1 - 审核未通过，0 - 等待提交，1 -  审核中， 2 - 审核通过,3 - 已过期'')
    },
    // 地址
    AddressOne: [],
    AddressTwo: [],
    AddressThree: [],

    // 找工作地址
    zgzAddress: {
        national: true,//全国
        zgzAddressOneName: '选择城市',
        zgzAddressOneNum: '',

        zgzAddressTwoName: '选择城市',
        zgzAddressTwoNum: '',
    },
    // 找工人地址
    zgrAddress: {
        zgrAddressOneName: '选择城市',
        zgrAddressOneNum: '',

        zgrAddressTwoName: '',
        zgrAddressTwoNum: '',

        zgrAddressTwoNumSwitch:''
    },
    // 找工人：
    // 工人/班组
    lookworker:true,
    lookworkerSwitch:true,
    // 工种
    work_type:'',
    // 城市id
    cityno:'',


    // 发布招工项目所在地
    fbzgAddress: {
        fbzgAddressOneName: '选择城市',
        fbzgAddressOneNum: '',

        fbzgAddressTwoName: '',
        fbzgAddressTwoNum: '',

        detailAddress: '请选择所在地'//详细地址
    },
    payType:'d',//计薪方式-日
    dj:'元/平方米',//单价单位


    // 找工作选择用工类型
    zgzEmployArr:[
        {
            code:0,
            name:'全部'
        },
        {
            code:1,
            name:'点工'
        },
        {
            code:2,
            name:'包工'
        }
    ],

    zgzEmploy:{
        zgzEmployName:'用工类型',
        zgzEmployNum:''
    },

    // 工种
    typeArr: [],
    // 工程类别
    projectArr:[],
    // 找工作选择工种
    zgzType: {
        zgzTypeName: '选择工种',
        zgzTypeNum: '0',
    },
    // 找工人选择工种
    zgrType: {
        zgrTypeName: '选择工种',
        zgrTypeNum: '',

        zgrTypeNameSwitch:'',
    },
    // 发布招工选择工种
    fbzgType: {
        fbzgTypeName: '选择工种',
        fbzgTypeNum: '',
    },
    // 发布招工选择工程类别
    fbzgProject: {
        fbzgProjectName: '选择工程类别',
        fbzgProjectNum: '',
    },

    pid: '',//项目id

    ///////////////////////////////////

    // 编辑的基本信息
    editbasic: {
        name: '',//姓名
        sex: '',//性别
        nation: [],//民族
        birthday: '',//生日
        workingyears: '',//工龄
        // 家乡地址
        jxaddress: {
            jxone: -1,
            jxtwo: -1,
            jxthree: -1,
            jxoneName: '',
            jxtwoName: '',
            jxthreeName: '',
        },
        // 期望工作地址
        qwaddress: {
            qwone: -1,
            qwtwo: -1,
            qwoneName: '',
            qwtwoName: '',
        },
        worktypelb: [],//选择工程类别
        worktype: [],// 选择工种
        mastery: [],// 选择熟练度
    },
    // 保存的基本信息
    basic: {},
    // 招突击队选择城市
    tjdaddress: {
        tjdone: -1,
        tjdtwo: -1,
        tjdoneName: '',
        tjdtwoName: '',
    },

    // 我的招聘模块选项卡打开记录
    TabChoose:'a',

    // 其他用户名片数据
    otherUser:{
        uid:'',
        pid:'',
        role_type:'',
        lng:'',
        lat:'',
        city_name:'',
        province_name:'',
        pro_address:''
    },
    detailLngnLat:{
        lng:'',
        lat:''
    }
}

// GLOBAL.cdnUrl = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4")
GLOBAL.imgUrl = GLOBAL.cdnUrl + "media/images/"