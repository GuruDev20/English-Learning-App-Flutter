const mongoose = require('mongoose');
const express = require("express");
const app = express();
const path = require("path");
const multer = require("multer");
const cors = require("cors");
const UserModel = require("./models/User");

mongoose.connect('mongodb://127.0.0.1:27017/English_Project_App');
app.use(express.static('public'));
app.use(express.json());
app.use(cors());
const PORT = process.env.PORT || 3000;
app.post("/createUser", async (req, res) => {
  try {
    const data = new UserModel(req.body);
    await data.save();
    res.status(200).send(data);
  } catch (error) {
    res.status(400).send(error);
  }
});

app.get("/getuser", async (req, res) => {
  try {
    const data = await UserModel.find({});
    res.status(200).send(data);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.post("/createContent", async (req, res) => {
  try {
    const title = req.body.title;
    const content = req.body.content;
    const contentSchema = new mongoose.Schema({
      content: String,
      timestamp: {
        type: Date,
        default: Date.now,
      },
    });
    const Content = mongoose.model(title, contentSchema);
    const newContent = new Content({ content });
    await newContent.save();
    res.status(200).send("Content created successfully.");
  } catch (error) {
    console.error(error);
    res.status(400).send("Internal Server Error");
  }
});

app.post("/addContent", async (req, res) => {
  try {
    const title = req.body.title;
    const lowercaseTitle = title.toLowerCase();
    let ContentModel;

    try {
      ContentModel = mongoose.model(lowercaseTitle);
    } catch (error) {
      ContentModel = mongoose.model(
        lowercaseTitle,
        new mongoose.Schema({
          content: String,
          timestamp: {
            type: Date,
            default: Date.now,
          },
        })
      );
    }

    if (!ContentModel) {
      return res
        .status(404)
        .send(`Collection with title ${lowercaseTitle} not found`);
    }

    const newContent = new ContentModel({
      content: req.body.content,
    });

    await newContent.save();

    res.status(201).send("Content added successfully.");
  } catch (error) {
    console.error("Error adding content:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/Images');
  },
  filename: (req, file, cb) => {
    cb(null, file.fieldname + '_' + Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });
app.post("/upload", upload.single("image"), async (req, res) => {
  try {
    const imagePath = req.file.filename;
    const originalTitle = req.body.title;
    const lowercaseTitle = originalTitle.toLowerCase();
    let ContentModel;
    try {
      ContentModel = mongoose.model(lowercaseTitle);
    } catch (error) {
      ContentModel = mongoose.model(
        lowercaseTitle,
        new mongoose.Schema({
          content: String,
        })
      );
    }

    const newContent = new ContentModel({
      content: imagePath,
    });

    await newContent.save();
    res
      .status(200)
      .json({ message: "Image uploaded successfully to existing collection" });
  } catch (error) {
    console.error("Error uploading image:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/newupload", upload.single("image"), async (req, res) => {
  try {
    const title = req.body.title;
    const imagePath = req.file.filename;

    const contentSchema = new mongoose.Schema({
      content: {
        type: String,
        required: true,
      },
    });

    const Content = mongoose.model(title, contentSchema);

    const newContent = new Content({ content: imagePath });
    await newContent.save();

    res.status(200).json({ message: "Image uploaded successfully" });
  } catch (error) {
    console.error("Error uploading image:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

const vstorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/Videos");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file.fieldname + "_" + Date.now() + path.extname(file.originalname)
    );
  },
});

const vupload = multer({ storage: vstorage });

app.post('/newVideo', vupload.single('video'), async (req, res) => { 
  try {
    const title = req.body.title;
    const videoPath = req.file.filename;

    const contentSchema = new mongoose.Schema({
      content: {
        type: String,
        required: true,
      },
    });

    const Content = mongoose.model(title, contentSchema);

    const newContent = new Content({ content: videoPath });
    await newContent.save();

    res.status(200).json({ message: "Video uploaded successfully" });
  } catch (error) {
    console.error("Error uploading Video:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});


app.post('/oldVideo', vupload.single('video'), async (req, res) => {
  try {
    const title = req.body.title;
    const videoPath = req.file.filename;
    const lowercaseTitle = title.toLowerCase();
    let ContentModel;

    try {
      ContentModel = mongoose.model(lowercaseTitle);
    } catch (error) {
      ContentModel = mongoose.model(
        lowercaseTitle,
        new mongoose.Schema({
          content: String,
        })
      );
    }

    const newContent = new ContentModel({ content: videoPath });
    await newContent.save();

    res.status(200).json({ message: "Video uploaded successfully" });
  } catch (error) {
    console.error("Error uploading Video:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

let collectionNames = [];

async function fetchCollectionNames() {
  try {
    const collections = await mongoose.connection.db.listCollections().toArray();
    collectionNames = collections
      .map((collection) => collection.name)
      .filter((name) => name !== 'users');
    console.log('Collection names fetched:', collectionNames);
  } catch (error) {
    console.error('Error fetching collection names:', error);
  }
}
app.get("/collectionNames", async (req, res) => {
  res.json(collectionNames);
});

app.put("/updateCollectionName", async (req, res) => {
  const { oldName, newName } = req.body;

  try {
    const collections = await mongoose.connection.db.listCollections().toArray();
    const collectionExists = collections.some(collection => collection.name === oldName);
    if (collectionExists) {
      await mongoose.connection.db.collection(oldName).rename(newName);
      const index = collectionNames.indexOf(oldName);
      if (index !== -1) {
        collectionNames[index] = newName;
      }
      res.sendStatus(200);
    } else {
      res.status(404).send("Collection not found");
    }
  } catch (error) {
    console.error("Error updating collection name:", error);
    res.status(500).send("Internal server error");
  }
});

app.delete("/deleteCollectionName", async (req, res) => {
  const collectionName = req.body.collectionName;

  try {
    const collections = await mongoose.connection.db.listCollections().toArray();
    const collectionExists = collections.some(collection => collection.name === collectionName);

    if (collectionExists) {
      await mongoose.connection.db.collection(collectionName).drop(); 
      const index = collectionNames.indexOf(collectionName);
      
      if (index !== -1) {
        collectionNames.splice(index, 1);
      }

      res.sendStatus(200);
    } else {
      res.status(404).send("Collection not found");
    }
  } catch (error) {
    console.error("Error deleting collection:", error);
    res.status(500).send("Internal server error");
  }
});

app.get('/data/:title', async (req, res) => {
  const title = req.params.title;
  try {
    const contentSchema = new mongoose.Schema({
      content: String,
      timestamp: {
        type: Date,
        default: Date.now,
      },
    });

    let ContentModel;
    try {
      ContentModel = mongoose.model(title);
    } catch (error) {
      ContentModel = mongoose.model(title, contentSchema);
    }

    const results = await ContentModel.find();

    if (results.length > 0) {
      const contentArray = results.map(result => result.content);
      res.json({ content: contentArray });
    } else {
      res.status(404).json({ error: 'Data not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

mongoose.connection.on('connected', () => {
  fetchCollectionNames().then(() => {
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  });
});