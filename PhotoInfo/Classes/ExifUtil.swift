//
//  ExifUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/12/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit


class ExifUtil {
  
  static func interpret(key:String, value:String) -> (key:String, value:String) {
    var newValue = value
    
    switch (key) {
    case "FNumber":
      newValue = "f/\(value)"
      
    case "FocalLength":
      newValue = "\(value)mm"
      
    case "ExposureTime":
      let floatValue = (value as NSString).floatValue
      let molecule = String(format: "%.0f", 1 / floatValue)
      newValue = floatValue >= 1 ? "\(floatValue)" : "1/\(molecule)"
      
    case "Orientation":
      
      let dic = ["1":"Horizontal (normal)".toGrobal(),
                 "2":"Mirror horizontal".toGrobal(),
                 "3":"Rotate 180".toGrobal(),
                 "4":"Mirror vertical".toGrobal(),
                 "5":"Mirror horizontal and rotate 270 CW".toGrobal(),
                 "6":"Rotate 90 CW".toGrobal(),
                 "7":"Mirror horizontal and rotate 90 CW".toGrobal(),
                 "8":"Rotate 270 CW".toGrobal()]
      newValue = dic[value] ?? value
      
    case "ColorSpace":
      let dic = ["1":"sRGB", "2":"Adobe RGB"]
      newValue = dic[value] ?? "Uncalibrated"
      
    case "ExposureBiasValue":
      newValue += " EV"
      
    case "ExposureMode":
      let dic = ["0":"Auto Exposure".toGrobal(),
                 "1":"Manual Exposure".toGrobal(),
                 "2":"Auto Bracket".toGrobal()]
      newValue = dic[value] ?? "Uncalibrated"
      
    case "WhiteBalance":
      let dic = ["0":"Auto".toGrobal(),
                 "1":"Manual".toGrobal()]
      newValue = dic[value] ?? value
      
    case "ExposureProgram":
      let dic = ["0":"Not defined".toGrobal(),
                 "1":"Manual".toGrobal(),
                 "2":"Normal program".toGrobal(),
                 "3":"Aperture priority".toGrobal(),
                 "4":"Shutter priority".toGrobal(),
                 "5":"Creative program".toGrobal(),
                 "6":"Action program".toGrobal(),
                 "7":"Portrait mode".toGrobal(),
                 "8":"Landscape mode".toGrobal()]
      newValue = dic[value] ?? value
      
    case "Flash":
      let dic = ["0":"Flash did not fire".toGrobal(),
                 "1":"Flash fired".toGrobal(),
                 "5":"Strobe return light not detected".toGrobal(),
                 "7":"Strobe return light detected".toGrobal(),
                 "9":"Flash fired, compulsory flash mode".toGrobal(),
                "13":"Flash fired, compulsory flash mode, return light not detected".toGrobal(),
                "15":"Flash fired, compulsory flash mode, return light detected".toGrobal(),
                "16":"Flash did not fire, compulsory flash mode".toGrobal(),
                "24":"Flash did not fire, auto mode".toGrobal(),
                "25":"Flash fired, auto mode".toGrobal(),
                "29":"Flash fired, auto mode, return light not detected".toGrobal(),
                "31":"Flash fired, auto mode, return light detected".toGrobal(),
                "32":"No flash function".toGrobal(),
                "65":"Flash fired, red-eye reduction mode".toGrobal(),
                "69":"Flash fired, red-eye reduction mode, return light not detected".toGrobal(),
                "71":"Flash fired, red-eye reduction mode, return light detected".toGrobal(),
                "73":"Flash fired, compulsory flash mode, red-eye reduction mode".toGrobal(),
                "77":"Flash fired, compulsory flash mode, red-eye reduction mode, return light not detected".toGrobal(),
                "79":"Flash fired, compulsory flash mode, red-eye reduction mode, return light detected".toGrobal(),
                "89":"Flash fired, auto mode, red-eye reduction mode".toGrobal(),
                "93":"Flash fired, auto mode, return light not detected, red-eye reduction mode".toGrobal(),
                "95":"Flash fired, auto mode, return light detected, red-eye reduction mode".toGrobal()]
      newValue = dic[value] ?? value
      
    case "MeteringMode":
      let dic = ["0":"Unknown".toGrobal(),
                 "1":"Average".toGrobal(),
                 "2":"CenterWeightedAverage".toGrobal(),
                 "3":"Spot".toGrobal(),
                 "4":"MultiSpot".toGrobal(),
                 "5":"Pattern".toGrobal(),
                 "6":"Partial".toGrobal()]
      newValue = dic[value] ?? value
      
    case "SceneCaptureType":
      let dic = ["0":"Standard".toGrobal(),
                 "1":"Landscape".toGrobal(),
                 "2":"Portrait".toGrobal(),
                 "3":"Night scene".toGrobal()]
      newValue = dic[value] ?? value
      
    case "SensingMethod":
      let dic = ["1":"Not defined".toGrobal(),
                 "2":"One-chip color area sensor".toGrobal(),
                 "3":"Two-chip color area sensor".toGrobal(),
                 "4":"Three-chip color area sensor".toGrobal(),
                 "5":"Color sequential area sensor".toGrobal(),
                 "7":"Trilinear sensor".toGrobal(),
                 "8":"Color sequential linear sensor".toGrobal()]
      newValue = dic[value] ?? value
      
    case "SceneType":
      let dic = ["1":"Directly photographed".toGrobal()]
      newValue = dic[value] ?? value
      
    case "ResolutionUnit":
      let dic = ["1":"No absolute unit of measurement".toGrobal(),
                 "2":"Inch".toGrobal(),
                 "3":"Centimeter".toGrobal()]
      newValue = dic[value] ?? value
      
    case "AltitudeRef":
      let dic = ["0":"Above sea level".toGrobal(),
                 "1":"Below sea level".toGrobal()]
      newValue = dic[value] ?? value
      
    case "DateStamp":
      newValue = value.stringByReplacingOccurrencesOfString(":", withString: "/")
      
    case "DateTime":
      var time = value.componentsSeparatedByString(" ")
      newValue = time[0].stringByReplacingOccurrencesOfString(":", withString: "/")
      newValue += " " + time[1]
      
    case "LensSpecification":
      var spec = value.componentsSeparatedByString(",")
      newValue = spec[0] + "mm-" + spec[1] + "mm  f/" + spec[2] + "-f/" + spec[3]
      
    case "ComponentsConfiguration":
      let dic = ["0":"", "1":"Y", "2":"Cb", "3":"Cr", "4":"R", "5":"G", "6":"B"]
      let specs = value.componentsSeparatedByString(",")
      newValue = specs.reduce("") { $0 + dic[$1]! }
      
    case "ExifVersion":
      newValue = value.stringByReplacingOccurrencesOfString(",", withString: ".")
    default: break
    }
    
    return (key, value)
  }
}
