@objc(WMFRandomArticleFetcher)
final class RandomArticleFetcher: Fetcher {
    @objc func fetchRandomArticle(withSiteURL siteURL: URL, completion: @escaping (Error?, URL?, [String: Any]?) -> Void) {
        let pathComponents = ["page", "random", "summary"]
        guard let taskURL = configuration.wikipediaMobileAppsServicesAPIURLComponentsForHost(siteURL.host, appending: pathComponents).url else {
            completion(Fetcher.invalidParametersError, nil, nil)
            return
        }
        session.getJSONDictionary(from: taskURL) { (result, response, error) in
            if let error = error {
                completion(error, nil, nil)
                return
            }
            guard
                let title = result?["title"] as? String,
                let articleURL = siteURL.wmf_URL(withTitle: title)
            else {
                completion(Fetcher.unexpectedResponseError, nil, nil)
                return
            }
            completion(nil, articleURL, result)
        }
    }
}
