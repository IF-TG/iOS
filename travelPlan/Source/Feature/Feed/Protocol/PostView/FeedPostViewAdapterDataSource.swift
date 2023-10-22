//
//  FeedPostViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/22/23.
//

protocol FeedPostViewAdapterDataSource: PostViewAdapterDataSource {
  var headerItem: TravelCategorySortingType { get }
}
