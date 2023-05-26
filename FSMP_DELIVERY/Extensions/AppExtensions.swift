//
//  AppExtensions.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//
import SwiftUI

var ALERT_TITLE = ""
var ALERT_MESSAGE = ""

var documentDirectory:URL? { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first }

func getQrImage() -> Image?{
    guard let data = generateQrCode(qrCodeStr:UUID().uuidString),
          let uiImage = UIImage(data: data) else { return nil}
    
    return Image(uiImage:uiImage)
}

func generateQrCode(qrCodeStr:String) -> Data?{
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    let data = qrCodeStr.data(using: .ascii, allowLossyConversion: false)
    filter.setValue(data, forKey: "inputMessage")
    guard let ciimage = filter.outputImage else { return nil }
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledCIImage = ciimage.transformed(by: transform)
    let uiimage = UIImage(ciImage: scaledCIImage)
    return uiimage.pngData()
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

extension String{
    
    func capitalizingFirstLetter() -> String {
          return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirst() {
        if self.isEmpty { return }
        self = self.capitalizingFirstLetter()
    }
}

extension UIImage {
    
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func compressImage(_ quality:CGFloat) -> Data?{
        return self.jpegData(compressionQuality: quality)
    }
}

extension Date{
    
    static func fromISO8601StringToDate(_ dateToProcess:String) -> Date?{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: dateToProcess)
    }
    
    func toISO8601String() -> String{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        return formatter.string(from: self)
    }
}

extension [[CGPoint]]{
    
    func getBoundaries() -> CGPoint{
        var m = CGPoint(x:100.0,y:100.0)
        for pointsList in self{
            let sortedWidth = pointsList.sorted(by: {$0.x < $1.x })
            let sortedHeight = pointsList.sorted(by: {$0.y < $1.y })
            
            if sortedWidth.last?.x ?? 0.0 > m.x { m.x = sortedWidth.last?.x ?? 0.0}
            if sortedHeight.last?.y ?? 0.0 > m.y { m.y = sortedHeight.last?.y ?? 0.0}
            
        }
        
        return m
    }
}

extension View {
    
    @MainActor
    func exportAsPdf(documentDirectory:URL,filePath:String)->URL?{
        let renderedUrl = documentDirectory.appending(path: filePath)
     
        guard let consumer = CGDataConsumer(url: renderedUrl as CFURL),
              let pdfContext = CGContext(consumer: consumer, mediaBox: nil, nil) else { return nil }
        
        let renderer = ImageRenderer(content: self)
        renderer.render { size, renderer in
            let options: [CFString: Any] = [
                kCGPDFContextMediaBox: CGRect(origin: .zero, size: size)
            ]
 
            pdfContext.beginPDFPage(options as CFDictionary)
 
            renderer(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        return renderedUrl
    }
    
    func snapshot() -> UIImage {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
      background(
        GeometryReader { geometryProxy in
          Color.clear
            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        }
      )
      .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func hLeading() -> some View{
        self.frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func hTrailing() -> some View{
        self.frame(maxWidth: .infinity,alignment: .trailing)
    }
    
    func hCenter() -> some View{
        self.frame(maxWidth: .infinity,alignment: .center)
    }
    
    func vTop() -> some View{
        self.frame(maxHeight: .infinity,alignment: .top)
    }
    
    func vBottom() -> some View{
        self.frame(maxHeight: .infinity,alignment: .bottom)
    }
    
    func vCenter() -> some View{
        self.frame(maxHeight: .infinity,alignment: .center)
    }
    
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
    
    func onConditionalAlert(actionPrimary:@escaping (()-> Void),
                        actionSecondary:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(ALERT_TITLE),
                message: Text(ALERT_MESSAGE),
                primaryButton: .destructive(Text("OK"), action: { actionPrimary() }),
                secondaryButton: .cancel(Text("AVBRYT"), action: { actionSecondary() } )
        )
    }
    
    func onResultAlert(action:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(ALERT_TITLE),
                message: Text(ALERT_MESSAGE),
                dismissButton: .cancel(Text("OK"), action: { action() } )
        )
    }
    
    func toast(message: String,
               isShowing: Binding<Bool>,
               config: ToastModifier.Config) -> some View {
        self.modifier(
            ToastModifier(message: message,
                  isShowing: isShowing,
                  config: config))
    }

    func toast(message: String,
             isShowing: Binding<Bool>,
             duration: TimeInterval) -> some View {
        self.modifier(ToastModifier(message: message,
                            isShowing: isShowing,
                            config: .init(duration: duration)))
  }
}
