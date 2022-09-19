//
//  RecordsCollection.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/09/19.
//

//import CodableFirebase
//import Entity
import FirebaseFirestore
//import RxSwift

// FIXME
public protocol RecordsCollection {
    func create(userId: String, selectedEmotionRawValue: Int, text: String) async throws -> Void
}

final class RecordsCollectionImpl: RecordsCollection {
    func create(userId: String, selectedEmotionRawValue: Int, text: String) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            
            
            let db = Firestore.firestore()
            // Add a new document with a generated id.
            var ref: DocumentReference? = nil
            ref = db.collection("records").addDocument(data: [
                "emoji": selectedEmotionRawValue,
                "onething": text,
                "dateCreated": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(with: .success(()))
                }
            }
        }
    }
}
