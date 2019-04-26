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
    
    @IBOutlet weak var cb_walking: UILabel!
    
    var rot_x = [0.0]
    var rot_y = [0.0]
    var rot_z = [0.0]
    var acc_x = [0.0]
    var acc_y = [0.0]
    var acc_z = [0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    
    let model = WalkingModel().model
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
                self.walking.text = "Walking (Apple API): " + String(activity!.walking)
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
                                    
                                    self.rot_x.append(x)
                                    self.rot_y.append(y)
                                    self.rot_z.append(z)

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
                                    
                                    self.acc_x.append(x)
                                    self.acc_y.append(y)
                                    self.acc_z.append(z)
                                    
                                    self.x_acc.text = "acceleration along X: " + String(format: "%.3f", x)
                                    self.y_acc.text = "acceleration along Y: " + String(format: "%.3f", y)
                                    self.z_acc.text = "acceleration along Z: " + String(format: "%.3f", z)
                                    
                                    self.logs += String(format: "%.3f ", x)
                                    self.logs += String(format: "%.3f ", y)
                                    self.logs += String(format: "%.3f\n", z)
                                }
                                
                                let avg_rot_x = self.rot_x.suffix(10).reduce(0, +) / 10.0
                                let avg_rot_y = self.rot_y.suffix(10).reduce(0, +) / 10.0
                                let avg_rot_z = self.rot_z.suffix(10).reduce(0, +) / 10.0
                                let avg_acc_x = self.acc_x.suffix(10).reduce(0, +) / 10.0
                                let avg_acc_y = self.acc_y.suffix(10).reduce(0, +) / 10.0
                                let avg_acc_z = self.acc_z.suffix(10).reduce(0, +) / 10.0

                                let min_rot_x = self.rot_x.suffix(10).reduce(0, min)
                                let min_rot_y = self.rot_y.suffix(10).reduce(0, min)
                                let min_rot_z = self.rot_z.suffix(10).reduce(0, min)
                                let min_acc_x = self.acc_x.suffix(10).reduce(0, min)
                                let min_acc_y = self.acc_y.suffix(10).reduce(0, min)
                                let min_acc_z = self.acc_z.suffix(10).reduce(0, min)

                                let max_rot_x = self.rot_x.suffix(10).reduce(0, max)
                                let max_rot_y = self.rot_y.suffix(10).reduce(0, max)
                                let max_rot_z = self.rot_z.suffix(10).reduce(0, max)
                                let max_acc_x = self.acc_x.suffix(10).reduce(0, max)
                                let max_acc_y = self.acc_y.suffix(10).reduce(0, max)
                                let max_acc_z = self.acc_z.suffix(10).reduce(0, max)
                                
//                                guard let pred = try? self.model.prediction(from: WalkingModelInput(avg_rot_x: avg_rot_x, avg_rot_y: avg_rot_y, avg_rot_z: avg_rot_z, min_rot_x: min_rot_x, min_rot_y: min_rot_y, min_rot_z: min_rot_z, max_rot_x: max_rot_x, max_rot_y: max_rot_y, max_rot_z: max_rot_z, avg_acc_x: avg_acc_x, avg_acc_y: avg_acc_y, avg_acc_z: avg_acc_z, min_acc_x: min_acc_x, min_acc_y: min_acc_y, min_acc_z: min_acc_z, max_acc_x: max_acc_x, max_acc_y: max_acc_y, max_acc_z: max_acc_z))  else { fatalError("Error in prediction") }
                                
                                guard let pred = try? self.model.prediction(from: WalkingModelInput(feature_0: avg_rot_x, feature_1: avg_rot_y, feature_2: avg_rot_z, feature_3: min_rot_x, feature_4: min_rot_y, feature_5: min_rot_z, feature_6: max_rot_x, feature_7: max_rot_y, feature_8: max_rot_z, feature_9: avg_acc_x, feature_10: avg_acc_y, feature_11: avg_acc_z, feature_12: min_acc_x, feature_13: min_acc_y, feature_14: min_acc_z, feature_15: max_acc_x, feature_16: max_acc_y, feature_17: max_acc_z))  else { fatalError("Error in prediction") }

                                
                                if let res = pred.featureValue(for: "prediction")?.multiArrayValue {
                                    self.cb_walking.text = "Walking (Catboost): " + String(Double(res[0]) > 0.5)
                        
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
