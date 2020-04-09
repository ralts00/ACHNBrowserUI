//
//  ItemRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    @EnvironmentObject private var collection: Collection
    
    let item: Item
    
    @State var displayedVariant: String?
    
    func bellsView(title: String, price: Int) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.text)
            Text("\(price)")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.bell)
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if self.collection.items.contains(self.item) {
                    self.collection.items.removeAll(where: { $0 == self.item })
                } else {
                    self.collection.items.append(self.item)
                }
            }) {
                Image(systemName: self.collection.items.contains(self.item) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: displayedVariant ?? item.image))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.text)
                Text(item.obtainedFrom ?? "unknown source")
                    .font(.subheadline)
                    .foregroundColor(.text)
                HStack(spacing: 4) {
                    if item.buy != nil {
                        bellsView(title: "Buy for:", price: item.buy!)
                    }
                    if item.sell != nil {
                        bellsView(title: "Sell for:", price: item.sell!)
                    }
                }
                if item.variants != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            ForEach(item.variants!, id: \.self) { variant in
                                ItemVariantImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: variant))
                                    .cornerRadius(4)
                                    .background(Rectangle()
                                        .cornerRadius(4)
                                        .foregroundColor(self.displayedVariant == variant ? Color.gray : Color.clear))
                                    .onTapGesture {
                                        self.displayedVariant = variant
                                }
                            }
                        }.frame(height: 30)
                    }
                }
            }
        }
    }
}
