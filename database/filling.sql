-- Цеха (workshops)
INSERT INTO workshops (workshop_id, workshop_name, workshop_type, address,
vehicle_type)
VALUES 
(1, 'Цех №1', 'Механический', 'ул. Индустриальная, 5', 'Bus'),
(2, 'Цех №2', 'Кузовной', 'ул. Южная, 10', 'Truck, Car' );

-- Начальники цехов (workshop_managers)
INSERT INTO workshop_managers (manager_id, full_name, position, workshop_id)
VALUES 
(1, 'Игнатов Игорь Игнатьевич', 'Начальник цеха', 1),
(2, 'Васильев Василий Васильевич', 'Начальник цеха', 2);

-- Бригады (teams)
INSERT INTO teams (team_id, team_name, foreman_id)
VALUES 
(1, 'Бригада 1', NULL),
(2, 'Бригада 2', NULL);

-- Персонал (maintenance_staff)
INSERT INTO maintenance_staff (staff_id, full_name, position, team_id)
VALUES 
(1, 'Фёдоров Фёдор Фёдорович', 'Слесарь', 1),
(2, 'Кузнецов Кузьма Кузьмич', 'Сварщик', 1),
(3, 'Борисов Борис Борисович', 'Бригадир', 1),
(4, 'Андреев Андрей Андреевич', 'Слесарь', 2),
(5, 'Степанов Степанович Степанович', 'Бригадир', 2);

-- Назначим бригадиров в teams
UPDATE teams SET foreman_id = 3 WHERE team_id = 1;
UPDATE teams SET foreman_id = 5 WHERE team_id = 2;

-- Транспорт (vehicles)
INSERT INTO vehicles (vehicle_id, vehicle_type, brand, manufacture_year,
 commission_date, decommission_date, capacity, payload_capacity, us-age_intensity, mileage, repair_count, repair_cost_total)
VALUES 
(1, 'Bus', 'Mercedes-Benz Citaro', 2018, DATE '2018-05-10', NULL, 100, NULL, 8, 220000, 4, 500000),
(2, 'Truck', 'Volvo FH', 2015, DATE '2015-03-15', NULL, NULL, 20000, 7, 450000, 6, 750000),
(3, 'Car', 'Toyota Corolla', 2020, DATE '2020-07-01', NULL, 5, NULL, 5, 80000, 1, 50000),
(4, 'Bus', 'MAN Lion’s City', 2017, DATE '2017-09-20', DATE '2025-01-01', 95, NULL, 7, 300000, 8, 1000000),
(5, 'Truck', 'Scania R450', 2019, DATE '2019-11-11', NULL, NULL, 18000, 6, 200000, 3, 300000);

-- Водители (drivers)
INSERT INTO drivers (driver_id, full_name, experience_years, license_category)
VALUES 
(1, 'Иванов Иван Иванович', 12, 'D'),
(2, 'Петров Петр Петрович', 8, 'C'),
(3, 'Сидоров Сергей Сергеевич', 5, 'B'),
(4, 'Алексеев Алексей Алексеевич', 3, 'D'),
(5, 'Михайлов Михаил Михайлович', 15, 'C');

-- Закрепление водителей (vehicle_driver_assignments)
INSERT INTO vehicle_driver_assignments (assignment_id, driver_id, vehicle_id, assignment_start_date, assignment_end_date)
VALUES 
(1, 1, 1, DATE '2022-01-01', NULL),
(2, 2, 2, DATE '2020-06-01', NULL),
(3, 3, 3, DATE '2021-03-15', NULL),
(4, 4, 1, DATE '2023-05-01', NULL),
(5, 5, 2, DATE '2023-02-01', NULL);

-- Маршруты (routes)
INSERT INTO routes (route_id, route_number, description, passenger_count)
VALUES 
(1, 'A1', 'Центральный вокзал - Парк', 250),
(2, 'B2', 'Школа - Торговый центр', 180),
(3, 'C3', 'Стадион - Больница', 300);

-- Закрепление транспорта за маршрутами (vehicle_route_assignments)
INSERT INTO vehicle_route_assignments (assignment_id, vehicle_id, route_id, assignment_start_date, assignment_end_date)
VALUES 
(1, 1, 1, DATE '2022-05-01', NULL),
(2, 4, 3, DATE '2020-03-01', DATE '2024-12-31');

-- Ремонты (repairs)
INSERT INTO repairs (repair_id, vehicle_id, team_id, repair_date, 
work_volume, repair_cost, replaced_parts_count)
VALUES 
(1, 1, 1, DATE '2023-06-10', 20, 150000, 2),
(2, 2, 2, DATE '2022-11-05', 10, 70000, 1),
(3, 4, 1, DATE '2021-04-12', 25, 200000, 3),
(4, 5, 2, DATE '2024-08-01', 15, 80000, 1);

-- Узлы и агрегаты (parts)
INSERT INTO parts (part_id, part_name)
VALUES 
(1, 'Двигатель'),
(2, 'Коробка передач'),
(3, 'Тормозная система'),
(4, 'Подвеска'),
(5, 'Радиатор');

-- Замены узлов (repair_part_replacements)
INSERT INTO repair_part_replacements (replacement_id, repair_id, part_id, sta-tus)
VALUES 
(1, 1, 1, 'Заменено'),
(2, 1, 3, 'Заменено'),
(3, 3, 2, 'Заменено'),
(4, 4, 4, 'Заменено');

INSERT INTO freight_transportation(vehicle_id, date_of_transportation)
VALUES (2,DATE  '2016-05-10'),
       (5,DATE  '2020-05-10'),
       (2,DATE  '2017-05-10'),
       (5, DATE '2020-05-14'),
       (2, DATE  '2016-05-16'),
       (5, DATE '2020-05-14'),
       (2, DATE '2016-05-10'),
       (5, DATE '2020-06-10'),
       (2, DATE '2017-06-10'),
       (5, DATE '2020-06-14'),
       (2, DATE '2016-06-16'),
       (5, DATE '2020-06-14');


