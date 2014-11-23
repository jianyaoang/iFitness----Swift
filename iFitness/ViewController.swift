//
//  ViewController.swift
//  iFitness
//
//  Created by Jian Yao Ang on 11/23/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var steps = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askingForPermission()
    }

    func askingForPermission(){
        
        // this step ensure the device has the Health app. iPad doesn't have it
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable(){
                println("booyeah! we have HKHealthStore")
                return HKHealthStore()
            }
            else{
                println("No HKHealthStore available")
                return nil
            }
        }()
        
        //HKQuantityType - basically a standardized method represent an amount of a specific unit
        //the sample code below can be used to get any of the HKQuantiyType
        let stepCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        //we can read and write the data that is made available to us by the users
        //however choose wisely what data we want from the user, requesting too many might be intimidating
        let dataToWrite = NSSet(object: stepCount)
        let dataToRead = NSSet(object: stepCount)
        
        healthStore?.requestAuthorizationToShareTypes(dataToWrite, readTypes: dataToRead, completion: { (success, error) -> Void in
            
            if success {
                println("Successfully request authorization from user")
                self.readDataFromHealthStore(healthStore!)
            }
            else{
                println("Unsuccessful. \(error.description)")
            }
        })
        
    }
    
    func readDataFromHealthStore(theHealthStore: HKHealthStore){
        
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        //to read the data, you can just use a query
        let queryStepsCount = HKSampleQuery(sampleType: stepsCount, predicate: nil, limit: 50, sortDescriptors: nil) { (query, results, error) -> Void in
            
            if let results = results as? [HKQuantitySample]{
                
                self.steps = results
                println("The steps data: \(self.steps)")
            }
        }
        //REMEMBER TO EXECUTE!!
        theHealthStore.executeQuery(queryStepsCount)
    }
    
    
}

