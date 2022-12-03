//
//  Excutable.swift
//  Created by Gaurav Rajput


import Foundation

protocol Excutable {
    func excute(completion: ResultCallback)
}

protocol Downloadable {
    func download(completion: ResultCallback)
}

protocol Uploadable {
    func upload(completion: ResultCallback)
}

protocol Schedulable {
    func addToQueue()
    
    func removeFromQueue()
    
}

protocol Cancelable {
    func cancel()
}
