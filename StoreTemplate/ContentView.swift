//
//  ContentView.swift
//  StoreTemplate
//
//  Created by Nicola Kaleta on 21/01/2024.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @AppStorage("subscribed") private var subcribed : Bool = false
    @State var lifetimePage: Bool = false
    
    var body: some View {
        SubscriptionStoreView(groupID: "148C004B", visibleRelationships: .all) {
            StoreContent()
                .containerBackground(Color.cyan.gradient, for: .subscriptionStoreHeader)
        }
        .backgroundStyle(.clear)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .storeButton(.visible, for: .restorePurchases)
        .sheet(isPresented: $lifetimePage) {
            
        }
        Button("More Purchase Options", action: {
            lifetimePage = true
        })
    }
}

#Preview {
    ContentView()
}
