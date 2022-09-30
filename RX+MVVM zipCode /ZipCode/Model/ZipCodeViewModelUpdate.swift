//  ZipCodeViewModelUpdate.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//


import Foundation

extension ZipCodeViewModel {
    enum Update {
        case initialSetup(title: String)
        case loading(Bool)
        case errorReceive
    }
}

