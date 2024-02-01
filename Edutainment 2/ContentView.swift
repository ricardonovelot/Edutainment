//
//  ContentView.swift
//  Edutainment 2
//
//  Created by Ricardo on 06/10/23.
//

/*
Edutainment App
 
 the user will choose the dificulty (max factor they are going to be answering)
 
 player should select the amount of questions they will be asked
 
 [>] Stepper to select the factor
 [>] Picker to selct the amount of questions
 [>] NavigationView for Title and simple estetics
 [] Need to create a way to store questions, *questions consist of a string(question) and an integer(correct answer)*, this means i need to create a new type,
 
 
 
 */


import SwiftUI

struct ContentView: View {
    
    // State variables for the app's functionality
    @State private var factor = 12 // Max multiplication factor
    @State private var selectedAmountOfQuestions = 3 // Number of questions
    @State private var settingsMode = true // Determines whether the settings or game view is shown
    @State private var userAnswer = "" // Stores user's answer
    @State private var score = 0 // User's score
    @State private var questionsAsked = 0 // Count of questions asked
    @State private var questionsResponded = 0 // Count of questions answered

    // Variables for handling alerts
    @State private var showAnswerAlert = false
    @State private var alertMessage = ""
    @State private var showQuitConfirmationAlert = false
    @State private var showfinishGameAlert = false
    @State private var finishAlertMessage = ""
    
    // Predefined set of question amounts
    let amountOfQuestions = [3, 5, 10]
    
    // Question struct to store each question and its correct answer
    struct Question {
        var question: String
        var correctAnswer: Int
    }
    
    // Current question being asked
    @State private var currentQuestion = Question(question: "", correctAnswer: 0)
    
    // The body of the ContentView
    var body: some View {
        if settingsMode {
            // Settings View
            NavigationStack {
                VStack {
                    Form {
                        // Section for selecting the amount of questions
                        Section("Amount of questions") {
                            Picker("Questions", selection: $selectedAmountOfQuestions) {
                                ForEach(amountOfQuestions, id: \.self) {
                                    Text("\($0)")
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        // Section for selecting the difficulty
                        Section("Difficulty") {
                            Stepper("\(factor)", value: $factor, in: 1...12)
                        }
                    }
                }
                .navigationTitle("Settings")
                .toolbar {
                    Button("Submit") {
                        NewQuestion()
                        startGame()
                    }
                }
            }
        } else {
            // Game View
            NavigationView {
                Form {
                    Section("How Much is \(currentQuestion.question)") {
                        TextField("Answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                    }
                }
                .onSubmit {
                    readAnswer()
                }
                .navigationTitle("Question \(questionsResponded)/\(selectedAmountOfQuestions):")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            quitConfirmation()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Home")
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Send") {
                            readAnswer()
                        }
                    }
                }
                // Alerts for answer feedback and game completion
                .alert("\(alertMessage)", isPresented: $showAnswerAlert) {
                    Button("OK", role: .cancel) {
                        if !showfinishGameAlert {
                            NewQuestion()
                        }
                    }
                } message: {
                    Text("\(currentQuestion.question) = \(currentQuestion.correctAnswer)")
                }
                .alert("\(finishAlertMessage)", isPresented: $showfinishGameAlert) {
                    Button("OK", role: .cancel) { restartGame() }
                } message: {
                    Text("Thanks for playing!")
                }
                .alert(isPresented: $showQuitConfirmationAlert) {
                    Alert(
                        title: Text("\(alertMessage)"),
                        message: Text("You will lose your progress"),
                        primaryButton: .default(Text("Confirm")) {
                            restartGame()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    func readAnswer(){
        // Logic to check the user's answer
        if Int(userAnswer) == currentQuestion.correctAnswer {
            score += 10
            alertMessage = "Your answer is Correct"
            showAnswerAlert = true
        } else {
            alertMessage = "Your answer is Wrong)"
            showAnswerAlert = true
        }
        questionsAsked += 1
        if questionsAsked == selectedAmountOfQuestions {
            finishGame()
        }
    }
    
    func NewQuestion(){
        // Logic to generate a new question
        let multiplier = Int.random(in: 2...10)
        let multiplicand = Int.random(in: 2...factor)
        currentQuestion = Question(question: "\(multiplier) x \(multiplicand)", correctAnswer: multiplier * multiplicand)
        userAnswer = ""
        questionsResponded += 1
    }
    
    func startGame(){
        // Logic to start the game
        settingsMode = false
    }
    
    func finishGame(){
        // Logic to finish the game and show results
        finishAlertMessage = "You scored \(score) pts"
        showfinishGameAlert = true
    }
    
    func quitConfirmation(){
        // Logic to confirm quitting the game
        alertMessage = "Are you sure you want to quit?"
        showQuitConfirmationAlert = true
    }
    
    func restartGame(){
        // Logic to restart the game
        score = 0
        questionsAsked = 0
        questionsResponded = 0
        settingsMode = true
    }
    
}

#Preview {
    ContentView()
}
