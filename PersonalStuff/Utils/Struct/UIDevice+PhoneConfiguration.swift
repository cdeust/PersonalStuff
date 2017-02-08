//
//  UIDevice+PhoneConfiguration.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 08/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import AVFoundation
import ExternalAccessory
import CoreMotion

public enum LMSizeScale {
    case bytes
    case kilobytes
    case megabytes
    case gigabytes
}

public enum LMBatteryState: Int {
    case unknown
    case unplugged
    case charging
    case full
}

public struct Device {
    
    // MARK: System
    
    public struct System {
        
        // MARK: Network
        
        public struct Network {
            
            public static var isConnectedViaWiFi: Bool {
                let reachability = Reachability()!
                
                if reachability.isReachableViaWiFi {
                    return true
                } else {
                    return false
                }
            }
            
            public static var isConnectedViaCellular: Bool {
                return !isConnectedViaWiFi
            }
            
            public static var SSID: String {
                var currentSSID = ""
                if let interfaces:CFArray = CNCopySupportedInterfaces() {
                    for i in 0..<CFArrayGetCount(interfaces) {
                        let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                        let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                        let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                        if unsafeInterfaceData != nil {
                            let interfaceData = unsafeInterfaceData! as Dictionary!
                            for dictData in interfaceData! {
                                if dictData.key as! String == "SSID" {
                                    currentSSID = dictData.value as! String
                                }
                            }
                        }
                    }
                }
                
                return currentSSID
            }
        }
        
        // MARK: Locale
        
        public struct Locale {
            
            public static var currentLanguage: String {
                return NSLocale.preferredLanguages[0]
            }
            
            public static var currentTimeZone: TimeZone {
                return TimeZone.current
            }
            
            public static var currentTimeZoneName: String {
                return TimeZone.current.identifier
            }
            
            public static var currentCountry: String {
                return NSLocale.current.identifier
            }
            
            public static var currentCurrency: String? {
                return NSLocale.current.currencyCode
            }
            
            public static var currentCurrencySymbol: String? {
                return NSLocale.current.currencySymbol
            }
            
            public static var usesMetricSystem: Bool {
                return NSLocale.current.usesMetricSystem
            }
            
            public static var decimalSeparator: String? {
                return NSLocale.current.decimalSeparator
            }
        }
        
        // MARK: Carrier
        
        public struct Carrier {
            
            public static var name: String? {
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider {
                    return carrier.carrierName
                }
                
                return nil
            }
            
            public static var ISOCountryCode: String? {
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider {
                    return carrier.isoCountryCode
                }
                
                return nil
            }
            
            public static var mobileCountryCode: String? {
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider {
                    return carrier.mobileCountryCode
                }
                
                return nil
            }
            
            public static var networkCountryCode: String? {
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider {
                    return carrier.mobileNetworkCode
                }
                
                return nil
            }
            
            public static var allowsVOIP: Bool? {
                let netInfo = CTTelephonyNetworkInfo()
                if let carrier = netInfo.subscriberCellularProvider {
                    return carrier.allowsVOIP
                }
                
                return nil
            }
        }
        
        // MARK: Hardware
        
        public struct Hardware {
            
            public static var processorsNumber: Int {
                return ProcessInfo().processorCount
            }
            
            public static var activeProcessorsNumber: Int {
                return ProcessInfo().activeProcessorCount
            }
            
            public static func physicalMemory (withSizeScale sizeScale: LMSizeScale) -> Float {
                let physicalMemory = ProcessInfo().physicalMemory
                
                switch sizeScale {
                case .bytes:
                    return Float(physicalMemory)
                case .kilobytes:
                    return Float(physicalMemory * 1024)
                case .megabytes:
                    return Float(physicalMemory * 1024 * 1024)
                case .gigabytes:
                    return Float(physicalMemory * 1024 * 1024 * 1024)
                }
            }
            
            public static var systemName: String {
                return UIDevice.current.systemName
            }
            
            public static var systemVersion: String {
                return UIDevice.current.systemVersion
            }
            
            public static var bootTime: TimeInterval {
                return ProcessInfo().systemUptime
            }
            
            // MARK: Screen
            
            public struct Screen {
                
                public static var brightness: Float {
                    return Float(UIScreen.main.brightness)
                }
                
