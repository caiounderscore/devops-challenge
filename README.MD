# Esse é um exercício de provisionamento de infra-estrutura como código 

### Na cloud da AWS ele irá provisionar os seguintes recursos:
- VPC 
- Subnets privadas e públicas 
- Route tables 
- Nat gateways 
- Internet Gateway 
- Security Groups 
- 2 instancias EC2 (nginx, apache) 
- 1 Load balancer 
- 1 Target group 

Está organizado de maneira que as instancias fiquem em rede privada e o load balancer na rede publica, permitindo assim o acesso fora da rede da AWS somente ao load balancer, existe um nat-gateway para cada subnet privada com suas respectivas zonas de disponilibidades de modo que as subnets sejam resilientes. As duas instâncias utilizam a imagem do ubuntu-server e serão vinculadas ao load balancer na porta 80, sendo elas com um servidor http instaldo, nginx e apache, a instalação do nginx e apache serão feitas via user-data, podem se encontrados no diretório **files/**

Ao final do provisionamento, retornará 2 informações de saída, o endpoint do load balancer e a chave privada da instancia, para conectar via ssh caso precise. 

Para **personalizar** informações como região, subnets, range de ip e etc, basta fazer as alterações no arquivo **vars/global.tfvars**

### Comandos para priviosnamento da infrastrutura:
```
terraform init 
terraform apply -var-file=vars/global.tfvars
```

### Comando para desfazer o provisionamento dos recursos:
    `terraform destroy -var-file=vars/global.tfvars`