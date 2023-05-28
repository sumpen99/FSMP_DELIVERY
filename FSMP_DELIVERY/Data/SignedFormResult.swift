//
//  SignedFormResult.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-18.
//

enum SignedFormResult {
    case ORDER_NOT_ACCEPTABLE
    case FORM_NOT_FILLED
    case QR_CODE_IS_NOT_A_MATCH
    case SIGNATURE_IS_NOT_VALID
    case SIGNATURE_AND_QRCODE_MISSMATCH
    case IMAGE_DATA_ERROR
    case USER_URL_ERROR
    case UPLOAD_FAILED
    case DOWNLOAD_FAILED
    case FORM_SAVED_BUT_NO_MAIL_WAS_SENT
    case FORM_SIGNED_BUT_NO_MAIL_WAS_SENT
    case FORM_SAVED_SUCCESFULLY
    case FORM_SIGNED_SUCCESFULLY
}

extension SignedFormResult {
    var describeYourSelf : (title:String,message:String) {
        switch self {
            case .ORDER_NOT_ACCEPTABLE:
            return (title:"Saknar info",
                    message:"Beställningen saknar viktig information")
            case .FORM_NOT_FILLED:
            return (title:"Saknar info",
                    message:"Beställningen måste signeras eller innehålla en verifierad Qr-kod")
            case .QR_CODE_IS_NOT_A_MATCH:
            return (title:"Qr-Kod ej verifierad",
                    message:"Scannad qr-kod överensstämmer inte med order-id")
            case .SIGNATURE_IS_NOT_VALID:
            return (title:"Signatur ej verifierad",
                    message:"Signatur är ej godkänd, skaka och signera igen")
            case .SIGNATURE_AND_QRCODE_MISSMATCH:
            return (title:"ERROR",
                    message:"Varken qr-kod eller signatur kan verifieras")
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
            case .FORM_SIGNED_SUCCESFULLY:
            return (title:"Order signerad",
                    message:"Kunden har fått bekräftelse skickad på mail")
            case .FORM_SAVED_BUT_NO_MAIL_WAS_SENT:
            return (title:"Order sparad",
                    message:"Orden har sparats men mail skickades inte ut till kund")
            case .FORM_SIGNED_BUT_NO_MAIL_WAS_SENT:
            return (title:"Order signerad",
                    message:"Orden har signerats men mail skickades inte ut till kund")
            }
    }
}
