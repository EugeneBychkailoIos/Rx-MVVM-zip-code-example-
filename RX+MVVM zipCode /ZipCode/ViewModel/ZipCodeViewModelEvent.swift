//  ZipCodeViewModelEvent.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import Foundation

protocol ZipCodeModule: class {

    var onEvent: Closure<ZipCodeModuleEvent> { get }

}

enum ZipCodeModuleEvent {
    case didTapCheckAvaliability
    case sendCheck
    case codeNotFounded
    case faqButton
}
