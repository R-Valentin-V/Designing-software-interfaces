package com.example;

import static spark.Spark.*;

import java.sql.*;
import java.util.*;
import java.sql.Date;

import com.google.gson.Gson;

public class TransportServer {

    private static final String DB_URL = "jdbc:oracle:thin:@//localhost:1521/freepdb1";

    private static final String DB_USER = "Не скажу";
    private static final String DB_PASSWORD = "Не помню";

    private static Gson gson = new Gson();

    public static void main(String[] args) {

        port(8080);


  
        get("/vehicles", (req, res) -> gson.toJson(callFunctionNoParams("PKG_TRANSPORT_INFO.vehicle")));
        get("/driver-vehicle-distribution", (req, res) -> gson.toJson(callFunctionNoParams("PKG_TRANSPORT_INFO.GET_DRIVER_VEHICLE_DISTRIBUTION")));
        get("/vehicle-route-distribution", (req, res) -> gson.toJson(callFunctionNoParams("PKG_TRANSPORT_INFO.get_vehicle_route_distribution")));
        get("/staff-hierarchy", (req, res) -> gson.toJson(callFunctionNoParams("PKG_TRANSPORT_INFO.get_staff_hierarchy")));

     
        get("/drivers/:vehicleId", (req, res) -> gson.toJson(callFunctionWithNumber("PKG_TRANSPORT_INFO.get_driver_list", Integer.parseInt(req.params(":vehicleId")))));

        get("/garage-info/:vehicleType", (req, res) -> gson.toJson(callFunctionWithString("PKG_TRANSPORT_INFO.get_garage_info", req.params(":vehicleType"))));

        get("/team-members/:name", (req, res) -> gson.toJson(callFunctionWithString("PKG_TRANSPORT_INFO.get_team_members", req.params(":name"))));

        get("/table/:tableName", (req, res) -> gson.toJson(callFunctionWithString("PKG_TRANSPORT_INFO.get_table", req.params(":tableName"))));

     
        get("/vehicle-mileage", (req, res) -> {
            String vehicleType = req.queryParams("vehicleType");
            int vehicleId = Integer.parseInt(req.queryParams("vehicleId"));
            return gson.toJson(callFunctionWithStringAndNumber("PKG_TRANSPORT_INFO.get_vehicle_mileage", vehicleType, vehicleId));
        });


        get("/vehicle-purchase", (req, res) -> {
            String fromStr = req.queryParams("from");
            String toStr = req.queryParams("to");
        
            Date from = null;
            Date to = null;
        
            if (fromStr != null) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null) {
                to = Date.valueOf(toStr);
            }
            return gson.toJson(callFunctionWithTwoDates("PKG_TRANSPORT_INFO.get_vehicle_purchase_and_decommission", from, to));
        });


