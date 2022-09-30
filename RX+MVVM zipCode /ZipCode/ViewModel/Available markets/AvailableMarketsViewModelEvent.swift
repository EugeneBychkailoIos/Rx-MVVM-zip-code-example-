//  AvailableMarketsViewModelEvent.swift
//
//  Created by Eugene on 19/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation

protocol AvailableMarketsModule: AnyObject {
    var onEvent: Closure<AvailableMarketsModuleEvent> { get }
}

enum AvailableMarketsModuleEvent {
    case moduleEvent
}
