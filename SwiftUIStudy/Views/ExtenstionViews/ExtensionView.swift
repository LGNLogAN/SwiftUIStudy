//
//  FontExtensionView.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/6/25.
//

import SwiftUI

struct ExtensionView: View {
    var body: some View {
        VStack(spacing:10){
            Text("Font Extension Example")
                .font(.pre(.bold, size:24))
            
            Text("Font 확장자 1번(순정)")
                .font(.custom("Pretendard-Thin", size:20))
            
            Text("Font 확장자 2번")
                .font(.pretendardBold14)
            
            Text("Font 확장자 3-1번")
                .font(.pre(.bold , size:16))
            
            Text("Font 확장자 3-2번")
                .font(.pre(.custom("Pretendard-ExtraBold"), size :18))
            
            Divider()
            
            Text("Color Extension Example")
                .font(.pre(.bold, size:24))
            
            Text("Color 확장자 1번")
                .font(.pretendardBold14)
                .foregroundColor(Color.red)
            
            Text("Color 확장자 2번")
                .font(.pre(.bold , size:16))
                .foregroundColor(Color(hex:"#999999"))
            
            Spacer()
        }.padding(.vertical,20)
    }
}

#Preview {
    ExtensionView()
}
