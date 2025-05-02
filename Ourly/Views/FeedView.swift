//
//  FeedView.swift
//  Ourly
//
//  Created by Sean Rhee on 4/11/25.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct FeedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    
                    // MARK: – Newly picked images
                    ForEach(selectedImages, id: \.self) { img in
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)      // fixed height
                                .clipped()
                                .cornerRadius(8)
                            
                            // overlay timestamp
                            Text(Date(), style: .time)
                                .font(.caption2)
                                .padding(6)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .padding([.trailing, .bottom], 12)
                        }
                    }
                    
                    // MARK: – “No posts yet” only if truly empty
                    if selectedImages.isEmpty && viewModel.posts.isEmpty {
                        Text("No posts yet")
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    }
                    
                    // MARK: – Fetched posts from Firestore
                    ForEach(viewModel.posts) { post in
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: post.imageUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    ProgressView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(8)
                            
                            // overlay Firestore timestamp
                            Text(post.timestamp, format: .dateTime.hour().minute())
                                .font(.caption2)
                                .padding(6)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .padding([.trailing, .bottom], 12)
                        }
                    }
                    
                    Divider()
                    
                    // MARK: – Photo picker button
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 0,
                        matching: .images
                    ) {
                        Label("Select Photos", systemImage: "photo.on.rectangle.angled")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    .onChange(of: selectedItems) { newItems in
                        for item in newItems {
                            Task {
                                do {
                                    if let data = try await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImages.append(uiImage)
                                        viewModel.uploadPost(image: uiImage)
                                    }
                                } catch {
                                    print("Image load error:", error)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal) // uniform side inset
            }
            // NAV BAR + LIFECYCLE
            .navigationTitle("OURLY")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.large) 
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 45)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { authViewModel.signOut() } label: {
                        Image(systemName: "arrow.backward.circle")
                            .imageScale(.large)
                            .accessibilityLabel("Sign out")
                    }
                }
            }
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .environmentObject(AuthViewModel())
    }
}
