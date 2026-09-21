@ignore
Feature: Helper - Obtener token de autenticación

  # Feature auxiliar usada por karate.callSingle en karate-config.js.
  # @ignore evita que se ejecute como un test normal de la suite.
  # Recibe baseUrl y credentials desde el config que le pasa callSingle.

  Scenario: Crear usuario efímero y hacer login
    * def uuid = '' + java.util.UUID.randomUUID()
    * def email = 'ci_' + uuid + '@qa.com'
    * def password = 'teste123'

    # 1) Registrar el usuario (POST /usuarios es público, no requiere token)
    Given url baseUrl
    And path 'usuarios'
    And header Content-Type = 'application/json'
    And request { nome: 'QA Automation', email: '#(email)', password: '#(password)', administrador: 'true' }
    When method POST
    Then status 201

    # 2) Login con ese usuario recién creado para obtener el token
    Given url baseUrl
    And path 'login'
    And header Content-Type = 'application/json'
    And request { email: '#(email)', password: '#(password)' }
    When method POST
    Then status 200
    * def authToken = response.authorization