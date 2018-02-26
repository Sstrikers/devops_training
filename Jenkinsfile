def currentVersion
def nexusURL = 'http://apache:8081/nexus/content/repositories/snapshots'
def responseTomcat
def branch = 'task6'
def appName = 'test.war'
def git = 'https://github.com/Sstrikers/devops_training'
def jkmanagerURL = 'apache:80/jkmanager/'
def nodeName = 'tomcat'
def tomcatDir = '/usr/share/tomcat/webapps/'

node ('master'){
    stage ('Clone'){
        gitCheckout (branch, git)
        sh "git config --global user.email 'sstrikers@gmail.com'"
        sh "git config --global user.name 'Sergey Tsurankov'"
    }
    
    stage ('Build'){
        sh './gradlew clean && ./gradlew incrementVersion && ./gradlew build'
    }
    
    stage ('Deploy to Nexus'){
        withCredentials([usernamePassword(credentialsId: 'fa9faa5f-fe0f-4fa5-ba7d-73aae6208da1', passwordVariable: 'nexusPassword', usernameVariable: 'nexusLogin')]) {
            def props = readProperties  file:'gradle.properties'
            currentVersion = props['buildVersion']
            nexusURL = nexusURL+'/'+branch+'/'+currentVersion+'/'+appName
            dir ('build/libs'){
                sh "curl -XPUT -u $nexusLogin:$nexusPassword -T $branch-*.war $nexusURL"
            }
        }
    }
}

for (i=1; i<=2; i++){
    node (nodeName+i){
        stage ('Get new application tomcat'+i){
            updateApp(nodeName, i, tomcatDir, jkmanagerURL, appName, nexusURL, currentVersion)
        }
    } 
}

node ('master'){
    stage ('Push and merge'){
        withCredentials([usernamePassword(credentialsId: '3cab255d-e955-41e9-ad2d-e31fbc2617c3', passwordVariable: 'gitPassword', usernameVariable: 'gitLogin')]) {
            sh 'git add gradle.properties'
            sh "git commit -m 'Added $currentVersion'"
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training task6"
            sh 'git checkout master'
            sh 'git merge task6'
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training master"
            sh "git tag -a v$currentVersion -m 'Project v$currentVersion'"
            sh "git push https://${gitLogin}:${gitPassword}@github.com/Sstrikers/devops_training v$currentVersion"
        }
        
    }
}

def gitCheckout(branch, url){
    git branch: branch, url: url
}

def updateApp(nodeName, nodeNumber, tomcatDir, jkmanagerURL, appName, nexusURL, currentVersion){
    sh "curl -G -d 'cmd=update&from=list&w=lb&sw=$nodeName$nodeNumber&vwa=1' $jkmanagerURL"
    sh "sudo rm $tomcatDir$appName || true"
    sh "sudo wget -P $tomcatDir $nexusURL"
    sleep 10
    def responseTomcat = httpRequest 'http://'+nodeName+nodeNumber+':8080/test'
    if (responseTomcat.content.contains("Current version is "+currentVersion)){
        sh "curl -G -d 'cmd=update&from=list&w=lb&sw=$nodeName$nodeNumber&vwa=0' $jkmanagerURL"
    } else {
        sh "exit 1"
    }
}