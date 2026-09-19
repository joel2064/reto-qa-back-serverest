@usuarios @eliminar
Feature: DELETE /usuarios/{_id} - Eliminar usuario

  # DELETE siempre responde 200; el mensaje distingue el resultado:
  #   - "Registro excluído com sucesso"  (sí borró)
  #   - "Nenhum registro excluído"       (el _id no existía)
  # Restricción del contrato: no se puede excluir un usuario con carrinho,
  # por eso creamos el usuario dentro del test (nunca tendrá carrito) en vez
  # de elegir uno al azar de la lista, lo que evita falsos negativos.

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header Authorization = token

  @happyPath @smokeTest
  Scenario: Eliminar un usuario existente y verificar que ya no exista
    # 1) Creamos el usuario
    * def email = DataUtils.randomEmail()
    Given path 'usuarios'
    And request { nome: 'Joel Ramos', email: '#(email)', password: 'djTiesto', administrador: 'true' }
    When method POST
    Then status 201
    * def idUsuario = response._id

    # 2) Lo eliminamos
    Given path 'usuarios', idUsuario
    When method DELETE
    Then status 200
    And match response.message contains 'sucesso'

    # 3) Verificamos que ya no exista (la búsqueda debe dar 400)
    Given path 'usuarios', idUsuario
    When method GET
    Then status 400
    And match response.message contains 'encontrado'

  @sadPath
  Scenario: Eliminar un usuario inexistente responde 200 con "Nenhum registro excluído"
    Given path 'usuarios', 'idQueNoExiste123'
    When method DELETE
    Then status 200
    And match response.message contains 'Nenhum'
