<h1>Estuda Challenge</h1>

Aqui foi testado alguns conhecimento como: *Docker*, *GitHub Action*, *Git*, *Terraform*, *K8s*, *Python*

Foi dividido em *steps* que não precisam ser executados sequecialemente, mas as coisas dentro dos steps precisam sim.

[!WARNING] - Pré-requisitos
Ferramentas que foram instaladas para a execução desse **challenge**
>- [Docker](https://docs.docker.com/engine/install/)
>- [Docker-compose]()
>- [Terraform](https://developer.hashicorp.com/terraform/install)
>- [Minikube - Kubernetes localmente](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
>- [Kubeclt](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

<h3>STEP 1 - API em Python</h3>
Foi feita uma API em Python usando o framework Flask, com dois endpoints

- 1: **/** - lista os usuários cadastrados no banco de dados. [GET]
- 2: **/add** - Adiciona um usuário. [POST]

<h3>STEP 2 - Banco de Dados</h3>
O banco foi criado em cima de um container com configuração padrão que vem da imagem do mysql, para facilitar a praticidade.

A configuração do banco se encontra no [docker-compose.yaml](docker-compose.yaml)

<h3>STEP 3 - IaC Infraestrutura como codigo</h3>

Foram criados arquivos (main.tf, variables.tf) do terraform, onde juntos compoem uma configuração de infraestrutura. Foi escolida a GCP (*Google Clould Platform*) para prover os recursos computacionais.

No [main.tf](/terraform/main.tf) se encontra os recursos de uma vm, um instancia de banco de dados e uma base de dados não estruturada.
Já no [variables.tf](terraform/variables.tf) se encontra algumas variaveis que compoen o arquivo main.tf

Para a execução dos arquivos terraform para eles criar a infraestrutura basta modificar as variaveis do arquivo *variables.tf* ter instalado o terraform como foi citado nos [pré-requisitos]() e executar um:


```bash
terraform plan # O comando mostra um planejamento de como vai ficar infraestrutura
```

```bash
terraform apply # O comando executa de fato a criação da infraestrutura.
```

Lembrando que, nesse challenge o terraform foi usado somente para provisionar os objectos na cloud, para a configuração dos objetos eu usaria o [*Ansible*](https://docs.ansible.com/ansible/latest/getting_started/introduction.html?extIdCarryOver=true&intcmp=7015Y000003t7aWQAQ&sc_cid=701f2000001OH6fAAG). Onde, com ele você pode clonar o app, executar a criação e importação do banco.

<h3>STEP 4 - Containers e Dockerfiles</h3>

Finalmente chegou os tão esperados Dockefiles. Foram criados, um [Dockerfile](/Dockerfile) para armazenar e containizar a aplicação citada no [step 1](/README.md#STEP-1-API-em-Python) e um [docker-compose](/docker-compose.yaml) file onde armaza a criação do banco usado na API e também a execução de criação dos container tando do banco quando da Api.

para a execução dos arquivos, logo após a instalação do *docker* e **docker-composer** basta criar uma sub-rede dentro do docker com o comando:
```bash
docker network create estuda --gateway 172.28.0.1 --subnet 172.28.0.0/24
```
onde *estuda* é o nome da rede, seguindo da execução dos comandos
```bash
docker build -t estuda-app .
```
onde faz o *build* da imagem da aplicação e
```bash
docker composer up -d
```
onde ele executa a criação dos containers, disponibilizando a url: *172.28.0.2:5000*, onde nela contem os dois endpoints tambem citados no [step 1]()

Você pode também querer importar uma base já criar, ela sem encontra em [**/base**](/base/estuda_clients_dump.sql.gz)

Para a execução da importação dessa base, basta descompacta-la e importa-la para o banco de dados com os comandos:

```bash
gunzip base/estuda_clients_dump.sql.gz
```
```bash
mysql -h 172.28.0.3 -u root -p'bi7d2lyFNV9ZwjB3' -e "CREATE DATABASE estuda_clients;"
mysql -h 172.28.0.3 -u root -p'bi7d2lyFNV9ZwjB3' estuda_clients < base/estuda_clients_dump.sql
```

<h3>STEP 5 - Pipeline CI/CD</h3>

Esse é um ponto delicado, onde você terá que criar uma conta no [DockerHub](https://hub.docker.com/) caso não tenha, pois um dos steps da *pipeline* vai ser o a *push* da
imagem no repositório do DockerHub.

Você precisará também criar um token de authenticação do DockerHub, para autorizar o GitHub Actions **"pushear"** a imagem. Para criar o token é somente ir em: ***Account Setting > Security > Personal acess token.***

Feito isso e copiado o token, você deve criar uma *secret* no seu repositório, que é bem simples também: ***Settings > Secrets ans variables > Actions > Secrets***. Os nomes das secrets e variaveis estão escritas no [gitaction.yaml](.github/workflows/gitaction.yaml)

E para executar é simples, só dar uma *push* no seu repositório que o Github já vai executa-lo, seguindo as regras do arquivo.

<h3>STEP 6 - Orquestração de Containers</h3>

> [!IMPORTANT]
> Dentro do arquivo [app.yaml](/k8s/app.yaml), mais especifico na tag *image*, lembrar de trocar para o seu repositório/image:tag do seu DockerHub.

Chegamos na etapa mais simple, onde, depois de instalado o [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download) e o [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) basta você iniciar o cluster com um:
```bash
minikube start
```
E logo após, executar os arquivos que estão dentro da pasta [k8s](./k8s/app.yaml):

```bash
kubectl apply -f secret.yaml
kubectl apply -f service.yaml
kubectl apply -f database.yaml
kubectl apply -f app.yaml
```