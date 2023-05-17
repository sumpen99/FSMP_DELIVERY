//
//  AppExtensions.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//
import SwiftUI

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

extension Date{
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
