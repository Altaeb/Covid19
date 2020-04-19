//
//  DResult.swift
//  Covid19
//
//  Created by Abdalfattah Altaeb on 4/19/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

enum DResult<T>{
    case success(T)
    case error(String)
}
