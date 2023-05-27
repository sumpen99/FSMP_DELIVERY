//
//  PDFKitView.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-26.
//

import SwiftUI
import PDFKit
struct PDFKitView: View{
    @Binding var url:URL?
    
    var body: some View{
        PDFKitRepresentedView(url:self.url)
        .padding()
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL?
    let pdfView = PDFView()
   
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        //pdfView.autoScales = true
        //guard let document = PDFDocument(url: self.url) else { return UIView()}
        //pdfView.document = document
        //pdfView.usePageViewController(true)

        /*DispatchQueue.main.async {
            self.total = document.pageCount
            print("Total pages: \(total)")
        }*/
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        guard let url = self.url, let document = PDFDocument(url: url) else { return }
        if uiView.window != nil, !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
                uiView.document = document
            }
        }
        else{
            print("PDFKitView line 47 if uiView.window != nil, !uiView.isFirstResponder ")
        }
        //pdfView.autoScales = true
        /*guard let pdfView = uiView as? PDFView else { return }

        if currentPage < total {
            pdfView.go(to: pdfView.document!.page(at: currentPage)!)
        }*/
    }
    
    func goToNextPage(){
        pdfView.goToNextPage(nil)
    }
}
