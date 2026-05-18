import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let detail: String
    let theme: LevelTheme
    let highlights: [OnboardingHighlight]

    static let all: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            title: "Fly Through the Sky",
            subtitle: "One tap, one jump",
            detail: "Tap anywhere to lift your bird. Time each jump to slip through gaps and stay in the air.",
            theme: .sunny,
            highlights: [
                OnboardingHighlight(icon: "hand.tap.fill", text: "Tap to rise"),
                OnboardingHighlight(icon: "wind", text: "Feel the gravity"),
                OnboardingHighlight(icon: "slider.horizontal.3", text: "Adjust sensitivity in Settings")
            ]
        ),
        OnboardingPage(
            id: 1,
            title: "12 Epic Levels",
            subtitle: "Three worlds to master",
            detail: "Clear pipe goals to unlock harder stages. Sunny skies, sunset valleys, and starlight realms await.",
            theme: .sunset,
            highlights: [
                OnboardingHighlight(icon: "sun.max.fill", text: "Levels 1–4"),
                OnboardingHighlight(icon: "sunset.fill", text: "Levels 5–8"),
                OnboardingHighlight(icon: "moon.stars.fill", text: "Levels 9–12")
            ]
        ),
        OnboardingPage(
            id: 2,
            title: "Ready for Takeoff?",
            subtitle: "Your adventure starts now",
            detail: "Beat your records, earn trophies, and climb every level. The sky is wide open.",
            theme: .night,
            highlights: [
                OnboardingHighlight(icon: "list.number", text: "Track records"),
                OnboardingHighlight(icon: "trophy.fill", text: "Unlock awards"),
                OnboardingHighlight(icon: "flag.checkered", text: "Complete the campaign")
            ]
        )
    ]
}

struct OnboardingHighlight: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
}
