//
//  ViewController.swift
//  LightbulbDemo
//
//  Created by Chris Beauchamp on 3/28/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import UIKit
import ThingIFSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var bulbImage: UIImageView!
    
    var api:ThingIFAPI?
    
    @IBAction func valuesChanged(sender: AnyObject) {
        self.sendCommand(["turnPower": ["power": self.powerSwitch.on]])
        self.sendCommand(["setBrightness": ["brightness": self.brightnessSlider.value]])
        self.sendCommand(["setColor": ["color": [self.redSlider.value, self.greenSlider.value, self.blueSlider.value]]])
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.getStates), name: "deviceUpdated", object: nil)

        do {
            try self.api = ThingIFAPI.loadWithStoredInstance()!
            self.getStates()
        } catch ThingIFError.API_NOT_STORED {
            // The instance has not stored
            self.onboard()
        } catch {
            // Error handling
            print("Unknown catch")
        }
    }
    
    func updateUIValues(result:Dictionary<String, AnyObject>) {
        self.powerSwitch.on = result["power"] as! Bool
        self.brightnessSlider.value = result["brightness"] as! Float
        
        let color:NSArray = result["color"] as! NSArray
        
        self.redSlider.value = color[0] as! Float
        self.greenSlider.value = color[1] as! Float
        self.blueSlider.value = color[2] as! Float
        self.updateUI()
    }
    
    func updateUI() {
        let powerOnColor:UIColor = UIColor.init(colorLiteralRed: self.redSlider.value/255, green: self.greenSlider.value/255, blue: self.blueSlider.value/255, alpha: self.brightnessSlider.value/255)
        self.bulbImage.backgroundColor = self.powerSwitch.on ? powerOnColor : UIColor.blackColor()
    }
    
    func getStates() {
        print("Getting states")

        if((self.api) != nil) {
            self.api!.getState() { (result: Dictionary<String, AnyObject>?, error: ThingIFError?) -> Void in
                if error == nil {
                    print(result)
                    self.updateUIValues(result!)
                } else {
                    print(error)
                }
            }
        } else {
            print("Can't get states without initialized api")
        }

    }
    
    func sendCommand(command:Dictionary<String, AnyObject>) {
        var actions = [Dictionary<String, AnyObject>]()
        actions.append(command)

        if((self.api) != nil) {
            self.api!.postNewCommand("SmartLightDemo", schemaVersion: 1, actions: actions, completionHandler: { (command: Command?, error: ThingIFError?)-> Void in
                if error != nil {
                    print(error)
                    // Error handling
                    return
                } else {
                    print("success")
                }
            })
        } else {
            print("Can't send command without initialized api")
        }
        
    }
    
    func onboard() {
        print("Onboarding")

        let typedUserID = TypedID(type: "user", id: "fe80eca00022-bcfa-5e11-bf4f-09e27b07")
        let owner = Owner(typedID: typedUserID, accessToken: "C0k0xTdkmO7xGu4faqTKVtHLKuEx3KKBFaMHV41EC10")
        
        let app = App(appID: "7acef728", appKey: "79446442d468a012151a6a57c3d72ff6", site: Site.US)
        let api = ThingIFAPIBuilder(app: app, owner: owner).build()
        
        let vendorThingID = "thing1"
        let thingPassword = "thing1"
        api.onboard(vendorThingID, thingPassword: thingPassword, thingType: nil, thingProperties: nil, completionHandler: { (target: Target?, error: ThingIFError?) -> Void in
            if error == nil {
                api.saveInstance()
                self.getStates()
            } else {
                print(error)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

