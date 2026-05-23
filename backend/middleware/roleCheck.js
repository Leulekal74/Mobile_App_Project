function requireEditor(req, res, next) {
  if (!req.user || (req.user.role !== "admin" && req.user.role !== "seller")) {
    return res.status(403).json({ message: "You do not have write access." });
  }

  next();
}

function requireAdmin(req, res, next) {
  if (!req.user || req.user.role !== "admin") {
    return res.status(403).json({ message: "Admin access required." });
  }

  next();
}

function canMutateOwnedRecord(user, record) {
  return user.role === "admin" || record.ownerId === user.id;
}

module.exports = {
  requireAdmin,
  requireEditor,
  canMutateOwnedRecord,
};
