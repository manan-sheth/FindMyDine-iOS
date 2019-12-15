//
//  APIParser.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import Alamofire

class APIParser: NSObject {
    
    enum HTTPRequestType {
        case get
        case post
        case put
        case delete
    }
    
    //MARK:- Setup
    typealias completionHandler = (_ status: Bool, _ responseData: Any?, _ responseString: String?, _ errorMessage: CustomError?) -> Void
    
    //MARK:- Accessors
    static let sharedInstance = APIParser()
    
    //MARK:- Init
    private override init() {
        super.init()
    }
    
    //MARK:- API Headers
    private func getAPIHeaders() -> HTTPHeaders {
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/json"
        defaultHeaders["user-key"] = APIConstants.APIServer.serverKey
        return defaultHeaders
    }
    
    //MARK:- Weather Request
    func generateWeatherRequest(reqURL: String, reqHTTPMethod: HTTPRequestType, reqParams: String? = nil, reqBodyData: Any? = nil, responseCallBack: @escaping completionHandler) {
        
        let url = "\(APIConstants.APIServer.serverBaseURL)/\(reqURL)"
        guard let weatherURL = URL(string: url) else {
            let strErrorMsg: String = "URL is not reachable."
            responseCallBack(false, nil, strErrorMsg, CustomError.init(title: "", desc: strErrorMsg, code: 404, api: url))
            return
        }
        
        var request = URLRequest(url: weatherURL)
        request.timeoutInterval = APIConstants.APIServer.serverTimeout
        request.cachePolicy = .useProtocolCachePolicy
        
        request.httpMethod = reqHTTPMethod == .post ? "POST" : reqHTTPMethod == .put ? "PUT" : reqHTTPMethod == .delete ? "DELETE" : "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("en-us", forHTTPHeaderField: "Accept-Language")
        request.allHTTPHeaderFields = getAPIHeaders()
        
        if reqBodyData != nil {
            
            var jsonData: Data! = nil
            do {
                jsonData = try JSONSerialization.data(withJSONObject: reqBodyData!, options: [])
                request.httpBody = jsonData
                
                let requestJSON = String(data: jsonData, encoding: String.Encoding.utf8)
                print("JSON Request ==> \(requestJSON!)")
            }
            catch {
                print("Array to JSON conversion failed: \(error.localizedDescription)")
            }
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        else if let params = reqParams {
            
            print("API Request Data ==> \(params)")
            //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            if let newUrl = URL(string: "\(url)?\(params)") {
                request.url = newUrl
            }
        }
        
        self.restaurantAlamofireRequestToServer(ntRequest: request, responseCallBack: responseCallBack)
    }
    
    private func restaurantAlamofireRequestToServer(ntRequest: URLRequest, responseCallBack: @escaping completionHandler) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = APIConstants.APIServer.serverTimeout
        
        //Request to Server
        manager.request(ntRequest)
            .responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    print("Error ==> \(error)")
                    
