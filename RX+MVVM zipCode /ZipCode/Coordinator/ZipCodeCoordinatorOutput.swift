//  ZipCodeCoordinatorOutput.swift
//
//  Created by Eugene on 6/3/21.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import Foundation

protocol ZipCodeCoordinatorOutput: class {
  var finishFlow: (() -> Void)? { get set }
}
