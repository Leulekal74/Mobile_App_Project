const express = require("express");

const { authenticate } = require("../middleware/auth");
const { canMutateOwnedRecord, requireEditor } = require("../middleware/roleCheck");
const { generateId, readStore, writeStore } = require("../utils/store");

const router = express.Router();

router.get("/", authenticate, (req, res) => {
  const store = readStore();
  res.json(store.patterns);
});

router.post("/", authenticate, requireEditor, (req, res) => {
  const { name, region, technique, description, threadCount } = req.body || {};

  if (!name || !region || !technique) {
    return res.status(400).json({ message: "Name, region, and technique are required." });
  }

  const store = readStore();
  const pattern = {
    id: generateId("p"),
    name: name.trim(),
    region: region.trim(),
    technique: technique.trim(),
    description: (description || "").trim(),
    threadCount: (threadCount || "").trim(),
    ownerId: req.user.id,
  };

  store.patterns.push(pattern);
  writeStore(store);

  return res.status(201).json(pattern);
});

router.put("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const index = store.patterns.findIndex((entry) => entry.id === req.params.id);

  if (index < 0) {
    return res.status(404).json({ message: "Pattern not found." });
  }

  const current = store.patterns[index];
  if (!canMutateOwnedRecord(req.user, current)) {
    return res.status(403).json({ message: "You can only update your own pattern records." });
  }

  const updated = {
    ...current,
    ...req.body,
    id: current.id,
    ownerId: current.ownerId,
  };

  store.patterns[index] = updated;
  writeStore(store);

  return res.json(updated);
});

router.delete("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const pattern = store.patterns.find((entry) => entry.id === req.params.id);

  if (!pattern) {
    return res.status(404).json({ message: "Pattern not found." });
  }

  if (!canMutateOwnedRecord(req.user, pattern)) {
    return res.status(403).json({ message: "You can only delete your own pattern records." });
  }

  store.patterns = store.patterns.filter((entry) => entry.id !== req.params.id);
  writeStore(store);

  return res.status(204).send();
});

module.exports = router;
