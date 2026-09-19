function fn() {
    var env = karate.env; // variable de entorno 'karate.env'
    if (!env) {
        env = 'dev'; // por defecto
    }
    karate.log('karate.env =', env);

    var config = {
        env: env,
        baseUrl: 'https://serverest.dev',
        credentials: {
            email: 'fulano@qa.com',
            password: 'teste'
        }
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

    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);

    return config;
}
