//
//  Contour.swift
//  PaintHelper
//
//  Created by Omid Shojaeian Zanjani on 22/05/23.
//

import Foundation

import Vision

struct Contour: Identifiable, Hashable {
  let id = UUID()
  let area: Double
  private let vnContour: VNContour

  init(vnContour: VNContour) {
    self.vnContour = vnContour
    self.area = vnContour.boundingBox.area
  }

  var normalizedPath: CGPath {
    self.vnContour.normalizedPath
  }

  var aspectRatio: CGFloat {
    CGFloat(self.vnContour.aspectRatio)
  }

  var boundingBox: CGRect {
    self.vnContour.boundingBox
  }

  func intersectionOverUnion(with contour: Contour) -> CGFloat {
    let intersection = boundingBox.intersection(contour.boundingBox).area
    let union = area + contour.area - intersection
    return intersection / union
  }
}
