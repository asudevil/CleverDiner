//
//  ProfileDetails.swift
//  CleverDiner
//
//  Created by admin on 4/1/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ProfileDetails: NSObject {
    
    var allDetailsDictionary: [String: Any]?
    var clickCountDictionary: [String: Any]?
    
    static let sharedInstance = ProfileDetails()
    
    override init() {
        super.init()
        
    }
    
    func setProfileDetails(profileDictionary: [String: Any]) {
        allDetailsDictionary = profileDictionary
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        updateUserDetailsIntoDataBaseWithUID(uid: uid, values: allDetailsDictionary!)
    }
    func getProfileDetails() -> [String: Any]? {
        return allDetailsDictionary
    }
    
    func appendCount(fieldToAppend: String) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        fetchUserInfofromServer(uid: uid) { (userDictionaryFromServer) in
            self.allDetailsDictionary = userDictionaryFromServer
            if let currentCount = userDictionaryFromServer[fieldToAppend] as? Int {
                let newCount = currentCount + 1
                
                self.allDetailsDictionary?.updateValue(newCount, forKey: fieldToAppend)
            } else {
                self.allDetailsDictionary?.updateValue(1, forKey: fieldToAppend)
            }
            self.updateUserDetailsIntoDataBaseWithUID(uid: uid, values: self.allDetailsDictionary!)
        }
    }
    
    func appendBizClickCount(bizToUpdate: String) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        fetchBizClickCountfromServer(uid: uid) { (clickCountDictionaryFromServer) in
            self.clickCountDictionary = clickCountDictionaryFromServer
            if let clickedBizCount = clickCountDictionaryFromServer[bizToUpdate] as? Int {
                let newCount = clickedBizCount + 1
                self.clickCountDictionary?.updateValue(newCount, forKey: bizToUpdate)
            } else {
                self.clickCountDictionary?.updateValue(1, forKey: bizToUpdate)
            }
            self.updateBusinessClickedCounterForUID(uid: uid, values: self.clickCountDictionary!)
        }
    }

    
    private func updateUserDetailsIntoDataBaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users-details").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
    }
    
    private func updateBusinessClickedCounterForUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users-details").child(uid).child("businessClicked")
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
    }
    
    func fetchUserInfofromServer(uid: String, completion: @escaping ([String: Any]) -> ()){
        FIRDatabase.database().reference().child("users-details").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDetailsDictionary = snapshot.value as? [String: Any] {
                completion(userDetailsDictionary)
            }
        }, withCancel: nil)
    }
    func fetchUserPermissions(fromId: String, toId: String, completion: @escaping ([String: Any]) -> ()){
        let uid = toId + fromId
        FIRDatabase.database().reference().child("contacts-permissions").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDetailsDictionary = snapshot.value as? [String: Any] {
                completion(userDetailsDictionary)
            } else {
                print("Default permissions")
                let userDefaultDetails = ["infoRequested":"No", "grantPermission":"No"]
                completion(userDefaultDetails)
            }
        }, withCancel: nil)
    }
    func fetchBizClickCountfromServer(uid: String, completion: @escaping ([String: Any]) -> ()){
        FIRDatabase.database().reference().child("users-details").child(uid).child("businessClicked").observeSingleEvent(of: .value, with: { (snapshot) in
            print("Fetched Info is: ",snapshot.value)
            if let userDetailsDictionary = snapshot.value as? [String: Any] {
                completion(userDetailsDictionary)
            } else {
                
            }
        }, withCancel: nil)
    }
}
