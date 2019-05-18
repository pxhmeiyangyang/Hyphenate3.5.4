//
//  KPEMMonitoringVC.swift
//  EMChat
//
//  Created by pxh on 2019/5/17.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit

/// 环信聊天 监控界面
class KPEMMonitoringVC: UIViewController {

    /// 通话对象
    private var callSession: EMCallSession!
    
    /// 视屏界面
    lazy var videoView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    /// 控制界面
    lazy var controlView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    /// 控制界面背景
    lazy var controlBG: UIImageView = {
        let view = UIImageView()
        controlView.addSubview(view)
        view.image = UIImage.init(named: "video_bg")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 左侧按钮
    lazy var leftBTN: UIButton = {
        let view = UIButton()
        controlBG.addSubview(view)
        view.setBackgroundImage(UIImage.init(named: "video_anjian_L"), for: UIControlState.normal)
        view.setBackgroundImage(UIImage.init(named: "video_anjian_LS"), for: UIControlState.highlighted)
        return view
    }()
    
    /// 右侧控制按钮
    lazy var rightBTN: UIButton = {
        let view = UIButton()
        controlBG.addSubview(view)
        view.setBackgroundImage(UIImage.init(named: "video_anjian_R"), for: UIControlState.normal)
        view.setBackgroundImage(UIImage.init(named: "video_anjian_RS"), for: UIControlState.highlighted)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全监控"
        monitoring()
        deploySubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KPEMChatHelper.hangupVideoCall(aSession: self.callSession)
    }
    
    /// 监控
    private func monitoring(){
        EMClient.shared()?.callManager.add?(self, delegateQueue: nil)
        KPEMChatHelper.startVideoCall(name: testEMName, ext: "peep") { (callSession, error) in
        }
    }
    
    /// 接受通话调用
    ///
    /// - Parameter aSession: 通话对象
    private func receiveAnswer(aSession: EMCallSession){
        self.callSession = aSession
        //同意接听视频通话之后
        let videoView = KPEMChatHelper.receiveVideoCall(aSession: aSession, frame: CGRect.zero)
        self.videoView.addSubview(videoView)
        aSession.remoteVideoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 配置子view
    private func deploySubviews(){
        videoView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(261)
        }
        
        controlView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(videoView.snp.bottom)
        }
        
        controlBG.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        leftBTN.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.width.equalTo(180)
            make.height.equalTo(241)
            make.right.equalTo(controlBG.snp.centerX)
        }
        
        rightBTN.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.width.equalTo(180)
            make.height.equalTo(241)
            make.left.equalTo(controlBG.snp.centerX)
        }
    }
    
    deinit {
        EMClient.shared()?.callManager.remove?(self)
    }
    
}

// MARK: - EMCallManagerDelegate
extension KPEMMonitoringVC: EMCallManagerDelegate{
    /*!
     *  \~chinese
     *  用户A拨打用户B，用户B会收到这个回调
     *
     *  @param aSession  会话实例
     *
     *  \~english
     *  User B will receive this callback after user A dial user B
     *
     *  @param aSession  Session instance
     */
    func callDidReceive(_ aSession: EMCallSession!) {
        
    }
    /*!
     *  \~chinese
     *  通话通道建立完成，用户A和用户B都会收到这个回调
     *
     *  @param aSession  会话实例
     *
     *  \~english
     *  Both user A and B will receive this callback after connection is established
     *
     *  @param aSession  Session instance
     */
    func callDidConnect(_ aSession: EMCallSession!) {
        
    }
    /*!
     *  \~chinese
     *  用户B同意用户A拨打的通话后，用户A会收到这个回调
     *
     *  @param aSession  会话实例
     *
     *  \~english
     *  User A will receive this callback after user B accept A's call
     *
     *  @param aSession
     */
    func callDidAccept(_ aSession: EMCallSession!) {
        self.receiveAnswer(aSession: aSession)
    }
    /*!
     *  \~chinese
     *  1. 用户A或用户B结束通话后，双方会收到该回调
     *  2. 通话出现错误，双方都会收到该回调
     *
     *  @param aSession  会话实例
     *  @param aReason   结束原因
     *  @param aError    错误
     *
     *  \~english
     *  1.The another peer will receive this callback after user A or user B terminate the call.
     *  2.Both user A and B will receive this callback after error occur.
     *
     *  @param aSession  Session instance
     *  @param aReason   Terminate reason
     *  @param aError    Error
     */
    func callDidEnd(_ aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {

    }
    
    /*!
     *  \~chinese
     *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
     *
     *  @param aSession  会话实例
     *  @param aType     改变类型
     *
     *  \~english
     *  User A and B is on the call, A pause or resume the data stream, B will receive the callback
     *
     *  @param aSession  Session instance
     *  @param aType     Type
     */
    func callStateDidChange(_ aSession: EMCallSession!, type aType: EMCallStreamingStatus) {
        
    }
    
    /*!
     *  \~chinese
     *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
     *
     *  @param aSession  会话实例
     *  @param aStatus   当前状态
     *
     *  \~english
     *  User A and B is on the call, A network status is not stable, A will receive the callback
     *
     *  @param aSession  Session instance
     *  @param aStatus   Current status
     */
    func callNetworkDidChange(_ aSession: EMCallSession!, status aStatus: EMCallNetworkStatus) {
        
    }
    /*!
     *  \~chinese
     *  建立通话时，自定义语音类别
     *
     *  @param aCategory  会话语音类别
     *
     *  \~english
     *  Custom audio catrgory when setting up a call
     *
     *  @param aCategory  Audio catrgory
     */
    func callDidCustomAudioSessionCategoryOptions(withCategory aCategory: String!) {
        
    }
}