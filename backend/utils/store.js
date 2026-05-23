const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const storePath = path.join(__dirname, "..", "data", "store.json");

function readStore() {
  if (!fs.existsSync(storePath)) {
    return {
      users: [],
      patterns: [],
      dyes: [],
      artisans: [],
    };
  }

  return JSON.parse(fs.readFileSync(storePath, "utf8"));
}

function writeStore(store) {
  fs.writeFileSync(storePath, JSON.stringify(store, null, 2));
}

function generateId(prefix) {
  return `${prefix}-${crypto.randomUUID().slice(0, 8)}`;
}

function sanitizeUser(user) {
  const { password, ...safeUser } = user;
  return safeUser;
}

module.exports = {
  readStore,
  writeStore,
  generateId,
  sanitizeUser,
};
