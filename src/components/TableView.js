import React, { useState, useEffect } from "react";
import Modal from "./Modal";
import { fetchTable } from "../api";
import actionsMap from "../actionsMap";

export default function TableView({ tableName }) {
  const [data, setData] = useState([]);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(15);
  const [modalContent, setModalContent] = useState(null);
  const [modalTitle, setModalTitle] = useState("");
  const [openMenuIndex, setOpenMenuIndex] = useState(null);
  const [openMenuData, setOpenMenuData] = useState(null);

  const tableNames = {
    Vehicles: "Транспорт",
    Drivers: "Водители",
    Vehicle_Driver_Assignments: "Закрепление водителей",
    routes : "Маршруты",
    Maintenance_Staff: "Персонал обслуживания",
    Workshops: "Мастерские",
    Repairs: "Ремонт",
    freight_transportation: "Грузоперевозки",
  };

  useEffect(() => {
    if (tableName) {
      fetchTable(tableName).then(setData);
      setCurrentPage(1);
      setOpenMenuData(null);
    }
  }, [tableName]);

  const filteredData = search.trim()
    ? data.filter((row) =>
        Object.values(row).some((val) =>
          (val ?? "").toString().toLowerCase().includes(search.toLowerCase())
        )
      )
    : data;

  const headers = filteredData.length > 0 ? Object.keys(filteredData[0]) : [];
  const gridTemplate = `40px repeat(${headers.length}, minmax(120px, 1fr))`;
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);
  const currentData = filteredData.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );
  const startItem = (currentPage - 1) * itemsPerPage + 1;
  const endItem = Math.min(currentPage * itemsPerPage, filteredData.length);

  const handleAction = async (actionLabel, endpoint) => {
    if (!endpoint) {
      alert("Not enough data to perform this action.");
      return;
    }

    try {
      const res = await fetch(endpoint);
      if (!res.ok) throw new Error("Failed to fetch action data");
      const result = await res.json();
      setModalContent(result);
      setModalTitle(actionLabel);
    } catch (err) {
      console.error(err);
      setModalContent({ error: err.message });
      setModalTitle("Error");
    }
  };
  return (
    <div className="w-11/12 p-4 h-screen overflow-auto relative bg-[#f7f8fa]">
      <div className="bg-white border rounded-lg shadow-lg p-6 space-y-4 h-[96.5vh] overflow-hidden flex flex-col">
  
      <div className="flex justify-between items-center space-x-4 -translate-y-1">
        <h2 className="text-2xl font-bold text-gray-800 transform -translate-y-1">
            {tableNames[tableName] || "Выберите таблицу"}
        </h2>



        <input
            type="text"
            placeholder="Поиск..."
            className="p-2 border rounded-lg shadow-sm focus:ring-2 focus:ring-blue-300 focus:outline-none w-64"
            value={search}
            onChange={(e) => {
            setSearch(e.target.value);
            setCurrentPage(1);
            }}
        />
      </div>
       
  

        {currentData.length > 0 && (
          <div className="flex-1 overflow-auto rounded-lg border">
            <div
              className="grid min-w-max"
              style={{ gridTemplateColumns: gridTemplate }}
            >
     
              <div />
              {headers.map((header) => (
                <div
                  key={header}
                  className="py-3 font-semibold text-gray-700 bg-white sticky top-0 z-10 relative before:content-[''] before:absolute before:left-[-40px] before:right-0 before:bottom-0 before:h-px before:bg-gray-300">
                  {header}
                </div>
              ))}
  
         
              {currentData.map((row, rowIndex) => {
                const actions = actionsMap[tableName] || [];
                const hasActions = actions.some((action) => action.endpoint(row));
  
                return (
                  <React.Fragment key={rowIndex}>
                
                    <div className="p-3 border-b relative">
                      {hasActions && (
                        <button
                          className="text-gray-800 hover:text-gray-900 text-2xl"
                          onClick={(e) => {
                            const rect = e.target.getBoundingClientRect();
                            setOpenMenuData({
                              x: rect.right + 5,
                              y: rect.top,
                              actions: actions
                                .map((action) => ({
                                  label: action.label,
                                  endpoint: action.endpoint(row),
                                }))
                                .filter((a) => a.endpoint),
                            });
                          }}
                        >
                          ⋮
                        </button>
                      )}
                    </div>
  
           
                    {headers.map((header, colIndex) => (
                    <div
                        key={rowIndex + "-" + colIndex}
                        className={`p-4 pl-[40px] -ml-[40px] border-b text-gray-700 text-left ${
                        rowIndex % 2 === 0 ? "bg-white" : "bg-gray-50"
                        } hover:bg-gray-100`}
                    >
                        {typeof row[header] === "string" &&
                        row[header].includes(", 12:00:00 AM")
                        ? row[header].replace(", 12:00:00 AM", "").trim()
                        : row[header] ?? "-"}
                    </div>
                    ))}

                  </React.Fragment>
                );
              })}
            </div>
          </div>
        )}
  
        {currentData.length === 0 && (
          <div className="flex-1 flex items-center justify-center text-gray-400 text-2xl">
           Пусто
          </div>
        )}
  

        <div className="pt-1">
          <div className="flex justify-between items-center text-sm text-gray-600">
            
 
            <div>
            Показано {filteredData.length === 0 ? 0 : startItem} - {endItem}  из  {filteredData.length} записей
            </div>
  
    
            <div className="flex items-center space-x-2">
              <span> На странице</span>
              <select
                value={itemsPerPage}
                onChange={(e) => {
                  setItemsPerPage(Number(e.target.value));
                  setCurrentPage(1);
                }}
                className="border rounded p-1"
              >
                {[15, 30, 50].map((count) => (
                  <option key={count} value={count}>
                    {count}
                  </option>
                ))}
              </select>
              <span>записей </span>
            </div>
  
         
            <div className="flex items-center space-x-2">
              <button
                className="px-3 py-1 border rounded disabled:opacity-50"
                onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
                disabled={currentPage === 1}
              >
                Назад
              </button>
  
              {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                <button
                  key={page}
                  className={`px-3 py-1 border rounded ${
                    currentPage === page
                      ? "bg-blue-500 text-white"
                      : "hover:bg-gray-100"
                  }`}
                  onClick={() => setCurrentPage(page)}
                >
                  {page}
                </button>
              ))}
  
              <button
                className="px-3 py-1 border rounded disabled:opacity-50"
                onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
                disabled={currentPage === totalPages}
              >
                Вперед
              </button>
            </div>
  
          </div>
        </div>
  
      </div>
  
 
      {openMenuData && (
        <div
          className="fixed z-50 bg-white border rounded shadow-lg p-2 space-y-1 min-w-[200px]"
          style={{ left: openMenuData.x, top: openMenuData.y }}
        >
          {openMenuData.actions.map((action, index) => (
            <button
              key={index}
              className="block text-sm hover:bg-gray-100 w-full text-left p-2"
              onClick={() => {
                handleAction(action.label, action.endpoint);
                setOpenMenuData(null);
              }}
            >
              {action.label}
            </button>
          ))}
        </div>
      )}
  
     
      {modalContent && (
        <Modal
          title={modalTitle}
          content={modalContent}
          onClose={() => setModalContent(null)}
        />
      )}
    </div>
  );
  

}
