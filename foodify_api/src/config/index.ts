// import dotenv from "dotenv";
// dotenv.config();

// export const JWT_SECRET = process.env.JWT_SECRET || "foodify_secret_key";
// export const MONGODB_URI = process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/foodify";
// export const PORT = process.env.PORT || 5050;

import dotenv from "dotenv";
dotenv.config();

export const JWT_SECRET = process.env.JWT_SECRET || "foodify_secret_key";

export const MONGODB_URI =
    process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/foodify";

export const PORT = Number(process.env.PORT) || 5050;
