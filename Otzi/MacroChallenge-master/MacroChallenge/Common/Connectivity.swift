//
//  Connectivity.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 02/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//


import Foundation
import Alamofire
import Network
class Connectivity {
    /// Property que indica se o usuário tem internet ou não
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}


class NetStatus {
    static let shared = NetStatus()
 
    private init() {
 
    }
    deinit {
        stopMonitoring()
    }
    var monitor: NWPathMonitor?
    
    var isMonitoring = false

    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
     
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    var didStartMonitoringHandler: (() -> Void)?
     
    var didStopMonitoringHandler: (() -> Void)?
     
    var netStatusChangeHandler: (() -> Void)?
    
    func startMonitoring() {
        guard !isMonitoring else { return }
     
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
     
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
     
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
}
