//
//  MailManager.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-25.
//
import SwiftUI
import SwiftSMTP
class MailManager{
    var onResult: ((Bool) -> Void)? = nil
    let SMTP_ADRESS = "smtp.gmail.com"
    var EMAIL_ADRESS_SENDER = ""
    var EMAIL_TOKEN = ""
    var EMAIL_SUBJECT = ""
    var EMAIL_TEXT = ""
    
    init(credentials:Credentials){
        EMAIL_ADRESS_SENDER = credentials.adress
        EMAIL_TOKEN = credentials.token
    }
  
    func sendSignedResponseMailTo(_ customer:Customer,fileUrl:URL){
        setSignedSubjectAndText()
        let email = createMail(customer.email,name:customer.name,filePath:fileUrl.relativePath)
        sendEmail(email)
    }
    
    /*func sendSignedResponseMailTo(fileUrl:URL){
        // pass customerinfo
        setSignedSubjectAndText()
        let email = createMail("fredrik@heatia.se",name:"Fredrik Sundström",filePath:fileUrl.relativePath)
        sendEmail(email)
    }*/
    
    func sendOrderResponseMailTo(customer:Customer,fileUrl:URL){
        setAcceptedOrderSubjectAndText()
        let email = createMail(customer.email,name:customer.name,filePath:fileUrl.relativePath)
        sendEmail(email)
    }
    
    func sendEmail(_ email:Mail){
        let smtp = SMTP(
            hostname:SMTP_ADRESS,
            email:EMAIL_ADRESS_SENDER,
            password:EMAIL_TOKEN,
            port:587
        )
        DispatchQueue.global(qos: .background).async {
            smtp.send(email){ [weak self] error in
                guard let strongSelf = self else { return }
                DispatchQueue.main.sync { 
                    strongSelf.onResult?(error == nil)
                    //print(error == nil)
                }
                
            }
        
        }
    }
    
    func createMail(_ email:String,name:String,filePath:String) -> Mail{
        //let toUser = Mail.User(name:name,email: adress)
        let EMAIL_SENDER = Mail.User(name:"Team FSMP",email: EMAIL_ADRESS_SENDER)
        let toUser = Mail.User(name:name,email: email)
        
        let attachments = [
            Attachment(
                filePath: filePath,
                additionalHeaders: ["CONTENT_ID": "pdf001"])
        ]
        
        return Mail(
            from:EMAIL_SENDER,
            to:[toUser],
            subject:EMAIL_SUBJECT,
            text:EMAIL_TEXT,
            attachments: attachments
        )
    }
    
    func setSignedSubjectAndText(){
        EMAIL_SUBJECT = "Tack för förtroendet"
        EMAIL_TEXT = "Din service är signerad och klar.\nHoppas arbetet var till belåtenhet \nFSMP_DELIVERY_SERVICE."
    }
    
    func setAcceptedOrderSubjectAndText(){
        EMAIL_SUBJECT = "Din order är mottagen"
        EMAIL_TEXT = "Den kommer behandlas så snart som möjligt.\nFSMP_DELIVERY_SERVICE."
    }
    
}
