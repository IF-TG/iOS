# 여가: 여행을 가다
// 목업파일같은거

## 프로젝트 소개 
> 먼저 다녀온 여행객의 여행 후기를 통해 여행 계획을 쉽게 세우고 여행 기록을 공유할 수 있는 서비스 입니다.



## 🧑🏻‍💻 팀 소개 

| BE: 임경완 | iOS: 양승현 | iOS: 김석현 | Design: 오수민
|:--------:|:--------:|:--------:|:--------:|
| <img src="https://avatars.githubusercontent.com/u/47065431?v=4" width="100" /> | <img src="https://avatars.githubusercontent.com/u/96910404?s=400&u=9e3d914e4168c78643e358115a0294669793ca99&v=4" width="100" /> | <img src="https://avatars.githubusercontent.com/u/108918481?v=4" width="100" /> | <img src="https://user-images.githubusercontent.com/96910404/236286254-671dd10b-9342-485b-9c75-799522175025.jpeg" width="100" /> |
[MoonDooo](https://github.com/MoonDooo) |[SHcommit](https://github.com/SHcommit) |[letusHyun](https://github.com/letusHyun) | OhSumin

## 🎯 동료와의 목표 
- UI 구현시 되도록 외부 라이브러리 사용하지 않기
- 기능 구현하다 막히거나 오류 해결이 어려운 경우 동료와 의논하며 해결하기
- 컨벤션 지키기
- PullRequest할 때, 자신이 구현한 기능 자세히 소개 및 새롭게 알게된 개념 소개 및 참고했던 포스트 링크 남기기
- etc...

## 개발 환경
- Minimum deployment target: **iOS 13.0**
- MVVM + Clean architecture
- Coordinator pattern
- etc...

## 사용 기술 및 라이브러리
### 1st party
- UIKit 
- AutoLayout
- Combine
- GCD
- XCTest
- Photos
- LinkPresentation
- NotificationCenter

### 3rd party
- Swinject
- Alamofire
- Firebase
- AppsFlyer
- Swiftlint
- Realm
- GoogleSignIn
- Snapkit

### Etc
- Figma
- SwiftPM
- Github project kanban

## Project Architecture
![image](https://github.com/user-attachments/assets/385d1aca-914c-4d78-b42f-ef6cead6fa76)

- MVVM Input/Output
| 선정 이유
- Clean Architecture
| 선정 이유 pros, cons 
- Coordinator
| 선정 이유 pros, cons 

## System Flow

 <img src="https://github.com/user-attachments/assets/b966127e-3344-4586-b1e6-7e1f4b1c5d96" height="350" />

## 어플리케이션 기능

로그인
피드
- e.g. 소팅, 카테고리, 페이징, 리프레싱
- e.g. 하트 등
피드 글쓰기 화면
- e.g. 글 추가(이미지 연속) and 이미지 + 글, (글 + 이미지인 경우, 첫 이미지 제거 후 작성, 개발하면서 고려했던 흐름들) 삭제,
- e.g. 카테고리 이동화면(카테고리 선택 화면 )

피드 상세화면
- 채팅 관련, 리프레시 , 편집등 동작되는 기능들
- 피드에서 글쓰기 화면 연동 등등.
알림
- 알림 동작에 관련된 모든 기능
검색
찜
설정

순서로 동작 구조 gif로 보여줍시당:) 한 라인에 4개씩!!

## 디렉터리 구조


## 기술적 도전

- 깃허브 위치로 링크 연동!!
