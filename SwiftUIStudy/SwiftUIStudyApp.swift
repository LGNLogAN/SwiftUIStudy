//
//  SwiftUIStudyApp.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/9/25.
//

import SwiftUI

@main
struct SwiftUIStudyApp: App {
    
    // Config 파일로 서버의 URL 과 API KEY 를 관리하고 사용
    // SwiftUIStudy 프로젝트 클릭 후 Info -> Configurations -> Debug -> Config.xcconfig 선택
    
    // 앱을 실행하면 가장 먼저 빌드되는 최상위 파일
    init() {
        // Config 파일에 있는 서버 주소 , Info 파일에 등록해놓은 해당 변수
        let serverURL = (Bundle.main.infoDictionary?["ServerURL"] as? String) ?? ""

        // 서버 주소가 비어있으면 Guard문에서 처리
        guard !serverURL.isEmpty else {
            print("⚠️ [ Warning ] 서버 주소가 설정 되어 있지 않습니다.")
            return
        }

        BasicService.shared.getServerURL()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
