import axios from "axios";

export default axios.create({
    baseURL: "http://localhost:8245/api-maowit00/item-management",
  headers: {
    "Content-type": "application/json"
  }
});