        get("/cargo-trips", (req, res) -> {
            int vehicleId = Integer.parseInt(req.queryParams("vehicleId"));
            String fromStr = req.queryParams("from");
            String toStr = req.queryParams("to");
        
            Date from = null;
            Date to = null;
        
            if (fromStr != null) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null) {
                to = Date.valueOf(toStr);
            }
            return gson.toJson(callFunctionWithNumberAndTwoDates("PKG_TRANSPORT_INFO.get_cargo_trips", vehicleId, from, to));
        });


        get("/repair-info", (req, res) -> {
            String vehicleType = req.queryParams("vehicleType");
            String brand = req.queryParams("brand");
            int vehicleId = Integer.parseInt(req.queryParams("vehicleId"));
            String fromStr = req.queryParams("from");
            String toStr = req.queryParams("to");
        
            Date from = null;
            Date to = null;
        
            if (fromStr != null) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null) {
                to = Date.valueOf(toStr);
            }
            return gson.toJson(callFunctionWithStringStringNumberTwoDates("PKG_TRANSPORT_INFO.get_repair_info", vehicleType, brand, vehicleId, from, to));
        });

 
        get("/used-parts", (req, res) -> {
            String vehicleType = req.queryParams("vehicleType");
            String brand = req.queryParams("brand");
            int vehicleId = Integer.parseInt(req.queryParams("vehicleId"));
            String partName = req.queryParams("partName");
            String fromStr = req.queryParams("from");
            String toStr = req.queryParams("to");
        
            Date from = null;
            Date to = null;
        
            if (fromStr != null) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null) {
                to = Date.valueOf(toStr);
            }
            
            return gson.toJson(callFunctionWithManyParams("PKG_TRANSPORT_INFO.get_used_parts", vehicleType, brand, vehicleId, from, partName, to));
        });

   
        get("/staff-work-info", (req, res) -> {
            int staffId = Integer.parseInt(req.queryParams("staffId"));
            String fromStr = req.queryParams("from");
            String toStr = req.queryParams("to");
            
            Date from = null;
            Date to = null;
        
            if (fromStr != null) {
                from = Date.valueOf(fromStr);
            }
            if (toStr != null) {
                to = Date.valueOf(toStr);
            }
      
            
            return gson.toJson(callFunctionWithNumberAndTwoDates("PKG_TRANSPORT_INFO.get_staff_work_info", staffId, from, to));
        });

        System.out.println("Server started on http://localhost:8080");
    }

    // -------------------- ФУНКЦИИ ----------------------

    private static List<Map<String, Object>> callFunctionNoParams(String functionName) {
        List<Map<String, Object>> result = new ArrayList<>();
    
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + " }")) {
    
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.execute();
    
            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
    
        } catch (SQLException e) {
            System.err.println(" Ошибка SQL при вызове " + functionName + ": " + e.getMessage());
        } catch (Exception e) {
            System.err.println(" Общая ошибка при вызове " + functionName + ": " + e.getMessage());
        }
    
        return result;
    }
    
    
    
    

    private static List<Map<String, Object>> callFunctionWithNumber(String functionName, int param) {
        List<Map<String, Object>> result = new ArrayList<>();
    
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?) }")) {
    
            System.out.println(" Вызов функции: " + functionName + " с параметром: " + param);
    
            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setInt(2, param);
            stmt.execute();
    
            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
    
        } catch (SQLException e) {
            System.err.println(" SQL Ошибка при вызове " + functionName + ": " + e.getMessage());
            e.printStackTrace(); // Вывод полной трассировки стека (очень полезно для поиска ошибки)
        } catch (Exception e) {
            System.err.println(" Общая ошибка при вызове " + functionName + ": " + e.getMessage());
            e.printStackTrace();
        }
    
        return result;
    }
    

    private static List<Map<String, Object>> callFunctionWithString(String functionName, String param) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setString(2, param);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> callFunctionWithStringAndNumber(String functionName, String strParam, int numParam) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?, ?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setString(2, strParam);
            stmt.setInt(3, numParam);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> callFunctionWithTwoDates(String functionName, Date from, Date to) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?, ?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setDate(2, from);
            stmt.setDate(3, to);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> callFunctionWithNumberAndTwoDates(String functionName, int num, Date from, Date to) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?, ?, ?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setInt(2, num);
            stmt.setDate(3, from);
            stmt.setDate(4, to);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> callFunctionWithStringStringNumberTwoDates(String functionName, String p1, String p2, int p3, Date p4, Date p5) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?, ?, ?, ?, ?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setString(2, p1);
            stmt.setString(3, p2);
            stmt.setInt(4, p3);
            stmt.setDate(5, p4);
            stmt.setDate(6, p5);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> callFunctionWithManyParams(String functionName, String p1, String p2, int p3, Date p4, String p5, Date p6) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement stmt = conn.prepareCall("{ ? = call " + functionName + "(?, ?, ?, ?, ?, ?) }")) {

            stmt.registerOutParameter(1, Types.REF_CURSOR);
            stmt.setString(2, p1);
            stmt.setString(3, p2);
            stmt.setInt(4, p3);
            stmt.setDate(5, p4);
            stmt.setString(6, p5);
            stmt.setDate(7, p6);
            stmt.execute();

            ResultSet rs = (ResultSet) stmt.getObject(1);
            return resultSetToList(rs);
        }
    }

    private static List<Map<String, Object>> resultSetToList(ResultSet rs) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        if (rs == null) {
            System.out.println(" ResultSet is NULL");
            return result;
        }
    
        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();
        
        boolean hasRows = false;
    
        while (rs.next()) {
            hasRows = true;
            Map<String, Object> row = new LinkedHashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                try {
                    Object val = rs.getObject(i);
                    row.put(meta.getColumnName(i), val);
                } catch (Exception ex) {
                    System.err.println("Ошибка при чтении поля [" + meta.getColumnName(i) + "]: " + ex.getMessage());
                    row.put(meta.getColumnName(i), "ERROR: " + ex.getMessage());
                }
            }
            result.add(row);
        }
    
        if (!hasRows) {
            System.out.println(" Пусто. Куда подевалось? ");
        } else {
            System.out.println(" Нашёль " + result.size() + " строк.");
        }
    
        rs.close();
        return result;
    }
    
    
}
