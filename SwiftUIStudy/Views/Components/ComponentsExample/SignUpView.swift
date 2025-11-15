//
//  SignUpView.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/13/25.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @State private var currentStep: Int = 1
    
    // Step 1 : 사용자 정보
    @State private var userName: String = ""
    @State private var profileImageData: Data?
    
    // Step 2 : 전화번호 정보
    @State private var phoneNumber: String = ""
    @State private var authenticationCode: Int = 0
    
    // Step 3 : 약관 동의
    @State private var agreeTerms: Bool = false
    @State private var agreePrivacy: Bool = false
    @State private var agreeLocation: Bool = false
    @State private var agreeMarketing: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 3, currentStep: currentStep)
                .padding(.top,20)
                .padding(.bottom,10)
            
            ZStack {
                if currentStep == 1 {
                    UserInfoFieldView(onNext: {name , imageData in
                        userName = name
                        profileImageData = imageData
                        withAnimation {
                            currentStep = 2
                        }
                    })
                } else if currentStep == 2 {
                    PhoneInfoFieldView(onNext: {phoneNumber in
                        self.phoneNumber = phoneNumber
                        withAnimation {
                            currentStep = 3
                        }
                    })
                } else if currentStep == 3 {
                    AgreementView(onComplete: { terms, privacy, location, marketing in
                        agreeTerms = terms
                        agreePrivacy = privacy
                        agreeLocation = location
                        agreeMarketing = marketing
                    })
                }
            }
        }
    }
}

// MARK: - Step 1 [ 기본 정보 입력 뷰 ]
struct UserInfoFieldView: View {
    @State private var nickName: String = ""
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var profileImageData: Data?
    
    let onNext: (String , Data?) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                HStack(spacing:0) {
                    Text("프로필 사진")
                        .foregroundColor(Color(hex: "#2DC45B"))
                    Text("과 ")
                    Text("닉네임")
                        .foregroundColor(Color(hex: "#2DC45B"))
                    Text("을 알려주세요")
                }
                .font(.pre(.bold , size: 24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                Text("사용자들 사이에서 회원님을 확인 할 수 있어요")
                    .font(.pre(.medium , size: 14))
                    .foregroundColor(Color(hex:"#999999"))
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // MARK: - PhotoPicker 를 사용한 이미지 선택 버튼
            VStack(spacing: 0) {
                PhotosPicker(selection: $selectedImage , matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        if let imageData = profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray.opacity(0.5))
                                )
                        }
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            )
                            .offset(x: 6, y: 6)
                        
                        
                    }.frame(width: 130, height: 130)
                }
                .onChange(of: selectedImage) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            profileImageData = data
                        }
                    }
                }
            }
            
            
            // MARK: - 유저 이름 입력받기
            TextField("사용하실 닉네임을 입력해주세요 !" , text: $nickName)
                .font(.pre(.medium , size:16))
                .padding()
                .background(Color(hex: "#F5F5F5"))
                .cornerRadius(12)
            
            Spacer()
            
            // MARK: - 폼 전송
            Button(action: {
                onNext(nickName, profileImageData)
            }) {
                Text("다음")
                    .font(.pre(.bold,size:17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isFormValid ? Color(hex: "#7EC491") : Color.gray.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)
            .padding(.bottom, 20)
            
            
        }.padding(.horizontal,24)
    }
    
    // MARK: - 폼 유효성 검사
    private var isFormValid: Bool {
        !nickName.isEmpty &&
        profileImageData != nil &&
        (2...8).contains(nickName.count) // 닉네임이 2~8자 사이
    }

}


