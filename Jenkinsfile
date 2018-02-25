def currentVersion
def nexusURL = 'http://192.168.56.10:8081/nexus/content/repositories/snapshots/'
def responseTomcat
def branch = 'task6'
def appName = 'test.war'
def git = 'https://github.com/Sstrikers/devops_training'
def jkmanagerURL = '192.168.56.10:80/jkmanager/'
def lbTomcat1Enable = 'cmd=update&from=list&w=lb&sw=tomcat1&vwa=0'
def lbTomcat1Disable = 'cmd=update&from=list&w=lb&sw=tomcat1&vwa=1'
def lbTomcat2Enable = 'cmd=update&from=list&w=lb&sw=tomcat2&vwa=0'
def lbTomcat2Disable = 'cmd=update&from=list&w=lb&sw=tomcat2&vwa=1'
def tomcat1URL = 'http://192.168.56.11:8080/test'
def tomcat2URL = 'http://192.168.56.12:8080/test'
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

node ('tomcat1'){
    stage ('Get new application tomcat 1'){
        sh "curl -G -d '$lbTomcat1Disable' $jkmanagerURL"
	    sh "sudo rm $tomcatDir$appName || true"
	    sh "sudo wget -P $tomcatDir $nexusURL"
	    sleep 10
	    responseTomcat = httpRequest tomcat1URL
        if (responseTomcat.content.contains("Current version is "+currentVersion)){
            sh "curl -G -d '$lbTomcat1Enable' $jkmanagerURL"
        }
	    
    }
}

node ('tomcat2'){
    stage ('Get new application tomcat 2'){
        sh "curl -G -d '$lbTomcat2Disable' $jkmanagerURL"
	    sh "sudo rm $tomcatDir$appName || true"
	    sh "sudo wget -P $tomcatDir $nexusURL"
	    sleep 10
	    responseTomcat = httpRequest tomcat2URL
        if (responseTomcat.content.contains("Current version is "+currentVersion)){
            sh "curl -G -d '$lbTomcat2Enable' $jkmanagerURL"
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