//
//  MediaPlayerTimeExtension.swift
//  Pratice12345
//
//  Created by MacBook AIR on 21/09/2023.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let second = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hour = totalSeconds / 3600
        let timeFormatstring = String(format: "%02d:%02d:%02d",hour,minutes,second)
        
        
        return timeFormatstring
        
    }
    

}
