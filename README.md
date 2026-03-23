# 🚲 BikeShop - Sistema de Gestão

Sistema completo para gerenciamento de uma loja de bicicletas, com controle de usuários, produtos, vendas, compras e orçamentos.

---

## 📌 Sobre o projeto

O **BikeShop** é uma aplicação desenvolvida com arquitetura separada entre **frontend e backend**, com foco em organização, escalabilidade e boas práticas.

O sistema permite:

* Cadastro e gerenciamento de usuários
* Controle de produtos
* Registro de vendas e compras
* (Em desenvolvimento) Orçamentos
* (Em desenvolvimento) Relatórios

---

## 🧱 Arquitetura

O projeto é dividido em dois repositórios:

### 🔹 Frontend

* Desenvolvido com **Flutter**
* Interface moderna e responsiva
* Consome API REST

### 🔹 Backend

* Desenvolvido com **Spring Boot**
* API REST
* Integração com banco de dados MySQL/MariaDB

---

## 🚀 Tecnologias utilizadas

### Frontend

* Flutter
* Dart

### Backend

* Java
* Spring Boot
* Spring Data JPA

### Banco de dados

* MySQL / MariaDB

---

## ⚙️ Funcionalidades

### 👤 Usuários

* Criar usuário
* Listar usuários
* Editar usuário
* Desativar usuário (**Soft Delete**)

> O sistema utiliza **soft delete**, ou seja, os registros não são removidos do banco, apenas marcados como inativos.

---

## 🔌 API (exemplo de endpoints)

| Método | Endpoint       | Descrição              |
| ------ | -------------- | ---------------------- |
| GET    | /usuarios      | Listar usuários ativos |
| POST   | /usuarios      | Criar usuário          |
| PUT    | /usuarios/{id} | Atualizar usuário      |
| DELETE | /usuarios/{id} | Desativar usuário      |

---

## 🖥️ Como executar o projeto

### 🔹 Backend (Spring Boot)

1. Clone o repositório:

```
git clone https://github.com/Geremias-Garcia/bikeshop-backend.git
```

2. Configure o banco de dados no `application.properties`

3. Execute:

```
mvn spring-boot:run
```

Servidor rodará em:

```
http://localhost:8080
```

---

### 🔹 Frontend (Flutter)

1. Clone o repositório:

```
git clone https://github.com/Geremias-Garcia/bikeshop-frontend.git
```

2. Instale as dependências:

```
flutter pub get
```

3. Configure a URL da API no service:

```dart
final String baseUrl = 'http://SEU_IP:8080/usuarios';
```

4. Execute:

```
flutter run
```

---

## 📱 Estrutura do projeto (Frontend)

```
lib/
 ├── core/
 ├── modules/
 ├── screens/
 │    ├── user/
 │    ├── product/
 │    ├── sale/
 │    ├── purchase/
 │    └── budget/
 ├── shared/
 └── main.dart
```

---

## 🧠 Boas práticas aplicadas

* Separação de responsabilidades (Service, Model, UI)
* Consumo de API REST
* Soft Delete para integridade dos dados
* Organização por módulos (em evolução)
* Código reutilizável (forms compartilhados)

---

## 📌 Próximas melhorias

* Implementação completa de orçamentos
* Relatórios (vendas, produtos)
* Autenticação de usuários
* Dashboard com indicadores
* Deploy (backend + app)

---

## 👨‍💻 Autor

Geremias Garcia Berto

* GitHub: https://github.com/Geremias-Garcia

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT.  
Consulte o arquivo LICENSE para mais detalhes.
