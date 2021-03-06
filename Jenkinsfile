#!groovy

@Library('github.com/teecke/jenkins-pipeline-library@v3.4.1') _

// Initialize global config
cfg = jplConfig('docker-cypress-crawler', 'docker', '', [email: env.CITEECKE_NOTIFY_EMAIL_TARGETS])

def publishDockerImage() {
    nextReleaseNumber = sh (script: "kd get-next-release-number .", returnStdout: true).trim().substring(1)
    docker.withRegistry("", 'teeckebot-docker-credentials') {
        def customImage = docker.build("teecke/docker-cypress-crawler:${nextReleaseNumber}", ".")
        customImage.push()
        customImage.push('latest')
    }
}

pipeline {
    agent { label 'docker' }

    stages {
        stage ('Initialize') {
            steps  {
                jplStart(cfg)
            }
        }
        stage ('Bash linter') {
            steps {
                sh 'devcontrol run-bash-linter'
            }
        }
        stage ('Crawler test') {
            steps {
                script {
                    docker.build("teecke/docker-cypress-crawler:latest", ".")
                    sh '''
                    cp cypress/fixtures/url_list.json.dist cypress/fixtures/url_list.json
                    devcontrol run-crawler
                    '''
                }
            }
        }
        stage ('Make release') {
            when { branch 'release/new' }
            steps {
                publishDockerImage()
                jplMakeRelease(cfg, true)
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 10, unit: 'MINUTES')
    }
}
