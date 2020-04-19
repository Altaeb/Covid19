//
//  DClient..swift
//  Covid19
//
//  Created by Abdalfattah Altaeb on 4/19/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

class DClient {

    static let shared = DClient()

    let baseApi = "https://api.covid19api.com/summary"

    func getRequest<T : Decodable>(_ url: String, _ completion: @escaping (DResult<T>) -> Void) {
        let errorMessage = "An error occured"
        var result: DResult<T>!
        let task = URLSession.shared.dataTask(with: URL(string: url)!){ data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                let responseBody = try? decoder.decode(T.self, from: data) as T
                if let body = responseBody {
                    result = DResult.success(body)
                } else {
                    result = DResult.error(errorMessage)
                }
            } else {
                result = DResult.error(errorMessage)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }

    func getSchoolSummaries(_ completion: @escaping (DResult<CountrySummaryResponse>) -> Void) {
        getRequest(baseApi, completion)

    }

}
