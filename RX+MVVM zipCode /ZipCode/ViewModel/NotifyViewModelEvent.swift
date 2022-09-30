//  NotifyViewModelEvent.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation

protocol NotifyModule: class {
    var onEvent: Closure<NotifyModuleEvent> { get }
}

enum NotifyModuleEvent {
    case sendNotify
    case faq
}
