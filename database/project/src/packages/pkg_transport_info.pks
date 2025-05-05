CREATE OR REPLACE PACKAGE pkg_transport_info 
IS

   FUNCTION vehicle RETURN SYS_REFCURSOR;
   FUNCTION get_driver_list(p_vehicle_id NUMBER) RETURN SYS_REFCURSOR;
   FUNCTION get_driver_vehicle_distribution RETURN SYS_REFCURSOR;
   FUNCTION get_vehicle_route_distribution RETURN SYS_REFCURSOR;
   FUNCTION get_vehicle_mileage(p_vehicle_type VARCHAR2, 
                                p_vehicle_id NUMBER 
                                ) RETURN SYS_REFCURSOR;

   FUNCTION get_repair_info(p_vehicle_type VARCHAR2,
                            p_brand VARCHAR2,
                            p_vehicle_id NUMBER, 
                            p_date_from DATE,
                            p_date_to DATE)
                            RETURN SYS_REFCURSOR;                         
  FUNCTION get_staff_hierarchy RETURN SYS_REFCURSOR;
  FUNCTION get_garage_info(p_vehicle_type VARCHAR2) RETURN SYS_REFCURSOR;
  FUNCTION get_cargo_trips(p_vehicle_id NUMBER, 
                  p_date_from DATE, 
                  p_date_to DATE) 
                  RETURN SYS_REFCURSOR;
  
  FUNCTION get_used_parts(p_vehicle_type VARCHAR2,
                          p_brand VARCHAR2, 
                          p_vehicle_id NUMBER, 
                          p_date_from DATE,
                          p_part_name VARCHAR2,
                          p_date_to DATE)
                          RETURN SYS_REFCURSOR;
  FUNCTION get_vehicle_purchase_and_decommission(p_date_from  DATE,
                                                 p_date_to DATE)
                                                 RETURN SYS_REFCURSOR;
  FUNCTION get_team_members(p_name VARCHAR2) RETURN SYS_REFCURSOR;  
  
  FUNCTION get_staff_work_info(p_staff_id NUMBER, 
                               p_date_from DATE, 
                               p_date_to DATE)
                               RETURN SYS_REFCURSOR; 
  FUNCTION get_table(table_name VARCHAR2)
                     RETURN SYS_REFCURSOR;                                        
END pkg_transport_info;
