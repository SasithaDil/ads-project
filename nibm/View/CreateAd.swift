//
//  CreateAd.swift
//  nibm
//
//  Created by Sasitha Dilshan on 2022-03-24.
//

import SwiftUI

struct CreateAd: View {
    @EnvironmentObject var adData : AdsViewModel
    
    @State var adTitle = ""
    @State var sellerName = ""
    @State var adContent: [adContent] = []
    
    @FocusState var showKeyboard: Bool
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 15){
                    VStack(alignment: .leading){
                        TextField("Ad Title", text: $adTitle)
                            .font(.title2)
                        Divider()
                    }
                    VStack(alignment: .leading, spacing:  11){
                        Text("Seller: ")
                            .font(.caption.bold())
                        TextField("seller", text: $sellerName)
                        
                        Divider()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    
                    ForEach($adContent){$content in
                        VStack{
                            if content.type == .Image {
                                // change it to access camera
                                if content.showImage && content.value != "" {
                                    
                                    WebImage(url: content.value)
                                        .onTapGesture {
                                            withAnimation {
                                                content.showImage = false
                                            }
                                        }
                                    
                                }
                                else{
                                    VStack{
                                        TextField("Image URL", text: $content.value, onCommit: {
                                            
                                            withAnimation {
                                                content.showImage = true
                                            }
                                        })
                                        Divider()
                                    }
                                    .padding(.leading, 5)
                                }
                                
                            }
                            else{
                                
                                TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type))
                                    .focused($showKeyboard)
                                    .frame( height: content.height == 0 ? getFontSize(type: content.type) * 2 : content.height)
                                    .background(
                                        Text(content.type.rawValue)
                                            .font(.system(size: getFontSize(type: content.type)))
                                            .foregroundColor(.gray)
                                            .opacity(content.value == "" ? 0.7 : 0)
                                            .padding(.leading, 5)
                                        
                                        ,alignment: .leading
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        contentShape(Rectangle())
                        .gesture(DragGesture().onEnded({ value in
                            if -value.translation.width < (UIScreen.main.bounds.width / 2.5) && content.showDeleteAlert{
                                content.showDeleteAlert = true
                            }
                        }))
                        .alert("Are you sure to delete this advertiesment?",isPresented: $content.showDeleteAlert){

                            Button("Delete",role: .destructive){
                                let index = adContent.firstIndex { currentAd in
                                    return currentAd.id == content.id
                                } ?? 0

                                withAnimation{
                                    adContent.remove(at: index)
                                }
                            }
                        }
                    }
                    
                    Menu{
                        
                        ForEach(AdType.allCases, id: \.rawValue){ type in
                            
                            Button(type.rawValue){
                                withAnimation{
                                    adContent.append(nibm.adContent(value: "", type: type))
                                    
                                }
                            }
                            
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.primary)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
                
            })
                .navigationTitle(adTitle == "" ? "Ad Title" : adTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(){
                    ToolbarItem(placement: .navigationBarLeading){
                        if !showKeyboard{
                            Button("Cancel") {
                                adData.createAd.toggle()
                            }
                        }
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        if showKeyboard {
                            Button("Done ") {
                                showKeyboard.toggle()
                            }
                        }
                        else{
                            Button("Share") {
                                adData.writeAd(content: adContent,sellerName: sellerName, adTitle: adTitle)
                            }
                            .disabled(sellerName == "" || adTitle == "")
                        }
                        
                    }
                    
                }
        }
    }
}

struct CreateAd_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getFontSize(type: AdType) -> CGFloat{
    
    switch type {
    case .Header:
        return 24
    case .SubHeader:
        return 22
    case .Description:
        return 18
    case .Image:
        return 18
    }
}

struct WebImage: View {
    
    var url: String
    
    var body: some View{
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image{
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                    .cornerRadius(15)
            }
            else{
                if let _ = phase.error{
                    Text("Failed to load image..")
                }
                else{
                    ProgressView()
                }
            }
        }
        .frame(height: 250)
    }
    
}
