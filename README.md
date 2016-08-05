[![CocoaPods](https://img.shields.io/cocoapods/v/HTZNetworkingManager.svg)](https://github.com/toohotz/HotzNetworkingManager.git)
[![License](https://img.shields.io/dub/l/vibe-d.svg)](https://opensource.org/licenses/MIT)

# HTZNetworkingManager
___
Personal Alamofire built upon wrapper for web server API endpoint requests with *Result* closure callback for more succinct error handling.  Utilizing the Facade pattern ensures only one networking manager instance exists per app life cycle. This framework wrapper was created wtih the intention of making web server endpoint requests faster to setup and easily customizable.

### Dependencies
* [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking library written in Swift.

### Requirements

- iOS 10.0+ 
- Xcode 8.0+

## Installation
----

### CocoaPods
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!
pod 'Alamofire'
pod 'HTZNetworkingManager'
```
Afterwards run a pod install.
```bash
$ pod install
```

### Manually

If project integration is your style (which I have personally done in a current project due to Xcode 7+ and Cocoapod issue with physical device testing). 

#### Embedded Framework
- Initialize a git repo in the root of your project directory if you have not done so already.  
- Add HTZNetworkingManager 
```bash
$ git submodule add https://github.com/toohotz/HotzNetworkingManager.git
```
Open *HTZNetworkingManager* folder and drag the project file named `HTZNetworkingManager.xcodeproj` into your application's Xcode project.

![Img1](http://f.cl.ly/items/0v0p2i3D0U3c442n010m/Screen%20Shot%202016-02-03%20at%202.54.17%20PM.png)

## Usage

After importing the module, making requests are similar to how requests are made using Alamofire.
Since we are expecting to be dealing with endpoint requests, we instantiate a baseURL that will be used as endpoints are appended to form the URL for a given request. **Note:** Requests will fail to execute if the baseURL has not been set prior to making an API call.  

Once set, instantiate an instance of `HTZNetworkingFacade.sharedInstance` and assign a baseURL.

From here, making requests works in a similar fashion to Alamofire requests like so:

``` swift
let networkingFacade = HTZNetworkingFacade.sharedInstance
networkingFacade.networkingManager.getDataFromEndPoint(“/someEndpoint”) { (responseData) -> () in
}
```
If you have not dabbed with Alamofire since 3.0 with its new type * Result *, utilizing functional programming we can now work with expected results rather than an optional which is for the better for two main reasons.

-	We can expect our result to exist if our closure returns a success for the Result value
-	In the event of an error, we are forced due to the Result type to handle our errors in code as it is tied to the closure Result type that we are expecting

Since error checking is compile time enforced, error handling for your specific API calls should also handle most (ideally all) of the possible errors that can occur relating to your network request being made.

#### Response data handling

Since code speaks better, handling a typical response would look like so:

``` swift 
switch responseData {
case .success(let validResponse):
// Do something with the response received
case .failure(let NetworkingError.responseError(errorDescription)):
// Handle the error accordingly
}
```
And that’s it.

Using the framework to handle responses is great but becomes better when subclassed to better handle the expected responses.

#### Example

A class that will be used to retrieve the Users for our application.
``` swift
class UserbaseFacade: HTZNetworkingFacade
```
Override the initializer to set the baseURL.

``` swift
self.networkingManager.baseURL = UserBaseFacadeEndpoint.baseURL.rawValue

```
Here you’ll notice that an enum is being used here, within the subclasses it is handy to use enum with raw values of strings as opposed to multiple string constants to easily keep track of specific endpoints like so

``` swift

enum UserBaseFacadeEndpoint: String {
	case baseURL = "someBaseURL"
	case retrieveAllUsers = "/getAllUsers"
	case getUser = "/getUser/"
}
```

Then we can wrap our subclass APIs around the underlying frameworks’s API calls like so

#### Making the API
``` swift
func retrieveAllUsers(userData: Result<[Users], UserNetworkError> -> () )
{

}
```
Here our expected response will be either a list of users or a custom error object that should handle all of our possible errors with a last case to handle an unexpected error (such as from the network itself). An example of that would look like this:

``` swift
enum UserNetworkError: Error {
	case noUsersFound
	// Our unexpected error handling case here
	case searchRequestFailed(String)
}
```
The body of our API would then look like so:

``` swift
// Make the call to the underlying networking API
self.networkingManager.getDataFromEndPoint(UserbaseFacadeEndpoint.retrieveAllUsers.rawValue) { (responseData) -> () in 
	switch responseData {
	case .success(let rawUserData):
	// Parse the data *NOTE for example sake we are just casting our response to the desired callback type*
	let parsedUsers = rawUserData as! [Users]
	// Here we check if no users were returned we callback with our custom .noUsersFound error
	if parsedUsers?.isEmpty == true {
                    userData(.failure(UserNetworkError.noUsersFound))
    }
    userData(.success(parsedUsers))
    
    // Our default error handling case
    
    case .failure(let NetworkingError.responseError(responseError)):
    // Passing along the error description that we received
    userData(.failure(UserNetworkError.SearchRequestFailed(responseError))
	}
}
```
#### Handling the response
From a View Controller that is looking for a list of users to update its tableview with, our API call to retrieve those users would look like this:

``` swift
let userFacade = UserBaseFacade()

userFacade.retrieveAllUsers{ (userResponse) -> () in 
	switch userResponse {
	case .Success(let users):
	// Do something with the list of users
	case .failure(let UserNetworkError.noUsersFound):
	print("No users were found.")
	case .failure(let UserNetworkError.SearchRequestFailed(responseString)):
	print(responseString)
	}
}
```

### Credits

Much goes out to the Alamofire Software Foundation for being the bedrock of how this framework wrapper functions.

