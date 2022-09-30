//  AvailableMarketsViewModelUpdate.swift
//
//  Created by Eugene on 19/08/2021.
//  Copyright (c) 2021. All rights reserved.
//

import Foundation

extension AvailableMarketsViewModel {
    enum Update {
        case loading(Bool)
        case errorReceive
    }
}
