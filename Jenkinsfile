


node {

     def blue_app
     def green_app


        stage('Clone repository') {
        /* Cloning the Repository to our Workspace */

                checkout scm

}

		 stage("Lint Dockerfile") {

                   sh "hadolint blue/Dockerfile && hadolint green/Dockerfile"



 }


 stage('Build Blue image') {
  /* This builds the blue container image */



        blue_app = docker.build("rdwns/node-docker-blue", "./blue")



 }

 stage('Build Green image') {
  /* This builds the green container image */

        green_app = docker.build("rdwns/node-docker-green", "./green")

 }

 stage('Push images to dockerhub') {
  /*
  You would need to first register with DockerHub before you can push images to your account
		*/

        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
        blue_app.push("${env.BUILD_NUMBER}")
        blue_app.push("latest")

        green_app.push("${env.BUILD_NUMBER}")
        green_app.push("latest")
        }
        echo "Trying to Push Docker Images to DockerHub"

 }

 stage('Create kubernetes cluster') {

        withAWS(region: 'ap-south-1', credentials: 'rdwn-cicd') {
                sh '''
                eksctl create cluster\
                --name udastone\
                --version 1.16\
                --region ap-south-1\
                --nodegroup-name udastone-nodes\
                --node-type t2.medium\
                --nodes 2\
                --nodes-min 1\
                --nodes-max 2\
                --managed
                '''
        }

 }


 stage('Deploy blue container') {

            withAWS(region: 'ap-south-1', credentials: 'rdwn-cicd') {
                sh "kubectl apply -f ./blue/blue-controller.yml"
        }

 }

 stage('Deploy green container') {

            withAWS(region: 'ap-south-1', credentials: 'rdwn-cicd') {
                sh "kubectl apply -f green/green-controller.yml"
            }

 }

 stage('Create service for cluster and redirect to blue!') {

            withAWS(region: 'ap-south-1', credentials: 'rdwn-cicd') {
                sh "kubectl apply -f ./blue-service.yml"
            }

 }

 stage('Approve deployment to green') {

             input "Should the traffic be redirected to green?"

 }

 stage('Create service for cluster and redirect to green!') {

            withAWS(region: 'ap-south-1', credentials: 'rdwn-cicd') {
                sh "kubectl apply -f ./green-service.yml"
        }
        }



}