                public static var isScreenMirrored: Bool {
                    if let _ = UIScreen.main.mirrored {
                        return true
                    }
                    
                    return false
                }
                
                public static var nativeBounds: CGRect {
                    return UIScreen.main.nativeBounds
                }
                
                public static var nativeScale: Float {
                    return Float(UIScreen.main.nativeScale)
                }
                
                public static var bounds: CGRect {
                    return UIScreen.main.bounds
                }
                
                public static var scale: Float {
                    return Float(UIScreen.main.scale)
                }
                
                public static var snapshotOfCurrentView: UIView {
                    return UIScreen.main.snapshotView(afterScreenUpdates: true)
                }
            }
            
            // MARK: Device
            
            public struct Device {
                
                public static var current: CurrentDevice {
                    return CurrentDevice.deviceInformation()
                }
                
                public static var identifierForVendor: String? {
                    return UIDevice.current.identifierForVendor?.uuidString
                }
                
                public static var orientation: UIDeviceOrientation {
                    return UIDevice.current.orientation
                }
            }
            
            // MARK: Accessory
            
            public struct Accessory {
                
                public static var count: Int {
                    return EAAccessoryManager.shared().connectedAccessories.count
                }
                
                public static var connectedAccessoriesNames: [String] {
                    var theNames: [String] = []
                    for accessory in EAAccessoryManager.shared().connectedAccessories {
                        theNames.append(accessory.name)
                    }
                    
                    return theNames
                }
                
                public static var connectedAccessories: [EAAccessory] {
                    return EAAccessoryManager.shared().connectedAccessories
                }
                
                public static var isHeadsetPluggedIn: Bool {
                    let route = AVAudioSession.sharedInstance().currentRoute
                    for desc in route.outputs {
                        if desc.portType == AVAudioSessionPortHeadphones {
                            return true
                        }
                    }
                    
                    return false
                }
            }
            
            // MARK: Sensors

            public struct Sensors {

                public static var isAccelerometerAvailable: Bool {
                    return CMMotionManager.init().isAccelerometerAvailable
                }
                
                public static var isGyroAvailable: Bool {
                    return CMMotionManager.init().isGyroAvailable
                }
                
                public static var isMagnetometerAvailable: Bool {
                    return CMMotionManager.init().isMagnetometerAvailable
                }
                
                public static var isDeviceMotionAvailable: Bool {
                    return CMMotionManager.init().isDeviceMotionAvailable
                }
            }
        }
        
        // MARK: Disk
        
        public struct Disk {
            
            private static func MBFormatter(_ bytes: Int64) -> String {
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = ByteCountFormatter.Units.useMB
                formatter.countStyle = ByteCountFormatter.CountStyle.decimal
                formatter.includesUnit = false
                
                return formatter.string(fromByteCount: bytes) as String
            }
            
            public static var totalSpace: String {
                return ByteCountFormatter.string(fromByteCount: totalSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            
            public static var freeSpace: String {
                return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            
            public static var usedSpace: String {
                return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            
            public static var totalSpaceInBytes: Int64 {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                    
                    return space!
                } catch {
                    return 0
                }
            }
            
            public static var freeSpaceInBytes: Int64 {
                do {
                    let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                    let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                    
                    return freeSpace!
                } catch {
                    return 0
                }
            }
            
            public static var usedSpaceInBytes: Int64 {
                let usedSpace = totalSpaceInBytes - freeSpaceInBytes
                
                return usedSpace
            }
        }
        
        // MARK: Battery
        
        public struct Battery {
            
            private static var device: UIDevice {
                get {
                    let dev = UIDevice.current
                    dev.isBatteryMonitoringEnabled = true
                    
                    return dev
                }
            }
            
            public static var level: Float? {
                let batteryCharge = device.batteryLevel
                if batteryCharge > 0 {
                    return batteryCharge * 100
                } else {
                    return nil
                }
            }
            
            public static var state: LMBatteryState {
                switch device.batteryState {
                case .unknown:
                    return LMBatteryState.unknown
                case .unplugged:
                    return LMBatteryState.unplugged
                case .charging:
                    return LMBatteryState.charging
                case .full:
                    return LMBatteryState.full
                }
            }
        }
    }
}
