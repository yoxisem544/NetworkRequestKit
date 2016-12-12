# Network Request Kit
This code is inspried by Austin Feight's [Evolution of a Network Layer](https://github.com/feighter09/Evolution-of-a-Network-Layer). I made it possiable to handle multipart request and deal with response that is ignorable according to my situation. 

There is a artical explain why should we wrap network request like this in chinese. We won't go too deep here.

## Requirement
- swift 3.0 or above
- xcode 8.0 or above
- iOS 9 or above

## Dependency
- SwiftyJSON
- Alamofire 4.x
- PromiseKit

## Installation
need to put it onto cocoapods

## How to use it
### First Look at NetworkRequest
#### Create Model
Let's assume we have to fetch user information from server. So let's create a struct `User`. `User` will have it's name and id. It will be like this.

```Swift
public struct User {
	let name: String
	let id: Int
}
```

#### Conform to JSONDecodable protocol
We will talk about this protocol and why we should conform to this protocol later. In order to comform to JSONDecodable protocol, you will have to implement `init(decodeUsing json: JSON)` init method.

```swift
extension User : JSONDecodable {
	init(decodeUsing json: JSON) {
		self.name = json["name"].stringValue
		self.id = json["id"].intValue
	}
}
```

#### Create a network request
In this situation, we are going to fetch user information from server. 

```swift
final public class FetchUser : NetworkRequest {
	
}
```

#### Conform to NerworkRequest protocol
We will have to tell which endpoint and method this api call should go and perform. Assume we need to perform a get here, and the end point is at `/user`.

Also, we need to explicitly tell the request what will the response type be. Here, our `ResponseType` is `User`.

```swift
final public class FetchUser : NetworkRequest {
	public typealias ResponseType = User
	
	public var endPoint: String { return "/user" }
	public var method: HTTPMethod { return .get }
}
```

#### Create a perform method
After telling all things we need to perform a request, we are firing the api call right now. Perform method is the method to fire api, and will return a promise with a response.

How do we make a api call using `NetworkRequest`? This will be really simple. If we conform to `NetworkRequest`, we will get a networkClient, reponseHandler for free. NetworkClient can help us make the request. ResponseHandler will then transform the data we get from the request into `ResponseType` we specific above. All these works are chained in Promise chain.

```swift
final public class FetchUser : NetworkRequest {
	public typealias ResponseType = User
	
	public var endPoint: String { return "/user" }
	public var method: HTTPMethod { return .get }
	
	public func perform() -> Promise<ResonseType> {
		return networkClient.performRequest(self).then(execute: responseHandler)
	}
}
```

### Advance Usage
#### Complex network requests
Assume you need to fetch user's information by it's user id. I recommand you to pass in user's id while performing api call like this. Let's make some adjust to our `FetchUser`.

I recommand you to have a private id inside your class. So, no one can revise this id during your api call is performing.

```swift
final public class FetchUser : NetworkRequest {
	public typealias ResponseType = User
	
	public var endPoint: String { return "/user" }
	public var method: Alamofire.HTTPMethod { return .get }
	public var parameters: [String : Any] { return ["id": id] }
	public var encoding: Alamofire.ParameterEncoding { return URLEncoding.default }
	
	private id: Int = 0
	public func perform(id: Int) -> Promise<ResonseType> {
		self.id = id
		return networkClient.performRequest(self).then(execute: responseHandler)
	}
}
```

#### If response is not important
We will love the benefits `NetworkRequst` gave us. Unfortunately, we need to specify our `ReponseType` at first. We can specify it to `Void` type `()` , but this doesn't look good. Therefore, I make a typealias `IgnorableResult` inside `NetworkRequst`. 

```swift
public typealias IgnorableResult = ()
```

If the response is not important, make `ResponseType` equal to `IgnorableRequslt`, and the response will not be parsed.

```swift
final public class FetchUser : NetworkRequest {
	public typealias ResponseType = IgnorableRequslt
	
	public var endPoint: String { return "/user" }
	public var method: HTTPMethod { return .get }
	
	public func perform() -> Promise<ResonseType> {
		return networkClient.performRequest(self).then(execute: responseHandler)
	}
}
```

#### If the response is an array
In many situation, the response is returned in a json array. What you need to do here is to call `arrayResponseHandler` after performing Requset. Then indicate the return type to an array of `ResonseType`, like `[ResponseType]`

```swift
final public class FetchUsers : NetworkRequest {
	public typealias ResponseType = IgnorableRequslt
	
	public var endPoint: String { return "/users" }
	public var method: HTTPMethod { return .get }
	
	public func perform() -> Promise<[ResonseType]> {
		return networkClient.performRequest(self).then(execute: arrayResponseHandler)
	}
}
```

#### Multipart request
Like uploading a large image to server, multipart request is often used in Web development. When it comes to iOS, it's not that easy. 

`MultipartNetworkRequest` and `MultipartNetworkClient` can help you to do this work in a easy way.

`MultipartNetworkRequest` conforms to `NetworkRequest`, so all benefits you got in `NetworkRequest` are also available here. But there are something you need to implement to comform to a `MultipartNetworkRequest` protocl.

You will need to implement these getters when comforming to `MultipartNetworkRequest ` protocol:

``` swift
public protocol MultipartNetworkRequest : NetworkRequest {
    
	/// Data prepared to upload
	var multipartUploadData: Data { get }
	/// e.g. "avatar"
	var multipartUploadName: String { get }
	/// e.g. "file"
	var multipartUploadFileName: String { get }
	/// e.g. "image/jpeg"
	var multipartUploadMimeType: String { get }
    
}
```

This is sample class that you might do to create a multipart upload request:

```swift
final public class UploadTask : MultipartNetworkRequest {
	public typealias ResponseType = IgnorableResult
	    
	public var endpoint: String { return "/user/199/uploadAvatar" }
	public var method: HTTPMethod { return .post }
	public var encoding: ParameterEncoding { return URLEncoding.default }
	    
	public var multipartUploadData: Data { return  }
	public var multipartUploadName: String { return "new_avatar" }
	public var multipartUploadFileName: String { return "file" }
	public var multipartUploadMimeType: String { return "image/jpeg" }
	    
	private var data: Data!
	func perform(avatarData: Data) -> Promise<ResponseType> {
		self.data = avatarData
	   return networkClient.performUploadRequest(self).then(execute: responseHandler)
}
}
```

#### Things to know
1. get method with parameters will need to change the encoding to URLEnconding.default, or it's gonna fail with no reason. This maybe Alamofire's bug or is just a RESTful api rule.




