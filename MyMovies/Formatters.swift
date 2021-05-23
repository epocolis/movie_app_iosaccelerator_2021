//
//  Formatters.swift
//  MyMovies
//
//  Created by Leotis buchanan on 2021-05-17.
//

import Foundation

enum Formatters {
    static let movieDecoding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d"
        return formatter
    }()
    
    static let movieDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter
    }()
}
