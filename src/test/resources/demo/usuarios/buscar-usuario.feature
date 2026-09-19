@usuarios @buscar
Feature: GET /usuarios/{_id} - Buscar usuario por ID

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header Authorization = token

  @happyPath @smokeTest
  Scenario: Buscar un usuario existente por su ID
    # Creamos el dato para no depender de IDs fijos que ServeRest limpia
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    * def idUsuario = response._id

    Given path 'usuarios', idUsuario
    When method GET
    Then status 200
    And match response == schemaUsuario
    And match response._id == idUsuario
    And match response.email == email

  @sadPath
  Scenario: Buscar usuario por ID inexistente devuelve 400
    Given path 'usuarios', 'idQueNoExiste123'
    When method GET
    Then status 400
    And match response.message contains 'encontrado'
