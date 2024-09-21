//
//  Item.swift
//  MykiInspectors
//
//  Created by Piripi Martin on 14/8/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
