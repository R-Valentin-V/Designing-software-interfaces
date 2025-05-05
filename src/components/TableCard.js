import React, { useState } from "react";

export default function TableCard({ data }) {
  const [open, setOpen] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div
      className="relative p-4 border rounded-lg shadow hover:shadow-lg bg-white cursor-pointer transition"
      onClick={() => setOpen(!open)}
    >
      <div className="flex justify-between items-start">
        <div>
          {Object.entries(data).map(([key, value], index) => (
            <div key={index} className="mb-1">
              <span className="font-semibold">{key}: </span>
              <span className={key.includes("CATEGORY") ? "inline-block px-2 py-1 bg-blue-100 text-blue-700 rounded text-sm" : ""}>
                {value}
              </span>
            </div>
          ))}
        </div>

        <div className="relative">
          <button
            onClick={(e) => {
              e.stopPropagation();
              setMenuOpen(!menuOpen);
            }}
            className="text-gray-400 hover:text-gray-600"
          >
            ⋮
          </button>

          {menuOpen && (
            <div className="absolute right-0 mt-2 w-40 bg-white border rounded shadow-lg z-10">
              <button className="block px-4 py-2 hover:bg-gray-100 w-full text-left">Mark as Done</button>
              <button className="block px-4 py-2 hover:bg-gray-100 w-full text-left">Remove</button>
            </div>
          )}
        </div>
      </div>

      {open && (
        <div className="mt-4 flex space-x-2">
          <button className="px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600">Call</button>
          <button className="px-3 py-1 bg-yellow-500 text-white rounded hover:bg-yellow-600">Email</button>
          <button className="px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">Edit</button>
        </div>
      )}
    </div>
  );
}
