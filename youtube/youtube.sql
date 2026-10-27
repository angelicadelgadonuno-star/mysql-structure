DROP DATABASE IF EXISTS youtube;
CREATE DATABASE youtube;
USE youtube;

CREATE TABLE users(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    birthday DATE NOT NULL,
    gender VARCHAR (20) NOT NULL,
    country VARCHAR (20) NOT NULL,
    postal_code VARCHAR (20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(65) NOT NULL
);

CREATE TABLE channels(
    channel_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (30) NOT NULL,
    description VARCHAR (100),
    creation_date DATE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    UNIQUE (user_id)
);

CREATE TABLE videos(
    video_id INT AUTO_INCREMENT PRIMARY KEY,
    video_title VARCHAR (30) NOT NULL,
    file_name VARCHAR (30) NOT NULL,
    description VARCHAR (250),
    video_size BIGINT UNSIGNED,
    length TIME NOT NULL,
    thumbnail VARCHAR (255),
    total_views BIGINT UNSIGNED NOT NULL DEFAULT(0) ,
    status ENUM('public', 'hidden', 'private') NOT NULL,
    upload_date DATETIME NOT NULL,
    channel_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY(channel_id) REFERENCES channels (channel_id)
);

CREATE TABLE labels(
    label_Id INT AUTO_INCREMENT PRIMARY KEY,
    label_name VARCHAR (60) NOT NULL,
    UNIQUE(label_name)
);
    
CREATE TABLE video_labels(
    video_label_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT NOT NULL,
    label_id INT NOT NULL,
    FOREIGN KEY (video_id) REFERENCES videos (video_id),
    FOREIGN KEY (label_id) REFERENCES labels (label_id),
    UNIQUE (video_id, label_id)
);

CREATE TABLE comments(
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    comment TEXT NOT NULL,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (video_id) REFERENCES videos (video_id)
);

CREATE TABLE video_likes(
    video_like_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (video_id) REFERENCES videos (video_id),
    UNIQUE (user_id, video_id)
);

CREATE TABLE video_dislikes(
    video_dislike_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (video_id) REFERENCES videos (video_id),
    UNIQUE (user_id, video_id)
);

CREATE TABLE comment_likes(
    comment_like_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    comment_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
    UNIQUE (user_id, comment_id)
);

CREATE TABLE comment_dislikes(
    comment_dislike_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    comment_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
    UNIQUE (user_id, comment_id)
);

CREATE TABLE playlists(
    playlist_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    playlist_name VARCHAR (50) NOT NULL,
    created_at DATE NOT NULL,
    privacy ENUM('public', 'private') NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users (user_id)
);

CREATE TABLE playlist_videos(
    playlist_video_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    video_id INT NOT NULL,
    playlist_id INT NOT NULL,
    FOREIGN KEY(video_id) REFERENCES videos (video_id),
    FOREIGN KEY(playlist_id) REFERENCES playlists(playlist_id),
    UNIQUE(playlist_id, video_id)
);

CREATE TABLE subscriptions(
    subscription_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    channel_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users (user_id),
    FOREIGN KEY(channel_id) REFERENCES channels(channel_id),
    UNIQUE(user_id, channel_id)
);

-- ============================================================
-- DATOS DE EJEMPLO (demostrativo, NO forma parte del modelo)
-- Ejecutar DESPUÉS de crear todas las tablas.
-- Orden respeta las FK.
-- ============================================================

-- ------------------------------------------------------------
-- 1. USUARIOS  (user_id 1, 2, 3)
-- ------------------------------------------------------------
INSERT INTO users (name, birthday, gender, country, postal_code, email, password)
VALUES
('Ana García',   '1995-03-12', 'female', 'España', '28001', 'ana@mail.com',   'hash_ana_123'),
('Luis Pérez',   '1988-07-25', 'male',   'España', '08001', 'luis@mail.com',  'hash_luis_456'),
('Marta Ruiz',   '2000-11-02', 'female', 'México', '01000', 'marta@mail.com', 'hash_marta_789');

-- ------------------------------------------------------------
-- 2. CANALES  (channel_id 1, 2)
-- Ana tiene canal (1), Luis tiene canal (2), Marta NO tiene canal
-- ------------------------------------------------------------
INSERT INTO channels (name, description, creation_date, user_id)
VALUES
('Canal de Ana',  'Recetas y cocina fácil', '2023-01-15', 1),
('Canal de Luis', 'Tecnología y gadgets',   '2022-06-01', 2);

-- ------------------------------------------------------------
-- 3. VÍDEOS  (video_id 1, 2, 3, 4)
-- OJO Opción B: el vídeo 3 lo publica Marta (user_id=3)
-- en el canal de Luis (channel_id=2). Colaboración.
-- ------------------------------------------------------------
INSERT INTO videos
(video_title, file_name, description, video_size, length, thumbnail, total_views, status, upload_date, channel_id, user_id)
VALUES
('Tortilla de patatas', 'tortilla.mp4', 'Receta clásica', 104857600, '00:12:35', 'tortilla.jpg', 1500, 'public',  '2024-02-10 10:30:00', 1, 1),
('Paella valenciana',   'paella.mp4',   'Receta tradicional', 209715200, '00:25:10', 'paella.jpg',   320,  'hidden',  '2024-03-05 18:00:00', 1, 1),
('Review móvil XYZ',    'review.mp4',   'Análisis del móvil', 52428800,  '00:08:20', 'review.jpg',   9800, 'public',  '2024-04-01 12:00:00', 2, 3),
('Setup gaming',        'setup.mp4',    'Mi setup 2024',      15728640,  '00:01:05', 'setup.jpg',    0,    'private', '2024-05-20 09:15:00', 2, 2);

-- ------------------------------------------------------------
-- 4. ETIQUETAS  (label_id 1, 2, 3)
-- ------------------------------------------------------------
INSERT INTO labels (label_name)
VALUES
('cocina'),
('tecnologia'),
('gaming');

-- ------------------------------------------------------------
-- 5. VÍDEO-ETIQUETA
-- ------------------------------------------------------------
INSERT INTO video_labels (video_id, label_id)
VALUES
(1, 1),  -- Tortilla -> cocina
(2, 1),  -- Paella   -> cocina
(3, 2),  -- Review   -> tecnologia
(4, 2),  -- Setup    -> tecnologia
(4, 3);  -- Setup    -> gaming

-- ------------------------------------------------------------
-- 6. COMENTARIOS  (comment_id 1, 2, 3)
-- ------------------------------------------------------------
INSERT INTO comments (comment, user_id, video_id, created_at)
VALUES
('¡Qué buena pinta la tortilla!', 2, 1, '2024-02-11 09:00:00'),
('Yo le pongo cebolla, pero buen vídeo.', 3, 1, '2024-02-11 10:15:00'),
('¿Qué tal la batería del móvil?', 1, 3, '2024-04-02 08:30:00');

-- ------------------------------------------------------------
-- 7. LIKES / DISLIKES DE VÍDEO
-- ------------------------------------------------------------
INSERT INTO video_likes (user_id, video_id, created_at)
VALUES
(2, 1, '2024-02-12 11:00:00'),
(3, 1, '2024-02-13 12:00:00'),
(1, 3, '2024-04-03 13:00:00'),
(2, 3, '2024-04-04 14:00:00');

INSERT INTO video_dislikes (user_id, video_id, created_at)
VALUES
(1, 2, '2024-03-06 15:00:00'),
(3, 2, '2024-03-07 16:00:00');

-- ------------------------------------------------------------
-- 8. LIKES / DISLIKES DE COMENTARIO
-- ------------------------------------------------------------
INSERT INTO comment_likes (user_id, comment_id, created_at)
VALUES
(1, 1, '2024-02-11 10:00:00'),
(1, 2, '2024-02-11 11:00:00');

INSERT INTO comment_dislikes (user_id, comment_id, created_at)
VALUES
(2, 3, '2024-04-02 09:00:00');

-- ------------------------------------------------------------
-- 9. PLAYLISTS  (playlist_id 1, 2)
-- ------------------------------------------------------------
INSERT INTO playlists (playlist_name, created_at, privacy, user_id)
VALUES
('Mis recetas favoritas', '2024-02-15', 'public',  1),
('Tecnología que me gusta', '2024-04-10', 'private', 2);

-- ------------------------------------------------------------
-- 10. PLAYLIST-VIDEO
-- ------------------------------------------------------------
INSERT INTO playlist_videos (video_id, playlist_id)
VALUES
(1, 1),
(2, 1),
(3, 2);

-- ------------------------------------------------------------
-- 11. SUSCRIPCIONES
-- ------------------------------------------------------------
INSERT INTO subscriptions (user_id, channel_id)
VALUES
(2, 1),  -- Luis sigue a Ana
(3, 1),  -- Marta sigue a Ana
(1, 2);  -- Ana sigue a Luis

-- ============================================================
-- 12. PRUEBAS DE INTEGRIDAD (deben FALLAR)
-- Descomenta UNA A UNA y comprueba que MySQL lanza error.
-- Vuelve a comentarlas después.
-- ============================================================

-- Like duplicado: Luis ya dio like al vídeo 1
-- INSERT INTO video_likes (user_id, video_id, created_at) VALUES (2, 1, NOW());

-- Like + dislike mismo usuario/vídeo: Luis ya dio like al 1
-- INSERT INTO video_dislikes (user_id, video_id, created_at) VALUES (2, 1, NOW());

-- Suscripción duplicada: Luis ya sigue el canal 1
-- INSERT INTO subscriptions (user_id, channel_id) VALUES (2, 1);

-- Email duplicado
-- INSERT INTO users (name, birthday, gender, country, postal_code, email, password)
-- VALUES ('X', '2000-01-01', 'male', 'ES', '00000', 'ana@mail.com', 'x');

-- Etiqueta duplicada
-- INSERT INTO labels (label_name) VALUES ('cocina');

-- Vídeo repetido en la misma playlist: el vídeo 1 ya está en la playlist 1
-- INSERT INTO playlist_videos (video_id, playlist_id) VALUES (1, 1);

-- FK inexistente: channel_id 999 no existe
-- INSERT INTO videos (video_title, file_name, description, video_size, length, thumbnail, total_views, status, upload_date, channel_id, user_id)
-- VALUES ('X', 'x.mp4', 'd', 1, '00:00:01', 't', 0, 'public', NOW(), 999, 1);

-- FK inexistente: video_id 999 no existe
-- INSERT INTO video_likes (user_id, video_id, created_at) VALUES (1, 999, NOW());


