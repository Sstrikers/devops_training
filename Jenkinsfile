import groovy.json.JsonOutput

def gitBranch = 'task10'
def gitURL = 'github.com/Sstrikers/devops_training'
def attributesFile = '/cookbooks/dockerdeploy/attributes/default.rb'
def metadataFile = '/cookbooks/dockerdeploy/metadata.rb'
def environmentFile = '/environments/prod.json'
def dockerImageVersionAttr = "node.default['dockerdeploy']['imageVersion']"
def cookbookDir = '/cookbooks/dockerdeploy'
def nodeName = 'apache'
node ('master') {
    stage ('Clone $gitBranch repository'){
        git branch: gitBranch, url: 'https://'+gitURL
        sh "git config --global user.email 'sstrikers@gmail.com'"
        sh "git config --global user.name 'Sergey Tsurankov'"
    }    
    stage ('Update projects version'){
        changeVersionProps(WORKSPACE+attributesFile, "'"+VERSION+"'", dockerImageVersionAttr)
        changeVersionMetadata (WORKSPACE+metadataFile, VERSION)
        changeVersionJSON(WORKSPACE+environmentFile, VERSION)
    }
    stage ('Update Chef Server'){
        sh "knife environment from file ${WORKSPACE}$environmentFile"
        sh "cd ${WORKSPACE}$cookbookDir && berks install && berks upload --force"
    }
    stage ('Commit to github'){
        withCredentials([usernamePassword(credentialsId: '4ff0ae2b-212e-4179-9a1f-cd5111a55f91', passwordVariable: 'gitPassword', usernameVariable: 'gitLogin')]) {
            sh 'git add ${WORKSPACE}$attributesFile'
            sh 'git add ${WORKSPACE}$metadataFile'
            sh 'git add ${WORKSPACE}$environmentFile'
            sh "git commit -m 'Updated. Current verison is $VERSION'"
            sh "git push https://${gitLogin}:${gitPassword}@$gitURL $gitBranch"
        }
    }
    stage ('Deploy docker app'){
        withCredentials([usernamePassword(credentialsId: '848233ec-534f-41ec-b390-4020f57814d9', passwordVariable: 'apachePassword', usernameVariable: 'apacheLogin')]) {
            sh "knife ssh name:$nodeName sudo chef-client -x ${apacheLogin} -P ${apachePassword}"
        }
    }
}
def changeVersionProps(file, version, property){
    Properties properties = new Properties()
    FileInputStream pReadFile = new FileInputStream(file)
    properties.load(pReadFile)
    properties.setProperty(property, version)
    FileOutputStream pWriteFile = new FileOutputStream(file)
    properties.store(pWriteFile, "")
    pReadFile.close()
    pWriteFile.close()
}

def changeVersionJSON (file, version){
    jReadFile =  readJSON file: file
    jReadFile.cookbook_versions.dockerdeploy = version
    jWriteFile = JsonOutput.toJson(jReadFile)
    jWriteFile = JsonOutput.prettyPrint(jWriteFile)
    writeFile(file:file, text: jWriteFile)    
}

def changeVersionMetadata (file, version){
    prevVersion = sh(returnStdout: true, script: "grep ^version '${file}' | awk '{print \$2}'").trim()
    sh "sed -i 's/${prevVersion}/${version}/g' ${file}"
}