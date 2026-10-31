# Checklist Week5-1

Protect the backend with the JWT issued by KeyCloak. The frontend sends the `access_token` in the `Authorization` header.

- [x] Create branch `week5-1`

```console
git switch -c week5-1
```

## Frontend: send access_token to the backend

### Interceptor

- [x] Adapt [http-common.js](/webshopfrontend/src/http-common.js) to intercept http calls and insert the `access_token` into the `Authorization` header

```javascript
import axios from "axios";
import { useAuth } from './composables/Auth';

const instance = axios.create({
  baseURL: "http://localhost:8245/api-maowit00/item-management/v1",
  headers: {
    "Content-type": "application/json"
  }
});

instance.interceptors.request.use(async config => {
  const { getAccessToken, ensure, isAuthenticated } = useAuth();

  await ensure();

  if (isAuthenticated.value) {

    const token = await getAccessToken();

    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    }
  }

  return config;

});

export default instance;
```

## Inspect Token

- [x] Start KeyCloak, backend and frontend
- [x] Login in the frontend as `maowit00`
- [x] Open the developer tools in Firefox (`F12`) and go to the tab `Network`
- [x] Navigate to `Add Item` or `Edit Item` and search for a call to the backend (port `8245`)
- [x] Click on the call and in the tab `Headers` find the request header `Authorization`
- [x] Copy the JWT (the string after the keyword `Bearer`)
  - In Firefox switch to the option `Raw`, otherwise the whole JWT can not be copied
- [x] Decode the JWT at [jwt.io](http://jwt.io) and check
  - [x] issuer `iss`: `http://localhost:8080/realms/maowit00-organisation`
  - [x] clientID `azp`: `webshop-maowit00`
  - [x] user information: `name`, `email`
- [x] Store the payload of the JWT in [JWTPayload.json](/docs/JWTPayload.json)

## Protect the Backend

### Dependency

- [ ] Add the dependency to the [pom.xml](/webshopbackend/pom.xml)

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security-oauth2-resource-server</artifactId>
</dependency>
```

> Note: the task sheet uses `spring-boot-starter-oauth2-resource-server`. Spring Boot 4 renamed it
> (the project uses Boot `4.1.1`), the old name is only a deprecated alias.

### Configuration

- [ ] Add the location of the KeyCloak public keys to [application.properties](/webshopbackend/src/main/resources/application.properties)

```properties
spring.security.oauth2.resourceserver.jwt.jwk-set-uri=http://localhost:8080/realms/maowit00-organisation/protocol/openid-connect/certs
```

> Note: the task sheet lists `spring.security.oauth2.resource.jwk.key-set-uri`. Spring Boot does not read that
> property, so no `JwtDecoder` is created and the backend fails to start. `...resourceserver.jwt.jwk-set-uri` is the correct one.

### Security Config

- [ ] Create the directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security)

```console
mkdir -p webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security
```

- [ ] Create [JWTSecurityConfig.java][JWTSecurityConfig.java]

```java
package de.hsesslingen.webshopbackend.security;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class JWTSecurityConfig {

  private static final String CLIENT_ID = "webshop-maowit00";

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity)
    throws Exception {
    httpSecurity
      .csrf(AbstractHttpConfigurer::disable)
      .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
      .oauth2ResourceServer(oauth2 -> oauth2
        .jwt(jwt -> jwt.jwtAuthenticationConverter(token -> new JwtAuthenticationToken(token, extractClientRoles(token))))
      )
      .authorizeHttpRequests(registry -> registry
        .requestMatchers(HttpMethod.GET, "/**").permitAll()
        .requestMatchers(HttpMethod.HEAD, "/**").permitAll()
        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
        .anyRequest().hasRole("admin")
      );

    return httpSecurity.build();
  }


  private static Collection<GrantedAuthority> extractClientRoles(Jwt jwt) {
    Map<String, Object> resourceAccess = jwt.getClaimAsMap("resource_access");
    if (resourceAccess == null
      || !(resourceAccess.get(CLIENT_ID) instanceof Map<?, ?> client)
      || !(client.get("roles") instanceof Collection<?> roles)) {
      return List.of();
    }
    return roles.stream()
      .<GrantedAuthority>map(role -> new SimpleGrantedAuthority("ROLE_" + role))
      .toList();
  }
}
```

[JWTSecurityConfig.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/security/JWTSecurityConfig.java

## Testing

- [ ] Start KeyCloak

```console
keycloak start-dev
```

- [ ] Start Backend

- [ ] Start Frontend

- [ ] Test the overall application. The frontend should still work as before
  - [ ] Items are listed without login
  - [ ] `Add Item` / `Edit Item` / `Delete` work after login as `maowit00` (role `admin`)

- [ ] Test the backend with Bruno without a token. `POST`, `PUT` and `DELETE` must result in `401`

```console
curl -i -X POST http://localhost:8245/api-maowit00/item-management/v1/items
```

### Screenshots Docs

- [ ] Create screenshot [week5-POST-401-maowit00][week5-POST-401-maowit00]
- [ ] Create screenshot [week5-PUT-401-maowit00][week5-PUT-401-maowit00]
- [ ] Create screenshot [week5-DELETE-401-maowit00][week5-DELETE-401-maowit00]

![week5-POST-401-maowit00][week5-POST-401-maowit00]
![week5-PUT-401-maowit00][week5-PUT-401-maowit00]
![week5-DELETE-401-maowit00][week5-DELETE-401-maowit00]

[week5-POST-401-maowit00]: /docs/week5-POST-401-maowit00.png
[week5-PUT-401-maowit00]: /docs/week5-PUT-401-maowit00.png
[week5-DELETE-401-maowit00]: /docs/week5-DELETE-401-maowit00.png

## Commit and Merge

- [ ] Commit all changes to branch `week5-1`

- [ ] Push the branch to the global repository

```console
git push -u origin week5-1
```

- [ ] Check the result at the [central repository](https://gitlab.hs-esslingen.de/swa-lab-wise25)

- [ ] Create Merge request at GitLab for `week5-1`
