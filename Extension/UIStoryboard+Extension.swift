//
//  UIStoryboard+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let position = "Position"

    static let barChart = "BarChart"

    static let recode = "Recode"

    static let share = "Share"

    static let profile = "Profile"
}

extension UIStoryboard {

    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }

    static var position: UIStoryboard { return stStoryboard(name: StoryboardCategory.position) }

    static var barChart: UIStoryboard { return stStoryboard(name: StoryboardCategory.barChart) }

    static var recode: UIStoryboard { return stStoryboard(name: StoryboardCategory.recode) }

    static var share: UIStoryboard { return stStoryboard(name: StoryboardCategory.share) }

    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }

    private static func stStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
