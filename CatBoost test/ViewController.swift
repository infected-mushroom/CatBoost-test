//
//  ViewController.swift
//  CatBoost test
//
//  Created by ks on 14/04/2019.
//  Copyright © 2019 ks. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var data: UITextField!
    
    @IBOutlet weak var x_label: UILabel!
    
    @IBOutlet weak var y_label: UILabel!
    
    @IBOutlet weak var z_label: UILabel!
    
    @IBOutlet weak var walking: UILabel!
    
    @IBOutlet weak var x_acc: UILabel!
    
    @IBOutlet weak var y_acc: UILabel!
    
    @IBOutlet weak var z_acc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    
    let gyroMotion = CMMotionManager()
    var activityManager = CMMotionActivityManager()
    let motionQueue = OperationQueue()
    var timer = Timer()
    
    var logs : String = ""

    @IBAction func add(_ sender: UIButton) {
        startGyros()
    }
    
    @IBAction func end_motion(_ sender: UIButton) {
        stopGyros()
        self.activityManager.stopActivityUpdates()
    }
    
    let motionHandler:CMMotionActivityHandler! = { (activity:CMMotionActivity?) -> Void in
        //let desc = activity?.debugDescription ?? "no activity"
        //z_label.text = "1"
    }
    
    func startGyros() {
        if self.gyroMotion.isGyroAvailable && CMMotionActivityManager.isActivityAvailable(){
            self.gyroMotion.gyroUpdateInterval = 1.0 / 6
            self.gyroMotion.accelerometerUpdateInterval = 1.0 / 6
            self.gyroMotion.startGyroUpdates()
            self.gyroMotion.startAccelerometerUpdates()
            
            self.activityManager.startActivityUpdates(to:OperationQueue.main, withHandler:{ (activity:CMMotionActivity?) -> Void in
                self.walking.text = "Walking: " + String(activity!.walking)
                self.logs += String(activity!.walking) + " "
            })
            
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0 / 6),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.gyroMotion.gyroData {
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z

                                    self.x_label.text = "rotation along X: " + String(format: "%.3f", x)
                                    self.y_label.text = "rotation along Y: " + String(format: "%.3f", y)
                                    self.z_label.text = "rotation along Z: " + String(format: "%.3f", z)
                                    
                                    self.logs += String(format: "%.3f ", x)
                                    self.logs += String(format: "%.3f ", y)
                                    self.logs += String(format: "%.3f ", z)
                        }
                                
                                if let data1 = self.gyroMotion.accelerometerData {
                                    let x = data1.acceleration.x
                                    let y = data1.acceleration.y
                                    let z = data1.acceleration.z
                                    self.x_acc.text = "acceleration along X: " + String(format: "%.3f", x)
                                    self.y_acc.text = "acceleration along Y: " + String(format: "%.3f", y)
                                    self.z_acc.text = "acceleration along Z: " + String(format: "%.3f", z)
                                    
                                    self.logs += String(format: "%.3f ", x)
                                    self.logs += String(format: "%.3f ", y)
                                    self.logs += String(format: "%.3f\n", z)
                                }
            }
            )
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func stopGyros() {
        self.gyroMotion.stopGyroUpdates()
        self.gyroMotion.stopAccelerometerUpdates()
        writeLog(text: self.logs)
    }
    
    func writeLog(text: String) {
        do {
            // get the documents folder url
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // create the destination url for the text file to be saved
                let fileURL = documentDirectory.appendingPathComponent("file.txt")
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
        } catch {
            print("error:", error)
        }
    }
}

