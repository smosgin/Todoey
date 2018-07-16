//
//  RealmService.swift
//  Todoey
//
//  Created by Seth Mosgin on 7/14/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    // Make init private so you can't create instances of this class
    private init() {}
    
    // Singleton for accessing the RealmService
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    // The generic T here means we can take any object that subclasses the Type Object (from Realm)
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            
        }
    }
    
    //MARK: - Error handling
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
