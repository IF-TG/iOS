# 여가: 여행을 가다

![image](https://github.com/user-attachments/assets/c4c200c9-01e3-4451-9abb-43454361a628)


## 프로젝트 소개 
먼저 다녀온 여행객의 여행 기록을 후기로 공유하고 국내 소외 관광지를 활성화 하기 위한 서비스 입니다.

### 👉 개발 동기
> 많은 현대인이 SNS 광고와 알고리즘에 의존해 여행지를 선택하면서, 일부 국내 여행지들이 소외되고 있습니다.
> 이 문제를 해결하기 위해, 한국관광공사 공공데이터를 활용한 여행 커뮤니티 앱 서비스를 개발하여 숨겨진 여행지를 발굴하고 공유할 수 있는 플렛폼을 마련했습니다🤩

---

## 🧑🏻‍💻 팀 소개 

| BE: 임경완 | iOS: 띵킹 | iOS: 김석현 | Design: 오수민
|:--------:|:--------:|:--------:|:--------:|
| <img src="https://avatars.githubusercontent.com/u/47065431?v=4" width="100" /> | <img src="https://avatars.githubusercontent.com/u/96910404?s=400&u=9e3d914e4168c78643e358115a0294669793ca99&v=4" width="100" /> | <img src="https://avatars.githubusercontent.com/u/108918481?v=4" width="100" /> | <img src="https://user-images.githubusercontent.com/96910404/236286254-671dd10b-9342-485b-9c75-799522175025.jpeg" width="100" /> |
[MoonDooo](https://github.com/MoonDooo) |[SHcommit](https://github.com/SHcommit) |[letusHyun](https://github.com/letusHyun) | OhSumin

## 🎯 동료와의 목표 
- UI 구현시 되도록 외부 라이브러리 사용하지 않기
- 기능 구현하다 막히거나 오류 해결이 어려운 경우 동료와 의논하며 해결하기
- 컨벤션 준수하기
- PullRequest할 때, 자신이 구현한 기능 자세히 소개 및 새롭게 알게된 개념 소개 및 참고했던 포스트 링크 남기기
- 중복 코드를 줄이기. 객체와의 의존성은 줄이고 결합도는 높이는 객체 설계 및 구현하기

### 💡 '여가' 스토리가 담긴 공간
- <a href="https://carbonated-eggplant-aad.notion.site/d00c55ded166441bb7991ff3a28b4d73?pvs=4">여가-여행을 가다[노션 링크]</a>
- <a href="https://www.figma.com/file/QmC7HTkSEMLfleIZlxnlOL/iOS-%EC%97%AC%ED%96%89-%EC%95%B1?type=design&mode=design">여가 UI/UX design Figma[링크]</a>
- <a href="https://carbonated-eggplant-aad.notion.site/iOS-97bec2a437214a8198843455b4c4f5e5?pvs=4">iOS 팀 노션 [링크]</a>

---
## 사용 기술 및 라이브러리
### 1st party
- UIKit, AutoLayout
- Combine, GCD
- XCTest
- Photos
- LinkPresentation
- NotificationCenter

### 3rd party
- Swinject
- Alamofire, Firebase, GoogleSignIn
- AppsFlyer
- Snapkit, Swiftlint

### Etc
- Figma, SwiftPM, Github project kanban

---

## 개발 환경
- Minimum deployment target: **iOS 13.0**

## Project Architecture & System Flow
<img width="709" alt="image" src="https://github.com/user-attachments/assets/f5be0aa7-3dfa-49fc-8ca8-87505a07bf11">

- Clean Architecture
- Input/Output binding ( in MVVM )
- Coordinator

> 각각의 layer 마다 객체들은 protocol을 통해 의존성을 낮추어 서로 협력합니다. 이때 **DIP**를 지키고자 노력했습니다.
> 또한 layer 별로 Assembly에서 객체를 등록해, 객체의 의존성 주입에 필요한 로직을 해당 Layer의 Assembly에서 한정할 수 있었습니다.

---

## 어플리케이션 기능

> 죄송합니다.
> 
> Application 각 flow별 동작 gif는 크롬 브라우저에서 원활하게 동작됩니다. (사파리에서는 gif가 동작되지 않는 현상을 발견했습니다😭.)
> GIF 용량이 있어서 때문에 일부 화면은 로딩 지연이 걸립니다.

### [ 로그인 화면 ]

| ![로그인 화면](https://github.com/user-attachments/assets/40d26c59-8582-4c7f-bd57-0c3e5ecb8d4e) | ![구글+파이어스토어로긴](https://github.com/user-attachments/assets/d1528479-5804-4c5d-b78c-82c1e6f45997)  | gif3  |
| :-: | :-: | :-: |
| `로그인 화면` | `구글 로그인 연동` | `애플 로그인 연동` |

### [ 피드 여행 후기 포스트 화면 ]
| gif1 | gif2  | gif3  | gif4  |
| :-: | :-: | :-: | :-: |
| `제목+글 추가 기본` | `이미지 연속 추가` | `이미지 추가->삭제 후 글 추가` | `글 추가 및 글 제거` |

<img src="https://github.com/IF-TG/iOS/assets/96910404/8acef3d7-9031-45b1-ba52-f098339fa58b" width="180">|<img src="https://github.com/IF-TG/iOS/assets/96910404/23ba2fec-581f-4c83-98aa-8312f4b402b6" width="180">|<img src="https://github.com/IF-TG/iOS/assets/96910404/b2b12a92-2b87-4bf2-9c83-f71185f04c60" width="180">|<img src="https://github.com/IF-TG/iOS/assets/96910404/3b1c3f6a-d979-40a4-b048-06f3aa463564" width="180">|
|:-:|:-:|:-:|:-:|
|`카테고리 화면 초기->선택완료까지`|`카테고리 화면 대분류 전환`|`카테고리 화면 소분류 다중 선택`|`카테고리 화면 다중 선택한 소분류 취소`| 

| <img src="https://github.com/user-attachments/assets/37d9d899-b2d0-4325-8924-7a7c3a494330" width="230"> | <img src="https://github.com/user-attachments/assets/1d240fb5-9079-455a-941e-ffffafcc696e" width="230"> | <img src="https://github.com/user-attachments/assets/e92ff353-b121-4575-a68a-6634392bd9e9" width="230"> |
| :-: | :-: | :-: |
| `피드 페이징 및 리프레싱` | `피드 카테고리 테마 전환` | `상세화면 이동` |

### [ 공유하기 로직 ]

- Closed #246 (<a href="https://github.com/IF-TG/iOS/pull/246">앱스플라이어 도전기 PR 링크 바로가기</a>)

| ![공유하기 로직](https://github.com/IF-TG/iOS/assets/96910404/1a3e3ed5-8868-4419-bcd9-cb811646d5f6) | ![앱이 백그라운드 상태일 때](https://github.com/IF-TG/iOS/assets/96910404/ae6982fb-e01c-46f6-bb40-c036f113d5d2) | ![실행되지 않은 앱일 때 링크 클릭](https://github.com/IF-TG/iOS/assets/96910404/a34b7cb6-0fee-4926-9e2a-dda3cae7df6b) | ![유효하지 않은 포스트일 때](https://github.com/IF-TG/iOS/assets/96910404/7807d479-9752-43e4-9cf0-7fe7c6314be8) | 
| :-: | :-: | :-: | :-: | 
| `공유하기 로직` | `앱이 백그라운드 상태일 때 링크 클릭`  | `실행되지 않은 앱일 때 링크 클릭` |`유효하지 않은 포스트일 때` |

### [ 피드 여행 후기 포스트 화면 ]

| ![테마별 소팅](https://github.com/user-attachments/assets/ab710bcc-b2f1-45df-87d8-dcb139064846) | ![포스트 차단 후 페이징](https://github.com/user-attachments/assets/a6736f5e-bd60-47dd-a1b7-d3b994c5a713) | ![피드 하트 취소](https://github.com/user-attachments/assets/9f8ff0c7-855c-4ca3-9410-4d231d9d4aa3) | ![피드 하트 후 포스트화면 연동](https://github.com/user-attachments/assets/fa8b4189-b076-4ac6-a387-abeee08868fe) | 
| :-: | :-: | :-: | :-: | 
| `피드 대표적 계절, 지역 테마 및 서브 카테고리 소팅` | `피드 포스트 그만보기 및 스크롤`  | `피드 포스트 하트 취소` |`피드에서 포스트 하트 후 상세화면 연동` |


### [ 여행 후기 포스트 상세화면 ]

| ![ 상세화면 스크롤 ](https://github.com/user-attachments/assets/a13edfca-32ed-4b12-b393-2a546e357a74) | ![네비바 애니](https://github.com/user-attachments/assets/be9ac408-1983-4d0b-a24f-880ad236c78c)  | ![ 카테고리 ](https://github.com/user-attachments/assets/64f07e56-6798-4e96-99cc-89a466edfc7f)  | ![편집하기](https://github.com/user-attachments/assets/fc9ff720-0940-4a0d-a67a-5380e6acdb24)  |
| :-: | :-: | :-: | :-: |
| `상세화면 스크롤` | `자연스러운 네비바 애니메이션` | `카테고리 화면` | `상세화면 -> 편집화면 이동` |

#### [ 댓글과 대댓글의 기능은 동일하게 동작해서 댓글의 동작 과정은 생략했습니다. ]

| ![대댓글 작성](https://github.com/user-attachments/assets/f26b57de-c4b8-4b17-ac36-83d61e0093c6) | ![대댓글 업데이트](https://github.com/user-attachments/assets/ffb8cd6c-0f1b-46da-8b31-75565f054543)  | ![대댓글 삭제](https://github.com/user-attachments/assets/e1ed7ee8-65f1-49e1-b8de-ddb021e9975e) | ![대댓글 하트 do, undo](https://github.com/user-attachments/assets/68c6a1db-ef04-4b2c-9986-c6ee38ac2a44) |
| :-: | :-: | :-: | :-: |
| `상세 화면 포스트 대댓글 추가` | `포스트 대댓글 업데이트` | `포스트 대댓글 삭제` | `대댓글 하트 do, undo` |

#### [타인의 댓글, 대댓글 옵션 선택하는 경우 #1, #2, #3]

| <img src="https://github.com/user-attachments/assets/3f913ea6-b984-473c-8683-a8720e54df43" width="230"> | <img src="https://github.com/user-attachments/assets/9bcd7cad-a92a-49a7-a1e4-68f053748ea3" width="230"> | <img src="https://github.com/user-attachments/assets/855c4b5f-8511-4c0c-9078-f5b94b3d67f0" width="230"> |
| :-: | :-: | :-: |
| `대댓글 차단 #1` | `댓글 차단(대댓글 존재(O))#2` | `댓글 차단상태-> 마지막 대댓글 차단#3` |

### [ 알림센터 Flow ]

| <img src="https://github.com/user-attachments/assets/b02c3d91-c098-46d1-827c-ddad203657b0" width="230"> | <img src="https://github.com/user-attachments/assets/d7094a04-277e-4885-8e0c-89cda9839de4" width="230"> | 
| :-: | :-: |
| `알림 화면. 알림 전부 제거, 리프레시` | `Firestore 기반 공지사항 화면` |

### [ 검색 Flow ]

- 검색에 관련된 모든것

- 검색 메인화면, 검색 메인화면 에서 특정 상세화면, 검색 메인 화면에서 더보기 누를 경우 (gif4개)
- keyboard 상호작용되는 검색 화면, 최근 검색 기록 하나 제거 및 전부 제거, 검색 결과 후 화면, 검색 결과 후 카테고리 선정시 소팅 되는 과정 (gif4개)
- 검색 결과 후 상세보기 화면, 페이징 (gif 1개 )

### [ 찜 Flow ]

- 찜 디렉터리 추가 및 제거 및 디렉터리 이름 수정 찜 상세화면 피드 탭 및 여행 후기 탭 (gif3개)
- 찜 디렉터리 안에서 피드 화면 클릭할 경우 진입 및 비어있는 경우 (gif2개)

### [ 설정 Flow ]

#### [ 설정 메인 화면, 내 정보 화면 ]

| ![설정메인](https://github.com/user-attachments/assets/168783b6-802a-4ba5-8c2b-3d3ed2dde248) | ![카메라로 이미지 추가](https://github.com/user-attachments/assets/069fcf35-3ef1-4f90-9fe5-3d3de0777d65) | ![닉네임 변경](https://github.com/user-attachments/assets/0d26a28d-bd53-483e-a32e-11a2940dd8d9) | ![프로필,이미지 수정 후 저장](https://github.com/user-attachments/assets/a6b1e70d-32ca-4960-a2d9-d84d2db5be18) |
| :-: | :-: | :-: | :-: |
| `설정 메인 화면` | `내 정보화면. 카메라로 프로필 이미지 추가` | `내 정보화면. 닉네임 변경` | `내 정보화면. 프로필 수정 및 이미지 수정 후 저장` |


#### [ 이용 안내 화면, 메일 문의 화면 flow ] 

| <img src="https://github.com/user-attachments/assets/107c76b0-29ef-4e6d-9fa8-2bdf449ae826" width="230"> | <img src="https://github.com/user-attachments/assets/999c360f-426f-4fbc-9fd5-1e9cec353b83" width="230"> | <img src="https://github.com/user-attachments/assets/eaf68c31-845a-419b-97c1-c2b5b2ba7e2f" width="230"> |
| :-: | :-: | :-: | 
| `이용 안내 화면` | `메일 문의화면 -> 메일 전송 flow` | `여가팀 메일함 메일 상세내용` |