                case .success(let responseObject):
                    print("Request ==> \((ntRequest.url)!)\n Response ==> \(responseObject)")
                }
                
                if let httpError = response.result.error {
                    
                    //TODO: HTTP ERROR
                    let statusCode = httpError._code
                    let strErrorMsg: String = self.getHTTPErrorMessage(status: statusCode)
                    responseCallBack(false, nil, strErrorMsg, CustomError.init(title: "", desc: strErrorMsg, code: statusCode, api: ntRequest.url!.absoluteString))
                }
                else {
                    //TODO: HTTP Response
                    let statusCode = response.response?.statusCode
                    
                    //TODO: Valid API Response - Data Parsing 😇
                    if statusCode == 200 {
                        
                        //Data Parsing
                        do {
                            if let data = response.data {
                                
                                if let dictResponse = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                    responseCallBack(true, dictResponse, "Data fetched successfully", nil)
                                }
                                else {
                                    let strErrorMsg: String = "Data not found"
                                    responseCallBack(false, nil, strErrorMsg, CustomError.init(title: "", desc: strErrorMsg, code: 200, api: ntRequest.url!.absoluteString))
                                }
                            }
                            else {
                                let strErrorMsg: String = self.getHTTPErrorMessage(status: response.response!.statusCode)
                                responseCallBack(false, nil, strErrorMsg, CustomError.init(title: "", desc: strErrorMsg, code: response.response!.statusCode, api: ntRequest.url!.absoluteString))
                            }
                        }
                        catch {
                            responseCallBack(false, nil, error.localizedDescription, CustomError.init(title: "", desc: error.localizedDescription, code: response.response!.statusCode, api: ntRequest.url!.absoluteString))
                        }
                    }
                    else {
                        let strErrorMsg: String = self.getHTTPErrorMessage(status: response.response!.statusCode)
                        responseCallBack(false, nil, strErrorMsg, CustomError.init(title: "", desc: strErrorMsg, code: statusCode ?? 404, api: ntRequest.url!.absoluteString))
                    }
                }
                return
        }
    }
    
    //MARK:- Server Error Messages
    private func getServerErrorMessage(status: Int, errMsg: String, api: String) -> CustomError {
        
        let error = CustomError.init(title: "", desc: errMsg, code: status, api: api)
        return error
    }
    
    //MARK:- Error Messages
    private func getHTTPErrorMessage(status: Int) -> String {
        
        var strMessage: String = ""
        
        switch status {
            
        //Server Errors
        case 400:
            strMessage = "The server cannot or will not process the request due to an apparent client error."
        case 401:
            strMessage = "Authentication is required and has failed or has not yet been provided."
        case 402:
            strMessage = "Authentication Required."
        case 403:
            strMessage = "The request was valid, but the server is refusing action. The user might not have the necessary permissions for a resource."
        case 404:
            strMessage = "The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible."
        case 500:
            strMessage = "A generic error message, given when an unexpected condition was encountered and no more specific message is suitable."
        case 502:
            strMessage = "The server was acting as a gateway or proxy and received an invalid response from the upstream server."
        case 503:
            strMessage = "The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
            
        //URL Errors
        case NSURLErrorUnknown:
            strMessage = "An unknown error occurred. Please try again in a while."
        case NSURLErrorCancelled:
            strMessage = "The connection was cancelled. Please try again in a while."
        case NSURLErrorBadURL:
            strMessage = "The connection failed due to a malformed URL. Please try again in a while."
        case NSURLErrorTimedOut:
            strMessage = "Looks like you have an unstable network at the moment. Please try again in a while."
        case NSURLErrorUnsupportedURL:
            strMessage = "The connection failed due to an unsupported URL scheme. Please try again in a while."
        case NSURLErrorCannotFindHost:
            strMessage = "The connection failed because the host could not be found. Please try again in a while."
        case NSURLErrorCannotConnectToHost:
            strMessage = "The connection failed because a connection cannot be made to the host. Please try again in a while."
        case NSURLErrorNetworkConnectionLost:
            strMessage = "The connection failed because the network connection was lost. Please try again in a while."
        case NSURLErrorDNSLookupFailed:
            strMessage = "The connection failed because the DNS lookup failed. Please try again in a while."
        case NSURLErrorHTTPTooManyRedirects:
            strMessage = "The HTTP connection failed due to too many redirects. Please try again in a while."
        case NSURLErrorResourceUnavailable:
            strMessage = "The connection’s resource is unavailable. Please try again in a while."
        case NSURLErrorNotConnectedToInternet:
            strMessage = "The connection failed because the device is not connected to the internet. Please try again in a while."
        case NSURLErrorRedirectToNonExistentLocation:
            strMessage = "The connection was redirected to a nonexistent location. Please try again in a while."
        case NSURLErrorBadServerResponse:
            strMessage = "The connection received an invalid server response. Please try again in a while."
        case NSURLErrorUserCancelledAuthentication:
            strMessage = "The connection failed because the user cancelled required authentication. Please try again in a while."
        case NSURLErrorUserAuthenticationRequired:
            strMessage = "The connection failed because authentication is required. Please try again in a while."
        case NSURLErrorZeroByteResource:
            strMessage = "The resource retrieved by the connection is zero bytes. Please try again in a while."
        case NSURLErrorCannotDecodeRawData:
            strMessage = "The connection cannot decode data encoded with a known content encoding. Please try again in a while."
        case NSURLErrorCannotDecodeContentData:
            strMessage = "The connection cannot decode data encoded with an unknown content encoding. Please try again in a while."
        case NSURLErrorCannotParseResponse:
            strMessage = "The connection cannot parse the server’s response. Please try again in a while."
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            strMessage = "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection. Please try again in a while."
        case NSURLErrorFileDoesNotExist:
            strMessage = "The file operation failed because the file does not exist. Please try again in a while."
        case NSURLErrorFileIsDirectory:
            strMessage = "The file operation failed because the file is a directory. Please try again in a while."
        case NSURLErrorNoPermissionsToReadFile:
            strMessage = "The file operation failed because it does not have permission to read the file. Please try again in a while."
        case NSURLErrorDataLengthExceedsMaximum:
            strMessage = "The file operation failed because the file is too large. Please try again in a while."
            
        //SSL Errors
        case NSURLErrorSecureConnectionFailed:
            strMessage = "The secure connection failed for an unknown reason. Please try again in a while."
        case NSURLErrorServerCertificateHasBadDate:
            strMessage = "The secure connection failed because the server’s certificate has an invalid date. Please try again in a while."
        case NSURLErrorServerCertificateUntrusted:
            strMessage = "The secure connection failed because the server’s certificate is not trusted. Please try again in a while."
        case NSURLErrorServerCertificateHasUnknownRoot:
            strMessage = "The secure connection failed because the server’s certificate has an unknown root. Please try again in a while."
        case NSURLErrorServerCertificateNotYetValid:
            strMessage = "The secure connection failed because the server’s certificate is not yet valid. Please try again in a while."
        case NSURLErrorClientCertificateRejected:
            strMessage = "The secure connection failed because the client’s certificate was rejected. Please try again in a while."
        case NSURLErrorClientCertificateRequired:
            strMessage = "The secure connection failed because the server requires a client certificate. Please try again in a while."
        case NSURLErrorCannotLoadFromNetwork:
            strMessage = "The connection failed because it is being required to return a cached resource, but one is not available. Please try again in a while."
            
        //Download and file I/O Errors
        case NSURLErrorCannotCreateFile:
            strMessage = "The file cannot be created. Please try again in a while."
        case NSURLErrorCannotOpenFile:
            strMessage = "The file cannot be opened. Please try again in a while."
        case NSURLErrorCannotCloseFile:
            strMessage = "The file cannot be closed. Please try again in a while."
        case NSURLErrorCannotWriteToFile:
            strMessage = "The file cannot be written. Please try again in a while."
        case NSURLErrorCannotRemoveFile:
            strMessage = "The file cannot be removed. Please try again in a while."
        case NSURLErrorCannotMoveFile:
            strMessage = "The file cannot be moved. Please try again in a while."
        case NSURLErrorDownloadDecodingFailedMidStream:
            strMessage = "The download failed because decoding of the downloaded data failed mid-stream. Please try again in a while."
        case NSURLErrorDownloadDecodingFailedToComplete:
            strMessage = "The download failed because decoding of the downloaded data failed to complete. Please try again in a while."
            
        case NSURLErrorInternationalRoamingOff:
            strMessage = "The connection failed because international roaming is disabled on the device. Please try again in a while."
        case NSURLErrorCallIsActive:
            strMessage = "The connection failed because a call is active. Please try again in a while."
        case NSURLErrorDataNotAllowed:
            strMessage = "The connection failed because data use is currently not allowed on the device. Please try again in a while."
        case NSURLErrorRequestBodyStreamExhausted:
            strMessage = "The connection failed because its request’s body stream was exhausted. Please try again in a while."
            
        //Background Session Errors
        case NSURLErrorBackgroundSessionRequiresSharedContainer:
            strMessage = "Background session required shared container at the moment. Please try again in a while."
        case NSURLErrorBackgroundSessionInUseByAnotherProcess:
            strMessage = "Background session is in use by another network process at the moment. Please try again in a while."
        case NSURLErrorBackgroundSessionWasDisconnected:
            strMessage = "Background session disconnected. Please try again in a while."
            
        default:
            strMessage = "Looks like you have an unstable network at the moment. Please try again in a while."
        }
        return strMessage
    }
}

//MARK:- Custom Error
protocol ErrorProtocol: Error {
    
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var requestedAPI: String { get }
    var code: Int { get }
}

struct CustomError: ErrorProtocol {
    
    var localizedTitle: String
    var localizedDescription: String
    var requestedAPI: String
    var code: Int
    
    init(title: String?, desc: String, code: Int, api: String) {
        self.localizedTitle = title ?? "Error"
        self.localizedDescription = desc
        self.code = code
        self.requestedAPI = api
    }
}
