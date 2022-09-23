# Wordpress + Infraesturura as Code

Esse repositório contém a implementação do primeiro trabalho do Cusro de SRE.

De acordo com o que foi socilitado este projeto provisiona via terraform os seguintes recursos:

    ⭐ VPC;

    ⭐ EC2;
    
    ⭐ Memcache;
    
    ⭐ RDS;
    
    ⭐ Load Balancer;
    
    ⭐ Autoscaling.
  
Além disso instala o Wordpress com Ansible nas instancias EC2;

## Estrutura do repositório

### ⭐ Ansible:
  Na pasta nomeada `ansible` temos o processo de configuração do **wordpress + nginx** (`ansible/role/wordpress`). Temos também a configuração dos certificados (`ansible/role/certificates`) e a geração da imagem de template (`ansible/role/ec2`). O arquivo `playbook.yml` concentra a execução das task mencionadas acima.

  Observações: O arquivo hosts e o arquivos de variáveis contidos na pasta vars, são gerados no terraform.

### ⭐ Terraform
  Os arquivos terraform estão concentrados na pasta `terraform`. A sua estrutura está organizada da seguinte forma: arquivos contidos na pasta `aws` representam todos os recursos da aws que serão provisionados para o trabalho. A pasta `tools`, contém apenas o arquivo terraform responsável por gerar a partir do output dos recursos provisionados as variáveis que serão utilizadas pelas **task do ansible**.

  No arquivo `main.tf` são importados na forma de módulos os arquivos da pasta `aws`.

### ⭐ SSH
  Contém a chave utilizada para acessar a ec2 criada.


### ⭐ Dockerfile, docker-compose e makefile
  A fim de provisionar um ambiente local que fosse fácil de configurar criei um `Dockerfile` em que todos os pacotes necessários para rodar esse projeto são instalados, oq ue permite uma configuração rápida do ambiente. Para excutar a imagem docker gerada pelo `Dockerfile`, foi criado um `docker-compose`; este é responsável por mapear volumes e repassar variáveis de ambiente necessárias para a execução da imagem gerada.

  O arquivo `makefile` é uma forma simples de executar os comandos necessários para provisionar toda a infraestrutura do projeto.

### ⭐ Executando o projeto

  Para executar o projeto é necessário criar na aws um usuário que possua as permissões necesárias para criar e deletar os recursos que serão povisionados. Com as credenciais deste usuário em mão vá ao arquivo `Makefile` e as adicione nas linhas 4 e 5 no seguinte formato:

```
    4 - AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>\
    5 - AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>\
```
Após isto é só executar os seguintes comandos na raiz do projeto:

    ⭐ `make init` (Executa o terraform init)

    ⭐ `make apply` (Executa o terraform apply para provisionar a estrutura necessária para subir a ec2 + loadbalance)

    ⭐ `make run-playbook` (Executa o ansible para configurar o wordpress e gerar uma imagem da ec2 provisionada)

    ⭐ `make apply-auto-scaling` (configurando o autoscalling)

