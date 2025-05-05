import React, { useState } from "react";
import actionsMap from "../actionsMap";

export default function TableRow({ data, headers, tableName, onAction }) {
  const [menuOpen, setMenuOpen] = useState(false);
  const actions = actionsMap[tableName] || [];

  const formatValue = (value) => {
    if (typeof value === "string" && value.includes(", 12:00:00 AM")) {
      return value.replace(", 12:00:00 AM", "").trim();
    }
    return value;
  };

  return (
    <div
      className="grid items-center border-b hover:bg-gray-50 gap-x-2 min-w-max"
      style={{
        gridTemplateColumns: `40px repeat(${headers.length}, minmax(120px, 1fr))`,
      }}
    >
      <div className="p-2 relative">
        {actions.length > 0 && (
          <button
            className="text-gray-400 hover:text-gray-600"
            onClick={() => setMenuOpen(!menuOpen)}
          >
            ⋯
          </button>
        )}

        {menuOpen && (
          <div className="absolute left-6 top-0 bg-white border rounded shadow-md z-20 p-2 space-y-1">
            {actions.map((action, index) => {
              const endpoint = action.endpoint(data);
              if (!endpoint) return null;

              return (
                <button
                  key={index}
                  className="block text-sm hover:bg-gray-100 w-full text-left p-1"
                  onClick={() => {
                    onAction(action.label, endpoint);
                    setMenuOpen(false);
                  }}
                >
                  {action.label}
                </button>
              );
            })}
          </div>
        )}
      </div>

      {headers.map((header) => (
        <div key={header} className="p-3 text-left">
          {data[header] !== undefined && data[header] !== null
            ? formatValue(data[header])
            : "-"}
        </div>
      ))}
    </div>
  );
}
