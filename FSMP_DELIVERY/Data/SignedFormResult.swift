//
//  SignedFormResult.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

enum SignedFormResult : Error {
    case FORM_NOT_FILLED
    case IMAGE_DATA_ERROR
    case USER_URL_ERROR
    case UPLOAD_FAILED
    case DOWNLOAD_FAILED
    case FORM_SAVED_SUCCESFULLY
}

extension SignedFormResult {
    var describeYourSelf : (title:String,message:String) {
        switch self {
            case .FORM_NOT_FILLED:
            return (title:"Saknar info",
                    message:"Beställningen måste signeras eller innehålla en verifierad Qr-kod")
            case .IMAGE_DATA_ERROR:
            return (title:"Uppladdning Avbruten",
                    message:"Registrering av order misslyckades\nFelmeddelande: IMAGE_DATA")
            case .USER_URL_ERROR:
            return (title:"Uppladdning Avbruten",
                    message:"Registrering av order misslyckades\nFelmeddelande: USER_URL")
            case .UPLOAD_FAILED:
            return (title:"Uppladdning Misslyckades",
                    message:"Uppladdning av pdf misslyckades\nFelmeddelande: UPLOAD_FAILED")
            case .DOWNLOAD_FAILED:
            return (title:"Nedladdning Misslyckades",
                    message:"Nedladdning av pdf misslyckades\nFelmeddelande: DOWNLOAD_FAILED")
            case .FORM_SAVED_SUCCESFULLY:
            return (title:"Order sparad",
                    message:"Kunden har fått bekräftelse skickad på mail")
            }
        
    }
}
