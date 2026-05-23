const express = require("express");

const { authenticate } = require("../middleware/auth");
const { canMutateOwnedRecord, requireEditor } = require("../middleware/roleCheck");
const { generateId, readStore, writeStore } = require("../utils/store");

const router = express.Router();

router.get("/", authenticate, (_req, res) => {
  const store = readStore();
  res.json(store.artisans);
});

router.post("/", authenticate, requireEditor, (req, res) => {
  const { name, specialty, region, experienceYears, bio } = req.body || {};

  if (!name || !specialty || !region) {
    return res.status(400).json({ message: "Name, specialty, and region are required." });
  }

  const store = readStore();
  const artisan = {
    id: generateId("a"),
    name: name.trim(),
    specialty: specialty.trim(),
    region: region.trim(),
    experienceYears: Number(experienceYears || 0),
    bio: (bio || "").trim(),
    ownerId: req.user.id,
  };

  store.artisans.push(artisan);
  writeStore(store);

  return res.status(201).json(artisan);
});

router.put("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const index = store.artisans.findIndex((entry) => entry.id === req.params.id);

  if (index < 0) {
    return res.status(404).json({ message: "Artisan record not found." });
  }

  const current = store.artisans[index];
  if (!canMutateOwnedRecord(req.user, current)) {
    return res.status(403).json({ message: "You can only update your own artisan records." });
  }

  const updated = {
    ...current,
    ...req.body,
    id: current.id,
    ownerId: current.ownerId,
  };

  store.artisans[index] = updated;
  writeStore(store);

  return res.json(updated);
});

router.delete("/:id", authenticate, requireEditor, (req, res) => {
  const store = readStore();
  const artisan = store.artisans.find((entry) => entry.id === req.params.id);

  if (!artisan) {
    return res.status(404).json({ message: "Artisan record not found." });
  }

  if (!canMutateOwnedRecord(req.user, artisan)) {
    return res.status(403).json({ message: "You can only delete your own artisan records." });
  }

  store.artisans = store.artisans.filter((entry) => entry.id !== req.params.id);
  writeStore(store);

  return res.status(204).send();
});

module.exports = router;
