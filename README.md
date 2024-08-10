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
- 중복 코드를 줄이기. 객체와의 의존성은 줄이고 결합도는 높이는 객체 설계 및 구현하기
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

- Clean Architecture
> 선정 이유 pros, cons 
- Input/Output binding ( in MVVM )
> 선정 이유
- Coordinator
> 선정 이유 pros, cons 

## System Flow

 <img src="https://github.com/user-attachments/assets/a532fd5e-2fc2-4fec-a6fb-c101f9347419" height="450" />

## 어플리케이션 기능


### [ 로그인 화면 ]

| gif1 | ![구글+파이어스토어로긴](https://github.com/user-attachments/assets/d1528479-5804-4c5d-b78c-82c1e6f45997)  | gif3  | gif4  |
| :-:| :-: | :-: | :-: |
| `로그인 애니메이션` | `구글 로그인 연동` | `애플 로그인 연동` | `없을시 제거` |

### [ 피드 여행 후기 포스트 글쓰기 화면 ]
| gif1 | gif2  | gif3  | gif4  |
| :-:| :-: | :-: | :-: |
| `제목+글 추가 기본` | `이미지 연속 추가` | `이미지 추가->삭제 후 글 추가` | `글 추가 및 글 제거` |

### [ 피드 여행 후기 포스트 화면 ]
| gif1 | gif2  | gif3  | gif4  |
| :-:| :-: | :-: | :-: |
| `피드 대 카테고리 소팅` | `피드 소 카테고리 소팅` | `피드 게시글 공유` | `피드 하트 on,  off` |

| gif1 | gif2  | gif3  | gif4  |
| :-:| :-: | :-: | :-: |
| `피드 페이징` | `피드 리프레시` | `포스트 신고` | `상세화면 이동` |

### [ 여행 후기 포스트 상세화면 ]

- 이미지+글+이미지 스크롤, 제목 애니메이션, 카테고리 화면, 편집 화면 이동 및 전환 (gif4개)
- 댓글 추가, 댓댓글 업데이트, 댓글 제거, 댓글 신고 (gif 4개)
- 대댓글 제거, 대댓글 업데이트, 대댓글 추가, 대댓글 신고 (gif 4개)
- 댓글 하트 및 누적 연동, 대댓글 하트 및 누적 연동, 여행 후기에서 포스트 하트시 피드에서 연동 ( gif 3개 )

### [ 알림센터 Flow ]

- 알림센터 알림 제거. 알림 전부 제거시 빈 화면, 공지사항 화면에서 dynamic 하게 증가 및 축소 (gif4개)

### [ 검색 Flow ]

- 검색에 관련된 모든것

- 검색 메인화면, 검색 메인화면 에서 특정 상세화면, 검색 메인 화면에서 더보기 누를 경우 (gif4개)
- keyboard 상호작용되는 검색 화면, 최근 검색 기록 하나 제거 및 전부 제거, 검색 결과 후 화면, 검색 결과 후 카테고리 선정시 소팅 되는 과정 (gif4개)
- 검색 결과 후 상세보기 화면 (gif 1개 )

### [ 찜 Flow ]

- 찜 디렉터리 추가 및 제거 및 디렉터리 이름 수정 찜 상세화면 피드 탭 및 여행 후기 탭 (gif3개)
- 찜 디렉터리 안에서 피드 화면 클릭할 경우 진입 및 비어있는 경우 (gif2개)

### [ 설정 Flow ]

- 설정 메인화면, 프로필 이미지 추가, 닉네임 추가, 닉네임 및 프로필 이미지 추가 후 뒤로가기 (gif4개)
- 설정 화면에서 갈 수 있는 화면들..

### etc
- 여행 카테고리 지정 모든 가능한 상황, 느리게 변심 없이 선택할 때 화면 동작.

## 기술적 도전

- 깃허브 위치로 링크 연동!!
