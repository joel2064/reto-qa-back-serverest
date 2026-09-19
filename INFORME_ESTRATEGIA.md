# Informe de Estrategia de Automatización

## 1. Objetivo y alcance

Automatizar la validación de la **API de Usuarios** de ServeRest cubriendo el CRUD
completo (crear, listar, buscar, actualizar, eliminar) más la autenticación, con
casos positivos y negativos, validación de esquemas JSON y datos de prueba dinámicos.

## 2. Enfoque de pruebas

### Cobertura positiva y negativa
Cada operación se prueba en su camino feliz (`@happyPath`) y en sus caminos de error
(`@sadPath`). Los negativos se derivaron del propio contrato: email duplicado, campos
obligatorios ausentes, credenciales inválidas e IDs inexistentes.

### Pruebas autocontenidas
En lugar de depender de IDs fijos del contrato (que ServeRest elimina al limpiar su
base), los escenarios de buscar, actualizar y eliminar **crean su propio usuario**,
capturan el `_id` real de la respuesta y operan sobre él. Esto elimina la fragilidad
por datos externos y hace las pruebas repetibles e independientes entre sí.

### Verificación de efectos, no solo de status
Actualizar y eliminar no se limitan a comprobar el código HTTP: tras el `PUT` se hace
un `GET` que confirma que el dato cambió, y tras el `DELETE` un `GET` que confirma que
el usuario ya no existe. Así se evita el falso positivo de un endpoint que responde
"éxito" sin haber modificado nada.

### Manejo del comportamiento particular de DELETE
`DELETE /usuarios/{_id}` siempre devuelve 200; la diferencia está en el mensaje
(`"Registro excluído com sucesso"` vs `"Nenhum registro excluído"`). El caso negativo
valida el mensaje, no el status, porque un assert solo sobre 200 ocultaría un borrado
que no ocurrió.

## 3. Patrones y buenas prácticas aplicadas

| Patrón | Implementación |
|--------|----------------|
| **Configuración centralizada** | `karate-config.js` define `baseUrl`, credenciales y esquemas; un solo punto de cambio por entorno (`karate.env`). |
| **Un feature por endpoint** | Cada endpoint tiene su archivo, lo que mejora la legibilidad, el mantenimiento y la ejecución selectiva. |
| **Background para setup común** | `url` y headers se definen una vez por feature, evitando repetición. |
| **Datos de prueba dinámicos** | `DataUtils.randomEmail()` (UUID) garantiza emails únicos y evita colisiones por email duplicado. |
| **Validación de esquema JSON** | Esquemas reutilizables (`schemaUsuario`, `schemaListaUsuarios`, `schemaCadastro`) validados con `match response == schema` y `#[] schema` para arreglos. |
| **Estrategia de etiquetado** | Tres dimensiones combinables: tipo (`@happyPath`/`@sadPath`), criticidad (`@smokeTest`) y funcionalidad. |
| **Aserciones por palabra clave** | `match ... contains` sobre los mensajes, robusto ante cambios menores de redacción del backend. |

## 4. Validación de esquemas JSON

Los esquemas se declaran una sola vez en `karate-config.js` y se reutilizan en los
features. Ejemplo del esquema de usuario:

```javascript
schemaUsuario = {
  nome: '#string',
  email: '#string',
  password: '#string',
  administrador: '#regex (true|false)',   // ServeRest devuelve string, no booleano
  _id: '#string'
};
```

El listado valida cada elemento del arreglo con la macro `'#[] schemaUsuario'`.

## 5. Gestión de datos de prueba

`DataUtils` (Java) centraliza la generación de datos:
- `randomEmail()` / `randomEmail(prefix)` — emails únicos con UUID.
- `randomId(usuarios)` — selección aleatoria de un `_id` de una lista (disponible para
  escenarios de datos dinámicos).

Al ser una clase Java, es reutilizable, testeable y escalable a más helpers.

## 6. Posibles mejoras futuras

- Ejecución en CI (GitHub Actions) con publicación del reporte de Karate.
- `Scenario Outline` con `Examples` para pruebas data-driven de validaciones.
- Paralelización con el `Runner` de Karate (`Runner.parallel`).
- Separar entornos reales (`dev`/`staging`) vía `karate.env`.
