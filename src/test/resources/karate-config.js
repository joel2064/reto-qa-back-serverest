function fn() {
    var env = karate.env; // variable de entorno 'karate.env'
    if (!env) {
        env = 'dev'; // por defecto
    }
    karate.log('karate.env =', env);

    var config = {
        env: env,
        baseUrl: 'https://serverest.dev',
        // 'credentials' y 'token' se completan más abajo con un usuario efímero
        // registrado en cada corrida (ver helpers/get-token.feature).
        credentials: null,
        token: null
    };

    // Utilidad de generación de datos de prueba, disponible en todos los features
    config.DataUtils = Java.type('demo.utils.DataUtils');

    // ============ Esquemas JSON (externalizados en /schemas) ============
    // Se cargan una vez y quedan como variables globales para todos los features.
    // Nota: 'lista-usuarios-schema.json' referencia a 'schemaUsuario', por eso
    // este último debe cargarse también (lo hacemos aquí, siempre disponible).
    config.schemaUsuario = read('classpath:schemas/usuario-schema.json');
    config.schemaListaUsuarios = read('classpath:schemas/lista-usuarios-schema.json');
    config.schemaCadastro = read('classpath:schemas/cadastro-schema.json');

    var authResult = karate.callSingle('classpath:helpers/get-token.feature', config);
    config.token = authResult.authToken;
    // El helper registra un usuario efímero: reusamos SUS credenciales para que
    // el escenario de login exitoso (que usa 'credentials') también sea válido.
    config.credentials = { email: authResult.email, password: authResult.password };

    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);

    return config;
}
