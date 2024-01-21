//
//  StoreContent.swift
//  StoreTemplate
//
//  Created by Nicola Kaleta on 21/01/2024.
//

import SwiftUI

struct StoreContent: View {
    @AppStorage("subscribed") private var subscribed : Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text(subscribed ? "Thanks!" : "Choose a plan")
                    .font(.largeTitle.bold())
                Text(subscribed ? "You are subscribed" : "A purchase is required to use this app")
                Image(.store)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect)
                    .frame(width: 100)
                    .padding()
            }
        }
    }
}

#Preview {
    StoreContent()
}
