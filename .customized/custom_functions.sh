# Perf
function perf {
  curl -o /dev/null  -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
}

function make_docker() {
    IMG_NAME=${IMG}

    if [[ ! -f "$(pwd)/Makefile" ]];then
        echo "Please place yourself in the right folder (E.G: /Users/jparrill/RedHat/RedHat_Engineering/hypershift/repos/jparrill-hypershift)"
        return 1
    fi

    if [[ -z ${IMG_NAME} ]];then
        echo "Please specify the Image Name for the build"
        exit 1
    fi

    if [[ ! -e "${HOME}/.orbstack/run/docker.sock" ]];then
        echo "Booting Orbstack"
        osascript -e 'launch app "Orbstack"'
        sleep 10
    fi

    echo "Docker Build: "
    echo "=================="
    echo "PWD: $(pwd)"
    echo "Docker Image: ${IMG}"
    echo "Build Command: docker build . --platform=linux/amd64 -t ${IMG}"
    echo "Push Command: docker push ${IMG}"

    read


    docker build . --platform=linux/amd64 -t ${IMG}
    docker push ${IMG}

}


function bootKind() {
    CURR_FOLDER=$(pwd)
    HACK_PATH=/Users/jparrill/RedHat/RedHat_Engineering/hypershift/repos/k8s-dev-env/hack
    SOURCE_PATH=${HACK_PATH}/kind

    if [[ ! -e "${HOME}/.orbstack/run/docker.sock" ]];then
        echo "Booting Orbstack"
        osascript -e 'launch app "Orbstack"'
        sleep 10
    fi

    cd ${SOURCE_PATH}
    echo "Deploying Kind"
    ${SOURCE_PATH}/deploy-kind.sh
    if [[ $? != 0 ]];then
        cd ${CURR_FOLDER}
        echo "Error launching Kind cluster"
        exit -1
    fi

    cd ${CURR_FOLDER}
}

function shutKind() {
    kind delete cluster
}

function luxafor() {
    if [[ -z "${1}" ]];then
    	echo "give me a color"
    	exit 1
    fi
    
    case ${1} in
        green)
            /usr/bin/curl -s https://api.luxafor.com/webhook/v1/actions/solid_color -H 'Content-Type: application/json' -d '{"userId": "$(pass Luxafor/userId)", "actionFields":{"color":"green"}}' -o /dev/null
        ;;
        red)
    	    /usr/bin/curl -s https://api.luxafor.com/webhook/v1/actions/solid_color -H 'Content-Type: application/json' -d '{"userId": "$(pass Luxafor/userId)", "actionFields":{"color":"red"}}' -o /dev/null
        ;;
        white)
    	    /usr/bin/curl -s https://api.luxafor.com/webhook/v1/actions/solid_color -H 'Content-Type: application/json' -d '{"userId": "$(pass Luxafor/userId)", "actionFields":{"color":"white"}}' -o /dev/null
        ;;
        *)
    	    echo "color not supported"
    	    exit 1
        ;;
    esac
}

