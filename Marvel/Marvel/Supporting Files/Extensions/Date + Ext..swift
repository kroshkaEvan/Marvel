//
//  Date + Ext..swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation

extension Date {
    func getCurrentTimestamp() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
