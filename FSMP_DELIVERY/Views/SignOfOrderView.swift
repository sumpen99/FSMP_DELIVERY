//
//  SignOfOrderView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//

import SwiftUI


struct SignOfOrderView: View{
    let OFFSET = 10.0
    @State var pointsList:[[CGPoint]] = []
    @State var isDragging = false
    @State var addNewPoint = true
    @State private var renderedImage:Image?
    @Environment(\.displayScale) var displayScale
    var body: some View{
        NavigationStack {
            VStack(spacing:10){
                VStack{
                    Text(Date().toISO8601String())
                    .hCenter()
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    renderedImage
                    Spacer()
                }
                .padding()
                .hCenter()
                Spacer()
                selfSignedCanvas
            }
        }
        .toolbar {
            ToolbarItemGroup{
                Button(action: clearAllDrawnLines) {
                    Image(systemName: "qrcode.viewfinder")
                }
                Button(action: saveSelfSignedName) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
        }
    }
    
    var selfSignedCanvas: some View {
        return GeometryReader{ reader in
            ZStack(alignment:.center){
                Rectangle()
                .foregroundColor(.white)
                .gesture(DragGesture(minimumDistance: 0.0)
                        .onChanged( { value in
                            if insideViewFrame(reader.frame(in: .local),newLocation:value.location){
                                self.addNewPoint(value.location)
                            }
                        })
                        .onEnded({ value in
                            addNewPoint = true
                        }))
                .onShake{
                    clearAllDrawnLines()
                }
                currentSignaturePath
                Text(pointsList.isEmpty ? "Signature" : "")
                    .foregroundColor(.gray)
            }
        }
        .hLeading()
        .frame(height:80.0)
        .cornerRadius(25.0)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray,lineWidth: 2)
        )
        .onChange(of: addNewPoint, perform: { _ in
            saveSelfSignedName()
            
        })
        .padding([.leading,.trailing],10)
               
    }
    
    var currentSignaturePath:some View{
        return Path { path in
            for i in 0..<pointsList.count {
                let pointsToDraw = pointsList[i]
                path.addPath(DrawShape(points:pointsToDraw).path())
            }
        }
        .stroke(lineWidth:5)
        .foregroundColor(.blue)
    }
    
    private func saveSelfSignedName(){
        if pointsList.isEmpty { return }
        let boundaries = pointsList.getBoundaries()
        let uiImage =   /*ZStack() {
                            currentSignaturePath
                            Text(Date().toISO8601String())
                            .hCenter()
                            .vBottom()
                            .padding(.bottom)
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        }
                        .hLeading()*/
                        currentSignaturePath
                        .frame(width:boundaries.x,height:boundaries.y)
                        .padding([.trailing,.bottom])
                        .snapshot()
        renderedImage = Image(uiImage: uiImage)
    }
    
    private func clearAllDrawnLines(){
        addNewPoint = true
        pointsList.removeAll()
        renderedImage = nil
    }
    
    private func addNewPoint(_ value:CGPoint){
        if addNewPoint{
            pointsList.append([])
            addNewPoint = false
        }
        let currentLine = max(0,pointsList.count - 1)
        pointsList[currentLine].append(value)
    }
       
    
    private func insideViewFrame(_ frame:CGRect,newLocation:CGPoint) ->Bool{
        return newLocation.x >= frame.minX+OFFSET && newLocation.x <= frame.minX + frame.width - OFFSET &&
               newLocation.y >= frame.minY+OFFSET && newLocation.y <= frame.minY + frame.height - OFFSET
    }
    
}

struct DrawShape{
    var points:[CGPoint]
    
    func path() -> Path{
        var path = Path()
        guard let firstPoint = points.first else { return path}
        
        path.move(to: firstPoint)
        for pointIndex in 1..<points.count{
            path.addLine(to: points[pointIndex])
        }
        
        return path
    }
}




struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



