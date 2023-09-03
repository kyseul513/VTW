pipeline {
    agent any
    
    environment { 
        repository = "kys513/vtw"
        DOCKERHUB_CREDENTIALS = credentials('docker_credentials') 
        dockerImage = '' 
    }
  
    stages {
        stage('Git Clone') {
            steps {
                git branch: 'master', url: 'https://github.com/kyseul513/VTW.git'
            }
        }
        
        stage('Build') {
            steps {
                dir("./") {
                    sh "./gradlew clean build --stacktrace"
                }
            }
        }
        
        stage('Build-image') { 
            steps { 
                script { 
                    sh "docker build -t kys513/vtw ."
                }
            } 
        }
        
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Docker Push') { 
          steps { 
              script {
                sh 'docker push kys513/vtw:3.0' //docker push
              } 
          }
        } 
        
        stage('Cleaning up') { 
            steps { 
              sh "docker rmi kys513/vtw:3.0" // docker image 제거
              }
        }
        
        stage('SSH transfer') {
            steps {
                sshPublisher(
                    continueOnError: false, failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "ec2-deploy",//Jenkins 시스템 정보에 사전 입력한 서버 ID
                            verbose: true,
                            transfers: [
                                sshTransfer(
                                    sourceFiles: "scripts/deploy.sh", //전송할 파일
                                    removePrefix: "scripts", //파일에서 삭제할 경로가 있다면 작성
                                    execCommand: """echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                                    sh deploy.sh""" //원격지에서 실행할 커맨드
                                    )
                            ]
                        )
                    ]
                )
            }
        }
        
    }
}