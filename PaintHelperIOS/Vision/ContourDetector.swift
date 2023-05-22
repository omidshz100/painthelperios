//
//  ContourDetector.swift
//  PaintHelper
//
//  Created by Omid Shojaeian Zanjani on 22/05/23.
//
//
import Foundation
import Vision

class ContourDetector {
  static let shared = ContourDetector()
  private var epsilon: Float = 0.001

  
  private lazy var request: VNDetectContoursRequest = {
    let req = VNDetectContoursRequest()
    return req
  }()

  
  private init() {}
  
  private func perform(request: VNRequest,
                       on image: CGImage) throws -> VNRequest {
    // 1
    let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
    
    // 2
    try requestHandler.perform([request])
    
    // 3
    return request
  }

  private func postProcess(request: VNRequest) -> [Contour] {
    // 1
    guard let results = request.results as? [VNContoursObservation] else {
      return []
    }
      
    // 2
    let vnContours = results.flatMap { contour in
      (0..<contour.contourCount).compactMap { try? contour.contour(at: $0) }
    }
        
    // 3
    let simplifiedContours = vnContours.compactMap {
      try? $0.polygonApproximation(epsilon: self.epsilon)
    }
            
    return simplifiedContours.map { Contour(vnContour: $0) }

  }

  func process(image: CGImage?) throws -> [Contour] {
    guard let image = image else {
      return []
    }
      
    let contourRequest = try perform(request: request, on: image)
    return postProcess(request: contourRequest)
  }

  func set(contrastPivot: CGFloat?) {
    request.contrastPivot = contrastPivot.map {
      NSNumber(value: $0)
    }
  }

  func set(contrastAdjustment: CGFloat) {
    request.contrastAdjustment = Float(contrastAdjustment)
  }

  func set(epsilon: CGFloat) {
    self.epsilon = Float(epsilon)
  }

}
