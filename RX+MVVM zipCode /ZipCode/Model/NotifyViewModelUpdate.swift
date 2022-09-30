//  NotifyViewModelUpdate.swift
//
//  Created by Eugene on 18/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation

extension NotifyViewModel {
    enum Update {
        case errorReceive
        case loading(Bool)
    }
}
