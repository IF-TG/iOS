//
//  PostOptionViewModelInfo.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import Foundation

struct PostOptionViewModelInfo {
  var postId: Int32?
  
  /// PostAuthor가 존재하지 않는 경우 유니버셜 링크를 통해 이동했기 때문입니다. 이 경우, PostDetailVM에서 포스트 정보를 받은 후에
  ///   노티피케이션으로 post할 때 옵션에서 받아야 합니다. 그때까지 대기해야. 합니다.
  ///   화면은 PostDetailVM에서 해당 포스트 정보를 불러온후 리로드되야만 옵션 선택을 호출할 수 있습니다.
  var postAuthorId: Int32?
  
  var postAuthorNickname: String?
  
  let postOptionLocation: PostOptionLocation
  
  var postTitle: String?
}
