//
//  LoadingView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-28.
//
import SwiftUI


struct LoadingView: View {
    let loadingtext:String
    @State var isLoading = false
    var body: some View {
        ZStack{
            ProgressView("Loading")
                .progressViewStyle(.horizontal)
        }
        .frame(width:200,height:50)
        .padding()
        .background(.white)
        .cornerRadius(10) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 2)
        )
    }
}

struct HorizontalProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(.circular)
            configuration.label
        }.foregroundColor(.secondary)
    }
}

extension ProgressViewStyle where Self == HorizontalProgressViewStyle {
    static var horizontal: HorizontalProgressViewStyle { .init() }
}



