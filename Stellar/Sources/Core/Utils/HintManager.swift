//
//  File.swift
//  
//
//  Created by Pasquale Cerqua on 21/01/23.
//

import Foundation


class HintManager {
    
    func hintForAction(with name: String) -> String {
        let hint = """
        
        
        Add the newly created action to the Executor's Package.swift.
        
            ...
            dependencies: [
                ...
                .package(path: "../../Actions/\(name)")
                ...
            ],
            ...
            targets: [
                ...
                .target(
                    ...
                    dependencies: [
                            ...
                            .product(name: "\(name)", package: "\(name)"),
                            ...
                    ])
                    ...
            ]
            ...
        
        
        """
        return hint
    }
    
}



