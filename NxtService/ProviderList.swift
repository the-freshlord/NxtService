//
//  ProviderList.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/25/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class ProviderList<T, D: Comparable, I> {
    private var _head: ProviderNode<T,D,I> = ProviderNode<T,D,I>()
    private var _tail: ProviderNode<T,D,I>?
    private var _count = 0
    
    var count: Int {
        return _count
    }
    
    func isEmpty() -> Bool {
        return _count == 0
    }
    
    func insertProvider(providerKey: T, distance: D, image: I) {
        // Check if the list is empty
        if _head.providerKey == nil {
            _head.providerKey = providerKey
            _head.distance = distance
            _head.image = image
            _tail = _head
            _count += 1
            return
        }
        
        // Get a pointer to the first node of the list
        var current: ProviderNode? = _head
        
        // Traverse through the list
        while current != nil {
            if current?.previous == nil && current?.distance > distance {
                
                // Insert new node to front of the list
                let providerNode: ProviderNode = ProviderNode<T,D,I>()
                providerNode.providerKey = providerKey
                providerNode.distance = distance
                providerNode.image = image
                providerNode.next = current
                current?.previous = providerNode
                _head = providerNode
                _count += 1
                break
            } else if current?.next == nil && current?.distance < distance {
                
                // Insert new node to the end of the list
                let providerNode: ProviderNode = ProviderNode<T,D,I>()
                providerNode.providerKey = providerKey
                providerNode.distance = distance
                providerNode.image = image
                providerNode.previous = current
                current?.next = providerNode
                _tail = providerNode
                _count += 1
                break
            } else if distance > current?.distance && distance < current?.next?.distance {
                
                // Insert new node between two existing nodes
                let providerNode: ProviderNode = ProviderNode<T,D,I>()
                providerNode.providerKey = providerKey
                providerNode.distance = distance
                providerNode.image = image
                providerNode.previous = current
                providerNode.next = current?.next
                current?.next?.previous = providerNode
                current?.next = providerNode
                _count += 1
                break
            } else {
                
                // Move current pointer to the next node
                current = current?.next
            }
        }
    }
    
    func getProvider(position: Int) -> (T,D,I) {
        // Get a pointer to the first node of the list
        var current: ProviderNode! = _head
        var currentPosition = 0
        
        while current != nil {
            if currentPosition == position {
                break
            } else {
                current = current.next
                currentPosition += 1
            }
        }
        
        return (current.providerKey!, current.distance!, current.image!)
    }
}