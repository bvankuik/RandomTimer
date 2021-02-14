//
//  ContentView.swift
//  RandomTimer
//
//  Created by Bart van Kuik on 13/02/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var number: Int = 0
    @State private var done: [Int] = []
    @AppStorage("startRange") private var startRange = 1
    @AppStorage("endRange") private var endRange = 30

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
            Text("\(number)").font(Font.system(size: 120))
            Spacer()
            Button(action: buttonAction) {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(UIColor.secondarySystemFill))
                    .frame(maxHeight: 120)
                    .overlay(Text("New Number").font(.title).foregroundColor(.primary))
            }
        }
        .padding(50)
    }
    
    private func buttonAction() {
        self.done.append(self.number)
        self.number = self.newRandomNumber()
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
