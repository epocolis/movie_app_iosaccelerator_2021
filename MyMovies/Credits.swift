//
//  Credits.swift
//  MyMovies
//
//  Created by Leotis buchanan on 2021-05-20.
//

import Foundation


struct Credits: Decodable {
    
    let cast: [CastMember]
    let crew: [CrewMember]
}


struct CastMember:Decodable, Identifiable {
    var id: String {creditId}
    let creditId: String
    let name : String
    let character: String
    let profilePath: String?
}

struct CrewMember: Decodable, Identifiable {
    var id: String {creditId}
    let creditId: String
    let name: String
    let job: String
    let profilePath: String?
}
