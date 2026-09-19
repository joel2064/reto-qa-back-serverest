@login
Feature: Login - Autenticación en ServeRest

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'

  @happyPath @smokeTest
  Scenario: Login exitoso devuelve token
    Given path 'login'
    And request credentials
    When method POST
    Then status 200
    And match response.message == 'Login realizado com sucesso'
    And match response.authorization == '#regex ^Bearer .+'

  @sadPath
  Scenario: Login con credenciales inválidas devuelve 401
    Given path 'login'
    And request { email: 'noexiste@qa.com', password: 'claveIncorrecta' }
    When method POST
    Then status 401
    And match response.message contains 'senha'

  @sadPath
  Scenario: Login sin el campo email devuelve 400
    Given path 'login'
    And request { password: 'teste' }
    When method POST
    Then status 400
    And match response.email contains 'obrigat'
