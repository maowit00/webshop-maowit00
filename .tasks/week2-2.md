# ToDos WebShop Week2-2

## Install Postgress

- [ ] Install postgress data base
  - [ ] [Automated installer scripts](/.scripts/setup/postgres/install.sh)
  - [ ] [Create DB, Table Entries scripts](/.scripts/project/db/itemdb/setup.sh)

## Install PGAdmin

- [ ] Install [pgAdmin](https://gitlab.hs-esslingen.de/swa-lab-wise26)
  - Not available on all archs:
    - [ ] x86 pgadmin4-desktop from apt after adding gpg keys
    - arm
      - [ ] [via docker](/.scripts/setup/pgadmin/docker/install.sh)
      - [ ] [via pip](/.scripts/setup/pgadmin/pip/install.sh). Also need env and a launcher
    - [ ] [pgmadmin-web](/.scripts/setup/pgadmin-web/install.sh) works on arm and x86
    - [ ] Launcher
      - [ ] [pgadmin docker launcher](/.scripts/launch/pgadmin/docker/launch.sh)
      - [ ] [pgadmin python launcher](/.scripts/launch/pgadmin/pip/launch.sh)

> Makes messing with SQL easier. Alternative available though.

## Create Database

- [ ] Create a user and a database in postgres
  - [ ] Scripts under [.scripts/project/db/itemdb/setup.sh](/.scripts/project/db/itemdb/setup.sh)

Create a user and database in postgres like shown in Slides 02-1_Database – Chapter Preparing PostgreSQL.
The user should follow the naming convention `webshop-[your-hs-esslingen-user-name]`.
The name of the database is `itemdb`.

## Modify Backend to Use Database

- [ ] Edit [webshopbackend/src/main/resources](/webshopbackend/src/main/resources/application.properties)

```properties
spring.application.name=webshopbackend

server.port=8200

spring.datasource.url=jdbc:postgresql://localhost:5432/itemdb
spring.datasource.username=webshop-maowit00
spring.datasource.password=not-hs-password

spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
# Hibernate ddl auto (create, create-drop, validate, update)
spring.jpa.hibernate.ddl-auto=update

```

## Add Backend Dependency

- [ ] Edit [POM.xml](/webshopbackend/pom.xml)

In the folder `~/lab/[your-project-folder]/webshopbackend` update the POM.xml file to use a dependency to postgres instead of h2 as shown in Slide 02-2_Backend - Maven Build information (2).

```XML
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

## Test Changes

- [ ] Check JSON response
  - [ ] Go to <http://localhost:8200/api-maowit00/item-management/items>

In the browser navigate to `http://localhost:82[your-unique-number]/api-[your-hs-esslingen-user-name]/item-management/items` to query all entries of the table item.

- [ ] Screenshot

- [ ] Commit and push

- [ ] Merge request
