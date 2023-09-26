//
//  Voices.swift
//  TikTokTTS
//
//  Created by Wisse Hes on 15/03/2023.
//

import Foundation

struct Voice: Hashable {
    let code: String
    let name: String
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
    
    init(_ code: String, _ name: String) {
        self.code = code
        self.name = name
    }
}

typealias Voices = [String: [Voice]]

extension Voices {
    var array: Array<(key: String, value: [Voice])> {
        return Array(voices).sorted(by: { $0.key < $1.key })
    }
    var allVoices: Array<Voice> {
        var voicesArray: [Voice] = []
        
        for category in voices {
            voicesArray.append(contentsOf: category.value)
        }
        
        return voicesArray
    }
}

// Thanks to https://github.com/oscie57/tiktok-voice/wiki/Voice-Codes
// And https://github.com/Steve0929/tiktok-tts/blob/main/README.md
// TODO: Organize voices better and remove duplicates
let voices: Voices = [
    "Disney": [
        .init(code: "en_us_ghostface", name: "Ghost"),
        .init(code: "en_us_chewbacca", name: "Disney Chewbacca"),
        .init("en_us_c3po", "C3PO"),
        .init("en_us_stitch", "Stitch"),
        .init("en_us_stormtrooper", "Stormtrooper"),
        .init("en_us_rocket", "Rocket"),
        .init("en_female_madam_leota", "Madame Leota"),
        .init("en_male_ghosthost", "Ghost Host"),
        .init("en_male_pirate", "Pirate")
    ],
    "English: Australian": [
        .init(code: "en_au_001", name: "Female"),
        .init(code: "en_au_002", name: "Male"),
    ],
    "English: United Kingdom": [
        .init(code: "en_uk_001", name: "Male 1"),
        .init(code: "en_uk_002", name: "Male 2")
    ],
    "English: United States": [
        .init("en_us_001", "Female 1"),
        .init("en_us_002", "Female 2"),
        .init("en_us_006", "Male 1"),
        .init("en_us_007", "Male 2"),
        .init("en_us_009", "Male 3"),
        .init("en_us_010", "Male 4"),
    ],
    "English: Other": [
        .init("en_male_narration", "Narrator"),
        .init("en_male_funny", "Wacky"),
        .init("en_female_emotional", "Peaceful"),
        .init("en_male_cody", "Serious"),
        .init("en_male_jomboy", "Game On"),
        .init("es_mx_002", "Warm"),
        .init("en_us_ghostface", "Scream"),
        .init("en_female_samc", "Empathetic"),
        .init("en_female_makeup", "Beauty Guru"),
        .init("en_female_richgirl", "Bestie"),
        .init("en_male_grinch", "Trickster"),
        .init("en_male_narration", "Story Teller"),
        .init("en_male_deadpool", "Mr. GoodGuy"),
        .init("en_male_jarvis", "Alfred"),
        .init("en_male_ashmagic", "ashmagic"),
        .init("en_male_olantekkers", "olantekkers"),
        .init("en_male_ukneighbor", "Lord Cringe"),
        .init("en_male_ukbutler", "Mr. Meticulous"),
        .init("en_female_shenna", "Debutante"),
        .init("en_female_pansino", "Varsity"),
        .init("en_male_trevor", "Marty"),
        .init("en_female_f08_twinkle", "Pop Lullaby"),
        .init("en_male_m03_classical", "Classic Electric"),
        .init("en_female_betty", "Bae"),
        .init("en_male_cupid", "Cupid"),
        .init("en_female_grandma", "Granny"),
        .init("en_male_m2_xhxs_m03_christmas", "Cozy"),
        .init("en_male_santa_narration", "Author"),
        .init("en_male_sing_deep_jingle", "Caroler"),
        .init("en_male_santa_effect", "Santa"),
        .init("en_female_ht_f08_newyear", "NYE 2023"),
        .init("en_male_wizard", "Magician"),
        .init("en_female_ht_f08_halloween", "Opera"),
        .init("en_male_sing_funny_thanksgiving", "Thanksgiving"),
        .init("en_us_007", "Professor"),
        .init("en_us_009", "Scientist"),
        .init("en_us_010", "Confidence"),
        .init("en_au_002", "Smooth")
    ],
    "French": [
        .init("fr_001", "Male 1"),
        .init("fr_002", "Male 2")
    ],
    "German": [
        .init("de_001", "Female"),
        .init("de_002", "Male")
    ],
    "Spanish": [
        .init("es_002", "Male")
    ],
    "Vocals": [
        .init("en_female_f08_salut_damour", "Alto"),
        .init("en_male_m03_lobby", "Tenor"),
        .init("en_male_m03_sunshine_soon", "Sunshine Soon"),
        .init("en_female_f08_warmy_breeze", "Warmy Breeze"),
        .init("en_female_ht_f08_glorious", "Glorious"),
        .init("en_male_sing_funny_it_goes_up", "It Goes Up"),
        .init("en_male_m2_xhxs_m03_silly", "Chipmunk"),
        .init("en_female_ht_f08_wonderful_world", "Dramatic")
    ]
]
