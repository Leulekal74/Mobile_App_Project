const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

const authRoutes = require("./routes/auth");
const patternRoutes = require("./routes/patterns");
const dyeRoutes = require("./routes/dyes");
const artisanRoutes = require("./routes/artisans");

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(
  cors({
    origin: true,
    credentials: true,
  }),
);
app.use(express.json());

app.get("/", (_req, res) => {
  res.json({
    message: "TibebArchive API is running.",
  });
});

app.use("/auth", authRoutes);
app.use("/patterns", patternRoutes);
app.use("/dyes", dyeRoutes);
app.use("/artisans", artisanRoutes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
