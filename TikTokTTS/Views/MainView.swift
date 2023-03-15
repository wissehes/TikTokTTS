//
//  MainView.swift
//  TikTokTTS
//
//  Created by Wisse Hes on 15/03/2023.
//

import SwiftUI
import Alamofire
import AVKit

struct Constants {
    static let user_agent = "com.zhiliaoapp.musically/2022600030 (Linux; U; Android 7.1.2; es_ES; SM-G988N; Build/NRD90M;tt-ok/3.12.13.1)"
    static let sessionid = "336c1fe56d00d99427a8b492eaa59278"
    static let tiktok_api = "https://api16-normal-useast5.us.tiktokv.com/media/api/text/speech/invoke/"
    static let custom_api = "https://tiktok-tts.weilnet.workers.dev"
}

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        Form {
            TextField("Text", text: $vm.text)
            Picker("Voice", selection: $vm.voice) {
                ForEach(Array(voices).sorted(by: { $0.key < $1.key }), id: \.key) { category in
                    Section(category.key) {
                        ForEach(category.value, id: \.code) { voice in
                            Text(voice.name)
                                .tag(voice)
                        }
                    }
                }
            }
            
            Button("Get TTS") {
                Task {
                    do {
                        try await vm.load()
                    } catch {
                        print(error)
                    }
                }
            }
            
            
        }.padding()
            .frame(minWidth: 100, minHeight: 250)
    }
}

final class MainViewModel: ObservableObject {
    @Published var text = ""
    @Published var voice: Voice = .init(code: "en_uk_001", name: "Male 1")
    @Published var isLoading = false
    
    @Published var player: AVAudioPlayer?
    
    func load() async throws {
        let params: Parameters = [
            "voice": voice.code,
            "text": text,
        ]
        
        let request = AF.request(
            "\(Constants.custom_api)/api/generation",
            method: .post,
            parameters: params,
            encoding: JSONEncoding()
        )
        
        let response = try await request.serializingDecodable(TTSResponse.self).value

        if let audio = response.audioData {
            DispatchQueue.main.async {
                self.playSound(data: audio)
            }
        }
    }
    
    func playSound(data: Data) {
        do {
            self.player = try .init(data: data)
            self.player?.play()
        } catch {
            print(error)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
