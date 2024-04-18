//
//  FirestoreReference.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import FirebaseFirestore

public protocol FirestoreReference { }
extension DocumentReference: FirestoreReference { }
extension CollectionReference: FirestoreReference { }
