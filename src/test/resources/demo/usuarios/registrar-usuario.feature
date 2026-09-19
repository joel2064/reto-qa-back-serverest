@usuarios @registrar
Feature: POST /usuarios - Registrar usuario

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header Authorization = token

  @happyPath @smokeTest
  Scenario: Registrar un usuario con datos válidos
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    And match response == schemaCadastro
    And match response.message == 'Cadastro realizado com sucesso'

  @sadPath
  Scenario: Registrar un usuario con email ya utilizado devuelve 400
    # 1) Creamos un usuario
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    # 2) Intentamos crearlo de nuevo con el MISMO email
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 400
    And match response.message contains 'usado'

  @sadPath
  Scenario: Registrar un usuario sin campos obligatorios devuelve 400
    Given path 'usuarios'
    And request { nome: 'Joel Ramos' }
    When method POST
    Then status 400
    And match response.email contains 'obrigat'
    And match response.password contains 'obrigat'

  @sadPath
  Scenario: Registrar un producto con token inválido devuelve 401
    # Sobrescribimos el Authorization del Background con un token inválido
    * def nombre = 'Producto QA ' + java.lang.System.currentTimeMillis()
    Given path 'produtos'
    And header Authorization = 'Bearer token-invalido-123'
    And request { nome: '#(nombre)', preco: 470, descricao: 'Token invalido', quantidade: 100 }
    When method POST
    Then status 401
    And match response.message contains 'Token'