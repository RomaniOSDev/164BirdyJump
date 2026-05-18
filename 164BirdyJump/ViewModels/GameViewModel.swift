import AudioToolbox
import Combine
import CoreGraphics
import SwiftUI
import UIKit

@MainActor
final class GameViewModel: ObservableObject {
    enum GameState {
        case menu
        case playing
        case gameOver
        case levelComplete
    }

    @Published var gameState: GameState = .menu
    @Published var isPaused = false
    @Published var score = 0
    @Published var highScore = 0
    @Published var settings = GameSettings(soundEnabled: true, vibrationEnabled: true)
    @Published var topScores: [GameScore] = []
    @Published var achievements: [Achievement] = []
    @Published var selectedLevel: GameLevel = GameLevel.all[0]
    @Published var levelRecords: [LevelRecord] = []
    @Published var completedLevel: GameLevel?

    @Published var birdY: CGFloat = 0
    @Published var birdVelocity: CGFloat = 0
    @Published var birdRotation: Double = 0
    @Published var birdOffsetX: CGFloat = 0
    @Published var wingFlapTrigger: Int = 0
    @Published var obstacles: [Obstacle] = []

    private var displayLinkDriver: DisplayLinkDriver?
    private var spawnAccumulator: Double = 0
    private var lastUpdateDate: Date?
    private var screenSize = CGSize(width: 390, height: 844)

    private let gravity: CGFloat = 950
    private let maxFallVelocity: CGFloat = 500

    /// Upward velocity from tap, derived from desired lift height in pixels.
    private var jumpImpulse: CGFloat {
        let lift = CGFloat(settings.tapLiftPixels)
        return -sqrt(2 * gravity * lift)
    }
    private let birdSize: CGFloat = 50
    private let baseBirdX: CGFloat = 100

    var birdDisplayX: CGFloat { baseBirdX + birdOffsetX }
    private let obstacleWidth: CGFloat = 60
    private let maxDeltaTime: TimeInterval = 1.0 / 20.0

    private let scoresKey = "birdyjump_scores"
    private let settingsKey = "birdyjump_settings"
    private let achievementsKey = "birdyjump_achievements"
    private let highScoreKey = "birdyjump_high_score"
    private let levelsKey = "birdyjump_levels"
    private let selectedLevelKey = "birdyjump_selected_level"

    var activeLevel: GameLevel { selectedLevel }

    var activeTheme: LevelTheme {
        LevelTheme.theme(forLevelId: selectedLevel.id)
    }

    var levelProgress: Double {
        guard activeLevel.targetPipes > 0 else { return 0 }
        return min(Double(score) / Double(activeLevel.targetPipes), 1)
    }

    var pipesRemaining: Int {
        max(activeLevel.targetPipes - score, 0)
    }

    init() {
        loadData()
    }

    func record(for levelID: Int) -> LevelRecord {
        levelRecords.first { $0.levelID == levelID }
            ?? LevelRecord(levelID: levelID, isUnlocked: levelID == 1, isCompleted: false, bestScore: 0)
    }

    func selectLevel(_ level: GameLevel) {
        guard record(for: level.id).isUnlocked else { return }
        selectedLevel = level
        UserDefaults.standard.set(level.id, forKey: selectedLevelKey)
    }

    // MARK: - Screen

    func updateScreenSize(_ size: CGSize) {
        guard size.width > 0, size.height > 0 else { return }
        screenSize = size
        if gameState != .playing {
            birdY = size.height / 2
        }
    }

    // MARK: - Game Control

    func startGame() {
        guard record(for: selectedLevel.id).isUnlocked else { return }
        score = 0
        completedLevel = nil
        gameState = .playing
        isPaused = false
        resetPhysics()
        startGameLoop()
    }

    func resetGame() {
        returnToMenu()
    }

    func returnToMenu() {
        stopGameLoop()
        gameState = .menu
        score = 0
        isPaused = false
        completedLevel = nil
        resetPhysics()
    }

    func replayCurrentLevel() {
        startGame()
    }

    func goToNextLevel() {
        let nextID = selectedLevel.id + 1
        guard let next = GameLevel.all.first(where: { $0.id == nextID }),
              record(for: next.id).isUnlocked else {
            returnToMenu()
            return
        }
        selectLevel(next)
        startGame()
    }

    func togglePause() {
        guard gameState == .playing else { return }
        isPaused.toggle()
        if isPaused {
            stopGameLoop()
        } else {
            startGameLoop()
        }
    }

    func birdJump() {
        guard gameState == .playing, !isPaused else { return }
        birdVelocity = jumpImpulse
        lastUpdateDate = Date()
        wingFlapTrigger += 1
        playJumpFeedback()
    }

    func gameOver() {
        guard gameState == .playing else { return }
        stopGameLoop()
        gameState = .gameOver

        updateLevelBestScore()

        let newScore = GameScore(id: UUID(), score: score, date: Date())
        topScores.append(newScore)
        topScores.sort { $0.score > $1.score }
        if topScores.count > 10 {
            topScores = Array(topScores.prefix(10))
        }

        if score > highScore {
            highScore = score
            checkAchievements()
        }

        if settings.vibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }

