CREATE TABLE flights (
airline VARCHAR(100) NOT NULL,
arrival VARCHAR(100) NOT NULL,
losAngeles INT NOT NULL,
phoenix INT NOT NULL,
sanDiego INT NOT NULL,
sanFrancisco INT NOT NULL,
seattle INT NOT NULL);
INSERT INTO flights (airline, arrival, losAngeles, phoenix, sanDiego, sanFrancisco, seattle)
VALUES
('ALASKA', 'onTime', 497, 221,  212, 503, 1841),
('ALASKA', 'delayed', 62, 12, 20, 102, 305),
('AM WEST', 'onTime', 694, 4840, 383,  320,  201),
('AM WEST', 'delayed', 117, 415, 65, 129, 61);