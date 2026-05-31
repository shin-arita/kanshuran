CREATE TYPE staff_status AS ENUM ('active', 'inactive');
CREATE TYPE bottle_remaining_level AS ENUM ('many', 'low', 'very_low');
CREATE TYPE bottle_status AS ENUM ('stored', 'finished');
CREATE TYPE notification_reservation_status AS ENUM ('pending', 'cancelled');
CREATE TYPE notification_delivery_status AS ENUM ('pending', 'sent', 'failed', 'cancelled');
