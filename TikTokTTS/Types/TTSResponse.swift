//
//  TTSResponse.swift
//  TikTokTTS
//
//  Created by Wisse Hes on 15/03/2023.
//

import Foundation

struct TTSResponse: Codable {
    let success: Bool
    let data: String
    let error: String?
    
    var audioData: Data? {
//        return Data(base64Encoded: "data:audio/mpeg;base64,\(data)")
        return Data(base64Encoded: data)

    }
}
