//  Initializer.swift

import Foundation

final public class Initializer {
    
    public init() {}
    
    public func install(at location: URL, templatesLocation: URL) throws {
        let urlManager = URLManager()
        let packagesLocation = urlManager.packagesUrl(at: location)
        
        let packageDotSwiftTemplateLocation = templatesLocation
            .appendingPathComponent("Package.stencil", isDirectory: false)
        let readmeTemplateLocation = templatesLocation
            .appendingPathComponent("README.stencil", isDirectory: false)
        let taskTemplateLocation = templatesLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("SampleTask.stencil", isDirectory: false)
        let executorTemplateLocation = templatesLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Executor.stencil", isDirectory: false)
        let testsTemplateLocation = templatesLocation
            .appendingPathComponent("Tests", isDirectory: true)
            .appendingPathComponent("Tests.stencil", isDirectory: false)
        
        let taskManager = TaskManager()
        try taskManager
            .createFolder(at: packagesLocation, name: Constants.executor)
        let executorLocation = try urlManager.existingExecutorUrl(at: location)
        do {
            try taskManager
                .initPackage(at: executorLocation)
                .createPackageDotSwift(packageName: Constants.executor,
                                       templateLocation: packageDotSwiftTemplateLocation,
                                       packageLocation: executorLocation)
                .createReadme(packageName: Constants.executor,
                              templateLocation: readmeTemplateLocation,
                              packageLocation: executorLocation)
                .deleteSourcesFolder(packageLocation: executorLocation)
                .deleteTestsFolder(packageLocation: executorLocation)
                .createExecutorSourceFile(packageName: Constants.executor,
                                          templateLocation: taskTemplateLocation,
                                          packageLocation: executorLocation)
                .createExecutorSourceFile(packageName: Constants.executor,
                                          templateLocation: executorTemplateLocation,
                                          packageLocation: executorLocation)
                .createTest(packageName: Constants.executor,
                            templateLocation: testsTemplateLocation,
                            packageLocation: executorLocation)
        } catch {
            Logger().log(error.localizedDescription)
            try taskManager
                .deletePackage(at: executorLocation)
        }
    }
}
