//
//  ViewController.swift
//  FlyingOverThePlanet
//
//  Created by user04 on 2018/9/24.
//  Copyright © 2018年 jerryHU. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var highScore: UILabel!
    let config = GameConfig.shared
    let scoreText = GameConfig.shared.highScore
    
    lazy var settingView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        
        let alphaView = UIView()
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.8
        bgView.addSubview(alphaView)
        alphaView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(bgView)
        }
        
        let bgImage = UIImageView(image:#imageLiteral(resourceName: "设置弹窗"))
        bgImage.isUserInteractionEnabled = true
        bgView.addSubview(bgImage)
        bgImage.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        
        let cancelButton = UIButton()
        cancelButton.setImage(#imageLiteral(resourceName: "叉"), for: .normal)
        cancelButton.tag = 31
        cancelButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        bgView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints({ (make) in
            make.top.equalTo(bgImage)
            make.left.equalTo(bgImage.snp.right)
        })
        
        let labelMusic = UILabel()
        labelMusic.textColor = UIColor.white
        labelMusic.text = "音乐"
        labelMusic.font = UIFont.systemFont(ofSize: 21)
        bgImage.addSubview(labelMusic)
        labelMusic.snp.makeConstraints({ (make) in
            make.left.equalTo(bgImage).offset(57)
            make.top.equalTo(bgImage).offset(108)
        })
        
        let labelEffect = UILabel()
        labelEffect.textColor = UIColor.white
        labelEffect.text = "音效"
        labelEffect.font = UIFont.systemFont(ofSize: 21)
        bgImage.addSubview(labelEffect)
        labelEffect.snp.makeConstraints({ (make) in
            make.left.equalTo(labelMusic)
            make.top.equalTo(labelMusic.snp.bottom).offset(35)
        })
        
        let musicButton = UIButton()
        musicButton.isSelected = config.isGameMusic
        musicButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)
        musicButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        musicButton.tag = 10
        musicButton.addTarget(self, action: #selector(settingClick(_:)), for: .touchUpInside)
        bgImage.addSubview(musicButton)
        musicButton.snp.makeConstraints({ (make) in
            make.left.equalTo(labelMusic.snp.right).offset(14)
            make.centerY.equalTo(labelMusic)
        })
        
        let soundButton = UIButton()
        soundButton.isSelected = config.isGameSound
        soundButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)
        soundButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        soundButton.tag = 11
        soundButton.addTarget(self, action: #selector(settingClick(_:)), for: .touchUpInside)
        bgImage.addSubview(soundButton)
        soundButton.snp.makeConstraints({ (make) in
            make.left.equalTo(labelEffect.snp.right).offset(14)
            make.centerY.equalTo(labelEffect)
        })
        
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.tag = 30
        button.setImage(#imageLiteral(resourceName: "关于我们"), for: .normal)
        bgImage.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImage)
            make.top.equalTo(labelEffect.snp.bottom).offset(43)
        }
        
        return bgView
    }()
    
    lazy var informationView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        
        let alphaView = UIView()
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.8
        bgView.addSubview(alphaView)
        alphaView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(bgView)
        }
        
        let bgImage = UIImageView(image:#imageLiteral(resourceName: "玩法说明弹窗"))
        bgImage.isUserInteractionEnabled = true
        bgView.addSubview(bgImage)
        bgImage.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
        
        let cancelButton = UIButton()
        cancelButton.setImage(#imageLiteral(resourceName: "叉"), for: .normal)
        cancelButton.tag = 32
        cancelButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        bgView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints({ (make) in
            make.top.equalTo(bgImage)
            make.left.equalTo(bgImage.snp.right)
        })
        
        let arr = ["1、玩家用一架飞机一直飞行","2、中途会出现各种障碍物","3、核心玩法是飞机飞行过程中要躲避各种障碍物哦！","4、飞机碰到障碍物游戏结束", "5、飞机所飞行的时间为标准得分，飞得越久得分越高！"]
        for i in 0..<arr.count{
            let label1 = UILabel()
            label1.textColor = UIColor.white
            label1.font = UIFont.systemFont(ofSize: 13)
            label1.text = arr[i]
            label1.numberOfLines = 0
            bgView.addSubview(label1)
            label1.snp.makeConstraints({ (make) in
                make.centerX.equalTo(bgImage)
                make.top.equalTo(bgImage).offset(60 + i * 200 / 4)
                make.width.equalTo(150)
                make.height.equalTo(200 / 4)
            })
        }
        
        return bgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var scoreText = defaults.object(forKey: "highScore") as? String
        if scoreText == nil {
            scoreText = "00:00.000"
            defaults.set(scoreText, forKey: "highScore")
        }
        highScore.text = "最高分:\(scoreText!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openWebView() {
        let webview = WebViewController()
        webview.urlStr = "http://static.tuyouli.net/Rocket/index.html"
        var top = UIApplication.shared.keyWindow?.rootViewController
        while ((top?.presentedViewController) != nil) {
            top = top?.presentedViewController
        }
        top?.present(webview, animated: true, completion: nil)
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        if sender.tag == 10 {
            openInformation()
        }
        
        if sender.tag == 12 {
            openSetting()
        }
        
        if sender.tag == 30 {
            openWebView()
        }
        
        if sender.tag == 31 {
            settingView.removeFromSuperview()
        }
        
        if sender.tag == 32 {
            informationView.removeFromSuperview()
        }
    }
    
    @objc func settingClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.tag == 10 {
            //音樂
            config.isGameMusic = sender.isSelected
        }
        if sender.tag == 11 {
            //音效
            config.isGameSound = sender.isSelected
        }
    }
    
    func openInformation() {
        view.addSubview(informationView)
        informationView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
    
    func openSetting() {
        view.addSubview(settingView)
        settingView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
    
}

