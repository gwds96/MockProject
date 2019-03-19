import Foundation

// MARK: - generic request data
func requestData<T: Codable>(urlRequest: URLRequest, completion: @escaping (T) -> ()) {
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data else { return }
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            completion(json)
        } catch {
            print(error)
        }
        }.resume()
}
