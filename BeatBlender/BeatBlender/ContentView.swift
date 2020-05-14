//
//  ContentView.swift
//  BeatBlender
//
//  Created by 김선웅 on 2020/05/09.
//  Copyright © 2020 novdov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let spliceRequest = BeatBlenderRequest(baseUrl: "http://localhost:8080/model")

    var body: some View {
        Button(action: {
            self.sample()
		}) {
            Text("Sample")
        }
    }

    func sample() {
        let body = BeatBlenderRequestBody(numSamples: 1, temperature: 0.5)
        spliceRequest.post(endpoint: "/sample", requestBody: body, completion: { result in
            switch result {
            case let .success(sampleData):
                let arr = sampleData["samples"] as! NSArray
                guard let jsonString: String = stringifyJson(withJSONObject: arr[0] as! [String: Any]) else {
                    return
                }
                guard let noteSequence: Tensorflow_Magenta_NoteSequence = jsonToNoteSequence(jsonString: jsonString) else {
                    return
                }
                print(noteSequence)
            case let .failure(error):
                print(error)
            }
		})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
