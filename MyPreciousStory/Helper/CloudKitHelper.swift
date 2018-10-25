//
//  CloudKitHelper.swift
//  CloudKitExample1
//
//  Created by Jazilul Athoya on 17/10/18.
//  Copyright © 2018 Jazilul Athoya. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

typealias onFetchStoryCompleted = (_ records : [CKRecord]) -> Void
typealias onFetchStoryCompletedWithStory = (_ records : [Story]) -> Void
typealias onFetchProgessing = (_ progressPercent: Float) -> Void

class CloudKitHelper {
    
    /**
     * We can create schema for CloudKit by saving the record, The record need CKRecord.ID and record object
     * - Parameters:
     **/
    func createNewRecordByStory(story: Story){
        // Create Record Object
        let storyRecord = CKRecord(recordType: "Story")
        
        // Create dictionary represent the attribute and value
        storyRecord["title"] = story.title
        storyRecord["coordinate"] = CLLocation(latitude: story.coordinate.latitude, longitude: story.coordinate.longitude)
        
        // deliver later when we reach CKAssets
        do {
            let imageUrl = try story.thumbnail.saveToTempLocation()
            if let url = imageUrl {
                let thumbnailAssest = CKAsset(fileURL: url)
                storyRecord["thumbnail"] = thumbnailAssest
            }
        } catch {
            
        }
        
        saveRecord(record: storyRecord)
    }
    
    /**
     * Function to save record to private CloudKit private database
     * - Parameters:
     *      - record: CKRecord
     **/
    func saveRecord(record: CKRecord){
        // use default container, we can set custom container by setting
        let container = CKContainer.default()
        let privateContainer = container.publicCloudDatabase
        
        privateContainer.save(record) { (resultRecord, error) in
            if let err = error {
                // Insert error handling
                print("Failed to save record", err.localizedDescription)
                return
            }
            
            // Insert successfully saved record code
            print("Record saved")
            print(record)
        }
    }
    
    func fetchAllStory(onComplete: @escaping onFetchStoryCompletedWithStory){
        let container = CKContainer.default()
        let privateContainer = container.publicCloudDatabase
        
        // fetch all record
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Story", predicate: predicate)
        
        // sort description
//        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
//        query.sortDescriptors = [sort]
        
        privateContainer.perform(query, inZoneWith: nil) { (result, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if let res = result {
                var stories: [Story] = []
                res.forEach({ (record) in
                    if let story = self.decodeCKRecordToStory(record: record) {
                        stories.append(story)
                    }
                })
                onComplete(stories)
            }
        }
    }
    
    func decodeCKRecordToStory(record: CKRecord) -> Story? {
        let title = record["title"] as? String
        let coordinate = record["coordinate"] as? CLLocation
        let thumbnail = record["thumbnail"] as? CKAsset
        
        if let asset = thumbnail {
            let data = NSData(contentsOf: asset.fileURL)
            let image = UIImage(data: data! as Data)
            
            let newStory = Story(title: title!, coordinate: (coordinate?.coordinate)!, thumbnail: image!)
            return newStory
        }
        
        return nil
    }
    
    func fetchAllStoryWithLoad(onProgress: @escaping onFetchProgessing, onComplete: @escaping onFetchStoryCompleted){
        let container = CKContainer.default()
        let privateContainer = container.publicCloudDatabase
        
        // fetch all record
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Story", predicate: predicate)
        
        // sort description
        //        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        //        query.sortDescriptors = [sort]
        
        var result: [CKRecord] = []
        
        let operation = CKQueryOperation(query: query)
        operation.queryCompletionBlock = { (cursor, error) in
            print("completed")
            print(cursor)
            print(error)
            onComplete(result)
        }
        
        operation.resultsLimit = 10
        
        operation.recordFetchedBlock = { (record) in
            print(record)
            result.append(record)
            let percent = Float(result.count) / Float(operation.resultsLimit)
            onProgress(percent)
        }
        
        privateContainer.add(operation)
    }
}
