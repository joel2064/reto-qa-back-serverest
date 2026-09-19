# Suite de Pruebas Automatizadas - API de Usuarios (ServeRest)

Suite de pruebas de API para la **API de Usuarios** de [ServeRest](https://serverest.dev/),
implementada con **Karate DSL**. Cubre el CRUD completo con casos positivos y negativos,
validación de esquemas JSON y generación dinámica de datos de prueba.

## Requisitos previos

- **Java JDK 11** o superior
- **Maven 3.6+**
- Conexión a internet (la API pública `https://serverest.dev` es el entorno bajo prueba)

Verificar la instalación:

```bash
java -version
mvn -version
```

## Estructura del proyecto

```
karate-demo/
├── pom.xml
├── README.md
├── INFORME_ESTRATEGIA.md
└── src/test/
    ├── java/demo/
    │   ├── TestRunner.java          # Runner: ejecuta todos los features
    │   ├── ServeRest.java           # Runner alternativo
    │   └── utils/
    │       └── DataUtils.java       # Helper de datos de prueba (email/id aleatorios)
    └── resources/
        ├── karate-config.js         # baseUrl, credenciales y esquemas JSON reutilizables
        ├── logback-test.xml         # Configuración de logs
        └── demo/
            ├── login.feature
            └── usuarios/
                ├── listar-usuarios.feature      # GET  /usuarios
                ├── registrar-usuario.feature    # POST /usuarios
                ├── buscar-usuario.feature       # GET  /usuarios/{_id}
                ├── actualizar-usuario.feature   # PUT  /usuarios/{_id}
                └── eliminar-usuario.feature     # DELETE /usuarios/{_id}
```

## Cómo ejecutar

### Todos los tests

```bash
mvn clean test
```

### Ejecutar por etiqueta (tags)

```bash
# Solo pruebas de humo (subconjunto crítico)
mvn test "-Dkarate.options=--tags @smokeTest"

# Solo caminos felices
mvn test "-Dkarate.options=--tags @happyPath"

# Solo caminos de error
mvn test "-Dkarate.options=--tags @sadPath"

# Por funcionalidad (ej. solo registrar)
mvn test "-Dkarate.options=--tags @registrar"

# Combinaciones: errores de registro (AND se expresa con espacio)
mvn test "-Dkarate.options=--tags @sadPath @registrar"
```

### Desde IntelliJ IDEA

Clic derecho sobre `TestRunner.java` → **Run 'TestRunner'**, o el ícono ▶ junto a cada
`Scenario` dentro de un `.feature`.

## Reporte de resultados

Al finalizar la ejecución, Karate genera un reporte HTML en:

```
target/karate-reports/karate-summary.html
```

Ábrelo en el navegador para ver el detalle de cada escenario, request/response y tiempos.

## Estrategia de tags

| Tag | Significado |
|-----|-------------|
| `@happyPath` | Flujos exitosos (camino feliz) |
| `@sadPath`   | Flujos de error / validaciones |
| `@smokeTest` | Subconjunto crítico para verificación rápida |
| `@login`, `@listar`, `@registrar`, `@buscar`, `@actualizar`, `@eliminar` | Clasificación por funcionalidad |

## Endpoints cubiertos

| Método | Endpoint | Positivos | Negativos |
|--------|----------|-----------|-----------|
| POST   | `/login` | Login exitoso | 401 credenciales inválidas, 400 sin email |
| GET    | `/usuarios` | Listar + esquema | — |
| POST   | `/usuarios` | Registrar válido | 400 email duplicado, 400 campos faltantes |
| GET    | `/usuarios/{_id}` | Buscar existente | 400 ID inexistente |
| PUT    | `/usuarios/{_id}` | Actualizar + verificar | 400 campos faltantes |
| DELETE | `/usuarios/{_id}` | Eliminar + verificar | 200 "Nenhum registro excluído" |

## Notas

- Los endpoints de `/usuarios` en ServeRest son públicos (no requieren token); el
  feature de `login` se incluye para cubrir la autenticación de forma independiente.
- ServeRest limpia periódicamente su base de datos, por eso los tests **crean sus
  propios datos** en lugar de depender de IDs fijos.
