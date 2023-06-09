//
//  UserDefaultsExtension.swift
//  PaintHelper
//
//  Created by Omid Shojaeian Zanjani on 22/05/23.
//

import CoreGraphics
import Foundation
import SwiftUI


extension UserDefaults {
  var minPivot: CGFloat {
    get {
      if let pivot = object(forKey: Settings.minPivot.rawValue) as? Double {
        return pivot
      }
      return 0.5
    }
    set {
      set(newValue, forKey: Settings.minPivot.rawValue)
    }
  }

  var maxPivot: CGFloat {
    get {
      if let pivot = object(forKey: Settings.maxPivot.rawValue) as? Double {
        return pivot
      }
      return 0.55
    }
    set {
      set(newValue, forKey: Settings.maxPivot.rawValue)
    }
  }

  var minAdjust: CGFloat {
    get {
      if let adjust = object(forKey: Settings.minAdjust.rawValue) as? Double {
        return adjust
      }
      return 2.0
    }
    set {
      set(newValue, forKey: Settings.minAdjust.rawValue)
    }
  }

  var maxAdjust: CGFloat {
    get {
      if let adjust = object(forKey: Settings.maxAdjust.rawValue) as? Double {
        return adjust
      }
      return 2.1
    }
    set {
      set(newValue, forKey: Settings.maxAdjust.rawValue)
    }
  }

  var epsilon: CGFloat {
    get {
      if let epsilon = object(forKey: Settings.epsilon.rawValue) as? Double {
        return epsilon
      }
      return 0.001
    }
    set {
      set(newValue, forKey: Settings.epsilon.rawValue)
    }
  }

  var iouThresh: CGFloat {
    get {
      if let thresh = object(forKey: Settings.iouThresh.rawValue) as? Double {
        return thresh
      }
      return 0.85
    }
    set {
      set(newValue, forKey: Settings.iouThresh.rawValue)
    }
  }

  func delete(key: Settings) {
    removeObject(forKey: key.rawValue)
  }
}
