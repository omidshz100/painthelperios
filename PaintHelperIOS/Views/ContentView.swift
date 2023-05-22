//
//  ContentView.swift
//  PaintHelper
//
//  Created by Omid Shojaeian Zanjani on 22/05/23.
//
// https://www.kodeco.com/32611432-vision-framework-tutorial-for-ios-contour-detection
import SwiftUI

struct ContentView: View {
  @StateObject private var model = ContentViewModel()

  @State private var showContours = false
  @State private var showSettings = false

  private var message: String {
    if model.calculating {
      return "Calculating contours..."
    } else {
      return "Tap screen to toggle contours"
    }
  }

  var body: some View {
    ZStack {
      Color.white

      if showContours {
        ContoursView(contours: model.contours)
      } else {
        ImageView(image: model.image)
      }

      VStack {
        HStack {
          Spacer()

          Text(message)
            .foregroundColor(.black)
            .padding()

          Spacer()
        }

        Spacer()

        HStack {
          Spacer()

          Button(action: {
            self.showSettings.toggle()
          }, label: {
            Image(systemName: "gear")
              .padding()
          })
        }
      }
    }
    .onTapGesture {
      self.showContours.toggle()
    }
    .sheet(isPresented: $showSettings) {
      SettingsView()
        .onDisappear {
          model.updateContours()
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
