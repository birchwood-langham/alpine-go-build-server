#!/usr/bin/env sh

if [[ ! -z ${BRANCH} ]] && [[ ! -z ${TAG} ]]; then
    echo "Cannot use both BRANCH and TAG, please use only one"
    exit 1
fi

if [[ -z ${USE_DEP} ]]; then
    USE_DEP=false
fi

if [[ -z ${CREATE_TARBALL} ]]; then
    CREATE_TARBALL=false
fi

if [[ -z ${PROJECT_PATH} ]] || [[ -z ${OUTPUT_PATH} ]] || [[ -z ${MAIN_PATH} ]]; then
    echo 'PROJECT_PATH, OUTPUT_PATH, MAIN_PATH must be defined'
    exit 1
fi

if [[ -z ${USE_GITLAB} ]]; then
    if [[ -n ${TOKEN} ]]; then
        echo 'Setting redirect for private GitHub repo'
        git config --global url."https://$TOKEN@github.com".insteadOf "https://github.com"
    fi
    
    PROJECT_URL=https://github.com/${PROJECT_PATH}
else
    if [[ -n ${TOKEN} ]]; then 
        echo 'Setting redirect for private GitLab repo'
        git config --global url."https://oauth2:$TOKEN@gitlab.com".insteadOf "https://gitlab.com"
    fi

    PROJECT_URL=https://gitlab.com/${PROJECT_PATH}
fi

if [[ ${USE_DEP} = true ]]; then 
    cd $GOPATH/src/gitlab.com/${PROJECT_PATH}
else 
    cd /build
fi

PROJECT=`echo ${PROJECT_URL##*/} | cut -d '.' -f 1`

echo Cloning project from ${PROJECT_URL}

if [[ -z ${BRANCH} ]]; then
    git clone ${PROJECT_URL}
else
    git clone --single-branch --branch ${BRANCH} ${PROJECT_URL}
fi

cd $PROJECT

if [[ ! -z ${TAG} ]]; then 
    echo Checking out tag: ${TAG}
    git checkout tags/${TAG}
fi

if [[ ${USE_DEP} = true ]]; then 
    dep ensure
else
    go get
fi

## we compile and force recompile dependencies without C dependencies
go build -a -installsuffix cgo -o ${OUTPUT_PATH} ${MAIN_PATH}

if [[ $CREATE_TARBALL = true ]]; then
    rm -rf .git

    cd ..
    tar -czf "${PROJECT}.tar.gz" ${PROJECT}
    cp "${PROJECT}.tar.gz" $(dirname ${OUTPUT_PATH})/
fi

