import React, { useState } from "react";
import Sidebar from "./components/Sidebar";
import TableView from "./components/TableView";

function App() {
  const [selectedTable, setSelectedTable] = useState(null);

  return (
    <div className="flex h-screen bg-gray-100">
      <Sidebar selectedTable={selectedTable} onSelectTable={setSelectedTable} />
      <TableView tableName={selectedTable} />
    </div>
  );
}

export default App;
