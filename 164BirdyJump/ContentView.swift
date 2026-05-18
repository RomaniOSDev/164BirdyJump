import SwiftUI

struct ContentView: View {
    @AppStorage(OnboardingStorage.completedKey) private var hasCompletedOnboarding = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.birdySkyBottom.opacity(0.95))
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.birdyBird)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.birdyBird)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainAppView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

private struct MainAppView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            BirdyJumpView(viewModel: viewModel)
                .tabItem {
                    Label("Play", systemImage: "gamecontroller.fill")
                }
                .tag(0)

            LevelsView(viewModel: viewModel)
                .tabItem {
                    Label("Levels", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)

            HighScoresView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Records", systemImage: "list.number")
                }
                .tag(2)

            AchievementsView(viewModel: viewModel)
                .tabItem {
                    Label("Awards", systemImage: "trophy.fill")
                }
                .tag(3)

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.birdyBird)
    }
}

#Preview("Main App") {
    MainAppView()
}

#Preview("Onboarding Gate") {
    ContentView()
}
