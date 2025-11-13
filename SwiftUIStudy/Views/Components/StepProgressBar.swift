//
//  StepProgressBar.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/9/25.
//

import SwiftUI

struct StepProgressBar: View {
    let totalSteps: Int
    let currentStep: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // 전체 라인
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 2)
                
                // 진행된 부분
                Capsule()
                    .fill(Color(hex: "#58C66F"))
                    .frame(width: progressWidth(totalWidth: geo.size.width) , height:2)
            }
            .overlay(stepCircles(totalWidth: geo.size.width))
        }
        .frame(height:30)
    }
    // MARK: - Helper: 각 스텝 표시
    func stepCircles(totalWidth: CGFloat) -> some View {
        HStack(spacing: 0){
            ForEach(1...totalSteps, id: \.self) { step in
                ZStack {
                    // 기본 점
                    Circle()
                        .fill(step <= currentStep ? Color(hex: "#58C66F") : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                    // 현재 단계 숫자 원
                    if step == currentStep {
                        Circle()
                            .stroke(Color(hex: "#58C66F"), lineWidth: 2)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(step)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#58C66F"))
                            )
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Helper: 진행 바 폭 계산
    func progressWidth(totalWidth: CGFloat) -> CGFloat {
        guard totalSteps > 1 else { return 0 }
        return totalWidth * CGFloat(currentStep - 1) / CGFloat(totalSteps - 1)
    }
}

#Preview {
    VStack(spacing: 50) {
        StepProgressBar(totalSteps: 3, currentStep: 1)
        StepProgressBar(totalSteps: 3, currentStep: 2)
        StepProgressBar(totalSteps: 3, currentStep: 3)
    }
}
