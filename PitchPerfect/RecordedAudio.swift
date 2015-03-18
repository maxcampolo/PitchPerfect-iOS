//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Max Campolo on 3/12/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    var title: NSString!
    var filePathURL: NSURL!
    
    init(audioTitle: NSString!, audioFilePath: NSURL!) {
        title = audioTitle
        filePathURL = audioFilePath
    }
}
