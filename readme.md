# Network Request Kit
[![Version](https://img.shields.io/cocoapods/v/NetworkRequestKit.svg?style=flat)](https://cocoapods.org/pods/NetworkRequestKit)
[![License](https://img.shields.io/cocoapods/l/NetworkRequestKit.svg?style=flat)](https://cocoapods.org/pods/NetworkRequestKit)
[![Platform](https://img.shields.io/cocoapods/p/NetworkRequestKit.svg?style=flat)](https://cocoapods.org/pods/NetworkRequestKit)

This code is inspried by Austin Feight's [Evolution of a Network Layer](https://github.com/feighter09/Evolution-of-a-Network-Layer). I made it possiable to handle multipart request and deal with response that is ignorable according to my situation. 

There is a [artical](https://github.com/yoxisem544/Network-Evolution-Practice) explain why should we wrap network request like this in chinese. We won't go too deep here. If you don't understand what we are doing here. I sugguest you to read this [artical](https://github.com/yoxisem544/Network-Evolution-Practice) first or [Evolution of A Networking Layer](https://medium.com/@austinfeight/evolution-of-a-networking-layer-c395017188b3#.pkla1nafd) for a english version.

## Requirement
- swift 4.x
- xcode 9.x
- iOS 9 or above

## Installation
Through [Cocoapods](https://cocoapods.org/pods/NetworkRequestKit)
```
pod 'NetworkRequestKit', '~> 2.1.2'
```

## Dependencies
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [PromiseKit](https://github.com/mxcl/PromiseKit)

## Sample Project
Sample project is located in the file `NetworkRequestExample`. If you don't want to read the instruction below, just open and play with the sample project.

**Notice**: Remember to install pod before opening sample project.

## How to use it
### Preparation
#### Set Your Base Url
What I will do here is to create a new file in your project naming it `NetworkRequestConfig`. Inside this file, I will indicate my `base url` and also set reqeust `header` if you use `Oauth` by throwing your `access token` through `header`.

NetworkRequestConfig.swift
```swift
import NetworkRequestKit

extension NetworkRequest {
  var baseURL: String { return "http://httpbin.org" }
  var accessToken: String { return "SOMETOKEN" }
  var headers: [String : String] { return ["access_token": accessToken] }
}
```
### First Look at NetworkRequest
#### Create Model
Let's assume we have to fetch user information from server. So let's create a struct `User`. `User` will have it's name and id. It will be like this.

```Swift
public struct User {
  let name: String
  let id: Int
}
```

#### Conform to Codable protocol
In order to conform to Codable protocol, just add Codable protocol to your data model, then you're all done!
For advance usage or complex nested json, please see [Ben Scheirman's Ultimate Guide to JSON Parsing with Swift 4](http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/?utm_campaign=Revue%20newsletter&utm_medium=Newsletter&utm_source=AppCoda)

```swift
extension User : Codable {}
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
	
  public var endpoint: String { return "/user" }
  public var method: HTTPMethod { return .get }
}
```

#### Create a perform method
After telling all things we need to perform a request, we are firing the api call right now. Perform method is the method to fire api, and will return a promise with a response.

How do we make a api call using `NetworkRequest`? This will be really simple. If we conform to `NetworkRequest`, we will get a networkClient, reponseHandler for free. NetworkClient can help us make the request. ResponseHandler will then transform the data we get from the request into `ResponseType` we specific above. All these works are chained in Promise chain.

```swift
final public class FetchUser : NetworkRequest {
  public typealias ResponseType = User
	
  public var endpoint: String { return "/user" }
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
	
  public var endpoint: String { return "/user" }
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
	
  public var endpoint: String { return "/user" }
  public var method: HTTPMethod { return .get }
	
  public func perform() -> Promise<ResonseType> {
    return networkClient.performRequest(self).then(execute: responseHandler)
  }
}
```

#### If the response is an array
In many situation, the response is returned in a json array. What you need to do here is to add angle bracket to your data model type. That's all :)

```swift
final public class FetchUsers : NetworkRequest {
  public typealias ResponseType = [User]
	
  public var endpoint: String { return "/users" }
  public var method: HTTPMethod { return .get }
	
  public func perform() -> Promise<ResonseType> {
    return networkClient.performRequest(self).then(execute: responseHandler)
  }
}
```

#### If you just want JSON resposne
In some situation, you just want a json back and handle everything by your self, or don't want to create another model file. Use `RawJSONResult` instead, `RawJSONResult` is typealias of `JSON`. Also need rseponse handler here. Notice that json is a dictionary in JS, so it is impossible to have an array response handler here.

```swift
final public class FetchUsers : NetworkRequest {
  public typealias ResponseType = RawJSONResult
	
  public var endpoint: String { return "/users" }
  public var method: HTTPMethod { return .get }
	
  public func perform() -> Promise<[ResonseType]> {
    return networkClient.performRequest(self).then(execute: responseHandler)
  }
}
```

#### Paging request
Fetching a bunch of data form server is not always a go thing to do. It makes your user experience bad aslo lower the performance on server. So, this is why we need a paging.

It will be like this, conform to `PagingEnabledRequest` protocol, then you have to specific which page are you on now. Execute response handler, then check if there is next page of data. Remember to track current page in your model or view controller.

`PagingResult` is a typealias of 
```swift
typealias PagingResult = (results: [Decodable], nextPage: NextPage)
```
This is for conveneince, typing such a long return type may be easy to get wrong.

```swift
final public class FetchUsers : NetworkRequest, PagingEnabledRequest {
  public typealias ResponseType = IgnorableResult

  public var endpoint: String { return "/users" }
  public var method: HTTPMethod { return .get }
  public var parameters: [String : Any]? { return ["page": page, "per_page": perPage] }

  public var page: Int = 1
  public func perform(page: Int) -> Promise<PagingResult> {
    self.page = page
    return networkClient.performRequest(self).then(execute: responseHandler).then(execute: checkHasNextPage)
  }
    
}
```

**NOTE**

There is also a `pagingParameters: [String : Any]` to get a packed dictionary if you like to combine two dictionary `parameters` and `pagingParameters` together.

#### Multipart request
Like uploading a large image to server, multipart request is often used in Web development. When it comes to iOS, it's not that easy. 

`MultipartNetworkRequest` and `MultipartNetworkClient` can help you to do this work in a easy way.

`MultipartNetworkRequest` conforms to `NetworkRequest`, so all benefits you got in `NetworkRequest` are also available here. But there are something you need to implement to conform to a `MultipartNetworkRequest` protocl.

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
      
  public var multipartUploadData: Data { return data }
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

#### Error handling
There are some predefined errors I often use in my project. 
1. If there is something wrong when parsing data, will return `.decodingError` or `.jsonParsingError` error.
2. If there is something wrong while making the api call, will return `.apiUnaccepatable` error. Error information is attached.
3. If there is no network, will return `.unknownError` error. You should fire request everytime nomatter network is available or not. This is recommanded in Alamofire's document. If you want to track the network state, check Alamofire's reachability document.

```swift
/// NetworkRequestError
///
/// - decodingError: Fail to decode.
/// - jsonParsingError: Fail to parse JSON.
/// - requestFailed: Reqeust failed, with error information attached.
/// - unknownError:  Unknown error.
/// - noNetwork:     No network connection.
public enum NetworkRequestError: Error {
  case decodingError(error: DecodingError)
  case jsonParsingError(error: Error)
  case requestFailed(information: RequestErrorInformation)
  case unknownError
  case noNetwork
}
```

Handling an error is easy. `RequestErrorInformation` contains the information you may need to handle an error. `error` is Alamofire's returned error. `statusCode` is something like 404, 401. `reponseBody` contains full information returned by server.

```swift
public struct RequestErrorInformation {
  
  /// Error returned from alamofire.
  let error: Error
  /// Error status code.
  let statusCode: Int?
  /// More error information, this could be returned error information from backend.
  let responseBody: JSON
  
  init(error: Error, data: Data?, urlResponse: HTTPURLResponse?) {
    self.error = error
    responseBody = JSON(data: data ?? Data())
    statusCode = urlResponse?.statusCode
  }
}
```

You can handle the error message by using `switch` or `if-let`.

```swift
let fetchUser = FetchUser()
fetchUser.perform().catch({ e in 
	// if-let statement
  if case let apiUnacceptable(errorInformation: errorInfo) = e {
    print(errorInfo)
  }
	
  // switch statement
  switch(e) {
  case let apiUnacceptable(errorInformation: errorInfo):
    print(errorInfo)
  default:
    break
  }
}) 
```

#### Things to know
1. GET method with parameters will need to change the encoding to URLEnconding.default, or it's gonna fail with no reason. This maybe Alamofire's bug or is just a RESTful api rule. Its also default setting in `NetworkRequest.swift`.
2. If you use OAuth 2.0, you can add your access token inside `NetworkRequest` extension.
3. Remember to set your base url, this url maybe an ip or a url to your server.
4. endpoint **DO** have to start with a `/`.
5. Beware of `endpoint` and `endPoint`. Sometimes you get an error that's telling you, you do not conform to `NetworkRequest` protocol, endpoint must be all lowercased characters!!!




