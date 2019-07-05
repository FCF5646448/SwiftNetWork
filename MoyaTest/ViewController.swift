//
//  ViewController.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/3.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import HandyJSON

class ViewController: UIViewController {

    var tb:UITableView!
    var channels:[ChannelItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        getData()
        
    }

    func initUI() {
        tb = UITableView(frame: self.view.frame, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tb)
    }
    
    func getData() {
        
        NetManager<ChannelItem>().request(ApiRequest.channelsApi, success: { (response) in
            
        })
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //获取选中项信息
        let obj = channels[indexPath.row]
     
        var param = [String:Any]()
        param["channel"] = obj.channel_id
        param["type"] = "n"
        param["from"] = "mainsite"
        NetManager<ChannelItem>().request(ApiRequest.playlistApi, param, success: { (response) in
//            if let objc:Song = response?.resObj {
//                let message = "歌手:\(objc.artist ?? "")\n 歌曲:\(objc.title ?? "")"
//                
//                let alertController = UIAlertController(title: objc.title,
//                                                        message: message, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//                
//            }
        })
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tb.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        //设置单元格内容
        let obj = channels[indexPath.row]
        cell.textLabel?.text = obj.name
        
        return cell
    }
    
    
}

