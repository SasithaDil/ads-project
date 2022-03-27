//
//  AdsViewModel.swift
//  nibm
//
//  Created by Sasitha Dilshan on 2022-03-23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class AdsViewModel: ObservableObject{
    @Published var ads: [AdPost]?
    
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    @Published var createAd = false
    @Published var isWriting = false
    
    func fetchAdPosts() async {
        do{
            let db = Firestore.firestore().collection("Ads")
            
            let ads = try await db.getDocuments()
            
            
            self.ads = ads.documents.compactMap({ ad in
                return try? ad.data(as: AdPost.self)
            })
            
        }
        catch{
            
            self.alertMessage = error.localizedDescription
            showAlert.toggle()
        }
    }
    func deleteAd (adPost: AdPost){
        
        guard let _ = ads else{return}
        
        let index = ads?.firstIndex(where: {currentAd in
            return currentAd.id == adPost.id
        }) ?? 0
        
        withAnimation{ads?.remove(at: index)}
    }
    func writeAd(content: [adContent], sellerName: String, adTitle: String){
        do{
            
            withAnimation {
                isWriting = true
            }
            
            let ad = AdPost(title: adTitle, seller: sellerName, adContent: content, date: Timestamp(date: Date()))
            
            let _ = try Firestore.firestore().collection("Ads").document().setData(from: ad)
            
            withAnimation {
                
                ads?.append(ad)
                isWriting = true
                createAd = false
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
}

