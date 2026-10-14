//
//  PinScreenModel.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

struct PinScreenModel: Codable {
    let profileImageUrl: String
    let name: String
    let phone: String
}

struct PinVerifyRequest: Encodable {
    let pin: String
}
