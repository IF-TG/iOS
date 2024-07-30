////
////  RealmStorage.swift
////  travelPlan
////
////  Created by SeokHyun on 7/18/24.
////
//
//import Foundation
//import RealmSwift
//
//final class RealmStorage {
//  // MARK: - Properties
//  static let shared = RealmStorage()
//  private let realm: Realm
//  
//  // MARK: - LifeCycle
//  private init() {
//    do {
//      self.realm = try Realm()
//    } catch {
//      fatalError("Failed to initialize Realm: \(error.localizedDescription)")
//    }
//  }
//}
//
//// MARK: - Helpers
//extension RealmStorage {
//  @discardableResult
//  func add<T: Object>(_ object: T) -> Bool {
//    do {
//      try realm.write {
//        realm.add(object)
//      }
//      return true
//    } catch {
//      print("DEBUG: Realm에 \(object.description)를 추가하는데 실패했습니다.: \(error.localizedDescription)")
//      return false
//    }
//  }
//  
//  func get<T: Object>(primaryKey: UUID, type: T.Type) -> T? {
//    return realm.object(ofType: type, forPrimaryKey: primaryKey)
//  }
//  
//  func getAll<T: Object>(_ type: T.Type) -> Results<T> {
//    return realm.objects(type)
//  }
//  
////  @discardableResult
////  func update<T: Object>(_ object: T, dictionary: [String: Any?]) -> Bool {
////    do {
////      try realm.write {
////        for (key, value) in dictionary {
////          object.setValue(value, forKey: key)
////        }
////        return true
////      }
////    } catch {
////      print("Realm에 \(object.description)를 업데이트하는데 실패했습니다.: \(error.localizedDescription)")
////      return false
////    }
////  }
//  
//  // KeyPath 사용
//  @discardableResult
//  func update<T: Object, V>(_ object: T, keyPath: ReferenceWritableKeyPath<T, V>, value: V) -> Bool {
//    do {
//      try realm.write {
//        object[keyPath: keyPath] = value
//      }
//      return true
//    } catch {
//      print("DEBUG: Realm에 \(object.description)를 업데이트하는데 실패했습니다.: \(error.localizedDescription)")
//      return false
//    }
//  }
//  
//  @discardableResult
//  func delete<T: Object>(_ object: T) -> Bool {
//    do {
//      try realm.write {
//        realm.delete(object)
//      }
//      return true
//    } catch {
//      print("DEBUG: Realm에 \(object.description)을 삭제하는데 실패했습니다.: \(error.localizedDescription)")
//      return false
//    }
//  }
//}
