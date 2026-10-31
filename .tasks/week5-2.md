# Checklist Week5-2

Make the backend protection switchable with Spring profiles, run two backend instances and load balance them with nginx.

| What                          | Value  |
| ----------------------------- | ------ |
| unique number                 | `45`   |
| first server port             | `8245` |
| second server port (`45 * 2`) | `8290` |
| load balancer port            | `80`   |

- [x] Create branch `week5-2`

```console
git checkout -b week5-2
```

## Disable the protection of the backend

- [ ] Create [DevJWTSecurityConfig.java][DevJWTSecurityConfig.java] in the directory `security`

```java
package de.hsesslingen.webshopbackend.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@Profile("dev")
public class DevJWTSecurityConfig {

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity)
    throws Exception {
      return httpSecurity
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()
                )
                .csrf((csrf)-> csrf.disable())
                .build();
  }
}
```

- [x] Add the `Profile` annotation to [JWTSecurityConfig.java][JWTSecurityConfig.java] (the import `org.springframework.context.annotation.Profile` is already there)

```java
@Profile("prod")
```

```java
@Configuration
@EnableWebSecurity
@Profile("prod")
public class JWTSecurityConfig {
```

- [x] Configure the active profile in [application.properties](/webshopbackend/src/main/resources/application.properties)

```properties
spring.profiles.active=dev
```

> Note: with `dev` active the endpoints are open again, so `POST`, `PUT` and `DELETE` no longer return `401`.
> Switch to `spring.profiles.active=prod` to get the protection from week5-1 back.

[DevJWTSecurityConfig.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security/DevJWTSecurityConfig.java
[JWTSecurityConfig.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security/JWTSecurityConfig.java

## Add response header `server-port`

- [x] Create the directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/filter](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/filter)

```console
mkdir -p webshopbackend/src/main/java/de/hsesslingen/webshopbackend/filter
```

- [ ] Create [AddResponseHeaderFilter.java][AddResponseHeaderFilter.java]

```java
package de.hsesslingen.webshopbackend.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AddResponseHeaderFilter implements Filter {

    @Value("${server.port}")
    String port;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        httpServletResponse.setHeader("server-port", port);
        chain.doFilter(request, response);
    }
}
```

[AddResponseHeaderFilter.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/filter/AddResponseHeaderFilter.java

## Test changes

- [x] Start the backend (first instance, port `8245`)

```console
mvn spring-boot:run
```

- [x] Test the API with Bruno. The response must contain the header `server-port`

### Screenshots Docs (first instance)

- [x] Create screenshot [week5-GET-8245-maowit00][week5-GET-8245-maowit00]
- [x] Create screenshot [week5-PUT-8245-maowit00][week5-PUT-8245-maowit00]

![week5-GET-8245-maowit00][week5-GET-8245-maowit00]
![week5-PUT-8245-maowit00][week5-PUT-8245-maowit00]

[week5-GET-8245-maowit00]: /docs/week5-GET-8245-maowit00.png
[week5-PUT-8245-maowit00]: /docs/week5-PUT-8245-maowit00.png

## Second backend instance

- [x] Start a second instance of the backend on port `8290` (in a second terminal, inside `webshopbackend`)

```console
env SERVER_PORT=8290 mvn spring-boot:run
```

> Note: if `mvn` is not installed, use the wrapper `env SERVER_PORT=8290 ./mvnw spring-boot:run`.

- [x] In Bruno duplicate the collection and name it `ItemManagement-8290`
- [x] Adapt the port in the requests to `8290`
- [x] Test the API. The response header `server-port` must show `8290`

### Screenshots Docs (second instance)

- [x] Create screenshot [week5-GET-8290-maowit00][week5-GET-8290-maowit00]
- [x] Create screenshot [week5-PUT-8290-maowit00][week5-PUT-8290-maowit00]

![week5-GET-8290-maowit00][week5-GET-8290-maowit00]
![week5-PUT-8290-maowit00][week5-PUT-8290-maowit00]

[week5-GET-8290-maowit00]: /docs/week5-GET-8290-maowit00.png
[week5-PUT-8290-maowit00]: /docs/week5-PUT-8290-maowit00.png

## Install nginx

- [ ] Update the repository index

```console
sudo apt update
```

- [ ] Install nginx

```console
sudo apt install -y nginx
```

- [ ] Check installation

```console
nginx -v
```

Results in something like:

```console
nginx version: nginx/1.28.3 (Ubuntu)
```

- [ ] Check status of the nginx service

```console
systemctl status nginx
```

The result should show `Active: active (running)`.

To later restart, stop or start nginx:

```console
sudo systemctl restart nginx
```

```console
sudo systemctl stop nginx
```

```console
sudo systemctl start nginx
```

## Configure nginx

The configuration is defined in `/etc/nginx/nginx.conf`.
It forwards all requests sent to `/api-maowit00/item-management/v1` to the servers defined in the `upstream` `item-management-pool`.

- [ ] Backup the original configuration

```console
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
```

- [ ] Replace the content of `/etc/nginx/nginx.conf`

```console
sudo nano /etc/nginx/nginx.conf
```

```nginx
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    upstream item-management-pool {
        server 127.0.0.1:8245;
        server 127.0.0.1:8290;
    }

    server {
        listen       80;
        server_name  localhost;

      root /var/www/html;

    # Add index.php to the list if you are using PHP
    index index.html index.htm index.nginx-debian.html;

    location / {
      # First attempt to serve request as file, then
      # as directory, then fall back to displaying a 404.
      try_files $uri $uri/ =404;
    }

        location /api-maowit00/item-management/v1 {
            proxy_pass http://item-management-pool/api-maowit00/item-management/v1;
        }


    }
}
```

- [ ] Check the configuration for syntax errors

```console
sudo nginx -t
```

- [ ] Restart nginx

```console
sudo systemctl restart nginx
```

## Test load balancing

- [ ] Make sure both backend instances (`8245` and `8290`) are running

- [ ] In Bruno duplicate the `GET` requests of the collection and add the postfix `-80`
- [ ] Adapt the port in the request URLs to the load balancer port `80`

```url
http://localhost/api-maowit00/item-management/v1/items
```

- [ ] Send the request repeatedly. The response header `server-port` must alternate between `8245` and `8290`

Quick check on the command line (prints the port of each answering instance):

```console
for i in 1 2 3 4; do curl -si http://localhost/api-maowit00/item-management/v1/items | grep -i server-port; done
```

### Screenshots (top level of the project folder)

- [ ] Create screenshot [week5-server-port-lb-8245-maowit00][week5-server-port-lb-8245-maowit00]
- [ ] Create screenshot [week5-server-port-lb-8290-maowit00][week5-server-port-lb-8290-maowit00]

![week5-server-port-lb-8245-maowit00][week5-server-port-lb-8245-maowit00]
![week5-server-port-lb-8290-maowit00][week5-server-port-lb-8290-maowit00]

[week5-server-port-lb-8245-maowit00]: /week5-server-port-lb-8245-maowit00.png
[week5-server-port-lb-8290-maowit00]: /week5-server-port-lb-8290-maowit00.png

## Commit and Merge

- [ ] Commit all changes to branch `week5-2`

- [ ] Push the branch to the global repository

```console
git push -u origin week5-2
```

- [ ] Check the result at the [central repository](https://gitlab.hs-esslingen.de/swa-lab-wise25)

- [ ] Create Merge request at GitLab for `week5-2`
