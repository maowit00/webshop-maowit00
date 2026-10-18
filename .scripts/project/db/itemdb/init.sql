DROP TABLE IF EXISTS item;

CREATE TABLE item (
	id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	price NUMERIC(10, 2) NOT NULL,
	availability INTEGER NOT NULL
);

INSERT INTO item (title, description, price, availability) VALUES ('Principles of transaction processing', 'A clear and concise guide for anyone involved in developing applications', 9.99, 3);
INSERT INTO item (title, description, price, availability) VALUES ('REST und http', 'Eine theoretisch fundierte und praxistaugliche Anleitung zum Einsatz von RESTful HTTP', 19.95, 5);
INSERT INTO item (title, description, price, availability) VALUES ('The inner game of tennis', 'The timeless guide to achieving the state of “relaxed concentration” that’s not only the key to peak performance in tennis but the secret to success in life itself', 9.99, 7);
INSERT INTO item (title, description, price, availability) VALUES ('The IT Crowd', 'The comedic misadventures of Roy, Moss and their grifting supervisor Jen, a rag-tag team of IT support workers at a large corporation headed by a hotheaded yuppie.', 14.99, 11);
INSERT INTO item (title, description, price, availability) VALUES ('Winning ugly - Mentale Kriegsführung im Tennis', 'Wie Sie mit der Strategie des legendären Erfolgstrainers bessere Spieler schlagen.', 14.99, 13);
INSERT INTO item (title, description, price, availability) VALUES ('Chuck', 'When a computer geek inadvertently downloads critical government secrets into his brain, both the CIA and the NSA assign an agent to protect him and exploit his newfound skills.', 14.99, 17);