// MARK: - Step 2 [ 휴대폰 번호 입력 뷰 ]
struct PhoneInfoFieldView: View {
    @State private var phoneNumber:String = ""
    @State private var isValidPhoneNumber:Bool = false
    @FocusState private var isPhoneNumberFieldFocus:Bool
    let onNext: (String) -> Void
    func isValidPhoneNumber(_ input: String) -> Bool {
        let pattern = #"^010-\d{4}-\d{4}$"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: input.utf16.count)
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
    
    var body: some View {
        VStack(spacing: 30){
            VStack(spacing: 5) {
                HStack(spacing:0) {
                    Text("전화번호")
                        .foregroundColor(Color(hex: "#2DC45B"))
                    Text("를 입력해주세요 !")
                }
                .font(.pre(.bold , size: 24))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                Text("전화번호는 공개되지 않아요.")
                    .font(.pre(.medium , size: 14))
                    .foregroundColor(Color(hex:"#999999"))
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            // MARK: - 휴대폰 번호 입력
            HStack(spacing: 10) {
                TextField("휴대폰 번호" , text:$phoneNumber)
                    .font(.pre(.semibold,size:20))
                    .keyboardType(.numberPad)
                    .onChange(of: self.phoneNumber) { _, newValue in
                        let digits = newValue.filter { $0.isNumber }
                        let limitedDigits = String(digits.prefix(11))
                        
                        var formatted = ""
                        if limitedDigits.count <= 3 {
                            formatted = limitedDigits
                        } else if limitedDigits.count <= 7 {
                            let prefix = limitedDigits.prefix(3)
                            let mid = limitedDigits.suffix(limitedDigits.count - 3)
                            formatted = "\(prefix)-\(mid)"
                        } else {
                            let prefix = limitedDigits.prefix(3)
                            let mid = limitedDigits.dropFirst(3).prefix(4)
                            let suf = limitedDigits.suffix(limitedDigits.count - 7)
                            formatted = "\(prefix)-\(mid)-\(suf)"
                        }
                        
                        self.phoneNumber = formatted
                        isValidPhoneNumber = isValidPhoneNumber(phoneNumber)
                    }


                Button(action: {
                    phoneNumber = ""
                    isValidPhoneNumber = false
                }){
                    Image(systemName: "xmark")
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
            }
            
            Spacer()
            // MARK: - 폼 전송
            Button(action: {
                onNext(phoneNumber)
            }) {
                Text("다음")
                    .font(.pre(.bold,size:17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isFormValid ? Color(hex: "#7EC491") : Color.gray.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)
            .padding(.bottom, 20)
            
        }.padding(.horizontal,24)
    }
    private var isFormValid: Bool {
        !phoneNumber.isEmpty && isValidPhoneNumber
    }
}


// MARK: - Step 3 [ 약관 동의 뷰 ]
enum AgreementType: String {
    case terms = "서비스 이용약관"
    case privacy = "개인정보 처리방침"
    case location = "위치정보 이용약관"
    case marketing = "마케팅 정보 수신 동의"
}

struct AgreementView: View {
    @State private var agreeAll: Bool = false
    @State private var agreeTerms: Bool = false
    @State private var agreePrivacy: Bool = false
    @State private var agreeLocation: Bool = false
    @State private var agreeMarketing: Bool = false
    @State private var showDetailSheet: Bool = false
    @State private var selectedAgreementType: AgreementType?

    let onComplete: (Bool, Bool, Bool, Bool) -> Void // agreeTerms, agreePrivacy, agreeLocation, agreeMarketing

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    // 제목
                    VStack(alignment: .center, spacing: 8) {
                        HStack(spacing:0) {
                            Text("약관")
                                .font(.pre(.bold,size:24))
                                .foregroundColor(Color(hex: "#2DC45B"))
                            Text("에 동의해주세요")
                                .font(.pre(.bold,size:24))
                                .foregroundColor(.black)
                        }
                        Text("리폼 서비스 이용을 위한 필수 약관입니다")
                            .font(.pretendardRegular14)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)

                    // 전체 동의
                    Button(action: {
                        agreeAll.toggle()
                        agreeTerms = agreeAll
                        agreePrivacy = agreeAll
                        agreeLocation = agreeAll
                        agreeMarketing = agreeAll
                    }) {
                        HStack(spacing:12){
                            Image(systemName: "checkmark").font(.system(size: 16, weight: .semibold))
                            Text("서비스 이용약관 전체동의")
                                .font(.pre(.semibold,size:16))
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(agreeAll ? Color.green : Color(red: 0.8, green: 0.8, blue: 0.8))
                        )
                        .foregroundColor(agreeAll ? Color.black : Color(red: 0.8, green: 0.8, blue: 0.8))
                    }
                    .padding(.bottom, 12)

                    // 개별 약관들
                    VStack(spacing: 16) {
                        // 서비스 이용약관 (필수)
                        AgreementRow(
                            isChecked: $agreeTerms,
                            title: "[필수] 서비스 이용약관",
                            hasDetail: true,
                            onDetail: {
                                selectedAgreementType = .terms
                                showDetailSheet = true
                            }
                        )

                        // 개인정보 처리방침 (필수)
                        AgreementRow(
                            isChecked: $agreePrivacy,
                            title: "[필수] 개인정보 처리방침",
                            hasDetail: true,
                            onDetail: {
                                selectedAgreementType = .privacy
                                showDetailSheet = true
                            }
                        )

                        // 위치정보 이용약관 (필수)
                        AgreementRow(
                            isChecked: $agreeLocation,
                            title: "[필수] 위치정보 이용약관",
                            hasDetail: true,
                            onDetail: {
                                selectedAgreementType = .location
                                showDetailSheet = true
                            }
                        )

                        // 마케팅 정보 수신 (선택)
                        AgreementRow(
                            isChecked: $agreeMarketing,
                            title: "[선택] 마케팅 정보 수신 동의",
                            hasDetail: true,
                            onDetail: {
                                selectedAgreementType = .marketing
                                showDetailSheet = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }

            Spacer()

            // 버튼들
            VStack(spacing: 12) {
                Button(action: {
                    onComplete(agreeTerms, agreePrivacy, agreeLocation, agreeMarketing)
                }) {
                    Text("완료")
                        .font(.pre(.semibold,size:16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isFormValid ? Color(hex: "#7EC491") : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)

            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showDetailSheet) {
            if let agreementType = selectedAgreementType {
                AgreementDetailView(agreementType: agreementType)
            }
        }
        .onChange(of: [agreeTerms, agreePrivacy, agreeLocation, agreeMarketing]) { _ in
            // 모든 항목이 체크되면 전체 동의도 체크
            agreeAll = agreeTerms && agreePrivacy && agreeLocation && agreeMarketing
        }
    }

    // MARK: - 폼 유효성 검사
    private var isFormValid: Bool {
        agreeTerms && agreePrivacy && agreeLocation
    }
}

// MARK: - 약관 항목 행
struct AgreementRow: View {
    @Binding var isChecked: Bool
    let title: String
    let hasDetail: Bool
    var onDetail: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isChecked ? Color(hex: "#7EC491") : Color.gray.opacity(0.3))
            }

            Text(title)
                .font(.pretendardRegular14)
                .foregroundColor(.black)

            Spacer()

            if hasDetail {
                Button(action: {
                    onDetail?()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 약관 상세 뷰
struct AgreementDetailView: View {
    let agreementType: AgreementType
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(getAgreementContent())
                        .font(.pretendardRegular14)
                        .foregroundColor(.black)
                        .lineSpacing(6)
                }
                .padding(24)
            }
            .navigationTitle(agreementType.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }

    private func getAgreementContent() -> String {
        switch agreementType {
        case .terms:
            return """
            제1조 (목적)
            본 약관은 리폼 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

            제2조 (용어의 정의)
            본 약관에서 사용하는 용어의 정의는 다음과 같습니다.
            1. "서비스"란 회사가 제공하는 모든 서비스를 의미합니다.
            2. "회원"이란 본 약관에 동의하고 서비스를 이용하는 자를 말합니다.

            제3조 (약관의 효력 및 변경)
            본 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 그 효력을 발생합니다.

            [약관 내용은 여기에 추가됩니다]
            """
        case .privacy:
            return """
            개인정보 처리방침

            리폼은 회원의 개인정보를 소중히 다루며, 개인정보 보호법 등 관련 법령을 준수합니다.

            1. 수집하는 개인정보의 항목
            - 필수항목: 이름, 이메일, 주소
            - 선택항목: 프로필 사진

            2. 개인정보의 수집 및 이용 목적
            - 회원 가입 및 관리
            - 서비스 제공 및 개선

            [개인정보 처리방침 내용은 여기에 추가됩니다]
            """
        case .location:
            return """
            위치정보 이용약관

            제1조 (목적)
            본 약관은 리폼이 제공하는 위치기반서비스와 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

            제2조 (서비스 내용)
            회사는 위치정보를 활용하여 다음과 같은 서비스를 제공합니다.
            - 주변 리폼 아이디어 추천
            - 지역 기반 커뮤니티 서비스

            [위치정보 이용약관 내용은 여기에 추가됩니다]
            """
        case .marketing:
            return """
            마케팅 정보 수신 동의

            리폼의 다양한 소식과 혜택 정보를 받아보실 수 있습니다.

            1. 수신 정보의 종류
            - 신규 서비스 안내
            - 이벤트 및 프로모션 정보
            - 맞춤형 콘텐츠 추천

            2. 수신 방법
            - 이메일
            - 앱 푸시 알림

            ※ 마케팅 정보 수신은 선택사항이며, 동의하지 않아도 서비스 이용이 가능합니다.

            [마케팅 정보 수신 동의 내용은 여기에 추가됩니다]
            """
        }
    }
}

#Preview {
    SignUpView()
}
