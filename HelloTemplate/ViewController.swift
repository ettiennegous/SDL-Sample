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
    
    func getTextButton(text: String, id: Int, handler: @escaping SDLRPCButtonNotificationHandler) -> SDLSoftButton {
        let textSoftButton = SDLSoftButton()
        textSoftButton.handler = handler
        textSoftButton.type = .text
        textSoftButton.text = text
        textSoftButton.softButtonID = NSNumber(integerLiteral: id)
        return textSoftButton;
    }
    
    func getImageButton() -> SDLSoftButton {
        let textWithImageSoftButton = SDLSoftButton()
        textWithImageSoftButton.handler = { (press, _) in
            if let _ = press {
                if press?.buttonPressMode == SDLButtonPressMode.short {
                    print("text image button pressed")
                }
            }
        }
        textWithImageSoftButton.type = SDLSoftButtonType.both
        textWithImageSoftButton.text = "imageWithText"
        textWithImageSoftButton.image = SDLImage(name: "sdl_logo", ofType: SDLImageType.dynamic, isTemplate: false)
        textWithImageSoftButton.softButtonID = NSNumber(integerLiteral: 200)
        return textWithImageSoftButton;
    }
    
    func Screen1YesClick() -> SDLRPCButtonNotificationHandler {
    return {
        (press, _) in
        if let _ = press {
            if press?.buttonPressMode == SDLButtonPressMode.short {
                print("text button pressed")
            }
        }
        }
    }
    
    func DeadClick() -> SDLRPCButtonNotificationHandler {
        return {
            (press, _) in
            if let _ = press {
            }
        }
    }
    
    func BackHomeClick() -> SDLRPCButtonNotificationHandler {
        return {
            (press, _) in
                self.homeView();
        }
    }
    
    func getYesNoAlert(textField1: String, textField2: String?, textField3: String?, yesHandler: @escaping SDLRPCButtonNotificationHandler, noHandler: @escaping SDLRPCButtonNotificationHandler) -> SDLAlert {
            return SDLAlert(alertText1: textField1, alertText2: textField2, alertText3: textField3, duration: 3000, softButtons: [
                self.getTextButton(text: "NO", id: 1, handler: noHandler),
                self.getTextButton(text: "YES", id: 2, handler: yesHandler)])
    }
    
    func getAlert(textField1: String, textField2: String?) -> SDLAlert {
        return SDLAlert(alertText1: textField1, alertText2: textField2, alertText3: nil, duration: 3000, softButtons: nil)
    }
    
    func step1Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert = self.getYesNoAlert(
                textField1: "Great Oceon Road 2019",
                textField2: "Ready to begin trip?",
                textField3: nil,
                yesHandler: self.DeadClick(),
                noHandler: self.DeadClick())
                ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }
    
    func step2Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let screen2TrackingAlert = self.getAlert(textField1: "Finch will start tracking ", textField2: "your distance travelled")
            ProxyManager.sharedManager.sdlManager?.send(request: screen2TrackingAlert)
        }
    }
    
    func step4Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let display = SDLSetDisplayLayout(predefinedLayout: SDLPredefinedLayout.largeGraphicWithSoftButtons)
            ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
                if response?.resultCode == .success {
                    let sdlImage = SDLImage(name: "groupbill2", ofType: SDLImageType.dynamic, isTemplate: false)
                    let show = SDLShow()
                    show.graphic = sdlImage
                    show.alignment = SDLTextAlignment.right
                    show.softButtons = self.getGroupTrackingButtons()
                    ProxyManager.sharedManager.sdlManager?.send(request: show)
                }
                else {
                    print("An Error has occured")
                    //print(response?.resultCode)
                }
            }
        }
    }
    
    func getGroupTrackingButtons() -> [SDLSoftButton] {
        let BtnStep3Action1 = self.getTextButton(text: "Add group bill", id: 31, handler: self.BackHomeClick())
        let BtnStep3Action2 = self.getTextButton(text: "Expenses", id: 32, handler: self.BackHomeClick())
        let BtnStep3Action3 = self.getTextButton(text: "My places", id: 33, handler: self.BackHomeClick())
        let BtnStep3Action4 = self.getTextButton(text: "End trip", id: 34, handler: self.BackHomeClick())
        
        return [BtnStep3Action1, BtnStep3Action2, BtnStep3Action3, BtnStep3Action4]
    }

    func step3Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let screen2TrackingAlert = self.getAlert(textField1: "Kate & Jane joined your group", textField2: nil)
            ProxyManager.sharedManager.sdlManager?.send(request: screen2TrackingAlert)
        }
    }
    
    func step5Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let screen2TrackingAlert = self.getAlert(textField1: "Jane added 'AirBnB' to GOR.", textField2: "Total of $131")
            ProxyManager.sharedManager.sdlManager?.send(request: screen2TrackingAlert)
        }
    }
    
    func step6AClick() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            
            let display = SDLSetDisplayLayout(predefinedLayout: SDLPredefinedLayout.textWithGraphic)
            ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
                if response?.resultCode == .success {
                    let sdlImage = SDLImage(name: "map", ofType: SDLImageType.dynamic, isTemplate: false)
                    let show = SDLShow()
                    show.graphic = sdlImage
                    //show.alignment = SDLTextAlignment.right
                    //show.softButtons = self.getGroupTrackingButtons()
                    show.mainField1 = "1. A bottle of milk"
                    show.mainField2 = "2. Mexican Republic"
                    show.mainField3 = "3. Wonder Sushi"
                    show.mainField4 = "4. Gelastossimo"
                    ProxyManager.sharedManager.sdlManager?.send(request: show)
                }
                else {
                    print("An Error has occured")
                    //print(response?.resultCode)
                }
            }
        }
    }

    func step6BClick() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert = self.getYesNoAlert(
                textField1: "Ate at Wonder Sushi?",
                textField2: "Would you like to add the bill",
                textField3: "to group and split the cost?",
                yesHandler: self.DeadClick(),
                noHandler: self.DeadClick())
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }

    
    func step7Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let slider = SDLSlider(numTicks: 26, position: 2, sliderHeader: "$ Ammount", sliderFooter: "", timeout: 5000)
            //let alert = self.getAlert(
                //textField1: "Slider is Borken, Need to speak to Xevo")
            ProxyManager.sharedManager.sdlManager?.send(slider)
        }
    }
    
    func step8Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert = SDLAlert(alertText1: "Total bill for Wonder Sushi is $150.00", alertText2: "Select split option", alertText3: nil, duration: 3000, softButtons: [
                self.getTextButton(text: "Unequal Split", id: 1, handler: self.DeadClick()),
                self.getTextButton(text: "Equal Split", id: 2, handler: self.DeadClick())])
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }
    
    func step9Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert = self.getAlert(
                textField1: "Total of $150 for Wonder Sushi", textField2: "has been added to Great Ocean Road.")
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }
    
    func step10Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let display = SDLSetDisplayLayout(predefinedLayout: SDLPredefinedLayout.largeGraphicWithSoftButtons)
            ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
                let sdlImage = SDLImage(name: "groupbill3", ofType: SDLImageType.dynamic, isTemplate: false)
                let show = SDLShow()
                show.graphic = sdlImage
                show.alignment = SDLTextAlignment.right
                show.softButtons = self.getGroupTrackingButtons()
                ProxyManager.sharedManager.sdlManager?.send(request: show)
            }
        }
    }
    
    func step11Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            //113.9
            //5L/100KM
            //835KM
            //41.75L
            //$48
            let alert =  SDLAlert(alertText1: "Fuel cost: 113.9c/L & Usage: 5L/100Km", alertText2: "Total Distance: 835km", alertText3: "Total: $48" , duration: 3000, softButtons: nil)
            
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }

    func step12Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert = SDLAlert(alertText1: "Fuel costs have been added.", alertText2: "Close and settle group?", alertText3: nil, duration: 3000, softButtons: [
                self.getTextButton(text: "NO", id: 1, handler: self.DeadClick()),
                self.getTextButton(text: "YES", id: 2, handler: self.DeadClick())])
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }
    
    func step13Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let alert =  SDLAlert(alertText1: "You have sent a payment of", alertText2: "$123.45 to Jane and", alertText3: "requested $35.90 from Sarah" , duration: 3000, softButtons: nil)
            
            ProxyManager.sharedManager.sdlManager?.send(alert)
        }
    }
    
    func step14Click() -> SDLMenuCellSelectionHandler {
        return {
            (_) in
            let display = SDLSetDisplayLayout(predefinedLayout: SDLPredefinedLayout.largeGraphicOnly)
            ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
                let sdlImage = SDLImage(name: "carstats", ofType: SDLImageType.dynamic, isTemplate: false)
                let show = SDLShow()
                show.graphic = sdlImage
                show.alignment = SDLTextAlignment.right
                ProxyManager.sharedManager.sdlManager?.send(request: show)
            }
        }
    }
    
    func embedFile(filename: String, type: SDLFileType) {
        let putFile = SDLPutFile(fileName: filename, fileType: type)
        let image = UIImage(named: filename)
        putFile.persistentFile = NSNumber(booleanLiteral: true)
        putFile.systemFile = NSNumber(booleanLiteral: false)
        if(type == SDLFileType.PNG) {
            putFile.bulkData = image!.pngData()!
        } else if(type == SDLFileType.JPEG) {
            putFile.bulkData = image!.jpegData(compressionQuality: 100.0)!
        }
        ProxyManager.sharedManager.sdlManager?.send(request: putFile,
            responseHandler: { (request, response, error) in
                print("response is \(String(describing: response))")
                print("error is \(String(describing: error))")
        })
    }
    
    func homeView() {
        
        let display = SDLSetDisplayLayout(predefinedLayout: SDLPredefinedLayout.largeGraphicWithSoftButtons)
        ProxyManager.sharedManager.sdlManager?.send(request: display) { (request, response, error) in
            if response?.resultCode == .success {
                self.embedFile(filename: "sdl", type: SDLFileType.PNG);
                self.embedFile(filename: "groupbill2", type: SDLFileType.JPEG);
                self.embedFile(filename: "groupbill3", type: SDLFileType.JPEG);
                self.embedFile(filename: "map", type: SDLFileType.PNG);
                self.embedFile(filename: "home", type: SDLFileType.JPEG);
                self.embedFile(filename: "carstats", type: SDLFileType.PNG);
                let show = SDLShow()
                show.mainField1 = "Welcome to Finch"
                let BtnHome1 = self.getTextButton(text: "Payments", id: 31, handler: self.BackHomeClick())
                let BtnHome2 = self.getTextButton(text: "Groups", id: 32, handler: self.BackHomeClick())
                let BtnHome3 = self.getTextButton(text: "Expenses", id: 33, handler: self.BackHomeClick())
                let BtnHome4 = self.getTextButton(text: "Places", id: 34, handler: self.BackHomeClick())
                
                let sdlImage = SDLImage(name: "home", ofType: SDLImageType.dynamic, isTemplate: false)
                show.graphic = sdlImage
                show.alignment = SDLTextAlignment.right
                show.softButtons = [BtnHome1, BtnHome2, BtnHome3, BtnHome4]
                ProxyManager.sharedManager.sdlManager?.send(request: show)

            }
        }

    }
    
    func buildMenu() -> [SDLMenuCell] {
        let menuItem1 = SDLMenuCell(title: "Step 1", icon: nil, voiceCommands: ["Step 1", "Start Roadtrip"], handler: self.step1Click())
        let menuItem2 = SDLMenuCell(title: "Step 2", icon: nil, voiceCommands: ["Step 2", "Start Tracking"], handler: self.step2Click())
        let menuItem3 = SDLMenuCell(title: "Step 3", icon: nil, voiceCommands: ["Step 3", "Members joined group"], handler: self.step3Click())
        let menuItem4 = SDLMenuCell(title: "Step 4", icon: nil, voiceCommands: ["Step 4", "Show Group Tracking"], handler: self.step4Click())
        let menuItem5 = SDLMenuCell(title: "Step 5", icon: nil, voiceCommands: ["Step 5", "Add Expense"], handler: self.step5Click())
        let menuItem6A = SDLMenuCell(title: "Step 6A", icon: nil, voiceCommands: ["Step 6A", "Navigate to Wonder Sushi"], handler: self.step6AClick())

        let menuItem6B = SDLMenuCell(title: "Step 6B", icon: nil, voiceCommands: ["Step 6B", "Add Sushi Expense"], handler: self.step6BClick())
        let menuItem7 = SDLMenuCell(title: "Step 7", icon: nil, voiceCommands: ["Step 7", "Split Expense"], handler: self.step7Click())
        let menuItem8 = SDLMenuCell(title: "Step 8", icon: nil, voiceCommands: ["Step 8", "Split Equal or Unequal"], handler: self.step8Click())
        let menuItem9 = SDLMenuCell(title: "Step 9", icon: nil, voiceCommands: ["Step 9", "Total Bill Added"], handler: self.step9Click())
        let menuItem10 = SDLMenuCell(title: "Step 10", icon: nil, voiceCommands: ["Step 10", "Show Group Again"], handler: self.step10Click())
        let menuItem11 = SDLMenuCell(title: "Step 11", icon: nil, voiceCommands: ["Step 11", "Fuel Total"], handler: self.step11Click())
        let menuItem12 = SDLMenuCell(title: "Step 12", icon: nil, voiceCommands: ["Step 12", "Close Group"], handler: self.step12Click())
        let menuItem13 = SDLMenuCell(title: "Step 13", icon: nil, voiceCommands: ["Step 13", "Payment Sent"], handler: self.step13Click())
        let menuItem14 = SDLMenuCell(title: "Step 14", icon: nil, voiceCommands: ["Step 14", "Car Stats"], handler: self.step14Click())

        return [menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6A, menuItem6B, menuItem7, menuItem8, menuItem9, menuItem10, menuItem11, menuItem12, menuItem13, menuItem14]
    }
    
    func createMenuAndGlobalVoiceCommands() {
        // Send the root menu items
        let menuItems = buildMenu()
        if !menuItems.isEmpty { ProxyManager.sharedManager.sdlManager?.screenManager.menu = menuItems }
        
    }

    var hasSetup: Bool = false
    
    @objc func onHMIStatus(_ notification: SDLRPCNotificationNotification) {
        guard let onHMIStatus = notification.notification as? SDLOnHMIStatus else {
            return
        }

        if onHMIStatus.hmiLevel == .limited || onHMIStatus.hmiLevel == .full {
            if(!hasSetup) {
                createMenuAndGlobalVoiceCommands()
                self.homeView()
                self.SubscribeVehicleData()
                hasSetup = true

            }
        }
    }
    
    func SubscribeVehicleData() {
        let subscribeVD = SDLSubscribeVehicleData(
            accelerationPedalPosition: true,
            airbagStatus: true,
            beltStatus: true,
            bodyInformation: true,
            clusterModeStatus: true,
            deviceStatus: true,
            driverBraking: true,
            eCallInfo: true,
            electronicParkBrakeStatus: true,
            emergencyEvent: true,
            engineOilLife: true,
            engineTorque: true,
            externalTemperature: true,
            fuelLevel: true,
            fuelLevelState: true,
            fuelRange: true,
            gps: true,
            headLampStatus: true,
            instantFuelConsumption: true,
            myKey: true,
            odometer: true,
            prndl: true,
            rpm: true,
            speed: true,
            steeringWheelAngle: true,
            tirePressure: true,
            turnSignal: true,
            wiperStatus: true)
        
        ProxyManager.sharedManager.sdlManager?.send(request: subscribeVD, responseHandler: { (request, response, error) in
            print("SubscribeVehicleData response is \(String(describing: response))")
            print("SubscribeVehicleData error is \(String(describing: error))")
        })

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

