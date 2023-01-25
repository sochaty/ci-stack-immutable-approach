pipeline {
    agent any 
    stages {
        stage('Clean workspace') { 
            steps {
                cleanWs()
             }
        }
        stage('Git Checkout') { 
            steps {
                git branch: 'master', credentialsId: 'githublogin', url: 'https://github.com/sochaty/ci-stack-immutable-approach' 
            }
        }
        stage('Restore packages') { 
            steps {
                sh "dotnet restore ${workspace}\\DemoCode\\<solution-project-name>.sln"
            }
        }
    }
}