#!/bin/bash

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"
cd $SCRIPT_HOME



build_browserNode() {
        sudo docker build -t selenium/standalone-firefox:2.46.0 .
}
start_browserNode() {
        sudo docker run --name browserNode \
                -p   4443:4444  \
                -e '' \
                -d selenium/standalone-firefox:2.46.0 
}

stop_browserNode() {
        sudo docker stop browserNode
        sudo docker rm browserNode
}


build_browserServer() {
        sudo docker build -t bitliner/browser-server .
}
start_browserServer() {
        sudo docker run --name browserServer \
                -p   9091:9091  9092:9092  \
                -e   CHROME_REMOTE_URL=http://172.17.42.1:4443/wd/hub  CONSUMER_IP=*  CONSUMER_PORT=9091  PRODUCER_IP=*  PRODUCER_PORT=9092  BROWSER_NAME=FIREFOX  \
                -d bitliner/browser-server 
}

stop_browserServer() {
        sudo docker stop browserServer
        sudo docker rm browserServer
}


run_browserNode() {
        build_browserNode
        stop_browserNode
        start_browserNode
}

run_browserServer() {
        build_browserServer
        stop_browserServer
        start_browserServer
}



stop() {

        stop_browserNode

        stop_browserServer

}
start() {

        start_browserNode

        start_browserServer


}
build() {

        build_browserNode

        build_browserServer

}




run() {
        build
        stop
        start
}
run_test() {
        build
        stop_test
        start_test
        show_logs
}
run_hub() {
        stop
        start_hub
}

usage() {
        echo "Actions:"
        echo "          run     build, stop and start all containers"
        echo "          build   build all containers"
        echo "          start  start all containers"
        echo "          stop    stop containers"
        echo ""
        echo ""
        
        
        echo "          ---> 'browserNode' container"
        echo ""
        echo "          run_browserNode   build, stop and start 'browserNode' container"
        echo "          build_browserNode build 'browserNode' container"
        echo "          start_browserNode start 'browserNode' container"
        echo "          stop_browserNode  stop 'browserNode' container"
        echo ""        
        
        echo "          ---> 'browserServer' container"
        echo ""
        echo "          run_browserServer   build, stop and start 'browserServer' container"
        echo "          build_browserServer build 'browserServer' container"
        echo "          start_browserServer start 'browserServer' container"
        echo "          stop_browserServer  stop 'browserServer' container"
        echo ""        
        
}


case $1 in
        run)
                run;;
        hub)
                run_hub;;
        test)
                run_test;;
        build)
                build;;
        start)
                start;;
        start_hub)
                start_hub;;
        start_test)
                start_test;;
        stop)
                stop;;
        stop_hub)
                stop_hub;;
        stop_test)
                stop_test;;
        *)
                usage
                exit 1
        ;;
esac
