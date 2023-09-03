pipeline {
    agent any
    tools {
        gradle 7.6 
    }
    
    
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
        
	stage('Build Image') {
            steps {
                sh 'gradle init'
                sh "echo 'building..'"
                git credentialsId: 'b702e96e-273b-46c6-b7aa-7ba51ee29c87',url:'https://github.com/kyseul513/VTW.git', 
                branch: 'master'
                withGradle {
                   sh 'gradle wrapper build'
                }
                sh 'docker build -t kys513/vtw .'
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
                sh 'docker push kys513/vtw:latest' //docker push
              } 
          }
        } 
        
        stage('Cleaning up') { 
            steps { 
              sh "docker rmi kys513/vtw:latest" // docker image 제거
              }
        }
        
        stage('SSH transfer') {
            steps {
                sshPublisher(
                    continueOnError: false, failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "ubuntu",//Jenkins 시스템 정보에 사전 입력한 서버 ID
                            verbose: true,
                            transfers: [
								sshTransfer(
								    sourceFiles: "scripts/deploy.sh", // 전송할 파일
								    removePrefix: "", // 파일에서 삭제할 경로가 있다면 작성
								    execCommand: """#!/bin/bash
								    set -e

								    docker login -u "kys513" -p "requiem513!"
								    
								    sh deploy.sh"""
								)
                            ]
                        )
                    ]
                )
            }
        }
        
    }
}