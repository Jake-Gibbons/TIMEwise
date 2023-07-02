import SwiftUI
import UserNotifications

struct CountdownTimerView: View {
    var guests: [String]
    var ghbAmounts: [String: String]

    @StateObject private var appState = AppState()

    @State private var hostNamePassed = UserDefaults.standard.string(forKey: "UserName")
    @State private var timerValues: [String: Int] = [:]
    @State private var progressValues: [String: Double] = [:]
    @State private var isTimerRunning: [String: Bool] = [:]

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
                List {
                    Section(header: Text("Host Timer")) {
                        timerRow(with: hostNamePassed ?? "Host Timer")
                    }
                    
                    Section(header: Text("Guest Timers")) {
                        ForEach(guests, id: \.self) { guest in
                            timerRow(with: guest)
                        }
                    }
                }
                
            }
        .navigationTitle(Text("Guest Timers"))
        .navigationBarItems(trailing:
                                Button(action: {
            // Info button action
        }) {
            Image(systemName: "info.circle")
        })
            .onAppear {
            restoreTimerState()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                saveTimerState()
            }
        }
    }

    private func timerRow(with name: String) -> some View {
        let timerValue = timerValues[name] ?? 60 * 60
        let progressValue = progressValues[name] ?? 0.0
        let ghbAmount = ghbAmounts[name] ?? ""

        return VStack {
            HStack {
                Circle()
                    .foregroundColor(getCircleColor(for: timerValue))
                    .modifier(PulsingAnimationModifier())
                    .frame(width: 20, height: 20)
                    .padding(.trailing)

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .padding(.bottom, 7)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("GHB: \(ghbAmount) ml")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                VStack {
                    Text(timeString(time: timerValue))
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(getTextColor(for: timerValue))

                    Button(action: {
                        toggleTimer(for: name)
                    }) {
                        HStack {
                            Image(systemName: isTimerRunning[name] == true ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                                .font(.caption)
                            Text(isTimerRunning[name] == true ? "PAUSE" : "START")
                                .font(.caption2)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .background(isTimerRunning[name] == true ? Color.gray.opacity(0.5) : Color.accentColor)
                    .disabled(isTimerRunning[name] == true)
                }
            }

            // Linear progress bar
            ProgressView(value: progressValue, total: 60 * 60)
                .progressViewStyle(LinearProgressViewStyle())
        }
        .onAppear {
            timerValues[name] = 60 * 60
        }
    }

    private func toggleTimer(for name: String) {
        if isTimerRunning[name] == true {
            pauseTimer(for: name)
        } else {
            startTimer(for: name)
        }
    }

    private func pauseTimer(for name: String) {
        isTimerRunning[name] = false
    }

    private func startTimer(for name: String) {
        guard let currentTimerValue = timerValues[name] else { return }
        
        // Calculate end time as one hour from the current time
        let currentTime = Date()
        let endTime = currentTime.addingTimeInterval(TimeInterval(currentTimerValue))
        
        // Update timerValues dictionary with the new end time
        timerValues[name] = Int(endTime.timeIntervalSince(currentTime))
        
        // Create a timer to update the timer value every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let isRunning = isTimerRunning[name], isRunning == false {
                timer.invalidate()
                return
            }
            
            // Calculate the time remaining based on the stored end time and the current time
            let timeRemaining = Int(endTime.timeIntervalSince(Date()))
            
            // Update the timerValues dictionary with the new time remaining
            timerValues[name] = timeRemaining
            
            // Check if the timer has reached zero
            if timeRemaining <= 0 {
                timer.invalidate()
                // Schedule a notification for timer completion if needed
                scheduleNotification(for: name)
            }
        }
        
    }
    private func saveTimerState() {
        UserDefaults.standard.set(timerValues, forKey: "timerValues")
        UserDefaults.standard.set(progressValues, forKey: "progressValues")
        UserDefaults.standard.set(isTimerRunning, forKey: "isTimerRunning")
    }

    private func restoreTimerState() {
        if let savedTimerValues = UserDefaults.standard.dictionary(forKey: "timerValues") as? [String: Int] {
            timerValues = savedTimerValues
        }

        if let savedProgressValues = UserDefaults.standard.dictionary(forKey: "progressValues") as? [String: Double] {
            progressValues = savedProgressValues
        }

        if let savedIsTimerRunning = UserDefaults.standard.dictionary(forKey: "isTimerRunning") as? [String: Bool] {
            isTimerRunning = savedIsTimerRunning
        }
    }

    private func getCircleColor(for timerValue: Int) -> Color {
        if timerValue <= 5 * 60 {
            return .green
        } else if timerValue <= 10 * 60 {
            return .orange
        } else {
            return .red
        }
    }

    private func getTextColor(for timerValue: Int) -> Color {
        if timerValue <= 5 * 60 {
            return .green
        } else if timerValue <= 10 * 60 {
            return .orange
        } else {
            return .red
        }
    }

    private func timeString(time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = (time % 3600) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    private func scheduleNotification(for name: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Timer Reached Zero"
        notificationContent.body = "\(name)'s timer has reached zero."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerReachedZero", content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}

struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerView(guests: ["Guest 1", "Guest 2"], ghbAmounts: ["Guest 1": "1.4", "Guest 2": "2.0"])
    }
}

struct PulsingAnimationModifier: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? 0.2 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                    isPulsing.toggle()
                }
            }
    }
}

class AppState: ObservableObject {
    @Published var countdownTimerActive: Bool = false
    @Published var guests: [String] = []
    @Published var ghbAmounts: [String: String] = [:]
    // Add any other published properties or data that you need for your app
}