function luxafor_enable() {
    osascript -e 'launch app "Luxafor"'
    door_status=$(curl -s -X GET http://192.168.1.99:8123/api/states/binary_sensor.lumi_lumi_sensor_magnet_ee264b02_on_off -H "Authorization: Bearer $(pass Luxafor/bearer)" -H "Content-Type: application/json"  | jq '.state')

    if [[ "$door_status" == "\"on\"" ]];then
        luxafor "red"
    else
        luxafor "green"
    fi
}

function luxafor_disable() {
    luxafor "white"
    sleep 1
    osascript -e 'quit app "Luxafor"'
}

function connect_virt_manager() {
  host=$1
  if [[ -z "$1" ]];then
    echo "You need to provide it in the user@host format"
    exit 1
  fi
  echo "Connecting..."
  echo "Command: virt-manager -c qemu+ssh://$host/system?socket=/var/run/libvirt/libvirt-sock"
  virt-manager -c "qemu+ssh://$host/system?socket=/var/run/libvirt/libvirt-sock"
}

function update() {
    echo "Updating Brew packages..."
    arch -arm64 brew upgrade
    echo "Updating NeoVim Plugins..."
    vim +PlugUpdate +qall
    echo "Updating Rust..."
    rustup update
    echo "Updating Oh-my-ZSH..."
    omz update
}

function test-hp() {
    #set -euo pipefail
    set -o monitor
    set +x

    export OCP_IMAG_PREVIOUS=${OCP_IMAGE:-"quay.io/openshift-release-dev/ocp-release:4.14.0-ec.1-x86_64"}
    export OCP_IMAGE_LATEST=${OCP_IMAGE:-"quay.io/openshift-release-dev/ocp-release:4.14.0-ec.1-x86_64"}
    export ARTIFACT_DIR=${ARTIFACT_DIR:-"/tmp/clusters"}
    export AWSREGION=${REGION:-us-west-1}
    export BUCKET_NAME=jparrill-hosted-${AWSREGION}
    #export BUCKET_NAME=jparrill-hosted-us-east-1
    ##export REGION=us-east-1
    export AWS_CREDS=~/.aws/credentials
    gvm use go1.19

    rm -rf ${ARTIFACT_DIR}
    mkdir -p ${ARTIFACT_DIR}

    if [[ ! -f "$(pwd)/Makefile" ]];then
        echo "Please place yourself in the right folder (E.G: /Users/jparrill/RedHat/RedHat_Engineering/hypershift/repos/jparrill-hypershift)"
        return 1
    fi

    if [[ -z "${KUBECONFIG}" ]]; then
        echo "Please set Kubeconfig ENV var to deploy HostedCluster environment"
        return 1
    fi

    if [[ ${KUBECONFIG} == "/Users/jparrill/RedHat/RedHat_Engineering/hypershift/AWS/Kubeconfig" ]];then
        echo "Root CI Kubeconfig set, please change it"
        return 1
    fi

    rm -rf "$(pwd)/bin/{test-e2e,test-setup}"
    make e2e

    if [[ $? != 0 ]];then
        echo "Compilation fail!!"
        return 1
    fi

    #CI_TESTS_RUN=${1:-TestNodePool}
    CI_TESTS_RUN=${1}

    if [[ ${CI_TESTS_RUN} ]];then 
        echo "Provide the E2E Test to run"
        exit 1
    fi

    bin/test-e2e \
      -test.v \
      -test.timeout=10h \
      -test.run=${CI_TESTS_RUN} \
      -test.parallel=20 \
      --e2e.aws-credentials-file=/Users/jparrill/.aws/credentials \
      --e2e.aws-zones=${AWSREGION}b \
      --e2e.aws-region=${AWSREGION} \
      --e2e.node-pool-replicas=2 \
      ##--e2e.external-dns-domain="jpdev.hypershift.devcluster.openshift.com" \
      --e2e.pull-secret-file=/Users/jparrill/RedHat/RedHat_Engineering/pull_secret.json \
      --e2e.latest-release-image="${OCP_IMAGE_LATEST}" \
      --e2e.previous-release-image="${OCP_IMAGE_PREVIOUS}" \
      --e2e.additional-tags="expirationDate=$(date "+%Y-%m-%dT%H:%M+%S:00")" \
      --e2e.skip-api-budget=true \
      --e2e.base-domain=jpdev.hypershift.devcluster.openshift.com | tee /tmp/test_out 

    set +o monitor
    set +x
}


function create_kubeconfig() {
    export BASE_PATH=/Users/jparrill/RedHat/RedHat_Engineering/hypershift
    export BIN=${BASE_PATH}/repos/hypershift/bin/hypershift
    export HC_PATH=${BASE_PATH}/hosted_clusters
    export NS=${1}
    export NAME=${2}

    if [[ -z "$1" ]];then
      echo "Gimme a NS"
      exit 1
    fi

    if [[ -z "$2" ]];then
      echo "Gimme a HC Name"
      exit 1
    fi

    echo "Variables Debug: "
    echo "=================="
    echo "HC Name: ${NAME}"
    echo "HC Namespace: ${NS}"

    read
    mkdir -p ${HC_PATH}/${NS}-${NAME}
    ${BIN} create kubeconfig --name ${NAME} --namespace ${NS} > ${HC_PATH}/${NS}-${NAME}/kubeconfig
    echo "export KUBECONFIG=${HC_PATH}/${NS}-${NAME}/kubeconfig"
}

function get_kubeadmin_password() {
    export NS=${1}
    export NAME=${2}

    if [[ -z "$1" ]];then
      echo "Gimme a NS"
      exit 1
    fi

    if [[ -z "$2" ]];then
      echo "Gimme a HC Name"
      exit 1
    fi

    if [[ -z ${KUBECONFIG} ]];then
        echo "Export a valid Kubeconfig"
        exit 1
    fi

    echo "Variables Debug: "
    echo "=================="
    echo "HC Name: ${NAME}"
    echo "HC Namespace: ${NS}"
    echo "Kubeconfig: ${KUBECONFIG}"

    read
    PASS=$(oc get secret -n ${NS}-${NAME} kubeadmin-password -o jsonpath='{.data.password}' | base64 -d)
    echo "Kubeadmin Password: ${PASS}"
}

