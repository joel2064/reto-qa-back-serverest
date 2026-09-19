package demo.utils;

import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

public class DataUtils {

    // Email aleatorio con prefijo por defecto
    public static String randomEmail() {
        return "usuario_" + UUID.randomUUID() + "@qa.com";
    }

    // Sobrecarga: email aleatorio con prefijo a elección
    public static String randomEmail(String prefix) {
        return prefix + "_" + UUID.randomUUID() + "@qa.com";
    }

    public static String randomId(List<Map<String, Object>> usuarios) {
        if (usuarios == null || usuarios.isEmpty()) {
            throw new RuntimeException("No hay usuarios disponibles para seleccionar un _id");
        }
        int indice = new Random().nextInt(usuarios.size());
        return String.valueOf(usuarios.get(indice).get("_id"));
    }
}