import React from "react";
import { ReactComponent as VehiclesIcon } from "../icons/Vehicles.svg";
import { ReactComponent as DriversIcon } from "../icons/Drivers.svg";
import { ReactComponent as VehicleDriverAssignmentsIcon } from "../icons/Vehicle_Driver_Assignments.svg";
import { ReactComponent as VehicleRouteAssignmentsIcon } from "../icons/Vehicle_Route_Assignments.svg";
import { ReactComponent as MaintenanceStaffIcon } from "../icons/Maintenance_Staff.svg";
import { ReactComponent as WorkshopsIcon } from "../icons/Workshops.svg";
import { ReactComponent as RepairsIcon } from "../icons/Repairs.svg";
import { ReactComponent as FreightTransportationIcon } from "../icons/freight_transportation.svg";

const iconMap = {
  Vehicles: VehiclesIcon,
  Drivers: DriversIcon,
  Vehicle_Driver_Assignments: VehicleDriverAssignmentsIcon,
  routes: VehicleRouteAssignmentsIcon,
  Maintenance_Staff: MaintenanceStaffIcon,
  Workshops: WorkshopsIcon,
  Repairs: RepairsIcon,
  freight_transportation: FreightTransportationIcon,
};

const tableNames = {
  Vehicles: "Транспорт",
  Drivers: "Водители",
  Vehicle_Driver_Assignments: "Водитель - Транспорт",
  routes : "Маршруты",
  Maintenance_Staff: "Персонал обслуживания",
  Workshops: "Мастерские",
  Repairs: "Ремонт",
  freight_transportation: "Грузоперевозки",
};

const tables = Object.keys(iconMap);

export default function Sidebar({ selectedTable, onSelectTable }) {
  return (
<div className="w-2/13 h-screen bg-[#f7f8fa] shadow-lg p-4 flex flex-col justify-between">


      <div>
      <h2 className=" text-2x2 font-bold text-gray-600">Предприятие  </h2>
      <h2 className=" text-2xl font-bold text-gray-600">АвтоПоток</h2>
        <ul className="space-y-3 mt-4">
          {tables.map((table) => {
            const Icon = iconMap[table];
            const isSelected = selectedTable === table;

            return (
              <li
                key={table}
                className={`cursor-pointer rounded flex items-center ${
                  isSelected
                    ? "bg-blue-100 text-blue-700 font-semibold"
                    : "text-gray-700 hover:bg-gray-100"
                }`}
                onClick={() => onSelectTable(table)}
              >
                <div className="p-3 flex items-center space-x-2 w-full min-h-[48px]">
                  <Icon
                    className={`w-5 h-5 ${
                      isSelected ? "text-blue-700" : "text-gray-600 group-hover:text-blue-500"
                    }`}
                  />
                  <span>{tableNames[table]}</span>
                </div>
              </li>
            );
          })}
        </ul>
      </div>

      <div className="font-semibold text-gray-500">
        <div >РИС 21-1бз</div>
        <div>Ремянников В.В.</div>
    </div>

    </div>
  );
}
