const express = require("express");

const { authenticate } = require("../middleware/auth");
const { canMutateOwnedRecord, requireEditor } = require("../middleware/roleCheck");
const { generateId, readStore, writeStore } = require("../utils/store");

const router = express.Router();

router.get("/", authenticate, (_req, res) => {
  const store = readStore();
  res.json(store.dyes);
});

router.post("/", authenticate, requireEditor, (req, res) => {
  const { name, sourceMaterial, region, formula, notes } = req.body || {};

  if (!name || !sourceMaterial || !formula) {
    return res.status(400).json({ message: "Name, source material, and formula are required." });
  }

  const store = readStore();
  const dye = {
    id: generateId("d"),
    name: name.trim(),
    sourceMaterial: sourceMaterial.trim(),
    region: (region || "").trim(),
    formula: formula.trim(),
    notes: (notes || "").trim(),
    ownerId: req.user.id,
  };

  store.dyes.push(dye);
  writeStore(store);

  return res.status(201).json(dye);
});

router.put("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const index = store.dyes.findIndex((entry) => entry.id === req.params.id);

  if (index < 0) {
    return res.status(404).json({ message: "Dye record not found." });
  }

  const current = store.dyes[index];
  if (!canMutateOwnedRecord(req.user, current)) {
    return res.status(403).json({ message: "You can only update your own dye records." });
  }

  const updated = {
    ...current,
    ...req.body,
    id: current.id,
    ownerId: current.ownerId,
  };

  store.dyes[index] = updated;
  writeStore(store);

  return res.json(updated);
});

router.delete("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const dye = store.dyes.find((entry) => entry.id === req.params.id);

  if (!dye) {
    return res.status(404).json({ message: "Dye record not found." });
  }

  if (!canMutateOwnedRecord(req.user, dye)) {
    return res.status(403).json({ message: "You can only delete your own dye records." });
  }

  store.dyes = store.dyes.filter((entry) => entry.id !== req.params.id);
  writeStore(store);

  return res.status(204).send();
});

module.exports = router;
