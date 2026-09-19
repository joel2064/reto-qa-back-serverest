@ignore
Feature: Helper - Obtener token de autenticación

  # Feature auxiliar usada por karate.callSingle en karate-config.js.
  # @ignore evita que se ejecute como un test normal de la suite.
  # Recibe baseUrl y credentials desde el config que le pasa callSingle.

  Scenario: Login para obtener token
    Given url baseUrl
    And path 'login'
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request credentials
    When method POST
    Then status 200
    * def authToken = response.authorization
