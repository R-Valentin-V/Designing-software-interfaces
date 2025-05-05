import React from "react";

export default function Modal({ title, content, onClose }) {
  const isArrayOfObjects =
    Array.isArray(content) && content.length > 0 && typeof content[0] === "object";

  const headers = isArrayOfObjects ? Object.keys(content[0]) : [];

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl p-8 max-w-[90%] w-full max-h-[80vh] overflow-auto relative space-y-6">
        <div className="flex items-center justify-between">
            <h2 className="text-2xl font-bold">{title}</h2>
            <button
                onClick={onClose}
                className="text-gray-500 hover:text-gray-700 text-3xl -translate-y-4" 
            >
                ✕
            </button>
        </div>

        {isArrayOfObjects ? (
          <div className="space-y-4">
            <div
              className="grid min-w-max bg-gray-50 border rounded"
              style={{
                gridTemplateColumns: `repeat(${headers.length}, minmax(120px, 1fr))`,
              }}
            >
              {headers.map((header) => (
                <div
                  key={header}
                  className="p-3 font-semibold text-gray-700 border-b bg-gray-100"
                >
                  {header}
                </div>
              ))}

              {content.map((row, rowIndex) =>
                headers.map((header, colIndex) => (
                  <div
                    key={rowIndex + "-" + colIndex}
                    className={`p-3 border-b text-gray-700 ${
                      rowIndex % 2 === 0 ? "bg-white" : "bg-gray-50"
                    } text-left`}
                  >
                    {typeof row[header] === "string" &&
                    row[header].includes(", 12:00:00 AM")
                      ? row[header].replace(", 12:00:00 AM", "").trim()
                      : row[header] ?? "-"}
                  </div>
                ))
              )}
            </div>
          </div>
        ) : (
          <pre className="bg-gray-100 p-4 rounded text-sm overflow-x-auto">
            {JSON.stringify(content, null, 2)}
          </pre>
        )}
      </div>
    </div>
  );
}
