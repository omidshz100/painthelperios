//
//  ContentViewModel.swift
//  PaintHelper
//
//  Created by Omid Shojaeian Zanjani on 22/05/23.
//

import Foundation
// https://www.kodeco.com/32611432-vision-framework-tutorial-for-ios-contour-detection
import Vision
import SwiftUI
import UIKit


class ContentViewModel: ObservableObject {
  @Published var image: CGImage?
  @Published var contours: [Contour] = []
  @Published var calculating = false

  init() {
    let uiImage = UIImage(named: "sample")
    let cgImage = uiImage?.cgImage
    self.image = cgImage
    updateContours()

  }

  func updateContours() {
    // 1
    guard !calculating else { return }
    calculating = true
    
    // 2
    Task {
      // 3
      let contours = await asyncUpdateContours()
      
      // 4
      DispatchQueue.main.async {
        self.contours = contours
        self.calculating = false
      }
    }
  }

  
  func asyncUpdateContours() async -> [Contour] {
    // 1
    var contours: [Contour] = []

    // 2
    let pivotStride = stride(
      from: UserDefaults.standard.minPivot,
      to: UserDefaults.standard.maxPivot,
      by: 0.1)
    let adjustStride = stride(
      from: UserDefaults.standard.minAdjust,
      to: UserDefaults.standard.maxAdjust,
      by: 0.2)

    // 3
    let detector = ContourDetector.shared
    detector.set(epsilon: UserDefaults.standard.epsilon)

    // 4
    for pivot in pivotStride {
      for adjustment in adjustStride {
        
        // 5
        detector.set(contrastPivot: pivot)
        detector.set(contrastAdjustment: adjustment)
        
        // 6
        let newContours = (try? detector.process(image: self.image)) ?? []
        
        // 7
        contours.append(contentsOf: newContours)
      }
    }

    // 1
    if contours.count < 9000 {
      // 2
      let iouThreshold = UserDefaults.standard.iouThresh
      
      // 3
      var pos = 0
      while pos < contours.count {
        // 4
        let contour = contours[pos]
        // 5
        contours = contours[0...pos] + contours[(pos+1)...].filter {
          contour.intersectionOverUnion(with: $0) < iouThreshold
        }
        // 6
        pos += 1
      }
    }

    // 8
    return contours

  }

}
