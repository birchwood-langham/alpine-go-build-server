# Alpine Linux Go Build Server

This build server allows you to checkout Go projects from GitLab and build them so they can be run on Alpine Linux. It supports managed dependencies through Go Modules (Go 1.11+) or Dep.

The following environment variables are supported when starting the build server:

| Environment Variable | Required | Notes | Example |
| -------------------- | -------- | ----- | ------- |
| PROJECT_PATH | Y | The path to the remote repository (do not include the http://gitlab.com/) | bl-paladin/nsa-backoffice/go-projects/go-protobuf-messages.git |
| TOKEN | Y | The access token to the repo account | Secret! Don't tell anyone! |
| OUTPUT_PATH | Y | Where to write the output of the build | /output/name-of-application |
| MAIN_PATH | Y | The path to the main() function that will launch the application, can be left empty | server/server.go |
| BRANCH | N | Specify the branch to check out and buildd | hotfix/my-hotfix
| TAG | N | Specify a specific tag to checkout and build | v1.0.0 
| USE_DEP | N | If set to true, then project uses GOPATH file structure and dep to manage dependencies, otherwise assumes Go Modules | |
| CREATE_TARBALL | N | If set to true, a tarball with all the project code will be zipped and placed in the output folder with the executable | |

### Example

The following snippet will launch a build server and pull the project using the token you specify and put the executable generated 
in the specified output path. The output path is volume mapped to your current directory on the docker host.

```bash 
docker run --rm -v $PWD:/output \
    -e PROJECT_PATH=path/to/project.git \
    -e OUTPUT_PATH=/output/myapp \
    -e MAIN_PATH=app/main.go
    -e TOKEN=Secret!Shh!!! \
    birchwoodlangham/alpine-go-build-server:latest
```

### Branches and Tags

If your project is not on the master branch, or you just want to build from a particular branch instead of the master branch, you can specify the branch to
check out your code from by setting the BRANCH environment variable

If not provided, the master branch will be used to do the build, to use a release tag instead, provide the Tag to use by setting the TAG environment variable.

> NOTE:
> 
> Do not specify both branch and tag environment variables, it doesn't make sense to do so, you're either compile a specific version on a specific branch
> or you're compiling a tagged version.

#### Branches and Tags Examples

1. The following snippet will launch a build server and pull the project from a development branch using the token you specify and put the executable generated 
in the specified output path. The output path is volume mapped to your current directory on the docker host.

```bash 
docker run --rm -v $PWD:/output \
    -e BRANCH=dev \
    -e PROJECT_PATH=path/to/project.git \
    -e OUTPUT_PATH=/output/myapp \
    -e MAIN_PATH=app/main.go
    -e TOKEN=Secret!Shh!!! \
    birchwoodlangham/alpine-go-build-server:latest
```

2. If the project uses something that doesn't currently support Go Modules and uses the GOPATH file structure and `dep` to manage the dependencies, then we can pass the USE_DEP
flag.

```bash 
docker run --rm -v $PWD:/output \
    -e BRANCH=dev \
    -e PROJECT_PATH=path/to/project.git \
    -e OUTPUT_PATH=/output/myapp \
    -e TOKEN=Secret!Shh!!! \
    -e MAIN_PATH=app/main.go
    -e USE_DEP=true \
    birchwoodlangham/alpine-go-build-server:latest
```

3. If you want to compile a particular tagged release using Dep

```bash 
docker run --rm -v $PWD:/output \
    -e TAG=1.0.0 \
    -e PROJECT_PATH=path/to/project.git \
    -e OUTPUT_PATH=/output/myapp \
    -e MAIN_PATH=app/main.go
    -e TOKEN=Secret!Shh!!! \
    -e USE_DEP=true \
    birchwoodlangham/alpine-go-build-server:latest
```
