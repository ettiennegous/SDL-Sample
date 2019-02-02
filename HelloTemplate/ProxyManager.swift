//
//  ProxyManager.swift
//  HelloVPM
//
//  Created by Takamitsu Yoshii on 2019/01/24.
//  Copyright © 2019年 XevoKK. All rights reserved.
//

import Foundation
import SmartDeviceLink

class ProxyManager: NSObject {
    private let appName = "HelloTemplate"
    private let appId = "123456789" // "com.xevo.testapp.0000.helloTemplate"

    // Manager
    var sdlManager: SDLManager!

    // Singleton
    static let sharedManager = ProxyManager()

    private override init() {
        super.init()
    }

    func connect() {
        // Used for USB Connection
        //let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, appId: appId)

        // Used for TCP/IP Connection
        //let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "10.10.120.41", port: 15324)

        // App icon image
        /*
         if let appImage = UIImage(named: "AppIcon Name") {
         let appIcon = SDLArtwork(image: appImage, name: "Name to Upload As", persistent: true, as: .JPG /* or .PNG */)
         lifecycleConfiguration.appIcon = appIcon
         }
         */

        let loggingConfig = SDLLogConfiguration.debug()
        loggingConfig.globalLogLevel = SDLLogLevel.verbose
        _ = loggingConfig.targets.insert(SDLLogTargetAppleSystemLog())

        lifecycleConfiguration.shortAppName = "HTMP"
        lifecycleConfiguration.appType = .default


        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .disabled(), logging: loggingConfig, fileManager: .default())

        sdlManager = SDLManager(configuration: configuration, delegate: self)

        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
            }
        }
    }
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
    }
}
