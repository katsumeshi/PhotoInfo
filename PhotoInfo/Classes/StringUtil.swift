//
//  StringUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/14/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Foundation

extension String {
  func toGrobal() -> String {
    return NSLocalizedString(self, comment: "")
  }
  
  @nonobjc static let empty = ""
}