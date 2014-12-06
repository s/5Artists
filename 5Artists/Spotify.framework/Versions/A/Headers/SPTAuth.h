//
//  SPTAuth.h
//  SPTAuth
//
//  Created by Daniel Kennett on 27/08/2013.

#import <Foundation/Foundation.h>

/** Scope that lets you stream music. */
FOUNDATION_EXPORT NSString * const SPTAuthStreamingScope;

/** Scope that lets you read private playlists of the authenticated user. */
FOUNDATION_EXPORT NSString * const SPTAuthPlaylistReadPrivateScope;

/** Scope that lets you modify public playlists of the authenticated user. */
FOUNDATION_EXPORT NSString * const SPTAuthPlaylistModifyPublicScope;

/** Scope that lets you modify private playlists of the authenticated user. */
FOUNDATION_EXPORT NSString * const SPTAuthPlaylistModifyPrivateScope;

/** Scope that lets you read email from the authenticated user. */
FOUNDATION_EXPORT NSString * const SPTAuthUserReadEmailScope;

/** Scope that lets you read the private user information of the authenticated user. */
FOUNDATION_EXPORT NSString * const SPTAuthUserReadPrivateScope;

/** Scope that lets you read user's Your Music library. */
FOUNDATION_EXPORT NSString * const SPTAuthUserLibraryReadScope;

/** Scope that lets you modify user's Your Music library. */
FOUNDATION_EXPORT NSString * const SPTAuthUserLibraryModifyScope;

@class SPTSession;

/**
 This class provides helper methods for authenticating users against the Spotify OAuth
 authentication service.
 */
@interface SPTAuth : NSObject

typedef void (^SPTAuthCallback)(NSError *error, SPTSession *session);

///----------------------------
/// @name Convenience Getters
///----------------------------

/**
 Returns a pre-created `SPTAuth` instance for convenience.

 @return A pre-created default `SPTAuth` instance.
 */
+(SPTAuth *)defaultInstance;

///----------------------------
/// @name Starting Authentication
///----------------------------

/**
 Returns a URL that, when opened, will begin the Spotify authentication process.

 @warning You must open this URL with the system handler to have the auth process
 happen in Safari. Displaying this inside your application is against the Spotify ToS.

 @param clientId Your client ID as declared in the Spotify Developer Centre.
 @param declaredURL Your callback URL as declared in the Spotify Developer Centre.
 @return The URL to pass to `UIApplication`'s `-openURL:` method.
 */
-(NSURL *)loginURLForClientId:(NSString *)clientId declaredRedirectURL:(NSURL *)declaredURL;

/**
 Returns a URL that, when opened, will begin the Spotify authentication process.

 @warning You must open this URL with the system handler to have the auth process
 happen in Safari. Displaying this inside your application is against the Spotify ToS.

 @param clientId Your client ID as declared in the Spotify Developer Centre.
 @param declaredURL Your callback URL as declared in the Spotify Developer Centre.
 @param scopes The custom scopes to request from the auth API.
 @return The URL to pass to `UIApplication`'s `-openURL:` method.
 */
-(NSURL *)loginURLForClientId:(NSString *)clientId declaredRedirectURL:(NSURL *)declaredURL scopes:(NSArray *)scopes;

/**
 Returns a URL that, when opened, will begin the Spotify authentication process.

 @warning You must open this URL with the system handler to have the auth process
 happen in Safari. Displaying this inside your application is against the Spotify ToS.

 @param clientId Your client ID as declared in the Spotify Developer Centre.
 @param declaredURL Your callback URL as declared in the Spotify Developer Centre.
 @param scopes The custom scopes to request from the auth API.
 @param responseType Authentication response code type, defaults to "code", use "token" if you want to bounce directly to the app without refresh tokens.
 @return The URL to pass to `UIApplication`'s `-openURL:` method.
 */
-(NSURL *)loginURLForClientId:(NSString *)clientId declaredRedirectURL:(NSURL *)declaredURL scopes:(NSArray *)scopes withResponseType:(NSString *)responseType;

///----------------------------
/// @name Handling Authentication Callback URLs
///----------------------------

/**
 Find out if the given URL appears to be a Spotify authentication URL.

 This method is useful if your application handles multiple URL types. You can pass every URL
 you receive through here to filter them.

 @param callbackURL The complete callback URL as triggered in your application.
 @param declaredURL Your pre-defined callback URL as declared in the Spotify Developer Centre.
 @return Returns `YES` if the callback URL appears to be a Spotify auth callback, otherwise `NO`.
 */
-(BOOL)canHandleURL:(NSURL *)callbackURL withDeclaredRedirectURL:(NSURL *)declaredURL;

/**
 Check if "flip-flop" application authentication is supported.
 @return YES if supported, NO otherwise.
 */
-(BOOL)supportsApplicationAuthentication;

/**
 Check if Spotify application is installed.
 @return YES if installed, NO otherwise.
 */
-(BOOL)spotifyApplicationIsInstalled;

/**
 Handle a Spotify authentication callback URL, returning a Spotify username and OAuth credential.

 This URL is obtained when your application delegate's `application:openURL:sourceApplication:annotation:`
 method is triggered. Use `-[SPTAuth canHandleURL:withDeclaredRedirectURL:]` to easily filter out other URLs that may be
 triggered.

 @param url The complete callback URL as triggered in your application.
 @param block The callback block to be triggered when authentication succeeds or fails.
 */
-(void)handleAuthCallbackWithTriggeredAuthURL:(NSURL *)url callback:(SPTAuthCallback)block;

/**
 Handle a Spotify authentication callback URL, returning a Spotify username and OAuth credential.

 This URL is obtained when your application delegate's `application:openURL:sourceApplication:annotation:`
 method is triggered. Use `-[SPTAuth canHandleURL:withDeclaredRedirectURL:]` to easily filter out other URLs that may be
 triggered.

 @note This method requires that you have a Spotify token swap service running and available.

 @param url The complete callback URL as triggered in your application.
 @param tokenSwapURL The URL of your token swap service endpoint.
 @param block The callback block to be triggered when authentication succeeds or fails.
 */
-(void)handleAuthCallbackWithTriggeredAuthURL:(NSURL *)url tokenSwapServiceEndpointAtURL:(NSURL *)tokenSwapURL callback:(SPTAuthCallback)block;

///----------------------------
/// @name Renewing Sessions
///----------------------------

/**
 Request a new access token using an existing SPTSession object containing a refresh token.

 @param session An SPTSession object with a valid refresh token.
 @param endpointURL The URL of the service that requests an access token using the refresh token.
 @param block The callback block that will be invoked when the request has been performed.
 */
-(void)renewSession:(SPTSession *)session withServiceEndpointAtURL:(NSURL *)endpointURL callback:(SPTAuthCallback)block;

@end
