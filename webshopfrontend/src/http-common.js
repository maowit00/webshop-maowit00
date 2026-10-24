import axios from "axios";

export default axios.create({
    baseURL: "http://localhost:8245/api-maowit00/item-management/v1",
  headers: {
    "Content-type": "application/json"
  }
});
