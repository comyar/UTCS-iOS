//
//  Social.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/30/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation

typealias SocialLink = (app: NSURL, web: NSURL)

let FACEBOOK_SOCIAL_LINK = (NSURL(string: "fb://page/272565539464226")!, NSURL(string: "https://fb.me/UTCompSci")!)
let TWITTER_SOCIAL_LINK = (NSURL(string: "twitter://user?screen_name=utcompsci")!, NSURL(string: "https://twitter.com/UTCompSci")!)

func openSocialLink(link: SocialLink) {
    let application = UIApplication.sharedApplication()
    if application.canOpenURL(link.app) {
        application.openURL(link.app)
    } else {
        application.openURL(link.web)
    }
}
