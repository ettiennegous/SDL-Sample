//
//  ViewController.swift
//  HelloTemplate
//
//  Created by Takamitsu Yoshii on 2019/01/30.
//  Copyright © 2019年 XevoKK. All rights reserved.
//

import UIKit
import SmartDeviceLink

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self, selector: #selector(self.onHMIStatus), name: NSNotification.Name.SDLDidChangeHMIStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onVehicleData), name: NSNotification.Name.SDLDidReceiveVehicleData, object: nil)
    }

    @objc func onHMIStatus(_ notification: SDLRPCNotificationNotification) {
        guard let onHMIStatus = notification.notification as? SDLOnHMIStatus else {
            return
        }

        if onHMIStatus.hmiLevel == .limited || onHMIStatus.hmiLevel == .full {
            let display = SDLSetDisplayLayout(predefinedLayout: .nonMedia)
            ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
                if response?.resultCode == .success {
                    let putFile = SDLPutFile(fileName: "sdl_logo", fileType: SDLFileType.PNG)
                    let image = UIImage(named: "sdl")
                    putFile.persistentFile = NSNumber(booleanLiteral: true)
                    putFile.systemFile = NSNumber(booleanLiteral: false)
                    putFile.bulkData = image!.pngData()!

                    ProxyManager.sharedManager.sdlManager?.send(request: putFile, responseHandler: { (request, response, error) in
                        print("response is \(String(describing: response))")
                        print("error is \(String(describing: error))")

                        if response?.resultCode == .success {
                            let sdlImage = SDLImage(name: "sdl_logo", ofType: SDLImageType.dynamic, isTemplate: false)
                            let show = SDLShow()
                            show.graphic = sdlImage
                            show.mainField1 = "Hello"
                            ProxyManager.sharedManager.sdlManager?.send(request: show)
                        }
                    })

                }
            }

            let subscribeVD = SDLSubscribeVehicleData(accelerationPedalPosition: true, airbagStatus: true, beltStatus: true,
                                                      bodyInformation: true, clusterModeStatus: true, deviceStatus: true,
                                                      driverBraking: true, eCallInfo: true, electronicParkBrakeStatus: true,
                                                      emergencyEvent: true, engineOilLife: true, engineTorque: true, externalTemperature: true,
                                                      fuelLevel: true, fuelLevelState: true, fuelRange: true, gps: true, headLampStatus: true,
                                                      instantFuelConsumption: true, myKey: true, odometer: true, prndl: true, rpm: true,
                                                      speed: true, steeringWheelAngle: true, tirePressure: true, turnSignal: true, wiperStatus: true)

            ProxyManager.sharedManager.sdlManager?.send(request: subscribeVD, responseHandler: { (request, response, error) in
                print("SubscribeVehicleData response is \(String(describing: response))")
                print("SubscribeVehicleData error is \(String(describing: error))")
            })
        }
    }

    @objc func onVehicleData(_ notification: SDLRPCNotificationNotification) {
        guard let OnVehicleData = notification.notification as? SDLOnVehicleData else {
            return
        }

        let show = SDLShow()
        show.mainField2 = "GPS: \(String(describing: OnVehicleData.gps?.latitudeDegrees)), \(String(describing: OnVehicleData.gps?.longitudeDegrees))"
        show.mainField3 = "Speed: \(OnVehicleData.speed ?? NSNumber.init(integerLiteral: -1))"

        ProxyManager.sharedManager.sdlManager?.send(request: show)
    }
}

