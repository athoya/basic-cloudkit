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

class CloudKitHelper {
    
    func createNewStory(story: Story) {
        let storyRecord = CKRecord(recordType: "Story")
        
        storyRecord["title"] = story.title
        storyRecord["coordinate"] = CLLocation(latitude: story.coordinate.latitude, longitude: story.coordinate.longitude)
        
        do {
            let url = try story.thumbnail.saveToTemporaryLocation()
            storyRecord["thumbnail"] = CKAsset(fileURL: url)
            saveRecordToPublicDatabase(record: storyRecord)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func saveRecordToPublicDatabase(record: CKRecord) {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        database.save(record) { (newRecord, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            if let r = newRecord {
                print(r)
            }
        }
    }
    
    func fetchStoryRecord() -> [Story] {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
//        let predicate = NSPredicate(format: "title = %@", "Morning")
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Story", predicate: predicate)
        
        var result: [Story] = []
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            if let fetchedRecords = records {
                print(fetchedRecords)
                fetchedRecords.forEach({ (record) in
                    let story = self.decoreCKRecordToStory(record: record)
                    print(story)
                })
            }
        }
        
        return result
    }
    
    func decoreCKRecordToStory(record: CKRecord) -> Story? {
        let title = record["title"] as? String
        let coordinateCLoudKit = record["coordinate"] as? CLLocation
        let thumbnail = record["thumbnail"] as? CKAsset
        
        let coordinateMake = CLLocationCoordinate2DMake((coordinateCLoudKit?.coordinate.latitude)!, (coordinateCLoudKit?.coordinate.longitude)!)
        
        do {
            let data = try Data(contentsOf: (thumbnail?.fileURL)!)
            let uiImage = UIImage(data: data)
            
            let story = Story(title: title!, coordinate: coordinateMake, thumbnail: uiImage!)
            return story
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
