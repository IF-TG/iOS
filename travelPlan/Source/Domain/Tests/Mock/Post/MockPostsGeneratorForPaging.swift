//
//  MockPostsGeneratorForPaging.swift
//  travelPlan
//
//  Created by 양승현 on 10/17/23.
//

import Alamofire
import Combine
// 임시적으로 어쩔수없이 에셋에 저장된 이미지를 불러와야합니다.
import UIKit


struct MockPostsGeneratorForPaging {
  private static let recurCount = 4
  let totalPage = 18*MockPostsGeneratorForPaging.recurCount
  var index = 0
  
  /// MockPostUseCaseForPaging에서 fetchComments는 미구현.
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    Empty().eraseToAnyPublisher()
  }
  
  /// MockPostUseCaseForPaging에서 fetchComments는 미구현.
  func searchPosts(
    keyword: String, page: Int32,
    perPage: Int32, isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    Empty().eraseToAnyPublisher()
  }
  
  /// 설정 화면의 내 활동에 사용됩니다
  func postThumbnailPath(_ index: Int) -> String { return "tempThumbnail\(index)" }
  func profilePath(_ index: Int) -> String { return "tempProfile\(index+1)" }
  var titles: [String] {
    ["Capturing the Beauty of Ocean Bliss", "영롱한 바다",
     "거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ", "맛과 향의 여행", 
     "또 가고 싶다..", "떠나요 둘이서", "신나는 여행~~", "여수 밤바다", "분위기 좋은 카페~",
    
     "Capturing the Beauty of Ocean Bliss", "영롱한 바다",
     "거, 갈땐 가더라도 커피 한잔 정도는 괜찮잖나.. ", "맛과 향의 여행",
     "또 가고 싶다..", "떠나요 둘이서", "신나는 여행~~", "여수 밤바다", "분위기 좋은 카페~"]
  }
  var userNames: [String] {
    ["Wanderlust_Journey", "SoulRebel", "용감한모험가", "커피맨", "모던스타일",
     "네트워킹마스터", "알고리즘 전문가", "concurrency Master", "자 가보자고~",
    
     "Wanderlust_Journey", "SoulRebel", "용감한모험가", "커피맨", "모던스타일",
     "네트워킹마스터", "알고리즘 전문가", "concurrency Master", "자 가보자고~"]
  }
  var durationArray: [String] {
    ["한달", "7일", "3일", "12일", "60일",
     "7일", "14일", "20일", "2일",
    
     "한달", "7일", "3일", "12일", "60일",
     "7일", "14일", "20일", "2일"]
  }
  var ymdArray: [String] {
    ["2023.03.16 ~ 2023.04.15", "2023.04.03 ~ 2023.04.09", "2023.04.17 ~ 2023.04.19",
     "2023.03.19 ~ 2023.03.30", "2023.03.15 ~ 2023.05.13",
     "2023.03.18 ~ 2023.03.24", "2023.03.07 ~ 2023.03.20", "2023.04.03 ~ 2023.04.22", "2023.04.11 ~ 2023.04.12",
    
     "2023.03.16 ~ 2023.04.15", "2023.04.03 ~ 2023.04.09", "2023.04.17 ~ 2023.04.19",
     "2023.03.19 ~ 2023.03.30", "2023.03.15 ~ 2023.05.13",
     "2023.03.18 ~ 2023.03.24", "2023.03.07 ~ 2023.03.20", "2023.04.03 ~ 2023.04.22", "2023.04.11 ~ 2023.04.12"]
  }
  var postContentTexts: [String] {
    ["여름 여름 여름 여름~~~~ ",
     "발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
     "이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
     "수영 하며 시원한 바다 즐겼는데, 특히 파도가 너무 작아서 안전하게 즐길 수 있었어요. 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!",
     "여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉",
     "여행하기 정말 좋은 날씨!!! 여름은 봄에가야죠: )",
     "출발전 모로코 지진소식으로 가족과 지인들의 우려속에 불안한 마음으로 출발했는데" +
     "민선예 인솔자님과 유범상 현지가이드님 덕분에 안전하고 편한하게 여행을 마무리할수 있었습니다",
     "시작된 하노이, 최고의 바다 여행은 만족스럽고 행복한 일정 이었습니다.",
     "공항에 가이드를 처음 대면했을때 참 쉽지 않은 여행이 되겠구나 라는 느낌을 가졌습니다. 그래도 비행기에 타니 여행이 기대가 됬었어요.",
     
     "여름 여름 여름 여름~~~~ ",
     "발리의 푸른 바다와 화려한 저녁 일몰은 정말로 멋있었어요. 휴양의 천국입니다! 대박 다음에 또 와야겠어요",
     "이번 여행에서는 평소에 느끼지 못한 여유와 힐링을 느낄 수 있었습니다.",
     "수영 하며 시원한 바다 즐겼는데, 특히 파도가 너무 작아서 안전하게 즐길 수 있었어요. 오랜만에 파스타 먹으니 대박 맛있어요. 따봉 따봉 강추!!",
     "여행 중 발견한 빙수 가게의 특별한 토핑과 시럽 조합은 따봉",
     "여행하기 정말 좋은 날씨!!! 여름은 봄에가야죠: )",
     "출발전 모로코 지진소식으로 가족과 지인들의 우려속에 불안한 마음으로 출발했는데" +
     "민선예 인솔자님과 유범상 현지가이드님 덕분에 안전하고 편한하게 여행을 마무리할수 있었습니다",
     "시작된 하노이, 최고의 바다 여행은 만족스럽고 행복한 일정 이었습니다.",
     "공항에 가이드를 처음 대면했을때 참 쉽지 않은 여행이 되겠구나 라는 느낌을 가졌습니다. 그래도 비행기에 타니 여행이 기대가 됬었어요."
    ]
  }
  var postContentThumbnails: [[String]] {
    [[1].map { postThumbnailPath($0) },
     [2, 3].map { postThumbnailPath($0) },
     (4...6).map { postThumbnailPath($0) },
     (7...10).map { postThumbnailPath($0) },
     (11...15).map { postThumbnailPath($0) },
     [4, 9, 12, 2].map { postThumbnailPath($0)},
     [6, 4, 3].map { postThumbnailPath($0) },
     [11, 8].map { postThumbnailPath($0) },
     [4, 6, 12, 15, 3].map { postThumbnailPath($0) },
    
     [1].map { postThumbnailPath($0) },
     [2, 3].map { postThumbnailPath($0) },
     (4...6).map { postThumbnailPath($0) },
     (7...10).map { postThumbnailPath($0) },
     (11...15).map { postThumbnailPath($0) },
     [4, 9, 12, 2].map { postThumbnailPath($0)},
     [6, 4, 3].map { postThumbnailPath($0) },
     [11, 8].map { postThumbnailPath($0) },
     [4, 6, 12, 15, 3].map { postThumbnailPath($0) }]
  }
  var postHearts: [Int] {
    [0, 1040, 41, 548, 7, 2, 10, 4, 1,
    
     0, 1040, 41, 548, 7, 2, 10, 4, 1]
  }
  var postComments: [Int] {
    [0, 2, 10, 1, 38, 2, 4, 22, 10,
    
     0, 2, 10, 1, 38, 2, 4, 22, 10]
  }
  func makeMockPostsContainers() -> [PostContainer] {
    return (0..<9*2).map { i -> PostContainer in
      let tripDate: Post.TripDate = {
        let str: String = self.ymdArray[i]
        let startAndEnd: [String] = str.components(separatedBy: " ~ ").map { String($0) }
        return Post.TripDate(
          startDate: DateTimeConverter.toDate(from: startAndEnd[0])!,
          endDate: DateTimeConverter.toDate(from: startAndEnd[1])!)
      }()
      let postDetail = Post.Detail.init(
        postID: "\(i)",
        title: titles[i],
        content: [Post.PostContent.init(sort: 1, text: postContentTexts[i])],
        likes: Int32(postHearts[i]),
        comments: Int32(postComments[i]),
        location: .init(x: -1.0, y: -1.0),
        createAt: Date(),
        tripDate: tripDate)
      let post = Post(
        liked: i % 2 == 0,
        detail: postDetail,
        author: .init(
          profileImageData: UIImage(named: profilePath(i%5))!.jpegData(compressionQuality: 1),
          nickname: userNames[i]),
        highResolveImages: postContentThumbnails[i].enumerated().map { (idx, imageString) in
          return Post.PostImage(
            imageData: UIImage(named: imageString)?.jpegData(compressionQuality: 1),
            sort: Int32(idx+2))
        },
        category: .init(themes: [.adventure, .festivals, .relaxation],
                        regions: [.busan], seasons: [.fall],
                        partners: [.lover, .friend]))
      
      let postContentThumbnails: [Data] = postContentThumbnails[i].compactMap {
        UIImage(named: $0)!.jpegData(compressionQuality: 1)
      }
      
      return PostContainer(
        post: post,
        thumbnail: .init(postImageDataList: postContentThumbnails),
        totalPosts: Int64(18*Self.recurCount))
    }
  }
  
  lazy var mockPostPage: PostsPage = {
    let mockPostContainers = makeMockPostsContainers()
    let posts = mockPostContainers.map { $0.post }
    let thumbnails = mockPostContainers.map { $0.thumbnail }
    
    let recurredPosts = (0..<Self.recurCount).map { _ in return posts }
    let recurredThumbnails = (0..<Self.recurCount).map { _ in return thumbnails }
    let postsPage = PostsPage(
      totalPosts: Int64(totalPage),
      posts: recurredPosts.flatMap { $0 },
      thumbnails: recurredThumbnails.flatMap { $0 })
    return postsPage
  }()
}
