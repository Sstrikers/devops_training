def currentVersion
def branch = 'task7'
def appFile = 'test.war'
def appName = 'test'
def repositoryURL = '192.168.56.10:5000'
def nodeURL = 'http://192.168.56.11:8080/test/'
def nexusURL = 'http://apache:8081/nexus/content/repositories/snapshots'
def git = 'https://github.com/Sstrikers/devops_training'

node ('master'){
    stage ('Clone'){
        gitCheckout (branch, git)
        sh "git config --global user.email 'sstrikers@gmail.com'"
        sh "git config --global user.name 'Sergey Tsurankov'"
    }
    
    stage ('Build'){
        sh './gradlew clean && ./gradlew incrementVersion && ./gradlew build'
    }
    
    stage ('Upload to Nexus'){
        withCredentials([usernamePassword(credentialsId: 'fa9faa5f-fe0f-4fa5-ba7d-73aae6208da1', passwordVariable: 'nexusPassword', usernameVariable: 'nexusLogin')]) {
            def props = readProperties  file:'gradle.properties'
            currentVersion = props['buildVersion']
            nexusURL = nexusURL+'/'+branch+'/'+currentVersion+'/'+appFile
            dir ('build/libs'){
                sh "curl -XPUT -u $nexusLogin:$nexusPassword -T $branch-*.war $nexusURL"
            }
        }
    }

    stage ('Build new docker image'){
        sh "docker build --build-arg currentVersion=$currentVersion -t $branch:$currentVersion ."
        sh "docker tag $branch:$currentVersion $repositoryURL/$branch:$currentVersion"
        sh "docker push $repositoryURL/$branch:$currentVersion"
    }
    
    stage ('Deploy to docker'){
        sh "docker service ls | grep $appName && docker service update --image $repositoryURL/$branch:$currentVersion $appName || docker service create --name $appName --replicas 3 --publish 8080:8080 $repositoryURL/$branch:$currentVersion"
        sleep 20
        sh "curl '$nodeURL' | grep 'Current version is $currentVersion' || exit 1"
    } 

    stage ('Push and merge'){
        withCredentials([usernamePassword(credentialsId: '3cab255d-e955-41e9-ad2d-e31fbc2617c3', passwordVariable: 'gitPassword', usernameVariable: 'gitLogin')]) {
            sh "git add gradle.properties"
            sh "git commit -m 'Added $currentVersion'"
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training $branch"
            sh "git checkout master"
            sh "git merge $branch"
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training master"
            sh "git tag -a v$currentVersion -m 'Project v$currentVersion'"
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training v$currentVersion"
        }
        
    }
}

def gitCheckout(branch, url){
    git branch: branch, url: url
}

