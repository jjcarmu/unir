-- Creación de la tabla mis_viajes
CREATE TABLE mis_viajes (
    id SERIAL PRIMARY KEY,
    destino VARCHAR(255) NOT NULL,
    fecha_viaje DATE,
    descripcion TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insertar algunos datos de ejemplo
INSERT INTO mis_viajes (destino, fecha_viaje, descripcion) VALUES
('París', '2026-06-15', 'Viaje para conocer la Torre Eiffel.'),
('Roma', '2026-09-22', 'Visita al Coliseo y al Vaticano.'),
('Tokio', '2027-03-10', 'Exploración de la cultura y gastronomía japonesa.');