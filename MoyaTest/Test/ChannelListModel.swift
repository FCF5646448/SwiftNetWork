//
//  ChannelListModel.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import HandyJSON

struct ChannelListModel: HandyJSON {
    var channels: [ChannelItem]?
}

struct ChannelItem: HandyJSON  {
    var name: String?
    var seq_id: Int = 0
    var abbr_en: String?
    var channel_id: Int = 0
    var name_en: String?
}


struct SongModel: HandyJSON {
    var is_show_quick_start: Int?
    var r:Int?
    var version_max:Int?
    var logout:Int?
    var warning:String?
    var song:[Song] = []
}

struct Song: HandyJSON {
    var status:Int?
    var picture:Int?
    var artist:String?
    var title:String?
    var url:String?
}

struct User: HandyJSON {
    var name:String?
    var id:String?
    
}