        saveData()
    }

    private func completeLevel() {
        guard gameState == .playing else { return }
        stopGameLoop()
        gameState = .levelComplete
        completedLevel = activeLevel

        updateLevelRecord(levelID: activeLevel.id, score: score, markCompleted: true)

        let nextID = activeLevel.id + 1
        if let index = levelRecords.firstIndex(where: { $0.levelID == nextID }) {
            levelRecords[index].isUnlocked = true
        }

        if settings.vibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }

        saveData()
    }

    // MARK: - Scoring

    func addScore(points: Int) {
        score += points
        updateLevelBestScore()

        if score > highScore {
            highScore = score
            checkAchievements()
        }

        if score >= activeLevel.targetPipes {
            completeLevel()
        }
    }

    private func updateLevelBestScore() {
        updateLevelRecord(levelID: activeLevel.id, score: score, markCompleted: false)
    }

    private func updateLevelRecord(levelID: Int, score: Int, markCompleted: Bool) {
        guard let index = levelRecords.firstIndex(where: { $0.levelID == levelID }) else { return }
        if score > levelRecords[index].bestScore {
            levelRecords[index].bestScore = score
        }
        if markCompleted {
            levelRecords[index].isCompleted = true
        }
    }

    private func checkAchievements() {
        var didUnlock = false
        for index in achievements.indices where !achievements[index].isUnlocked {
            if highScore >= achievements[index].requiredScore {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                didUnlock = true
            }
        }
        if didUnlock {
            saveData()
        }
    }

    // MARK: - Game Loop

    private func startGameLoop() {
        stopGameLoop()
        spawnAccumulator = 0
        lastUpdateDate = Date()

        let driver = DisplayLinkDriver { [weak self] in
            guard let self else { return }
            MainActor.assumeIsolated {
                self.updateGame()
            }
        }
        driver.start()
        displayLinkDriver = driver
    }

    private func stopGameLoop() {
        displayLinkDriver?.stop()
        displayLinkDriver = nil
    }

    private func applyBirdPhysics(deltaTime: TimeInterval) {
        let dt = CGFloat(min(max(deltaTime, 0), maxDeltaTime))
        guard dt > 0 else { return }

        birdVelocity += gravity * dt
        birdVelocity = min(birdVelocity, maxFallVelocity)
        birdY += birdVelocity * dt
    }

    /// Smooth tilt and slight forward drift — dive nose-down, glide forward on fall.
    private func updateBirdPresentation(deltaTime: TimeInterval) {
        let dt = min(max(deltaTime, 0), maxDeltaTime)
        guard dt > 0 else { return }

        let targetRotation = Double(min(max(birdVelocity * 0.13, -28), 50))
        let rotationStep = min(dt * 9, 1)
        birdRotation += (targetRotation - birdRotation) * rotationStep

        let targetOffsetX: CGFloat
        if birdVelocity > 60 {
            targetOffsetX = min(birdVelocity * 0.04, 16)
        } else if birdVelocity < -80 {
            targetOffsetX = max(birdVelocity * 0.012, -5)
        } else {
            targetOffsetX = birdOffsetX * 0.85
        }

        let offsetStep = min(CGFloat(dt) * 7, 1)
        birdOffsetX += (targetOffsetX - birdOffsetX) * offsetStep
    }

    @discardableResult
    private func checkBirdBounds() -> Bool {
        let minY = birdSize / 2
        let maxY = screenSize.height - birdSize / 2
        if birdY <= minY || birdY >= maxY {
            gameOver()
            resetPhysics()
            return true
        }
        return false
    }

    private func updateGame() {
        guard gameState == .playing, !isPaused else { return }

        let now = Date()
        let rawDelta = lastUpdateDate.map { now.timeIntervalSince($0) } ?? 0
        lastUpdateDate = now
        let deltaTime = min(max(rawDelta, 0), maxDeltaTime)
        let dt = CGFloat(deltaTime)

        applyBirdPhysics(deltaTime: deltaTime)
        updateBirdPresentation(deltaTime: deltaTime)
        if checkBirdBounds() { return }

        let level = activeLevel
        let speed = level.obstacleSpeed
        let obstacleDelta = speed * dt * 60
        for index in obstacles.indices {
            obstacles[index].x -= obstacleDelta
        }
        obstacles.removeAll { $0.x + obstacleWidth < 0 }

        spawnAccumulator += deltaTime
        let spawnInterval = level.spawnInterval
        let minSpacing = obstacleWidth + speed * CGFloat(spawnInterval) * 30
        let canSpawn = obstacles.isEmpty || (obstacles.last!.x < screenSize.width - minSpacing)
        if spawnAccumulator >= spawnInterval && canSpawn {
            spawnObstacle()
            spawnAccumulator = 0
        }

        let birdRect = CGRect(
            x: baseBirdX - birdSize / 2,
            y: birdY - birdSize / 2,
            width: birdSize,
            height: birdSize
        )

        let gapHalf = level.gapSize / 2
        for index in obstacles.indices {
            let obstacle = obstacles[index]
            let topHeight = max(0, obstacle.gapCenterY - gapHalf)
            let bottomY = obstacle.gapCenterY + gapHalf
            let bottomHeight = max(0, screenSize.height - bottomY)

            let topRect = CGRect(x: obstacle.x, y: 0, width: obstacle.width, height: topHeight)
            let bottomRect = CGRect(x: obstacle.x, y: bottomY, width: obstacle.width, height: bottomHeight)

            if birdRect.intersects(topRect) || birdRect.intersects(bottomRect) {
                gameOver()
                resetPhysics()
                return
            }

            if !obstacles[index].isPassed && obstacle.x + obstacle.width < baseBirdX {
                obstacles[index].isPassed = true
                addScore(points: 1)
                if gameState != .playing { return }
            }
        }
    }

    private func spawnObstacle() {
        let gapSize = activeLevel.gapSize
        let margin: CGFloat = 80
        let minCenter = margin + gapSize / 2
        let maxCenter = screenSize.height - margin - gapSize / 2
        guard maxCenter > minCenter else { return }

        let gapCenterY = CGFloat.random(in: minCenter...maxCenter)
        let obstacle = Obstacle(
            id: UUID(),
            x: screenSize.width,
            gapCenterY: gapCenterY,
            width: obstacleWidth,
            isPassed: false
        )
        obstacles.append(obstacle)
    }

    private func resetPhysics() {
        birdY = screenSize.height / 2
        birdVelocity = 0
        birdRotation = 0
        birdOffsetX = 0
        obstacles.removeAll()
        spawnAccumulator = 0
        lastUpdateDate = nil
    }

    private func playJumpFeedback() {
        if settings.soundEnabled {
            AudioServicesPlaySystemSound(1104)
        }
        if settings.vibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

    // MARK: - Persistence

    func saveData() {
        if let encoded = try? JSONEncoder().encode(topScores) {
            UserDefaults.standard.set(encoded, forKey: scoresKey)
        }
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
        if let encoded = try? JSONEncoder().encode(levelRecords) {
            UserDefaults.standard.set(encoded, forKey: levelsKey)
        }
        UserDefaults.standard.set(highScore, forKey: highScoreKey)
        UserDefaults.standard.set(selectedLevel.id, forKey: selectedLevelKey)
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: scoresKey),
           let decoded = try? JSONDecoder().decode([GameScore].self, from: data) {
            topScores = decoded
        }

        highScore = max(
            UserDefaults.standard.integer(forKey: highScoreKey),
            topScores.first?.score ?? 0
        )

        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(GameSettings.self, from: data) {
            settings = decoded
        }

        loadLevelRecords()

        let savedLevelID = UserDefaults.standard.integer(forKey: selectedLevelKey)
        if savedLevelID > 0, record(for: savedLevelID).isUnlocked {
            selectedLevel = GameLevel.level(id: savedLevelID)
        }

        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            loadDefaultAchievements()
        }

        checkAchievements()
    }

    private func loadLevelRecords() {
        if let data = UserDefaults.standard.data(forKey: levelsKey),
           let decoded = try? JSONDecoder().decode([LevelRecord].self, from: data) {
            levelRecords = mergeLevelRecords(with: decoded)
        } else {
            levelRecords = defaultLevelRecords()
        }
        applyTestUnlocksIfNeeded()
    }

    private func applyTestUnlocksIfNeeded() {
        guard DebugConfig.unlockAllLevels else { return }
        for index in levelRecords.indices {
            levelRecords[index].isUnlocked = true
        }
    }

    private func mergeLevelRecords(with saved: [LevelRecord]) -> [LevelRecord] {
        GameLevel.all.map { level in
            saved.first { $0.levelID == level.id }
                ?? LevelRecord(levelID: level.id, isUnlocked: level.id == 1, isCompleted: false, bestScore: 0)
        }
    }

    private func defaultLevelRecords() -> [LevelRecord] {
        GameLevel.all.map { level in
            LevelRecord(levelID: level.id, isUnlocked: level.id == 1, isCompleted: false, bestScore: 0)
        }
    }

    private func loadDefaultAchievements() {
        achievements = [
            Achievement(id: UUID(), name: "First Points", description: "Score 10 points", requiredScore: 10, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), name: "Beginner", description: "Score 50 points", requiredScore: 50, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), name: "Pro", description: "Score 100 points", requiredScore: 100, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), name: "Master", description: "Score 200 points", requiredScore: 200, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), name: "Legend", description: "Score 500 points", requiredScore: 500, isUnlocked: false, unlockedDate: nil)
        ]
        saveData()
    }
}
