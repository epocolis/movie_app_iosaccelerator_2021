//
//  Genre.swift
//  MyMovies
//
//  Created by Leotis buchanan on 2021-05-19.
//

import Foundation

struct Genre:Decodable, Identifiable {
    var id : String {name}
    let name: String
    let color:String
    
    static let all = Dictionary(uniqueKeysWithValues:Bundle.main.decode([String:Genre].self,
                                                                        from: "genres.json")
                                    .map{key, value in (Int(key) ?? 0, value)})
}






