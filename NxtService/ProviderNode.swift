//
//  ProviderNode.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/25/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class ProviderNode<T,D> {
    var providerKey: T?
    var distance: D?
    var next: ProviderNode?
    var previous: ProviderNode?
}