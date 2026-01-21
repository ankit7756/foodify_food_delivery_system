// import express from "express";
// import cors from "cors";
// import { connectDB } from "./database/mongodb";
// import authRoutes from "./routes/auth.route";
// import { PORT } from "./config";

// const app = express();

// app.use(cors({
//     origin: "http://localhost:3000", 
//     credentials: true
// }));

// app.use(express.json());

// app.get("/", (req, res) => {
//     res.json({ message: "Foodify Auth API is running!" });
// });

// app.use("/api/auth", authRoutes);

// const start = async () => {
//     await connectDB();
//     app.listen(PORT, () => {
//         console.log(`Server running on http://localhost:${PORT}`);
//     });
// };

// start();

import express from "express";
import cors from "cors";
import { connectDB } from "./database/mongodb";
import authRoutes from "./routes/auth.route";
import { PORT } from "./config";

const app = express();

// Update CORS to allow mobile app
app.use(cors({
    origin: "*",  // Allow all origins (for development)
    credentials: true
}));

app.use(express.json());

app.get("/", (req, res) => {
    res.json({ message: "Foodify Auth API is running!" });
});

app.use("/api/auth", authRoutes);

const start = async () => {
    await connectDB();
    app.listen(PORT, '0.0.0.0', () => {  // Listen on all interfaces
        console.log(`Server running on http://localhost:${PORT}`);
    });
};

start();