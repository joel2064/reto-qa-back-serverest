package demo;

import com.intuit.karate.junit5.Karate;

/**
 * Runner principal: ejecuta todos los .feature dentro de la carpeta 'demo'
 * Clic derecho → Run para lanzar desde IntelliJ
 */
class TestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:demo").relativeTo(getClass());
    }
}
