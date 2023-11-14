//
//  SegmentedView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 14.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import SwiftUI

struct SegmentView: View {
    var values:[String]
    var didSelect:(_ at:Int)->()
    @State var selectedAt:Int
    private let height:CGFloat = 40
    
    var body: some View {
        GeometryReader(content: { geometry in
            Color.gray
                .cornerRadius(geometry.size.height >= 60 ? 60 : (geometry.size.height / 2))
            selectionView(geometry.size)
            HStack {
                ForEach(0..<values.count, id: \.self) {i in
                    Text(values[i])
                        .frame(width: geometry.size.width / CGFloat(values.count), height: height
                        )
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                selectedAt = i
                            }
                            didSelect(i)
                            print("selected at: ", i)
                        }
                        .foregroundColor(i == selectedAt ? Color.black : Color.white)
                        
                }
            }

            
        })
    }
    
  
    func selectionView(_ size:CGSize) -> some View {
        return Rectangle()
            .fill(Color.yellow)
            .cornerRadius(size.height >= 60 ? 60 : (size.height / 2))
            .frame(width: size.width / CGFloat(values.count),
                   height: height)
            .position(.init(x: CGFloat(selectedAt) * size.width / CGFloat(values.count) + (size.width / CGFloat(values.count) / 2), y: 20))
    }

}

#Preview {
    SegmentView(values: ["one", "two"], didSelect: {_ in
    }, selectedAt: 0)
}
