<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '/var/www/html/src/Database.php';

$database = new Database();
$db = $database->getConnection();

if ($db) {
    try {
        $query = "SELECT id, destino, fecha_viaje, descripcion FROM mis_viajes ORDER BY id ASC";
        $stmt = $db->prepare($query);
        $stmt->execute();

        $num = $stmt->rowCount();

        if ($num > 0) {
            $viajes_arr = array();
            $viajes_arr["records"] = array();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                extract($row);
                $viaje_item = array(
                    "id" => $id,
                    "destino" => $destino,
                    "fecha_viaje" => $fecha_viaje,
                    "descripcion" => $descripcion
                );
                array_push($viajes_arr["records"], $viaje_item);
            }

            http_response_code(200);
            echo json_encode($viajes_arr);
        } else {
            http_response_code(404);
            echo json_encode(array("message" => "No se encontraron viajes."));
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(array("message" => "Error al consultar la base de datos.", "error" => $e->getMessage()));
    }
} else {
    http_response_code(503);
    echo json_encode(array("message" => "No se pudo conectar a la base de datos."));
}

?>