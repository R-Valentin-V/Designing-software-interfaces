CREATE OR REPLACE PACKAGE BODY pkg_transport_info
IS
 FUNCTION vehicle RETURN SYS_REFCURSOR
   -- 1 Получить список всех транспортных средств предприятия
 IS 
   p_curs_transport_info  SYS_REFCURSOR;       
  BEGIN 
    
   OPEN p_curs_transport_info FOR 
      SELECT     vehicle_id AS "ID транспорта",
                 vehicle_type AS "Тип транспорта",
                 brand AS "Марка",
                 manufacture_year AS "Год выпуска",
                 commission_date AS "Дата ввода в эксплуатацию",
                 decommission_date AS "Дата вывода из эксплуатации",
                 capacity AS "Вместимость (пассажиры)",
                 payload_capacity AS "Грузоподъемность (кг)",
                 usage_intensity AS "Интенсивность использования",
                 mileage AS "Пробег (км)",
                 repair_count AS "Количество ремонтов",
                 repair_cost_total AS "Общая стоимость ремонтов"
      FROM VEHICLES;
   
   RETURN p_curs_transport_info;
    
  END vehicle;

  FUNCTION get_driver_list(p_vehicle_id NUMBER) RETURN SYS_REFCURSOR
    -- 2 Получите перечень и общее число водителей по предприятию, по указан-ной автомашине. 

  IS
      f_vehicle_id     vehicles.vehicle_id%TYPE;
      p_curs_transport_info  SYS_REFCURSOR; 
      
  BEGIN 
    
    SELECT vehicle_id
    INTO f_vehicle_id
    FROM vehicles
    WHERE vehicle_id = p_vehicle_id;
    
    OPEN p_curs_transport_info FOR
       SELECT 
            driver_id AS "ID водителя",
            full_name AS "ФИО водителя",
            experience_years AS "Стаж (лет)",
            license_category AS "Категория водительского удостоверения"                   
       FROM drivers 
       WHERE EXISTS( SELECT 1
                     FROM vehicle_driver_assignments 
                     WHERE vehicle_id = f_vehicle_id
                     AND vehicle_driver_assignments.driver_id =
 drivers.driver_id);
                     
    RETURN p_curs_transport_info;
    
  END get_driver_list;
  
  
   FUNCTION get_driver_vehicle_distribution RETURN SYS_REFCURSOR
     --3 Получите распределение водителей по автомобилям
   IS
      p_curs_transport_info  SYS_REFCURSOR; 
   BEGIN 
     
     OPEN p_curs_transport_info FOR 
       SELECT 
          v.vehicle_id AS "ID транспорта",
          v.vehicle_type AS "Тип транспорта",
          v.brand AS "Марка",
          COUNT(1) AS "Количество водителей"
       FROM vehicles v
       JOIN vehicle_driver_assignments vd
       ON v.vehicle_id = vd.vehicle_id
       GROUP BY v.vehicle_id, v.vehicle_type, v.brand
       ORDER BY COUNT(1) DESC;
     
     RETURN p_curs_transport_info;
     
   END get_driver_vehicle_distribution;
   
    FUNCTION get_vehicle_route_distribution RETURN SYS_REFCURSOR
      --4 Получить данные о закреплении пассажирского транспорта за маршрута-ми.
    IS
       p_curs_transport_info  SYS_REFCURSOR; 
    BEGIN 
       
       OPEN p_curs_transport_info FOR
         SELECT 
               r.route_number AS "Номер маршрута",
               r.description AS "Описание маршрута",
               COUNT(1) AS "Количество транспорта"
         FROM routes  r
         JOIN vehicle_route_assignments  vr
         ON r.route_id = vr.route_id
         GROUP BY r.route_number, r.description
         ORDER BY  COUNT(1) DESC;
      RETURN p_curs_transport_info;
    END get_vehicle_route_distribution; 
   
    FUNCTION get_vehicle_mileage(p_vehicle_type VARCHAR2, 
                                p_vehicle_id NUMBER)
                                RETURN SYS_REFCURSOR
     --5 Получите сведения о пробеге автотранспорта определенной категории или конкретной автомашины.                           
   IS
      p_curs_transport_info  SYS_REFCURSOR; 
   BEGIN 
    
       OPEN p_curs_transport_info FOR
         SELECT 
                vehicle_id AS "ID транспорта",
                vehicle_type AS "Тип транспорта",
                mileage AS "Пробег (км)"
         FROM vehicles 
         WHERE vehicle_type = NVL(p_vehicle_type, vehicle_type)AND
               vehicle_id = NVL(p_vehicle_id, vehicle_id);
             
    RETURN p_curs_transport_info;
    
   END get_vehicle_mileage;
   
   FUNCTION get_repair_info(p_vehicle_type VARCHAR2,
                            p_brand VARCHAR2,
                            p_vehicle_id NUMBER, 
                            p_date_from DATE,
                            p_date_to DATE)
                            RETURN SYS_REFCURSOR
    -- 6) Получите данные о числе ремонтов и их стоимости для автотранспорта определенной категории, отдельной марки автотранспорта или указанной автомаши-ны за указанный период. 
 
    IS
       p_curs_transport_info  SYS_REFCURSOR; 
    BEGIN 
      OPEN p_curs_transport_info FOR
           SELECT 
               ve.vehicle_id AS "ID транспорта",
               ve.vehicle_type AS "Тип транспорта",
               ve.brand AS "Марка",
               re.repair_cost AS "Стоимость ремонта",
               re.replaced_parts_count AS "Количество заменённых узлов"
           FROM repairs re
           JOIN vehicles  ve
           ON re.vehicle_id = ve.vehicle_id
           WHERE  ve.vehicle_id = NVL(p_vehicle_id,ve.vehicle_id) AND 
                  ve.vehicle_type = NVL(p_vehicle_type,ve.vehicle_type) AND
                  ve.brand = NVL(p_brand,ve.brand) AND
                  re.repair_date BETWEEN NVL(p_date_from,re.repair_date) AND NVL(p_date_to,re.repair_date);
                  
     RETURN p_curs_transport_info;
        
    END get_repair_info; 
    
    FUNCTION get_staff_hierarchy 
    RETURN SYS_REFCURSOR 
    -- 7) Получите данные о подчиненности персонала: рабочие – бригадиры – ма-стера – начальники участков и цехов.  
    IS
        p_curs_transport_info  SYS_REFCURSOR; 
    BEGIN 
        OPEN p_curs_transport_info FOR
             SELECT 
                  ws.workshop_name AS "Цех / Гараж",
                  wm.full_name AS "Начальник цеха / участка",
                  t.team_name AS "Бригада",
                  bf.full_name AS "Бригадир",
                  ms.full_name AS "Рабочий",
                  ms.position AS "Должность рабочего"
          FROM maintenance_staff ms
          JOIN teams t ON ms.team_id = t.team_id
          JOIN maintenance_staff bf ON t.foreman_id = bf.staff_id
          JOIN workshop_managers wm ON wm.workshop_id = (
              SELECT w.workshop_id 
              FROM workshops w
              WHERE w.workshop_id = wm.workshop_id
          )
          JOIN workshops ws ON wm.workshop_id = ws.workshop_id
          ORDER BY ws.workshop_name, t.team_name, bf.full_name, ms.full_name;
          
     RETURN p_curs_transport_info;
    END get_staff_hierarchy; 
    
   FUNCTION get_garage_info(p_vehicle_type VARCHAR2) RETURN SYS_REFCURSOR
     --   8) Получите сведения о наличии гаражного хозяйства в целом и по каж-дой категории транспорта. 

   IS
      p_curs_transport_info  SYS_REFCURSOR;
   BEGIN        
     OPEN p_curs_transport_info FOR 
          SELECT 
              workshop_id AS "ID объекта",
              workshop_name AS "Наименование объекта",
              workshop_type AS "Тип объекта",
              address AS "Адрес",
              vehicle_type  AS "Ремонтирует"
          FROm workshops 
          WHERE vehicle_type LIKE NVL('%' || p_vehicle_type || '%' ,vehicle_type);
          
     RETURN p_curs_transport_info;
     
   END get_garage_info;   
   
   FUNCTION get_cargo_trips(p_vehicle_id NUMBER, 
                  p_date_from DATE, 
                  p_date_to DATE) 
                  RETURN SYS_REFCURSOR   
  -- 9) Получите сведения о грузоперевозках, выполненных указанной автомашиной за обозначенный период.                 
  IS
      p_curs_transport_info  SYS_REFCURSOR;
     
  BEGIN 
    OPEN p_curs_transport_info FOR
       SELECT 
            fe_id AS "ID перевозки",
            vehicle_id AS "ID транспорта",
            date_of_transportation AS "Дата перевозки"                  
       FROM freight_transportation
       WHERE vehicle_id = NVL(p_vehicle_id,vehicle_id) AND
             date_of_transportation BETWEEN NVL(p_date_from, date_of_transportation) AND
             NVL(p_date_to, date_of_transportation);
             
     RETURN p_curs_transport_info;           
  END get_cargo_trips; 
  
  FUNCTION get_used_parts(p_vehicle_type VARCHAR2,
                          p_brand VARCHAR2, 
                          p_vehicle_id NUMBER, 
                          p_date_from DATE,
                          p_part_name VARCHAR2,
                          p_date_to DATE)
                          RETURN SYS_REFCURSOR
   -- 10) Получите данные о числе использованных для ремонта указанных узлов и агрегатов для транспорта определенной категории, отдельной марки автотранспор-та или конкретной автомашины за указанный период.                        
   IS 
       p_curs_transport_info  SYS_REFCURSOR;

   BEGIN 
     
                    
    OPEN p_curs_transport_info FOR
      SELECT 
           par.part_name AS "Узел / Агрегат",
           COUNT(rpr.part_id) AS "Количество использований"
      FROM parts par
      JOIN (SELECT repair_id, part_id
           FROM repair_part_replacements
           ) rpr
      ON  par.part_id = rpr.part_id
      JOIN ( SELECT repair_id
             FROm repairs re
             WHERE repair_date BETWEEN NVL(p_date_from, repair_date) AND
                     NVL(p_date_to, repair_date) AND
                     EXISTS (SELECT 1
                             FROM vehicles ve
                             WHERE re.vehicle_id = ve.vehicle_id AND 
                                   ve.vehicle_type = NVl(p_vehicle_type, ve.vehicle_type) AND 
                                   ve.brand = NVl(p_brand, ve.brand) AND 
                                   ve.vehicle_id = NVl(p_vehicle_id, ve.vehicle_id)
                             )
      ) fr
      ON fr.repair_id = rpr.repair_id
      WHERE part_name = NVl(p_part_name, part_name)
      GROUP BY part_name
      ORDER BY COUNT(par.part_id ) DESC;
      
     
     RETURn p_curs_transport_info;
      
   END get_used_parts; 
                           
   FUNCTION get_vehicle_purchase_and_decommission(p_date_from  DATE,
                                                 p_date_to DATE)
                                                 RETURN SYS_REFCURSOR
   -- 11) Получите сведения о купленной и списанной технике за указанный пери-од.                                               
   IS
       p_curs_transport_info  SYS_REFCURSOR;
   BEGIN 
     
      OPEN p_curs_transport_info FOR
      SELECT 
            vehicle_id AS "ID транспорта",
            DECODE(decommission_date, NULL, 'КУПЛЕНА', 'СПИСАНА') AS "Статус",
            vehicle_type AS "Тип транспорта",
            brand AS "Марка",
            manufacture_year AS "Год выпуска",
            commission_date AS "Дата ввода в эксплуатацию",
            decommission_date AS "Дата списания"
      FROm vehicles 
      WHERE (commission_date BETWEEN NVL(p_date_from, commission_date) AND
            NVL(p_date_to, commission_date)) OR
            (decommission_date BETWEEN NVL(p_date_from, decommission_date) AND
            NVL(p_date_to, decommission_date));
            
      RETURn p_curs_transport_info;
      
   END get_vehicle_purchase_and_decommission;   
   
   FUNCTION get_team_members(p_name VARCHAR2) RETURN SYS_REFCURSOR
     --12) Получите состав подчиненных указанного бригадира, мастера. 

   IS
       p_curs_transport_info  SYS_REFCURSOR; 
       f_staff_id             maintenance_staff.staff_id%TYPE;   
       f_team_id_id           teams.team_id%TYPE;    
   BEGIn 
     SELECT staff_id
     INTO f_staff_id
     FROM maintenance_staff
     WHERE UPPER(full_name) = UPPER(p_name);
     
     SELECT team_id
     INTO f_team_id_id
     FROm teams;
   
     OPEN p_curs_transport_info FOR
        SELECT 
             full_name AS "ФИО сотрудника",
             position AS "Должность"                  
        FROM maintenance_staff 
        WHERE team_id = f_team_id_id AND
              UPPER(full_name) != UPPER(p_name);
        
    RETURN p_curs_transport_info ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
          RETURN NULL;
          
   END get_team_members;     
    
   FUNCTION get_staff_work_info(p_staff_id NUMBER, 
                               p_date_from DATE, 
                               p_date_to DATE)
                               RETURN SYS_REFCURSOR
   -- 13) Получите данные о работах, выполненных указанным специалистом (свар-щиком, слесарем и т.д.) за обозначенный период в целом и по конкретной автома-шине.                             
   IS
      p_curs_transport_info  SYS_REFCURSOR;  
      f_team_id            maintenance_staff.team_id%TYPE;  
   BEGIN 
     
      SELECT team_id
      INTO f_team_id
      FROM maintenance_staff 
      WHERE staff_id  = p_staff_id;
      
      OPEN p_curs_transport_info FOR
        SELECT 
           team_id AS "ID бригады",
            repair_date AS "Дата ремонта",
            work_volume AS "Объём работ",
            repair_cost AS "Стоимость ремонта",
            replaced_parts_count AS "Количество заменённых узлов"
        FROm repairs 
        WHERE team_id = f_team_id AND
              repair_date BETWEEN NVL(p_date_from, repair_date) AND
            NVL(p_date_to, repair_date);
        
   END get_staff_work_info;  
   
   
     FUNCTION get_table(table_name VARCHAR2)
                     RETURN SYS_REFCURSOR
     -- Получения всей таблицы динамически
     IS
         p_curs_transport_info  SYS_REFCURSOR;  
         v_sql                  VARCHAR2(1000);
     BEGIN 
       
       v_sql := 'SELECT *
                 FROM ' || table_name ; 
                 
       OPEN p_curs_transport_info FOR v_sql;
       
       RETURN p_curs_transport_info;        
     END get_table;  
                                                                      
END pkg_transport_info;
 
