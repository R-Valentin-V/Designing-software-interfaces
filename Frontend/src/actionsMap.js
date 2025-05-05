const actionsMap = {
    Vehicles: [
      {
        label: "Информация о гараже",
        endpoint: (row) => row.VEHICLE_TYPE ? `/garage-info/${row.VEHICLE_TYPE}` : null,
      },
      {
        label: "Информация о ремонте",
        endpoint: (row) => row.VEHICLE_ID ? `/repair-info?vehicleId=${row.VEHICLE_ID}` : null,
      },
      {
        label: "Пробег",
        endpoint: (row) => row.VEHICLE_ID ? `/vehicle-mileage?vehicleId=${row.VEHICLE_ID}` : null,
      },
      {
        label: "Водители",
        endpoint: (row) => row.VEHICLE_ID ? `/drivers/${row.VEHICLE_ID}` : null,
      },
      {
        label: "Грузовые перевозки",
        endpoint: (row) => row.VEHICLE_ID ? `/cargo-trips?vehicleId=${row.VEHICLE_ID}&from=2000-01-01&to=2026-12-31` : null,
      },
      {
        label: "Использованные при ремонте детали",
        endpoint: (row) => row.VEHICLE_ID ? `/used-parts?vehicleId=${row.VEHICLE_ID}&from=2000-01-01&to=2026-12-31` : null,
      },
    ],
  
    Drivers: [
      {
        label: "Распределение водителей по автомобилям",
        endpoint: () => `/driver-vehicle-distribution`,
      },
    ],
  
    Vehicle_Driver_Assignments: [
      {
        label: "Распределение водителей по автомобилям",
        endpoint: () => `/driver-vehicle-distribution`,
      },
    ],
  
    routes: [
      {
        label: "Распределение транспортных средств по маршрутам",
        endpoint: () => `/vehicle-route-distribution`,
      },
    ],
  
    Maintenance_Staff: [
      {
        label: "Иерархия персонала",
        endpoint: () => `/staff-hierarchy`,
      },
      {
        label: "Информация о работе персонала",
        endpoint: (row) => row.STAFF_ID ? `/staff-work-info?staffId=${row.STAFF_ID}` : null,
      },
    ],

  

  
    Cargo_Trips: [
      {
        label: "Грузовые перевозки",
        endpoint: (row) => row.VEHICLE_ID ? `/cargo-trips?vehicleId=${row.VEHICLE_ID}&from=2000-01-01&to=2026-12-31` : null,
      },
    ],
  
    
  };
  
  export default actionsMap;
  