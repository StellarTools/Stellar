import Foundation

// NOTE:
// We cannot use @main on StellarCLICommand since
// we should call our implementation in order to forward
// commands; with @main our main() func will be never called.
StellarCLICommand.main(arguments: CommandLine.arguments)
