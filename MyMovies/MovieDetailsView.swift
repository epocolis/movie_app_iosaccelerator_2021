//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Leotis buchanan on 2021-05-19.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var dataController: DataController
    
    let movie: Movie
    
    @State private var reviews = [Review]()
    @State private var reviewText = ""
    @State private var details: MovieDetails?
    @State private var credits: Credits?
    @State private var requests = Set<AnyCancellable>()
    
    @State private var showingAllCrew:Bool = false
    @State private var showingAllCast:Bool  = false
    
    var reviewURL: URL? {
        URL(string: "https://www.hackingwithswift.com/samples/ios-accelerator/\(movie.id)")
    }
    
    
    
    func fetchMovieDetails(){
        
        let details_url = "movie/\(movie.id)"
        let credit_url = "movie/\(movie.id)/credits"
        
        let movieRequest = URLSession.shared.get(path: details_url,
                                                 defaultValue: nil)
        {
            downloaded in
            details = downloaded
        }
        
        let creditsRequest = URLSession.shared.get(path: credit_url,
                                                   defaultValue: nil)
        {
            downloaded in
            credits = downloaded
        }
        
        if let movieRequest = movieRequest { requests.insert(movieRequest)}
        if let creditsRequest = creditsRequest { requests.insert(creditsRequest)}
        
        guard let reviewURL = reviewURL else {return}
        
        let reviewsRequest = URLSession.shared.fetch(reviewURL,
                                                     defaultValue: []){
            downloaded in
            reviews = downloaded
        }
        
        requests.insert(reviewsRequest)
    }
    
     
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false) {
                VStack(alignment:.leading){
                    VStack(alignment: .leading, spacing: 0){
                        
                        if let path = movie.backdropPath {
                            WebImage(url:URL(string:"https://image.tmdb.org/t/p/w1280\(path)"))
                                .placeholder{Color.gray.frame(maxHeight:200)}
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight:200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                        //only show this if we have details
                        if let details = details {
                            
                            HStack(spacing: 20){
                                Text("Revenue: $\(details.revenue)")
                                Text("\(details.runtime) minutes")
                            }
                            .foregroundColor(.white)
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(Color.black)
                        }
                        
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing:3){
                            ForEach(movie.genres) { genre in
                                Text(genre.name)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical,2)
                                    .background(Color(genre.color))
                                    .clipShape(Capsule())
                                
                            }
                            
                        }
                        
                    }
                    Text(movie.overview)
                        .padding([.bottom])
                    
                    Group {
                        Text("Cast")
                            .font(.title)
                        ScrollView(Axis.Set.horizontal, showsIndicators: false){
                            if let credits = credits {
                                HStack {
                                    ForEach(credits.cast) {
                                        person in
                                        VStack(alignment: .leading){
                                            //image
                                            if let path = person.profilePath {
                                                WebImage(url:URL(string:"https://image.tmdb.org/t/p/w1280\(path)"))
                                                    .placeholder{Color.gray.frame(maxHeight:200)}
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxHeight:200)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                
                                            }
                                            else {
                                                Image("NoPoster")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxHeight:200)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                            }
                                            Text(person.name)
                                                .font(.headline)
                                            Text(person.character)
                                            
                                        }.padding(.bottom ,1)
                                    }} } //end hstack
                            
                            
                        }
                        
                        DisclosureGroup (isExpanded:$showingAllCrew,
                                         content:{
                                            ScrollView(Axis.Set.horizontal, showsIndicators: false){
                                                if let credits = credits {
                                                    HStack {
                                                        ForEach(credits.crew) {
                                                            person in
                                                            VStack(alignment: .leading){
                                                                //image
                                                                if let path = person.profilePath {
                                                                    WebImage(url:URL(string:"https://image.tmdb.org/t/p/w1280\(path)"))
                                                                        .placeholder{Color.gray.frame(maxHeight:200)}
                                                                        .resizable()
                                                                        .scaledToFill()
                                                                        .frame(maxHeight:200)
                                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                                }else {
                                                                    Image("NoPoster")
                                                                        .resizable()
                                                                        .scaledToFill()
                                                                        .frame(maxHeight:200)
                                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                                }
                                                                Text(person.name)
                                                                    .font(.headline)
                                                                Text(person.job)
                                                                
                                                            }.padding(.bottom ,1)
                                                            .padding(.horizontal, 10)
                                                        }
                                                    } // end hstack
                                                }
                                                
                                            }
                                         }
                                         ,
                                         label:{
                                            HStack(spacing:20){
                                                
                                                Text("Crew")
                                                    .font(.title)
                                            }
                                         }).contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showingAllCrew.toggle()
                                }
                            }
                        
                        
                        Text("Reviews")
                            .font(.title)
                        
                        ForEach(reviews) {
                            review in
                            Text(review.text)
                                .font(.body.italic())
                        }
                        
                        TextEditor(text: $reviewText)
                            .frame(height : 200)
                            .border(Color.gray, width: 1)
                        
                        Button("Submit Review", action: submitReview)
                        
                                               
                    }
                    
                }
                
            }
            
        }
        .toolbar {
            Button {
                dataController.toggleFavorite(movie)
            } label: {
                if dataController.isFavorite(movie){
                    Image(systemName: "heart.fill")
                } else {
                    Image(systemName: "heart")
                }
            }
        }
        .navigationTitle(movie.title)
        .padding(EdgeInsets(top: 0, leading: 32, bottom: 10, trailing: 32))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:fetchMovieDetails)
        
        
        
        
    }
    
    
    func submitReview() {
        guard reviewText.isEmpty == false else {return}
        guard let reviewURL = reviewURL else { return}
        
        let review = Review(id:UUID().uuidString, text:reviewText)
        
        let request = URLSession.shared.post(review, to: reviewURL){
            result in
            if result == "OK" {
                reviews.append(review)
                reviewText = ""
            }
        }
        
        
        requests.insert(request)
    }
    
}






struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie.example)
            .environmentObject(DataController(inMemory: true))
    }
}
