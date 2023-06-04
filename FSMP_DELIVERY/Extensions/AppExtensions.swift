//
//  AppExtensions.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-17.
//
import SwiftUI

var ALERT_TITLE = ""
var ALERT_MESSAGE = ""
let FSMP_RELEASE_YEAR = 2023
var documentDirectory:URL? { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first }

var ordersFolder:URL? {
    guard let documentDirectory = documentDirectory else { return nil}
    
    let ordersFolder = documentDirectory.appendingPathComponent("orders")
    if !FileManager.default.fileExists(atPath: ordersFolder.absoluteString) {
        do{
            try FileManager.default.createDirectory(at: ordersFolder,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch{
            print(error)
            return nil
        }
        return ordersFolder
    }
    
    /*let subFolderInsideOrders = documentDirectory.appendingPathComponent("orders/\(String("newFolder"))")
        
    if !FileManager.default.fileExists(atPath: subFolderInsideOrders.absoluteString) {
     do{
         try FileManager.default.createDirectory(at: subFolderInsideOrders,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
     }
     catch{
         print(error)
         return nil
     }
     return ordersFolder
    }*/
    
    return nil
}

struct FillFormModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

func removeAllOrdersFromFolder(){
    let fileManager = FileManager.default
    guard let ordersFolder = ordersFolder,
          let filePaths = try? fileManager.contentsOfDirectory(at: ordersFolder, includingPropertiesForKeys: nil, options: [])  else { return }
    DispatchQueue.global(qos: .background).async {
        for filePath in filePaths {
            do{
                try fileManager.removeItem(at: filePath)
            }
            catch{
                print(error)
            }
        }
    }
}

func removeOneOrderFromFolder(fileName:String){
    guard let filePath = getPdfUrlPath(fileName: fileName) else { return }
    do{
        try FileManager.default.removeItem(at: filePath)
    }
    catch{
        print(error)
    }
}

func getPdfUrlPath(fileName:String) -> URL?{
    guard let ordersFolder = ordersFolder else { return nil }
    let filePath = fileName + ".pdf"
    let renderedUrl = ordersFolder.appending(path: filePath)
    return renderedUrl
}

func getQrImage() -> (Image?,String?){
    let token = UUID().uuidString
    guard let data = generateQrCode(qrCodeStr:token),
          let uiImage = UIImage(data: data) else { return (nil,nil)}
    
    return (Image(uiImage:uiImage),token)
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

func daysInCurrentMonth(monthNumber: Int,year: Int) -> Int {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = monthNumber
    guard let d = Calendar.current.date(from: dateComponents),
          let interval = Calendar.current.dateInterval(of: .month, for: d),
          let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
    else{ return 0 }
    return days
}

extension ButtonStyle where Self == CustomButtonStyleGradient {
    static var gradient: CustomButtonStyleGradient { .init() }
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

extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

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

extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    static func getSwedishWeekdayNames() -> [String]{
        var calendar = Calendar(identifier: .gregorian)
        //calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.locale = Locale(identifier: "sv")
        return calendar.weekdaySymbols
    }
    
    static func getSwedishShortWeekdayNames() -> [String]{
        var calendar = Calendar(identifier: .gregorian)
        //calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.locale = Locale(identifier: "sv")
        return calendar.shortWeekdaySymbols
    }
    
    static func getWeekdayName(_ weekday:Int) -> String{
        return getSwedishWeekdayNames()[weekday-1]
    }
    
    static func getShortWeekdayName(_ weekday:Int) -> String{
        return getSwedishShortWeekdayNames()[weekday-1]
    }
}


extension Date{
    
    static func from(_ year: Int, _ month: Int, _ day: Int) -> Date?{
        let gregorianCalendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents(calendar: gregorianCalendar, year: year, month: month, day: day)
        dateComponents.timeZone = .gmt
        return gregorianCalendar.date(from: dateComponents)
    }
    
    static func fromISO8601StringToDate(_ dateToProcess:String) -> Date?{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: dateToProcess)
    }
    
    func getFirstWeekdayInMonth() -> Int{
        let calendar = Calendar.current
        return calendar.component(.weekday, from: calendar.startOfMonth(self))
    }
    
    func toISO8601String() -> String{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        return formatter.string(from: self)
    }
    
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
         
        return dateFormatter.string(from: self)
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
        
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
        
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
        
    }
    
    func monthName() -> String{
        if let monthInt = Calendar.current.dateComponents([.month], from: self).month {
            return Calendar.current.shortMonthSymbols[monthInt-1]
        }
        return ""
    }
    
    func dayName() -> String{
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE")
        return df.string(from: self)
    }
    
    func getDaysInMonth() -> Int?{
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date)
        else{
            return nil
        }
        return range.count
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
    func exportAsPdf(renderedUrl:URL)->URL?{
      
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
    
    func fillSection() -> some View{
        self.modifier(FillFormModifier())
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
                primaryButton: .default(Text("OK"), action: { actionPrimary() }),
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
