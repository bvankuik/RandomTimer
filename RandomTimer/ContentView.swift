//
//  ContentView.swift
//  RandomTimer
//
//  Created by Bart van Kuik on 13/02/2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    private static let offTimer = Timer.TimerPublisher(interval: 0, runLoop: .main, mode: .default)
    private static let countdownMax = 3
    
    @State private var number: Int?
    @State private var done: [Int] = []
    @AppStorage("startRange") private var startRange = 1
    @AppStorage("endRange") private var endRange = 30
    @State private var timer = Self.offTimer
    @State private var cancellable: AnyCancellable?
    @State private var countdown = 0
    
    var body: some View {
        VStack {
            HStack {
                TextField("Start of range", text: self.makeIntBinding(to: self.$startRange))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Stepper(value: self.$startRange, label: {})
            }
            HStack {
                TextField("End of range", text: self.makeIntBinding(to: self.$endRange))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Stepper(value: self.$endRange, label: {})
            }
            Spacer()
            Text("888").font(Font.system(size: 120)).opacity(0).accessibility(hidden: true) // For sizing purposes
                .overlay(self.randomNumberLabel())
                .overlay(self.countdownLabel())
            Spacer()
            Button(action: buttonAction) {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(UIColor.secondarySystemFill))
                    .frame(maxHeight: 120)
                    .overlay(Text("New Number").font(.title).foregroundColor(.primary))
            }
        }
        .padding(50)
        .onReceive(self.timer, perform: timerAction)
    }
    
    @ViewBuilder private func countdownLabel() -> some View {
        if self.countdown == 0 {
            EmptyView()
        } else {
            Text("\(self.countdown)").font(Font.system(size: 60))
                .frame(width: 80, height: 80)
                .background(Circle().fill(Color.gray))
        }
    }
    
    @ViewBuilder private func randomNumberLabel() -> some View {
        if let number = self.number, self.countdown == 0 {
            Text("\(number)").font(Font.system(size: 120))
        } else {
            EmptyView()
        }
    }
    
    private func buttonAction() {
        self.number = nil
        self.countdown = Self.countdownMax
        let timer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
        self.cancellable = timer.connect() as? AnyCancellable
        self.timer = timer
    }
    
    private func timerAction(_ date: Date) {
        if self.countdown > 0 {
            self.countdown -= 1
        } else {
            if let number = self.number {
                self.done.append(number)
            }
            self.number = self.newRandomNumber()
            self.cancellable?.cancel()
            self.timer = Self.offTimer
        }
    }
    
    private func makeIntBinding(to intState: Binding<Int>) -> Binding<String> {
        Binding<String>(
            get: {
                return String(describing: intState.wrappedValue)
            },
            set: { newValue in
                if let newInt = Int(newValue) {
                    intState.wrappedValue = newInt
                }
            }
        )
    }

    private func newRandomNumber() -> Int {
        var new = 0
        while new == 0 {
            if let randomElement = (1 ... 10).randomElement() {
                new = randomElement
            }
        }
        return new
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
