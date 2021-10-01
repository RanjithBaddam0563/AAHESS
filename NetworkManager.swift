//
//  NetworkManager.swift
//  Alain
//
//  Created by MicroExcel on 6/8/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {

    static let shared = NetworkManager()

    var unsecure: SessionManager!
    var serverTrustPolicies: [String: ServerTrustPolicy] = ["unsecureSslHostname":.disableEvaluation]

    private init () {
        self.unsecure = { () -> SessionManager in
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            return SessionManager(
                configuration: configuration,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies)
            )
        }()
    }
}
