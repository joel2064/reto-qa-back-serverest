@usuarios @listar
Feature: GET /usuarios - Listar usuarios

  Background:
    * url baseUrl
    * header Authorization = token

  @happyPath @smokeTest
  Scenario: Listar todos los usuarios y validar el esquema de la respuesta
    Given path 'usuarios'
    When method GET
    Then status 200
    And match response == schemaListaUsuarios
