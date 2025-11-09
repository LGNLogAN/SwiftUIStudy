//
//  Ex+ Color.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/6/25.
//

/*
    SwiftUI 에서는 헥사(hex)코드로 색을 지정하는게 불편하다.
    Asset 에 등록하는 방식으로 가능하지만 색 변수를 계속 생성해줘야하는 불편함이 있다.
    
    그래서 Color 확장을 통해 보다 편하게 색을 지정하는 방법이 있다.
 
 */
// Color 확장자는 기본적으로 SwiftUI를 임포트 해줘야한다.

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
