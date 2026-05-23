const jwt = require("jsonwebtoken");
const { readStore, sanitizeUser } = require("../utils/store");

const secret = process.env.JWT_SECRET || "tibebarchive-local-secret";

function authenticate(req, res, next) {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ")
    ? authHeader.slice(7)
    : null;

  if (!token) {
    return res.status(401).json({ message: "Authentication required." });
  }

  try {
    const payload = jwt.verify(token, secret);
    const store = readStore();
    const user = store.users.find((entry) => entry.id === payload.userId);

    if (!user) {
      return res.status(401).json({ message: "User no longer exists." });
    }

    req.user = sanitizeUser(user);
    next();
  } catch (_error) {
    return res.status(401).json({ message: "Invalid or expired token." });
  }
}

module.exports = {
  authenticate,
  secret,
};
