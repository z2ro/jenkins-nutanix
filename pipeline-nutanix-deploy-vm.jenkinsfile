pipeline {
agent any

parameters {
    string(name: 'Login', description: 'Login do Prism Element')
    password(name: 'Senha', description: 'Senha do Prism Element')
    string(name: 'VIP', description: 'IP do Cluster')
    string(name: 'HOSTNAME', defaultValue: 'TESTE-JENKINS', description: 'Nome da VM')
    string(name: 'CPU', defaultValue: '1', description: 'Número de vCPU')
    string(name: 'MEM', defaultValue: '1024', description: 'RAM do servidor em MB')
    choice(name: 'NIC', choices: ['DEVOPS', 'CLOUDLAN'], description: 'VLAN do Cliente')
    string(name: 'IP', defaultValue: '10.10.76.100', description: 'IP da VM')
    choice(name: 'IMAGE', choices: ['CENTOS-7', 'UBUNTU-1804'], description: 'SO')
}
stages {
stage('Configurando Terraform') {
steps {
script {
def tfHome = tool name: 'terraform'
env.PATH = "${tfHome}:${env.PATH}"
}
sh 'terraform --version'
}
}

stage('Definindo variáveis') {
    steps {
        dir ('nutanix'){
        sh ("echo login=\\\"${params.Login}\\\" > vars.tfvars")
        sh ("echo password=\\\"${params.Senha}\\\" >> vars.tfvars")
        sh ("echo vip=\\\"${params.VIP}\\\" >> vars.tfvars")
        sh ("echo hostname=\\\"${params.HOSTNAME}\\\" >> vars.tfvars")
        sh ("echo vcpu=\\\"${params.CPU}\\\" >> vars.tfvars")
        sh ("echo mem=\\\"${params.MEM}\\\" >> vars.tfvars")
        sh ("echo ip=\\\"${params.IP}\\\" >> vars.tfvars")
        sh ("bash rimage.sh ${params.IMAGE}")
        sh ("bash rnics.sh ${params.NIC}")
        }
    }
}

stage('Provisionando Infraestrutura') {

steps {
dir ('nutanix')
{
sh 'terraform init -input=false'
sh 'terraform plan -out=tfplan -input=false -var-file=vars.tfvars'
sh 'terraform apply -input=false tfplan'
sh 'rm -rf terraform.tfstate'
}
}
}

stage('Configurando NGT') {
    steps {
        dir ('nutanix'){
          sh ("bash apiv2/vm-get-uuid.sh ${params.HOSTNAME}")
        }
    }
}
}
}
