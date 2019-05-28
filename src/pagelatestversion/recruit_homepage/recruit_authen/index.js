import React, { useState, useEffect, useRef } from 'react'
import { StyleSheet, View, Text, Image, ScrollView, ImageBackground, TouchableOpacity, NativeModules, Platform, TextInput } from 'react-native'
import { withNavigation } from 'react-navigation'
import Icon from "react-native-vector-icons/iconfont"
import { Toast } from '../../../component/toast'
import ImagePicker from 'react-native-image-picker'

import fetchFun from '../../../fetch/fetch'

import { Flex, Btn } from '../../../component/ui/index'
import Brief from './brief'


function Index({ type, detail, updateDetail, navigation }){
	let manage = false,
		state_num = Number(detail.status) || 0,
		defaultSrc = detail.imgs[0] ? GLOBAL.imgUrl + detail.imgs[0].replace('media/images/', '') : `${GLOBAL.server}public/imgs/my/at-default.png`,
		// 企业资质图片
    	defaultSrcEn = detail.company_img ? GLOBAL.imgUrl + detail.company_img.replace('media/images/', '') : `${GLOBAL.server}public/imgs/my/at-default-enterprise.png`
	console.log('defaultSrc',defaultSrc)	
	const btnState = ['再次认证', '提交审核', '重新提交', '认证续期']
	const teq = [
		{icon:'match',desc:'项目优先匹配，获得更多找项目机会'},
		{icon:'show',desc:'班组推荐优先展示，增加展示机会'},
		{icon:'refresh',desc:'名片信息每天无限刷新，提升被查看次数'},
		{icon:'logo',desc:'吉工家官方认证标识，特别展示'},
		{icon:'service',desc:'专属客服'}
	]

	const options = {
		title: '请选择图片来源',
		cancelButtonTitle:'取消',
  		takePhotoButtonTitle:'拍照',
  		chooseFromLibraryButtonTitle:'相册图片',
		storageOptions: {
			skipBackup: true,
			path: 'images'
		}
	}

	const [ src, setSrc ] = useState(null),
		[ srcEn, setSrcEn ] = useState(null),
		[ enterpriseName, setEnterpriseName ] = useState(''),
		[ enterpriseCode, setEnterpriseCode] = useState(''),
		[ workerLeaderEn, setWorkerLeaderEn ] = useState(type > 1 && !!Number(detail.is_have_company_info) || false)

	const latestSrc = useRef(src)

	const resRender = () => {
		// let {workInfo} = this.state;
		let state = detail.status
		switch (state) {
			// 失败
			case -1:
				return (
					<View>
						<Text 
							style={{
								paddingLeft:10,
								paddingRight:10,
								paddingTop:8,
								paddingBottom:8,
								fontSize:14,
								backgroundColor:'#ebebeb'
							}}
						>
							认证结果
						</Text>
						<View
							style={{
								backgroundColor:'#fff',
								fontSize:14,
								paddingLeft:10,
								paddingRight:10,
								paddingTop:14,
								paddingBottom:14
							}}
						>
							<Text style={{color:'#eb4e4e',marginBottom:8}}>审核不通过</Text>
							<Text style={{color:'#666'}}>不通过原因：{detail.admin_remark}</Text>
						</View>
					</View>
				)
			// 未进行
			case 0:
				return (
					<Text
						style={{fontSize:12,paddingTop:8,paddingBottom:8,textAlign:'center',backgroundColor:'#fdf1e0',color:'#f18215'}}
					>
						请尽快提交以下审核资料，平台会在5个工作日内完成审核
					</Text>
				)
			// 进行中
			case 1:
				return (
					<View>
						<Text
							style={{
								paddingLeft:10,
								paddingRight:10,
								paddingTop:8,
								paddingBottom:8,
								fontSize:14,
								backgroundColor:'#ebebeb'
							}}
						>平台审核中</Text>
						<View
							style={{color:'#eb4e4e',paddingTop:14,paddingBottom:14,paddingLeft:10,paddingRight:10,fontSize:14,backgroundColor:'#fff'}}
						>
							<Text>您在{detail.submit_time_format}提交了申请</Text>
							<Text>平台会在5个工作日内完成审核，请耐心等待。</Text>
						</View>
					</View>
				)
			case 2:
				return <Brief detail={detail} manage={manage} />
			default:
				return null
		}
	}

	// 实名认证条件渲染
    const idCard = () => {
		let msg = detail,
            // img_style = index => {
            // 	return {
            // 	    height: '5rem'
            // 	    , background: `url("${GLOBAL.imgUrl}${msg.idcard_imgs[index]}")`
            // 	}
        	// },
        	isCrt = manage ? (msg && Number(msg.verified) === 3) : !!(msg && msg.idcard);
        // let {role, data} = this.props
        return <View
            className={`${isCrt ? 'of-h' : 'flex-row justify-between align-center'} bg-fff bt-top bt-bottom-before`}>
            {
                isCrt
                    ?
                    <View
						style={{
							paddingTop:8,
							paddingRight:10,
							paddingBottom:8,
							paddingLeft:10,
							backgroundColor:'#ebebeb',
							flex:1,
							flexDirection:'row',
							alignItems: 'center',
							flexBasis:40,
							flexGrow:0
						}}
					>
						<Text>认证信息</Text>
					</View>
                    : null
            }
			<View
				style={{
					paddingRight:10,
					paddingLeft:10,
					paddingBottom:40,
					flexDirection:isCrt?'column':'row',
					justifyContent:'space-between',
					alignItems:isCrt?'flex-start':'center'
				}}
			>
				<View style={{flexDirection:'row',alignItems:'center',marginTop:12,marginBottom:12}}>
					<Text style={sty.dot}>1</Text><Text>实名认证</Text>
                	{/* <Verified
                	    className="rml-10"
                	    role_type={role}
                	    verified={this.props.userInfo.info.verified}
                	    group_verified={false}
                	    commando={false}
                	/> */}
                	{isCrt ? null : <Text style={{fontSize:12,color:'#999',marginLeft:5}}>(申请人需要通过实名认证)</Text>}
				</View>
				{isCrt?
					<View style={{flexDirection:'row',alignItems:'center'}}>
						<Text>{GLOBAL.userinfo.user_name}</Text><Text>({detail.idcard.replace(/\d{6}(?=(\d{2}|\d{1}x)$)/i, '******')})</Text>
					</View>:
					<Text
						onPress={() => linkPage('my/idcard')}
						style={{
							color: '#f18215',
							borderWidth:1,
							borderColor:'#f18215',
							borderRadius:2,
							paddingLeft:10,
							paddingRight:10
						}}
					>去认证
					</Text>
            	}
			</View>
        </View>
	}
	// 认证说明渲染
    const instructionRender = () => {
        if (manage){
			return (
				<View
					style={{
						marginTop:10,
						marginBottom:14,
						backgroundColor:'#fff',
						paddingTop:14,
						paddingBottom:14,
						paddingLeft:10,
						paddingRight:10,
						fontSize:12,
						color:'#999',
						borderTopWidth:1,
						borderColor:'#dbdbdb'
					}}
				>
                	<Text style={{fontSize:14,color:'#000'}}>认证说明</Text>
                	<Text style={{paddingTop:14}}>上传资质证明的企业名称需与现在企业信息中名称一致，请确保上传的图片清晰度可辩。</Text>
                	<Text style={{paddingTop:14}}>认证承诺：提交的资料仅用于吉工宝企业认证使用，我们承诺不会用于其他商业用途。</Text>
            	</View>
			)
		}else{
			return (
				<View
					style={{
						marginTop:10,
						marginBottom:14,
						backgroundColor:'#fff',
						paddingTop:14,
						paddingBottom:14,
						paddingLeft:10,
						paddingRight:10,
						fontSize:12,
						color:'#999',
						borderTopWidth:1,
						borderColor:'#dbdbdb'
					}}
				>
                	<Text style={{fontSize:14,color:'#000'}}>认证说明</Text>
                	<Text style={{paddingTop:14}}>安全、严格的真实性认证，是为了更好地保护平台用户的合法权益。</Text>
                	<Text style={{paddingTop:14}}>认证审核服务费用一经缴纳不退还且对审核结果是否通过不做担保，请慎重上传真实资料。</Text>
                	<Text style={{paddingTop:14}}>平台不会对认证用户作担保，只对认证结果公示，不对之后该信息的有效性负责。</Text>
                	<Text style={{paddingTop:14}}>认证有效期间如遇举报及投诉，经核实，将取消认证标识，且审核费用不退。</Text>
            	</View>
			)
		}
    }
	// 班组长企业认证选项
    const selectCompanyAttest = () => {
        // let {workerLeaderEn} = this.state;
        let boxStyle = {
            width: 22,
			height: 22,
			borderWidth:1,
			borderRadius:4,
			backgroundColor:workerLeaderEn ? '#eb4e4e ' : '#f2f2f2',
			borderColor:workerLeaderEn ? '#eb4e4e' : '#dbdbdb'
        };
        // let selectFun = () => {
        //     this.setState({
        //         workerLeaderEn: !workerLeaderEn
        //     });
        // };

        return (
			<TouchableOpacity activeOpacity={.7}
				onPress={() => {setWorkerLeaderEn(!workerLeaderEn)}}
			>
				<Flex
					style={{backgroundColor:'#fafafa',paddingLeft:10,paddingRight:10,paddingTop:14,paddingBottom:14,borderTopWidth:1,borderColor:'#dbdbdb'}}
				>
					<View
						style={{marginRight:10,fontSize:14}}
					>
            		    <Text>企业认证</Text>
            		    <Text style={{color:'#eb4e4e',fontSize:12}}>非必选，填写了企业认证的用户发布招工可信度更高</Text>
            		</View>
            		<View
            		    style={boxStyle}>
						{workerLeaderEn?
							<Icon name="sure" size={18} color="#fff" />:
							null
            		    }
            		</View>
        		</Flex>
			</TouchableOpacity>
		)
    }
	// 资质渲染
    const imgForEnterprise = () => {
        // let {srcEn, defaultSrcEn, msg, workerLeaderEn} = this.state;
        // let state_num = Number(msg.status);
        // let img_style = {
        //     background: `url(${srcEn ? srcEn : defaultSrcEn}) no-repeat center center / cover`
        // };

        return (
			<View
				style={{
					fontSize:14,
					borderTopWidth:1,
					borderColor:'#dbdbdb',
					marginTop:workerLeaderEn ? 0 : 10
				}}
			>
        		<View
					style={{
						borderTopWidth:1,
						borderColor:'#dbdbdb',
						backgroundColor:'#fff',
						paddingTop:10,
						paddingBottom:10
					}}
        		    // className={`bt-bottom bg-fff rpl-10 rpr-10 ${state_num === 2 || state_num === -1 ? '' : 'flex-row fs-14 align-center'}`}
				>
					<Text
						style={{
							paddingTop:state_num === 2 || state_num === -1?12:0,
							paddingBottom:state_num === 2 || state_num === -1?12:0,
							marginRight:state_num === 2 || state_num === -1?0:10
						}}
					>企业全称</Text>
					{state_num === 2 || state_num === -1?
						<Text style={{paddingTop:12,paddingBottom:12}}>{this.enterpriseName || ''}</Text>:
						<TextInput
        					style={{paddingTop:12,paddingBottom:12}}
							placeholder="请填写企业全称"
							maxLength = {50}
							value={enterpriseName}
        					onChangeText={(text) => setEnterpriseName(text.trim().replace(' ', ''))}
        				/>
        		    }
        		</View>

            	<View style={{paddingLeft:10,paddingRight:10,marginTop:10,fontSize:14,backgroundColor:'#fff',borderBottomWidth:1,borderColor:'#dbdbdb'}}>
            	    <Text style={{paddingTop:12,paddingBottom:12}}>统一社会信用代码/组织机构代码：</Text>
					{state_num === 2 || state_num === -1?
						<Text style={{paddingTop:12,paddingBottom:12}}>{enterpriseCode || ''}</Text>:
						<TextInput
        					style={{paddingTop:12,paddingBottom:12}}
							placeholder="请填写统一社会信用代码/组织机构代码"
							maxLength = {18}
							value={enterpriseCode}
        					onChangeText={(text) => setEnterpriseCode(text.trim())}
        				/>
            	    }
            	</View>

            	<View
					style={{
						backgroundColor:'#fff',
						marginTop:10,
						paddingTop:14,
						paddingBottom:30,
						paddingLeft:10,
						paddingRight:10,
						marginBottom:state_num === 1 || state_num === -1 ? 10 : 0
					}}
				>
            	    <Text>资质证明</Text>

					{/* className={`pst-rel br-4 attest__upload ${(srcEn || msg.imgs.length) && (state_num !== 2 && state_num !== -1) ? 'attest__upload__mark' : ''}`} */}
					<TouchableOpacity activeOpacity={.7}
						onPress={()=>pickImage(true)}
						style={{justifyContent:'center',alignItems:'center'}}
					>
						<ImageBackground
							style={{position:'relative',borderRadius:4,width: 195, height: 195,paddingBottom:20}}
							source={{uri:`${srcEn ? 'file://'+srcEn : defaultSrcEn}`}}
						>
							{(state_num < 2 && state_num > -1) || !state_num?
								<View
									style={{
										flexDirection:'row',
										alignItems:'center',
										justifyContent:'center',
										borderRadius:50,
										backgroundColor: '#dbbf81',
										width:50,
										height:50,
										lineHeight:50
									}}
								>
									<Icon name="camera" size={30} color="#fff" />
								</View>:
								null
            	    	    }
							{/*(state_num < 2 && state_num > -1) || !state_num?
								<input className="attest__upload__input" id="file" type="file" onChange={(e) => {
            	    	                this.getImg(e, true)
            	    	        }}
								accept="image/jpg, image/jpeg, image/png, image/bmp, image/gif"/>
								:
								null
            	    	    */}
            			</ImageBackground>
					</TouchableOpacity>
                	{(state_num < 2 && state_num > -1) || !state_num?
						<Text
							style={{marginBottom:4,fontSize:12,textAlign:'center',color:'#666'}}
						>
							{srcEn || detail.company_img ? '（点击图片重新提交）' : '（按照实例上传照片）'}
						</Text>:
						null
                	}

					{(state_num > -1 && state_num < 2) || !state_num?
						<View
							style={{paddingLeft:15,paddingRight:15,paddingBottom:4,marginTop:28,fontSize:12,color:'#eb4e4e'}}
						>
                	        <Text>证件各项信息完整清晰</Text>{/* className="m-0 pst-rel attest__front__point" */}
                	        <View style={{marginTop:12}}>
                	            <Text>请上传营业执照/组织机构代码证/统一社会信用代码登记证书的原件照片或扫描件，或者复印件加盖公章</Text>
                	            <Text>图片支持jpg、bmp、png格式，大小不超过5M</Text>
                	        </View>
						</View>:
						null
                	}
            	</View>
        	</View>
		)
    }

	// 提交允许
    const allowSubmit = () => {
        // let {src, srcEn, msg, workerLeaderEn} = this.state;
        // let {manage} = this;
        // if ( !msg ) return false;
		// if ( Number(msg.status) === 2 && !workInfo ) return false;
		let msg = detail

        // 完善度验证
        let manageValidate;                 // 企业验证数据
        // let validate = [{
        //     data: (manage ? Number(msg.verified) === 3 : msg.idcard) || null
        //     , type: ['required']
        //     , errorMsg: ['请完善实名认证']
        // }, {
        //     data: src || msg.imgs.length && msg.imgs[0].length || null
        //     , type: ['required']
        //     , errorMsg: ['请上传认证对比图片']
		// }];
		if(!(manage ? Number(msg.verified) === 3 : msg.idcard)){
			Toast.show('请完善实名认证')
			return true
		}
		if(!(src || msg.imgs.length && msg.imgs[0].length)){
			Toast.show('请上传认证对比图片')
			return true
		}

        if (manage || workerLeaderEn) {
			if(enterpriseName.length==0){
				Toast.show('请填写企业全称')	
				return true
			}
			if(enterpriseName.length>2){
				Toast.show('企业名称不能小于2个字')
				return true
			}
			if(enterpriseCode.length==0){
				Toast.show('请填写统一社会信用代码/组织机构代码')
				return true
			}
			if(!(/^[a-zA-Z\d-_]+$/.test(enterpriseCode))){
				Toast.show('请输入正确的统一社会信用代码/组织机构代码')
				return true
			}
			if(!(srcEn || msg.company_img && msg.company_img.length || null)){
				Toast.show('请上传资质证明图片')
				return true
			}

            // manageValidate = [{
            //     data: this.enterpriseName
            //     , type: ['required', 'minLength_2']
            //     , errorMsg: ['请填写企业全称', '企业名称不能小于2个字']
            // }, {
            //     data: this.enterpriseCode
            //     , type: ['required']
            //     , errorMsg: ['请填写统一社会信用代码/组织机构代码']
            // }, {
            //     data: this.enterpriseCode
            //     , type: ['custom']
            //     , reg: /^[a-zA-Z\d-_]+$/
            //     , errorMsg: ['请输入正确的统一社会信用代码/组织机构代码']
            // }, {
            //     data: srcEn || msg.company_img && msg.company_img.length || null
            //     , type: ['required']
            //     , errorMsg: ['请上传资质证明图片']
            // }];

            // validate = validate.concat(manageValidate);
        } else {
            // validate.push({
            //     data: Number(msg.have_basic_info) && Number(msg.have_team_introduce) && Number(msg.have_project_experience) || null
            //     , type: ['required']
            //     , errorMsg: ['请完善名片资料']
			// });
			if(!(Number(msg.have_basic_info) && Number(msg.have_team_introduce) && Number(msg.have_project_experience))){
				Toast.show('请完善名片资料')
				return true
			}

            // 班组长企业认证
            // if (workerLeaderEn)
            //     validate = validate.concat(manageValidate);
        }
        // let info_complete = !!(msg.idcard && (msg.imgs.length || src) && Number(msg.have_basic_info) && Number(msg.have_team_introduce) && Number(msg.have_project_experience));
        // let allow_renewal = Number(msg.status) === 2 && Number(msg.time_left_day) < 90;

        // if (Verification.bind(this, validate)())
        //     return true;

        return false;
    }
	
	const submit = () => {
		// let {msg, srcEn, defaultSrcEn, workerLeaderEn} = this.state
        //     , {manage} = this
		//     , status = Number(msg.status);
		let status = +detail.status
		// status = 0
        // 认证失败或成功(人前往付款页面)
        if (status === -1 || status === 2) {
            if (manage) {
                msg.status = 0;
                this.setState({
                    msg: msg
                }, () => {
                    this.rollTop();
                })
            } else{
				// this.props.router.push('/my/attest/pay?role=' + this.role);
				navigation.navigate('Recruit_authenpay',{role:type})
			}
        }else if (!status || status === 0 || status === 1) {
            if (allowSubmit()) return false
            let postMsg = {}//new FormData();
            if (!manage) {
				postMsg = {
					'is_have_company_info': workerLeaderEn ? '1' : '0',
					'auth_type': type
				}
                // postMsg.append('is_have_company_info', workerLeaderEn ? '1' : '0');
                // postMsg.append('auth_type', type);
            }

            // 企业上传数据
			
			if (manage || workerLeaderEn) {
				postMsg.company_name=enterpriseName
				postMsg.company_code=enterpriseCode
                // postMsg.append('company_name', enterpriseName);
                // postMsg.append('company_code', enterpriseCode);

                let enImg = manage ? detail.companyInfo.company_img : detail.company_img;

                if (srcEn) {
                    if (this.enterpriseImg) {
                        enImg = this.enterpriseImg;
                    }
                }

				postMsg.company_img= enImg
				// postMsg.append('company_img', enImg);
			}
			

			/*
            reduxPost(this.props, {
                url: manage ? 'v2/company/commitcompanyauth' : 'auth-info/post-commit'
                , newApi: !manage
                , type: 'POST'
                , data: postMsg
                , processData: false
                , contentType: false
                , success: res => {
                    this.rollTop();
                    if (manage || workerLeaderEn)
                        res = this.dataClear.bind(this, res)();

                    this.setState({
                        msg: res
                        , [manage ? 'srcEn' : '']: null
                        , [manage ? 'defaultSrcEn' : '']: res.company_img && GLOBAL.imgUrl + res.company_img        // 企业资质图片
                    });
                    this.props.SynData({
                        isShow: true
                        , text: '提交成功'
                        , type: 'success'
                    }, 'SYN_REMINDER')
                }
			})
			*/
			fetchFun.load({
				url: manage ? 'v2/company/commitcompanyauth' : 'auth-info/post-commit',
				newApi: !manage,
				type: 'POST',
				data: {
					...postMsg
				},
				success: (res) => {
					if (manage || workerLeaderEn){
						updateDetail(res)
						if(manage){
							setSrcEn(null)
						}
					}

					Toast.show('提交成功')		
				}
			})
        }
	}
	/**
	 * 选择图片
	 * @param {boolean} isEn 是否是企业 
	 */
	const pickImage = (isEn) => {
		if((!isEn && !(state_num < 2 && state_num > -1)) || (isEn && !((state_num < 2 && state_num > -1) || !state_num))){
			return
		}

		if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.MyNativeModule.singleSelectPicture('', (res) => {
				console.log('singleSelectPicture',res)
				// res 是字符串
				let src = res.slice(2,-2)
				if(isEn){
					setSrcEn(src)
				}else{
					setSrc(src)
				}
				
				// receiveImg()
			})
		}
		if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
			ImagePicker.showImagePicker(options, (response) => {
				console.log('Response = ', response);

				if (response.didCancel) {
					console.log('User cancelled image picker');
				} else if (response.error) {
					console.log('ImagePicker Error: ', response.error);
				} else if (response.customButton) {
					console.log('User tapped custom button: ', response.customButton);
				} else {
					if(isEn){
						setSrcEn(response.uri)
					}else{
						setSrc(response.uri)
					}
					// receiveImg();
				}
			});
		}


		// ImagePicker.showImagePicker(options, (response) => {
		// 	console.log('Response = ', response);
		  
		// 	if (response.didCancel) {
		// 		console.log('User cancelled image picker');
		// 	} else if (response.error) {
		// 		console.log('ImagePicker Error: ', response.error);
		// 	} else if (response.customButton) {
		// 		console.log('User tapped custom button: ', response.customButton);
		// 	} else {
		// 	  	// const source = { uri: response.uri };

		// 	  	// You can also display the image using data:
		// 	  	// const source = { uri: 'data:image/jpeg;base64,' + response.data }
		// 	  	//   this.setState({
		// 		// 		avatarSource: source
		// 		//   });
		// 		let src = 'data:image/jpeg;base64,' + response.data
		// 		if(isEn){
		// 			setSrcEn(src)
		// 		}else{
		// 			setSrc(src)
		// 		}
		// 	}
		// })
	}

	useEffect(() => {
		receiveImg()
	},[src])

	// 人证对比图片上传
    const receiveImg = () => {
		if(!src) return
		// this.setState({
        //     src: img.bs64
        // });

        let da = new FormData();
        // let {manage} = this;
		// latestSrc.current = src
		
        if (manage) {
            // da.append(manage ? 'personImg' : 'upload_files', img.file);
            // da.append('personImg', img.file);
            // reduxPost(this.props, {
            //     url: 'v2/company/commitpersonimg'
            //     , data: da
            //     , type: 'POST'
            //     , processData: false
            //     , contentType: false
            // })
        } else {
			// da.append('file[]', file);
			// let reader = new FileReader()
			// reader.readAsDataURL('file://'+src)
			// reader.onload(()=>{
			// 	console.log(reader.result)	
			// })
			fetchFun.load({
				url: 'v2/tool/upimg',
				type: 'POST',
				data: {
					'file[]':{uri: 'file://'+src, type: 'multipart/form-data', name: 'a.jpg'}
				},
				success: (res) => {
					console.log('post-img',res)
					fetchFun.load({
						url: 'auth-info/post-img',
						newApi: true,
						type: 'POST',
						data: {
							file_url: res[0],
							auth_type: type
						},
						success: (res) => {}
					})
				}
			})
			
			/*
            reduxPost(this.props, {
                url: ''
                // , newApi: true
                , type: 'POST'
                , data: da
                , processData: false
                , contentType: false
                , success: res => {
                    console.log(res);
                    reduxPost(this.props, {
                        url: 'auth-info/post-img'
                        , newApi: true
                        , data: {
                            file_url: res[0]
                            , auth_type: this.role
                        }
                        , type: 'POST'
                    })
                }
			});
			*/
        }
    }

	const linkPage=(params)=>{
		if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.MyNativeModule.openWebView(params)
		}
		if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
			NativeModules.JGJRecruitmentController.openWebView(params)
		}
	}

	return (
		<>
		<ScrollView>
			{resRender()}
			{idCard()}
			{/* <View
				style={{
					paddingTop:8,
					paddingRight:10,
					paddingBottom:8,
					paddingLeft:10,
					backgroundColor:'#ebebeb',
					flex:1,
					flexDirection:'row',
					alignItems: 'center',
					flexBasis:40,
					flexGrow:0
				}}
			>
				<Text>认证信息</Text>
			</View>
			<View style={{paddingRight:10,paddingLeft:10,paddingBottom:40}}>
				<View style={{flexDirection:'row',alignItems:'center',marginTop:12,marginBottom:12}}>
					<Text style={sty.dot}>1</Text><Text>实名认证</Text>
				</View>
				<View style={{flexDirection:'row',alignItems:'center'}}>
					<Text>姓名</Text><Text>({detail.idcard.replace(/\d{6}(?=(\d{2}|\d{1}x)$)/i, '******')})</Text>
				</View>
			</View> */}
			{/* 灰色条 */}
			<View style={{backgroundColor:'#ebebeb',paddingTop:10}}></View>
			<View style={{paddingRight:10,paddingLeft:10}}>
				<View style={{flexDirection:'row',alignItems:'center',marginTop:12,marginBottom:12}}>
					<Text style={sty.dot}>2</Text><Text>人证对比</Text>
				</View>
				{/* <Image
					source={{uri:'file:///storage/emulated/0/Pictures/Screenshots/Screenshot_2019-02-23-15-31-52.png'}}
					style={{width: 195, height: 195,paddingBottom:20}}
				/> */}
				<TouchableOpacity activeOpacity={.7}
					onPress={()=>pickImage()}
					style={{justifyContent:'center',alignItems:'center'}}
				>
					<ImageBackground
						source={{uri:`${src ? 'file://'+src : defaultSrc}`}}
						style={{position:'relative',borderRadius:4,width: 195, height: 195,paddingBottom:20,marginBottom:20}}
                	    className={`attest__upload ${(src || detail.imgs.length) && (state_num !== 2 && state_num !== -1) ? 'attest__upload__mark' : ''}`}
					>
						{state_num < 2 && state_num > -1?
							<View
								style={{
									flexDirection:'row',
									alignItems:'center',
									justifyContent:'center',
									borderRadius:50,
									backgroundColor: '#dbbf81',
									width:50,
									height:50,
									lineHeight:50
								}}
							>
                	            <Icon name="camera" size={30} color="#fff" />
							</View>:
							null
                	    }
						{/*state_num < 2 && state_num > -1?
							// <input
							// 	className="attest__upload__input" id="file" type="file"
                	        //              onChange={this.getImg}
                	        //              accept="image/jpg, image/jpeg, image/png, image/bmp, image/gif"/>
                	        : null
                	    */}
                	</ImageBackground>
				</TouchableOpacity>
				{/* <Image
					style={{ width: 195, height: 195 }}
                    source={{uri:`${GLOBAL.server}${detail.imgs[0]}`}}
				></Image> */}
				{state_num < 2 && state_num > -1?
					<Text style={{marginBottom:4,marginTop:5,fontSize:12,color:'#666',textAlign:'center'}}>{src || detail.imgs.length ? '（点击图片重新提交）' : '（请手持身份证拍摄一张人像及身份证清晰的照片）'}</Text>:
					null
                }
			</View>
			{/* 灰色条 */}
			<View style={{backgroundColor:'#ebebeb',paddingTop:10}}></View>
			<View>
				<Flex
					style={{
						marginTop:12,
						marginBottom:20,
						paddingBottom:10,
						paddingRight:10,
						paddingLeft:10,
						justifyContent:'space-between',
						borderBottomWidth:1,
						borderColor:'#dbdbdb'
					}}
				>
					<Flex><Text style={sty.dot}>3</Text><Text>名片资料</Text></Flex>
					{manage?
						null:
						<Text
							onPress={()=>linkPage('my/resume')}
							style={{
								color: '#f18215',
								borderWidth:1,
								borderColor:'#f18215',
								borderRadius:2,
								paddingLeft:10,
								paddingRight:10
							}}
						>
							去完善
						</Text>
					}
				</Flex>
				{manage?
					null:
					<Flex
						style={{
							justifyContent:'space-around',
							paddingBottom:16
						}}
					>
						<TouchableOpacity activeOpacity={.7}
							onPress={()=>linkPage('my/info')}
							style={{alignItems:'center',position:'relative'}}
						>
							<Image
								style={{ width: 36, height: 36, marginBottom: 8 }}
                		        source={detail.have_basic_info?require('../../../assets/recruit/at-base-ac.png'):require('../../../assets/recruit/at-base.png')}
							></Image>
							<Text>基本信息</Text>
							{detail.have_basic_info?
								<Icon style={{ position: 'absolute',top:0,right:7 }} name="success" size={14} color="#eb4e4e" />:
								null
							}
						</TouchableOpacity>
						<TouchableOpacity activeOpacity={.7}
							onPress={()=>linkPage('my/introduce')}
							style={{alignItems:'center',position:'relative'}}
						>
							<Image
								style={{ width: 36, height: 36, marginBottom: 8 }}
                		        source={detail.have_team_introduce?require('../../../assets/recruit/at-team-ac.png'):require('../../../assets/recruit/at-team.png')}
							></Image>
							<Text>队伍介绍</Text>
							{detail.have_team_introduce?
								<Icon style={{ position: 'absolute',top:0,right:7 }} name="success" size={14} color="#eb4e4e" />:
								null
							}
						</TouchableOpacity>
						<TouchableOpacity activeOpacity={.7}
							onPress={()=>linkPage('my/exp')}
							style={{alignItems:'center',position:'relative'}}
						>
							<Image
								style={{ width: 36, height: 36, marginBottom: 8 }}
                		        source={detail.have_project_experience?require('../../../assets/recruit/at-exp-ac.png'):require('../../../assets/recruit/at-exp.png')}
							></Image>
							<Text>项目经验</Text>
							{detail.have_project_experience?
								<Icon style={{ position: 'absolute',top:0,right:7 }} name="success" size={14} color="#eb4e4e" />:
								null
							}
						</TouchableOpacity>
					</Flex>
				}
			</View>
			{/*班组长企业认证选择*/}
			{!manage && (type === 2 && state_num < 2 && state_num > -1) && selectCompanyAttest()}
			{/*企业资质渲染*/}
			{(manage || workerLeaderEn) && imgForEnterprise()}
			{/*认证说明渲染*/}
			{state_num==0?instructionRender():null}
			{/*认证成功特权渲染*/}
			{state_num==2?
				<>
					<View
						style={{
							paddingTop:8,
							paddingRight:10,
							paddingBottom:8,
							paddingLeft:10,
							backgroundColor:'#ebebeb',
							flex:1,
							flexDirection:'row',
							alignItems: 'center',
							flexBasis:40,
							flexGrow:0
						}}
					>
						<Text>我的特权</Text>
					</View>
					<View style={{paddingLeft:10,paddingRight:10}}>
						{teq.map((item,index)=>{
							return (
								<Flex key={index} style={{paddingTop:14,paddingBottom:14,borderBottomWidth:1,borderColor:'#dbdbdb'}}>
									<Image
										style={{ width: 34, height: 34, marginRight: 14 }}
            		    	    	    source={{uri:`${GLOBAL.server}public/imgs/my/at-icon-${item.icon}.png`}}
									></Image>
									<Text>{item.desc}</Text>
								</Flex>
							)
						})}
					</View>
				</>:
				null
			}
			{/* 灰色条 */}
			<View style={{backgroundColor:'#ebebeb',paddingTop:60}}></View>
		</ScrollView>
			{Number(detail.time_left_day) > 90 && state_num === 2 ?
                null :
                <Btn>
					<Text
						onPress={submit}
						style={{
							backgroundColor:'#eb4e4e',
							color:'#fff',
							fontSize:17,
							paddingTop:10,
							paddingBottom:10,
							textAlign:'center',
							borderRadius:4
						}}
					>{btnState[state_num + 1]}</Text>
				</Btn>
            }
		</>
	)
}

const sty = StyleSheet.create({
    dot: {
		width:16,
		lineHeight:16,
		color:'#fff',
		backgroundColor:'#000',
		borderRadius:10,
		marginRight:5,
		textAlign:'center'
    }
})


export default withNavigation(Index)
