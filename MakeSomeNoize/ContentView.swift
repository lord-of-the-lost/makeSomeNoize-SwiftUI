//
//  ContentView.swift
//  MakeSomeNoize
//
//  Created by Николай Игнатов on 20.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var value: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    
    private let defaultHeight: CGFloat = 200
    private let defaultWidth: CGFloat = 80
    
    private var currentVolume: CGFloat {
        let currentValue = value - offset.height / defaultHeight
        if currentValue < 0.0 {
            return currentValue / 30.0
        } else if currentValue > 1.0 {
            return CGFloat(1.0) + (currentValue - 1) / 30.0
        }
        return currentValue
    }
    
    private var сurrentVolume: CGFloat {
        min(1.0, max(0.0, currentVolume))
    }
    
    private var xScale: CGFloat {
        if currentVolume > 1.0  {
            return 1 / CGFloat(sqrt(Double(currentVolume)))
        } else if currentVolume < 0.0 {
            return 1 / CGFloat(sqrt(Double(1 - currentVolume)))
        } else {
            return 1.0
        }
    }
    
    private var yScale: CGFloat {
        1 / xScale
    }
    
    private var yOffset: CGFloat {
        if currentVolume > 1.0 {
            return -defaultHeight * (yScale - 1.0)
        } else if currentVolume < 0.0 {
            return defaultHeight * (yScale - 1.0)
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        VStack {
            Color.black.background(.ultraThinMaterial)
                .opacity(0.5)
                .frame(width: defaultWidth * xScale, height: defaultHeight * yScale)
                .overlay(alignment: .bottom) {
                    Color.white.background(.ultraThinMaterial)
                        .opacity(0.7)
                        .frame(width: defaultWidth * xScale, height: defaultHeight * yScale * сurrentVolume)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scaleEffect(x: xScale, y: yScale)
                .offset(y: yOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            withAnimation {
                                self.value = сurrentVolume
                                offset = .zero
                            }
                        })
        }
    }
}

#Preview {
    ContentView()
}
