import Foundation

struct Story: Identifiable, Codable {
    let id: String
    let title: String
    let sentences: [Sentence]
    let animations: [String: String] // sentence index -> animation asset name
}

struct Sentence: Identifiable, Codable {
    let id: String
    let text: String
    let tappableWords: [String]
}

struct StoryLibrary {
    static let stories: [Story] = [
        Story(
            id: "lost_star",
            title: "The Lost Star",
            sentences: [
                Sentence(
                    id: "s1",
                    text: "A small star fell from the sky.",
                    tappableWords: ["star", "fell", "sky"]
                ),
                Sentence(
                    id: "s2",
                    text: "It felt scared and alone.",
                    tappableWords: ["scared", "alone"]
                ),
                Sentence(
                    id: "s3",
                    text: "A little girl found it shining in the grass.",
                    tappableWords: ["girl", "shining", "grass"]
                ),
                Sentence(
                    id: "s4",
                    text: "She lifted it up and smiled.",
                    tappableWords: ["lifted", "smiled"]
                ),
                Sentence(
                    id: "s5",
                    text: "That night, the star returned home.",
                    tappableWords: ["night", "returned", "home"]
                ),
                Sentence(
                    id: "s6",
                    text: "The sky felt complete again.",
                    tappableWords: ["sky", "complete"]
                ),
                Sentence(
                    id: "s7",
                    text: "Moral: Kindness brings light.",
                    tappableWords: ["kindness", "light"]
                )
            ],
            animations: [
                "0": "star_fall",
                "1": "star_scared",
                "2": "girl_find",
                "3": "girl_smile",
                "4": "star_home",
                "5": "sky_complete",
                "6": "moral_light"
            ]
        ),
        Story(
            id: "slow_winner",
            title: "The Slow Winner",
            sentences: [
                Sentence(
                    id: "s1",
                    text: "A rabbit laughed at a turtle.",
                    tappableWords: ["rabbit", "laughed", "turtle"]
                ),
                Sentence(
                    id: "s2",
                    text: "\"You are too slow,\" he said.",
                    tappableWords: ["slow", "said"]
                ),
                Sentence(
                    id: "s3",
                    text: "They ran a race.",
                    tappableWords: ["ran", "race"]
                ),
                Sentence(
                    id: "s4",
                    text: "The rabbit slept on the way.",
                    tappableWords: ["rabbit", "slept"]
                ),
                Sentence(
                    id: "s5",
                    text: "The turtle kept walking.",
                    tappableWords: ["turtle", "walking"]
                ),
                Sentence(
                    id: "s6",
                    text: "The turtle won the race.",
                    tappableWords: ["turtle", "won"]
                ),
                Sentence(
                    id: "s7",
                    text: "Moral: Slow and steady wins.",
                    tappableWords: ["slow", "steady", "wins"]
                )
            ],
            animations: [
                "0": "rabbit_laugh",
                "1": "turtle_slow",
                "2": "race_start",
                "3": "rabbit_sleep",
                "4": "turtle_walk",
                "5": "turtle_win",
                "6": "moral_steady"
            ]
        ),
        Story(
            id: "talking_tree",
            title: "The Talking Tree",
            sentences: [
                Sentence(
                    id: "s1",
                    text: "A boy sat under a tree.",
                    tappableWords: ["boy", "tree", "under"]
                ),
                Sentence(
                    id: "s2",
                    text: "He felt sad and tired.",
                    tappableWords: ["sad", "tired"]
                ),
                Sentence(
                    id: "s3",
                    text: "The tree whispered, \"Rest here.\"",
                    tappableWords: ["tree", "whispered", "rest"]
                ),
                Sentence(
                    id: "s4",
                    text: "The boy smiled and closed his eyes.",
                    tappableWords: ["smiled", "closed", "eyes"]
                ),
                Sentence(
                    id: "s5",
                    text: "When he woke up, he felt happy.",
                    tappableWords: ["woke", "happy"]
                ),
                Sentence(
                    id: "s6",
                    text: "The tree stood silent again.",
                    tappableWords: ["tree", "silent"]
                ),
                Sentence(
                    id: "s7",
                    text: "Moral: Nature heals us.",
                    tappableWords: ["nature", "heals"]
                )
            ],
            animations: [
                "0": "tree_shade",
                "1": "boy_sad",
                "2": "tree_whisper",
                "3": "boy_rest",
                "4": "boy_happy",
                "5": "tree_silent",
                "6": "moral_nature"
            ]
        ),
        Story(
            id: "brave_little_bird",
            title: "The Brave Little Bird",
            sentences: [
                Sentence(
                    id: "s1",
                    text: "A baby bird feared flying.",
                    tappableWords: ["bird", "feared", "flying"]
                ),
                Sentence(
                    id: "s2",
                    text: "The sky looked too big.",
                    tappableWords: ["sky", "big"]
                ),
                Sentence(
                    id: "s3",
                    text: "Its mother waited below.",
                    tappableWords: ["mother", "waited", "below"]
                ),
                Sentence(
                    id: "s4",
                    text: "The bird jumped and fell.",
                    tappableWords: ["bird", "jumped", "fell"]
                ),
                Sentence(
                    id: "s5",
                    text: "Then it flew.",
                    tappableWords: ["flew"]
                ),
                Sentence(
                    id: "s6",
                    text: "Fear turned into joy.",
                    tappableWords: ["fear", "joy"]
                ),
                Sentence(
                    id: "s7",
                    text: "Moral: Bravery starts with one step.",
                    tappableWords: ["bravery", "starts", "step"]
                )
            ],
            animations: [
                "0": "bird_scared",
                "1": "sky_big",
                "2": "mother_wait",
                "3": "bird_jump",
                "4": "bird_fly",
                "5": "joy",
                "6": "moral_brave"
            ]
        ),
        Story(
            id: "cloud_that_cried",
            title: "The Cloud That Cried",
            sentences: [
                Sentence(
                    id: "s1",
                    text: "A cloud felt heavy inside.",
                    tappableWords: ["cloud", "heavy", "inside"]
                ),
                Sentence(
                    id: "s2",
                    text: "It cried and cried.",
                    tappableWords: ["cried"]
                ),
                Sentence(
                    id: "s3",
                    text: "Rain fell on dry land.",
                    tappableWords: ["rain", "fell", "land"]
                ),
                Sentence(
                    id: "s4",
                    text: "Flowers began to bloom.",
                    tappableWords: ["flowers", "bloom"]
                ),
                Sentence(
                    id: "s5",
                    text: "The cloud smiled.",
                    tappableWords: ["cloud", "smiled"]
                ),
                Sentence(
                    id: "s6",
                    text: "Its tears helped others grow.",
                    tappableWords: ["tears", "helped", "grow"]
                ),
                Sentence(
                    id: "s7",
                    text: "Moral: Feelings can create good things.",
                    tappableWords: ["feelings", "create", "good"]
                )
            ],
            animations: [
                "0": "cloud_heavy",
                "1": "cloud_cry",
                "2": "rain_fall",
                "3": "flowers_bloom",
                "4": "cloud_smile",
                "5": "grow",
                "6": "moral_feelings"
            ]
        )
    ]
}
