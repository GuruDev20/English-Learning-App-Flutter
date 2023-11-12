const mongoose = require('mongoose');
const express = require('express');
const app = express();
const UserModel = require('./models/User');
app.use(express.json());
mongoose.connect('mongodb://127.0.0.1:27017/English_Project_App');
app.post('/createUser', async (req, res) => {
  try {
    const data = new UserModel(req.body);
    await data.save();
    res.status(200).send(data);
  } catch (error) {
    res.status(400).send(error);
  }
});

app.get('/getuser', async (req, res) => {
  try {
    const data = await UserModel.find({});
    res.status(200).send(data);
  } catch (error) {
    res.status(500).send(error);
  }
});

app.post('/createContent', async (req, res) => {
  try {
    const title = req.body.title;
    const content = req.body.content;
    const collectionName = title;
    const contentSchema = new mongoose.Schema({
      title: String,
      content: String,
    });
    const Content = mongoose.model(collectionName, contentSchema);
    const newContent = new Content({ title, content });
    await newContent.save();
    res.status(200).send('Content created successfully.');
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

app.listen(3000, () => {
  console.log(`Server is running on port 3000`);
});
