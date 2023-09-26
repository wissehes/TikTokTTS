//
//  MainView.swift
//  TikTokTTS
//
//  Created by Wisse Hes on 15/03/2023.
//

import SwiftUI
import Alamofire
//import AVKit
import AVFoundation

struct Constants {
    static let user_agent = "com.zhiliaoapp.musically/2022600030 (Linux; U; Android 7.1.2; es_ES; SM-G988N; Build/NRD90M;tt-ok/3.12.13.1)"
    static let sessionid = "336c1fe56d00d99427a8b492eaa59278"
    static let tiktok_api = "https://api16-normal-useast5.us.tiktokv.com/media/api/text/speech/invoke/"
    static let custom_api = "https://tiktok-tts.weilnet.workers.dev"
}

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    var body: some View {
        VStack {
            GroupBox("Text to speech") {
                Form {
                    TextField("Text", text: $vm.text, prompt: Text("Enter text..."))
                        .frame(maxWidth: 300)
                    HStack {
                        picker
                            .frame(maxWidth: 300)
                        Button("Random") {
                            if let random = voices.allVoices.randomElement() {
                                vm.voice = random
                            }
                        }
                    }
                    HStack {
                        Button("Submit") {
                            Task {
                                do {
                                    try await vm.load()
                                } catch {
                                    print(error)
                                }
                            }
                        }.disabled(!vm.canTextToSpeech)
                        
                        if vm.isLoading {
                            ProgressView()
                                .scaleEffect(0.6)
                                .frame(width: 10, height: 10)
                        }
                    }
                    
                }.padding()
                    .frame(maxWidth: 400)
            }
            
            player
            
        }.padding()
            .frame(minWidth: 450, minHeight: 300)
    }
    
    var player: some View {
        GroupBox("Audio") {
            HStack {
                Button("Play") {
                    vm.playSound()
                }
                
                Button("Stop") {
                    vm.player?.stop()
                }
                
                Button("Save file") { vm.saveAudio() }
                    .disabled(!vm.canTextToSpeech)
            }.disabled(vm.data == nil)
            .padding()
            .frame(maxWidth: 400)
        }
    }
    
    var picker: some View {
        Picker("Voice", selection: $vm.voice) {
            // Iterate over sorted categories
            ForEach(voices.array, id: \.key) { category in
                // Create a section for each category
                Section(category.key) {
                    // Iterate over the category's voices
                    ForEach(category.value, id: \.code) { voice in
                        Text("\(category.key) - \(voice.name)")
                            .tag(voice)
                    }
                }
            }
        }
    }
}

final class MainViewModel: ObservableObject {
    @Published var text = ""
    @Published var voice: Voice = .init(code: "en_uk_001", name: "Male 1")
    @Published var isLoading = false
    
    @Published var player: AVAudioPlayer?
    @Published var playing = false
    
    @Published var data: Data?
    
    var canTextToSpeech: Bool {
        text.count > 0 && text.count < 300
    }
    
    func load() async throws {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
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
                withAnimation {
                    self.data = audio
                }
            }
        }
    }
    
    func playSound() {
        guard let data = self.data else { return }
        
        do {
            self.player = try .init(data: data)
            self.player?.play()
//            self.player.se
        } catch {
            print(error)
        }
    }
    
    func saveAudio() {
        guard let data = self.data else { return }
        guard let fileURL = self.showSavePanel() else { return }
        
        try? data.write(to: fileURL)
    }
    
    private func showSavePanel() -> URL? {

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.mp3]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your text-to-speech file"
        savePanel.message = "Choose a folder and a name to store the audio."
        savePanel.nameFieldStringValue = "audio.mp3"
//        savePanel.nameFieldLabel = "Image file name:"
        
        let response = savePanel.runModal()

        return response == .OK ? savePanel.url : nil
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
