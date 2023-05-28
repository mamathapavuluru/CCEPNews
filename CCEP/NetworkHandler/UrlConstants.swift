//
//  UrlConstants.swift
//  CCEP


import Foundation

// HTTP method type
enum HTTPMethodType: String {
    case postMethod = "POST"
    case getMethod = "GET"
}

// News Categories
enum NewsCategoryType: String {
    case all = "all"
}

// URL Constants
struct APPUrl {

   private struct Domains {
       static let dev = "https://inshorts.deta.dev"
   }

   private  struct Routes {
       static let api = "/"
   }

   private  static let domain = Domains.dev // based on server need to change this Dev/UAT/QA/Local
   private  static let route = Routes.api
   private  static let baseURL = domain + route

   static var newsPath: String {
       return baseURL  + "news?category="
   }
}
