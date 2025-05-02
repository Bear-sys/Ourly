//
//  FeedViewModel.swift
//  Ourly
//
//  Created by Sean Rhee on 4/11/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct Post: Identifiable {
    let id: String
    let imageUrl: String
    let timestamp: Date
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let imageUrl = data["imageUrl"] as? String,
            let ts = data["timestamp"] as? Timestamp
        else { return nil }
        
        self.id = document.documentID
        self.imageUrl = imageUrl
        self.timestamp = ts.dateValue()
    }
}

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var uploadError: String?
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching posts:", error.localizedDescription)
                    return
                }
                guard let docs = snapshot?.documents else { return }
                let newPosts = docs.compactMap(Post.init)
                DispatchQueue.main.async {
                    self.posts = newPosts
                }
            }
    }
    
    func uploadPost(image: UIImage) {
        isLoading = true
        uploadError = nil
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            uploadError = "Failed to compress image"
            isLoading = false
            return
        }
        
        let postId = UUID().uuidString
        let imageRef = storage.reference().child("posts/\(postId).jpg")
        
        imageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.uploadError = "Upload failed: \(error.localizedDescription)"
                self.isLoading = false
                return
            }
            imageRef.downloadURL { url, error in
                guard let url = url else {
                    self.uploadError = "Failed to get URL: \(error?.localizedDescription ?? "")"
                    self.isLoading = false
                    return
                }
                let postData: [String: Any] = [
                    "imageUrl": url.absoluteString,
                    "timestamp": Timestamp(date: Date())
                ]
                self.db.collection("posts")
                    .document(postId)
                    .setData(postData) { error in
                        self.isLoading = false
                        if let error = error {
                            self.uploadError = "Failed to save post: \(error.localizedDescription)"
                        } else {
                            Task { @MainActor in
                                self.fetchPosts()
                            }
                        }
                    }
            }
        }
    }
}

