# Code coverage for multiple Go packages

This coverage script is originally created by mlafeldt

See the following link for original version
https://github.com/mlafeldt/chef-runner/blob/v0.7.0/script/coverage

## Modification

* Remove absolute path generated in .cover/*.cover
 
## Original document

Generate test coverage statistics for Go packages.

Works around the fact that `go test -coverprofile` currently does not work
with multiple packages, see https://code.google.com/p/go/issues/detail?id=6909

```
Usage: script/coverage [--html|--coveralls]

     --html      Additionally create HTML report and open it in browser
     --coveralls Push coverage statistics to coveralls.io
```