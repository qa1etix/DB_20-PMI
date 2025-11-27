CREATE USER "i.ivanov" WITH
	PASSWORD '1234'

CREATE USER "d.qwerty" WITH
	PASSWORD '4321'

GRANT Manager TO "i.ivanov"
GRANT operator_ TO "d.qwerty"

