const express = require("express");
const jwt = require("jsonwebtoken");

const { authenticate, secret } = require("../middleware/auth");
const { generateId, readStore, sanitizeUser, writeStore } = require("../utils/store");

const router = express.Router();

router.post("/signup", (req, res) => {
  const { name, email, password, role } = req.body || {};
  const normalizedEmail = (email || "").trim().toLowerCase();
  const normalizedRole = (role || "").trim().toLowerCase();

  if (!name || !normalizedEmail || !password || !normalizedRole) {
    return res.status(400).json({ message: "All signup fields are required." });
  }

  if (!["admin", "buyer", "seller"].includes(normalizedRole)) {
    return res.status(400).json({ message: "Invalid role selected." });
  }

  const store = readStore();
  const existingUser = store.users.find((user) => user.email === normalizedEmail);

  if (existingUser) {
    return res.status(409).json({ message: "An account already exists for this email." });
  }

  const user = {
    id: generateId("u"),
    name: name.trim(),
    email: normalizedEmail,
    password: String(password),
    role: normalizedRole,
  };

  store.users.push(user);
  writeStore(store);

  const safeUser = sanitizeUser(user);
  const token = jwt.sign({ userId: user.id, role: user.role }, secret, { expiresIn: "7d" });

  return res.status(201).json({ token, user: safeUser });
});

router.post("/login", (req, res) => {
  const email = (req.body?.email || "").trim().toLowerCase();
  const password = String(req.body?.password || "");

  const store = readStore();
  const user = store.users.find(
    (entry) => entry.email === email && entry.password === password,
  );

  if (!user) {
    return res.status(401).json({ message: "Invalid credentials." });
  }

  const safeUser = sanitizeUser(user);
  const token = jwt.sign({ userId: user.id, role: user.role }, secret, { expiresIn: "7d" });

  return res.json({ token, user: safeUser });
});

router.get("/me", authenticate, (req, res) => {
  res.json({ user: req.user });
});

module.exports = router;
