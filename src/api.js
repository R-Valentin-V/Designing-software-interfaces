export async function fetchTable(tableName) {
    const response = await fetch(`/table/${tableName}`);
    const data = await response.json();
    return data;
  }
  