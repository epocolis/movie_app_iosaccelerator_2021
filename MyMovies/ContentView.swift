//
//  ContentView.swift
//  MyMovies
//
//  Created by Paul Hudson on 12/05/2021.
//
import Combine
import SwiftUI

//
// TMDb asks you to register for an API key to use their
// service, and it's free as long as you provide attribution.
// You can learn more and apply for your own API key here:
// https://www.themoviedb.org/documentation/api
//
// Alternatively, just for testing purposes you can use this testing
// key I have generated specifically for this workshop:
// API KEY: cda44c124921b7b8d95d7055ed36baf3
//
// IMPORTANT: Do *not* use that key in a shipping application,
// because it might go away at any point in the future. It's
// just for testing here.
//
// Separately, here's an example value I don't really want you to
// type live on the stream, so it's here for safe keeping:
//
// 
//

struct ContentView: View {
    
     
    @StateObject  private var search = DebouncedText()
    @State private var searchResults = SearchResults(results:[])
    @State private var request: AnyCancellable?
    
    
    func runSearch(criteria: String){
        request?.cancel()
        
        request = URLSession.shared.get(path: "search/movie",
                                        queryItems: ["query":criteria],
                                        defaultValue: SearchResults(results: []))
        {
            items in
            searchResults = items
        }
    }
    
        
    var body: some View {
        NavigationView {
            List {
                Section (
                    header:TextField("Search for a movie", text:$search.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textCase(.none)
                        .font(.title)
                )
                {
                    ForEach(searchResults.results, content: MovieRow.init)
                    }
                }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("My Movies")
            .onChange(of: search.debouncedText, perform: runSearch)
            }
            
        }
           
    }

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
