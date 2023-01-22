import Foundation

struct K {
    static let accessKey = "45V_47NAE3YXOsxEma47rlcGz8W9gJQKwM68gqIGcjo"
    static let secretKey = "Iuk0CV-2rMm4MSaTUvQ3UzPfWb1xdCsPHpe9u-FjUTc"
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseAPIURL = URL(string: "https://api.unsplash.com")
    static let defaultBaseURL = URL(string: "https://unsplash.com")
    
    
    static let authURL = "https://unsplash.com/oauth/authorize"
    static let authURLPath = "/oauth/authorize"
    
    static let tokenURL = "https://unsplash.com/oauth/token"
    static let tokenURLPath = "/oauth/token"
    
}
