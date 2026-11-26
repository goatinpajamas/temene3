import TemeneCore

/// Demo set written for this prototype (not taken from past papers). Uses g = 10 m/s².
enum DemoQuestions {
    static let projectiles: [Question] = [
        Question(id: "phy-proj-1", subject: .physics, topic: "Projectile motion",
                 stem: "Same launch speed, no air. Which angle gives the longest range?",
                 options: ["30°", "45°", "60°", "75°"], answer: 1,
                 explanation: "Range = v² × sin 2θ ÷ g. It is largest when sin 2θ = 1, so 2θ = 90° and θ = 45°."),
        Question(id: "phy-proj-2", subject: .physics, topic: "Projectile motion",
                 stem: "A ball is thrown at 20 m/s at 30°. What is its vertical velocity at the highest point?",
                 options: ["0 m/s", "10 m/s", "17.3 m/s", "20 m/s"], answer: 0,
                 explanation: "At the top the ball stops rising, so the vertical velocity is 0. Only the horizontal part, 20 × cos 30° ≈ 17.3 m/s, remains."),
        Question(id: "phy-proj-3", subject: .physics, topic: "Projectile motion",
                 stem: "Same speed, launched once at 30° and once at 60°. Which lands farther?",
                 options: ["30°", "60°", "They land the same distance", "It depends on the mass"], answer: 2,
                 explanation: "sin 60° = sin 120°, so angles that add up to 90° give the same range. The 60° throw goes higher and stays up longer."),
        Question(id: "phy-proj-4", subject: .physics, topic: "Projectile motion",
                 stem: "A ball is launched at 20 m/s straight up (90°). How long is it in the air?",
                 options: ["2 s", "4 s", "1 s", "20 s"], answer: 1,
                 explanation: "Time up = v ÷ g = 20 ÷ 10 = 2 s. It takes the same time to come down, so 4 s in total."),
        Question(id: "phy-proj-5", subject: .physics, topic: "Projectile motion",
                 stem: "Ignoring air, what is the horizontal acceleration of a projectile?",
                 options: ["10 m/s² forward", "0 m/s²", "10 m/s² backward", "It changes during the flight"], answer: 1,
                 explanation: "Gravity acts only downward, so nothing speeds the ball up or slows it down sideways. Horizontal velocity stays constant."),
        Question(id: "phy-proj-6", subject: .physics, topic: "Projectile motion",
                 stem: "A ball is kicked at 20 m/s at 45°. About how far does it land? (sin 90° = 1)",
                 options: ["20 m", "40 m", "80 m", "400 m"], answer: 1,
                 explanation: "Range = v² × sin 2θ ÷ g = 400 × 1 ÷ 10 = 40 m."),
    ]
}
