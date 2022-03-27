//
//  Home.swift
//  nibm
//
//  Created by Sasitha Dilshan on 2022-03-23.
//

import SwiftUI

struct Home: View {
    @StateObject var adData = AdsViewModel()
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack{
            if let ads = adData.ads{
                
                if ads.isEmpty{
                    (
                        Text(Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                        +
                        Text("Post an advertiestment")
                    )
                }
                else{
                    List(ads){ adPost in
                        
                        CardView(adPost: adPost)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true){
                                Button(role: .destructive){
                                    adData.deleteAd(adPost: adPost)
                                } label:{
                                    Image("trash")
                                }
                            }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            else{
                ProgressView()
            }
        }
        .navigationTitle("Available Deeds")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: {
                adData.createAd.toggle()
            }, label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(scheme == .dark ? Color.black :  Color.white)
                    .padding()
                    .background(.primary,in: Circle())
            })
                .padding()
                .foregroundStyle(.primary)
            ,alignment: .bottomTrailing
        )
        .task{
            await adData.fetchAdPosts()
        }
        .fullScreenCover(isPresented: $adData.createAd, content: {
            CreateAd()
                .environmentObject(adData)
        })
        .alert(adData.alertMessage, isPresented: $adData.showAlert){
        }
    }
    @ViewBuilder
    func CardView(adPost: AdPost) -> some View{
        VStack(alignment: .leading, spacing: 12){
            Text(adPost.title)
                .fontWeight(.bold)
            
            Text("Seller \(adPost.seller)")
                .font(.callout)
                .foregroundColor(.gray)
            
            Text("Seller \(adPost.date.dateValue().formatted(date: .numeric, time: .shortened))")
                .font(.caption.bold())
                .foregroundColor(.gray)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
