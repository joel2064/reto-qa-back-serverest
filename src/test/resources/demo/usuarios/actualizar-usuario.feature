@usuarios @actualizar
Feature: PUT /usuarios/{_id} - Actualizar usuario

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header Authorization = token

  @happyPath @smokeTest
  Scenario: Actualizar un usuario existente y verificar el cambio
    # 1) Creamos el usuario
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    * def idUsuario = response._id

    # 2) Lo editamos
    * def emailNuevo = DataUtils.randomEmail()
    Given path 'usuarios', idUsuario
    And request { nome: 'Joel Ramos Editado', email: '#(emailNuevo)', password: 'nuevaPass123', administrador: 'false' }
    When method PUT
    Then status 200
    And match response.message contains 'alterado'

    # 3) Verificamos que el cambio realmente se aplicó
    Given path 'usuarios', idUsuario
    When method GET
    Then status 200
    And match response.nome == 'Joel Ramos Editado'
    And match response.email == emailNuevo
    And match response.administrador == 'false'

  @sadPath
  Scenario: Actualizar un usuario sin campos obligatorios devuelve 400
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    * def idUsuario = response._id

    Given path 'usuarios', idUsuario
    And request { nome: 'Solo Nombre' }
    When method PUT
    Then status 400
    And match response.email contains 'obrigat'
