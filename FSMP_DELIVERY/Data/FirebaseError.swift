//
//  FirebaseError.swift
//  FSMP_DELIVERY
//
//  Created by fredrik sundström on 2023-05-30.
//

enum FirebaseError: Error {
    case TRY_SET_DATA_FAILED
}

extension FirebaseError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .TRY_SET_DATA_FAILED:
            return "Tried set data but failed"
            
        }
    }
}
